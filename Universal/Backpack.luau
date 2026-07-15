if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Shared = (function()
    local Success, Env = pcall(getgenv)
    return (Success and Env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local function expect(expected, value, fallback)
    if type(value) == expected then
        return value
    end
    if fallback ~= nil then
        if type(fallback) == "function" then
            return function(...)
                warn("[Expect]: Missing executor functionality. Using fallback function.")
                return fallback(...)
            end
        end
        warn("[Expect]: Value has unexpected type. Using fallback value.")
    end
    return fallback
end

local cloneref = expect("function", cloneref, function(...) return ... end)

local Services = setmetatable({}, {
    __index = function(self, name)
        local success, cache = pcall(function()
            return cloneref(game:GetService(name))
        end)
        if success then
            rawset(self, name, cache)
            return cache
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

local Hui = (gethui and gethui()) or Services.CoreGui
local Players = Services.Players
local StarterGui = Services.StarterGui
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

Shared.__Inventory = Shared.__Inventory or {}

if Shared.__Inventory.IsLoaded then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Inventory",
            Text = "Inventory is already running!",
            Icon = "rbxasset://textures/ui/TopBar/inventoryOn.png",
            Duration = 4
        })
    end)
    return
end

Shared.__Inventory.IsLoaded = true

local TopbarPlus = PlayerGui:FindFirstChild("TopbarStandard")
if TopbarPlus and TopbarPlus:FindFirstChild("Holders") and TopbarPlus.Holders:FindFirstChild("Left") then
    TopbarPlus = TopbarPlus.Holders.Left
end
local Fallback = Services.CoreGui:FindFirstChild("TopBarApp")
if Fallback then Fallback = Fallback:FindFirstChild("TopBarApp") end
if Fallback then Fallback = Fallback:FindFirstChild("TopBarFrame") end

local UI = {}

UI.BackpackBtn = Instance.new("Frame")
UI.BackpackBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
UI.BackpackBtn.BackgroundTransparency = 0.08
UI.BackpackBtn.BorderSizePixel = 0
UI.BackpackBtn.LayoutOrder = -2147483647
UI.BackpackBtn.Name = "__TB_Backpack"
UI.BackpackBtn.Position = UDim2.fromOffset(214, 2)
UI.BackpackBtn.Size = UDim2.fromOffset(44, 44)
UI.BackpackBtn.Parent = TopbarPlus or Fallback or Hui

UI.Corner = Instance.new("UICorner")
UI.Corner.CornerRadius = UDim.new(1, 0)
UI.Corner.Name = "Corner"
UI.Corner.Parent = UI.BackpackBtn

UI.Backpack = Instance.new("ImageButton")
UI.Backpack.AnchorPoint = Vector2.new(0.5, 0.5)
UI.Backpack.AutoButtonColor = true
UI.Backpack.BackgroundTransparency = 1
UI.Backpack.BorderSizePixel = 0
UI.Backpack.Image = "rbxasset://textures/ui/TopBar/inventoryOff.png"
UI.Backpack.Name = "Icon"
UI.Backpack.Position = UDim2.fromScale(0.5, 0.5)
UI.Backpack.Size = UDim2.fromOffset(36, 36)
UI.Backpack.Parent = UI.BackpackBtn

UI.InvGui = Instance.new("ScreenGui")
UI.InvGui.Name = "__Inventory"
UI.InvGui.ResetOnSpawn = false
UI.InvGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.InvGui.Parent = Hui

UI.MainUI = Instance.new("Frame")
UI.MainUI.AnchorPoint = Vector2.new(0.5, 1)
UI.MainUI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.MainUI.BackgroundTransparency = 1
UI.MainUI.BorderSizePixel = 0
UI.MainUI.Name = "UI"
UI.MainUI.Position = UDim2.new(0.5, 0, 1, -6)
UI.MainUI.Size = UDim2.new(0.5, 28, 0.9, 0)
UI.MainUI.Parent = UI.InvGui

UI.UILayout = Instance.new("UIListLayout")
UI.UILayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.UILayout.Name = "UILayout"
UI.UILayout.Padding = UDim.new(0, 4)
UI.UILayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.UILayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
UI.UILayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.UILayout.Parent = UI.MainUI

UI.BackpackFrame = Instance.new("CanvasGroup")
UI.BackpackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.BackpackFrame.BackgroundTransparency = 0.3
UI.BackpackFrame.BorderSizePixel = 0
UI.BackpackFrame.LayoutOrder = 1
UI.BackpackFrame.Name = "Backpack"
UI.BackpackFrame.Size = UDim2.new(0.2, 0, 0.3, 0)
UI.BackpackFrame.Parent = UI.MainUI
UI.BackpackFrame:SetAttribute("IsBackpackRegion", true)

UI.BackpackCorner = Instance.new("UICorner")
UI.BackpackCorner.CornerRadius = UDim.new(0, 6)
UI.BackpackCorner.Name = "BackpackCorner"
UI.BackpackCorner.Parent = UI.BackpackFrame

UI.Topbar = Instance.new("Frame")
UI.Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.Topbar.BackgroundTransparency = 1
UI.Topbar.BorderSizePixel = 0
UI.Topbar.Name = "Topbar"
UI.Topbar.Size = UDim2.new(0.2, 0, 0.3, 0)
UI.Topbar.Parent = UI.BackpackFrame

UI.SearchBox = Instance.new("TextBox")
UI.SearchBox.AnchorPoint = Vector2.new(1, 0)
UI.SearchBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.SearchBox.BackgroundTransparency = 0.6
UI.SearchBox.BorderSizePixel = 0
UI.SearchBox.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI.SearchBox.Name = "SearchBox"
UI.SearchBox.PlaceholderColor3 = Color3.fromRGB(111, 111, 111)
UI.SearchBox.PlaceholderText = "Search"
UI.SearchBox.Position = UDim2.new(1, 0, 0, 0)
UI.SearchBox.Size = UDim2.new(0.45, 0, 1, 0)
UI.SearchBox.Text = ""
UI.SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.SearchBox.TextScaled = true
UI.SearchBox.TextWrapped = true
UI.SearchBox.TextXAlignment = Enum.TextXAlignment.Left
UI.SearchBox.Parent = UI.Topbar

UI.SearchBoxStroke = Instance.new("UIStroke")
UI.SearchBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SearchBoxStroke.Color = Color3.fromRGB(255, 255, 255)
UI.SearchBoxStroke.Name = "SearchBoxStroke"
UI.SearchBoxStroke.Thickness = 0.9
UI.SearchBoxStroke.Transparency = 0.8
UI.SearchBoxStroke.Parent = UI.SearchBox

UI.SearchBoxPadding = Instance.new("UIPadding")
UI.SearchBoxPadding.Name = "SearchBoxPadding"
UI.SearchBoxPadding.PaddingBottom = UDim.new(0, 6)
UI.SearchBoxPadding.PaddingLeft = UDim.new(0, 6)
UI.SearchBoxPadding.PaddingRight = UDim.new(0, 6)
UI.SearchBoxPadding.PaddingTop = UDim.new(0, 6)
UI.SearchBoxPadding.Parent = UI.SearchBox

UI.SearchBoxCorner = Instance.new("UICorner")
UI.SearchBoxCorner.CornerRadius = UDim.new(0, 3)
UI.SearchBoxCorner.Name = "SearchBoxCorner"
UI.SearchBoxCorner.Parent = UI.SearchBox

UI.TopbarSizeCons = Instance.new("UISizeConstraint")
UI.TopbarSizeCons.MaxSize = Vector2.new(9999, 34)
UI.TopbarSizeCons.MinSize = Vector2.new(0, 34)
UI.TopbarSizeCons.Name = "TopbarSizeCons"
UI.TopbarSizeCons.Parent = UI.Topbar

UI.TopbarPadding = Instance.new("UIPadding")
UI.TopbarPadding.Name = "TopbarPadding"
UI.TopbarPadding.PaddingBottom = UDim.new(0, 4)
UI.TopbarPadding.PaddingLeft = UDim.new(0, 4)
UI.TopbarPadding.PaddingRight = UDim.new(0, 4)
UI.TopbarPadding.PaddingTop = UDim.new(0, 4)
UI.TopbarPadding.Parent = UI.Topbar

UI.BackpackLayout = Instance.new("UIListLayout")
UI.BackpackLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.BackpackLayout.Name = "BackpackLayout"
UI.BackpackLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.BackpackLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.BackpackLayout.Parent = UI.BackpackFrame

UI.ToolsFrame = Instance.new("Frame")
UI.ToolsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.ToolsFrame.BackgroundTransparency = 1
UI.ToolsFrame.BorderSizePixel = 0
UI.ToolsFrame.Name = "ToolsFrame"
UI.ToolsFrame.Size = UDim2.new(0.2, 0, 0.3, 0)
UI.ToolsFrame.Parent = UI.BackpackFrame

UI.Tools = Instance.new("ScrollingFrame")
UI.Tools.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.Tools.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.Tools.BackgroundTransparency = 1
UI.Tools.BorderSizePixel = 0
UI.Tools.Name = "Tools"
UI.Tools.ScrollBarThickness = 6
UI.Tools.ScrollingDirection = Enum.ScrollingDirection.Y
UI.Tools.Size = UDim2.new(1, 8, 1, 0)
UI.Tools.Parent = UI.ToolsFrame

UI.ToolsPadding = Instance.new("UIPadding")
UI.ToolsPadding.Name = "ToolsPadding"
UI.ToolsPadding.PaddingBottom = UDim.new(0, 6)
UI.ToolsPadding.PaddingLeft = UDim.new(0, 6)
UI.ToolsPadding.PaddingRight = UDim.new(0, 8)
UI.ToolsPadding.PaddingTop = UDim.new(0, 6)
UI.ToolsPadding.Parent = UI.Tools

UI.ToolsLayout = Instance.new("UIGridLayout")
UI.ToolsLayout.CellPadding = UDim2.new(0, 8, 0, 8)
UI.ToolsLayout.CellSize = UDim2.new(0, 60, 0, 60)
UI.ToolsLayout.Name = "ToolsLayout"
UI.ToolsLayout.Parent = UI.Tools

UI.HotbarFrame = Instance.new("Frame")
UI.HotbarFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.HotbarFrame.BackgroundTransparency = 1
UI.HotbarFrame.BorderSizePixel = 0
UI.HotbarFrame.LayoutOrder = 2
UI.HotbarFrame.Name = "Hotbar"
UI.HotbarFrame.Size = UDim2.new(0, 386, 0, 44)
UI.HotbarFrame.Parent = UI.MainUI

UI.HotbarSizeCons = Instance.new("UISizeConstraint")
UI.HotbarSizeCons.MaxSize = Vector2.new(2147483648, 60)
UI.HotbarSizeCons.Name = "HotbarSizeCons"
UI.HotbarSizeCons.Parent = UI.HotbarFrame

UI.HotbarLayout = Instance.new("UIListLayout")
UI.HotbarLayout.FillDirection = Enum.FillDirection.Horizontal
UI.HotbarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UI.HotbarLayout.HorizontalFlex = Enum.UIFlexAlignment.None
UI.HotbarLayout.Name = "HotbarLayout"
UI.HotbarLayout.Padding = UDim.new(0, 8)
UI.HotbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.HotbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.HotbarLayout.Parent = UI.HotbarFrame

UI.SlotWrapperTemplate = Instance.new("Frame")
UI.SlotWrapperTemplate.BackgroundTransparency = 1
UI.SlotWrapperTemplate.BorderSizePixel = 0
UI.SlotWrapperTemplate.Name = "SlotWrapper"
UI.SlotWrapperTemplate.Size = UDim2.new(0, 44, 1, 0)

UI.SlotWrapperCorner = Instance.new("UICorner")
UI.SlotWrapperCorner.CornerRadius = UDim.new(0, 6)
UI.SlotWrapperCorner.Name = "WrapperCorner"
UI.SlotWrapperCorner.Parent = UI.SlotWrapperTemplate

UI.ToolButtonTemplate = Instance.new("ImageButton")
UI.ToolButtonTemplate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.ToolButtonTemplate.BackgroundTransparency = 0.4
UI.ToolButtonTemplate.BorderSizePixel = 0
UI.ToolButtonTemplate.LayoutOrder = -1
UI.ToolButtonTemplate.Name = "Slot"
UI.ToolButtonTemplate.Size = UDim2.new(0, 44, 1, 0)

UI.HTCorner = Instance.new("UICorner")
UI.HTCorner.CornerRadius = UDim.new(0, 6)
UI.HTCorner.Name = "SlotCorner"
UI.HTCorner.Parent = UI.ToolButtonTemplate

UI.HTIcon = Instance.new("ImageLabel")
UI.HTIcon.AnchorPoint = Vector2.new(0.5, 0.5)
UI.HTIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.HTIcon.BackgroundTransparency = 1
UI.HTIcon.BorderSizePixel = 0
UI.HTIcon.Interactable = false
UI.HTIcon.Name = "SlotIcon"
UI.HTIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.HTIcon.ScaleType = Enum.ScaleType.Fit
UI.HTIcon.Size = UDim2.new(1, -8, 1, -8)
UI.HTIcon.Parent = UI.ToolButtonTemplate

UI.HTStroke = Instance.new("UIStroke")
UI.HTStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.HTStroke.Color = Color3.fromRGB(0, 0, 0)
UI.HTStroke.Name = "SlotStroke"
UI.HTStroke.Thickness = 2
UI.HTStroke.Transparency = 0.5
UI.HTStroke.Parent = UI.ToolButtonTemplate

UI.HTRatio = Instance.new("UIAspectRatioConstraint")
UI.HTRatio.Name = "SlotRatio"
UI.HTRatio.Parent = UI.ToolButtonTemplate

UI.HTLabel = Instance.new("TextLabel")
UI.HTLabel.AnchorPoint = Vector2.new(0.5, 0.5)
UI.HTLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.HTLabel.BackgroundTransparency = 1
UI.HTLabel.BorderSizePixel = 0
UI.HTLabel.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI.HTLabel.Interactable = false
UI.HTLabel.Name = "SlotLabel"
UI.HTLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.HTLabel.Size = UDim2.new(1, -8, 1, -8)
UI.HTLabel.Text = ""
UI.HTLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.HTLabel.TextScaled = true
UI.HTLabel.TextWrapped = true
UI.HTLabel.Parent = UI.ToolButtonTemplate

UI.BackpackTemplate = UI.ToolButtonTemplate:Clone()
UI.BackpackTemplate.Size = UDim2.new(0, 60, 0, 60)

local isOpen = false
local currentSearch = ""
local toolOrder = setmetatable({}, {__mode = "k"})
local orderCounter = 0
local activeTweens = setmetatable({}, {__mode = "k"})
local lastEquippedTool = nil

local HotbarSlotCount = 6
local GhostColor = Color3.fromRGB(0, 0, 0)
local GhostTransparency = 0.55
local hotbarSlots = table.create(HotbarSlotCount, false)
local hotbarWrappers = {}

local dragState = {
    Active = false,
    Started = false,
    Tool = nil,
    FromSlot = nil,
    StartPos = nil,
    Icon = nil,
}

local updateInventory

local UnselectedColor = Color3.fromRGB(0, 0, 0)
local UnselectedTransparency = 0.5
local SelectedColor = Color3.fromRGB(59, 130, 246)
local SelectedTransparency = 0

local function setBackpackTransparency(target)
    TweenService:Create(
        UI.BackpackFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
        {GroupTransparency = target}
    ):Play()
end

UI.BackpackFrame.Visible = false
UI.BackpackFrame.GroupTransparency = 1

local function toggleBackpack()
    isOpen = not isOpen
    if isOpen then
        UI.Backpack.Image = "rbxasset://textures/ui/TopBar/inventoryOn.png"
        UI.BackpackFrame.Visible = true
        setBackpackTransparency(0)
    else
        UI.Backpack.Image = "rbxasset://textures/ui/TopBar/inventoryOff.png"
        setBackpackTransparency(1)
        task.delay(0.2, function()
            if not isOpen then
                UI.BackpackFrame.Visible = false
            end
        end)
    end
    updateInventory()
end

UI.Backpack.MouseButton1Click:Connect(toggleBackpack)

pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end)

local function applySlotSelection(slot, selected)
    local stroke = slot.SlotStroke
    stroke:SetAttribute("Selected", selected)

    if activeTweens[stroke] then
        activeTweens[stroke]:Cancel()
    end

    local tween = TweenService:Create(
        stroke,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
        {
            Color = selected and SelectedColor or UnselectedColor,
            Transparency = selected and SelectedTransparency or UnselectedTransparency
        }
    )
    activeTweens[stroke] = tween
    tween:Play()
end

local function styleOccupiedButton(button, tool, equippedTool)
    if tool.TextureId ~= "" and tool.TextureId ~= "rbxasset://textures/Unknown.png" then
        button.SlotIcon.Image = tool.TextureId
        button.SlotLabel.Text = ""
    else
        button.SlotIcon.Image = ""
        button.SlotLabel.Text = tool.Name
    end
    if tool == lastEquippedTool and tool ~= equippedTool then
        button.SlotStroke.Color = SelectedColor
        button.SlotStroke.Transparency = SelectedTransparency
    end
    applySlotSelection(button, tool == equippedTool)
end

local function bindEquipClick(button, tool, ch, equippedTool)
    button.MouseButton1Click:Connect(function()
        if tool.Parent == ch then
            tool.Parent = LocalPlayer.Backpack
        else
            if equippedTool then equippedTool.Parent = LocalPlayer.Backpack end
            tool.Parent = ch
        end
    end)
end

local function isInHotbar(tool)
    for i = 1, HotbarSlotCount do
        if hotbarSlots[i] == tool then
            return true
        end
    end
    return false
end

local function firstEmptyHotbarSlot()
    for i = 1, HotbarSlotCount do
        if not hotbarSlots[i] then
            return i
        end
    end
    return nil
end

local function findDropTarget(pos)
    local hits = PlayerGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
    for _, obj in ipairs(hits) do
        local node = obj
        while node and node ~= PlayerGui do
            local slotIndex = node:GetAttribute("HotbarSlotIndex")
            if slotIndex then
                return "Hotbar", slotIndex
            end
            if node:GetAttribute("IsBackpackRegion") then
                return "Backpack", nil
            end
            node = node.Parent
        end
    end
    return nil, nil
end

local function handleDrop(tool, fromSlot, dropPos)
    if not tool or (tool.Parent ~= LocalPlayer.Character and tool.Parent ~= LocalPlayer.Backpack) then
        return
    end

    local targetType, targetIndex = findDropTarget(dropPos)
    if not targetType then
        return
    end

    if targetType == "Backpack" then
        if fromSlot.Type == "Hotbar" then
            hotbarSlots[fromSlot.Index] = false
        end
        return
    end

    if fromSlot.Type == "Hotbar" then
        if fromSlot.Index == targetIndex then
            return
        end
        hotbarSlots[fromSlot.Index], hotbarSlots[targetIndex] = hotbarSlots[targetIndex], hotbarSlots[fromSlot.Index]
    else
        hotbarSlots[targetIndex] = tool
    end
end

local function startActualDrag(tool)
    local icon = Instance.new("ImageLabel")
    icon.AnchorPoint = Vector2.new(0, 0)
    icon.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
    icon.BackgroundTransparency = 0.25
    icon.BorderSizePixel = 0
    icon.Name = "DragIcon"
    icon.ScaleType = Enum.ScaleType.Fit
    icon.Size = UDim2.fromOffset(44, 44)
    icon.ZIndex = 1000

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = icon

    local label = Instance.new("TextLabel")
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.BackgroundTransparency = 1
    label.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    label.Position = UDim2.fromScale(0.5, 0.5)
    label.Size = UDim2.new(1, -6, 1, -6)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.TextWrapped = true
    label.Text = ""
    label.Parent = icon

    if tool.TextureId ~= "" and tool.TextureId ~= "rbxasset://textures/Unknown.png" then
        icon.Image = tool.TextureId
    else
        label.Text = tool.Name
    end

    icon.Parent = UI.InvGui
    dragState.Icon = icon
end

local function endDrag(dropPos)
    if dragState.Started then
        handleDrop(dragState.Tool, dragState.FromSlot, dropPos)
        updateInventory()
    end
    if dragState.Icon then
        dragState.Icon:Destroy()
    end
    dragState.Active = false
    dragState.Started = false
    dragState.Tool = nil
    dragState.FromSlot = nil
    dragState.StartPos = nil
    dragState.Icon = nil
end

local function beginPotentialDrag(tool, sourceInfo, inputPos)
    if dragState.Active then
        return
    end
    dragState.Active = true
    dragState.Started = false
    dragState.Tool = tool
    dragState.FromSlot = sourceInfo
    dragState.StartPos = inputPos
end

local function hookDrag(button, tool, sourceInfo)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            beginPotentialDrag(tool, sourceInfo, Vector2.new(input.Position.X, input.Position.Y))
        end
    end)
end

UserInputService.InputChanged:Connect(function(input)
    if not dragState.Active then
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    local currentPos = Vector2.new(input.Position.X, input.Position.Y)
    if not dragState.Started then
        if (currentPos - dragState.StartPos).Magnitude > 6 then
            dragState.Started = true
            startActualDrag(dragState.Tool)
            if dragState.FromSlot.Type == "Hotbar" then
                local wrapper = hotbarWrappers[dragState.FromSlot.Index]
                if wrapper then
                    local innerButton = wrapper:FindFirstChild("Slot")
                    if innerButton then
                        innerButton.Visible = false
                    end
                    wrapper.BackgroundColor3 = GhostColor
                    wrapper.BackgroundTransparency = GhostTransparency
                end
            end
        end
    end
    if dragState.Started and dragState.Icon then
        dragState.Icon.Position = UDim2.fromOffset(currentPos.X - 22, currentPos.Y - 22)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if not dragState.Active then
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    endDrag(Vector2.new(input.Position.X, input.Position.Y))
end)

function updateInventory()
    for i = 1, HotbarSlotCount do
        local occupant = hotbarSlots[i]
        if occupant and occupant.Parent ~= LocalPlayer.Character and occupant.Parent ~= LocalPlayer.Backpack then
            hotbarSlots[i] = false
        end
    end

    for _, child in ipairs(UI.HotbarFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, child in ipairs(UI.Tools:GetChildren()) do
        if child:IsA("ImageButton") then child:Destroy() end
    end

    local ch = LocalPlayer.Character
    local equippedTool = ch and ch:FindFirstChildOfClass("Tool")

    local allTools = {}
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then table.insert(allTools, tool) end
    end
    if equippedTool then
        table.insert(allTools, equippedTool)
    end

    for _, tool in ipairs(allTools) do
        if not toolOrder[tool] then
            orderCounter = orderCounter + 1
            toolOrder[tool] = orderCounter
            local slot = firstEmptyHotbarSlot()
            if slot then
                hotbarSlots[slot] = tool
            end
        end
    end

    table.sort(allTools, function(a, b)
        return toolOrder[a] < toolOrder[b]
    end)

    local visibleHotbarCount = 0
    for i = 1, HotbarSlotCount do
        if hotbarSlots[i] or isOpen then
            visibleHotbarCount = visibleHotbarCount + 1
        end
    end
    UI.HotbarFrame.Size = UDim2.new(0, (visibleHotbarCount * 44) + (math.max(0, visibleHotbarCount - 1) * 6), 0, 44)

    table.clear(hotbarWrappers)

    for i = 1, HotbarSlotCount do
        local tool = hotbarSlots[i]
        if tool then
            local wrapper = UI.SlotWrapperTemplate:Clone()
            wrapper.LayoutOrder = i
            wrapper:SetAttribute("HotbarSlotIndex", i)
            wrapper.Parent = UI.HotbarFrame
            hotbarWrappers[i] = wrapper

            local button = UI.ToolButtonTemplate:Clone()
            button.Size = UDim2.new(1, 0, 1, 0)
            button.Parent = wrapper

            styleOccupiedButton(button, tool, equippedTool)
            bindEquipClick(button, tool, ch, equippedTool)
            hookDrag(button, tool, {Type = "Hotbar", Index = i})
        elseif isOpen then
            local ghost = UI.SlotWrapperTemplate:Clone()
            ghost.Name = "GhostSlot"
            ghost.LayoutOrder = i
            ghost.BackgroundColor3 = GhostColor
            ghost.BackgroundTransparency = GhostTransparency
            ghost.Active = false
            ghost:SetAttribute("HotbarSlotIndex", i)
            ghost.Parent = UI.HotbarFrame
            hotbarWrappers[i] = ghost
        end
    end

    local bpIndex = 0
    for _, tool in ipairs(allTools) do
        if not isInHotbar(tool) then
            local matches = true
            if currentSearch ~= "" then
                if not string.find(string.lower(tool.Name), string.lower(currentSearch), 1, true) then
                    matches = false
                end
            end

            if matches then
                bpIndex = bpIndex + 1
                local slot = UI.BackpackTemplate:Clone()
                slot.LayoutOrder = bpIndex
                slot.Parent = UI.Tools

                styleOccupiedButton(slot, tool, equippedTool)
                bindEquipClick(slot, tool, ch, equippedTool)
                hookDrag(slot, tool, {Type = "Backpack"})
            end
        end
    end

    lastEquippedTool = equippedTool
end

local updateQueued = false
local function updateInv()
    if updateQueued then return end
    updateQueued = true
    task.defer(function()
        updateQueued = false
        updateInventory()
    end)
end

LocalPlayer.Backpack.ChildAdded:Connect(updateInv)
LocalPlayer.Backpack.ChildRemoved:Connect(updateInv)

local function hookChar(char)
    char.ChildAdded:Connect(updateInv)
    char.ChildRemoved:Connect(updateInv)
    updateInventory()
end

if LocalPlayer.Character then task.spawn(hookChar, LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(hookChar)

UI.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    currentSearch = UI.SearchBox.Text
    updateInventory()
end)

local hotbarKeys = {
    [Enum.KeyCode.One] = 1,
    [Enum.KeyCode.Two] = 2,
    [Enum.KeyCode.Three] = 3,
    [Enum.KeyCode.Four] = 4,
    [Enum.KeyCode.Five] = 5,
    [Enum.KeyCode.Six] = 6,
}

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local slotNum = hotbarKeys[input.KeyCode]
    if slotNum then
        local tool = hotbarSlots[slotNum]
        if tool then
            local ch = LocalPlayer.Character
            local equippedTool = ch and ch:FindFirstChildOfClass("Tool")
            if tool.Parent == ch then
                tool.Parent = LocalPlayer.Backpack
            else
                if equippedTool then equippedTool.Parent = LocalPlayer.Backpack end
                tool.Parent = ch
            end
        end
    end
end)

updateInventory()
return UI