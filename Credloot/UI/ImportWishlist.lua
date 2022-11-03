---@type CL
local _, CL = ...;

local AceGUI = LibStub("AceGUI-3.0")
local DB = CL.DB; ---@type DB


function ImportWishlist()
    local ImportWishlistWindow = AceGUI:Create("Frame")
    ImportWishlistWindow:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
    ImportWishlistWindow:SetTitle("Import Wishlist")
    ImportWishlistWindow:SetLayout("Flow")
    ImportWishlistWindow:SetWidth(400);
    ImportWishlistWindow:SetHeight(250);
    ImportWishlistWindow:EnableResize(false);
    ImportWishlistWindow.frame:SetFrameStrata("HIGH");
    ImportWishlistWindow.statustext:GetParent():Hide(); -- Hide the statustext bar

    --First Row
    local FirstRow = AceGUI:Create("SimpleGroup");
    FirstRow:SetLayout("Fill");
    FirstRow:SetFullWidth(true);
    FirstRow:SetHeight(150);
    ImportWishlistWindow:AddChild(FirstRow);

    -- Textarea
    local ImportText = AceGUI:Create("MultiLineEditBox");
    ImportText:SetLabel("Wishlist Import");
    ImportText:SetNumLines(20);
    ImportText:SetHeight(140);
    ImportText:SetMaxLetters(999999999);
    -- ImportText:DisableButton(true);
    ImportText:SetFocus();
    FirstRow:AddChild(ImportText);

    -- ImportText:SetCallback("OnTextChanged", function(_, _, text)
    -- end)
    ImportText:SetCallback("OnEnterPressed", function(_, _, text)
        ImportWishlistToDB(text)
    end)

    -- Import
    function ImportWishlistToDB(data)
        CL:debug("ImportWishlist.ImportWishlistToDB");

        if (type(data) ~= "string") then
            return CL:warning("Invalid data provided");
        end
        CL.DB.ImportedWishlist = {};

        -- If there are newlines, let's remove those!
        -- data = data:gsub("\r\n", "");

        local WishlistData = {};
        -- Format expected:
        -- Character:ItemId:IsPrio
        for line in data:gmatch("[^\n]+") do
            local segments = CL:strSplit(line, ":");
            local segmentCount = #segments;

            if (segmentCount < 3) then
                return CL:warning(string.format("Invalid data provided in line: '%s': missing character, item id or priority", line));
            end

            local character = strtrim(segments[1]);
            local itemId = strtrim(segments[2]);
            local isPrio = strtrim(segments[3]);
            if (isPrio == "true") then
                isPrio = true
            else
                isPrio = false
            end

            -- CL:dump(WishlistData)
            WishlistData[itemId] = WishlistData[itemId] or {}

            tinsert(WishlistData[itemId], {
                character = string.lower(character),
                itemId = itemId,
                isPrio = isPrio,
                itemId = itemId,
            });
        end

        CL.DB.ImportedWishlist = WishlistData;

        CL:success("Wishlists imported successfully");
    end
end
