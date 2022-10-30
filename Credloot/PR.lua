

function ShowPR()

-- Go over all received items
for character, items in pairs(Reciveditem) do
    -- Since the character can receive more than 1 item, loop all the items for that character
    for k, item in pairs(items) do
        -- Ensure character exists in APGP table
        if (APGP[character]) then
            APGP[character]["sum_cost"] = APGP[character]["sum_cost"] + item["itemcost"]
        end
    end
end

-- Finnally, go over all APGP rows to calculate final PR
for character, data in pairs(APGP) do
    denominator = APGP[character]["GP"] + (APGP[character]["sum_cost"] or 0)
    if denominator == 0 then
        APGP[character]["PR"] = 0
    else
        APGP[character]["PR"] = APGP[character]["AP"] / denominator
    end
    print(character, APGP[character]["PR"])
    
end   
end

for items, character in pairs(Wishlist) do
    --if Whislist[items] == itemID then
        print(items[character])
    --end
end