SLASH_RELOAD1 = "/rl"; -- for quicker reloading
SlashCmdList.RELOAD = ReloadUI;

 
local AceGUI = LibStub("AceGUI-3.0")

--[[function Cred:OnInitialize()
  self:RegisterChatCommand("cred", "ChatCommand")
end


local frameShown = false]]--


--Create a container frame

local f = AceGUI:Create("Frame")
f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
f:SetTitle("Credendum Loot")
f:SetLayout("Flow")


       -- SECOND ROW (Item link)
 

local FirstRow = AceGUI:Create("SimpleGroup");
        FirstRow:SetLayout("Flow");
        FirstRow:SetFullWidth(true);
        FirstRow:SetHeight(30);
        f:AddChild(FirstRow);

                --[[
                    ITEM ICON
                ]]

				local ItemIcon = AceGUI:Create("Icon");
                ItemIcon:SetImage("Interface\\Icons\\INV_Misc_QuestionMark");
                ItemIcon:SetImageSize(30, 30);
                ItemIcon:SetWidth(40);
                FirstRow:AddChild(ItemIcon);
                 
				 --[[
                    ITEM TEXTBOX
                ]]
                local ItemBox = AceGUI:Create("EditBox");

                ItemBox:DisableButton(true);
                ItemBox:SetHeight(20);
                ItemBox:SetWidth(170);
                FirstRow:AddChild(ItemBox);
				
				--[[
                    BUTTON PADDER
                    CONTAINER FOR PADDING PURPOSES ONLY
                ]]

                local ButtonPadder = AceGUI:Create("SimpleGroup");
                ButtonPadder:SetLayout("Flow");
                ButtonPadder:SetWidth(14);
                ButtonPadder:SetHeight(30);
                FirstRow:AddChild(ButtonPadder);
				
				-- Create a Reward button
				local btnAward = AceGUI:Create("Button")
				btnAward:SetWidth(80)
				btnAward:SetText("Award")
				btnAward:SetCallback("OnClick", function() print("Award") end)
				FirstRow:AddChild(btnAward)
				
				-- Create a PI Roll button
				local btnPIroll = AceGUI:Create("Button")
				btnPIroll:SetWidth(80)
				btnPIroll:SetText("PI Roll")
				btnPIroll:SetCallback("OnClick", function() print("PI roll") end)
				FirstRow:AddChild(btnPIroll)

				-- Create a PI Roll button
				local btnMSOSroll = AceGUI:Create("Button")
				btnMSOSroll:SetWidth(80)
				btnMSOSroll:SetText("MS/OS")
				btnMSOSroll:SetCallback("OnClick", function() print("MS/OS") end)
				FirstRow:AddChild(btnMSOSroll)
               --[[
        SECOND ROW (player name box)
    ]]

    local SecondRow = AceGUI:Create("SimpleGroup");
    SecondRow:SetLayout("Flow");
    SecondRow:SetFullWidth(true);
    SecondRow:SetHeight(24);
    f:AddChild(SecondRow);

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
    --PlayerNameBox:SetCallback("OnEnterPressed", function ()
        -- Remove table selection because we're awarding from the player name field
        --local PlayersTable = GL.Interface:getItem(self, "Table.Players");

        --if (PlayersTable) then
        --    PlayersTable:ClearSelection();
        --end

        --AwardButton:Fire("OnClick");
    --end); -- Award
    SecondRow:AddChild(PlayerNameBox);
    --GL.Interface:setItem(self, "PlayerName", PlayerNameBox);
	
	 local ThirdRow = AceGUI:Create("SimpleGroup");
    ThirdRow:SetLayout("FILL");
    ThirdRow:SetFullWidth(true);
    ThirdRow:SetHeight(150);
    f:AddChild(ThirdRow);
	
	
	-----------------------------------------------------------------------------
	
	
	