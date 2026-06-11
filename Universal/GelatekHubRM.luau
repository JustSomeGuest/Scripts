if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Global = (getgenv and getgenv()) or shared
Global.GelatekHubRM = Global.GelatekHubRM or {}

local function default(expected, value, fallback)
    if type(value) == expected then return value end
    return fallback
end

local cloneref = default("function", cloneref, function(x) return x end)

local Services = setmetatable({}, {
    __index = function(self, name)
        local ok, result = pcall(function()
            return cloneref(game:GetService(name))
        end)
        if ok then
            rawset(self, name, result)
            return result
        end
        error("Invalid Service: " .. tostring(name))
    end
})

if Global.GelatekHubRM.isLoaded then
    Services.StarterGui:SetCore("SendNotification", {
        Title = "GelatekHubRM",
        Text = "Gelatek Hub Remastered is already running!",
        Duration = 4
    })
    return
end

Global.GelatekHubRM.isLoaded = true

local function SafeCall(func, ...)
    local ok, result = pcall(func, ...)
    if not ok then warn("[Gelatek Hub]: " .. tostring(result)) end
    return ok, result
end

local function Run(url)
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
                error("HttpGetAsync: " .. tostring(asyncErr) .. " | HttpGet: " .. tostring(syncErr))
            end
        end
        local fn, compileErr = loadstring(src)
        if not fn then
            error("loadstring failed: " .. tostring(compileErr))
        end
        fn()
    end)
    if not ok then
        warn("[Gelatek Hub]: " .. tostring(result))
        Services.StarterGui:SetCore("SendNotification", {
            Title = "Script Error",
            Text = "Failed to load script. Check console.",
            Duration = 4
        })
    end
end

local WriteFile = default("function", writefile, function() return end)
local IsFile = default("function", isfile, function() return false end)
local IsFolder = default("function", isfolder, function() return false end)
local MakeFolder = default("function", makefolder, function() return end)

local function CheckAudioPackage()
    if not WriteFile or not IsFile or not MakeFolder or not IsFolder then
        return
    end

    if IsFolder("GelatekHub") then
        return
    end

    local ok, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Gelatekussy/GelatekHub/main/src/packages/AudioPack.lua"))()
    end)

    if not ok then
        warn("[Gelatek Hub]: Failed to install audio package: " .. tostring(err))
    end
end

SafeCall(CheckAudioPackage)

Run("https://raw.githubusercontent.com/Gelatekussy/GelatekHub/main/src/packages/FunctionPack.lua")

local Games = {
  ["Just A Baseplate"] = 123974602339071,
}

Global.GelatekHubConfig = {
    ["Permanent Death"] = false,
    ["Torso Fling"] = false,
    ["Bullet Enabled"] = false,
    ["Enable Collisions"] = false,
    ["Keep Hats On Head"] = false,
    ["Headless On Perma"] = false,
    ["Anti Void"] = false,
    ["Anti Void Offset"] = 75,
    ["Disable Anims"] = false,
}

local Success, Hui = pcall(function() return gethui and gethui() end)
local CoreGui = (Success and Hui) or Services.CoreGui
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService

local GelatekHub = Instance.new("ScreenGui")
GelatekHub.DisplayOrder = 1
GelatekHub.Name = "GelatekHub"
GelatekHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GelatekHub.ResetOnSpawn = false
GelatekHub.Parent = CoreGui

local Show = Instance.new("TextButton")
Show.TextWrapped = true
Show.BorderSizePixel = 0
Show.TextScaled = true
Show.TextColor3 = Color3.fromRGB(255, 88, 91)
Show.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
Show.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Show.Size = UDim2.new(0, 32, 0, 32)
Show.Text = "G"
Show.Name = "Show"
Show.Visible = false
Show.Position = UDim2.new(0, 18, 0, 6)
Show.Parent = GelatekHub

local ShowStroke = Instance.new("UIStroke")
ShowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ShowStroke.Color = Color3.fromRGB(255, 88, 91)
ShowStroke.Parent = Show

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(0, 4)
ShowCorner.Parent = Show

local Main = Instance.new("Frame")
Main.BorderSizePixel = 0
Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Main.Size = UDim2.new(0.7, 0, 0.9, 0)
Main.Position = UDim2.new(0, 18, 0, 6)
Main.Name = "Main"
Main.BackgroundTransparency = 1
Main.Parent = GelatekHub

local Shadow = Instance.new("ImageLabel")
Shadow.BorderSizePixel = 0
Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Shadow.ImageTransparency = 0.2
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Image = "rbxassetid://15298624572"
Shadow.Size = UDim2.new(1.059, 0, 1.088, 0)
Shadow.BackgroundTransparency = 1
Shadow.Name = "Shadow"
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Parent = Main

local Frame = Instance.new("CanvasGroup")
Frame.ZIndex = 2
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.Name = "Frame"
Frame.Parent = Main

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 4)
FrameCorner.Parent = Frame

local FrameLayout = Instance.new("UIListLayout")
FrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
FrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
FrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
FrameLayout.Parent = Frame

local Topbar = Instance.new("Frame")
Topbar.BorderSizePixel = 0
Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Topbar.Size = UDim2.new(1, 0, 0.1, 0)
Topbar.Name = "Topbar"
Topbar.LayoutOrder = 1
Topbar.BackgroundTransparency = 1
Topbar.Parent = Frame

local TopbarLayout = Instance.new("UIListLayout")
TopbarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
TopbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
TopbarLayout.Padding = UDim.new(0, 4)
TopbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
TopbarLayout.FillDirection = Enum.FillDirection.Horizontal
TopbarLayout.Parent = Topbar

local TopbarPadding = Instance.new("UIPadding")
TopbarPadding.PaddingTop = UDim.new(0, 4)
TopbarPadding.PaddingRight = UDim.new(0, 4)
TopbarPadding.PaddingLeft = UDim.new(0, 4)
TopbarPadding.PaddingBottom = UDim.new(0, 4)
TopbarPadding.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.TextWrapped = true
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextScaled = true
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Title.TextColor3 = Color3.fromRGB(255, 88, 91)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Text = "Gelatek Hub Remastered • " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
Title.LayoutOrder = 1
Title.Name = "Title"
Title.Parent = Topbar

local TitlePadding = Instance.new("UIPadding")
TitlePadding.PaddingTop = UDim.new(0, 1)
TitlePadding.PaddingBottom = UDim.new(0, 1)
TitlePadding.Parent = Title

local Hide = Instance.new("TextButton")
Hide.TextWrapped = true
Hide.BorderSizePixel = 0
Hide.TextScaled = true
Hide.TextColor3 = Color3.fromRGB(255, 88, 91)
Hide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Hide.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Hide.BackgroundTransparency = 1
Hide.Size = UDim2.new(0.2, 0, 1, 0)
Hide.LayoutOrder = 2
Hide.Text = "-"
Hide.Name = "Hide"
Hide.Parent = Topbar

local HideRatio = Instance.new("UIAspectRatioConstraint")
HideRatio.Parent = Hide

local Close = Instance.new("TextButton")
Close.TextWrapped = true
Close.BorderSizePixel = 0
Close.TextScaled = true
Close.TextColor3 = Color3.fromRGB(255, 88, 91)
Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Close.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Close.BackgroundTransparency = 1
Close.Size = UDim2.new(0.2, 0, 1, 0)
Close.LayoutOrder = 3
Close.Text = "×"
Close.Name = "Close"
Close.Parent = Topbar

local CloseRatio = Instance.new("UIAspectRatioConstraint")
CloseRatio.Parent = Close

local FrameContent = Instance.new("Frame")
FrameContent.BorderSizePixel = 0
FrameContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FrameContent.Size = UDim2.new(1, 0, 0.9, 0)
FrameContent.Name = "FrameContent"
FrameContent.LayoutOrder = 2
FrameContent.BackgroundTransparency = 1
FrameContent.Parent = Frame

local FrameContentLayout = Instance.new("UIListLayout")
FrameContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
FrameContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
FrameContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
FrameContentLayout.FillDirection = Enum.FillDirection.Horizontal
FrameContentLayout.Parent = FrameContent

local Tabs = Instance.new("ScrollingFrame")
Tabs.ScrollingDirection = Enum.ScrollingDirection.Y
Tabs.BorderSizePixel = 0
Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Tabs.Name = "Tabs"
Tabs.AutomaticCanvasSize = Enum.AutomaticSize.Y
Tabs.Size = UDim2.new(0.25, 0, 1, 0)
Tabs.ScrollBarThickness = 0
Tabs.LayoutOrder = 1
Tabs.BackgroundTransparency = 1
Tabs.Parent = FrameContent

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
TabsLayout.Padding = UDim.new(0, 9)
TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabsLayout.Parent = Tabs

local TabsPadding = Instance.new("UIPadding")
TabsPadding.PaddingTop = UDim.new(0, 4)
TabsPadding.PaddingRight = UDim.new(0, 4)
TabsPadding.PaddingLeft = UDim.new(0, 4)
TabsPadding.PaddingBottom = UDim.new(0, 4)
TabsPadding.Parent = Tabs

local Contents = Instance.new("Frame")
Contents.BorderSizePixel = 0
Contents.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Contents.Size = UDim2.new(0.75, 0, 1, 0)
Contents.Name = "Contents"
Contents.LayoutOrder = 2
Contents.BackgroundTransparency = 1
Contents.Parent = FrameContent

local ContentsPadding = Instance.new("UIPadding")
ContentsPadding.PaddingTop = UDim.new(0, 4)
ContentsPadding.PaddingRight = UDim.new(0, 4)
ContentsPadding.PaddingLeft = UDim.new(0, 4)
ContentsPadding.PaddingBottom = UDim.new(0, 4)
ContentsPadding.Parent = Contents

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
    sf.Parent = Contents
    local layout = Instance.new("UIListLayout")
    layout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = sf
    return sf
end

local HomeContent = MakeScrollContent("HomeContent", 1, 5)
HomeContent.Visible = true
local ReanimContent = MakeScrollContent("ReanimContent", 2, 0)
local FreeScriptsContent = MakeScrollContent("FreeScriptsContent", 3, 0)
local HatScriptsContent = MakeScrollContent("HatScriptsContent", 4, 0)
local HatsContent = MakeScrollContent("HatsContent", 5, 0)
local CreditsContent = MakeScrollContent("CreditsContent", 6, 5)

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

local Welcome = Instance.new("Frame")
Welcome.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
Welcome.Size = UDim2.new(0, 300, 0, 31)
Welcome.Name = "Welcome"
Welcome.LayoutOrder = 1
Welcome.Parent = HomeContent
Instance.new("UICorner", Welcome).CornerRadius = UDim.new(0, 4)
MakePadding(Welcome)

local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.TextWrapped = true
WelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
WelcomeLabel.TextScaled = true
WelcomeLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WelcomeLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Size = UDim2.new(1, 0, 1, 0)
WelcomeLabel.Text = "Hello! Thanks for using our hub. We hope you enjoy it!"
WelcomeLabel.Parent = Welcome

local Version = Instance.new("Frame")
Version.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
Version.Size = UDim2.new(0, 300, 0, 31)
Version.Name = "Version"
Version.LayoutOrder = 2
Version.Parent = HomeContent
Instance.new("UICorner", Version).CornerRadius = UDim.new(0, 4)
MakePadding(Version)

local VersionLabel = Instance.new("TextLabel")
VersionLabel.TextWrapped = true
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.TextScaled = true
VersionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
VersionLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
VersionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Size = UDim2.new(1, 0, 1, 0)
VersionLabel.Text = "Current Version: 1.0"
VersionLabel.Parent = Version

MakeDivider(FreeScriptsContent, 2)
local Deanimate = MakeButton(FreeScriptsContent, "- [ Deanimate ] -", 1)
local GaleFighter = MakeButton(FreeScriptsContent, "Gale Fighter", 3)
local Ender = MakeButton(FreeScriptsContent, "Ender", 4)
local Caducus = MakeButton(FreeScriptsContent, "Caducus", 5)
MakeDivider(FreeScriptsContent, 6)
local Keyboard = MakeButton(FreeScriptsContent, "Keyboard", 7)

MakeDivider(ReanimContent, 2)
local ReanimateBtn = MakeButton(ReanimContent, "- [ Reanimate ] -", 1)
local EnablePermadeath, PermadeathToggle = MakeToggleButton(ReanimContent, "Permanent Death", 3)
local EnableTorsoFling, TorsoFlingToggle = MakeToggleButton(ReanimContent, "Torso Fling", 4)
local EnableBulletFling, BulletFlingToggle = MakeToggleButton(ReanimContent, "Bullet Fling", 5)
local EnableCollisions, CollisionsToggle = MakeToggleButton(ReanimContent, "Collisions", 6)
local EnableNetless, NetlessToggle = MakeToggleButton(ReanimContent, "Keep Hats Attached", 7)
local EnableHeadless, HeadlessToggle = MakeToggleButton(ReanimContent, "Headless On Permadeath", 8)
local DisableAnims, DisableAnimsToggle = MakeToggleButton(ReanimContent, "Disable Animations", 9)
local EnableAntivoid, AntivoidToggle = MakeToggleButton(ReanimContent, "Antivoid", 10)

MakeDivider(HatScriptsContent, 2)
local HatScriptsDeanimate = MakeButton(HatScriptsContent, "- [ Deanimate ] -", 1)
local DualUltima = MakeButton(HatScriptsContent, "Dual Ultima", 3)
local TheHotline = MakeButton(HatScriptsContent, "The Hotline", 4)
local Carnage = MakeButton(HatScriptsContent, "Carnage", 5)
local NeptunianV = MakeButton(HatScriptsContent, "Neptunian V", 6)
local ZenithBattleRifle = MakeButton(HatScriptsContent, "Zenith Battle Rifle-70", 7)
local Chips = MakeButton(HatScriptsContent, "Chips", 8)
local VoidScythe = MakeButton(HatScriptsContent, "Void Scythe", 9)
local VoodooDoll = MakeButton(HatScriptsContent, "Voodoo Doll", 10)
local Quenox = MakeButton(HatScriptsContent, "Quenox", 11)
local Goner = MakeButton(HatScriptsContent, "Goner", 12)

MakeDivider(HatsContent, 2)
local CopyR6BulletHat = MakeButton(HatsContent, "Copy R6 Bullet Hat Id(s)", 1)
local CopyDualUltimaHats = MakeButton(HatsContent, "Copy Dual Ultima Hat Id(s)", 3)
local CopyTheHotlineHats = MakeButton(HatsContent, "Copy The Hotline Hat Id(s)", 4)
local CopyCarnageHats = MakeButton(HatsContent, "Copy Carnage Hat Id(s)", 5)
local CopyNeptunianVHats = MakeButton(HatsContent, "Copy Neptunian V Hat Id(s)", 6)
local CopyZenithBattleRifleHats = MakeButton(HatsContent, "Copy Zenith Battle Rifle-70 Hat Id(s)", 7)
local CopyChipsHats = MakeButton(HatsContent, "Copy Chips Hat Id(s)", 8)
local CopyVoidScytheHats = MakeButton(HatsContent, "Copy Void Scythe Hat Id(s)", 9)
local CopyVoodooDollHats = MakeButton(HatsContent, "Copy Voodoo Doll Hat Id(s)", 10)
local CopyQuenoxHats = MakeButton(HatsContent, "Copy Quenox Hat Id(s)", 11)
local CopyGonerHats = MakeButton(HatsContent, "Copy Goner Hat Id(s)", 12)

local CreditsLabel = Instance.new("TextLabel")
CreditsLabel.TextWrapped = true
CreditsLabel.TextXAlignment = Enum.TextXAlignment.Left
CreditsLabel.TextSize = 14
CreditsLabel.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
CreditsLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CreditsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CreditsLabel.RichText = true
CreditsLabel.Size = UDim2.new(1, 0, 0, 0)
CreditsLabel.Text = "<b>Original Creator:</b> Gelatekussy\n<b>Remastered By:</b> JustAGuest\n\n<b>Special Thanks:</b> Everyone who supported Gelatek Hub.\n\nThis remaster is based on the original Gelatek Hub. Full credit for the original project and its foundation belongs to Gelatekussy."
CreditsLabel.AutomaticSize = Enum.AutomaticSize.Y
CreditsLabel.LayoutOrder = 1
CreditsLabel.Parent = CreditsContent
MakePadding(CreditsLabel)
Instance.new("UICorner", CreditsLabel).CornerRadius = UDim.new(0, 4)

local HomeTab, HomeTabUnderlay, HomeTabLabel = MakeTabButton(Tabs, "Home", 1)
HomeTabLabel.TextTransparency = 0
HomeTabUnderlay.Size = UDim2.new(1, 0, 0, 2)

local ReanimTab, ReanimTabUnderlay, ReanimTabLabel = MakeTabButton(Tabs, "Reanimate", 2)
local FreeScriptsTab, FreeScriptsTabUnderlay, FreeScriptsTabLabel = MakeTabButton(Tabs, "Free Scripts", 3)
local HatScriptsTab, HatScriptsTabUnderlay, HatScriptsTabLabel = MakeTabButton(Tabs, "Hat Scripts", 4)
local HatsTab, HatsTabUnderlay, HatsTabLabel = MakeTabButton(Tabs, "Hats", 5)
local CreditsTab, CreditsTabUnderlay, CreditsTabLabel = MakeTabButton(Tabs, "Credits", 6)

local function TweenUnderlay(underlay, sizeX)
    local ok, tween = SafeCall(function()
        return TweenService:Create(underlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(sizeX, 0, 0, 2)
        })
    end)
    if ok and tween then tween:Play() end
end

local function TweenText(label, transparency)
    local ok, tween = SafeCall(function()
        return TweenService:Create(label, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = transparency
        })
    end)
    if ok and tween then tween:Play() end
end

local function Dragify(DragObject, MoveObject)
    MoveObject = MoveObject or DragObject
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

    local function ClampPosition(newX, newY)
        local viewport = workspace.CurrentCamera.ViewportSize
        local size = MoveObject.AbsoluteSize
        local padding = 3
        return math.clamp(newX, padding, viewport.X - size.X - padding),
            math.clamp(newY, padding, viewport.Y - size.Y - padding)
    end

    DragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MoveObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
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
            local newX, newY = ClampPosition(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
            MoveObject.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        end
    end)
end

Dragify(Show)
Dragify(Frame, Main)

local function HideMain()
    SafeCall(function()
        TweenService:Create(Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { ImageTransparency = 1 }):Play()
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { BackgroundTransparency = 1 }):Play()
        local fadeOut = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { GroupTransparency = 1 })
        fadeOut:Play()
        fadeOut.Completed:Wait()
        Main.Visible = false
        Show.Visible = true
        TweenService:Create(Show, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
    end)
end

local function ShowMain()
    SafeCall(function()
        local fadeOutShow = TweenService:Create(Show, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 })
        fadeOutShow:Play()
        fadeOutShow.Completed:Wait()
        Show.Visible = false
        Main.Visible = true
        TweenService:Create(Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { ImageTransparency = 0.2 }):Play()
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { GroupTransparency = 0 }):Play()
    end)
end

Hide.MouseButton1Click:Connect(HideMain)
Show.MouseButton1Click:Connect(ShowMain)

local TabMap = {
    Home = { Content = HomeContent, Underlay = HomeTabUnderlay, Label = HomeTabLabel },
    Reanimate = { Content = ReanimContent, Underlay = ReanimTabUnderlay, Label = ReanimTabLabel },
    FreeScripts = { Content = FreeScriptsContent, Underlay = FreeScriptsTabUnderlay, Label = FreeScriptsTabLabel },
    HatScripts = { Content = HatScriptsContent, Underlay = HatScriptsTabUnderlay, Label = HatScriptsTabLabel },
    Hats = { Content = HatsContent, Underlay = HatsTabUnderlay, Label = HatsTabLabel },
    Credits = { Content = CreditsContent, Underlay = CreditsTabUnderlay, Label = CreditsTabLabel },
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

HomeTab.MouseButton1Click:Connect(function() SelectTab("Home") end)
ReanimTab.MouseButton1Click:Connect(function() SelectTab("Reanimate") end)
FreeScriptsTab.MouseButton1Click:Connect(function() SelectTab("FreeScripts") end)
HatScriptsTab.MouseButton1Click:Connect(function() SelectTab("HatScripts") end)
HatsTab.MouseButton1Click:Connect(function() SelectTab("Hats") end)
CreditsTab.MouseButton1Click:Connect(function() SelectTab("Credits") end)

SelectTab("Home")

local function BetterStopScript()
    SafeCall(function()
        StopScript()
        task.wait(0.25)
        StopScript()
    end)
end

local function MakeToggle(button, toggleFrame, configKey)
    local isOn = false
    button.MouseButton1Click:Connect(function()
        isOn = not isOn
        Global.GelatekHubConfig[configKey] = isOn
        toggleFrame.BackgroundColor3 = isOn and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(255, 57, 60)
    end)
end

MakeToggle(EnablePermadeath, PermadeathToggle, "Permanent Death")
MakeToggle(EnableTorsoFling, TorsoFlingToggle, "Torso Fling")
MakeToggle(EnableBulletFling, BulletFlingToggle, "Bullet Enabled")
MakeToggle(EnableCollisions, CollisionsToggle, "Enable Collisions")
MakeToggle(EnableNetless, NetlessToggle, "Keep Hats On Head")
MakeToggle(EnableHeadless, HeadlessToggle, "Headless On Perma")
MakeToggle(EnableAntivoid, AntivoidToggle, "Anti Void")
MakeToggle(DisableAnims, DisableAnimsToggle, "Disable Anims")

local BASE = "https://raw.githubusercontent.com/Gelatekussy/GelatekHub/main/src/"

local function IsGame(targetPlaceId)
    return game.PlaceId == targetPlaceId
end

if IsGame(Games["Just A Baseplate"]) then
    local CmdEvent = game:GetService("ReplicatedStorage"):WaitForChild("01_server")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local function WaitForDeath()
        local character = LocalPlayer.Character
        if not character then
            character = LocalPlayer.CharacterAdded:Wait()
        end
        local humanoid = character:WaitForChild("Humanoid")
        local connection
        connection = humanoid.HealthChanged:Connect(function(health)
            if health <= 0 then
                connection:Disconnect()
            end
        end)
    end
    
    ReanimateBtn.MouseButton1Click:Connect(function()
        if Global.GelatekHubConfig["Permanent Death"] then
            CmdEvent:FireServer("cmd", "-pd")
        end
        task.wait(2)
        if Global.GelatekHubConfig["Keep Hats On Head"] then
            CmdEvent:FireServer("cmd", "-net")
        end
        task.wait(2)
        Run(BASE .. "lib/Reanimate.lua")
        WaitForDeath()
        task.wait(0.1)
        CmdEvent:FireServer("cmd", "-net")
    end)
    
    local hatIdMap = {
        [CopyR6BulletHat] = "48474313",
        [CopyDualUltimaHats] = "4524991457,4820152700",
        [CopyTheHotlineHats] = "4962455546",
        [CopyCarnageHats] = "5134896593,5410674378",
        [CopyNeptunianVHats] = "4506945409",
        [CopyZenithBattleRifleHats] = "4962510729,4962455546",
        [CopyChipsHats] = "4964938812",
        [CopyVoidScytheHats] = "5414429551",
        [CopyVoodooDollHats] = "7218265043,7170689370",
        [CopyQuenoxHats] = "4820152700,4794315940,4524991457,4315489767,4458601937,4506945409",
        [CopyGonerHats] = "6869866014",
    }
    for btn, ids in pairs(hatIdMap) do
        btn.Text = btn.Text:gsub("^Copy", "Get"):gsub("Hat Id%(s%)", "Hat(s)")
        btn.MouseButton1Click:Connect(function()
            CmdEvent:FireServer("cmd", "-gh " .. ids)
        end)
    end
else
    ReanimateBtn.MouseButton1Click:Connect(function()
        Run(BASE .. "lib/Reanimate.lua")
    end)
    
    local function CopyToClipboard(text)
        SafeCall(function()
            if type(setclipboard) == "function" then
                setclipboard(text)
                Services.StarterGui:SetCore("SendNotification", { Title = "Copied!", Text = text, Duration = 2 })
            else
                warn("[GelatekHub]: setclipboard not available")
            end
        end)
    end
    CopyR6BulletHat.MouseButton1Click:Connect(function() CopyToClipboard("48474313") end)
    CopyDualUltimaHats.MouseButton1Click:Connect(function() CopyToClipboard("4524991457,4820152700") end)
    CopyTheHotlineHats.MouseButton1Click:Connect(function() CopyToClipboard("4962455546") end)
    CopyCarnageHats.MouseButton1Click:Connect(function() CopyToClipboard("5134896593,5410674378") end)
    CopyNeptunianVHats.MouseButton1Click:Connect(function() CopyToClipboard("4506945409") end)
    CopyZenithBattleRifleHats.MouseButton1Click:Connect(function() CopyToClipboard("4962510729,4962455546") end)
    CopyChipsHats.MouseButton1Click:Connect(function() CopyToClipboard("4964938812") end)
    CopyVoidScytheHats.MouseButton1Click:Connect(function() CopyToClipboard("5414429551") end)
    CopyVoodooDollHats.MouseButton1Click:Connect(function() CopyToClipboard("7218265043,7170689370") end)
    CopyQuenoxHats.MouseButton1Click:Connect(function() CopyToClipboard("4820152700,4794315940,4524991457,4315489767,4458601937,4506945409") end)
    CopyGonerHats.MouseButton1Click:Connect(function() CopyToClipboard("6869866014") end)
end

Deanimate.MouseButton1Click:Connect(BetterStopScript)
HatScriptsDeanimate.MouseButton1Click:Connect(BetterStopScript)

GaleFighter.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/GaleFighter.lua")
end)

Ender.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/Ender.lua")
end)

Caducus.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/Cadacus.lua")
end)

Keyboard.MouseButton1Click:Connect(function()
    Run("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/DeltaKD.luau")
end)

DualUltima.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/DualUltima.lua")
end)

TheHotline.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/TheHotline.lua")
end)

Carnage.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/TheCarnage.lua")
end)

NeptunianV.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/NeptunianV.lua")
end)

ZenithBattleRifle.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/ZenithAttackRifle.lua")
end)

Chips.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/TheChips.lua")
end)

VoidScythe.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/VoidScythe.lua")
end)

VoodooDoll.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/VoodooDoll.lua")
end)

Quenox.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/Quenox.lua")
end)

Goner.MouseButton1Click:Connect(function()
    Run(BASE .. "scripts/Goner.lua")
end)

Close.MouseButton1Click:Connect(function()
    SafeCall(function()
        GelatekHub:Destroy()
        Global.GelatekHubRM.isLoaded = false
    end)
end)