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

UI.BackpackContainer = Instance.new("Frame")
UI.BackpackContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
UI.BackpackContainer.BackgroundTransparency = 0.08
UI.BackpackContainer.BorderSizePixel = 0
UI.BackpackContainer.LayoutOrder = -2147483647
UI.BackpackContainer.Name = "__BackpackContainer"
UI.BackpackContainer.Position = UDim2.fromOffset(214, 2)
UI.BackpackContainer.Size = UDim2.fromOffset(44, 44)
UI.BackpackContainer.Parent = TopbarPlus or Fallback or Hui

UI.Corner = Instance.new("UICorner")
UI.Corner.CornerRadius = UDim.new(1, 0)
UI.Corner.Name = "Corner"
UI.Corner.Parent = UI.BackpackContainer

UI.Backpack = Instance.new("ImageButton")
UI.Backpack.AnchorPoint = Vector2.new(0.5, 0.5)
UI.Backpack.AutoButtonColor = true
UI.Backpack.BackgroundTransparency = 1
UI.Backpack.BorderSizePixel = 0
UI.Backpack.Image = "rbxasset://textures/ui/TopBar/inventoryOff.png"
UI.Backpack.Name = "__Backpack"
UI.Backpack.Position = UDim2.fromScale(0.5, 0.5)
UI.Backpack.Size = UDim2.fromOffset(36, 36)
UI.Backpack.Parent = UI.BackpackContainer

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
UI.MainUI.Size = UDim2.new(0.5, 6, 0.9, 0)
UI.MainUI.Parent = UI.InvGui

UI.UILayout = Instance.new("UIListLayout")
UI.UILayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.UILayout.Name = "UILayout"
UI.UILayout.Padding = UDim.new(0, 4)
UI.UILayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.UILayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
UI.UILayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.UILayout.Parent = UI.MainUI

UI.BackpackFrame = Instance.new("Frame")
UI.BackpackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.BackpackFrame.BackgroundTransparency = 0.3
UI.BackpackFrame.BorderSizePixel = 0
UI.BackpackFrame.LayoutOrder = 1
UI.BackpackFrame.Name = "Backpack"
UI.BackpackFrame.Size = UDim2.new(0.2, 0, 0.3, 0)
UI.BackpackFrame.Parent = UI.MainUI

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
UI.ToolsPadding.PaddingTop = UDim.new(0, 6)
UI.ToolsPadding.Parent = UI.Tools

UI.ToolsLayout = Instance.new("UIGridLayout")
UI.ToolsLayout.CellPadding = UDim2.new(0, 6, 0, 6)
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
UI.HotbarLayout.Padding = UDim.new(0, 6)
UI.HotbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.HotbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.HotbarLayout.Parent = UI.HotbarFrame

UI.HotbarTemplate = Instance.new("ImageButton")
UI.HotbarTemplate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.HotbarTemplate.BackgroundTransparency = 0.4
UI.HotbarTemplate.BorderSizePixel = 0
UI.HotbarTemplate.LayoutOrder = -1
UI.HotbarTemplate.Name = "Slot"
UI.HotbarTemplate.Size = UDim2.new(0, 44, 1, 0)

UI.HTCorner = Instance.new("UICorner")
UI.HTCorner.CornerRadius = UDim.new(0, 6)
UI.HTCorner.Name = "SlotCorner"
UI.HTCorner.Parent = UI.HotbarTemplate

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
UI.HTIcon.Parent = UI.HotbarTemplate

UI.HTStroke = Instance.new("UIStroke")
UI.HTStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.HTStroke.Color = Color3.fromRGB(0, 0, 0)
UI.HTStroke.Name = "HTStroke"
UI.HTStroke.Thickness = 2
UI.HTStroke.Transparency = 0.5
UI.HTStroke.Parent = UI.HotbarTemplate

UI.HTRatio = Instance.new("UIAspectRatioConstraint")
UI.HTRatio.Name = "SlotRatio"
UI.HTRatio.Parent = UI.HotbarTemplate

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
UI.HTLabel.Parent = UI.HotbarTemplate

UI.BackpackTemplate = UI.HotbarTemplate:Clone()
UI.BackpackTemplate.Size = UDim2.new(0, 60, 0, 60)

local isOpen = false
local currentSearch = ""
local toolOrder = setmetatable({}, {__mode = "k"})
local orderCounter = 0

local UnselectedColor = Color3.fromRGB(0, 0, 0)
local UnselectedTransparency = 0.5
local SelectedColor = Color3.fromRGB(59, 130, 246)
local SelectedTransparency = 0

local function setBackpackTransparency(target)
    local elements = {
        {UI.BackpackFrame, 0.3},
        {UI.SearchBox, 0.6}
    }

    for _, item in ipairs(elements) do
        local obj, default = item[1], item[2]
        local val = default + (1 - default) * target

        TweenService:Create(
            obj,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundTransparency = val}
        ):Play()
    end

    local strokeVal = 0.8 + (1 - 0.8) * target

    TweenService:Create(
        UI.SearchBoxStroke,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
        {Transparency = strokeVal}
    ):Play()

    for _, str in ipairs(UI.BackpackFrame:GetDescendants()) do
        if str:IsA("UIStroke") and str.Name ~= "SearchBoxStroke" and str.Name ~= "HTStroke" then
            local val = 1 * target

            TweenService:Create(
                str,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {Transparency = val}
            ):Play()
        end
    end

    for _, descendant in ipairs(UI.Tools:GetChildren()) do
        if descendant:IsA("ImageButton") then
            local slotVal = 0.4 + 0.6 * target

            TweenService:Create(
                descendant,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {BackgroundTransparency = slotVal}
            ):Play()

            local label = descendant:FindFirstChild("SlotLabel")
            if label then
                TweenService:Create(
                    label,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {TextTransparency = target}
                ):Play()
            end

            local icon = descendant:FindFirstChild("SlotIcon")
            if icon then
                TweenService:Create(
                    icon,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {ImageTransparency = target}
                ):Play()
            end

            local htStroke = descendant:FindFirstChild("HTStroke")
            if htStroke then
                local strokeTransparencyGoal = htStroke:GetAttribute("Selected") and SelectedTransparency or UnselectedTransparency
                local fadedGoal = strokeTransparencyGoal + (1 - strokeTransparencyGoal) * target
                TweenService:Create(
                    htStroke,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {Transparency = fadedGoal}
                ):Play()
            end
        end
    end

    TweenService:Create(
        UI.SearchBox,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
        {TextTransparency = target}
    ):Play()
end

UI.BackpackFrame.Visible = false
setBackpackTransparency(1)

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
end

UI.Backpack.MouseButton1Click:Connect(toggleBackpack)

pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end)

local function applySlotSelection(slot, selected, fadedIn)
    local stroke = slot.HTStroke
    stroke:SetAttribute("Selected", selected)
    stroke.Color = selected and SelectedColor or UnselectedColor
    if fadedIn then
        stroke.Transparency = selected and SelectedTransparency or UnselectedTransparency
    else
        stroke.Transparency = 1
    end
end

local function updateInventory()
    for _, child in ipairs(UI.HotbarFrame:GetChildren()) do
        if child:IsA("ImageButton") then child:Destroy() end
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
        end
    end

    table.sort(allTools, function(a, b)
        return toolOrder[a] < toolOrder[b]
    end)

    local hotbarCount = math.min(#allTools, 6)
    UI.HotbarFrame.Size = UDim2.new(0, (hotbarCount * 44) + (math.max(0, hotbarCount - 1) * 6), 0, 44)

    for i = 1, hotbarCount do
        local tool = allTools[i]
        local slot = UI.HotbarTemplate:Clone()
        slot.LayoutOrder = i
        slot.Parent = UI.HotbarFrame
        
        if tool.TextureId ~= "" and tool.TextureId ~= "rbxasset://textures/Unknown.png" then
            slot.SlotIcon.Image = tool.TextureId
            slot.SlotLabel.Text = ""
        else
            slot.SlotIcon.Image = ""
            slot.SlotLabel.Text = tool.Name
        end
        
        applySlotSelection(slot, tool == equippedTool, true)
        
        slot.MouseButton1Click:Connect(function()
            if tool.Parent == ch then
                tool.Parent = LocalPlayer.Backpack
            else
                if equippedTool then equippedTool.Parent = LocalPlayer.Backpack end
                tool.Parent = ch
            end
        end)
    end

    local bpIndex = 1
    for i = 7, #allTools do
        local tool = allTools[i]
        local matches = true
        if currentSearch ~= "" then
            if not string.find(string.lower(tool.Name), string.lower(currentSearch), 1, true) then
                matches = false
            end
        end
        
        if matches then
            local slot = UI.BackpackTemplate:Clone()
            slot.LayoutOrder = bpIndex
            slot.Parent = UI.Tools
            bpIndex = bpIndex + 1
            
            if tool.TextureId ~= "" and tool.TextureId ~= "rbxasset://textures/Unknown.png" then
                slot.SlotIcon.Image = tool.TextureId
                slot.SlotLabel.Text = ""
            else
                slot.SlotIcon.Image = ""
                slot.SlotLabel.Text = tool.Name
            end

            applySlotSelection(slot, tool == equippedTool, isOpen)
            
            slot.MouseButton1Click:Connect(function()
                if tool.Parent == ch then
                    tool.Parent = LocalPlayer.Backpack
                else
                    if equippedTool then equippedTool.Parent = LocalPlayer.Backpack end
                    tool.Parent = ch
                end
            end)
        end
    end
    
    if isOpen then
        setBackpackTransparency(0)
    end
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
        local ch = LocalPlayer.Character
        local equippedTool = ch and ch:FindFirstChildOfClass("Tool")
        local allTools = {}
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then table.insert(allTools, tool) end
        end
        if equippedTool then table.insert(allTools, equippedTool) end

        table.sort(allTools, function(a, b)
            return (toolOrder[a] or 0) < (toolOrder[b] or 0)
        end)
        
        local tool = allTools[slotNum]
        if tool then
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