---@type CL
local _, CL = ...;

local AceGUI = LibStub("AceGUI-3.0")
local DB = CL.DB; ---@type DB

function AwardItem()
    local AwardWindow = AceGUI:Create("Frame")
    AwardWindow:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
    AwardWindow:SetTitle("Award Item")
    AwardWindow:SetLayout("Flow")
    AwardWindow:SetWidth(400);
    AwardWindow:SetHeight(250);
    AwardWindow:EnableResize(false);
    AwardWindow.frame:SetFrameStrata("HIGH");
    AwardWindow.statustext:GetParent():Hide(); -- Hide the statustext bar

    --First Row (Checkbox)
		local FirstRow = AceGUI:Create("SimpleGroup");
        FirstRow:SetLayout("Flow");
        FirstRow:SetFullWidth(true);
        FirstRow:SetHeight(30);
        AwardWindow:AddChild(FirstRow);


    -- Plus one checkbox
    local PlusOneCheckBox = AceGUI:Create("CheckBox");
    PlusOneCheckBox:SetLabel("");
    PlusOneCheckBox:SetDescription("");
    PlusOneCheckBox:SetHeight(20);
    PlusOneCheckBox:SetWidth(24);
    FirstRow:AddChild(PlusOneCheckBox);

    -- Plus one label
    local PlusOneLabel = AceGUI:Create("InteractiveLabel");
    PlusOneLabel:SetFontObject(_G["GameFontNormal"]);
    PlusOneLabel:SetWidth(100);
    PlusOneLabel:SetText("Add a +1");

    PlusOneLabel:SetCallback("OnClick", function()
        PlusOneCheckBox:ToggleChecked();
    end);

    FirstRow:AddChild(PlusOneLabel);

    -- Plus one checkbox
    local OffSpecCheckBox = AceGUI:Create("CheckBox");
    OffSpecCheckBox:SetLabel("");
    OffSpecCheckBox:SetDescription("");
    OffSpecCheckBox:SetHeight(20);
    OffSpecCheckBox:SetWidth(24);
    FirstRow:AddChild(OffSpecCheckBox);

    -- Plus one label
    local OffSpecLabel = AceGUI:Create("InteractiveLabel");
    OffSpecLabel:SetFontObject(_G["GameFontNormal"]);
    OffSpecLabel:SetWidth(30);
    OffSpecLabel:SetText("OS");

    OffSpecLabel:SetCallback("OnClick", function()
        OffSpecCheckBox:ToggleChecked();
    end);

    FirstRow:AddChild(OffSpecLabel);

    --Create a Award button
    local btnAwardItem = AceGUI:Create("Button")
    btnAwardItem:SetWidth(80)
    btnAwardItem:SetText("Award")
    btnAwardItem:SetCallback("OnClick", function() ActualAwardItem() end)
    FirstRow:AddChild(btnAwardItem)

        --Second Row (player name box)
    local SecondRow = AceGUI:Create("SimpleGroup");
    SecondRow:SetLayout("Flow");
    SecondRow:SetFullWidth(true);
    SecondRow:SetHeight(24);
    AwardWindow:AddChild(SecondRow);

        Spacer = AceGUI:Create("SimpleGroup");
        Spacer:SetLayout("Fill");
        Spacer:SetWidth(4);
        Spacer:SetHeight(20);
        SecondRow:AddChild(Spacer);


    local PlayerNameReward = AceGUI:Create("Label");
    PlayerNameReward:SetText(PlayerNameRew);
    PlayerNameReward:SetHeight(20);
    PlayerNameReward:SetWidth(128); -- Minimum is 122
    SecondRow:AddChild(PlayerNameReward);



	--Verdier som kommer i ScrollingTable
	ldataset = {}
	function insertDataInTable(table)
		local counter = 1
        local color = ""
		for k, name in pairs(table) do
            color = CL:returnClassColors(table[counter][2])
            tinsert(ldataset, counter, {
                cols = {
                    {
                        value = table[counter][1],
                        color = color
                        }, -- Namelist
                    {
                        value = table[counter][3],
                        color = color
                        }, -- Standing
                    {
                        value = table[counter][4],
                        color = color
                        }, -- Attendance
                    {
                        value = table[counter][5],
                        color = color
                        }, -- +1
                    {
                        value = table[counter][6],
                        color = color
                        }, -- sort

                    },
                })
                counter = counter+1
		end
	end
    insertDataInTable(finalTable)

end
function AwardItem()
    
    --Lager Award vindu n??r du trykker p?? Award knappen i MLUI
    local AwardWindow = AceGUI:Create("Frame")
    AwardWindow:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
    AwardWindow:SetTitle("Award Item")
    AwardWindow:SetLayout("Flow")
    AwardWindow:SetWidth(290);
    AwardWindow:SetHeight(250);
    AwardWindow:EnableResize(false);
    AwardWindow.frame:SetFrameStrata("HIGH");
    AwardWindow.statustext:GetParent():Hide(); -- Hide the statustext bar

    --First Row (Checkbox)
    local FirstRow = AceGUI:Create("SimpleGroup");
    FirstRow:SetLayout("Flow");
    FirstRow:SetFullWidth(true);
    FirstRow:SetHeight(30);
    AwardWindow:AddChild(FirstRow);

        -- Wishlist checkbox
    local WishlistCheckBox = AceGUI:Create("CheckBox");
    WishlistCheckBox:SetLabel("");
    WishlistCheckBox:SetDescription("");
    WishlistCheckBox:SetHeight(20);
    WishlistCheckBox:SetWidth(24);
    FirstRow:AddChild(WishlistCheckBox);
    
    -- Wishlist label
    local WishlistLabel = AceGUI:Create("InteractiveLabel");
    WishlistLabel:SetFontObject(_G["GameFontNormal"]);
    WishlistLabel:SetWidth(60);
    WishlistLabel:SetText("Wishlist");

    WishlistLabel:SetCallback("OnClick", function()
        WishlistCheckBox:ToggleChecked();
    end);

    FirstRow:AddChild(WishlistLabel);

    -- Prio Item checkbox
    local PrioItemBox = AceGUI:Create("CheckBox");
    PrioItemBox:SetLabel("");
    PrioItemBox:SetDescription("");
    PrioItemBox:SetHeight(20);
    PrioItemBox:SetWidth(24);
    FirstRow:AddChild(PrioItemBox);
    
    -- Prio Item label
    local PrioItemLabel = AceGUI:Create("InteractiveLabel");
    PrioItemLabel:SetFontObject(_G["GameFontNormal"]);
    PrioItemLabel:SetWidth(60);
    PrioItemLabel:SetText("Prio Item");

    PrioItemLabel:SetCallback("OnClick", function()
        PrioItemBox:ToggleChecked();
    end);

    FirstRow:AddChild(PrioItemLabel);

    -- Plus one checkbox
    local MsOsCheckBox = AceGUI:Create("CheckBox");
    MsOsCheckBox:SetLabel("");
    MsOsCheckBox:SetDescription("");
    MsOsCheckBox:SetHeight(20);
    MsOsCheckBox:SetWidth(24);
    FirstRow:AddChild(MsOsCheckBox);
    
    -- Plus one label
    local MsOsLabel = AceGUI:Create("InteractiveLabel");
    MsOsLabel:SetFontObject(_G["GameFontNormal"]);
    MsOsLabel:SetWidth(60);
    MsOsLabel:SetText("MS/OS");

    MsOsLabel:SetCallback("OnClick", function()
        MsOsCheckBox:ToggleChecked();
    end);

    FirstRow:AddChild(MsOsLabel);
    
	 --Second Row (Hvilket item som skal til hvilke person)
    local SecondRow = AceGUI:Create("SimpleGroup");
    SecondRow:SetLayout("Flow");
    SecondRow:SetFullWidth(true);
    SecondRow:SetHeight(20);
    AwardWindow:AddChild(SecondRow);
   
    local ItemNameReward = AceGUI:Create("Label");
    ItemNameReward:SetText(awardMessage);
    ItemNameReward:SetFont(_, 20, _)
    ItemNameReward:SetHeight(40);
    ItemNameReward:SetFullWidth(true); -- Minimum is 122
    SecondRow:AddChild(ItemNameReward);
    
    Spacer = AceGUI:Create("SimpleGroup");
    Spacer:SetLayout("Fill");
    Spacer:SetFullWidth(true);
    Spacer:SetHeight(100);
    SecondRow:AddChild(Spacer);

    local ThirdRow = AceGUI:Create("SimpleGroup");
    SecondRow:SetLayout("Flow");
    SecondRow:SetFullWidth(true);
    SecondRow:SetHeight(200);
    AwardWindow:AddChild(ThirdRow);
    
    --Create a Yes button
    local btnAwardItem = AceGUI:Create("Button")
    btnAwardItem:SetWidth(80)
    btnAwardItem:SetText("Yes")
    btnAwardItem:SetCallback("OnClick", function() ActualAwardItem() end)
    ThirdRow:AddChild(btnAwardItem)
    
end
