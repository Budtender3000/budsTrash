local addonName, addonTable = ...

-- Global addon table access
_G.budsTrash = addonTable

-- Default database
addonTable.defaultDB = {
    blacklist = {}
}

function addonTable:GetItemIDFromLink(link)
    if not link then return nil end
    local id = string.match(link, "item:(%d+)")
    return tonumber(id) or tonumber(link)
end

function addonTable:Print(msg)
    print("|cFF00FF00budsTrash|r: " .. msg)
end

function addonTable:PrintError(msg)
    print("|cFFFF0000budsTrash|r: " .. msg)
end
