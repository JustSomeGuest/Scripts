if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (function()
    local Success, Env = pcall(getgenv)
    return (Success and Env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local function expect(ExpectedType, Value, Fallback)
    if type(Value) == ExpectedType then
        return Value
    end

    if Fallback ~= nil then
        if type(Fallback) == "function" then
            return function(...)
                warn("[Expect]: Missing executor functionality. Using fallback function.")
                return Fallback(...)
            end
        end

        warn("[Expect]: Value has unexpected type. Using fallback value.")
    end

    return Fallback
end

local cloneref = expect("function", cloneref, function(...) return ... end) or function(v) return v end

local Services = setmetatable({}, {
    __index = function(Self, Name)
        local Success, Cache = pcall(function()
            return cloneref(game:GetService(Name))
        end)

        if Success then
            rawset(Self, Name, Cache)
            return Cache
        else
            error("Invalid Service: " .. tostring(Name))
        end
    end
})

local Hui = (gethui and gethui()) or Services.CoreGui
local TweenService = Services.TweenService
local Players = Services.Players
local ReplicatedStorage = Services.ReplicatedStorage
local Workspace = Services.Workspace
local GuiService = Services.GuiService
local UserInputService = Services.UserInputService
local MarketplaceService = Services.MarketplaceService
local StarterGui = Services.StarterGui

local function Tween(Object, Speed, Properties, EasingStyle, EasingDirection)
    if EasingStyle == nil then
        EasingStyle = "Quad"
    end

    if EasingDirection == nil then
        EasingDirection = "Out"
    end

    local TweenInformation = TweenInfo.new(
        Speed,
        Enum.EasingStyle[EasingStyle],
        Enum.EasingDirection[EasingDirection]
    )

    return TweenService:Create(Object, TweenInformation, Properties)
end

local Base = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/GelatekHubRM/"
local Scripts = Base .. "Scripts"
local FreeScripts = Base .. "Scripts/Free"
local HatScripts = Base .. "Scripts/Hat"
local Modules = Base .. "Modules"

Shared.GelatekHubRM = Shared.GelatekHubRM or {}

if Shared.GelatekHubRM.IsLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "GelatekHubRM",
        Text = "Gelatek Hub Remastered is already running!",
        Duration = 4
    })
    return
end

Shared.GelatekHubRM.IsLoaded = true

local function SafeCall(func, ...)
    local ok, result = pcall(func, ...)
    if not ok then warn("[Gelatek Hub]: " .. tostring(result)) end
    return ok, result
end

local function load(url, scriptName)
    scriptName = scriptName or url
    local ok, result = pcall(function()
        local src
        local asyncOk, asyncErr = pcall(function()
            src = game:HttpGetAsync(url)
        end)
        if not asyncOk or not src then
            local syncOk, syncErr = pcall(function()
                src = game:HttpGet(url)
            end)
            if not syncOk or not src then
                error(string.format(
                    "Failed to fetch script: %s\nURL: %s\nAsync Error: %s\nSync Error: %s\nPossible causes: File doesn't exist (404), network issue, or repo is private/deleted.",
                    scriptName,
                    url,
                    tostring(asyncErr),
                    tostring(syncErr)
                ))
            end
        end
        local fn, compileErr = loadstring(src)
        if not fn then
            error(string.format(
                "Failed to compile script: %s\nURL: %s\nCompile Error: %s\nPossible cause: The file contains syntax errors or is not valid Lua/Luau code.",
                scriptName,
                url,
                tostring(compileErr)
            ))
        end
        fn()
    end)
    if not ok then
        warn("[Gelatek Hub]: " .. tostring(result))
        StarterGui:SetCore("SendNotification", {
            Title = "Script Error",
            Text = "Failed to load: " .. scriptName .. "\nCheck console (F9) for details.",
            Duration = 6
        })
    end
end

local WriteFile = expect("function", writefile, function() return end)
local IsFile = expect("function", isfile, function() return false end)
local IsFolder = expect("function", isfolder, function() return false end)
local MakeFolder = expect("function", makefolder, function() return end)

local function CheckAudioPackage()
    if not WriteFile or not IsFile or not MakeFolder or not IsFolder then
        warn("[Gelatek Hub Remastered]: Skipping audio package check - required file functions not available")
        return
    end

    if IsFolder("GelatekHubRemastered") then
        return
    end

    local ok, err = pcall(function()
        load(Modules .. "/Audios.luau", "Audios.luau")
    end)

    if not ok then
        warn("[Gelatek Hub]: Failed to install audio package: " .. tostring(err))
    end
end

SafeCall(CheckAudioPackage)

load(Modules .. "/Functions.luau", "Functions.luau")

local Games = {
    ["Just A Baseplate"] = 123974602339071,
}

local function IsGame(gameName)
    local placeId = Games[gameName]
    if not placeId then return false end
    return game.PlaceId == placeId
end

Shared.GelatekHubConfig = {
    PermanentDeath = false,
    TorsoFling = false,
    BulletFling = false,
    EnableCollisions = false,
    KeepHatsAttached = false,
    HeadlessOnPerma = false,
    Antivoid = false,
    AntivoidOffset = 75,
    DisableAnims = false,
}

local Player = Players.LocalPlayer
local Wait = task.wait

local function WaitForDeath()
    local character = Player.Character
    if not character then
        character = Player.CharacterAdded:Wait()
    end
    local humanoid = character:WaitForChild("Humanoid")
    local connection
    connection = humanoid.HealthChanged:Connect(function(health)
        if health <= 0 then
            connection:Disconnect()
        end
    end)
end

local UI = {}

UI["GelatekHub"] = Instance.new("ScreenGui")
UI["GelatekHub"]["DisplayOrder"] = 1
UI["GelatekHub"]["Name"] = "GelatekHub"
UI["GelatekHub"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
UI["GelatekHub"]["ResetOnSpawn"] = false
UI["GelatekHub"]["Parent"] = Hui

UI["Show"] = Instance.new("TextButton")
UI["Show"]["TextWrapped"] = true
UI["Show"]["BorderSizePixel"] = 0
UI["Show"]["TextScaled"] = true
UI["Show"]["TextColor3"] = Color3.fromRGB(255, 88, 91)
UI["Show"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31)
UI["Show"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["Show"]["Size"] = UDim2.new(0, 32, 0, 32)
UI["Show"]["Text"] = "G"
UI["Show"]["Name"] = "Show"
UI["Show"]["Visible"] = false
UI["Show"]["Position"] = UDim2.new(0, 18, 0, 6)
UI["Show"]["Parent"] = UI["GelatekHub"]

UI["ShowStroke"] = Instance.new("UIStroke")
UI["ShowStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ShowStroke"]["Color"] = Color3.fromRGB(255, 88, 91)
UI["ShowStroke"]["Parent"] = UI["Show"]

UI["ShowCorner"] = Instance.new("UICorner")
UI["ShowCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["ShowCorner"]["Parent"] = UI["Show"]

UI["Main"] = Instance.new("Frame")
UI["Main"]["BorderSizePixel"] = 0
UI["Main"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Main"]["Size"] = UDim2.new(0.7, 0, 0.9, 0)
UI["Main"]["Position"] = UDim2.new(0, 18, 0, 6)
UI["Main"]["Name"] = "Main"
UI["Main"]["BackgroundTransparency"] = 1
UI["Main"]["Parent"] = UI["GelatekHub"]

UI["Shadow"] = Instance.new("ImageLabel")
UI["Shadow"]["BorderSizePixel"] = 0
UI["Shadow"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Shadow"]["ImageTransparency"] = 0.2
UI["Shadow"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
UI["Shadow"]["Image"] = "rbxassetid://15298624572"
UI["Shadow"]["Size"] = UDim2.new(1.059, 0, 1.088, 0)
UI["Shadow"]["BackgroundTransparency"] = 1
UI["Shadow"]["Name"] = "Shadow"
UI["Shadow"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
UI["Shadow"]["Parent"] = UI["Main"]

UI["Frame"] = Instance.new("CanvasGroup")
UI["Frame"]["ZIndex"] = 2
UI["Frame"]["BorderSizePixel"] = 0
UI["Frame"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31)
UI["Frame"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["Frame"]["Name"] = "Frame"
UI["Frame"]["Parent"] = UI["Main"]

UI["FrameCorner"] = Instance.new("UICorner")
UI["FrameCorner"]["CornerRadius"] = UDim.new(0, 4)
UI["FrameCorner"]["Parent"] = UI["Frame"]

UI["FrameLayout"] = Instance.new("UIListLayout")
UI["FrameLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["FrameLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["FrameLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["FrameLayout"]["Parent"] = UI["Frame"]

UI["Topbar"] = Instance.new("Frame")
UI["Topbar"]["BorderSizePixel"] = 0
UI["Topbar"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Topbar"]["Size"] = UDim2.new(1, 0, 0.1, 0)
UI["Topbar"]["Name"] = "Topbar"
UI["Topbar"]["LayoutOrder"] = 1
UI["Topbar"]["BackgroundTransparency"] = 1
UI["Topbar"]["Parent"] = UI["Frame"]

UI["TopbarLayout"] = Instance.new("UIListLayout")
UI["TopbarLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["TopbarLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["TopbarLayout"]["Padding"] = UDim.new(0, 4)
UI["TopbarLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["TopbarLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["TopbarLayout"]["Parent"] = UI["Topbar"]

UI["TopbarPadding"] = Instance.new("UIPadding")
UI["TopbarPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["TopbarPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["TopbarPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["TopbarPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["TopbarPadding"]["Parent"] = UI["Topbar"]

UI["Title"] = Instance.new("TextLabel")
UI["Title"]["TextWrapped"] = true
UI["Title"]["TextSize"] = 14
UI["Title"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["Title"]["TextScaled"] = true
UI["Title"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Title"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["Title"]["TextColor3"] = Color3.fromRGB(255, 88, 91)
UI["Title"]["BackgroundTransparency"] = 1
UI["Title"]["Size"] = UDim2.new(0.8, 0, 1, 0)
UI["Title"]["Text"] = "Gelatek Hub Remastered • " .. MarketplaceService:GetProductInfo(game.PlaceId).Name
UI["Title"]["LayoutOrder"] = 1
UI["Title"]["Name"] = "Title"
UI["Title"]["Parent"] = UI["Topbar"]

UI["TitlePadding"] = Instance.new("UIPadding")
UI["TitlePadding"]["PaddingTop"] = UDim.new(0, 1)
UI["TitlePadding"]["PaddingBottom"] = UDim.new(0, 1)
UI["TitlePadding"]["Parent"] = UI["Title"]

UI["Hide"] = Instance.new("TextButton")
UI["Hide"]["TextWrapped"] = true
UI["Hide"]["BorderSizePixel"] = 0
UI["Hide"]["TextScaled"] = true
UI["Hide"]["TextColor3"] = Color3.fromRGB(255, 88, 91)
UI["Hide"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Hide"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["Hide"]["BackgroundTransparency"] = 1
UI["Hide"]["Size"] = UDim2.new(0.2, 0, 1, 0)
UI["Hide"]["LayoutOrder"] = 2
UI["Hide"]["Text"] = "-"
UI["Hide"]["Name"] = "Hide"
UI["Hide"]["Parent"] = UI["Topbar"]

UI["HideRatio"] = Instance.new("UIAspectRatioConstraint")
UI["HideRatio"]["Parent"] = UI["Hide"]

UI["Close"] = Instance.new("TextButton")
UI["Close"]["TextWrapped"] = true
UI["Close"]["BorderSizePixel"] = 0
UI["Close"]["TextScaled"] = true
UI["Close"]["TextColor3"] = Color3.fromRGB(255, 88, 91)
UI["Close"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Close"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["Close"]["BackgroundTransparency"] = 1
UI["Close"]["Size"] = UDim2.new(0.2, 0, 1, 0)
UI["Close"]["LayoutOrder"] = 3
UI["Close"]["Text"] = "×"
UI["Close"]["Name"] = "Close"
UI["Close"]["Parent"] = UI["Topbar"]

UI["CloseRatio"] = Instance.new("UIAspectRatioConstraint")
UI["CloseRatio"]["Parent"] = UI["Close"]

UI["FrameContent"] = Instance.new("Frame")
UI["FrameContent"]["BorderSizePixel"] = 0
UI["FrameContent"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["FrameContent"]["Size"] = UDim2.new(1, 0, 0.9, 0)
UI["FrameContent"]["Name"] = "FrameContent"
UI["FrameContent"]["LayoutOrder"] = 2
UI["FrameContent"]["BackgroundTransparency"] = 1
UI["FrameContent"]["Parent"] = UI["Frame"]

UI["FrameContentLayout"] = Instance.new("UIListLayout")
UI["FrameContentLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["FrameContentLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["FrameContentLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["FrameContentLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["FrameContentLayout"]["Parent"] = UI["FrameContent"]

UI["Tabs"] = Instance.new("ScrollingFrame")
UI["Tabs"]["ScrollingDirection"] = Enum.ScrollingDirection.Y
UI["Tabs"]["BorderSizePixel"] = 0
UI["Tabs"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Tabs"]["Name"] = "Tabs"
UI["Tabs"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
UI["Tabs"]["Size"] = UDim2.new(0.25, 0, 1, 0)
UI["Tabs"]["ScrollBarThickness"] = 0
UI["Tabs"]["LayoutOrder"] = 1
UI["Tabs"]["BackgroundTransparency"] = 1
UI["Tabs"]["Parent"] = UI["FrameContent"]

UI["TabsLayout"] = Instance.new("UIListLayout")
UI["TabsLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["TabsLayout"]["Padding"] = UDim.new(0, 9)
UI["TabsLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["TabsLayout"]["Parent"] = UI["Tabs"]

UI["TabsPadding"] = Instance.new("UIPadding")
UI["TabsPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["TabsPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["TabsPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["TabsPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["TabsPadding"]["Parent"] = UI["Tabs"]

UI["Contents"] = Instance.new("Frame")
UI["Contents"]["BorderSizePixel"] = 0
UI["Contents"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Contents"]["Size"] = UDim2.new(0.75, 0, 1, 0)
UI["Contents"]["Name"] = "Contents"
UI["Contents"]["LayoutOrder"] = 2
UI["Contents"]["BackgroundTransparency"] = 1
UI["Contents"]["Parent"] = UI["FrameContent"]

UI["ContentsPadding"] = Instance.new("UIPadding")
UI["ContentsPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["ContentsPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["ContentsPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["ContentsPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["ContentsPadding"]["Parent"] = UI["Contents"]

local function MakeScrollContent(name, layoutOrder, scrollbarThickness)
    local sf = Instance.new("ScrollingFrame")
    sf.Visible = false
    sf.Active = true
    sf.ScrollingDirection = Enum.ScrollingDirection.Y
    sf.BorderSizePixel = 0
    sf.CanvasSize = UDim2.new(0, 0, 0, 0)
    sf.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sf.Name = name
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.ScrollBarThickness = scrollbarThickness or 0
    sf.LayoutOrder = layoutOrder
    sf.BackgroundTransparency = 1
    sf.Parent = UI["Contents"]
    local layout = Instance.new("UIListLayout")
    layout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = sf
    return sf
end

UI["HomeContent"] = MakeScrollContent("HomeContent", 1, 5)
UI["HomeContent"]["Visible"] = true
UI["ReanimationContent"] = MakeScrollContent("ReanimationContent", 2, 0)
UI["ScriptsContent"] = MakeScrollContent("ScriptsContent", 3, 0)
UI["HatsContent"] = MakeScrollContent("HatsContent", 4, 0)
UI["ExtraContent"] = MakeScrollContent("ExtraContent", 5, 0)
UI["CreditsContent"] = MakeScrollContent("CreditsContent", 6, 5)

local function MakeDivider(parent, layoutOrder)
    local d = Instance.new("Frame")
    d.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
    d.Size = UDim2.new(0, 300, 0, 4)
    d.Name = "Divider"
    d.LayoutOrder = layoutOrder
    d.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0.1, 1)
    c.Parent = d
    return d
end

local function MakeLabel(parent, text, layoutOrder)
    local lbl = Instance.new("TextLabel")
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextSize = 14
    lbl.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
    lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    lbl.TextColor3 = Color3.fromRGB(255, 88, 91)
    lbl.Size = UDim2.new(0, 300, 0, 28)
    lbl.Text = text
    lbl.Name = "Label"
    lbl.LayoutOrder = layoutOrder
    lbl.BackgroundTransparency = 1
    lbl.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = lbl
    return lbl
end

local function MakePadding(parent, top, right, bottom, left)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, top or 8)
    p.PaddingRight = UDim.new(0, right or 8)
    p.PaddingBottom = UDim.new(0, bottom or 8)
    p.PaddingLeft = UDim.new(0, left or 8)
    p.Parent = parent
    return p
end

local function MakeButton(parent, text, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.TextWrapped = true
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
    btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    btn.Size = UDim2.new(0, 300, 0, 31)
    btn.LayoutOrder = layoutOrder
    btn.Text = text
    btn.Name = text:gsub("%s+", ""):gsub("[%[%]%-]", "")
    btn.Parent = parent
    MakePadding(btn)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.1, 1)
    corner.Parent = btn
    return btn
end

local function MakeToggleButton(parent, labelText, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
    btn.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    btn.Size = UDim2.new(0, 300, 0, 31)
    btn.LayoutOrder = layoutOrder
    btn.Text = " "
    btn.Name = "Enable" .. labelText:gsub("%s+", "")
    btn.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    layout.VerticalFlex = Enum.UIFlexAlignment.Fill
    layout.Padding = UDim.new(0, 4)
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Parent = btn

    MakePadding(btn, 6, 8, 6, 8)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    local lbl = Instance.new("TextLabel")
    lbl.TextWrapped = true
    lbl.BorderSizePixel = 0
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.2, 0, 0.3, 0)
    lbl.Text = labelText
    lbl.LayoutOrder = 1
    lbl.Parent = btn
    MakePadding(lbl, 2, 0, 2, 0)

    local toggle = Instance.new("Frame")
    toggle.BorderSizePixel = 0
    toggle.BackgroundColor3 = Color3.fromRGB(255, 57, 60)
    toggle.Size = UDim2.new(0.2, 0, 0.3, 0)
    toggle.LayoutOrder = 2
    toggle.Parent = btn

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 4)
    tCorner.Parent = toggle

    local tRatio = Instance.new("UIAspectRatioConstraint")
    tRatio.Parent = toggle

    return btn, toggle
end

local function MakeTabButton(parent, text, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 0, 24)
    btn.LayoutOrder = layoutOrder
    btn.Text = " "
    btn.Name = text:gsub("%s+", "") .. "Tab"
    btn.Parent = parent

    local underlay = Instance.new("Frame")
    underlay.BorderSizePixel = 0
    underlay.BackgroundColor3 = Color3.fromRGB(255, 88, 91)
    underlay.Size = UDim2.new(0, 0, 0, 2)
    underlay.LayoutOrder = 2
    underlay.Parent = btn
    Instance.new("UICorner").Parent = underlay

    local lbl = Instance.new("TextLabel")
    lbl.TextWrapped = true
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTransparency = 0.5
    lbl.TextYAlignment = Enum.TextYAlignment.Bottom
    lbl.TextScaled = true
    lbl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Text = text
    lbl.LayoutOrder = 1
    lbl.Position = UDim2.new(0, 4, 0, 4)
    lbl.Parent = btn
    MakePadding(lbl, 3, 0, 3, 0)

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = btn

    return btn, underlay, lbl
end

UI["Welcome"] = Instance.new("Frame")
UI["Welcome"]["BackgroundColor3"] = Color3.fromRGB(43, 43, 43)
UI["Welcome"]["Size"] = UDim2.new(0, 300, 0, 31)
UI["Welcome"]["Name"] = "Welcome"
UI["Welcome"]["LayoutOrder"] = 1
UI["Welcome"]["Parent"] = UI["HomeContent"]
Instance.new("UICorner", UI["Welcome"]).CornerRadius = UDim.new(0, 4)
MakePadding(UI["Welcome"])

UI["WelcomeLabel"] = Instance.new("TextLabel")
UI["WelcomeLabel"]["TextWrapped"] = true
UI["WelcomeLabel"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["WelcomeLabel"]["TextScaled"] = true
UI["WelcomeLabel"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["WelcomeLabel"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["WelcomeLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["WelcomeLabel"]["BackgroundTransparency"] = 1
UI["WelcomeLabel"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["WelcomeLabel"]["Text"] = "Hello! Thanks for using our hub. We hope you enjoy it!"
UI["WelcomeLabel"]["Parent"] = UI["Welcome"]

UI["Version"] = Instance.new("Frame")
UI["Version"]["BackgroundColor3"] = Color3.fromRGB(43, 43, 43)
UI["Version"]["Size"] = UDim2.new(0, 300, 0, 31)
UI["Version"]["Name"] = "Version"
UI["Version"]["LayoutOrder"] = 2
UI["Version"]["Parent"] = UI["HomeContent"]
Instance.new("UICorner", UI["Version"]).CornerRadius = UDim.new(0, 4)
MakePadding(UI["Version"])

UI["VersionLabel"] = Instance.new("TextLabel")
UI["VersionLabel"]["TextWrapped"] = true
UI["VersionLabel"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["VersionLabel"]["TextScaled"] = true
UI["VersionLabel"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["VersionLabel"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["VersionLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["VersionLabel"]["BackgroundTransparency"] = 1
UI["VersionLabel"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["VersionLabel"]["Text"] = "Current Version: 1.2"
UI["VersionLabel"]["Parent"] = UI["Version"]

UI["ReanimateBtn"] = MakeButton(UI["ReanimationContent"], "Reanimate", 1)
UI["Deanimate"] = MakeButton(UI["ReanimationContent"], "Deanimate", 2)
MakeDivider(UI["ReanimationContent"], 3)
UI["EnablePermadeath"], UI["PermadeathToggle"] = MakeToggleButton(UI["ReanimationContent"], "Permanent Death", 4)
UI["EnableTorsoFling"], UI["TorsoFlingToggle"] = MakeToggleButton(UI["ReanimationContent"], "Torso Fling", 5)
UI["EnableBulletFling"], UI["BulletFlingToggle"] = MakeToggleButton(UI["ReanimationContent"], "Bullet Fling", 6)
UI["EnableCollisions"], UI["CollisionsToggle"] = MakeToggleButton(UI["ReanimationContent"], "Collisions", 7)
UI["EnableNetless"], UI["NetlessToggle"] = MakeToggleButton(UI["ReanimationContent"], "Keep Hats Attached", 8)
UI["EnableHeadless"], UI["HeadlessToggle"] = MakeToggleButton(UI["ReanimationContent"], "Headless On Permadeath", 9)
UI["DisableAnims"], UI["DisableAnimsToggle"] = MakeToggleButton(UI["ReanimationContent"], "Disable Animations", 10)
UI["EnableAntivoid"], UI["AntivoidToggle"] = MakeToggleButton(UI["ReanimationContent"], "Antivoid", 11)

MakeLabel(UI["ScriptsContent"], "Free Scripts", 1)
UI["GaleFighter"] = MakeButton(UI["ScriptsContent"], "Gale Fighter", 2)
UI["Ender"] = MakeButton(UI["ScriptsContent"], "Ender", 3)
UI["Caducus"] = MakeButton(UI["ScriptsContent"], "Caducus", 4)

MakeLabel(UI["ScriptsContent"], "Hat Scripts", 5)
UI["DualUltima"] = MakeButton(UI["ScriptsContent"], "Dual Ultima", 6)
UI["Carnage"] = MakeButton(UI["ScriptsContent"], "Carnage", 7)
UI["NeptunianV"] = MakeButton(UI["ScriptsContent"], "Neptunian V (Disable Anims)", 8)
UI["ZenithBattleRifle"] = MakeButton(UI["ScriptsContent"], "Zenith Battle Rifle-70", 9)
UI["Chips"] = MakeButton(UI["ScriptsContent"], "Chips", 10)
UI["VoidScythe"] = MakeButton(UI["ScriptsContent"], "Void Scythe", 11)
UI["VoodooDoll"] = MakeButton(UI["ScriptsContent"], "Voodoo Doll", 12)
UI["Quenox"] = MakeButton(UI["ScriptsContent"], "Quenox", 13)
UI["Goner"] = MakeButton(UI["ScriptsContent"], "Goner", 14)

UI["CopyDualUltimaHats"] = MakeButton(UI["HatsContent"], "Copy Dual Ultima Hat Id(s)", 1)
UI["CopyCarnageHats"] = MakeButton(UI["HatsContent"], "Copy Carnage Hat Id(s)", 2)
UI["CopyNeptunianVHats"] = MakeButton(UI["HatsContent"], "Copy Neptunian V Hat Id(s)", 3)
UI["CopyZenithBattleRifleHats"] = MakeButton(UI["HatsContent"], "Copy Zenith Battle Rifle-70 Hat Id(s)", 4)
UI["CopyChipsHats"] = MakeButton(UI["HatsContent"], "Copy Chips Hat Id(s)", 5)
UI["CopyVoidScytheHats"] = MakeButton(UI["HatsContent"], "Copy Void Scythe Hat Id(s)", 6)
UI["CopyVoodooDollHats"] = MakeButton(UI["HatsContent"], "Copy Voodoo Doll Hat Id(s)", 7)
UI["CopyQuenoxHats"] = MakeButton(UI["HatsContent"], "Copy Quenox Hat Id(s)", 8)
UI["CopyGonerHats"] = MakeButton(UI["HatsContent"], "Copy Goner Hat Id(s)", 9)

UI["Shiftlock"] = MakeButton(UI["ExtraContent"], "Shiftlock", 1)
UI["TouchGui"] = MakeButton(UI["ExtraContent"], "TouchGui (Uses Keyboard Keys)", 2)
UI["Keyboard"] = MakeButton(UI["ExtraContent"], "Mobile Keyboard", 3)

UI["CreditsLabel"] = Instance.new("TextLabel")
UI["CreditsLabel"]["TextWrapped"] = true
UI["CreditsLabel"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["CreditsLabel"]["TextSize"] = 14
UI["CreditsLabel"]["BackgroundColor3"] = Color3.fromRGB(43, 43, 43)
UI["CreditsLabel"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["CreditsLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["CreditsLabel"]["RichText"] = true
UI["CreditsLabel"]["Size"] = UDim2.new(1, 0, 0, 0)
UI["CreditsLabel"]["Text"] = "<b>Original Creator:</b> Gelatekussy\n<b>Remastered By:</b> JustAGuest\n\n<b>Special Thanks:</b> Everyone who supported Gelatek Hub.\n\nThis remaster is based on the original Gelatek Hub. Full credit for the original project and its foundation belongs to Gelatekussy."
UI["CreditsLabel"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["CreditsLabel"]["LayoutOrder"] = 1
UI["CreditsLabel"]["Parent"] = UI["CreditsContent"]
MakePadding(UI["CreditsLabel"])
Instance.new("UICorner", UI["CreditsLabel"]).CornerRadius = UDim.new(0, 4)

UI["HomeTab"], UI["HomeTabUnderlay"], UI["HomeTabLabel"] = MakeTabButton(UI["Tabs"], "Home", 1)
UI["HomeTabLabel"]["TextTransparency"] = 0
UI["HomeTabUnderlay"]["Size"] = UDim2.new(1, 0, 0, 2)

UI["ReanimationTab"], UI["ReanimationTabUnderlay"], UI["ReanimationTabLabel"] = MakeTabButton(UI["Tabs"], "Reanimation", 2)
UI["ScriptsTab"], UI["ScriptsTabUnderlay"], UI["ScriptsTabLabel"] = MakeTabButton(UI["Tabs"], "Scripts", 3)
UI["HatsTab"], UI["HatsTabUnderlay"], UI["HatsTabLabel"] = MakeTabButton(UI["Tabs"], "Hats", 4)
UI["ExtraTab"], UI["ExtraTabUnderlay"], UI["ExtraTabLabel"] = MakeTabButton(UI["Tabs"], "Extra", 5)
UI["CreditsTab"], UI["CreditsTabUnderlay"], UI["CreditsTabLabel"] = MakeTabButton(UI["Tabs"], "Credits", 6)

local function TweenUnderlay(underlay, sizeX)
    local ok, tween = SafeCall(function()
        return Tween(underlay, 0.2, {
            Size = UDim2.new(sizeX, 0, 0, 2)
        })
    end)
    if ok and tween then tween:Play() end
end

local function TweenText(label, transparency)
    local ok, tween = SafeCall(function()
        return Tween(label, 0.2, {
            TextTransparency = transparency
        })
    end)
    if ok and tween then tween:Play() end
end

local function Dragify(DragObject, MoveObject)
    MoveObject = MoveObject or DragObject

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    DragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = MoveObject.AbsolutePosition

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    DragObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging or input ~= dragInput then
            return
        end

        local delta = input.Position - dragStart

        local parent = MoveObject.Parent
        local parentSize = parent.AbsoluteSize
        local objectSize = MoveObject.AbsoluteSize

        local padding = 3

        local newX = math.clamp(
            startPos.X + delta.X,
            padding,
            parentSize.X - objectSize.X - padding
        )

        local newY = math.clamp(
            startPos.Y + delta.Y,
            padding,
            parentSize.Y - objectSize.Y - padding
        )

        MoveObject.Position = UDim2.fromOffset(newX, newY)
    end)
end

Dragify(UI["Show"])
Dragify(UI["Frame"], UI["Main"])

local function HideMain()
    SafeCall(function()
        Tween(UI["Main"], 0.3, { Size = UDim2.new(0, 0, 0, 0) }, "Back", "In"):Play()
        Tween(UI["Main"], 0.3, { BackgroundTransparency = 1 }, "Quad", "InOut"):Play()
        Tween(UI["Shadow"], 0.3, { ImageTransparency = 1 }, "Quad", "InOut"):Play()
        local fadeOut = Tween(UI["Frame"], 0.3, { GroupTransparency = 1 }, "Quad", "InOut")
        fadeOut:Play()
        fadeOut.Completed:Wait()
        UI["Main"]["Visible"] = false
        UI["Main"]["Size"] = UDim2.new(0.7, 0, 0.9, 0)
        UI["Main"]["BackgroundTransparency"] = 1
        UI["Show"]["Visible"] = true
        Tween(UI["Show"], 0.2, { Size = UDim2.new(0, 32, 0, 32) }, "Back", "Out"):Play()
        Tween(UI["Show"], 0.2, { BackgroundTransparency = 0 }, "Quad", "Out"):Play()
    end)
end

local function ShowMain()
    SafeCall(function()
        local fadeOutShow = Tween(UI["Show"], 0.2, { BackgroundTransparency = 1 }, "Quad", "Out")
        fadeOutShow:Play()
        fadeOutShow.Completed:Wait()
        UI["Show"]["Visible"] = false
        UI["Show"]["Size"] = UDim2.new(0, 0, 0, 0)
        UI["Main"]["Visible"] = true
        UI["Main"]["Size"] = UDim2.new(0, 0, 0, 0)
        Tween(UI["Main"], 0.3, { Size = UDim2.new(0.7, 0, 0.9, 0) }, "Back", "Out"):Play()
        Tween(UI["Shadow"], 0.3, { ImageTransparency = 0.2 }, "Quad", "InOut"):Play()
        Tween(UI["Main"], 0.3, { BackgroundTransparency = 1 }, "Quad", "InOut"):Play()
        Tween(UI["Frame"], 0.3, { GroupTransparency = 0 }, "Quad", "InOut"):Play()
    end)
end

UI["Hide"]["MouseButton1Click"]:Connect(HideMain)
UI["Show"]["MouseButton1Click"]:Connect(ShowMain)

local TabMap = {
    Home = { Content = UI["HomeContent"], Underlay = UI["HomeTabUnderlay"], Label = UI["HomeTabLabel"] },
    Reanimation = { Content = UI["ReanimationContent"], Underlay = UI["ReanimationTabUnderlay"], Label = UI["ReanimationTabLabel"] },
    Scripts = { Content = UI["ScriptsContent"], Underlay = UI["ScriptsTabUnderlay"], Label = UI["ScriptsTabLabel"] },
    Hats = { Content = UI["HatsContent"], Underlay = UI["HatsTabUnderlay"], Label = UI["HatsTabLabel"] },
    Extra = { Content = UI["ExtraContent"], Underlay = UI["ExtraTabUnderlay"], Label = UI["ExtraTabLabel"] },
    Credits = { Content = UI["CreditsContent"], Underlay = UI["CreditsTabUnderlay"], Label = UI["CreditsTabLabel"] },
}

local function SelectTab(tabName)
    for name, data in pairs(TabMap) do
        if name == tabName then
            data.Content.Visible = true
            TweenUnderlay(data.Underlay, 1)
            TweenText(data.Label, 0)
        else
            data.Content.Visible = false
            TweenUnderlay(data.Underlay, 0)
            TweenText(data.Label, 0.5)
        end
    end
end

UI["HomeTab"]["MouseButton1Click"]:Connect(function() SelectTab("Home") end)
UI["ReanimationTab"]["MouseButton1Click"]:Connect(function() SelectTab("Reanimation") end)
UI["ScriptsTab"]["MouseButton1Click"]:Connect(function() SelectTab("Scripts") end)
UI["HatsTab"]["MouseButton1Click"]:Connect(function() SelectTab("Hats") end)
UI["ExtraTab"]["MouseButton1Click"]:Connect(function() SelectTab("Extra") end)
UI["CreditsTab"]["MouseButton1Click"]:Connect(function() SelectTab("Credits") end)

SelectTab("Home")

local function BetterStopScript()
    SafeCall(function()
        StopScript()
        Wait(0.25)
        StopScript()
    end)
end

local function MakeToggle(button, toggleFrame, configKey)
    local isOn = false
    button.MouseButton1Click:Connect(function()
        isOn = not isOn
        Shared.GelatekHubConfig[configKey] = isOn
        toggleFrame.BackgroundColor3 = isOn and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(255, 57, 60)
    end)
end

MakeToggle(UI["EnablePermadeath"], UI["PermadeathToggle"], "PermanentDeath")
MakeToggle(UI["EnableTorsoFling"], UI["TorsoFlingToggle"], "TorsoFling")
MakeToggle(UI["EnableBulletFling"], UI["BulletFlingToggle"], "BulletFling")
MakeToggle(UI["EnableCollisions"], UI["CollisionsToggle"], "EnableCollisions")
MakeToggle(UI["EnableNetless"], UI["NetlessToggle"], "KeepHatsAttached")
MakeToggle(UI["EnableHeadless"], UI["HeadlessToggle"], "HeadlessOnPerma")
MakeToggle(UI["EnableAntivoid"], UI["AntivoidToggle"], "Antivoid")
MakeToggle(UI["DisableAnims"], UI["DisableAnimsToggle"], "DisableAnims")

if IsGame("Just A Baseplate") then
    local CmdEvent = ReplicatedStorage:WaitForChild("01_server")

    UI["ReanimateBtn"]["MouseButton1Click"]:Connect(function()
        if Shared.GelatekHubConfig.PermanentDeath then
            CmdEvent:FireServer("cmd", "-pd")
        end

        Wait(2)

        if Shared.GelatekHubConfig.KeepHatsAttached then
            CmdEvent:FireServer("cmd", "-net")
        end

        Wait(2)

        load(Modules .. "/Reanimate.luau", "Reanimate.luau")

        WaitForDeath()
        Wait(0.1)

        if Shared.GelatekHubConfig.KeepHatsAttached then
            CmdEvent:FireServer("cmd", "-net")
        end
    end)

    local hatIdMap = {
        [UI["CopyDualUltimaHats"]] = "4524991457,4820152700",
        [UI["CopyCarnageHats"]] = "5134896593,5410674378",
        [UI["CopyNeptunianVHats"]] = "112934510372081",
        [UI["CopyZenithBattleRifleHats"]] = "4962510729,4962455546",
        [UI["CopyChipsHats"]] = "4964938812",
        [UI["CopyVoidScytheHats"]] = "5414429551",
        [UI["CopyVoodooDollHats"]] = "7218265043,7170689370",
        [UI["CopyQuenoxHats"]] = "4820152700,4794315940,4524991457,4315489767,4458601937,4506945409",
        [UI["CopyGonerHats"]] = "6869866014",
    }

    for btn, ids in pairs(hatIdMap) do
        btn.Text = btn.Text:gsub("^Copy", "Get"):gsub("Hat Id%(s%)", "Hat(s)")

        btn.MouseButton1Click:Connect(function()
            CmdEvent:FireServer("cmd", "-gh " .. ids)

            Wait(2)

            CmdEvent:FireServer("cmd", "-net")
        end)
    end
else
    local function CopyToClipboard(text)
        if type(setclipboard) ~= "function" then
            warn("[Gelatek Hub Remastered]: Executor doesn't support setclipboard")

            StarterGui:SetCore("SendNotification", {
                Title = "Gelatek Hub Remastered",
                Text = "Your executor doesn't support clipboard access!",
                Duration = 4
            })

            return
        end

        SafeCall(function()
            setclipboard(text)

            StarterGui:SetCore("SendNotification", {
                Title = "Gelatek Hub Remastered",
                Text = "Copied Hat Id!",
                Duration = 2
            })
        end)
    end

    UI["CopyDualUltimaHats"]["MouseButton1Click"]:Connect(function()
        CopyToClipboard("4524991457,4820152700")
    end)

    UI["CopyCarnageHats"]["MouseButton1Click"]:Connect(function()
        CopyToClipboard("5134896593,5410674378")
    end)

    UI["CopyNeptunianVHats"]["MouseButton1Click"]:Connect(function()
        CopyToClipboard("112934510372081")
    end)

    UI["CopyZenithBattleRifleHats"]["MouseButton1Click"]:Connect(function()
        CopyToClipboard("4962510729,4962455546")
    end)

    UI["CopyChipsHats"]["MouseButton1Click"]:Connect(function()
        CopyToClipboard("4964938812")
    end)

    UI["CopyVoidScytheHats"]["MouseButton1Click"]:Connect(function()
        CopyToClipboard("5414429551")
    end)

    UI["CopyVoodooDollHats"]["MouseButton1Click"]:Connect(function()
        CopyToClipboard("7218265043,7170689370")
    end)

    UI["CopyQuenoxHats"]["MouseButton1Click"]:Connect(function()
        CopyToClipboard("4820152700,4794315940,4524991457,4315489767,4458601937,4506945409")
    end)

    UI["CopyGonerHats"]["MouseButton1Click"]:Connect(function()
        CopyToClipboard("6869866014")
    end)
end

UI["Deanimate"]["MouseButton1Click"]:Connect(BetterStopScript)

UI["GaleFighter"]["MouseButton1Click"]:Connect(function()
    load(FreeScripts .. "/GaleFighter.luau", "GaleFighter.luau")
end)

UI["Ender"]["MouseButton1Click"]:Connect(function()
    load(FreeScripts .. "/Ender.luau", "Ender.luau")
end)

UI["Caducus"]["MouseButton1Click"]:Connect(function()
    load(FreeScripts .. "/Caducus.luau", "Caducus.luau")
end)

UI["Shiftlock"]["MouseButton1Click"]:Connect(function()
    load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Init.luau", "Init.luau")
    SafeCall(function()
        Init.Shiftlock()
    end)
end)

UI["TouchGui"]["MouseButton1Click"]:Connect(function()
    load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Init.luau", "Init.luau")
    SafeCall(function()
        Init.TouchGui()
    end)
end)

UI["Keyboard"]["MouseButton1Click"]:Connect(function()
    load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Init.luau", "Init.luau")
    SafeCall(function()
        Init.DeltaKD()
    end)
end)

UI["DualUltima"]["MouseButton1Click"]:Connect(function()
    load(HatScripts .. "/DualUltima.luau", "DualUltima.luau")
end)

UI["Carnage"]["MouseButton1Click"]:Connect(function()
    load(HatScripts .. "/Carnage.luau", "Carnage.luau")
end)

UI["NeptunianV"]["MouseButton1Click"]:Connect(function()
    load(HatScripts .. "/Neptunian.luau", "Neptunian.luau")
end)

UI["ZenithBattleRifle"]["MouseButton1Click"]:Connect(function()
    load(HatScripts .. "/ZenithAttackRifle.luau", "ZenithAttackRifle.luau")
end)

UI["Chips"]["MouseButton1Click"]:Connect(function()
    load(HatScripts .. "/Chips.luau", "Chips.luau")
end)

UI["VoidScythe"]["MouseButton1Click"]:Connect(function()
    load(HatScripts .. "/VoidScythe.luau", "VoidScythe.luau")
end)

UI["VoodooDoll"]["MouseButton1Click"]:Connect(function()
    load(HatScripts .. "/VoodooDoll.luau", "VoodooDoll.luau")
end)

UI["Quenox"]["MouseButton1Click"]:Connect(function()
    load(HatScripts .. "/Quenox.luau", "Quenox.luau")
end)

UI["Goner"]["MouseButton1Click"]:Connect(function()
    load(HatScripts .. "/Goner.luau", "Goner.luau")
end)

UI["Close"]["MouseButton1Click"]:Connect(function()
    SafeCall(function()
        Tween(UI["Main"], 0.3, { Size = UDim2.new(0, 0, 0, 0) }, "Back", "In"):Play()
        Tween(UI["Main"], 0.3, { BackgroundTransparency = 1 }, "Quad", "InOut"):Play()
        Tween(UI["Shadow"], 0.3, { ImageTransparency = 1 }, "Quad", "InOut"):Play()
        local fadeOut = Tween(UI["Frame"], 0.3, { GroupTransparency = 1 }, "Quad", "InOut")
        fadeOut:Play()
        fadeOut.Completed:Wait()
        UI["GelatekHub"]:Destroy()
        Shared.GelatekHubRM.IsLoaded = false
    end)
end)