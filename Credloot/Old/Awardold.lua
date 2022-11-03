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
