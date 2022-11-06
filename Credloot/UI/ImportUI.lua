---@type CL
local _, CL = ...;
local DB = CL.DB; ---@type DB

local AceGUI = LibStub("AceGUI-3.0")

local FrameBackdrop = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
}

function importUI()

    --Lager ImportUI
    local ImportUI = AceGUI:Create("Frame")
    ImportUI:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
    ImportUI:SetTitle("Import")
    ImportUI:SetLayout("Flow")
    ImportUI:SetWidth(180);
    ImportUI:SetHeight(160);
    ImportUI:EnableResize(false);
    --ImportUI:SetBackdrop(FrameBackdrop);
    --ImportUI:SetPoint("BOTTOMLEFT", Window, "BOTTOMLEFT", 0, 0);
    ImportUI.frame:SetFrameStrata("HIGH");
    ImportUI.statustext:GetParent():Hide(); -- Hide the statustext


    --Create a import-button
    local btnImportWishlistWindow = AceGUI:Create("Button")
    btnImportWishlistWindow:SetWidth(180)
    btnImportWishlistWindow:SetText("Import Wishlist")
    btnImportWishlistWindow:SetCallback("OnClick", function() ImportWishlist() end)
    ImportUI:AddChild(btnImportWishlistWindow)

    local btnImportAPGPWindow = AceGUI:Create("Button")
    btnImportAPGPWindow:SetWidth(180)
    btnImportAPGPWindow:SetText("Import APGP")
    btnImportAPGPWindow:SetCallback("OnClick", function() ImportAPGP() end)
    ImportUI:AddChild(btnImportAPGPWindow)
end
