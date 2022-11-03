---@type CL
local _, CL = ...;

-- A function that returns the total sum of itemscosts for a given character 
-- @param1 -- must be a table {} 
-- @param2 -- a string with the player name that is to be checked against the table in @param1
function sumItemCost(table, playerName)
    local sumItems = 0 -- the sum cost of all items recieved
    for index, data in pairs(table) do
        if data.character == playerName then
            for key, value in pairs(data) do
                if value.itemcost then
                    sumItems = sumItems + tonumber(value.itemcost)
                end
            end
        end    
    end
    return sumItems
end

function ShowPR()
    -- BEREGNE ENDELIG STANDING (PR)
    local Reciveditem = CL.DB.ReceivedItems
    local APGP = CL.DB.ImportedAPGP
    for character, data in pairs(APGP) do
        denominator = APGP["GP"] + sumItemCost(Reciveditem, character)
        if denominator == 0 then
            APGP["Score"] = 0
        else
            APGP["Score"] = APGP["AP"] / denominator
        end
        print(character, APGP["Score"])
        --[[local database = CL.DB.ImportedAPGP
        datbase[character].GP = APGP["Score"]
        CL.DB.ImportedAPGP = database]]
    end 
end




