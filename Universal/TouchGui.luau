if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Global = (pcall(getgenv) and getgenv()) or warn("[TouchGui]: Executor doesn't support getgenv()")

Global.TouchGui = Global.TouchGui or {}

local function default(expected, value, fallback)
    if type(value) == expected then
        return value
    end
    return fallback
end

local cloneref = default("function", cloneref, function() return end)

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

local Players = Services.Players
local StarterGui = Services.StarterGui
local UserInputService = Services.UserInputService
local VirtualInputManager = Services.VirtualInputManager
local RunService = Services.RunService
local CoreGui = Services.CoreGui

local Success, Hui = pcall(function() return gethui and gethui() end)
local CoreGui = Success and Hui or CoreGui

if Global.TouchGui.isLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "TouchGui",
        Text = "TouchGui is already running!",
        Duration = 4
    })
    return
end

Global.TouchGui.isLoaded = true

local function isDesktop()
    return not UserInputService.TouchEnabled
        and UserInputService.MouseEnabled
        and UserInputService.KeyboardEnabled
end

local function isMobile()
    return UserInputService.TouchEnabled
        and not UserInputService.MouseEnabled
        and not UserInputService.KeyboardEnabled
end

if isDesktop() then
    StarterGui:SetCore("SendNotification", {
        Title = "TouchGui",
        Text = "This script is intended for mobile devices only.",
        Duration = 5
    })
    return
end

if not isMobile() then
    return
end

local Player = Players.LocalPlayer
local PlayerGui = Player:FindFirstChild("PlayerGui")
local TouchControlFrame = PlayerGui and PlayerGui:FindFirstChild("TouchGui") and PlayerGui.TouchGui:FindFirstChild("TouchControlFrame")
local OriginalJump = TouchControlFrame and TouchControlFrame:FindFirstChild("JumpButton")

local TouchGui = Instance.new("ScreenGui")
TouchGui.Name = "TouchGui"
TouchGui.ResetOnSpawn = false
TouchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
TouchGui.Parent = CoreGui

local function GetOppisitePos(Position, AnchorPoint)
    return UDim2.new(
        1 - Position.X.Scale,
        -Position.X.Offset,
        Position.Y.Scale,
        Position.Y.Offset
    ), Vector2.new(
        1 - AnchorPoint.X,
        AnchorPoint.Y
    )
end

local ZoneKeys = {
    TopLeft = {"W", "A"},
    TopCenter = {"W"},
    TopRight = {"W", "D"},
    CenterLeft = {"A"},
    Center = {},
    CenterRight = {"D"},
    BottomLeft = {"S", "A"},
    BottomCenter = {"S"},
    BottomRight = {"S", "D"},
}

local ActiveKeys = {W = false, A = false, S = false, D = false}

local function SendKey(key, isDown)
    local keyCode = Enum.KeyCode[key]
    if keyCode then
        VirtualInputManager:SendKeyEvent(isDown, keyCode, false, game)
    end
end

local function UpdateMovement(zone)
    local keysToPress = ZoneKeys[zone] or {}
    
    for key, isActive in pairs(ActiveKeys) do
        local shouldBeActive = false
        for _, zoneKey in ipairs(keysToPress) do
            if zoneKey == key then
                shouldBeActive = true
                break
            end
        end
        
        if shouldBeActive and not isActive then
            ActiveKeys[key] = true
            SendKey(key, true)
        elseif not shouldBeActive and isActive then
            ActiveKeys[key] = false
            SendKey(key, false)
        end
    end
end

local Jump = Instance.new("ImageButton")
Jump.Active = true
Jump.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Jump.BackgroundTransparency = 1
Jump.BorderSizePixel = 0
Jump.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
Jump.ImageRectOffset = Vector2.new(1, 146)
Jump.ImageRectSize = Vector2.new(144, 144)
Jump.Name = "Jump"
Jump.ScaleType = Enum.ScaleType.Fit
Jump.Parent = TouchGui

local JumpRatio = Instance.new("UIAspectRatioConstraint")
JumpRatio.Name = "JumpRatio"
JumpRatio.Parent = Jump

local Thumb = Instance.new("ImageLabel")
Thumb.Active = true
Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Thumb.BackgroundTransparency = 1
Thumb.BorderSizePixel = 0
Thumb.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
Thumb.ImageColor3 = Color3.fromRGB(0, 0, 0)
Thumb.ImageRectOffset = Vector2.new(1, 1)
Thumb.ImageRectSize = Vector2.new(144, 144)
Thumb.Name = "Thumb"
Thumb.ScaleType = Enum.ScaleType.Fit
Thumb.Parent = TouchGui

local ThumbRatio = Instance.new("UIAspectRatioConstraint")
ThumbRatio.Name = "ThumbRatio"
ThumbRatio.Parent = Thumb

local Knob = Instance.new("ImageLabel")
Knob.Active = true
Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Knob.BackgroundTransparency = 1
Knob.BorderSizePixel = 0
Knob.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
Knob.ImageRectOffset = Vector2.new(1, 1)
Knob.ImageRectSize = Vector2.new(144, 144)
Knob.Name = "Knob"
Knob.ScaleType = Enum.ScaleType.Fit
Knob.Size = UDim2.new(0.45, 0, 0.45, 0)
Knob.Parent = Thumb

local KnobRatio = Instance.new("UIAspectRatioConstraint")
KnobRatio.Name = "KnobRatio"
KnobRatio.Parent = Knob

if OriginalJump then
    Jump.Position = OriginalJump.Position
    Jump.Size = OriginalJump.Size
    
    OriginalJump:GetPropertyChangedSignal("Position"):Connect(function()
        Jump.Position = OriginalJump.Position
    end)
    
    OriginalJump:GetPropertyChangedSignal("Size"):Connect(function()
        Jump.Size = OriginalJump.Size
    end)
    
    local oppositePos, oppositeAnchor = GetOppisitePos(OriginalJump.Position, OriginalJump.AnchorPoint)
    Thumb.Position = oppositePos
    Thumb.AnchorPoint = oppositeAnchor
    Thumb.Size = OriginalJump.Size
    
    OriginalJump:GetPropertyChangedSignal("Position"):Connect(function()
        local newOppositePos, newOppositeAnchor = GetOppisitePos(OriginalJump.Position, OriginalJump.AnchorPoint)
        Thumb.Position = newOppositePos
        Thumb.AnchorPoint = newOppositeAnchor
    end)
    
    OriginalJump:GetPropertyChangedSignal("Size"):Connect(function()
        Thumb.Size = OriginalJump.Size
    end)
end

local Dragging = false
local ActiveInput = nil
local CurrentKnobPosition = Vector2.new(0.5, 0.5)
local TargetKnobPosition = Vector2.new(0.5, 0.5)

local function GetZoneFromNormalized(X, Y)
    local Horizontal
    local Vertical

    if X < -0.33 then
        Horizontal = "Left"
    elseif X > 0.33 then
        Horizontal = "Right"
    else
        Horizontal = "Center"
    end

    if Y < -0.33 then
        Vertical = "Top"
    elseif Y > 0.33 then
        Vertical = "Bottom"
    else
        Vertical = "Center"
    end

    return Vertical .. Horizontal
end

local function UpdateKnobPosition(Input)
    local ThumbPosition = Thumb.AbsolutePosition
    local ThumbSize = Thumb.AbsoluteSize

    local Center = ThumbPosition + (ThumbSize / 2)

    local Relative = Vector2.new(
        Input.Position.X - Center.X,
        Input.Position.Y - Center.Y
    )

    local Radius = ThumbSize.X / 2
    local Distance = Relative.Magnitude

    if Distance > Radius then
        Relative = Relative.Unit * Radius
    end

    local Normalized = Relative / Radius
    TargetKnobPosition = Vector2.new((Normalized.X + 1) / 2, (Normalized.Y + 1) / 2)
    
    local Zone = GetZoneFromNormalized(Normalized.X, Normalized.Y)
    UpdateMovement(Zone)
end

local function ResetKnob()
    TargetKnobPosition = Vector2.new(0.5, 0.5)
    UpdateMovement("Center")
end

RunService.RenderStepped:Connect(function()
    local smoothed = CurrentKnobPosition:Lerp(TargetKnobPosition, 0.3)
    CurrentKnobPosition = smoothed
    
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new(CurrentKnobPosition.X, 0, CurrentKnobPosition.Y, 0)
end)

Knob.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        ActiveInput = Input
        UpdateKnobPosition(Input)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and Input == ActiveInput then
        UpdateKnobPosition(Input)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input == ActiveInput then
        Dragging = false
        ActiveInput = nil
        ResetKnob()
    end
end)

Jump.MouseButton1Down:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
end)

Jump.MouseButton1Up:Connect(function()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end)