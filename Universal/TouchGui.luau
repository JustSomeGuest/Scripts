if not game:IsLoaded() then
    game.Loaded:Wait()
end

pcall(loadstring, game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Utilities/Notifs.lua"))

local Env = (type(getgenv) == "function" and getgenv()) or _G

local function GetService(Name)
    local Svc = game:GetService(Name)
    return cloneref and cloneref(Svc) or Svc
end

local Hui = gethui and gethui() or GetService("CoreGui")
local TweenService = GetService("TweenService")
local StarterGui = GetService("StarterGui")
local Players = GetService("Players")
local UserInputService = GetService("UserInputService")
local VirtualInputManager = GetService("VirtualInputManager")
local RunService = GetService("RunService")

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

Env.TouchGui = Env.TouchGui or {}

if Env.TouchGui.IsLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "TouchGui",
        Text = "TouchGui is already running!",
        Duration = 4
    })
    return
end

Env.TouchGui.IsLoaded = true

local function IsDesktop()
    return not UserInputService.TouchEnabled
        and UserInputService.MouseEnabled
        and UserInputService.KeyboardEnabled
end

local function IsMobile()
    return UserInputService.TouchEnabled
        and not UserInputService.MouseEnabled
        and not UserInputService.KeyboardEnabled
end

if IsDesktop() then
    StarterGui:SetCore("SendNotification", {
        Title = "TouchGui",
        Text = "This script is intended for mobile devices only.",
        Duration = 5
    })
    return
end

if not IsMobile() then
    return
end

local Player = Players.LocalPlayer
local PlayerGui = Player:FindFirstChild("PlayerGui")
local TouchControlFrame = PlayerGui and PlayerGui:FindFirstChild("TouchGui") and PlayerGui.TouchGui:FindFirstChild("TouchControlFrame")
local OriginalJump = TouchControlFrame and TouchControlFrame:FindFirstChild("JumpButton")

local TouchGui = Instance.new("ScreenGui")
TouchGui.Name = UID()
TouchGui.ResetOnSpawn = false
TouchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
TouchGui.Parent = Hui

local function GetOppositePos(Position, AnchorPoint)
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
    ForwardLeft = {"W", "A"},
    Forward = {"W"},
    ForwardRight = {"W", "D"},
    Left = {"A"},
    Neutral = {},
    Right = {"D"},
    BackwardLeft = {"S", "A"},
    Backward = {"S"},
    BackwardRight = {"S", "D"},
}

local ActiveKeys = {W = false, A = false, S = false, D = false}

local function SendKey(Key, IsDown)
    local KeyCode = Enum.KeyCode[Key]

    if KeyCode then
        VirtualInputManager:SendKeyEvent(IsDown, KeyCode, false, game)
    end
end

local function UpdateMovement(Zone)
    local KeysToPress = ZoneKeys[Zone] or {}

    for Key, IsActive in pairs(ActiveKeys) do
        local ShouldBeActive = false

        for _, ZoneKey in ipairs(KeysToPress) do
            if ZoneKey == Key then
                ShouldBeActive = true
                break
            end
        end

        if ShouldBeActive and not IsActive then
            ActiveKeys[Key] = true
            SendKey(Key, true)
        elseif not ShouldBeActive and IsActive then
            ActiveKeys[Key] = false
            SendKey(Key, false)
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
Jump.Name = UID()
Jump.ScaleType = Enum.ScaleType.Fit
Jump.Parent = TouchGui

local JumpRatio = Instance.new("UIAspectRatioConstraint")
JumpRatio.Name = UID()
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
Thumb.Name = UID()
Thumb.ScaleType = Enum.ScaleType.Fit
Thumb.Parent = TouchGui

local ThumbRatio = Instance.new("UIAspectRatioConstraint")
ThumbRatio.Name = UID()
ThumbRatio.Parent = Thumb

local Knob = Instance.new("ImageLabel")
Knob.Active = true
Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Knob.BackgroundTransparency = 1
Knob.BorderSizePixel = 0
Knob.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
Knob.ImageRectOffset = Vector2.new(1, 1)
Knob.ImageRectSize = Vector2.new(144, 144)
Knob.Name = UID()
Knob.ScaleType = Enum.ScaleType.Fit
Knob.Size = UDim2.new(0.45, 0, 0.45, 0)
Knob.Parent = Thumb

local KnobRatio = Instance.new("UIAspectRatioConstraint")
KnobRatio.Name = UID()
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

    local OppositePos, OppositeAnchor = GetOppositePos(OriginalJump.Position, OriginalJump.AnchorPoint)

    Thumb.Position = OppositePos
    Thumb.AnchorPoint = OppositeAnchor
    Thumb.Size = OriginalJump.Size

    OriginalJump:GetPropertyChangedSignal("Position"):Connect(function()
        local NewOppositePos, NewOppositeAnchor = GetOppositePos(OriginalJump.Position, OriginalJump.AnchorPoint)

        Thumb.Position = NewOppositePos
        Thumb.AnchorPoint = NewOppositeAnchor
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
        Horizontal = ""
    end

    if Y < -0.33 then
        Vertical = "Forward"
    elseif Y > 0.33 then
        Vertical = "Backward"
    else
        Vertical = ""
    end

    if Vertical == "" and Horizontal == "" then
        return "Neutral"
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

    TargetKnobPosition = Vector2.new(
        (Normalized.X + 1) / 2,
        (Normalized.Y + 1) / 2
    )

    local Zone = GetZoneFromNormalized(Normalized.X, Normalized.Y)
    UpdateMovement(Zone)
end

local function ResetKnob()
    TargetKnobPosition = Vector2.new(0.5, 0.5)
    UpdateMovement("Neutral")
end

RunService.RenderStepped:Connect(function()
    local Smoothed = CurrentKnobPosition:Lerp(TargetKnobPosition, 0.3)

    CurrentKnobPosition = Smoothed
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new(
        CurrentKnobPosition.X,
        0,
        CurrentKnobPosition.Y,
        0
    )
end)

Thumb.InputBegan:Connect(function(Input)
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