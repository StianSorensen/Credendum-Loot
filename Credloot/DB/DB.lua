---@type CL
local _, CL = ...;

---@class DB
CL.DB = {
    _initialized = false,
    ReceivedItems = {},
    ImportedAPGP = {},
    ImportedWishlist = {},
    
};

local DB = CL.DB;

function DB:_init()
    -- No need to initialize this class twice
    if (self._initialized) then
        return;
    end

    if (not CredlootDB or not (type(CredlootDB) == "table")) then
        CredlootDB = {};
    end

    -- Prepare our database tables
    CredlootDB.ReceivedItems = CredlootDB.ReceivedItems or {};
    CredlootDB.ImportedAPGP = CredlootDB.ImportedAPGP or {};
    CredlootDB.ImportedWishlist = CredlootDB.ImportedWishlist or {};
    -- CredlootDB.raidNameTable = CredlootDB.raidNameTable or {};


    -- Provide a shortcut for each table
    self.ReceivedItems = CredlootDB.ReceivedItems
    self.ImportedAPGP = CredlootDB.ImportedAPGP
    self.ImportedWishlist = CredlootDB.ImportedWishlist
    -- self.raidNameTable = CredlootDB.raidNameTable
    --CL:dump(CredlootDB.ImportedWishlist)
    CL:dump(CredlootDB.ImportedAPGP)
    CL:dump(CredlootDB.ReceivedItems)
    CL:dump(CredlootDB.ImportedAPGP["tallefjompen"])
    -- Fire DB:store before every logout/reload/exit
    CL.Events:register("DBPlayerLogoutListener", "PLAYER_LOGOUT", self.store);

    self._initialized = true;
end

--- Make sure the database persists between sessions
--- This is just a safety precaution and should strictly
--- speaking not be necessary, but hey you never know!
function DB:store()
    CL:debug("DB:store");
    CredlootDB.ReceivedItems = CL.DB.ReceivedItems
    CredlootDB.ImportedAPGP = CL.DB.ImportedAPGP
    CredlootDB.ImportedWishlist = CL.DB.ImportedWishlist
    -- CredlootDB.raidNameTable = CL.raidNameTable
end

--Get a value from the database, or return a default if it doesn't exist
function DB:get(keyString, default)
    return CL:tableGet(DB, keyString, default);
end

-- Set a database value by a given key and value
function DB:set(keyString, value)
    return CL:tableSet(DB, keyString, value);
end

--- Set a table value by a given key and value. Use dot notation to traverse multiple levels e.g:
--- Settings.UI.Auctioneer.offsetX can be set using GL:tableSet(myTable, "Settings.UI.Auctioneer.offsetX", myValue)
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
        --GL:warning("Invalid key provided in GL:tableSet");
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

--- Get a table value by a given key. Use dot notation to traverse multiple levels e.g:
--- Settings.UI.Auctioneer.offsetX can be fetched using GL:tableGet(myTable, "Settings.UI.Auctioneer.offsetX", 0)
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

-- -- Reset the tables
-- function DB:reset()
--     GL:debug("DB:reset");

--     self.AwardHistory = {};
--     self.LootPriority = {};
--     self.MinimapButton = {};
--     self.PlusOnes = {};
--     self.Settings = {};
--     self.LoadDetails = {};
--     self.SoftRes = {};
--     self.TMB = {};
--     self.BoostedRolls = {};

--     GL:success("Tables reset");
-- end
