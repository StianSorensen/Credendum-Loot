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
SlashCmdList.CREDLOOT = function()

--Lager vinduet
local Window = AceGUI:Create("Frame")
Window:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
Window:SetTitle("Credendum Loot")
Window:SetLayout("Flow")
Window:SetWidth(600);
Window:SetHeight(450);
Window:EnableResize(false);
Window.frame:SetFrameStrata("HIGH");
Window.statustext:GetParent():Hide(); -- Hide the statustext bar

    --First Row (Item link)
    local FirstRow = AceGUI:Create("SimpleGroup");
    FirstRow:SetLayout("Flow");
    FirstRow:SetFullWidth(true);
    FirstRow:SetHeight(30);
    Window:AddChild(FirstRow);

    --First Row (Item link)
    local ImportRow = AceGUI:Create("SimpleGroup");
    ImportRow:SetLayout("Flow");
    ImportRow:SetFullWidth(true);
    ImportRow:SetHeight(30);
    Window:AddChild(ImportRow);

    --Item Icon
    local ItemIcon = AceGUI:Create("Icon");
    ItemIcon:SetImage(MasterLooterUI.Defaults.itemIcon);
    ItemIcon:SetImageSize(30, 30);
    ItemIcon:SetWidth(40);
    FirstRow:AddChild(ItemIcon);

    --Item Textbox
    local ItemBox = AceGUI:Create("EditBox");
    ItemBox:DisableButton(true);
    ItemBox:SetHeight(20);
    ItemBox:SetWidth(170);
    ItemBox:SetCallback("OnTextChanged", function (EditBox, _, itemLink)
        local itemId = select(3, strfind(itemLink, "item:(%d+)"))
        ItemIcon:SetImage(GetItemIcon(itemLink))

        if itemLink ~= nil then
            MasterLooterUI.ItemBoxHoldsValidItem = true
            populateWishlistByItem(itemId)
        else
            MasterLooterUI.ItemBoxHoldsValidItem  = false
            populateWishlistByItem(-1)
        end
    end); -- Update item info when input value changes
    FirstRow:AddChild(ItemBox);

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

    --Button Padder
    local ButtonPadder = AceGUI:Create("SimpleGroup");
    ButtonPadder:SetLayout("Flow");
    ButtonPadder:SetWidth(14);
    ButtonPadder:SetHeight(30);
    FirstRow:AddChild(ButtonPadder);

    --Create a Award button
    local btnAward = AceGUI:Create("Button")
    btnAward:SetWidth(80)
    btnAward:SetText("Award")
    btnAward:SetCallback("OnClick", function() AwardItem() end)
    FirstRow:AddChild(btnAward)

    --Create a Roll button
    local btnPIroll = AceGUI:Create("Button")
    btnPIroll:SetWidth(80)
    btnPIroll:SetText("Roll")
    btnPIroll:SetCallback("OnClick", function() ShowPR() end)
    FirstRow:AddChild(btnPIroll)

    --Create a import-button
    local btnImportWishlistWindow = AceGUI:Create("Button")
    btnImportWishlistWindow:SetWidth(180)
    btnImportWishlistWindow:SetText("Import Wishlist")
    btnImportWishlistWindow:SetCallback("OnClick", function() ImportWishlist() end)
    ImportRow:AddChild(btnImportWishlistWindow)

    local btnImportAPGPWindow = AceGUI:Create("Button")
    btnImportAPGPWindow:SetWidth(180)
    btnImportAPGPWindow:SetText("Import APGP")
    btnImportAPGPWindow:SetCallback("OnClick", function() ImportAPGP() end)
    ImportRow:AddChild(btnImportAPGPWindow)

    --Second Row (player name box)
    local SecondRow = AceGUI:Create("SimpleGroup");
    SecondRow:SetLayout("Flow");
    SecondRow:SetFullWidth(true);
    SecondRow:SetHeight(24);
    Window:AddChild(SecondRow);

    Spacer = AceGUI:Create("SimpleGroup");
    Spacer:SetLayout("Fill");
    Spacer:SetWidth(4);
    Spacer:SetHeight(20);
    SecondRow:AddChild(Spacer);

    local PlayerNameLabel = AceGUI:Create("Label");
    PlayerNameLabel:SetText("Select player below");
    PlayerNameLabel:SetHeight(20);
    PlayerNameLabel:SetWidth(128); -- Minimum is 122
    SecondRow:AddChild(PlayerNameLabel);

    PlayerNameBox = AceGUI:Create("EditBox");
    PlayerNameBox:SetHeight(20);
    PlayerNameBox:SetWidth(120);
    PlayerNameBox:SetMaxLetters(128)
    PlayerNameBox:SetDisabled(true)
    SecondRow:AddChild(PlayerNameBox);
--end

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
            sort = 2,
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
            name = "Prio",
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

    };

	CharacterAwardWishlistItemTable = ScrollingTable:CreateST(columns, 8, 15, nil, Window.frame);
    CharacterAwardWishlistItemTable:SetWidth(810);
    CharacterAwardWishlistItemTable:EnableSelection(true)
    CharacterAwardWishlistItemTable:RegisterEvents({
        ["OnClick"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, table, button, ...)
            local characterName = data[row]["cols"][1]["value"]
            -- PlayerNameBox.SetText("Test")
        end
    })
	CharacterAwardWishlistItemTable.frame:SetPoint("BOTTOM", Window.frame, "BOTTOM", 0, 50);
	-- CharacterAwardWishlistItemTable:SetData(ldataset)
	CharacterAwardWishlistItemTable:SortData()
	-- CharacterAwardWishlistItemTable:SetDisplayRows(2, 15) endrer hvor mange Rows som er synlig
	-- CharacterAwardWishlistItemTable:Show()
	-- CharacterAwardWishlistItemTable:EnableSelection(true)
end


function populateWishlistByItem(itemId)
    if (itemId == -1 or itemId == nil) then
        CharacterAwardWishlistItemTable:SetData({})
        return
    end

    local data = {}
    local i = 1;
    for k, characters in pairs(CL.DB.ImportedWishlist) do
        if (k == itemId) then
            for _, d in pairs(characters) do
                if (UnitInRaid(d.character)) then
                    local classInfo = UnitClass(d.character);
                    local className = select(1, classInfo)

                    local c = CL:returnClassColors(string.lower(className or ""));
                    local isPrio = "N"
                    local isPrioColor = {r = 1, g = 0, b = 0, a = 1}
                    if (d.isPrio) then
                        isPrio = "Y"
                        isPrioColor = {r = 0, g = 1, b = 0, a = 1}
                    end

                    local apgp = CL.DB.ImportedAPGP[string.lower(d.character)]
                    print(apgp)
                    CL:dump(CredlootDB.ImportedAPGP[string.lower(d.character)])
                    tinsert(data, i, {
                        cols = {
                            {
                                value = CL:capitalize(d.character),
                                color = c
                            }, -- Namelist
                            {
                                value = apgp.Score,
                                color = c
                            }, -- Standing
                            {
                                value = apgp.Attendance,
                                color = c
                            }, -- Attendance
                            {
                                value = isPrio,
                                color = isPrioColor
                            }, -- +1
                        },
                    })
                    i = i + 1
                end
            end
        end
    end
    CharacterAwardWishlistItemTable:SetData(data)
end
