---@type CL
local _, CL = ...;

CL.RollOff = CL.RollOff or {}; ---@type RollOff
CL.ScrollingTable = CL.ScrollingTable or LibStub("ScrollingTable");

---@todo Refactor to interface
---@class MasterLooterUI
CL.MasterLooterUI = {
    ItemBoxHoldsValidItem = false,
    PlayersTable = {},
    Defaults = {
        itemIcon = "Interface\\Icons\\INV_Misc_QuestionMark",
        itemBoxText = "",
    },
};

local AceGUI = LibStub("AceGUI-3.0")
local MasterLooterUI = CL.MasterLooterUI; ---@type MasterLooterUI
local ScrollingTable = CL.ScrollingTable;


function MasterLooterUI:draw(itemLink)
    CL:debug("MasterLooterUI:draw");
    

    --[[if (CL.User.isInGroup
        and not CL.User.isMasterLooter
        and not CL.User.hasAssist
    ) then
        return CL:warning("You need to be the master looter or have an assist / lead role!");
    end]]--

    -- Close the reopen masterlooter button if it exists
    --self:closeReopenMasterLooterUIButton();

    -- First we need to check if the frame hasn't been
    -- rendered already. If so then show it (if it's hidden)
    -- and pass the itemLink along in case one was provided
    local Window = CL.Interface:getItem(self, "Window");
    if (Window) then
        if (itemLink) then
            MasterLooterUI:passItemLink(itemLink);
            populateWishlistByItem(itemLink);
            --stealItemLink = itemLink
            --print(stealItemLink)
        end

        -- If the frame is hidden we need to show it again
        if (not Window:IsShown()) then
            Window:Show();
            --CL.Interface.AwardHistory:draw(Window);
        end

        return;
    end

    local HorizonalSpacer, VerticalSpacer;

    -- Create a container/parent frame
    Window = AceGUI:Create("Frame", "CREDENDUM_MASTERLOOTERUI_WINDOW");
    Window:SetTitle("Credendum Loot");
    Window:SetLayout("Flow");
    Window:SetWidth(450);
    Window:SetHeight(450);
    Window:EnableResize(false);
    Window.frame:SetFrameStrata("HIGH");
    Window.statustext:GetParent():Hide(); -- Hide the statustext bar
    Window:SetCallback("OnClose", function(widget)
        self:close();
    end);
    CL.Interface:setItem(self, "Window", Window);

    --Window:SetPoint(CL.Interface:getPosition("RollOff"));


       
        --FIRST ROW (ITEM ICON AND LINK BOX)
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
            FirstRow:AddChild(ItemIcon);
            CL.Interface:setItem(self, "Item", ItemIcon);

            --Item Box
            local ItemBox = AceGUI:Create("EditBox");
            ItemBox:DisableButton(true);
            ItemBox:SetHeight(20);
            ItemBox:SetWidth(170);
            ItemBox:SetCallback("OnTextChanged", function () MasterLooterUI:ItemBoxChanged() end); -- Update item info when input value changes
            ItemBox:SetCallback("OnEnterPressed", function () MasterLooterUI:ItemBoxChanged() end); -- Update item info when item is dragged on top (makes no sense to use OnEnterPressed I know)

            CL.Interface:setItem(self, "Item", ItemBox);

            FirstRow:AddChild(ItemBox);

            -- Show a gametooltip if the icon shown belongs to an item
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
                GameTooltip:Hide();
            end)                

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
        btnAward:SetCallback("OnClick", function() populateWishlistByItem(itemLink) end)
        ThirdRow:AddChild(btnAward)


    MasterLooterUI:drawPlayersTable(Window.frame);
    populateWishlistByItem(itemLink)

    if (itemLink
        and type(itemLink) == "string"
    ) then
        MasterLooterUI:passItemLink(itemLink);
    end

    --CL.Interface.AwardHistory:draw(Window);
end

---@return void
function MasterLooterUI:close()
    CL:debug("MasterLooterUI:close");

    -- When the master looter closes the master loot window with a master
    -- loot still in progress we show the reopen master looter button
    if (CL.RollOff.inProgress) then
        self:drawReopenMasterLooterUIButton();
    end

    local Window = CL.Interface:getItem(self, "Window");
    if (Window) then
        -- Store the frame's last position for future play sessions
        --CL.Interface:storePosition(Window, "RollOff");
        Window:Hide();
    end
end

function MasterLooterUI:drawPlayersTable(parent)
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
    
	CharacterAwardWishlistItemTable = ScrollingTable:CreateST(columns, 8, 15, nil, parent);
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
                tostring(gItemLink),
                CL.Data.Constants.ClassHexColors[string.lower(className)],
                currentCharacterName)
            rewardPlayerNameLabel:SetText(question)
            rewardPlayerNameLabel:SetColor(0, 1, 0)

            --print(currentCharacterName)
        end})
	CharacterAwardWishlistItemTable.frame:SetPoint("BOTTOM", parent, "BOTTOM", 0, 160);
	CharacterAwardWishlistItemTable:SortData()
    CharacterAwardWishlistItemTable:Refresh()
end


function populateWishlistByItem(linkitem)
    currentItemId = CL:getItemIdFromLink(linkitem)
    gItemLink = linkitem
    print("ItemId"..currentItemId)
    if (currentItemId == -1 or currentItemId == nil) then
        print("hva fean")
        --CharacterAwardWishlistItemTable:SetData({})
        --rewardPlayerNameLabel:SetText("")
        return
    end

    local data = {}
    local i = 1;
    for k, characters in pairs(CL.DB.ImportedWishlist) do
        if (k == tostring(currentItemId)) then
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
    print("hei")
end

-- The item box contents changed
function MasterLooterUI:ItemBoxChanged()
    CL:debug("MasterLooterUI:ItemBoxChanged");

    itemLink = CL.Interface:getItem(self, "EditBox.Item"):GetText();

    MasterLooterUI:passItemLink(itemLink);
end

-- Pass an item link to the master looter UI
-- This method is used when alt clicking an item
-- in a loot window or when executing /gl roll [itemlink]
function MasterLooterUI:passItemLink(itemLink)
    CL:debug("MasterLooterUI:passItemLink");

    if (not CL.Interface:getItem(self, "Window")) then
        return;
    end

    if (CL.RollOff.inProgress) then
        return CL:warning("A roll is currently in progress");
    end

    CL.Interface:getItem(self, "EditBox.Item"):SetText(itemLink);
    return MasterLooterUI:update();
end

-- Update the master looter UI based on the value of the ItemBox input
function MasterLooterUI:update()
    CL:debug("MasterLooterUI:update");

    local IconWidget = CL.Interface:getItem(self, "Icon.Item");
    local itemLink = CL.Interface:getItem(self, "EditBox.Item"):GetText();

    -- If the item link is not valid then
    --   Show the default question mark icon
    --   Remove the item priority string
    if (not itemLink or itemLink == "") then
        CL:debug("MasterLooterUI:update. Item link is invalid");

        MasterLooterUI.ItemBoxHoldsValidItem = false;
        IconWidget:SetImage(MasterLooterUI.Defaults.itemIcon);

      
      
        return;
    end

    -- The item's icon is in the 10th position
    local icon = select(10, GetItemInfo(itemLink));

    if (icon) then
        --CL.Interface:getItem(self, "Table.Players"):ClearSelection();

        IconWidget:SetImage(icon);
        MasterLooterUI.ItemBoxHoldsValidItem = true;
    else
        MasterLooterUI.ItemBoxHoldsValidItem = false;
        IconWidget:SetImage(MasterLooterUI.Defaults.itemIcon);
    end

end


-- Reset the roll off UI to its defaults
function MasterLooterUI:reset(keepItem)
    CL:debug("MasterLooterUI:reset");

    keepItem = CL:toboolean(keepItem);

    if (not keepItem) then
        CL.Interface:getItem(self, "Icon.Item"):SetImage(MasterLooterUI.Defaults.itemIcon);
        CL.Interface:getItem(self, "EditBox.Item"):SetText(MasterLooterUI.Defaults.itemText);
    
        MasterLooterUI.ItemBoxHoldsValidItem = false;
    end

    CL.Interface:getItem(self, "Table.Players"):ClearSelection();
    CL.Interface:getItem(self, "Table.Players"):ClearSelection();
    CL.Interface:getItem(self, "Table.Players"):SetData({}, true);

end




