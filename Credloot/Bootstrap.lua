-- arg1 is the name of the addon, arg2 is the addon namespace
---@class Bootstrapper
local appName, CL = ...;
_G.Credloot = CL;

CL.name = appName;
CL._initialized = false;
CL.clientUIinterface = 0;
CL.clientVersion = 0;
CL.elvUILoaded = false;
CL.firstBoot = false;
CL.isEra = false;
CL.isRetail = false;
CL.isClassic = false;
CL.version = GetAddOnMetadata(CL.name, "Version");
CL.DebugLines = {};
CL.EventFrame = {};


-- Register our addon with the Ace framework
CL.Ace = LibStub("AceAddon-3.0"):NewAddon(CL.name, "AceConsole-3.0", "AceComm-3.0", "AceTimer-3.0", "AceHook-3.0");

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "Credloot" then
        CL:_init()
        -- Our saved variables, if they exist, have been loaded at this point.
        --[[if  CredlootDB == nil then
            -- This is the first time this addon is loaded; set SVs to default values
            CredlootDB = {}
        else
            CredlootDB = 10;
        end]]

    end

end)



---@return void
function CL:_init()

    do
        local version, _, _, uiVersion = GetBuildInfo();

        self.clientUIinterface = uiVersion;
        local expansion,majorPatch,minorPatch = (version or "3.0.0"):match("^(%d+)%.(%d+)%.(%d+)");
        self.clientVersion = (expansion or 0) * 10000 + (majorPatch or 0) * 100 + (minorPatch or 0);
    end

    if self.clientVersion < 20000 then
        self.isEra = true;
    elseif self.clientVersion < 90000 then
        self.isClassic = true;
    else
        self.isRetail = true;
    end

    -- Initialize classes
    self.Events:_init(self.EventFrame);
    self.DB:_init();

    -- self.Version:_init();
    -- self.Settings:_init();

    -- Add forwards compatibility
    self:polyFill();

    -- self.Comm:_init();
    -- self.User:_init();
    -- self.Reciveditem:_init();
    -- self.APGP:_init();
    -- self.Wishlist2:_init();
    -- self.raidNameTable:_init();


    -- Hook the bagslot events
    self:hookBagSlotEvents();

    -- -- Hook item tooltip events
    -- self:hookTooltipSetItemEvents();

    -- -- Make sure to initialize the user last
    -- self.User:refresh();
end

function CL:polyFill()
    if (_G.GetContainerItemInfo ~= nil or not C_Container.GetContainerItemInfo) then
        return;
    end

    -- The GetContainerNumSlots has the same return type in both classic and DF
    _G.GetContainerNumSlots = C_Container.GetContainerNumSlots;

    -- DF returns a single table instead of single values, polyFill time!
    _G.GetContainerItemInfo = function (bagID, slot)
        local result = C_Container.GetContainerItemInfo(bagID, slot);

        if (not result) then
            return nil;
        end

        return result.iconFileID, result.stackCount, result.isLocked, result.quality, result.isReadable,
            result.hasLoot, result.hyperlink, result.isFiltered, result.hasNoValue, result.itemID, result.isBound;
    end
end

---@return void
function CL:hookBagSlotEvents()
    hooksecurefunc("HandleModifiedItemClick", function(itemLink)
        -- The user doesnt want to use shortcut keys when solo
        --[[if (not CL.User.isInGroup
            --and CL.Settings:get("ShortcutKeys.onlyInGroup")
        ) then
            return;
        end]]

        if (not itemLink or type(itemLink) ~= "string") then
            return;
        end

        local keyPressIdentifier = CL.Events:getClickCombination();
        local keyPressRecognized = false;

        -- Open the roll window
    
            if (keyPressIdentifier == "ALT_CLICK") then
                CL.MasterLooterUI:draw(itemLink);            
                keyPressRecognized = true;

           --[[ ShortcutKeys = {
                onlyInGroup = false,
                showLegend = true,
                rollOff = "ALT_CLICK",
                award = "ALT_SHIFT_CLICK",
                disenchant = "CTRL_SHIFT_CLICK",
            }]]
        -- Open the award window
            elseif (keyPressIdentifier == CL.Settings:get("ShortcutKeys.award")) then
                CL.Interface.Award:draw(itemLink);
                keyPressRecognized = true;
            end
        
        -- Close the stack split window immediately after opening
        if (keyPressRecognized and IsShiftKeyDown()) then
            CL.Ace:ScheduleTimer(function ()
                if (_G.StackSplitFrame) then
                    _G.StackSplitFrame:Hide();
                end
            end, .05);
        end
    end);
end

--[[function CL.Ace:OnEnable()
	self:Hook("ContainerFrameItemButton_OnModifiedClick", true)
end]]

-- Fire CL.bootstrap every time an addon is loaded
CL.EventFrame = CreateFrame("FRAME", "CredLootEventFrame");
CL.EventFrame:RegisterEvent("ADDON_LOADED");
CL.EventFrame:SetScript("OnEvent", function (...) CL:bootstrap(...); end);

