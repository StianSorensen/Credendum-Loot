--Masterlooter UI


local AceGUI = LibStub("AceGUI-3.0")

ScrollingTable = ScrollingTable or LibStub("ScrollingTable");

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

--Window:Hide()

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
						WLitemId =  select(3, strfind(itemLink, "item:(%d+)"))
						ItemIcon:SetImage(GetItemIcon(itemLink))
						if itemLink ~= nil then
							MasterLooterUI.ItemBoxHoldsValidItem = true else 
							MasterLooterUI.ItemBoxHoldsValidItem  = false 
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
				btnAward:SetCallback("OnClick", function() print("Award") AwardItem() end)
				FirstRow:AddChild(btnAward)
				
				--Create a PI Roll button
				local btnPIroll = AceGUI:Create("Button")
				btnPIroll:SetWidth(80)
				btnPIroll:SetText("PI Roll")
				btnPIroll:SetCallback("OnClick", function() ShowWL2() end)
				FirstRow:AddChild(btnPIroll)

				--Create a PI Roll button
				local btnMSOSroll = AceGUI:Create("Button")
				btnMSOSroll:SetWidth(80)
				btnMSOSroll:SetText("Raidet")
				btnMSOSroll:SetCallback("OnClick", function() ShowStanding() end)
				FirstRow:AddChild(btnMSOSroll)
             
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
			PlayerNameBox:SetCallback("OnTextChanged", function () 
            PlayerNameRew = PlayerNameBox:GetText() end)
			SecondRow:AddChild(PlayerNameBox);

		local ThirdRow = AceGUI:Create("SimpleGroup");
		ThirdRow:SetLayout("FILL"); --"FILL"
		ThirdRow:SetFullWidth(true);
		ThirdRow:SetHeight(50);
		Window:AddChild(ThirdRow);	

		local FourthRow = AceGUI:Create("SimpleGroup");
        FourthRow:SetLayout("Flow");
        FourthRow:SetFullWidth(true);
        FourthRow:SetHeight(150);
        Window:AddChild(FourthRow);
--end


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
        --Om du har fått Prio Item denne uka
        {
            name = "+1 PI",
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
        --Om item er Prio for sortering
        {
            name = "",
            width = 150,
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

	function returnClassColors(class)
        if class == "druid" then
            return {r = 1, g = .48627, b = .0392, a = 1}
        elseif class == "hunter" then
            return {r = .6666, g = .827450, b = .44705, a = 1}
        elseif class == "mage" then
            return {r = .4078, g = .8, b = .93725, a = 1}
        elseif class == "paladin" then
            return {r = .95686, g = .5490, b = .72941, a = 1}
        elseif class == "priest" then
            return {r = 1, g = 1, b = 1, a = 1}
        elseif class == "rogue" then
            return {r = 1, g = .95686, b = .40784, a = 1}
        elseif class == "shaman" then
            return {r = 0, g = .44, b = .87, a = 1}
        elseif class == "warlock" then
            return {r = .57647, g = .5098, b = .788235, a = 1}
        elseif class == "warrior" then
            return {r = .77647, g = .607843, b = .42745, a = 1}
        elseif class == "death knight" then 
            return {r = .77, g = .12, b = .23, a = 1}
        end
    end

	--Verdier som kommer i ScrollingTable
	ldataset = {}
	function insertDataInTable(table)
		local counter = 1
		for k, name in pairs(table) do
		tinsert(ldataset, counter, {
			cols = {
				{
					value = table[counter][1], 
					color = returnClassColors(table[counter][2])
					}, -- Namelist
				{
					value = table[counter][3],
					color = returnClassColors(table[counter][2])
					}, -- Standing
				{
					value = table[counter][4],
					color = returnClassColors(table[counter][2])
					}, -- Attendance
				{
					value = table[counter][5],
					color = returnClassColors(table[counter][2])
					}, -- +1
				{
					value = table[counter][6],
					color = returnClassColors(table[counter][2])
					}, -- sort
						
				},
			})
			counter = counter+1
		end
	end
insertDataInTable(finalTable)
	
		
			

	local Table = ScrollingTable:CreateST(columns, 8, 15, nil, Window.frame);
    Table:SetWidth(510);
    Table:EnableSelection(true)
	Table.frame:SetPoint("BOTTOM", Window.frame, "BOTTOM", 0, 50);
	Table:SetData(ldataset)
	Table:SortData()
	--Table:SetDisplayRows(2, 15) endrer hvor mange Rows som er synlig
	--Table:Show()
	--Table:EnableSelection(true)

end

-- navn, class, priority raiting (pr), attendance, priority, +1 
--[[function makeFinalTable()
	tempFinalTable = {}
	tinsert(tempFinalTable, )
end]]

finalTable ={
    {   
        "Tallefjompen",
        "paladin", 
        0.35,
        "75%", 
        true, 
        false,
	},
    {
        "Mindlini",
        "priest",
        3.2,
        "100%",
        false,
        false,
    },
    {
        "Uitest",
        "rogue",
        2.2,
        "100%",
        true,
        true,
    },

}