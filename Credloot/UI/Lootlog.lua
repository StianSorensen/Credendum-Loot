---@type GL
local _, GL = ...;

CL.ScrollingTable = CL.ScrollingTable or LibStub("ScrollingTable");

---@class AwardHistoryInterface
CL.UI.Lootlog = { -- endring CL.Interface.AwardHistory = {
    isVisible = false,
    eventListenersSet = false,
    RefreshTimer = nil,
    ChecksumsToShow = nil,
    PreviousAnchors = {},
    Window = nil,
};

---@type AwardHistoryInterface
local Lootlog = CL.UI.Lootlog; -- endring local AwardHistory = CL.Interface.AwardHistory;

--- Determine which checksums should be shown in the awardhistory window
---
---@return void
function Lootlog:populateChecksumsToShow() -- endring function AwardHistory:populateChecksumsToShow()
    self.ChecksumsToShow = {};
    local fiveHoursAgo = GetServerTime() - 18000;
    local loadItemsGTE = math.min(fiveHoursAgo, CL.loadedOn);

    for checksum, Entry in pairs(CL.DB.ReceivedItems) do -- endring for checksum, Entry in pairs(CL.DB.AwardHistory) do
        if (checksum and Entry.timestamp and Entry.timestamp >= loadItemsGTE) then
            tinsert(self.ChecksumsToShow, {checksum, Entry.timestamp});
        end
    end

    local sortChecksumsNewestToOldest = function ()
        table.sort(self.ChecksumsToShow, function (a, b)
            return a[2] > b[2];
        end);
    end;

    sortChecksumsNewestToOldest();

    -- endring VI HAR IKKE EVENTLISTENER ENDA
    --[[ if (not self.eventListenersSet) then
            self.eventListenersSet = true;

            CL.Events:register("AwardHistoryItemAwardedInstantListener", "CL.ITEM_AWARDED", function (_, Entry)
                if (not Entry.checksum or not Entry.timestamp) then
                    return;
                end

                tinsert(self.ChecksumsToShow, {Entry.checksum, Entry.timestamp});
                sortChecksumsNewestToOldest();
            end);
        end]]
end

--- Draw the award history window
---
---@param AnchorTo table|nil This is the AceGUI element the history should attach itself to
---@return void
function Lootlog:draw(AnchorTo) -- endring function AwardHistory:draw(AnchorTo)
    CL:debug("AwardHistory:draw");

    if (type(AnchorTo) ~= "table") then
        AnchorTo = nil;
    end

    if (AnchorTo) then
        if (self.isVisible) then
            self:reAnchor(AnchorTo);
            return;
        end

        -- Store this anchor in order to create an anchor "history"
        tinsert(self.PreviousAnchors, AnchorTo);
    end

    -- Cache the items we need to show first
    if (not self.ChecksumsToShow) then
        self:populateChecksumsToShow();
    end

    self.isVisible = true;

    local Window;
    local WindowWidth;

    if (AnchorTo) then
        WindowWidth = math.max(AnchorTo.frame:GetWidth(), 430);
        Window = CL.AceGUI:Create("InlineGroup");
        Window:SetHeight(140);

        Window.frame:ClearAllPoints();
        Window.frame:SetParent(AnchorTo.frame);
        Window.frame:SetPoint("TOP", AnchorTo.frame, "BOTTOM", 0, 12);
        Window.frame:SetPoint("CENTER", AnchorTo.frame, "CENTER");
        Window.frame.AnchoredTo = AnchorTo;
        Window.frame:SetAlpha(0);

        -- Remove the close button
        local CloseButton = CL:fetchCloseButtonFromAceGUIWidget(Window);
        if (CloseButton) then
            CloseButton:Hide();
        end

        -- Make the frame less transparent
        local Border = CL:fetchBorderFromAceGUIInlineGroup(Window);
        if (Border) then
            Border:SetBackdropColor(.1, .1, .1, .9);
        end

        -- We need to keep the default hide behavior intact, hence the post hook
        hooksecurefunc(AnchorTo.frame, "Hide", function()
            self:close();
        end);
    else
        -- Not in use yet! Use at own risk!
        --[[
            /script _G.Gargul.Interface.AwardHistory:draw();
        ]]
        WindowWidth = 430;
        Window = CL.AceGUI:Create("Frame");
        Window:SetTitle("Award History");
        Window:SetHeight(420);
    end

    Window:SetLayout("FILL");
    Window:SetWidth(WindowWidth);

    self.Window = Window;

    local ScrollFrameHolder = CL.AceGUI:Create("SimpleGroup");
    ScrollFrameHolder:SetLayout("FILL")
    ScrollFrameHolder:SetFullWidth(true);
    ScrollFrameHolder:SetFullHeight(true);
    Window:AddChild(ScrollFrameHolder);

    local ScrollFrame = CL.AceGUI:Create("ScrollFrame");
    ScrollFrame:SetLayout("Flow");
    ScrollFrameHolder:AddChild(ScrollFrame);

    local fiveHoursAgo = GetServerTime() - 18000;
    local loadItemsGTE = math.min(fiveHoursAgo, CL.loadedOn);
    local AwardedItemsToShow = {};
    local thereAreItemsToShow = false;

    for _, Entry in pairs(self.ChecksumsToShow) do
        local Loot = CL.DB.ReceivedItems[Entry[1]]; -- endring local Loot = CL.DB.AwardHistory[Entry[1]];

        -- This item should no longer be shown
        if (not Loot or not Loot.timestamp or Loot.timestamp < loadItemsGTE) then
            CL.DB.ReceivedItems[Entry[1]] = nil; -- endring CL.DB.AwardHistory[Entry[1]] = nil;
        else
            tinsert(AwardedItemsToShow, Loot);
            thereAreItemsToShow = true;
        end
    end

    if (thereAreItemsToShow) then
        Window.frame:SetAlpha(1);
    end

    --local itemLinkLabelWidth = math.max(160, 160 + (WindowWidth - 430));
    local itemLinkLabelWidth = math.max(150, 150 + (WindowWidth - 430));
    CL:onItemLoadDo(CL:tableColumn(AwardedItemsToShow, "itemID"), function()
        for _, Award in pairs(AwardedItemsToShow) do
            (function ()
                local ItemDetails = CL.DB.Cache.ItemsByID[tostring(Award.itemID)];

                -- Item was not found, better safe than lua error
                if (not ItemDetails) then
                    return;
                end

                local ItemRow = CL.AceGUI:Create("SimpleGroup");
                ItemRow:SetLayout("FLOW");
                ItemRow:SetFullWidth(true);
                ScrollFrame:AddChild(ItemRow);

                -- Show player details on hover
                local ItemsWonByRollerInTheLastFiveHours;
                ItemRow.frame:SetScript("OnEnter", function()
                    if (not ItemsWonByRollerInTheLastFiveHours) then
                        ItemsWonByRollerInTheLastFiveHours = CL.AwardedLoot:byWinner(Award.awardedTo, fiveHoursAgo);
                    end

                    if (not CL:empty(ItemsWonByRollerInTheLastFiveHours)) then
                        GameTooltip:ClearLines();
                        GameTooltip:SetOwner(ItemRow.frame, "ANCHOR_RIGHT");
                        GameTooltip:AddLine(string.format("Items won by %s:", Award.awardedTo));
                        GameTooltip:AddLine(" ");

                        for _, Entry in pairs(ItemsWonByRollerInTheLastFiveHours) do
                            local receivedString = " (received)";
                            if (not Entry.received) then
                                receivedString = " (not received yet)";
                            end

                            local OSString = "";
                            if (Entry.OS) then
                                OSString = " (OS)"
                            end

                            local BRString = "";
                            if (CL:higherThanZero(Entry.BRCost)) then
                                BRString = string.format(" (BR: %s)", Entry.BRCost);
                            end

                            local line = string.format("%s%s%s%s",
                                Entry.itemLink,
                                OSString,
                                BRString,
                                receivedString
                            );

                            GameTooltip:AddLine(line);
                        end

                        GameTooltip:Show();
                    end
                end);
                ItemRow.frame:SetScript("OnLeave", function()
                    GameTooltip:Hide();
                end);

                local ItemIcon = CL.AceGUI:Create("Icon");
                ItemIcon:SetWidth(30);
                ItemIcon:SetHeight(30);
                ItemIcon:SetImageSize(30, 30);
                ItemIcon:SetImage(ItemDetails.icon);
                ItemRow:AddChild(ItemIcon);
                ItemIcon:SetCallback("OnLeave", function()
                    GameTooltip:Hide();
                end);

                -- Show a gametooltip if the icon shown belongs to an item
                ItemIcon:SetCallback("OnEnter", function()
                    GameTooltip:SetOwner(ItemIcon.frame, "ANCHOR_TOP");
                    GameTooltip:SetHyperlink(ItemDetails.link);
                    GameTooltip:Show();
                end)

                local VerticalSpacer = CL.AceGUI:Create("SimpleGroup");
                VerticalSpacer:SetLayout("FILL");
                VerticalSpacer:SetWidth(8);
                VerticalSpacer:SetHeight(1);
                ItemRow:AddChild(VerticalSpacer);

                local ItemLinkLabel = CL.AceGUI:Create("Label");
                ItemLinkLabel:SetText(ItemDetails.link);
                ItemLinkLabel:SetWidth(itemLinkLabelWidth);
                ItemRow:AddChild(ItemLinkLabel);

                local PlayerLabel = CL.AceGUI:Create("Label");
                PlayerLabel:SetText(string.format("|c00%s%s|r",
                    CL:classHexColor(CL.Player:classByName(Award.awardedTo, 0), "5f5f5f"),
                    Award.awardedTo
                ));
                PlayerLabel:SetWidth(100);
                ItemRow:AddChild(PlayerLabel);

                local ActionButtonFrame = CL.AceGUI:Create("SimpleGroup");
                ActionButtonFrame:SetLayout("FILL");

                local elvUIStupendousScalingCrapModifier = 0;
                if (CL.elvUILoaded) then
                    elvUIStupendousScalingCrapModifier = 10;
                end

                ActionButtonFrame:SetWidth(WindowWidth - 30 - itemLinkLabelWidth - 100 - 50 - 16 - elvUIStupendousScalingCrapModifier);
                ActionButtonFrame:SetHeight(30);
                ItemRow:AddChild(ActionButtonFrame);

                local DeleteButton = CL.UI:createFrame("Button", "AwardHistoryActionButton" .. CL:uuid(), ActionButtonFrame.frame, "UIPanelButtonTemplate");
                DeleteButton:SetSize(24, 24);
                DeleteButton:SetPoint("TOPRIGHT", ActionButtonFrame.frame, "TOPRIGHT", 0, 0);
                DeleteButton:SetMotionScriptsWhileDisabled(true); -- Make sure tooltip still shows even when button is disabled

                local HighlightTexture = DeleteButton:CreateTexture();
                HighlightTexture:SetTexture("Interface\\AddOns\\Gargul\\Assets\\Buttons\\delete-highlighted");
                HighlightTexture:SetPoint("CENTER", DeleteButton, "CENTER", 0, 0);
                HighlightTexture:SetSize(24, 24);

                DeleteButton:SetNormalTexture("Interface\\AddOns\\Gargul\\Assets\\Buttons\\delete");
                DeleteButton:SetHighlightTexture(HighlightTexture);

                DeleteButton:SetScript("OnClick", function(_, button)
                    if (button == 'LeftButton') then
                        local BRString = "";
                        if (CL:higherThanZero(Award.BRCost)) then
                            BRString = " " .. tostring(Award.BRCost) .. " boosted roll points will be refunded!";
                        end

                        CL.Interface.Dialogs.PopupDialog:open({
                            question = string.format(
                                "Are you sure you want to undo %s awarded to %s?%s",
                                Award.itemLink,
                                Award.awardedTo,
                                BRString
                            ),
                            OnYes = function ()
                                CL.AwardedLoot:deleteWinner(Award.checksum);
                            end,
                        });
                    end
                end);

                local EditButton = CL.UI:createFrame("Button", "AwardHistoryActionButton" .. CL:uuid(), ActionButtonFrame.frame, "UIPanelButtonTemplate");
                EditButton:SetSize(24, 24);
                EditButton:SetPoint("TOPRIGHT", DeleteButton, "TOPLEFT", -3, 0);

                HighlightTexture = EditButton:CreateTexture();
                HighlightTexture:SetTexture("Interface\\AddOns\\Gargul\\Assets\\Buttons\\edit-highlighted");
                HighlightTexture:SetPoint("CENTER", EditButton, "CENTER", 0, 0);
                HighlightTexture:SetSize(24, 24);

                EditButton:SetNormalTexture("Interface\\AddOns\\Gargul\\Assets\\Buttons\\edit");
                EditButton:SetHighlightTexture(HighlightTexture);
                EditButton:SetDisabledTexture("Interface\\AddOns\\Gargul\\Assets\\Buttons\\edit-disabled");

                EditButton:SetScript("OnClick", function(_, button)
                    if (button == 'LeftButton') then
                        -- Show the player selector
                        local question = string.format("Who should %s go to instead?", Award.itemLink);
                        CL.Interface.PlayerSelector:draw(question, CL.User:groupMemberNames(), function (playerName)
                            CL.Interface.Dialogs.PopupDialog:open({
                                question = string.format("Award %s to |cff%s%s|r?",
                                    Award.itemLink,
                                    CL:classHexColor(CL.Player:classByName(playerName)),
                                    playerName
                                ),
                                OnYes = function ()
                                    if (not playerName or type(playerName) ~= "string") then
                                        return;
                                    end

                                    playerName = CL:capitalize(string.trim(string.lower(CL:stripRealm(playerName))));
                                    CL.AwardedLoot:editWinner(Award.checksum, playerName);

                                    CL.Interface.PlayerSelector:close();
                                end,
                            });
                        end);
                    end
                end);
            end)();
        end

        local ItemRow = CL.AceGUI:Create("SimpleGroup");
        ItemRow:SetLayout("FLOW");
        ItemRow:SetFullWidth(true);
        ScrollFrame:AddChild(ItemRow);
    end);

    -- Make sure that the window is updated whenever an award changes
    CL.Events:register({
        {"AwardHistoryItemAwardedListener", "CL.ITEM_AWARDED" },
        {"AwardHistoryItemUnAwardedListener", "CL.ITEM_UNAWARDED" },
        {"AwardHistoryItemEditedListener", "CL.ITEM_AWARD_EDITED" },
    }, function()
        CL:debug("AwardHistory:refresh");

        CL.Ace:CancelTimer(self.RefreshTimer);
        self.RefreshTimer = CL.Ace:ScheduleTimer(function ()
            self:refresh(AnchorTo);
        end, .3);
    end);
end

--- Close the current AwardHistory instance and by default reattach it to its last known location
---
---@param reattach boolean|nil
---@return void
function AwardHistory:close(reattach)
    CL:debug("AwardHistory:close");

    if (not self.isVisible) then
        return;
    end

    self.isVisible = false;

    if (self.Window
        and self.Window.frame
        and self.Window.frame.Hide
    ) then
        self.Window.frame:Hide();
    end

    self.Window = nil;

    CL.Events:unregister({
        "AwardHistoryItemAwardedListener",
        "AwardHistoryItemUnAwardedListener",
    });

    if (reattach == nil or reattach) then
        for index = #self.PreviousAnchors, 1, -1 do
            local anchorIsValid = false;
            local Anchor = self.PreviousAnchors[index];

            if (Anchor
                and type(Anchor) == "table"
                and Anchor.frame
                and Anchor.frame:IsVisible()
            ) then
                anchorIsValid = true;
            end

            self.PreviousAnchors[index] = nil;
            table.remove(self.PreviousAnchors, index);

            if (anchorIsValid) then
                CL.Ace:ScheduleTimer(function ()
                    self:draw(Anchor);
                end, 1);
                break;
            end
        end
    end
end

--- Reanchor the award history instance to a new AceGUI element
---
---@parm AnchorTo table
---@param AnchorTo table|nil
---@return void
function AwardHistory:reAnchor(AnchorTo)
    CL:debug("AwardHistory:reAnchor");

    self:close(false);
    self:draw(AnchorTo);
end

--- Refresh
---
---@param AnchorTo table|nil
---@return void
function AwardHistory:refresh(AnchorTo)
    CL:debug("AwardHistory:refresh");

    self:close();
    self:draw(AnchorTo);
end

CL:debug("Interface/AwardHistory.lua");