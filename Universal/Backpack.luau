if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G

local function GetService(Service)
    local Service = game:GetService(Service)
    return cloneref and cloneref(Service) or Service
end

local Hui = gethui and gethui() or GetService("CoreGui")
local TweenService = GetService("TweenService")
local Players = GetService("Players")
local StarterGui = GetService("StarterGui")
local UserInputService = GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = GetService("RunService")

local function Tween(Object, Speed, Props, Style, Dir)
    return TweenService:Create(
        Object,
        TweenInfo.new(
            Speed,
            Enum.EasingStyle[Style or "Quad"],
            Enum.EasingDirection[Dir or "Out"]
        ),
        Props
    )
end

local function UID(Length)
    Length = Length or 64
    local Chars = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]]
    local Id = table.create(Length)
    for i = 1, Length do
        local Rand = math.random(1, #Chars)
        Id[i] = Chars:sub(Rand, Rand)
    end
    return table.concat(Id)
end

Shared.Backpack = Shared.Backpack or {}

if Shared.Backpack.IsLoaded then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Backpack",
            Text = "Backpack is already running!",
            Icon = "rbxasset://textures/ui/TopBar/inventoryOn.png",
            Duration = 4
        })
    end)
    return
end

Shared.Backpack.IsLoaded = true

local TopbarPlus = PlayerGui:FindFirstChild("TopbarStandard")
if TopbarPlus and TopbarPlus:FindFirstChild("Holders") and TopbarPlus.Holders:FindFirstChild("Left") then
    TopbarPlus = TopbarPlus.Holders.Left
end

local UI = {}

UI.InvGui = Instance.new("ScreenGui")
UI.InvGui.Name = UID()
UI.InvGui.ResetOnSpawn = false
UI.InvGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.InvGui.Parent = Hui

UI.BackpackBtn = Instance.new("Frame")
UI.BackpackBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
UI.BackpackBtn.BackgroundTransparency = 0.08
UI.BackpackBtn.BorderSizePixel = 0
UI.BackpackBtn.LayoutOrder = -2147483647
UI.BackpackBtn.Name = "BackpackBtn"
UI.BackpackBtn.Position = UDim2.fromOffset(16, 4)
UI.BackpackBtn.Size = UDim2.fromOffset(44, 44)
UI.BackpackBtn.Parent = TopbarPlus or UI.InvGui

UI.Corner = Instance.new("UICorner")
UI.Corner.CornerRadius = UDim.new(1, 0)
UI.Corner.Name = "Corner"
UI.Corner.Parent = UI.BackpackBtn

UI.BackpackIcon = Instance.new("ImageButton")
UI.BackpackIcon.AnchorPoint = Vector2.new(0.5, 0.5)
UI.BackpackIcon.AutoButtonColor = true
UI.BackpackIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.BackpackIcon.BackgroundTransparency = 1
UI.BackpackIcon.BorderSizePixel = 0
UI.BackpackIcon.Image = "rbxasset://textures/ui/TopBar/inventoryOff.png"
UI.BackpackIcon.Name = "BackpackIcon"
UI.BackpackIcon.Position = UDim2.fromScale(0.5, 0.5)
UI.BackpackIcon.Size = UDim2.fromOffset(36, 36)
UI.BackpackIcon.Parent = UI.BackpackBtn

UI.BackpackIconCorner = Instance.new("UICorner")
UI.BackpackIconCorner.CornerRadius = UDim.new(1, 0)
UI.BackpackIconCorner.Name = "BackpackIconCorner"
UI.BackpackIconCorner.Parent = UI.BackpackIcon

UI.MainUI = Instance.new("Frame")
UI.MainUI.AnchorPoint = Vector2.new(0.5, 1)
UI.MainUI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.MainUI.BackgroundTransparency = 1
UI.MainUI.BorderSizePixel = 0
UI.MainUI.Name = "MainUI"
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
UI.BackpackFrame.Name = "BackpackFrame"
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
UI.HotbarFrame.Name = "HotbarFrame"
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

UI.HotbarTemplate = Instance.new("ImageButton")
UI.HotbarTemplate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.HotbarTemplate.BackgroundTransparency = 0.4
UI.HotbarTemplate.BorderSizePixel = 0
UI.HotbarTemplate.LayoutOrder = -1
UI.HotbarTemplate.Name = "HotbarTemplate"
UI.HotbarTemplate.Size = UDim2.new(0, 44, 1, 0)
UI.HotbarTemplate.Visible = false
UI.HotbarTemplate.Parent = UI.HotbarFrame

UI.HTCorner = Instance.new("UICorner")
UI.HTCorner.CornerRadius = UDim.new(0, 6)
UI.HTCorner.Name = "HTCorner"
UI.HTCorner.Parent = UI.HotbarTemplate

UI.HTIcon = Instance.new("ImageLabel")
UI.HTIcon.AnchorPoint = Vector2.new(0.5, 0.5)
UI.HTIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.HTIcon.BackgroundTransparency = 1
UI.HTIcon.BorderSizePixel = 0
UI.HTIcon.Interactable = false
UI.HTIcon.Name = "HTIcon"
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
UI.HTRatio.Name = "HTRatio"
UI.HTRatio.Parent = UI.HotbarTemplate

UI.HTLabel = Instance.new("TextLabel")
UI.HTLabel.AnchorPoint = Vector2.new(0.5, 0.5)
UI.HTLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.HTLabel.BackgroundTransparency = 1
UI.HTLabel.BorderSizePixel = 0
UI.HTLabel.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI.HTLabel.Interactable = false
UI.HTLabel.Name = "HTLabel"
UI.HTLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.HTLabel.Size = UDim2.new(1, -8, 1, -8)
UI.HTLabel.Text = ""
UI.HTLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.HTLabel.TextScaled = true
UI.HTLabel.TextWrapped = true
UI.HTLabel.Parent = UI.HotbarTemplate

UI.BackpackTemplate = UI.HotbarTemplate:Clone()
UI.BackpackTemplate.Size = UDim2.new(0, 60, 0, 60)
UI.BackpackTemplate.Visible = false
UI.BackpackTemplate.Parent = UI.Tools

local isOpen = false
local currentSearch = ""
local toolOrder = setmetatable({}, {__mode = "k"})
local orderCounter = 0
local activeTweens = setmetatable({}, {__mode = "k"})
local lastEquippedTool = nil

local UnselectedColor = Color3.fromRGB(0, 0, 0)
local UnselectedTransparency = 0.5
local SelectedColor = Color3.fromRGB(59, 130, 246)
local SelectedTransparency = 0

UI.BackpackFrame.Visible = false
UI.BackpackFrame.GroupTransparency = 1

local function toggleBackpack()
    isOpen = not isOpen
    if isOpen then
        UI.BackpackIcon.Image = "rbxasset://textures/ui/TopBar/inventoryOn.png"
        UI.BackpackIcon.BackgroundTransparency = 0.85
        UI.BackpackFrame.Visible = true
        local tween = Tween(UI.BackpackFrame, 0.2, {GroupTransparency = 0})
        tween:Play()
    else
        UI.BackpackIcon.Image = "rbxasset://textures/ui/TopBar/inventoryOff.png"
        UI.BackpackIcon.BackgroundTransparency = 1
        local tween = Tween(UI.BackpackFrame, 0.2, {GroupTransparency = 1})
        tween:Play()
        task.delay(0.25, function()
            if not isOpen then
                UI.BackpackFrame.Visible = false
            end
        end)
    end
end

UI.BackpackIcon.MouseButton1Click:Connect(toggleBackpack)

pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end)

local function applySlotSelection(slot, selected)
    local stroke = slot:FindFirstChildOfClass("UIStroke")
    stroke:SetAttribute("Selected", selected)

    if activeTweens[stroke] then
        activeTweens[stroke]:Cancel()
    end

    local tween = Tween(
        stroke,
        0.2,
        {
            Color = selected and SelectedColor or UnselectedColor,
            Transparency = selected and SelectedTransparency or UnselectedTransparency
        }
    )
    activeTweens[stroke] = tween
    tween:Play()
end

local function updateInventory()
    for _, child in ipairs(UI.HotbarFrame:GetChildren()) do
        if child:IsA("ImageButton") and child ~= UI.HotbarTemplate then
            child:Destroy()
        end
    end
    for _, child in ipairs(UI.Tools:GetChildren()) do
        if child:IsA("ImageButton") and child ~= UI.BackpackTemplate then
            child:Destroy()
        end
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
        return (toolOrder[a] or 0) < (toolOrder[b] or 0)
    end)

    local hotbarCount = math.min(#allTools, 6)
    UI.HotbarFrame.Size = UDim2.new(0, (hotbarCount * 44) + (math.max(0, hotbarCount - 1) * 6), 0, 44)

    for i = 1, hotbarCount do
        local tool = allTools[i]
        local slot = UI.HotbarTemplate:Clone()
        slot.Visible = true
        slot.LayoutOrder = i
        slot.Parent = UI.HotbarFrame

        local icon = slot:FindFirstChildOfClass("ImageLabel")
        local label = slot:FindFirstChildOfClass("TextLabel")

        if tool.TextureId ~= "" and tool.TextureId ~= "rbxasset://textures/Unknown.png" then
            icon.Image = tool.TextureId
            label.Text = ""
        else
            icon.Image = ""
            label.Text = tool.Name
        end

        if tool == lastEquippedTool and tool ~= equippedTool then
            local stroke = slot:FindFirstChildOfClass("UIStroke")
            stroke.Color = SelectedColor
            stroke.Transparency = SelectedTransparency
        end
        applySlotSelection(slot, tool == equippedTool)

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
            slot.Visible = true
            slot.LayoutOrder = bpIndex
            slot.Parent = UI.Tools
            bpIndex = bpIndex + 1

            local icon = slot:FindFirstChildOfClass("ImageLabel")
            local label = slot:FindFirstChildOfClass("TextLabel")

            if tool.TextureId ~= "" and tool.TextureId ~= "rbxasset://textures/Unknown.png" then
                icon.Image = tool.TextureId
                label.Text = ""
            else
                icon.Image = ""
                label.Text = tool.Name
            end

            if tool == lastEquippedTool and tool ~= equippedTool then
                local stroke = slot:FindFirstChildOfClass("UIStroke")
                stroke.Color = SelectedColor
                stroke.Transparency = SelectedTransparency
            end
            applySlotSelection(slot, tool == equippedTool)

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

if LocalPlayer.Character then
    task.spawn(hookChar, LocalPlayer.Character)
end
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