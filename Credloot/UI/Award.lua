---@type CL
local _, CL = ...;

local AceGUI = LibStub("AceGUI-3.0")
local DB = CL.DB; ---@type DB

function ActualAwardItem() 
    table = {
        ["character"] = "Toa",
        ["itemId"] = "40332",
        ["priorecived"] = true,
        ["itemcost"] = 750,
        }
    
    DB:set("Reciveditem", table)
end
--[[---@param PlayerNameRew string
---@param ItemNameRew string
---@return void]]--
function AwardItem()
    


    --local ItemNameRew = tostring(ItemNameRew)
    local itemId = tostring(itemLink)
    local PlayerNameRew = PlayerNameRew
    awardMessage = string.format("Award %s to %s?", itemId, PlayerNameRew)

    --Lager Award vindu når du trykker på Award knappen i MLUI
    local AwardWindow = AceGUI:Create("Frame")
    AwardWindow:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
    AwardWindow:SetTitle("Award Item")
    AwardWindow:SetLayout("Flow")
    AwardWindow:SetWidth(290);
    AwardWindow:SetHeight(250);
    AwardWindow:EnableResize(false);
    AwardWindow.frame:SetFrameStrata("HIGH");
    AwardWindow.statustext:GetParent():Hide(); -- Hide the statustext bar
    
    --[[local VerticalSpacer = AceGUI:Create("SimpleGroup");
    Spacer:SetLayout("Fill");
    Spacer:SetFullWidth(true);
    Spacer:SetHeight(1);
    AwardWindow:AddChild(VerticalSpacer);]]--

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
    ItemNameReward:SetText(awardMessage) --("Award ".."[Worn Dagger]".." to ");
    ItemNameReward:SetFont(_, 20, _)
    ItemNameReward:SetHeight(40);
    ItemNameReward:SetFullWidth(true); -- Minimum is 122
    SecondRow:AddChild(ItemNameReward);

    --[[local PlayerNameReward = AceGUI:Create("Label");
    PlayerNameReward:SetText(PlayerNameRew);
    PlayerNameReward:SetHeight(20);
    PlayerNameReward:SetWidth(128); -- Minimum is 122
    SecondRow:AddChild(PlayerNameReward);]]--
    
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
