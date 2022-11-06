---@type CL
local _, CL = ...;

---@class Interface
CL.Interface = CL.Interface or {
    typeDictionary = {
        InteractiveLabel = "Label",
        SimpleGroup = "Frame",
        InlineGroup = "Frame",
    }
};

--local Settings = CL.Settings; ---@type Settings
local Interface = CL.Interface; ---@type Interface

-- Set an interface item on a given scope (either an object or string reference to an interface class)
function Interface:setItem(scope, identifier, Item)
    local widgetType = self:determineItemType(Item);
    local path = "";

    if (type(scope) == "table") then
        path = string.format("InterfaceItems.%s.%s", widgetType, identifier);
        return CL:tableSet(scope, path, Item);
    end

    path = string.format("CL.Interface.%s.InterfaceItems.%s.%s", scope, widgetType, identifier);
    return CL:tableSet(path, identifier);
end

-- Fetch an interface item from a given scope (either an object or string reference to an interface class)
function Interface:getItem(Scope, identifier)
    if (identifier == "Window") then
        identifier = "Frame.Window";
    end

    if (type(Scope) == "table") then
        return CL:tableGet(Scope, "InterfaceItems." .. identifier);
    end

    return CL:tableGet(CL.Interface, Scope .. ".InterfaceItems." .. identifier);
end

--- Release an item and remove it from our interface entirely
---
---@param Scope table
---@param identifier string
---@return boolean
function Interface:release(Scope, identifier)
    if (type(Scope) ~= "table"
        or type(identifier) ~= "string"
        or CL:empty(identifier)
    ) then
        return false
    end

    local Item = self:getItem(Scope, identifier);

    if (not Item
        or type(Item) ~= "table"
    ) then
        return false;
    end

    if (type(Item.type) == "string") then
        CL.AceGUI:Release(Item);
    end

    local path = string.format("InterfaceItems.%s", identifier);
    return CL:tableSet(Scope, path, nil);
end

-- Determine the given Item's type
function Interface:determineItemType(Item)
    if (type(Item.GetCell) == "function") then
        return "Table";
    end

    if (type(Item.type) == "string") then
        local itemType = Item.type;

        return self.typeDictionary[itemType] or itemType;
    end

    return "Frame";
end

--- Get an element's stored position (defaults to center of screen)
---
--[[---@param identifier string
---@return table
function Interface:getPosition(identifier)
    identifier = string.format("UI.%s.Position", identifier);

    return unpack({
        Settings:get(identifier .. ".point", "CENTER"),
        UIParent,
        Settings:get(identifier .. ".relativePoint", "CENTER"),
        Settings:get(identifier .. ".offsetX", 0),
        Settings:get(identifier .. ".offsetY", 0),
    });
end

--- Store an element's position in the settings table
---
---@param Item table
---@param identifier string The name under which the settings should be stored
---@return void
function Interface:storePosition(Item, identifier)
    identifier = string.format("UI.%s.Position", identifier);

    local point, _, relativePoint, offsetX, offsetY = Item:GetPoint();

    Settings:set(identifier .. ".point", point);
    Settings:set(identifier .. ".relativePoint", relativePoint);
    Settings:set(identifier .. ".offsetX", offsetX);
    Settings:set(identifier .. ".offsetY", offsetY);
end]]--

--CL:debug("UI/Interface.lua");


