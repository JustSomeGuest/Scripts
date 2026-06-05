if not game:IsLoaded() then 
    game.Loaded:Wait()
end

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

local WriteFile = default("function", writefile, function() return end)
local IsFile = default("function", isfile, function() return end)
local IsFolder = default("function", isfolder, function() return end)
local MakeFolder = default("function", makefolder, function() return end)
local ListFiles = default("function", listfiles, function() return end)

getgenv().SoundDock = getgenv().SoundDock or {}

if getgenv().SoundDock.isLoaded then
    Services.StarterGui:SetCore("SendNotification", {
        Title = "SoundDock Music Player",
        Text = "SoundDock is already running!",
        Duration = 4
    })
    return
end

getgenv().SoundDock.isLoaded = true

local TweenService = Services.TweenService
local RunService = Services.RunService
local StarterGui = Services.StarterGui
local UserInputService = Services.UserInputService
local CoreGui = (gethui and select(2, pcall(gethui))) or Services.CoreGui

local SoundDockFolder = "SoundDock"
local SongsFolder = SoundDockFolder .. "/Songs"
local SettingsPath = SoundDockFolder .. "/Settings.json"

if not IsFolder(SoundDockFolder) then MakeFolder(SoundDockFolder) end
if not IsFolder(SongsFolder) then MakeFolder(SongsFolder) end

local settings = {
    IsLooped = false,
    Volume = 1,
    Speed = 1
}

if IsFile(SettingsPath) then
    local success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(SettingsPath))
    end)
    if success and type(data) == "table" then
        for k, v in pairs(data) do
            settings[k] = v
        end
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SoundDock"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local Toggle = Instance.new("ImageButton")
Toggle.Name = "Toggle"
Toggle.BorderSizePixel = 0
Toggle.BackgroundTransparency = 0.2
Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Size = UDim2.new(0, 44, 0, 44)
Toggle.Position = UDim2.new(0, 20, 0, 4)
Toggle.Parent = ScreenGui

local TogglePadding = Instance.new("UIPadding")
TogglePadding.PaddingTop = UDim.new(0, 10)
TogglePadding.PaddingRight = UDim.new(0, 10)
TogglePadding.PaddingLeft = UDim.new(0, 10)
TogglePadding.PaddingBottom = UDim.new(0, 10)
TogglePadding.Parent = Toggle

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = Toggle

local ToggleRatio = Instance.new("UIAspectRatioConstraint")
ToggleRatio.Parent = Toggle

local ToggleIcon = Instance.new("ImageLabel")
ToggleIcon.Name = "ToggleIcon"
ToggleIcon.BorderSizePixel = 0
ToggleIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleIcon.Image = "rbxassetid://7059338404"
ToggleIcon.Size = UDim2.new(1, 0, 1, 0)
ToggleIcon.BackgroundTransparency = 1
ToggleIcon.Parent = Toggle

local ToggleGradient = Instance.new("UIGradient")
ToggleGradient.Rotation = 90
ToggleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.000, Color3.fromRGB(53, 53, 53)),
    ColorSequenceKeypoint.new(1.000, Color3.fromRGB(7, 7, 7))
}
ToggleGradient.Parent = Toggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Transparency = 0.33
ToggleStroke.Thickness = 3
ToggleStroke.Parent = Toggle

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Size = UDim2.new(0, 284, 0, 184)
MainFrame.Position = UDim2.new(0, 76, 0, 4)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local SongName = Instance.new("TextLabel")
SongName.Name = "SongName"
SongName.TextWrapped = true
SongName.BorderSizePixel = 0
SongName.TextSize = 14
SongName.TextScaled = true
SongName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SongName.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
SongName.TextColor3 = Color3.fromRGB(255, 255, 255)
SongName.BackgroundTransparency = 1
SongName.Size = UDim2.new(0.74167, 0, 0.2193, 0)
SongName.BorderColor3 = Color3.fromRGB(0, 0, 0)
SongName.Text = ""
SongName.Position = UDim2.new(0.13056, 0, 0.07456, 0)
SongName.Parent = MainFrame

local SongNameRatio = Instance.new("UIAspectRatioConstraint")
SongNameRatio.AspectRatio = 5.34
SongNameRatio.Parent = SongName

local Previous = Instance.new("ImageButton")
Previous.Name = "Previous"
Previous.BorderSizePixel = 0
Previous.BackgroundTransparency = 1
Previous.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Previous.Image = "rbxassetid://12008863261"
Previous.Size = UDim2.new(0.15833, 0, 0.25, 0)
Previous.BorderColor3 = Color3.fromRGB(0, 0, 0)
Previous.Rotation = -180
Previous.Position = UDim2.new(0.19167, 0, 0.53947, 0)
Previous.Parent = MainFrame

local PreviousRatio = Instance.new("UIAspectRatioConstraint")
PreviousRatio.Parent = Previous

local MainFrameRatio = Instance.new("UIAspectRatioConstraint")
MainFrameRatio.AspectRatio = 1.579
MainFrameRatio.Parent = MainFrame

local MainFrameStroke = Instance.new("UIStroke")
MainFrameStroke.Transparency = 0.33
MainFrameStroke.Thickness = 3
MainFrameStroke.Parent = MainFrame

local BarBackground = Instance.new("Frame")
BarBackground.Name = "BarBackground"
BarBackground.BorderSizePixel = 0
BarBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BarBackground.Size = UDim2.new(0.90833, 0, 0.01754, 0)
BarBackground.Position = UDim2.new(0.04722, 0, 0.42544, 0)
BarBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
BarBackground.Parent = MainFrame

local BarBackgroundCorner = Instance.new("UICorner")
BarBackgroundCorner.CornerRadius = UDim.new(1, 0)
BarBackgroundCorner.Parent = BarBackground

local ProgressBar = Instance.new("Frame")
ProgressBar.Name = "Bar"
ProgressBar.BorderSizePixel = 0
ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProgressBar.Size = UDim2.new(0.01249, 0, 1, 0)
ProgressBar.Position = UDim2.new(-0.00171, 0, -0.07454, 0)
ProgressBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
ProgressBar.Parent = BarBackground

local ProgressBarCorner = Instance.new("UICorner")
ProgressBarCorner.CornerRadius = UDim.new(1, 0)
ProgressBarCorner.Parent = ProgressBar

local Next = Instance.new("ImageButton")
Next.Name = "Next"
Next.BorderSizePixel = 0
Next.BackgroundTransparency = 1
Next.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Next.Image = "rbxassetid://12008863261"
Next.Size = UDim2.new(0.15833, 0, 0.25, 0)
Next.BorderColor3 = Color3.fromRGB(0, 0, 0)
Next.Position = UDim2.new(0.66944, 0, 0.53947, 0)
Next.Parent = MainFrame

local NextRatio = Instance.new("UIAspectRatioConstraint")
NextRatio.Parent = Next

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 10)
MainFrameCorner.Parent = MainFrame

local MainFrameGradient = Instance.new("UIGradient")
MainFrameGradient.Rotation = 90
MainFrameGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.000, Color3.fromRGB(53, 53, 53)),
    ColorSequenceKeypoint.new(1.000, Color3.fromRGB(7, 7, 7))
}
MainFrameGradient.Parent = MainFrame

local SongDuration = Instance.new("TextLabel")
SongDuration.Name = "SongDuration"
SongDuration.TextWrapped = true
SongDuration.BorderSizePixel = 0
SongDuration.TextSize = 14
SongDuration.TextScaled = true
SongDuration.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SongDuration.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
SongDuration.TextColor3 = Color3.fromRGB(255, 255, 255)
SongDuration.BackgroundTransparency = 1
SongDuration.Size = UDim2.new(0.55556, 0, 0.0614, 0)
SongDuration.BorderColor3 = Color3.fromRGB(0, 0, 0)
SongDuration.Text = "0:00 / 0:00"
SongDuration.Position = UDim2.new(0.21944, 0, 0.35965, 0)
SongDuration.Parent = MainFrame

local SongDurationRatio = Instance.new("UIAspectRatioConstraint")
SongDurationRatio.AspectRatio = 14.28572
SongDurationRatio.Parent = SongDuration

local Loop = Instance.new("ImageButton")
Loop.Name = "Loop"
Loop.BorderSizePixel = 0
Loop.BackgroundTransparency = 1
Loop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Loop.Image = "rbxassetid://127077202039990"
Loop.Size = UDim2.new(0, 24, 0, 24)
Loop.BorderColor3 = Color3.fromRGB(0, 0, 0)
Loop.Position = UDim2.new(0.01201, 0, 0.84242, 0)
Loop.Parent = MainFrame

local Pause = Instance.new("ImageButton")
Pause.Name = "Pause"
Pause.BorderSizePixel = 0
Pause.BackgroundTransparency = 1
Pause.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Pause.Image = "rbxassetid://12099513379"
Pause.Size = UDim2.new(0.15833, 0, 0.25, 0)
Pause.BorderColor3 = Color3.fromRGB(0, 0, 0)
Pause.Position = UDim2.new(0.41944, 0, 0.53947, 0)
Pause.Parent = MainFrame

local PauseRatio = Instance.new("UIAspectRatioConstraint")
PauseRatio.Parent = Pause

local Settings = Instance.new("ImageButton")
Settings.Name = "Settings"
Settings.BorderSizePixel = 0
Settings.BackgroundTransparency = 1
Settings.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Settings.Image = "rbxassetid://9405931578"
Settings.Size = UDim2.new(0, 24, 0, 24)
Settings.BorderColor3 = Color3.fromRGB(0, 0, 0)
Settings.Position = UDim2.new(0, 256, 0.84, 0)
Settings.Parent = MainFrame

local SettingsFrame = Instance.new("Frame")
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Visible = false
SettingsFrame.BorderSizePixel = 0
SettingsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SettingsFrame.Size = UDim2.new(0, 284, 0, 180)
SettingsFrame.Position = UDim2.new(1, 12, 0, 0)
SettingsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
SettingsFrame.BackgroundTransparency = 0.2
SettingsFrame.Parent = MainFrame

local SettingsFrameStroke = Instance.new("UIStroke")
SettingsFrameStroke.Transparency = 0.33
SettingsFrameStroke.Thickness = 3
SettingsFrameStroke.Parent = SettingsFrame

local SettingsFrameCorner = Instance.new("UICorner")
SettingsFrameCorner.CornerRadius = UDim.new(0, 10)
SettingsFrameCorner.Parent = SettingsFrame

local SettingsFrameGradient = Instance.new("UIGradient")
SettingsFrameGradient.Rotation = 90
SettingsFrameGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.000, Color3.fromRGB(53, 53, 53)),
    ColorSequenceKeypoint.new(1.000, Color3.fromRGB(7, 7, 7))
}
SettingsFrameGradient.Parent = SettingsFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.TextWrapped = true
Title.BorderSizePixel = 0
Title.TextSize = 14
Title.TextScaled = true
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title.Text = "Settings"
Title.LayoutOrder = 1
Title.Parent = SettingsFrame

local TitleSizeCons = Instance.new("UISizeConstraint")
TitleSizeCons.MaxSize = Vector2.new(math.huge, 28)
TitleSizeCons.Parent = Title

local SettingsListLayout = Instance.new("UIListLayout")
SettingsListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SettingsListLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SettingsListLayout.Padding = UDim.new(0, 4)
SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsListLayout.Parent = SettingsFrame

local OptionsScrollingFrame = Instance.new("ScrollingFrame")
OptionsScrollingFrame.Name = "Options"
OptionsScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
OptionsScrollingFrame.BorderSizePixel = 0
OptionsScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OptionsScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
OptionsScrollingFrame.Size = UDim2.new(0, 272, 0, 140)
OptionsScrollingFrame.ScrollBarThickness = 0
OptionsScrollingFrame.LayoutOrder = 2
OptionsScrollingFrame.BackgroundTransparency = 1
OptionsScrollingFrame.Parent = SettingsFrame

local OptionsListLayout = Instance.new("UIListLayout")
OptionsListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
OptionsListLayout.Padding = UDim.new(0, 6)
OptionsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
OptionsListLayout.Parent = OptionsScrollingFrame

local OptionsPadding = Instance.new("UIPadding")
OptionsPadding.PaddingRight = UDim.new(0, 4)
OptionsPadding.PaddingLeft = UDim.new(0, 4)
OptionsPadding.Parent = OptionsScrollingFrame

local VolumeFrame = Instance.new("Frame")
VolumeFrame.Name = "Volume"
VolumeFrame.BorderSizePixel = 0
VolumeFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
VolumeFrame.Size = UDim2.new(0, 270, 0, 22)
VolumeFrame.LayoutOrder = 1
VolumeFrame.BackgroundTransparency = 1
VolumeFrame.Parent = OptionsScrollingFrame

local VolumeListLayout = Instance.new("UIListLayout")
VolumeListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
VolumeListLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
VolumeListLayout.Padding = UDim.new(0, 4)
VolumeListLayout.SortOrder = Enum.SortOrder.LayoutOrder
VolumeListLayout.FillDirection = Enum.FillDirection.Horizontal
VolumeListLayout.Parent = VolumeFrame

local VolumeLabel = Instance.new("TextLabel")
VolumeLabel.Name = "VolumeLabel"
VolumeLabel.TextWrapped = true
VolumeLabel.BorderSizePixel = 0
VolumeLabel.TextSize = 14
VolumeLabel.TextXAlignment = Enum.TextXAlignment.Left
VolumeLabel.TextScaled = true
VolumeLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
VolumeLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
VolumeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
VolumeLabel.BackgroundTransparency = 1
VolumeLabel.Size = UDim2.new(1, 0, 0, 28)
VolumeLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
VolumeLabel.Text = "Volume (0.5-10)"
VolumeLabel.LayoutOrder = 1
VolumeLabel.Parent = VolumeFrame

local VolumeBox = Instance.new("TextBox")
VolumeBox.Name = "VolumeBox"
VolumeBox.BorderSizePixel = 0
VolumeBox.TextWrapped = true
VolumeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
VolumeBox.TextScaled = true
VolumeBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
VolumeBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
VolumeBox.AutomaticSize = Enum.AutomaticSize.X
VolumeBox.Size = UDim2.new(0, 0, 0, 34)
VolumeBox.Text = ""
VolumeBox.PlaceholderText = tostring(settings.Volume)
VolumeBox.LayoutOrder = 2
VolumeBox.BackgroundTransparency = 0.5
VolumeBox.Parent = VolumeFrame

local VolumeBoxCorner = Instance.new("UICorner")
VolumeBoxCorner.Parent = VolumeBox

local VolumeBoxPadding = Instance.new("UIPadding")
VolumeBoxPadding.PaddingTop = UDim.new(0, 4)
VolumeBoxPadding.PaddingRight = UDim.new(0, 6)
VolumeBoxPadding.PaddingLeft = UDim.new(0, 6)
VolumeBoxPadding.PaddingBottom = UDim.new(0, 4)
VolumeBoxPadding.Parent = VolumeBox

local VolumeSizeCons = Instance.new("UISizeConstraint")
VolumeSizeCons.MinSize = Vector2.new(10, 0)
VolumeSizeCons.Parent = VolumeBox

local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "Speed"
SpeedFrame.BorderSizePixel = 0
SpeedFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedFrame.Size = UDim2.new(0, 270, 0, 22)
SpeedFrame.LayoutOrder = 2
SpeedFrame.BackgroundTransparency = 1
SpeedFrame.Parent = OptionsScrollingFrame

local SpeedListLayout = Instance.new("UIListLayout")
SpeedListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SpeedListLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SpeedListLayout.Padding = UDim.new(0, 4)
SpeedListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SpeedListLayout.FillDirection = Enum.FillDirection.Horizontal
SpeedListLayout.Parent = SpeedFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.TextWrapped = true
SpeedLabel.BorderSizePixel = 0
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.TextScaled = true
SpeedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Size = UDim2.new(1, 0, 0, 28)
SpeedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
SpeedLabel.Text = "Playback Speed (0.25-3)"
SpeedLabel.LayoutOrder = 1
SpeedLabel.Parent = SpeedFrame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.BorderSizePixel = 0
SpeedBox.TextWrapped = true
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.TextScaled = true
SpeedBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
SpeedBox.AutomaticSize = Enum.AutomaticSize.X
SpeedBox.Size = UDim2.new(0, 0, 0, 34)
SpeedBox.Text = ""
SpeedBox.PlaceholderText = tostring(settings.Speed)
SpeedBox.LayoutOrder = 2
SpeedBox.BackgroundTransparency = 0.5
SpeedBox.Parent = SpeedFrame

local SpeedBoxCorner = Instance.new("UICorner")
SpeedBoxCorner.Parent = SpeedBox

local SpeedBoxPadding = Instance.new("UIPadding")
SpeedBoxPadding.PaddingTop = UDim.new(0, 4)
SpeedBoxPadding.PaddingRight = UDim.new(0, 6)
SpeedBoxPadding.PaddingLeft = UDim.new(0, 6)
SpeedBoxPadding.PaddingBottom = UDim.new(0, 4)
SpeedBoxPadding.Parent = SpeedBox

local SpeedSizeCons = Instance.new("UISizeConstraint")
SpeedSizeCons.MinSize = Vector2.new(10, 0)
SpeedSizeCons.Parent = SpeedBox

local function Dragify(Frame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function ClampPosition(newX, newY)
        local viewport = workspace.CurrentCamera.ViewportSize
        local size = Frame.AbsoluteSize
        local padding = 3

        local maxX = viewport.X - size.X - padding
        local maxY = viewport.Y - size.Y - padding
        local minX = padding
        local minY = padding

        newX = math.clamp(newX, minX, maxX)
        newY = math.clamp(newY, minY, maxY)

        return newX, newY
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            newX, newY = ClampPosition(newX, newY)
            Frame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        end
    end)
end

Dragify(MainFrame)

Toggle.Visible = true

local songs = {}
local listSuccess, files = pcall(ListFiles, SongsFolder)
if listSuccess then
    for _, file in ipairs(files) do
        if type(file) == "string" and file:sub(-4):lower() == ".mp3" then
            table.insert(songs, file)
        end
    end
end

if #songs == 0 then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "SoundDock",
            Text = "No MP3 files found. Drop your songs into SoundDock/Songs folder and re-execute.",
            Duration = 6
        })
    end)
    ScreenGui:Destroy()
    return
else
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "SoundDock",
            Text = #songs.." song(s) loaded from SoundDock/Songs",
            Duration = 5
        })
    end)
end

local currentSongIndex = 1
local currentSound = nil
local isPaused = false
local currentTween = nil
local currentSongTime = 0
local defaultPauseImage = "rbxassetid://13980756617"
local pausedImage = "rbxassetid://12099513379"
local defaultLoopColor = Loop.ImageColor3
local loopisLoadedColor = Color3.fromRGB(0, 170, 255)
local fadeTime = 0.5
local fadeTweenInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Linear)
local isLooping = settings.IsLooped or false

Loop.ImageColor3 = isLooping and loopisLoadedColor or defaultLoopColor

local function SaveSettings()
    local newSettings = {
        IsLooped = isLooping,
        Volume = settings.Volume,
        Speed = settings.Speed
    }
    local success, encoded = pcall(function()
        return game:GetService("HttpService"):JSONEncode(newSettings)
    end)
    if success then
        pcall(function() WriteFile(SettingsPath, encoded) end)
    end
end

local function FormatTime(seconds)
    seconds = math.max(0, seconds or 0)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = math.floor(seconds % 60)
    return string.format("%d:%02d", minutes, remainingSeconds)
end

local function UpdateSongDurationLabel()
    if not currentSound then return end
    local timeLength = currentSound.TimeLength or 0
    SongDuration.Text = FormatTime(currentSongTime).." / "..FormatTime(timeLength)
end

local function FadeOut(sound)
    if not sound then return end
    local tween = TweenService:Create(sound, fadeTweenInfo, {Volume = 0})
    tween:Play()
    tween.Completed:Wait()
end

local function FadeIn(sound)
    if not sound then return end
    sound.Volume = 0
    local tween = TweenService:Create(sound, fadeTweenInfo, {Volume = settings.Volume})
    tween:Play()
end

local function UpdateProgressBar(sound, startTime)
    if not sound then return end
    ProgressBar.Visible = true
    if currentTween then currentTween:Cancel() currentTween = nil end
    local timeLength = sound.TimeLength or 1
    local remainingTime = math.max(0.001, timeLength - startTime)
    local startProgress = startTime / timeLength
    ProgressBar.Size = UDim2.new(startProgress, 0, 1, 0)
    if isPaused then return end
    local tweenInfo = TweenInfo.new(remainingTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
    currentTween = TweenService:Create(ProgressBar, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    currentTween:Play()
end

local function StopCurrentSong()
    if currentSound then 
        pcall(function()
            FadeOut(currentSound)
            currentSound:Stop()
        end)
        currentSound = nil
    end
    if currentTween then currentTween:Cancel() currentTween = nil end
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    currentSongTime = 0
    UpdateSongDurationLabel()
end

local function PlaySong(index)
    if #songs == 0 then return end
    StopCurrentSong()
    if index < 1 then index = #songs elseif index > #songs then index = 1 end
    currentSongIndex = index
    local path = songs[currentSongIndex]
    if not path then return end
    local sound = Instance.new("Sound")
    sound.Parent = Services.Workspace
    sound.SoundId = getcustomasset(path)
    sound.Volume = settings.Volume
    sound.PlaybackSpeed = settings.Speed
    local filename = path:match("([^/\\]+)$") or "Unknown"
    filename = filename:gsub("%.mp3$", "")
    SongName.Text = filename
    sound:Play()
    FadeIn(sound)
    currentSound = sound
    currentSongTime = 0
    ProgressBar.Visible = true
    UpdateProgressBar(sound, 0)
    isPaused = false
    Pause.Image = defaultPauseImage
    sound.Ended:Connect(function()
        if sound == currentSound then
            if isLooping then
                PlaySong(currentSongIndex)
            else
                PlaySong(currentSongIndex + 1)
            end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    pcall(function()
        if currentSound and currentSound.IsPlaying and not isPaused then
            currentSongTime = currentSound.TimePosition or 0
            UpdateSongDurationLabel()
            UpdateProgressBar(currentSound, currentSongTime)
        end
    end)
end)

Pause.MouseButton1Click:Connect(function()
    if not currentSound then return end
    isPaused = not isPaused
    if isPaused then
        pcall(function()
            FadeOut(currentSound)
            currentSound:Pause()
        end)
        Pause.Image = pausedImage
        if currentTween then currentTween:Cancel() currentTween = nil end
    else
        pcall(function()
            currentSound:Resume()
            FadeIn(currentSound)
        end)
        Pause.Image = defaultPauseImage
        currentSongTime = currentSound.TimePosition or 0
        UpdateProgressBar(currentSound, currentSongTime)
    end
end)

Next.MouseButton1Click:Connect(function()
    PlaySong(currentSongIndex + 1)
end)

Previous.MouseButton1Click:Connect(function()
    PlaySong(currentSongIndex - 1)
end)

Loop.MouseButton1Click:Connect(function()
    isLooping = not isLooping
    Loop.ImageColor3 = isLooping and loopisLoadedColor or defaultLoopColor
    SaveSettings()
end)

Toggle.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

Settings.MouseButton1Click:Connect(function()
    SettingsFrame.Visible = not SettingsFrame.Visible
    if SettingsFrame.Visible then
        Settings.ImageColor3 = loopisLoadedColor
    else
        Settings.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

VolumeBox.FocusLost:Connect(function()
    local value = tonumber(VolumeBox.Text)
    if value then
        value = math.clamp(value, 0.5, 10)
        settings.Volume = value
        if currentSound then
            pcall(function() currentSound.Volume = value end)
        end
        VolumeBox.PlaceholderText = tostring(value)
        SaveSettings()
    end
    VolumeBox.Text = ""
end)

SpeedBox.FocusLost:Connect(function()
    local value = tonumber(SpeedBox.Text)
    if value then
        value = math.clamp(value, 0.25, 3)
        settings.Speed = value
        if currentSound then
            pcall(function() currentSound.PlaybackSpeed = value end)
        end
        SpeedBox.PlaceholderText = tostring(value)
        SaveSettings()
    end
    SpeedBox.Text = ""
end)

PlaySong(currentSongIndex)