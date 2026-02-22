local addonName, addonTable = ...

-- Create the options panel
local panel = CreateFrame("Frame", "budsTrashOptionsPanel", UIParent)
panel.name = "budsTrash"

-- Title
local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("budsTrash Blacklist Options")

-- Description
local desc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
desc:SetText("Add or remove items you want to automatically delete when looted.")

-- Input Box for Item Link / ID
local itemInput = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
itemInput:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 10, -20)
itemInput:SetSize(200, 30)
itemInput:SetAutoFocus(false)

local inputLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
inputLabel:SetPoint("BOTTOMLEFT", itemInput, "TOPLEFT", 0, 0)
inputLabel:SetText("Item Link or ID:")

-- Add Button
local btnAdd = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
btnAdd:SetPoint("LEFT", itemInput, "RIGHT", 10, 0)
btnAdd:SetSize(80, 22)
btnAdd:SetText("Add")
btnAdd:SetScript("OnClick", function()
    local text = itemInput:GetText()
    local itemID = addonTable:GetItemIDFromLink(text)
    if itemID then
        budsTrashDB.blacklist[itemID] = true
        addonTable:Print("Added item to blacklist.")
        itemInput:SetText("")
        itemInput:ClearFocus()
        panel:UpdateList()
    else
        addonTable:PrintError("Invalid Item Link or ID.")
    end
end)

-- Remove Button
local btnRemove = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
btnRemove:SetPoint("LEFT", btnAdd, "RIGHT", 5, 0)
btnRemove:SetSize(80, 22)
btnRemove:SetText("Remove")
btnRemove:SetScript("OnClick", function()
    local text = itemInput:GetText()
    local itemID = addonTable:GetItemIDFromLink(text)
    if itemID and budsTrashDB.blacklist[itemID] then
        budsTrashDB.blacklist[itemID] = nil
        addonTable:Print("Removed item from blacklist.")
        itemInput:SetText("")
        itemInput:ClearFocus()
        panel:UpdateList()
    else
        addonTable:PrintError("Item not found in blacklist.")
    end
end)

-- The Blacklist Display Area (Simple multi-line string)
local listScroll = CreateFrame("ScrollFrame", "budsTrashScrollFrame", panel, "UIPanelScrollFrameTemplate")
listScroll:SetPoint("TOPLEFT", itemInput, "BOTTOMLEFT", -5, -20)
listScroll:SetSize(350, 250)

local listText = CreateFrame("EditBox", nil, listScroll)
listText:SetMultiLine(true)
listText:SetSize(350, 250)
listText:SetAutoFocus(false)
listText:SetFontObject("GameFontHighlight")
listText:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
listScroll:SetScrollChild(listText)

-- Update List Function
function panel:UpdateList()
    local text = ""
    for id, _ in pairs(budsTrashDB.blacklist) do
        local itemName, itemLink = GetItemInfo(id)
        if itemLink then
            text = text .. itemLink .. "\n"
        else
            text = text .. "Item ID: " .. id .. " (Not Cached)\n"
        end
    end
    if text == "" then
        text = "Your blacklist is empty."
    end
    listText:SetText(text)
end

panel:SetScript("OnShow", function()
    panel:UpdateList()
end)

-- Register the Options Panel
InterfaceOptions_AddCategory(panel)
