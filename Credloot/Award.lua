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