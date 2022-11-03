-- Lager kolonner i ScrollingTable
--[[local columns = {
    --Player name
    {
        name = "Player",
        width = 130,
        align = "LEFT",
        color = {
            r = 0.5,
            g = 0.5,
            b = 1.0,
            a = 1.0
        },
        colorargs = nil,
    },
    --Standing APGP
    {
        name = "Standing",
        width = 65,
        align = "LEFT",
        color = {
            r = 0.5,
            g = 0.5,
            b = 1.0,
            a = 1.0
        },
        colorargs = nil,
        --defaultsort = ScrollingTable.descending,
    },
    --Attendance siste 4 uker 
    {
        name = "Attendance",
        width = 100,
        align = "LEFT",
        color = {
            r = 0.5,
            g = 0.5,
            b = 1.0,
            a = 1.0
        },
        colorargs = nil,
    },
    --Om du har fått Prio Item denne uka
    {
        name = "+1 PI",
        width = 65,
        align = "LEFT",
        color = {
            r = 0.5,
            g = 0.5,
            b = 1.0,
            a = 1.0
        },
        colorargs = nil,
    },
    --Om item er Prio for sortering
    {
        name = "",
        width = 150,
        align = "LEFT",
        color = {
            r = 0.5,
            g = 0.5,
            b = 1.0,
            a = 1.0
        },
        colorargs = nil,
    },
    
};

local WlChar = 



-- Verdier som skal fylles inn i kolonner
local Row = {
    cols = {
        {
            value = WlChar, --characters som har "itemId" på "Wishlist"
            color = {
                    r = 0,
                    g = 0,
                    b = 0,
                    a = 0
                },
            },
        {
            value = "PR", --"PR" som blir regnet ut med ShowPr()
            color = {
                    r = 0,
                    g = 0,
                    b = 0,
                    a = 0
                },
            },
        {
            value = "Attendance", --"Attendance" fra "APGP" (må legges til i export fra siden)
            color = {
                    r = 0,
                    g = 0,
                    b = 0,
                    a = 0
                },
            },
        {
            value = "priorecived", --"priorecived" fra "Reciveditem"
            color = {
                    r = 0,
                    g = 0,
                    b = 0,
                    a = 0
                },
            },
        {
            value = "prio", --["prio"] fra "Wishlist"
            color = {
                    r = 0,
                    g = 0,
                    b = 0,
                    a = 0
                },
            },
        
    },
};
local RollTableData = {}
tinsert(RollTableData, Row);



local Table = ScrollingTable:CreateST(columns, 8, 15, nil, Window.frame);
Table:SetWidth(510);
Table:EnableSelection(true)
Table.frame:SetPoint("BOTTOM", Window.frame, "BOTTOM", 0, 50);
Table:SetData(RollTableData)
Table:SortData();
--Table:SetDisplayRows(2, 15) endrer hvor mange Rows som er synlig
Table:Show()
Table:EnableSelection(true)]]--