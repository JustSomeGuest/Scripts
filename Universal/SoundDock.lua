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
local RunService = GetService("RunService")
local StarterGui = GetService("StarterGui")
local UserInputService = GetService("UserInputService")
local HttpService = GetService("HttpService")
local Workspace = GetService("Workspace")

local WriteFile = writefile or function() end
local IsFile = isfile or function() return false end
local IsFolder = isfolder or function() return false end
local MakeFolder = makefolder or function() end
local ListFiles = listfiles or function() return {} end

Env.SoundDock = Env.SoundDock or {}

if Env.SoundDock.IsLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "SoundDock Music Player",
        Text = "SoundDock is already running!",
        Duration = 4
    })
    return
end

Env.SoundDock.IsLoaded = true

local SoundDockFolder = "SoundDock"
local SongsFolder = SoundDockFolder .. "/Songs"
local SettingsPath = SoundDockFolder .. "/Settings.json"

if not IsFolder(SoundDockFolder) then
    MakeFolder(SoundDockFolder)
end

if not IsFolder(SongsFolder) then
    MakeFolder(SongsFolder)
end

local Settings = {
    IsLooped = false,
    Volume = 1,
    Speed = 1
}

if IsFile(SettingsPath) then
    local Success, Data = pcall(function()
        return HttpService:JSONDecode(readfile(SettingsPath))
    end)

    if Success and type(Data) == "table" then
        for Key, Value in pairs(Data) do
            Settings[Key] = Value
        end
    end
end

local SoundDock = Instance.new("ScreenGui", Hui)
local Toggle = Instance.new("ImageButton", SoundDock)
local TogglePadding = Instance.new("UIPadding", Toggle)
local ToggleCorner = Instance.new("UICorner", Toggle)
local ToggleRatio = Instance.new("UIAspectRatioConstraint", Toggle)
local ToggleIcon = Instance.new("ImageLabel", Toggle)
local ToggleGradient = Instance.new("UIGradient", Toggle)
local ToggleStroke = Instance.new("UIStroke", Toggle)

local MainFrame = Instance.new("Frame", SoundDock)
local SongName = Instance.new("TextLabel", MainFrame)
local SongNameRatio = Instance.new("UIAspectRatioConstraint", SongName)
local Previous = Instance.new("ImageButton", MainFrame)
local PreviousRatio = Instance.new("UIAspectRatioConstraint", Previous)
local MainFrameRatio = Instance.new("UIAspectRatioConstraint", MainFrame)
local MainFrameStroke = Instance.new("UIStroke", MainFrame)
local BarBackground = Instance.new("Frame", MainFrame)
local BarBackgroundCorner = Instance.new("UICorner", BarBackground)
local ProgressBar = Instance.new("Frame", BarBackground)
local ProgressBarCorner = Instance.new("UICorner", ProgressBar)
local Next = Instance.new("ImageButton", MainFrame)
local NextRatio = Instance.new("UIAspectRatioConstraint", Next)
local MainFrameCorner = Instance.new("UICorner", MainFrame)
local MainFrameGradient = Instance.new("UIGradient", MainFrame)
local SongDuration = Instance.new("TextLabel", MainFrame)
local SongDurationRatio = Instance.new("UIAspectRatioConstraint", SongDuration)
local Loop = Instance.new("ImageButton", MainFrame)
local Pause = Instance.new("ImageButton", MainFrame)
local PauseRatio = Instance.new("UIAspectRatioConstraint", Pause)
local SettingsButton = Instance.new("ImageButton", MainFrame)

local SettingsFrame = Instance.new("Frame", MainFrame)
local SettingsFrameStroke = Instance.new("UIStroke", SettingsFrame)
local SettingsFrameCorner = Instance.new("UICorner", SettingsFrame)
local SettingsFrameGradient = Instance.new("UIGradient", SettingsFrame)
local Title = Instance.new("TextLabel", SettingsFrame)
local TitleSizeCons = Instance.new("UISizeConstraint", Title)
local SettingsListLayout = Instance.new("UIListLayout", SettingsFrame)
local OptionsScrollingFrame = Instance.new("ScrollingFrame", SettingsFrame)
local OptionsListLayout = Instance.new("UIListLayout", OptionsScrollingFrame)
local OptionsPadding = Instance.new("UIPadding", OptionsScrollingFrame)

local VolumeFrame = Instance.new("Frame", OptionsScrollingFrame)
local VolumeListLayout = Instance.new("UIListLayout", VolumeFrame)
local VolumeLabel = Instance.new("TextLabel", VolumeFrame)
local VolumeBox = Instance.new("TextBox", VolumeFrame)
local VolumeBoxCorner = Instance.new("UICorner", VolumeBox)
local VolumeBoxPadding = Instance.new("UIPadding", VolumeBox)
local VolumeSizeCons = Instance.new("UISizeConstraint", VolumeBox)

local SpeedFrame = Instance.new("Frame", OptionsScrollingFrame)
local SpeedListLayout = Instance.new("UIListLayout", SpeedFrame)
local SpeedLabel = Instance.new("TextLabel", SpeedFrame)
local SpeedBox = Instance.new("TextBox", SpeedFrame)
local SpeedBoxCorner = Instance.new("UICorner", SpeedBox)
local SpeedBoxPadding = Instance.new("UIPadding", SpeedBox)
local SpeedSizeCons = Instance.new("UISizeConstraint", SpeedBox)

SoundDock.Name = "SoundDock"
SoundDock.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Toggle.Name = "Toggle"
Toggle.BorderSizePixel = 0
Toggle.BackgroundTransparency = 0.2
Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Size = UDim2.new(0, 44, 0, 44)
Toggle.Position = UDim2.new(0, 20, 0, 4)

TogglePadding.PaddingTop = UDim.new(0, 10)
TogglePadding.PaddingRight = UDim.new(0, 10)
TogglePadding.PaddingLeft = UDim.new(0, 10)
TogglePadding.PaddingBottom = UDim.new(0, 10)

ToggleCorner.CornerRadius = UDim.new(1, 0)

ToggleIcon.Name = "ToggleIcon"
ToggleIcon.BorderSizePixel = 0
ToggleIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleIcon.Image = "rbxassetid://7059338404"
ToggleIcon.Size = UDim2.new(1, 0, 1, 0)
ToggleIcon.BackgroundTransparency = 1

ToggleGradient.Rotation = 90
ToggleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(53, 53, 53)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 7, 7))
}

ToggleStroke.Transparency = 0.33
ToggleStroke.Thickness = 3

MainFrame.Name = "MainFrame"
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Size = UDim2.new(0, 284, 0, 184)
MainFrame.Position = UDim2.new(0, 76, 0, 4)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Visible = false

SongName.Name = "SongName"
SongName.TextWrapped = true
SongName.BorderSizePixel = 0
SongName.TextSize = 14
SongName.TextScaled = true
SongName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SongName.FontFace = Font.new(
    "rbxassetid://11702779517",
    Enum.FontWeight.SemiBold,
    Enum.FontStyle.Normal
)
SongName.TextColor3 = Color3.fromRGB(255, 255, 255)
SongName.BackgroundTransparency = 1
SongName.Size = UDim2.new(0.74167, 0, 0.2193, 0)
SongName.BorderColor3 = Color3.fromRGB(0, 0, 0)
SongName.Text = ""
SongName.Position = UDim2.new(0.13056, 0, 0.07456, 0)

SongNameRatio.AspectRatio = 5.34

Previous.Name = "Previous"
Previous.BorderSizePixel = 0
Previous.BackgroundTransparency = 1
Previous.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Previous.Image = "rbxassetid://12008863261"
Previous.Size = UDim2.new(0.15833, 0, 0.25, 0)
Previous.BorderColor3 = Color3.fromRGB(0, 0, 0)
Previous.Rotation = -180
Previous.Position = UDim2.new(0.19167, 0, 0.53947, 0)

MainFrameRatio.AspectRatio = 1.579

MainFrameStroke.Transparency = 0.33
MainFrameStroke.Thickness = 3

BarBackground.Name = "BarBackground"
BarBackground.BorderSizePixel = 0
BarBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BarBackground.Size = UDim2.new(0.90833, 0, 0.01754, 0)
BarBackground.Position = UDim2.new(0.04722, 0, 0.42544, 0)
BarBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)

BarBackgroundCorner.CornerRadius = UDim.new(1, 0)

ProgressBar.Name = "Bar"
ProgressBar.BorderSizePixel = 0
ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProgressBar.Size = UDim2.new(0.01249, 0, 1, 0)
ProgressBar.Position = UDim2.new(-0.00171, 0, -0.07454, 0)
ProgressBar.BorderColor3 = Color3.fromRGB(0, 0, 0)

ProgressBarCorner.CornerRadius = UDim.new(1, 0)

Next.Name = "Next"
Next.BorderSizePixel = 0
Next.BackgroundTransparency = 1
Next.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Next.Image = "rbxassetid://12008863261"
Next.Size = UDim2.new(0.15833, 0, 0.25, 0)
Next.BorderColor3 = Color3.fromRGB(0, 0, 0)
Next.Position = UDim2.new(0.66944, 0, 0.53947, 0)

MainFrameCorner.CornerRadius = UDim.new(0, 10)

MainFrameGradient.Rotation = 90
MainFrameGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(53, 53, 53)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 7, 7))
}

SongDuration.Name = "SongDuration"
SongDuration.TextWrapped = true
SongDuration.BorderSizePixel = 0
SongDuration.TextSize = 14
SongDuration.TextScaled = true
SongDuration.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SongDuration.FontFace = Font.new(
    "rbxassetid://11702779517",
    Enum.FontWeight.SemiBold,
    Enum.FontStyle.Normal
)
SongDuration.TextColor3 = Color3.fromRGB(255, 255, 255)
SongDuration.BackgroundTransparency = 1
SongDuration.Size = UDim2.new(0.55556, 0, 0.0614, 0)
SongDuration.BorderColor3 = Color3.fromRGB(0, 0, 0)
SongDuration.Text = "0:00 / 0:00"
SongDuration.Position = UDim2.new(0.21944, 0, 0.35965, 0)

SongDurationRatio.AspectRatio = 14.28572

Loop.Name = "Loop"
Loop.BorderSizePixel = 0
Loop.BackgroundTransparency = 1
Loop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Loop.Image = "rbxassetid://127077202039990"
Loop.Size = UDim2.new(0, 24, 0, 24)
Loop.BorderColor3 = Color3.fromRGB(0, 0, 0)
Loop.Position = UDim2.new(0.01201, 0, 0.84242, 0)

Pause.Name = "Pause"
Pause.BorderSizePixel = 0
Pause.BackgroundTransparency = 1
Pause.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Pause.Image = "rbxassetid://12099513379"
Pause.Size = UDim2.new(0.15833, 0, 0.25, 0)
Pause.BorderColor3 = Color3.fromRGB(0, 0, 0)
Pause.Position = UDim2.new(0.41944, 0, 0.53947, 0)

SettingsButton.Name = "Settings"
SettingsButton.BorderSizePixel = 0
SettingsButton.BackgroundTransparency = 1
SettingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SettingsButton.Image = "rbxassetid://9405931578"
SettingsButton.Size = UDim2.new(0, 24, 0, 24)
SettingsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
SettingsButton.Position = UDim2.new(0, 256, 0.84, 0)

SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Visible = false
SettingsFrame.BorderSizePixel = 0
SettingsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SettingsFrame.Size = UDim2.new(0, 284, 0, 180)
SettingsFrame.Position = UDim2.new(1, 12, 0, 0)
SettingsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
SettingsFrame.BackgroundTransparency = 0.2

SettingsFrameStroke.Transparency = 0.33
SettingsFrameStroke.Thickness = 3

SettingsFrameCorner.CornerRadius = UDim.new(0, 10)

SettingsFrameGradient.Rotation = 90
SettingsFrameGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(53, 53, 53)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 7, 7))
}

Title.Name = "Title"
Title.TextWrapped = true
Title.BorderSizePixel = 0
Title.TextSize = 14
Title.TextScaled = true
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.FontFace = Font.new(
    "rbxassetid://11702779517",
    Enum.FontWeight.SemiBold,
    Enum.FontStyle.Normal
)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title.Text = "Settings"
Title.LayoutOrder = 1

TitleSizeCons.MaxSize = Vector2.new(math.huge, 28)

SettingsListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SettingsListLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SettingsListLayout.Padding = UDim.new(0, 4)
SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder

OptionsScrollingFrame.Name = "Options"
OptionsScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
OptionsScrollingFrame.BorderSizePixel = 0
OptionsScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OptionsScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
OptionsScrollingFrame.Size = UDim2.new(0, 272, 0, 140)
OptionsScrollingFrame.ScrollBarThickness = 0
OptionsScrollingFrame.LayoutOrder = 2
OptionsScrollingFrame.BackgroundTransparency = 1

OptionsListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
OptionsListLayout.Padding = UDim.new(0, 6)
OptionsListLayout.SortOrder = Enum.SortOrder.LayoutOrder

OptionsPadding.PaddingRight = UDim.new(0, 4)
OptionsPadding.PaddingLeft = UDim.new(0, 4)

VolumeFrame.Name = "Volume"
VolumeFrame.BorderSizePixel = 0
VolumeFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
VolumeFrame.Size = UDim2.new(0, 270, 0, 22)
VolumeFrame.LayoutOrder = 1
VolumeFrame.BackgroundTransparency = 1

VolumeListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
VolumeListLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
VolumeListLayout.Padding = UDim.new(0, 4)
VolumeListLayout.SortOrder = Enum.SortOrder.LayoutOrder
VolumeListLayout.FillDirection = Enum.FillDirection.Horizontal

VolumeLabel.Name = "VolumeLabel"
VolumeLabel.TextWrapped = true
VolumeLabel.BorderSizePixel = 0
VolumeLabel.TextSize = 14
VolumeLabel.TextXAlignment = Enum.TextXAlignment.Left
VolumeLabel.TextScaled = true
VolumeLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
VolumeLabel.FontFace = Font.new(
    "rbxassetid://11702779517",
    Enum.FontWeight.SemiBold,
    Enum.FontStyle.Normal
)
VolumeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
VolumeLabel.BackgroundTransparency = 1
VolumeLabel.Size = UDim2.new(1, 0, 0, 28)
VolumeLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
VolumeLabel.Text = "Volume (0.5-10)"
VolumeLabel.LayoutOrder = 1

VolumeBox.Name = "VolumeBox"
VolumeBox.BorderSizePixel = 0
VolumeBox.TextWrapped = true
VolumeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
VolumeBox.TextScaled = true
VolumeBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
VolumeBox.FontFace = Font.new(
    "rbxasset://fonts/families/GothamSSm.json",
    Enum.FontWeight.Medium,
    Enum.FontStyle.Normal
)
VolumeBox.AutomaticSize = Enum.AutomaticSize.X
VolumeBox.Size = UDim2.new(0, 0, 0, 34)
VolumeBox.Text = ""
VolumeBox.PlaceholderText = tostring(Settings.Volume)
VolumeBox.LayoutOrder = 2
VolumeBox.BackgroundTransparency = 0.5

VolumeBoxPadding.PaddingTop = UDim.new(0, 4)
VolumeBoxPadding.PaddingRight = UDim.new(0, 6)
VolumeBoxPadding.PaddingLeft = UDim.new(0, 6)
VolumeBoxPadding.PaddingBottom = UDim.new(0, 4)

VolumeSizeCons.MinSize = Vector2.new(10, 0)

SpeedFrame.Name = "Speed"
SpeedFrame.BorderSizePixel = 0
SpeedFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedFrame.Size = UDim2.new(0, 270, 0, 22)
SpeedFrame.LayoutOrder = 2
SpeedFrame.BackgroundTransparency = 1

SpeedListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SpeedListLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SpeedListLayout.Padding = UDim.new(0, 4)
SpeedListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SpeedListLayout.FillDirection = Enum.FillDirection.Horizontal

SpeedLabel.Name = "SpeedLabel"
SpeedLabel.TextWrapped = true
SpeedLabel.BorderSizePixel = 0
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.TextScaled = true
SpeedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.FontFace = Font.new(
    "rbxassetid://11702779517",
    Enum.FontWeight.SemiBold,
    Enum.FontStyle.Normal
)
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Size = UDim2.new(1, 0, 0, 28)
SpeedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
SpeedLabel.Text = "Playback Speed (0.25-3)"
SpeedLabel.LayoutOrder = 1

SpeedBox.Name = "SpeedBox"
SpeedBox.BorderSizePixel = 0
SpeedBox.TextWrapped = true
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.TextScaled = true
SpeedBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedBox.FontFace = Font.new(
    "rbxasset://fonts/families/GothamSSm.json",
    Enum.FontWeight.Medium,
    Enum.FontStyle.Normal
)
SpeedBox.AutomaticSize = Enum.AutomaticSize.X
SpeedBox.Size = UDim2.new(0, 0, 0, 34)
SpeedBox.Text = ""
SpeedBox.PlaceholderText = tostring(Settings.Speed)
SpeedBox.LayoutOrder = 2
SpeedBox.BackgroundTransparency = 0.5

SpeedBoxPadding.PaddingTop = UDim.new(0, 4)
SpeedBoxPadding.PaddingRight = UDim.new(0, 6)
SpeedBoxPadding.PaddingLeft = UDim.new(0, 6)
SpeedBoxPadding.PaddingBottom = UDim.new(0, 4)

SpeedSizeCons.MinSize = Vector2.new(10, 0)

local function Dragify(Frame)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPos

    local function ClampPosition(X, Y)
        local Camera = Workspace.CurrentCamera
        local Viewport = Camera.ViewportSize
        local Size = Frame.AbsoluteSize
        local Padding = 3

        X = math.clamp(X, Padding, Viewport.X - Size.X - Padding)
        Y = math.clamp(Y, Padding, Viewport.Y - Size.Y - Padding)

        return X, Y
    end

    Frame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then

            Dragging = true
            DragStart = Input.Position
            StartPos = Frame.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            local X = StartPos.X.Offset + Delta.X
            local Y = StartPos.Y.Offset + Delta.Y

            X, Y = ClampPosition(X, Y)

            Frame.Position = UDim2.new(
                StartPos.X.Scale,
                X,
                StartPos.Y.Scale,
                Y
            )
        end
    end)
end

Dragify(MainFrame)

local Songs = {}

local ListSuccess, Files = pcall(ListFiles, SongsFolder)

if ListSuccess then
    for _, File in ipairs(Files) do
        if type(File) == "string" and File:sub(-4):lower() == ".mp3" then
            table.insert(Songs, File)
        end
    end
end

if #Songs == 0 then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "SoundDock",
            Text = "No MP3 files found. Drop your songs into SoundDock/Songs folder and re-execute.",
            Duration = 6
        })
    end)

    SoundDock:Destroy()
    return
end

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "SoundDock",
        Text = #Songs .. " song(s) loaded from SoundDock/Songs",
        Duration = 5
    })
end)

local CurrentSongIndex = 1
local CurrentSound
local IsPaused = false
local CurrentTween
local CurrentSongTime = 0
local PauseImage = "rbxassetid://13980756617"
local PausedImage = "rbxassetid://12099513379"
local LoopOffColor = Loop.ImageColor3
local LoopOnColor = Color3.fromRGB(0, 170, 255)
local FadeTime = 0.5
local FadeTweenInfo = TweenInfo.new(FadeTime, Enum.EasingStyle.Linear)
local IsLooping = Settings.IsLooped or false

Loop.ImageColor3 = IsLooping and LoopOnColor or LoopOffColor

local function SaveSettings()
    local Data = {
        IsLooped = IsLooping,
        Volume = Settings.Volume,
        Speed = Settings.Speed
    }

    local Success, Encoded = pcall(function()
        return HttpService:JSONEncode(Data)
    end)

    if Success then
        pcall(function()
            WriteFile(SettingsPath, Encoded)
        end)
    end
end

local function FormatTime(Seconds)
    Seconds = math.max(0, Seconds or 0)

    local Minutes = math.floor(Seconds / 60)
    local RemainingSeconds = math.floor(Seconds % 60)

    return string.format("%d:%02d", Minutes, RemainingSeconds)
end

local function UpdateSongDurationLabel()
    if not CurrentSound then
        return
    end

    local TimeLength = CurrentSound.TimeLength or 0

    SongDuration.Text =
        FormatTime(CurrentSongTime)
        .. " / "
        .. FormatTime(TimeLength)
end

local function FadeOut(Sound)
    if not Sound then
        return
    end

    local Tween = TweenService:Create(
        Sound,
        FadeTweenInfo,
        {Volume = 0}
    )

    Tween:Play()
    Tween.Completed:Wait()
end

local function FadeIn(Sound)
    if not Sound then
        return
    end

    Sound.Volume = 0

    local Tween = TweenService:Create(
        Sound,
        FadeTweenInfo,
        {Volume = Settings.Volume}
    )

    Tween:Play()
end

local function UpdateProgressBar(Sound, StartTime)
    if not Sound then
        return
    end

    ProgressBar.Visible = true

    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end

    local TimeLength = Sound.TimeLength or 1

    if TimeLength <= 0 then
        ProgressBar.Size = UDim2.new(0, 0, 1, 0)
        return
    end

    local RemainingTime = math.max(0.001, TimeLength - StartTime)
    local StartProgress = math.clamp(StartTime / TimeLength, 0, 1)

    ProgressBar.Size = UDim2.new(StartProgress, 0, 1, 0)

    if IsPaused then
        return
    end

    local TweenInfoObject = TweenInfo.new(
        RemainingTime,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut
    )

    CurrentTween = TweenService:Create(
        ProgressBar,
        TweenInfoObject,
        {Size = UDim2.new(1, 0, 1, 0)}
    )

    CurrentTween:Play()
end

local function StopCurrentSong()
    if CurrentSound then
        local Sound = CurrentSound
        CurrentSound = nil

        pcall(function()
            FadeOut(Sound)
            Sound:Stop()
            Sound:Destroy()
        end)
    end

    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end

    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    CurrentSongTime = 0

    UpdateSongDurationLabel()
end

local function PlaySong(Index)
    if #Songs == 0 then
        return
    end

    StopCurrentSong()

    if Index < 1 then
        Index = #Songs
    elseif Index > #Songs then
        Index = 1
    end

    CurrentSongIndex = Index

    local Path = Songs[CurrentSongIndex]

    if not Path then
        return
    end

    local Sound = Instance.new("Sound", Workspace)

    Sound.SoundId = getcustomasset(Path)
    Sound.Volume = Settings.Volume
    Sound.PlaybackSpeed = Settings.Speed

    local Filename = Path:match("([^/\\]+)$") or "Unknown"
    Filename = Filename:gsub("%.mp3$", "")

    SongName.Text = Filename

    CurrentSound = Sound
    CurrentSongTime = 0
    IsPaused = false

    Sound:Play()
    FadeIn(Sound)

    ProgressBar.Visible = true
    Pause.Image = PauseImage

    UpdateProgressBar(Sound, 0)

    Sound.Ended:Connect(function()
        if Sound ~= CurrentSound then
            return
        end

        if IsLooping then
            PlaySong(CurrentSongIndex)
        else
            PlaySong(CurrentSongIndex + 1)
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if CurrentSound and CurrentSound.IsPlaying and not IsPaused then
        CurrentSongTime = CurrentSound.TimePosition or 0
        UpdateSongDurationLabel()
    end
end)

Pause.MouseButton1Click:Connect(function()
    if not CurrentSound then
        return
    end

    IsPaused = not IsPaused

    if IsPaused then
        pcall(function()
            FadeOut(CurrentSound)
            CurrentSound:Pause()
        end)

        Pause.Image = PausedImage

        if CurrentTween then
            CurrentTween:Cancel()
            CurrentTween = nil
        end
    else
        pcall(function()
            CurrentSound:Resume()
            FadeIn(CurrentSound)
        end)

        Pause.Image = PauseImage
        CurrentSongTime = CurrentSound.TimePosition or 0

        UpdateProgressBar(CurrentSound, CurrentSongTime)
    end
end)

Next.MouseButton1Click:Connect(function()
    PlaySong(CurrentSongIndex + 1)
end)

Previous.MouseButton1Click:Connect(function()
    PlaySong(CurrentSongIndex - 1)
end)

Loop.MouseButton1Click:Connect(function()
    IsLooping = not IsLooping
    Loop.ImageColor3 = IsLooping and LoopOnColor or LoopOffColor

    SaveSettings()
end)

Toggle.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

SettingsButton.MouseButton1Click:Connect(function()
    SettingsFrame.Visible = not SettingsFrame.Visible

    if SettingsFrame.Visible then
        SettingsButton.ImageColor3 = LoopOnColor
    else
        SettingsButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

VolumeBox.FocusLost:Connect(function()
    local Value = tonumber(VolumeBox.Text)

    if Value then
        Value = math.clamp(Value, 0.5, 10)

        Settings.Volume = Value

        if CurrentSound then
            pcall(function()
                CurrentSound.Volume = Value
            end)
        end

        VolumeBox.PlaceholderText = tostring(Value)

        SaveSettings()
    end

    VolumeBox.Text = ""
end)

SpeedBox.FocusLost:Connect(function()
    local Value = tonumber(SpeedBox.Text)

    if Value then
        Value = math.clamp(Value, 0.25, 3)

        Settings.Speed = Value

        if CurrentSound then
            pcall(function()
                CurrentSound.PlaybackSpeed = Value
            end)
        end

        SpeedBox.PlaceholderText = tostring(Value)

        SaveSettings()
    end

    SpeedBox.Text = ""
end)

PlaySong(CurrentSongIndex)
