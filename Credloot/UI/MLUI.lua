--Masterlooter UI

---@type CL
local _, CL = ...;
local DB = CL.DB; ---@type DB

local AceGUI = LibStub("AceGUI-3.0")

ScrollingTable = ScrollingTable or LibStub("ScrollingTable");

CharacterAwardWishlistItemTable = {}
PlayerNameBox = {}
MasterLooterUI = {
    ItemBoxHoldsValidItem = false,
    PlayersTable = {},
    Defaults = {
        itemIcon = "Interface\\Icons\\INV_Misc_QuestionMark",
        itemBoxText = "",
    },
};


--Slash command for å åpne vinduet
SLASH_CREDLOOT1 = "/cl";
SLASH_CREDLOOT2 = "/clo";
SlashCmdList.CREDLOOT = function() MainUI() end

function MainUI()
CL.Interface:setItem(self, "Window", Window);
--Lager vinduet
local Window = CL.Interface:getItem(self, "Window");
if (Window) then
    --[[if (itemLink) then
        MasterLooterUI:passItemLink(itemLink);
    end]]
    print("it exists")
    -- If the frame is hidden we need to show it again
    if (not Window:IsShown()) then
        Window:Show();
    end
    return;
end
local Window = AceGUI:Create("Frame")
Window:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
Window:SetTitle("Credendum Loot")
Window:SetLayout("Flow")
Window:SetWidth(450);
Window:SetHeight(450);
--Window:SetBackdropColor(0, 0, 0, 1)
Window:EnableResize(false);
Window.frame:SetFrameStrata("HIGH");
Window.statustext:GetParent():Hide(); -- Hide the statustext bar
--CL.Interface:setItem(self, "Window", Window); --Sets the window into the interfacelist of drawn windows
--CL.Interface:restorePosition(Window, "MasterLooterUI");

    --First Row (Item link)
    local FirstRow = AceGUI:Create("SimpleGroup");
    FirstRow:SetLayout("Flow");
    FirstRow:SetFullWidth(true);
    FirstRow:SetHeight(30);
    Window:AddChild(FirstRow);

        --Item Icon
        local ItemIcon = AceGUI:Create("Icon");
        ItemIcon:SetImage(MasterLooterUI.Defaults.itemIcon);
        ItemIcon:SetImageSize(30, 30);
        ItemIcon:SetWidth(40);
            ItemIcon:SetCallback("OnEnter", function()
                if (not MasterLooterUI.ItemBoxHoldsValidItem) then
                    return;
                end

                local itemLink = ItemBox:GetText();
                GameTooltip:SetOwner(ItemIcon.frame, "ANCHOR_TOP");
                GameTooltip:SetHyperlink(itemLink);
                GameTooltip:Show();
            end)

            ItemIcon:SetCallback("OnLeave", function() 
                if (not MasterLooterUI.ItemBoxHoldsValidItem) then
                ItemIcon:SetImage(MasterLooterUI.Defaults.itemIcon)
                end
                GameTooltip:Hide();
            end)    
        FirstRow:AddChild(ItemIcon);

        --Item Textbox
        ItemBox = AceGUI:Create("EditBox");
        ItemBox:DisableButton(true);
        ItemBox:SetDisabled(false)
        ItemBox:SetHeight(20);
        ItemBox:SetWidth(170);
            ItemBox:SetCallback("OnTextChanged", function (EditBox, _, itemLink)
                CharacterAwardWishlistItemTable:SetData({})
                currentItemId = select(3, strfind(itemLink, "item:(%d+)"))
                ItemIcon:SetImage(GetItemIcon(itemLink))

                if itemLink ~= nil then
                    MasterLooterUI.ItemBoxHoldsValidItem = true
                    populateWishlistByItem(currentItemId)
                    CLitemLink = itemLink
                else
                    MasterLooterUI.ItemBoxHoldsValidItem  = false
                    populateWishlistByItem(-1)
                end
            end); -- Update item info when input value changes
            ItemBox:HighlightText(1,1)
        FirstRow:AddChild(ItemBox);   

        --Create a Item button for testing
        local btnAward = AceGUI:Create("Button")
        btnAward:SetWidth(80)
        btnAward:SetText("Item")
        btnAward:SetCallback("OnClick", function() ItemBox:SetText("|cffa335ee|Hitem:39714::::::::1:::::::::|h[Webbed Death]|h|r") end)
        FirstRow:AddChild(btnAward)

        --Create a Award button
        local btnAward = AceGUI:Create("Button")
        btnAward:SetWidth(80)
        btnAward:SetText("Award")
        btnAward:SetCallback("OnClick", function() ActualAwardItem() end)
        FirstRow:AddChild(btnAward)

    --Second Row (player name box)
    local SecondRow = AceGUI:Create("SimpleGroup");
    SecondRow:SetLayout("Flow");
    SecondRow:SetFullWidth(true);
    SecondRow:SetHeight(24);
    Window:AddChild(SecondRow);
        
        local spacer = AceGUI:Create("SimpleGroup");
        spacer:SetLayout("Filler");
        spacer:SetFullWidth(true);
        spacer:SetHeight(20);
        SecondRow:AddChild(spacer)

        rewardPlayerNameLabel = AceGUI:Create("Label");
        --rewardPlayerNameLabel:SetLayout("Fill");
        rewardPlayerNameLabel:SetHeight(50);
        rewardPlayerNameLabel:SetWidth(400);
        rewardPlayerNameLabel:SetColor(0, 1, 0)
        rewardPlayerNameLabel:SetJustifyH("CENTER")
        rewardPlayerNameLabel:SetFontObject(_G["GameFontNormalLarge"]);
        SecondRow:AddChild(rewardPlayerNameLabel);

--Third Row (Scrolling Table)
local ThirdRow = AceGUI:Create("SimpleGroup");
ThirdRow:SetLayout("Flow");
ThirdRow:SetFullWidth(true);
ThirdRow:SetHeight(24);
Window:AddChild(ThirdRow);
    
    local spacer = AceGUI:Create("SimpleGroup");
    spacer:SetLayout("Filler");
    spacer:SetFullWidth(true);
    spacer:SetHeight(300);
    ThirdRow:AddChild(spacer)

    --Create a Import button
    local btnImport = AceGUI:Create("Button")
    btnImport:SetWidth(80)
    btnImport:SetPoint("BOTTOMLEFT", 10, 10);
    btnImport:SetText("Import")
    btnImport:SetCallback("OnClick", function() importUI() end)
    ThirdRow:AddChild(btnImport)

    --Create a Award button
    local btnAward = AceGUI:Create("Button")
    btnAward:SetWidth(80)
    btnAward:SetText("TEST")
    btnAward:SetCallback("OnClick", function() CL.DB.ReceivedItems = {} end)
    ThirdRow:AddChild(btnAward)

    createWishlistItemScrollingTable(Window)
    
end

function createWishlistItemScrollingTable(Window)
    -- Lager kolonner i ScrollingTable
    local columns = {
        --Player name
        {
            name = "Player",
            width = 100,
            align = "LEFT",
            color = {
                r = 0.5,
                g = 0.5,
                b = 1.0,
                a = 1.0
            },
            colorargs = nil,
        },
        --Standing APGP
        {
            name = "Standing",
            width = 65,
            align = "LEFT",
            color = {
                r = 0.5,
                g = 0.5,
                b = 1.0,
                a = 1.0
            },
            colorargs = nil,         
        },
        --Attendance siste 4 uker
        {
            name = "Attendance",
            width = 100,
            align = "LEFT",
            color = {
                r = 0.5,
                g = 0.5,
                b = 1.0,
                a = 1.0
            },
            colorargs = nil,
        },
        --Er Prio ITem
        {
            name = "Pinned",
            width = 65,
            align = "LEFT",
            color = {
                r = 0.5,
                g = 0.5,
                b = 1.0,
                a = 1.0
            },
            colorargs = nil,
        },
        --Sortering
        {
        name = "sort",
        width = 40,
        align = "LEFT",
        color = {
            r = 0.5,
            g = 0.5,
            b = 1.0,
            a = 1.0
        },
        colorargs = nil,
        sort = 2,
    },

    };
    
	CharacterAwardWishlistItemTable = ScrollingTable:CreateST(columns, 8, 15, nil, Window.frame);
    CharacterAwardWishlistItemTable:SetWidth(370);
    CharacterAwardWishlistItemTable:EnableSelection(true)
    CharacterAwardWishlistItemTable:SetSelection(realrow)
    CharacterAwardWishlistItemTable:RegisterEvents({
        ["OnClick"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, table, button, ...)
            --local CharacterName = data[row]["cols"][1]["value"]
            currentCharacterName = data[realrow]["cols"][1]["value"] -- realrow eller row (ved tull)
            local classInfo = UnitClass(currentCharacterName);
            local className = select(1, classInfo)
            
            question = string.format("Award %s to |cff%s%s|r?",
                CLitemLink,
                CL.Data.Constants.ClassHexColors[string.lower(className)],
                currentCharacterName)
            rewardPlayerNameLabel:SetText(question)
            rewardPlayerNameLabel:SetColor(0, 1, 0)

            --print(currentCharacterName)
        end})
	CharacterAwardWishlistItemTable.frame:SetPoint("BOTTOM", Window.frame, "BOTTOM", 0, 160);
	CharacterAwardWishlistItemTable:SortData()
    --CharacterAwardWishlistItemTable:Refresh()
end


function populateWishlistByItem(itemId)
    if (itemId == -1 or itemId == nil) then
        CharacterAwardWishlistItemTable:SetData({})
        rewardPlayerNameLabel:SetText("")
        return
    end

    local data = {}
    local i = 1;
    for k, characters in pairs(CL.DB.ImportedWishlist) do
        if (k == itemId) then
            for _, d in pairs(characters) do
                if (UnitInRaid(d.character)) then
                    getThisName = d.character
                    local classInfo = UnitClass(d.character);
                    local className = select(1, classInfo)
                    local c = CL:returnClassColors(string.lower(className or ""));                  
                    -- import the characters value from the DB table ImportedAPGP 
                    local apgp = CL.DB.ImportedAPGP[string.lower(d.character)][1]
                    -- concate attendance value with a "%"
                    local attendance = apgp.Attendance
                    attendance = tostring(ceil(tonumber(attendance) * 100) .. "%")
                    ShowPR()
                    -- format standing with two decimals 
                    local fscore = string.format("%.2f", apgp.Score)
                    -- check if priority is Yes/No and set color based on that. Y = Green, N = Red.
                    local isPrio = "N"
                    local isPrioColor = {r = 1, g = 0, b = 0, a = 1}
                    local prioSorting = fscore
                    if (d.isPrio) then
                        isPrio = "Y"
                        if (apgp.ReceivedPrioItemThisReset) then -- or priorecieved "har man fått på reset eller iløpet av raidet? hvis ja, tekst rød"
                            isPrioColor = {r = 1, g = 0, b = 0, a = 1}
                        else -- har ikke fått item denne reset eller i raidet, sjekk om spiller har attendance over eller under 0.75
                            --spiller har attendance under 0.75, Y skal derfor være rød
                            if (tonumber(apgp.Attendance)) < 0.75 then 
                                isPrioColor = {r = 1, g = 0, b = 0, a = 1}
                            --spiller har ikke fått items og har attendance over 0.75 sett farge grønn og gi +1000 
                            else 
                                isPrioColor = {r = 0, g = 1, b = 0, a = 1}
                                prioSorting = prioSorting + 1000  
                            end                        
                        end                                                 
                    end
                    -- insert our tabeldata into the scrollingtable 
                    tinsert(data, i, {
                        cols = {
                            {
                                value = CL:capitalize(d.character),
                                color = c
                            }, -- Namelist
                            {
                                value = fscore,
                                color = c
                            }, -- Standing
                            {
                                value = attendance,
                                color = c
                            }, -- Attendance
                            {
                                value = isPrio,
                                color = isPrioColor
                            }, -- Pinned Item
                            {
                                value = prioSorting,
                                color = isPrioColor
                            }, -- Pinned Item
                        },
                    })
                    i = i + 1
                end
            end
        end
    end
    CharacterAwardWishlistItemTable:SetData(data)
end
--[[function CL.Ace:ContainerFrameItemButton_OnModifiedClick(...)
	if select(2, ...) == "LeftButton" and IsAltKeyDown() and not CursorHasItem() then
		MainUI()
        -- Hvis tooltip er synlig, hent tooltip fra item man holder over.
        if GameTooltip:IsShown() then
            local _, itemLink = GameTooltip:GetItem()
            if itemLink then
              --  itemID = GetItemInfoFromHyperlink(itemLink) #Hvis man vil ha itemId fra tooltip
                ItemBox:SetText(itemLink)
                
            
            end
        end    
        
        
	end
end]]