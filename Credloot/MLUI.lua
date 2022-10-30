--Masterlooter UI


local AceGUI = LibStub("AceGUI-3.0")


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
SlashCmdList.CREDLOOT = function(Vindu)

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
						local itemId =  select(3, strfind(itemLink, "item:(%d+)"))
						ItemIcon:SetImage(GetItemIcon(itemLink))
						if itemLink ~= nil then
							MasterLooterUI.ItemBoxHoldsValidItem = true else 
							MasterLooterUI.ItemBoxHoldsValidItem  = false end 
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
				
				--Create a Reward button
				local btnAward = AceGUI:Create("Button")
				btnAward:SetWidth(80)
				btnAward:SetText("Award")
				btnAward:SetCallback("OnClick", function() print("Award") AwardItem() end)
				FirstRow:AddChild(btnAward)
				
				--Create a PI Roll button
				local btnPIroll = AceGUI:Create("Button")
				btnPIroll:SetWidth(80)
				btnPIroll:SetText("PI Roll")
				btnPIroll:SetCallback("OnClick", function() print("PR") ShowPR() end)
				FirstRow:AddChild(btnPIroll)

				--Create a PI Roll button
				local btnMSOSroll = AceGUI:Create("Button")
				btnMSOSroll:SetWidth(80)
				btnMSOSroll:SetText("MS/OS")
				btnMSOSroll:SetCallback("OnClick", function() print("MS/OS") end)
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
			SecondRow:AddChild(PlayerNameBox);

		local ThirdRow = AceGUI:Create("SimpleGroup");
		ThirdRow:SetLayout("FILL");
		ThirdRow:SetFullWidth(true);
		ThirdRow:SetHeight(150);
		Window:AddChild(ThirdRow);	

		local FourthRow = AceGUI:Create("SimpleGroup");
        FourthRow:SetLayout("Flow");
        FourthRow:SetFullWidth(true);
        FourthRow:SetHeight(50);
        Window:AddChild(FourthRow);
end

function AwardItem()
    local AwardWindow = AceGUI:Create("Frame")
    AwardWindow:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
    AwardWindow:SetTitle("Award Loot")
    AwardWindow:SetLayout("Flow")
    AwardWindow:SetWidth(600);
    AwardWindow:SetHeight(450);
    AwardWindow:EnableResize(false);
    AwardWindow.frame:SetFrameStrata("HIGH");
    AwardWindow.statustext:GetParent():Hide(); -- Hide the statustext bar
end
