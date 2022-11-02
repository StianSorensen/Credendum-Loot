--Liste med alle navn i Wishlist på en item
function returnWishlistNametest(table, itemId)
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