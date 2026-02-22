local addonName, addonTable = ...

SLASH_BUDSTRASH1 = "/bt"
SLASH_BUDSTRASH2 = "/budstrash"

SlashCmdList["BUDSTRASH"] = function(msg)
    local command, rest = msg:match("^(%S*)%s*(.-)$")
    command = command and command:lower() or ""

    if command == "add" and rest ~= "" then
        local itemID = addonTable:GetItemIDFromLink(rest)
        if itemID then
            budsTrashDB.blacklist[itemID] = true
            addonTable:Print("Added " .. rest .. " to blacklist.")
        else
            addonTable:PrintError("Invalid item. Use /bt add [Shift-Click Item]")
        end
    elseif command == "remove" and rest ~= "" then
        local itemID = addonTable:GetItemIDFromLink(rest)
        if itemID and budsTrashDB.blacklist[itemID] then
            budsTrashDB.blacklist[itemID] = nil
            addonTable:Print("Removed " .. rest .. " from blacklist.")
        else
            addonTable:PrintError("Item not found in blacklist.")
        end
    elseif command == "list" then
        print("|cFF00FF00budsTrash Blacklist:|r")
        local count = 0
        for id, _ in pairs(budsTrashDB.blacklist) do
            local itemName, itemLink = GetItemInfo(id)
            print(itemLink or ("Item ID: " .. id))
            count = count + 1
        end
        if count == 0 then
            print("Your blacklist is empty.")
        end
    else
        print("|cFF00FF00budsTrash Commands:|r")
        print("  /bt add [Item Link] - Adds an item to the blacklist")
        print("  /bt remove [Item Link] - Removes an item")
        print("  /bt list - Shows all blacklisted items")
    end
end
