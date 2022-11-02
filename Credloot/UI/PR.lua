
--Liste over alle som har item på wishlist og hvilke prio
function ShowWL()


returnWishlistName(Wishlist2, WLitemId)
final_table = playersInRaidThatWantItem(raidNameCheck, wishlistNameCheck)

for k,v in pairs(returnWishlistName) do
    print(v)
end
end

function checkRaid()
    WlPrio = raidName()
    for k, v in pairs(WlPrio) do
    print(v)
end
end

function ShowWL2()
    for k, v in pairs(returnWishlistName(Wishlist2, WLitemId)) do
        print(v)
    end

end

-- Regner ut summen av cost på alle items fått i raidet
function sumItemCost(table, playerName)
    local sumItems = 0-- the sum cost of all items recieved
    for index, data in pairs(table) do
        if index == playerName then
            for key, value in pairs(data) do
                if value.itemcost then
                    sumItems = sumItems + tonumber(value.itemcost)
                end
            end
        end    
    end
    return sumItems
end

-- Bergener Standing(PR)
function ShowStanding()

    for character, data in pairs(APGP) do
    denominator = APGP[character]["GP"] + sumItemCost(Reciveditem, character) --(APGP[character]["sum_cost"] or 0)
    if denominator == 0 then
        APGP[character]["PR"] = 0
    else
        APGP[character]["PR"] = APGP[character]["AP"] / denominator
    end
    print(character, APGP[character]["PR"])
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
                        -- if value.prio == true then
                        if UnitInRaid(value.character) ~= nil then
                        -- if UnitInRaid(value.character) >= 1 then
                            tinsert(wishListName, value.character)
                        end
					end
				end
			end
		end
	end
    return wishListName
end



