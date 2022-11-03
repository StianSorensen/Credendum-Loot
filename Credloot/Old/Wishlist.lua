Wishlist = {
			["2092"] = {
				["zhypa"] =
					{
						["prio"] = 1,
						["type"] = 2,
					}, -- [1]
				["theintersect"] =
					{
						["prio"] = 9,
						["type"] = 2,
					}, -- [2]
				["mindlini"] =
					{
						["prio"] = 9,
						["type"] = 2,
					}, -- [3]
				["mentop"] =
					{	
						["prio"] = 9,
						["type"] = 2,
					}, -- [4]
						},
			["40724"] = {
				["zhypa"] =
					{
						["prio"] = 1,
						["type"] = 2,
					}, -- [1]
				["theintersect"] =
					{
						["prio"] = 9,
						["type"] = 2,
					}, -- [2]
				["mindlini"] =
					{
						["prio"] = 9,
						["type"] = 2,
					}, -- [3]
				["mentop"] =
					{
						["prio"] = 9,
						["type"] = 2,
					}, -- [4]
						}
			}

Wishlist2 = {
	["2092"] = {
		{
			["character"] = "Zhypa",
			["prio"] = 1,
			["type"] = 2,
		}, -- [1]
		{
			["character"] = "Uitest",
			["prio"] = 2,
			["type"] = 2,
		}, -- [2]
		{
			["character"] = "Mindlini",
			["prio"] = 2,
			["type"] = 2,
		}, -- [3]
		{
			["character"] = "Tallefjompen",
			["prio"] = 1,
			["type"] = 2,
		}, -- [4]
				},
	["35"] = {
		{
			["character"] = "Tallefjompen",
			["prio"] = 1,
			["type"] = 2,
		}, -- [1]
		{
			["character"] = "toadin",
			["prio"] = 2,
			["type"] = 2,
		}, -- [2]
		{
			["character"] = "Uitest",
			["prio"] = 2,
			["type"] = 2,
		}, -- [3]
		{
			["character"] = "Mentop",
			["prio"] = 2,
			["type"] = 2,
		}, -- [4]
				}
	}


-- Sjekker hvem som har itemet på wishlist og deler opp i to lister basert på prio
--[[function createScoreListTest(table, itemId)

	for k,v in pairs(table) do

		if tonumber(k) == tonumber(itemId) then 

			prio1Table = {}
			prio2Table = {}

			for index, data in pairs(table) do

				if tonumber(index) == tonumber(itemId) then

					for key, value in pairs(data) do

						if value.prio == 1 then

							prio1Table[value.character] = value.prio
                            
						elseif value.prio == 2 then

							prio2Table[value.character] = value.prio

						end
					end
				end
			end
			

			for k, v in pairs(prio1Table) do -- printing out the tables to see values
				print(k,v)
			end
			for k, v in pairs(prio2Table) do 
				print(k,v) 
			end
		end
	end
end

--Liste med alle navn i Wishlist på en item

function returnWishlistName(table, itemId)

	for k,v in pairs(table) do

		if tonumber(k) == tonumber(itemId) then 

			wishListName = {}

			for index, data in pairs(table) do

				if tonumber(index) == tonumber(itemId) then

					for key, value in pairs(data) do

						if value.prio == 1 or value.prio == 2 then

							tinsert(wishListName, value.character)
                            
						end
					end
				end
			end
			

			for k, v in pairs(wishListName) do -- printing out the tables to see values
				print(v)
			end

		end
	end
end

--Lager en tabell som inneholder alle spillere i raidet
function raidName()
	--local init = UnitInRaid("player")
	--if init == nil then 

		local raidNameTable = {}
		local members = GetNumGroupMembers(); 

		for i=1, members, 1 do
			name = UnitName("raid"..i)

			tinsert(raidNameTable, name)

		end
		
		return raidNameTable
	--else return end

end

function playersInRaidThatWantItem(table1, table2)
	local compareMatch = {}
	-- check that both tables contains something
	if table1 ~= nil and table2 ~= nil then
		for k, v in pairs(table1) do 
			for l, x in pairs(table2) do
				if v == x then
					tinsert(compareMatch, v)                                      
				end
			end
		end
	end
		
	if compareMatch ~= nil then
		return compareMatch
	else 
		return "no matches"
	end    
end
local a = playersInRaidThatWantItem(wishListName, raidName)
	
for k, v in pairs(a) do
	print(v)
end]]   
