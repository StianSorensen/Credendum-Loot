---@type CL
local _, CL = ...;

local AceGUI = LibStub("AceGUI-3.0")
local DB = CL.DB; ---@type DB


function ImportAPGP()
    local ImportAPGPWindow = AceGUI:Create("Frame")
    ImportAPGPWindow:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
    ImportAPGPWindow:SetTitle("Import APGP")
    ImportAPGPWindow:SetLayout("Flow")
    ImportAPGPWindow:SetWidth(400);
    ImportAPGPWindow:SetHeight(250);
    ImportAPGPWindow:EnableResize(false);
    ImportAPGPWindow.frame:SetFrameStrata("HIGH");
    ImportAPGPWindow.statustext:GetParent():Hide(); -- Hide the statustext bar

    --First Row
    local FirstRow = AceGUI:Create("SimpleGroup");
    FirstRow:SetLayout("Fill");
    FirstRow:SetFullWidth(true);
    FirstRow:SetHeight(150);
    ImportAPGPWindow:AddChild(FirstRow);

    -- Textarea
    local ImportText = AceGUI:Create("MultiLineEditBox");
    ImportText:SetLabel("APGP Import");
    ImportText:SetNumLines(20);
    ImportText:SetHeight(140);
    ImportText:SetMaxLetters(999999999);
    -- ImportText:DisableButton(true);
    ImportText:SetFocus();
    FirstRow:AddChild(ImportText);

    -- ImportText:SetCallback("OnTextChanged", function(_, _, text)
    -- end)
    ImportText:SetCallback("OnEnterPressed", function(_, _, text)
        ImportAPGPToDB(text)
    end)

    -- Import
    function ImportAPGPToDB(data)
        CL:debug("ImportAPGP.ImportAPGPToDB");

        if (type(data) ~= "string") then
            return CL:warning("Invalid data provided");
        end
        CL.DB.ImportedAPGP = {};

        -- If there are newlines, let's remove those!
        -- data = data:gsub("\r\n", "");

        local APGPData = {};
        -- Format expected:
        -- Character:AP:GP:Attendance:ReceivedPrioItemThisReset:LastUpdated
        for line in data:gmatch("[^\n]+") do
            local segments = CL:strSplit(line, ":");
            local segmentCount = #segments;

            if (segmentCount < 7) then
                return CL:warning(string.format("Invalid data provided in line: '%s'", line));
            end

            local character = string.lower(strtrim(segments[1]));
            local AP = strtrim(segments[2]);
            local GP = strtrim(segments[3]);
            local Score = strtrim(segments[4]);
            local Attendance = strtrim(segments[5]);
            local ReceivedPrioItemThisReset = strtrim(segments[6]);
            local LastUpdated = strtrim(segments[7]);
            if (ReceivedPrioItemThisReset == "true") then
                ReceivedPrioItemThisReset = true
            else
                ReceivedPrioItemThisReset = false
            end

            if (tonumber(GP) ~= nil) then
                GP = tonumber(GP);
            end
            if (tonumber(AP) ~= nil) then
                AP = tonumber(AP);
            end

            APGPData[character] = {};
            local row = {
                ["AP"] = AP,
                ["GP"] = GP,
                ["Score"] = Score,
                ["Attendance"] = Attendance,
                ["ReceivedPrioItemThisReset"] = ReceivedPrioItemThisReset,
                ["LastUpdated"] = LastUpdated,
            }
            tinsert(APGPData[character], row);
        end

        CL.DB.ImportedAPGP = APGPData;

        CL:success("APGPs imported successfully");
    end
end
