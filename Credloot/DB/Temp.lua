--[[function MasterLooterUI:drawPlayersTable(parent)
    --GL:debug("MasterLooterUI:drawPlayersTable");

    -- Combined width of all colums should be 340
    --(local columns = {
        --[[ Player name ]]
        {
            name = "Player",
            width = 120,
            align = "LEFT",
            color = {
                r = 0.5,
                g = 0.5,
                b = 1.0,
                a = 1.0
            },
            colorargs = nil,
        },
        --[[ Roll ]]
        {
            name = "Roll",
            width = 35,
            align = "LEFT",
            color = {
                r = 0.5,
                g = 0.5,
                b = 1.0,
                a = 1.0
            },
            colorargs = nil,
            defaultsort = GL.Data.Constants.ScrollingTable.descending,
        },
        --[[ +1 ]]
        {
            name = "+1",
            width = 35,
            align = "LEFT",
            color = {
                r = 0.5,
                g = 0.5,
                b = 1.0,
                a = 1.0
            },
            colorargs = nil,
        },
        --[[ ROLL TYPE: MS/OS etc ]]
        {
            name = "Type",
            width = 63,
            align = "LEFT",
            color = {
                r = 0.5,
                g = 0.5,
                b = 1.0,
                a = 1.0
            },
            colorargs = nil,
        },
        --[[ Reserved / TMB etc ]]
        {
            name = "Note",
            width = 88,
            align = "LEFT",
            color = {
                r = 0.5,
                g = 0.5,
                b = 1.0,
                a = 1.0
            },
            colorargs = nil,
        },
        --[[ PRIORITY (NOT VISIBLE, FOR SORTING ONLY! ]]
        {
            name = "",
            width = 1,
            align = "LEFT",
            color = {
                r = 0,
                g = 0,
                b = 0,
                a = 0
            },
            colorargs = nil,
            sort = GL.Data.Constants.ScrollingTable.ascending,
            sortnext = 2,
        },
    };

    local Table = ScrollingTable:CreateST(columns, 8, 15, nil, parent);
    Table:SetWidth(340);
    Table:EnableSelection(true);]]--