---@type CL
local _, CL = ...;

local AceGUI = LibStub("AceGUI-3.0")
local DB = CL.DB; ---@type DB

-- A function that returns the total sum of itemscosts for a given character 
-- @param1 -- must be a table {} 
-- @param2 -- a string with the player name that is to be checked against the table in @param1

function getItemCostFromReceivedItems(table, name)
    --print(CL.DB.ReceivedItems["29916388432240283077"]["itemcost"])
local tempCost = 0 
    for key, value in pairs(table) do
        local splittedChecksum = CL:strSplit(key, '|') -- splittedChecksum[3] = characternavn
        if string.lower(splittedChecksum[3]) == name then
            tempCost = tempCost + table[key]["itemcost"]
            
        end         
    end
    return tempCost
end

function ShowPR()
    -- BEREGNE ENDELIG STANDING (PR)
    local Receiveditem = CL.DB.ReceivedItems
    local APGP = CL.DB.ImportedAPGP
    local cost = getItemCostFromReceivedItems(Receiveditem, getThisName)
    for character, data in pairs(APGP) do
        denominator = APGP[getThisName][1]["GP"] + cost
        if denominator == 0 then
            APGP[getThisName][1]["Score"] = 0
        else
            APGP[getThisName][1]["Score"] = APGP[getThisName][1]["AP"] / denominator
        end
        --print(character, APGP[getThisName][1]["Score"])
        --[[local database = CL.DB.ImportedAPGP
        datbase[character].GP = APGP["Score"]
        CL.DB.ImportedAPGP = database]]
    end 
end




--getItemCostFromReceivedItemstable(CL.DB.ReceivedItems)

--[[["ReceivedItems"] = {
		["29916388432240283077"] = {
			["checksum"] = "29916388432240283077",
			["character"] = "Tallefjompen",
			["prioreceived"] = false,
			["itemcost"] = 500,
			["timestamp"] = 1667665143,
			["itemlink"] = "|cffa335ee|Hitem:39714::::::::1:::::::::|h[Webbed Death]|h|r ",
			["itemId"] = "39714",
		},
		["16860378732240283077"] = {
			["checksum"] = "16860378732240283077",
			["character"] = "Tallefjompen",
			["prioreceived"] = false,
			["itemcost"] = 500,
			["timestamp"] = 1667665155,
			["itemlink"] = "|cffa335ee|Hitem:39714::::::::1:::::::::|h[Webbed Death]|h|r ",
			["itemId"] = "39714",]]
                
