---@class CL : Bootstrapper
local _, CL = ...;

local Constants = CL.Data.Constants; ---@type Data

--- LUA supports tostring, tonumber etc but no toboolean, let's fix that!
---@param var any
---@return boolean
function CL:toboolean(var)
    return not CL:empty(var);
end

---@param var number
---@param precision number
---@return number
function CL:round(var, precision)
    if (precision and precision > 0) then
        local mult = 10^ precision;
        return math.floor(var * mult + .5) / mult;
    end

    return math.floor(var + .5);
end

--- Print a normal message (white)
---
---@vararg string
---@return void
function CL:message(...)
    print("|TInterface/TARGETINGFRAME/UI-RaidTargetingIcon_3:12|t|cff8aecff CredLoot : |r" .. string.join(" ", ...));
end

--- Print a colored message
---
---@param color string
---@vararg string
---@return void
function CL:coloredMessage (color, ...)
    CL:message(string.format("|c00%s%s", color, string.join(" ", ...)));
end

--- Print a multicolored message
--- ColoredMessages is table of tables, with the message
--- being in the first and the color being in the second position
--- e.g. CL:multiColoredMessage({{"message", "color"},{"message2", "color2"}});
---
---@vararg table
---@param delimiter string
---@return void
function CL:multiColoredMessage (ColoredMessages, delimiter)
    local multiColoredMessage = "";
    delimiter = delimiter or " ";

    local firstMessage = true;
    for _, Envelope in pairs(ColoredMessages) do
        local message = Envelope[1];
        local color = Envelope[2];

        if (message and type(message) == "string"
            and color and type(color) == "string"
        ) then
            local coloredMessage = string.format("|c00%s%s|r", color, message);

            if (firstMessage) then
                multiColoredMessage = coloredMessage;
            else
                multiColoredMessage = string.format("%s%s%s", multiColoredMessage, delimiter, coloredMessage);
            end

            firstMessage = false;
        end
    end

    CL:message(multiColoredMessage);
end

--- Print a success message (green)
---
---@return void
function CL:success(...)
    CL:coloredMessage("92FF00", ...);
end

--- Print a debug message (orange)
---
---@return void
function CL:debug(...)
    if (not CL.Settings
        or not CL.Settings.Active
        or CL.Settings.Active.debugModeEnabled ~= true
    ) then
        return;
    end

    CL:coloredMessage("F7922E", ...);
end


--- Print a notice message (yellow)
---
---@return void
function CL:notice(...)
    CL:coloredMessage("FFF569", ...);
end

--- Print a warning message (orange)
---
---@return void
function CL:warning(...)
    CL:coloredMessage("F7922E", ...);
end

--- Print a error message (red)
---
---@return void
function CL:error(...)
    CL:coloredMessage("BE3333", ...);
end

--- Capitalize a given value (e.g. foo becomes Foo)
---
---@param value string
---@return string
function CL:capitalize(value)
    return (value:gsub("^%l", string.upper));
end

--- Dump a variable (functions won't work!)
---
---@param mixed any
---@return void
function CL:dump(mixed)
    local success, encoded = pcall(function () return CL.JSON:encode(mixed); end);

    if (not success) then
        CL:error("Unable to encode payload provided in CL:dump");
        return;
    end

    CL:message(encoded);
end

--- Check whether a given variable is empty
---
---@param mixed any
---@return boolean
function CL:empty(mixed)
    mixed = mixed or false;

    ---@type string
    local varType = type(mixed);

    if (varType == "boolean") then
        return not mixed;
    end

    if (varType == "string") then
        return strtrim(mixed) == "";
    end

    if (varType == "table") then
        for _ in pairs(mixed) do
            return false;
        end

        return true;
    end

    if (varType == "number") then
        return mixed == 0;
    end

    if (varType == "function"
        or varType == "CFunction"
        or varType == "userdata"
    ) then
        return false;
    end

    return true;
end

--- StringHash method, courtesy of Mikk38024 @ Wowpedia
---
---@param text string
function CL:stringHash(text)
    text = tostring(text);
    local counter = 1;
    local len = string.len(text);

    for i = 1, len, 3 do
        counter = math.fmod(counter*8161, 4294967279) +  -- 2^32 - 17: Prime!
            (string.byte(text,i)*16776193) +
            ((string.byte(text,i+1) or (len-i+256))*8372226) +
            ((string.byte(text,i+2) or (len-i+256))*3932164);
    end

    return math.fmod(counter, 4294967291); -- 2^32 - 5: Prime (and different from the prime in the loop)
end

--- Check whether a given variable is a number that's higher than zero
---
---@param numericValue number
---@return boolean
function CL:higherThanZero(numericValue)
    return numericValue
        and type(numericValue) == "number"
        and numericValue > 0
end

--- Levenshtein string distance
---
---@param str1 string
---@param str2 string
---
---@return number
function CL:levenshtein(str1, str2)
    local len1 = string.len(str1);
    local len2 = string.len(str2);
    local matrix = {};
    local cost = 0;

    if (len1 == 0) then
        return len2;
    end

    if (len2 == 0) then
        return len1;
    end

    if (str1 == str2) then
        return 0;
    end

    -- Initialise the base matrix values
    for i = 0, len1, 1 do
        matrix[i] = {};
        matrix[i][0] = i;
    end

    for j = 0, len2, 1 do
        matrix[0][j] = j;
    end

    -- actual Levenshtein algorithm
    for i = 1, len1, 1 do
        for j = 1, len2, 1 do
            if (str1:byte(i) == str2:byte(j)) then
                cost = 0;
            else
                cost = 1;
            end

            matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost);
        end
    end

    -- return the last value - this is the Levenshtein distance
    return matrix[len1][len2];
end

--- Get a class' RGB color by a given class name
---
---@param className string
---@param default string|nil
---@return table
function CL:classRGBAColor(className, default)
    default = default or Constants.classRGBAColors.priest;

    if (not className or type(className) ~= "string") then
        return default;
    end

    return CL:tableGet(
        Constants.classRGBAColors,
        string.lower(className),
        default
    );
end

--- Get a class' RGB color by a given class name
---
---@param className string
---@param default string|nil
---@return table
function CL:classRGBColor(className, default)
    default = default or Constants.classRGBColors.priest;

    if (not className
        or type(className) ~= "string"
    ) then
        return default;
    end

    return CL:tableGet(
        Constants.classRGBColors,
        string.lower(className),
        default
    );
end

--- Get a class' HEX color by a given class name
---
---@param className string
---@param default string|nil
---@return string
function CL:classHexColor(className, default)
    default = default or Constants.ClassHexColors.priest;

    if (not className or type(className) ~= "string") then
        return default;
    end

    return CL:tableGet(
        Constants.ClassHexColors,
        string.lower(className),
        default
    );
end

--- Print a table to the console
---
---@param t table
---@param shouldReturn boolean|nil
---@return void|string
function CL:printTable(t, shouldReturn)
    local returnString = "";

    local printTable_cache = {};

    local segment = "";
    local function sub_printTable( t, indent )
        if (printTable_cache[tostring(t)]) then
            segment = indent .. "*" .. tostring(t);
            if (shouldReturn) then
                returnString = "\n" .. returnString .. segment;
            else
                print(segment);
            end
        else
            printTable_cache[tostring(t)] = true;

            if (type(t) == "table") then
                for pos,val in pairs( t ) do
                    if (type(val)== "table") then
                        segment = indent .. "[" .. pos .. "] => " .. tostring( t ).. " {";

                        if (shouldReturn) then
                            returnString = "\n" .. returnString .. segment;
                        else
                            print(segment);
                        end

                        sub_printTable(val, indent .. string.rep( " ", string.len(pos)+8 ));

                        segment = indent .. string.rep( " ", string.len(pos)+6 ) .. "}";
                        if (shouldReturn) then
                            returnString = "\n" .. returnString .. segment;
                        else
                            print(segment);
                        end
                    elseif (type(val) == "string") then
                        segment = indent .. "[" .. pos .. '] => "' .. val .. '"';
                        if (shouldReturn) then
                            returnString = "\n" .. returnString .. segment;
                        else
                            print(segment);
                        end
                    else
                        segment = indent .. "[" .. pos .. "] => " .. tostring(val);
                        if (shouldReturn) then
                            returnString = "\n" .. returnString .. segment;
                        else
                            print(segment);
                        end
                    end
                end
            else
                segment = indent .. tostring(t);
                if (shouldReturn) then
                    returnString = "\n" .. returnString .. segment;
                else
                    print(segment);
                end
            end
        end
    end

    if (type(t) == "table") then
        segment = tostring(t) .. " {";
        if (shouldReturn) then
            returnString = "\n" .. returnString .. segment .. "\n";
        else
            print(segment);
            print();
        end

        sub_printTable(t, "  ");

        segment = "}";
        if (shouldReturn) then
            returnString = "\n" .. returnString .. segment;
        else
            print(segment);
        end
    else
        sub_printTable(t, "  ");
    end

    if (shouldReturn) then
        return returnString;
    end
end

--- Clone a table
---
---@param original table
---@return table
function CL:cloneTable(original)
    return {unpack(original)};
end

--- Clears the provided scrolling table (lib-ScrollingTable)
---
---@param ScrollingTable table
---@return void
function CL:clearScrollTable(ScrollingTable)
    ScrollingTable:SetData({}, true);
    ScrollingTable.frame:Hide();
    ScrollingTable:Hide();
    ScrollingTable.frame = nil;
    ScrollingTable = nil;
end

--- Check whether the provided string starts with a given substring
---
---@param str string
---@param startStr string
---@return boolean
function CL:strStartsWith(str, startStr)
   return string.sub(str, 1, string.len(startStr)) == startStr;
end

--- Check whether the provided string ends with a given substring
---
---@param str string
---@param endStr string
---@return boolean
function CL:strEndsWith(str, endStr)
    return string.sub(str,-(string.len(endStr))) == endStr;
end

--- Check whether the provided string contains a given substring
---
---@param str string
---@param subStr string
---@return boolean
function CL:strContains(str, subStr)
    return CL:toboolean(strfind(str, subStr));
end

--- URL Decode a given url string
---
---@param url string
---@return string
function CL:urlDecode(url)
    local hexToChar = function(x)
        return string.char(tonumber(x, 16));
    end

    if (url == nil) then
        return "";
    end

    url = url:gsub("+", " ");
    return url:gsub("%%(%x%x)", hexToChar);
end

--- Print large quantities of text to a multiline editbox
--- Very useful for debugging purposes, should not be used for anything else
---
---@param message string|table
---@return void
function CL:frameMessage(message)
    if (type(message) == "table") then
        message = CL.JSON:encode(message);
    end

    local AceGUI = CL.AceGUI or LibStub("AceGUI-3.0");

    -- Create a container/parent frame
    local MesseGrame = AceGUI:Create("Frame");
    MesseGrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget); end);
    MesseGrame:SetTitle("CredLoot v" .. CL.version);
    MesseGrame:SetStatusText("");
    MesseGrame:SetLayout("Flow");
    MesseGrame:SetWidth(600);
    MesseGrame:SetHeight(450);

    -- Large edit box
    local MessageBox = AceGUI:Create("MultiLineEditBox");
    MessageBox:SetText(message);
    MessageBox:SetFocus();
    MessageBox:SetFullWidth(true);
    MessageBox:DisableButton(true);
    MessageBox:SetNumLines(22);
    MessageBox:HighlightText();
    MessageBox:SetMaxLetters(999999999);
    MesseGrame:AddChild(MessageBox);
end

--- Counting tables (or arrays if you will) is anything but straight-forward in LUA. Examples:
--- #{["test"] = "value", ["test2"] = "value2"} -> results in 0
--- #{1 = "value", 2 = "value2"} -> results in 2
--- #{5 = "value5", 9 = "value9"} -> results in 9, not 2!
---
--- @param var string|table
--- @return number
function CL:count(var)
    if (type(var) == "string") then
        return strlen(var);
    end

    if (type(var) == "table") then
        local count = 0;
        for _ in pairs(var) do
            count = count + 1;
        end

        return count;
    end

    return 0;
end

--- The onItemLoadDo helper accepts one or more item ids or item links
--- The corresponding items will be loaded using Blizzard's Item API
--- After all of the files are loaded execute the provided callback function
---
---@param Items table
---@param callback function
---@param haltOnError boolean
---@param sorter function
---@return void
function CL:onItemLoadDo(Items, callback, haltOnError, sorter)
    CL:debug("CL:onItemLoadDo");

    CL.DB.Cache.ItemsById = CL.DB.Cache.ItemsById or {};
    haltOnError = haltOnError or false;

    if (type(callback) ~= "function") then
        CL:warning("Unexpected type '" .. type(callback) .. "' in CL:continueOnItemLoad, expecting type 'function'");
        return;
    end

    if (type(Items) ~= "table") then
        Items = {Items};
    end;

    local itemsLoaded = 0;
    local ItemData = {};
    local lastError = "";
    local callbackCalled = false;
    local numberOfItemsToLoad = self:count(Items);

    --- We use this nasty function construct in order to be able to return out of a for loop (see below)
    ---
    ---@param itemIdentifier string|number
    ---@return void
    local function loadOrReturnItem(itemIdentifier)
        local ItemResult = {}; ---@type Item
        local identifierType = type(itemIdentifier);
        local identifierIsId = CL:higherThanZero(tonumber(itemIdentifier));
        local idString = "";

        -- If a number is provided we assume that it's an item ID
        if (identifierIsId) then
            -- This seems counterintuitive, but don't get me started on numeric table keys in LUA
            idString = tostring(itemIdentifier);

            -- The item already exists in our runtime item cache, return it
            if (CL.DB.Cache.ItemsById[idString] ~= nil) then
                itemsLoaded = itemsLoaded + 1;
                tinsert(ItemData, CL.DB.Cache.ItemsById[idString]);

                return;
            end

            -- The item doesn't exist yet, start loading it
            ItemResult = Item:CreateFromItemID(tonumber(itemIdentifier));

        -- If a string is provided we assume that it's an item link
        elseif (identifierType == "string") then
            ItemResult = Item:CreateFromItemLink(itemIdentifier);

        -- We can't use anything that's not an id or link so we skip it
        else
            itemsLoaded = itemsLoaded + 1;
            lastError = "Unknown identifier type in CL:onItemLoadDo:loadOrReturnItem, expecting string or number";

            return;
        end

        -- This is Blizzard's way of saying: this item don't exist fool
        if (ItemResult:IsItemEmpty()) then
            itemsLoaded = itemsLoaded + 1;
            lastError = "No item found with identifier " .. itemIdentifier;

            return;
        end

        ItemResult:ContinueOnItemLoad(function()
            local itemID = ItemResult:GetItemID();
            itemsLoaded = itemsLoaded + 1;

            local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
            itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(itemID);

            if (CL:empty(itemName)
                or CL:empty(itemLink)
                or type (bindType) ~= "number"
            ) then
                CL:debug("GetItemInfo data was not yet available for item with ID: " .. itemID);

                return; -- Return here so we don't cache any incomplete data
            end

            idString = tostring(itemID);

            CL.DB.Cache.ItemsById[idString] = {
                id = itemID,
                bindType = bindType,
                classID = classID,
                icon = itemTexture,
                inventoryType = itemEquipLoc,
                level = itemLevel,
                link = itemLink,
                name = itemName,
                subclassID = subclassID,
                quality = itemQuality,
            };

            tinsert(ItemData, CL.DB.Cache.ItemsById[idString]);

            if (not callbackCalled
                and itemsLoaded >= numberOfItemsToLoad
            ) then
                callbackCalled = true;

                if (type(sorter) == "function") then
                    table.sort(ItemData, sorter);
                end

                callback(ItemData);
                return;
            end
        end)
    end

    --- This might seem like a weird construction, but LUA
    --- does not support continue statements in for loops.
    ---
    ---@param itemIdentifier string|number
    for _, itemIdentifier in pairs(Items) do
        if (haltOnError and not CL:empty(lastError)) then
            CL:warning(lastError);
            return;
        end

        loadOrReturnItem(itemIdentifier);

        -- Make sure the callback has not yet been executed in the async onload method
        if (not callbackCalled
            and itemsLoaded >= numberOfItemsToLoad
        ) then
            callbackCalled = true;

            if (type(sorter) == "function") then
                table.sort(ItemData, sorter);
            end

            callback(ItemData);
            return;
        end
    end
end

--- Make sure era names are suffixed with a realm
---
---@param playerName string
---@return string
function CL:normalizedName(playerName)
    CL:debug("CL:normalizedName");

    if (CL.isEra and not strfind(playerName, "-")) then
        playerName = string.format("%s-%s", playerName, CL.User.realm);
    end

    return string.lower(playerName);
end

-- Set up a table of all relevant localized time strings,
-- mapping them to their equivalent time in seconds
-- This allows us to fetch hours/minutes/seconds remaining from item tooltips
local TimeTable = {}
local TimeFormats = {
    [INT_SPELL_DURATION_HOURS] = 60 * 60,
    [INT_SPELL_DURATION_MIN] = 60,
    [INT_SPELL_DURATION_SEC] = 1
};
for pattern, coefficient in pairs(TimeFormats) do
    local prefix = "";
    pattern = pattern:gsub("%%d(%s?)", function(s)
        prefix = "(%d+)" .. s;
        return "";
    end);

    pattern = pattern:gsub("|4", ""):gsub("[:;]", " ");

    for s in pattern:gmatch("(%S+)") do
        TimeTable[prefix .. s] = coefficient;
    end
end

--- Read CL.TooltipFrame's tooltip and see if there's time remaining to trade the item
---
---@return number Seconds or 0
function CL:tooltipItemTradeTimeRemaining()
    local timeRemaininCLine;
    local needle = BIND_TRADE_TIME_REMAINING:gsub("%%s", ".*");
    local itemIsSoulBound = false;

    -- Attempt to find a tooltip line that holds the remaining trading time
    for i = 1, CL.TooltipFrame:NumLines() do
        local line = _G["GargulTooltipFrameTextLeft" .. i];

        if line then
            timeRemaininCLine = line:GetText() or "";

            -- The item is actually soulbound!
            if (timeRemaininCLine == ITEM_SOULBOUND) then
                itemIsSoulBound = true;
            end

            -- The time remaining line was found, no need to continue searching!
            if timeRemaininCLine:find(needle) then
                break;
            end

            timeRemaininCLine = nil;
        end
    end

    -- Extract each unit of time, convert it to seconds, and sum it
    if (timeRemaininCLine) then
        local timeRemainingInSeconds = 0;
        for pattern, coefficient in pairs(TimeTable) do
            local timeRemainingSegment = timeRemaininCLine:match(pattern);

            if timeRemainingSegment then
                timeRemainingInSeconds = timeRemainingInSeconds + timeRemainingSegment * coefficient;
            end
        end

        return timeRemainingInSeconds;
    end

    -- The item isn't soulbound at all!
    if (not itemIsSoulBound) then
        return CL.Data.Constants.itemIsNotBound;
    end

    return 0;
end

--- Check how much time to trade is remaining on the given item in our bags
---
---@param bag number
---@param slot number
---@return number Seconds or 0
function CL:inventoryItemTradeTimeRemaining(bag, slot)
    CL.TooltipFrame:ClearLines();
    CL.TooltipFrame:SetBagItem(bag, slot);

    local timeRemaining = CL:tooltipItemTradeTimeRemaining();
    CL.TooltipFrame:ClearLines();

    if (CL.Interface.Settings.LootTradeTimers.testEnabled) then
        return math.random(5000, 7200);
    end

    return timeRemaining;
end

--- Check whether a user can use the given item ID or link (callback required)
---
---@param itemLinkOrID string|number
---@param callback function
---
---@return void
function CL:canUserUseItem(itemLinkOrID, callback)
    CL:debug("CL:canUserUseItem");

    if (type(callback) ~= "function") then
        CL:warning("Unexpected type '" .. type(callback) .. "' in CL:canUserUseItem, expecting type 'function'");
        return;
    end

    local itemID;
    local concernsID = CL:higherThanZero(tonumber(itemLinkOrID));

    if (concernsID) then
        itemID = math.floor(tonumber(itemLinkOrID));
    else
        itemID = CL:getItemIdFromLink(itemLinkOrID);
    end

    CL:onItemLoadDo(itemID, function (Results)
        local Item = Results[1];

        -- Better safe than lua error!
        if (CL:empty(Item.link)) then
            return callback(true);
        end

        CL.TooltipFrame:ClearLines();
        CL.TooltipFrame:SetHyperlink("item:" .. itemID);

        local IsTooltipTextRed = function (text)
            if (text and text:GetText()) then
                local r, g, b = text:GetTextColor();
                return math.floor(r * 256) == 255 and math.floor(g * 256) == 32 and math.floor(b * 256) == 32;
            end

            return false
        end;

        for line = 1, CL.TooltipFrame:NumLines() do
            local left = _G["GargulTooltipFrameTextLeft" .. line];
            local right = _G["GargulTooltipFrameTextRight" .. line];

            if (IsTooltipTextRed(left) or IsTooltipTextRed(right)) then
                return callback(false);
            end
        end

        return callback(true);
    end);
end

--- Find the first bag id and slot for a given item id (or false)
---
---@param itemID number
---@param skipSoulBound boolean
---@return table
function CL:findBagIdAndSlotForItem(itemID, skipSoulBound, includeBankBags)
    skipSoulBound = CL:toboolean(skipSoulBound);
    includeBankBags = CL:toboolean(includeBankBags);

    local numberOfBagsToCheck = 4;
    if (includeBankBags) then
        numberOfBagsToCheck = 10;
    end

    for bag = 0, numberOfBagsToCheck do
        for slot = 1, GetContainerNumSlots(bag) do
            local _, _, locked, _, _, _, _, _, _, bagItemID = GetContainerItemInfo(bag, slot);

            if (bagItemID == itemID
                and not locked -- The item is locked, aka it can not be put in the window
                and (not skipSoulBound -- We don't care about the soulbound status of the item, return the bag/slot!
                    or CL:inventoryItemTradeTimeRemaining(bag, slot) > 0 -- The item is tradeable
                )
            ) then
                return {bag, slot};
            end
        end
    end

    return {};
end

--- Dragonflight and future WoW releases no longer support OnTooltipSetItem
---
---@param Callback function
---@return any
function CL:onTooltipSetItem(Callback, includeItemRefTooltip)
    CL:debug("CL:onTooltipSetItem");

    if (includeItemRefTooltip == nil) then
        includeItemRefTooltip = true;
    end

    includeItemRefTooltip = CL:toboolean(includeItemRefTooltip);

    if (TooltipDataProcessor) then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function (Tooltip)
            return Callback(Tooltip);
        end);
    else
        GameTooltip:HookScript("OnTooltipSetItem", function(Tooltip)
            return Callback(Tooltip);
        end);

        if (includeItemRefTooltip) then
            ItemRefTooltip:HookScript("OnTooltipSetItem", function(Tooltip)
                return Callback(Tooltip);
            end);
        end
    end
end

--- In some very rare cases we need to manipulate the close button on AceGUI elements
---
---@param Widget table
---@return void|table
function CL:fetchCloseButtonFromAceGUIWidget(Widget)
    CL:debug("CL:fetchCloseButtonFromAceGUIWidget");

    if (not Widget or not Widget.frame) then
        return;
    end

    -- Try to locate the Close button and hide it
    for _, Child in pairs({Widget.frame:GetChildren()}) do
        if (Child.GetText and Child:GetText() == "Close") then
            return Child;
        end
    end
end

--- In some very rare cases we need to manipulate the border on AceGUI Inline Group elements
---
---@param Widget table
---@return void|table
function CL:fetchBorderFromAceGUIInlineGroup(Widget)
    CL:debug("CL:fetchBorderFromAceGUIInlineGroup");

    if (not Widget or not Widget.frame) then
        return;
    end

    -- Try to locate the Close button and hide it
    for _, Child in pairs({Widget.frame:GetChildren()}) do
        if (Child.SetBackdropColor) then
            return Child;
        end
    end
end

--- Some items have items linked to them. Example: t4 tokens have their quest reward counterpart linked to them.
---
---@param itemId number
---@return table
function CL:getLinkedItemsForId(itemId)
    -- An invalid item id was provided
    itemId = tonumber(itemId);
    if (not CL:higherThanZero(itemId)) then
        return {};
    end

    -- Gather all the item IDs that are linked to our item
    itemId = tostring(itemId);
    local AllLinkedItemIds = {itemId};
    for _, id in pairs(CL.Data.ItemLinks[itemId] or {}) do
        tinsert(AllLinkedItemIds, id);
    end

    return AllLinkedItemIds;
end

--- Return an item's ID from an item link, false if invalid itemlink is provided
---
---@param itemLink string
---@return number|boolean
function CL:getItemIdFromLink(itemLink)
    if (not itemLink
        or type(itemLink) ~= "string"
        or itemLink == ""
    ) then
        return false;
    end

    local _, itemId = strsplit(":", itemLink);
    itemId = tonumber(itemId);

    if (not itemId) then
        return false;
    end

    return itemId;
end

--- Strip the realm off of a string (usually a player name)
---
---@param str string
---@return string
function CL:stripRealm(str)
    str = tostring(str);

    if (self:empty(str)) then
        return "";
    end

    -- WoW knows multiple realm separators ( - @ # * ) depending on version and locale
    local separator = str:match("[" .. REALM_SEPARATORS .. "]");

    -- No realm separator was found, return the original message
    if (not separator) then
        return str;
    end

    local Parts = self:strSplit(str, separator);
    return Parts[1] or "";
end

--- Check whether the given player name occurs more than once in the player's group
--- (only possible in Era because of cross-realm support)
---
---@param name string
---@return boolean
function CL:nameIsUnique(name)
    if (not CL.isEra) then
        return true;
    end

    name = string.lower(CL:stripRealm(name));
    local nameEncountered = false;
    for _, playerName in pairs(CL.User:groupMemberNames()) do
        if (playerName == name) then
            if (not nameEncountered) then
                nameEncountered = true;
            else
                return false;
            end
        end
    end

    return true;
end

--- Return an item's name from an item link
---
---@param itemLink string
---@return string|boolean
function CL:getItemNameFromLink(itemLink)
    if (type(itemLink) ~= "string"
        or self:empty(itemLink)
    ) then
        return false;
    end

    local itemName = false;
    local openingBracketPosition = string.find(itemLink, "%[");
    local closingBracketPosition = string.find(itemLink, "%]");
    if (openingBracketPosition and closingBracketPosition) then
        itemName = string.sub(itemLink, openingBracketPosition + 1, closingBracketPosition - 1);
    end

    return itemName;
end

--- Transform a copper value to a money string
---
--- copperToMoney(125000)                    > 12G 50S
--- copperToMoney(125000, nil, true)         > 12G 50S 0C
--- copperToMoney(125000, {".","",""}, true) > 12.5000
--- copperToMoney(125000, nil, true, true)   > G12 S50 C0
---
---@param copper number
---@param Separators table|nil
---@param includeEmpty boolean|nil
---@param separatorBeforeUnit boolean|nil
---
---@return string
function CL:copperToMoney(copper, Separators, includeEmpty, separatorBeforeUnit)
    local DefaultSeparators;

    if (copper < 1) then
        return "";
    end

    if (not separatorBeforeUnit) then
        DefaultSeparators = {"G ", "S ", "C "};
    else
        DefaultSeparators = {" G", " S", " C"};
    end

    Separators = Separators or {};
    includeEmpty = CL:toboolean(includeEmpty);
    separatorBeforeUnit = CL:toboolean(separatorBeforeUnit);
    local goldSeparator = Separators[1] or DefaultSeparators[1];
    local silverSeparator = Separators[2] or DefaultSeparators[2];
    local copperSeparator = Separators[3] or DefaultSeparators[3];

    local gold = math.floor(copper / 10000);
    local silver = math.floor(copper / 100) % 100
    local copperLeft = copper % 100

    -- The user doesn't care about empty units, return as-is
    if (includeEmpty) then
        if (not separatorBeforeUnit) then
            return string.format(
                "%s%s%s%s%s%s",
                gold,
                goldSeparator,
                silver,
                silverSeparator,
                copperLeft,
                copperSeparator
            );
        else
            return string.format(
                "%s%s%s%s%s%s",
                goldSeparator,
                gold,
                silverSeparator,
                silver,
                copperSeparator,
                copperLeft
            );
        end
    end

    local money = "";

    if (gold > 0) then
        if (separatorBeforeUnit) then
            money = goldSeparator .. gold;
        else
            money = gold .. goldSeparator;
        end
    end

    if (silver > 0) then
        if (separatorBeforeUnit) then
            money = money .. silverSeparator .. silver;
        else
            money = money .. silver .. silverSeparator;
        end
    end

    if (copperLeft > 0) then
        if (separatorBeforeUnit) then
            money = money .. copperSeparator .. copperLeft;
        else
            money = money .. copperLeft .. copperSeparator;
        end
    end

    return strtrim(money);
end

--- Limit a given string to a maximum number of characters
---
---@param str string
---@param limit number
---@param append string|nil
---@return string
function CL:strLimit(str, limit, append)
    local strLength = string.len(str);

    -- The string is not too long, just return it
    if (strLength <= limit) then
        return str;
    end

    append = append or "...";
    local appendLength = string.len(append);

    -- Return the limited string with appendage
    return str:sub(1, limit - appendLength) .. append;
end

--- Split a string by a given delimiter
--- WoWLua already has a strsplit function, but it returns multiple arguments instead of a table
---
---@param s string
---@param delimiter string
---@return table
function CL:strSplit(s, delimiter)
    local Result = {};

    -- No delimited is provided, split all characters
    if (not delimiter) then
        s:gsub(".",function(character) table.insert(Result, character); end);
        return Result;
    end

    for match in (s .. delimiter):gmatch("(.-)%" .. delimiter) do
        tinsert(Result, strtrim(match));
    end

    return Result;
end

--- Split a string by any space characters or commas
--- This is useful for CSV, TSV files and pasted tables from GooCLe Docs
---
---@param s string
---@return table
function CL:separateValues(s)
    local Segments = {};

    for match in string.gmatch(s, "[^%s,]+") do
        tinsert(Segments, match);
    end

    return Segments;
end

--- Turn a given wow pattern into something we can use in string.match
---
---@param pattern string
---@param maximize boolean|nil
---@return string
function CL:createPattern(pattern, maximize)
    pattern = string.gsub(pattern, "[%(%)%-%+%[%]]", "%%%1");

    if not maximize then
        pattern = string.gsub(pattern, "%%s", "(.-)");
    else
        pattern = string.gsub(pattern, "%%s", "(.+)");
    end

    pattern = string.gsub(pattern, "%%d", "%(%%d-%)");

    if not maximize then
        pattern = string.gsub(pattern, "%%%d%$s", "(.-)");
    else
        pattern = string.gsub(pattern, "%%%d%$s", "(.+)");
    end

    return string.gsub(pattern, "%%%d$d", "%(%%d-%)");
end

--- Play a sound
---
---@param soundNameOrNumber string
---@param channel string
function CL:playSound(soundNameOrNumber, channel)
    -- Check if the user muted the addon
    if (CL.Settings:get("noSounds")) then
        return;
    end

    if (type(channel) ~= "string"
        or CL:empty(channel)
    ) then
        channel = "Master";
    end

    PlaySound(soundNameOrNumber, channel);
end

local gaveNoMessagesWarning = false;
local gaveNoAssistWarning = false;
---@param message string The message you'd like to send
---@param chatType string The type of message (SAY|EMOTE|YELL|PARTY|GUILD|OFFICER|RAID|RAID_WARNING|INSTANCE_CHAT|BATTLEGROUND|WHISPER|CHANNEL|AFK|DND)
---@param language string|nil The language of the message (COMMON|ORCISH|etc), if nil it's COMMON for Alliance and ORCISH for Horde
---@param channel string|nil The channel (numeric) or player (name string) receiving the message
---@param stw boolean|nil Important for throttling / spam prevention
---@return void
function CL:sendChatMessage(message, chatType, language, channel, stw)
    CL:debug("CL:sendChatMessage");

    if (stw == nil) then
        stw = true;
    end
    stw = CL:toboolean(stw);

    -- No point sending an empty message!
    if (CL:empty(message)) then
        return;
    end

    -- No point sending an empty message!
    if (CL:empty(chatType)) then
        CL:warning("Missing 'chatType' in CL:sendChatMessage!");
        return;
    end

    -- The player enabled the noMessages setting
    if (CL.Settings:get("noMessages")) then
        if (not gaveNoMessagesWarning) then
            CL:message("A message was blocked because you have the 'No messages' setting enabled.");
            gaveNoMessagesWarning = true;
        end

        return;
    end

    -- The user is not in a group of any kind but still wants to
    -- post a message on group or raid. Let's assume he's testing stuff
    if (not CL.User.isInGroup
        and CL:inTable({"GROUP", "PARTY", "RAID", "RAID_WARNING"}, chatType)
    ) then
        return CL:coloredMessage("FF7D0A", message); -- FF7D0A is the same color as /ra text
    end

    if (stw) then
        message = string.format("{rt3} %s : %s", CL.name, message);
    end

    -- The player wants to message the group (either raid or party)
    if (chatType == "GROUP") then
        chatType = "PARTY";

        if (CL.User.isInRaid) then
            chatType = "RAID";
        end

    -- The player wants to post in RAID_WARNING but is either not in a raid or doesn't have assist
    elseif (chatType == "RAID_WARNING") then
        if (not CL.User.isInRaid) then
            chatType = "PARTY";
        elseif (not CL.User.hasAssist) then
            if (not gaveNoAssistWarning) then
                CL:warning("You need assist to use raid warnings!");
                gaveNoAssistWarning = true;
            end

            chatType = "RAID";
        end
    end

    SendChatMessage (
        message,
        chatType,
        language,
        channel
    );
end

--- Check whether a given value exists within a table
---
---@param array table
---@param value any
function CL:inTable(array, value)
    if (type(value) == "string") then
        value = string.lower(value);
    end

    for _, val in pairs(array) do
        if (type(val) == "string") then
            val = string.lower(val);
        end

        if value == val then
            return true
        end
    end

    return false
end

--- Generate a random (enough) uuid
---
---@return string
function CL:uuid()
    local random = math.random;
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx";

    return string.gsub(template, "[xy]", function (c)
        local v = (c == "x") and random(0, 0xf) or random(8, 0xb);
        return string.format("%x", v);
    end)
end

--- Overwrite/compliment the original table (left) with the values from the right table
---
---@param left table
---@param right table
---@return table
function CL:tableMerge(left, right)
    if (type(left) ~= "table" or type(right) ~= "table") then
        return false;
    end

    for key,value in pairs(right) do
        if (type(value) == "table") then
            if (type(left[key] or false) == "table") then
                self:tableMerge(left[key] or {}, right[key] or {});
            else
                left[key] = value;
            end
        else
            left[key] = value;
        end
    end

    return left;
end

--- Return the values from a sinCLe column in the input table
---
---@param Table table
---@param column string
---@return table
function CL:tableColumn(Table, column)
    local Values = {};

    for _, Entry in pairs(Table) do
        if (Entry[column]) then
            tinsert(Values, Entry[column]);
        end
    end

    return Values;
end

--- Simple table flip (keys become values, values become keys)
--- (╯°□°）╯︵ ┻━┻
---
---@param Table table
function CL:tableFlip(Table)
    local Flipped = {};
    for key, value in pairs(Table) do
        Flipped[value] = key;
    end

    return Flipped;
end

--- Table slice method
---
---@param Table table
---@param offset number
---@param length number
---@param preserveKeys boolean
---@return table
function CL:tableSlice(Table, offset, length, preserveKeys)
    if (not length) then
        length = offset;
        offset = 0;
    end

    if (not offset
        or type(offset) ~= "number"
        or offset < 1
    ) then
        offset = 1;
    end

    local Slice = {};
    local last = offset + length;

    if (preserveKeys) then
        local index = 1;
        for key, value in pairs(Table) do
            if (index > last) then
                return Slice;
            end

            if (index >= offset) then
                Slice[key] = value;
            end

            index = index + 1;
        end

        return Slice;
    end

    for index = offset, last do
        if (type(Table[index]) == "nil") then
            return Slice;
        end

        tinsert(Slice, Table[index]);
    end

    return Slice;
end

--- Pad a string to a certain length with another string (left side)
---
---@param str string
---@param padChar string
---@param length number
---@return string
function CL:strPadLeft(str, padChar, length)
    return string.rep(padChar, length - CL:count(str)) .. str;
end

--- Pad a string to a certain length with another string (right side)
---
---@param str string
---@param padChar string
---@param length number
---@return string
function CL:strPadRight(str, padChar, length)
    return str .. string.rep(padChar, length - CL:count(str));
end

--- Get a table value by a given key. Use dot notation to traverse multiple levels e.g:
--- Settings.UI.Auctioneer.offsetX can be fetched using CL:tableGet(myTable, "Settings.UI.Auctioneer.offsetX", 0)
--- without having to worry about tables or keys existing along the way.
--- This helper is absolutely invaluable for writing error-free code!
---
---@param Table table
---@param keyString string
---@param default any
---@return any
function CL:tableGet(Table, keyString, default)
    if (type(keyString) ~= "string"
        or self:empty(keyString)
    ) then
        return default;
    end

    local keys = CL:strSplit(keyString, ".");
    local numberOfKeys = #keys;
    local firstKey = keys[1];

    if (not numberOfKeys or not firstKey) then
        return default;
    end

    if (type(Table[firstKey]) == "nil") then
        return default;
    end

    Table = Table[firstKey];

    -- Changed if (#keys == 1) then to below, saved this just in case we get weird behavior
    if (numberOfKeys == 1) then
        default = nil;
        return Table;
    end

    tremove(keys, 1);
    return self:tableGet(Table, strjoin(".", unpack(keys)), default);
end

--- Set a table value by a given key and value. Use dot notation to traverse multiple levels e.g:
--- Settings.UI.Auctioneer.offsetX can be set using CL:tableSet(myTable, "Settings.UI.Auctioneer.offsetX", myValue)
--- without having to worry about tables or keys existing along the way.
---
---@param Table table
---@param keyString string
---@param value any
---@return boolean
function CL:tableSet(Table, keyString, value)
    if (not keyString
        or type(keyString) ~= "string"
        or keyString == ""
    ) then
        CL:warning("Invalid key provided in CL:tableSet");
        return false;
    end

    local keys = CL:strSplit(keyString, ".");
    local firstKey = keys[1];

    if (#keys == 1) then
        Table[firstKey] = value;
        return true;
    elseif (not Table[firstKey]) then
        Table[firstKey] = {};
    end

    tremove(keys, 1);

    Table = Table[firstKey];
    return self:tableSet(Table, strjoin(".", unpack(keys)), value);
end

--- Apply a user supplied function to every member of a table
---
---@param Table table
---@param callback function
---@return void
function CL:tableWalk(Table, callback, ...)
    for key, Value in pairs(Table) do
        callback(key, Value, ...);
    end
end;

--- Finds the correct class-color
---
---@param Table table
---@param callback function
---@return void
function CL:returnClassColors(class)
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

CL:debug("Helpers.lua");
