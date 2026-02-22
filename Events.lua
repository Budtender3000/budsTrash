local addonName, addonTable = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("BAG_UPDATE")

local isDeleting = false

local function DeleteBlacklistedItems()
    if isDeleting then return end

    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink then
                local itemID = addonTable:GetItemIDFromLink(itemLink)
                if itemID and budsTrashDB and budsTrashDB.blacklist and budsTrashDB.blacklist[itemID] then
                    local _, _, locked = GetContainerItemInfo(bag, slot)

                    if not locked and not CursorHasItem() then
                        isDeleting = true
                        PickupContainerItem(bag, slot)
                        
                        -- Delete the item
                        DeleteCursorItem()
                        
                        -- Auto-confirm if a "DELETE_ITEM" or "DELETE_GOOD_ITEM" popups appears
                        if StaticPopup_Visible("DELETE_GOOD_ITEM") then
                            StaticPopup_OnClick(StaticPopup1, 1)
                        elseif StaticPopup_Visible("DELETE_ITEM") then
                            StaticPopup_OnClick(StaticPopup1, 1)
                        end

                        addonTable:Print("Deleted " .. itemLink)
                        isDeleting = false
                        return -- Return to avoid multiple deletes in same frame locking the UI
                    end
                end
            end
        end
    end
end

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        budsTrashDB = budsTrashDB or addonTable.defaultDB
        print("|cFF00FF00budsTrash|r loaded. Type /bt to see options.")
        self:UnregisterEvent("ADDON_LOADED")
    elseif event == "BAG_UPDATE" then
        DeleteBlacklistedItems()
    end
end)
