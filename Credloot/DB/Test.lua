Reciveditem = {
    ["zypha"] = {
        {
            ["itemId"] = "40332",
            ["prio"] = 0,
            ["itemcost"] = 500,
        }, -- [1]
        {
            ["itemId"] = "40724",
            ["prio"] = 1,
            ["itemcost"] = 750,
        }, -- [2]
    },
    ["mentop"] = {
        {
            ["itemId"] = "40724",
            ["prio"] = 1,
            ["itemcost"] = 750,
        }, -- [1]
    }
}
            
APGP = {
    ["zypha"] = {
        ["AP"] = 1300,
        ["GP"] = 650,
        ["sum_cost"] = 0
    }, -- [1]
    ["theintersect"] = {
        ["AP"] = 1500,
        ["GP"] = 1000,
        ["sum_cost"] = 0
    }, -- [2]
    ["mindlini"] = {
        ["AP"] = 600,
        ["GP"] = 50,
        ["sum_cost"] = 0
    }, -- [3]
    ["mentop"] = {
        ["AP"] = 1500,
        ["GP"] = 780,
        ["sum_cost"] = 0
    }, -- [4]
}

--[[-- Go over all received items
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
end]]--
