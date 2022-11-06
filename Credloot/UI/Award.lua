-- Dependencies: libs, bootstrap 
---@type CL
local _, CL = ...;

local AceGUI = LibStub("AceGUI-3.0")
local DB = CL.DB; ---@type DB


function ActualAwardItem() 
    --DB.ReceivedItems = {}
    if currentCharacterName == nil then
        rewardPlayerNameLabel:SetText("DU MÅ VELGE EN SPILLER I LISTEN UNDER")
        rewardPlayerNameLabel:SetColor(1, 0, 0)
    else
      
    function FindIsPrio()
        local IsPrio = CL.DB.ImportedWishlist[tostring(currentItemId)]  
        for k, data in pairs(IsPrio) do
                for j, v in pairs(data) do
                    if v == string.lower(currentCharacterName) then
                        return data.isPrio
                    end
                end
        end
    end 
        
    function findItemCost()
        local ItemCost = CL.DB.ImportedWishlist[tostring(currentItemId)]  
        for k, data in pairs(ItemCost) do
                for j, v in pairs(data) do
                    if v == string.lower(currentCharacterName) then
                        return data.itemcost
                    end
                end
        end
    end
    
    local timestamp;
    local dateProvided = date and type(date) == "string";

    if (not dateProvided and type(date) == "number") then
        timestamp = date;
    else
        timestamp = GetServerTime();
    end

    local currentIsPrio = FindIsPrio()
    local currentItemCost = findItemCost()
    local itemLink = gItemLink
    --local checksum = CL:strPadRight(CL:strLimit(CL:stringHash(timestamp .. currentItemId) .. CL:stringHash(currentCharacterName), 20, ""), "0", 20)
    local checksum = timestamp.."|"..currentItemId.."|"..currentCharacterName
    --table legger loot i ReceivedItems
    local table = {
        checksum = checksum,
        character = currentCharacterName,
        itemId = currentItemId,
        itemlink = itemLink,
        prioreceived = currentIsPrio,
        itemcost = currentItemCost,
        timestamp = timestamp
        }

    DB.ReceivedItems[checksum] = table
    DB:store()
    end
end

