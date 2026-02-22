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
                        
                        -- Handle Delete Confirmation Popups
                        for i = 1, STATICPOPUP_NUMDIALOGS do
                            local dialog = _G["StaticPopup"..i]
                            if dialog and dialog:IsVisible() and (dialog.which == "DELETE_ITEM" or dialog.which == "DELETE_GOOD_ITEM") then
                                if dialog.editBox and dialog.editBox:IsVisible() then
                                    dialog.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
                                end
                                local button = _G["StaticPopup"..i.."Button1"]
                                if button then
                                    button:Click()
                                end
                                break
                            end
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
        budsTrashDB = budsTrashDB or {}
        budsTrashDB.blacklist = budsTrashDB.blacklist or {}
        print("|cFF00FF00budsTrash|r loaded. Type /bt to see options.")
        self:UnregisterEvent("ADDON_LOADED")
    elseif event == "BAG_UPDATE" then
        DeleteBlacklistedItems()
    end
end)
