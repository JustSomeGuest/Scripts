if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Blacklist = {}

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

local Players = Services.Players
local TweenService = Services.TweenService
local Hui = (gethui and gethui()) or Services.CoreGui
local LocalPlayer = Players.LocalPlayer

local function BetterTween(Object, Speed, Properties, EasingStyle, EasingDirection)
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

local function AnimateUIStroke(UIStroke)
    local UIGradient = UIStroke:FindFirstChildOfClass("UIGradient")
    if not UIGradient then
        return
    end

    task.spawn(function()
        while UIGradient.Parent do
            local Sine = os.clock()

            UIGradient.Rotation += 1
            UIGradient.Offset = Vector2.new(
                2.5 * math.sin(Sine),
                math.cos((Sine + 0.5) * 0.1)
            )

            task.wait()
        end
    end)
end

local function AnimateScreenGui(ScreenGui)
    for _, Object in ScreenGui:GetDescendants() do
        if Object:IsA("UIStroke") then
            AnimateUIStroke(Object)
        end
    end
end

local Repo = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/"

local function Get(URL)
    local Success, Response = pcall(game.HttpGetAsync, game, URL)

    if not Success then
        Success, Response = pcall(game.HttpGet, game, URL)
    end

    if not Success then
        error(("[Init Error]: Failed to fetch script: %s"):format(tostring(Response)), 0)
    end

    local Chunk, Err = loadstring(Response)

    if not Chunk then
        error(("[Init Error]: %s"):format(tostring(Err)), 0)
    end

    local Loaded, Result = pcall(Chunk)

    if not Loaded then
        error(("[Init Error]: %s"):format(tostring(Result)), 0)
    end

    return Result
end

local Users = Get(Repo .. "Blacklist/Users.luau")

local ExistingUI = nil

local function CreateBlacklistUI(UserData)
    if ExistingUI then
        return
    end

    local UI = {}

    UI["BlacklistUI"] = Instance.new("ScreenGui")
    UI["BlacklistUI"]["Name"] = [[BlacklistUI]]
    UI["BlacklistUI"]["IgnoreGuiInset"] = true
    UI["BlacklistUI"]["DisplayOrder"] = 999
    UI["BlacklistUI"]["ResetOnSpawn"] = false
    UI["BlacklistUI"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
    UI["BlacklistUI"]["Parent"] = Hui

    UI["Background"] = Instance.new("Frame")
    UI["Background"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
    UI["Background"]["BackgroundTransparency"] = 0.5
    UI["Background"]["BorderSizePixel"] = 0
    UI["Background"]["Name"] = [[Background]]
    UI["Background"]["Size"] = UDim2.new(1, 0, 1, 0)
    UI["Background"]["Parent"] = UI["BlacklistUI"]

    UI["Frame"] = Instance.new("Frame")
    UI["Frame"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
    UI["Frame"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20)
    UI["Frame"]["BackgroundTransparency"] = 0
    UI["Frame"]["BorderSizePixel"] = 0
    UI["Frame"]["Name"] = [[Frame]]
    UI["Frame"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
    UI["Frame"]["Size"] = UDim2.new(0, 0, 0, 0)
    UI["Frame"]["Parent"] = UI["BlacklistUI"]

    UI["Corner"] = Instance.new("UICorner")
    UI["Corner"]["CornerRadius"] = UDim.new(0, 8)
    UI["Corner"]["Name"] = [[Corner]]
    UI["Corner"]["Parent"] = UI["Frame"]

    UI["Layout"] = Instance.new("UIListLayout")
    UI["Layout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
    UI["Layout"]["Name"] = [[Layout]]
    UI["Layout"]["Padding"] = UDim.new(0, 12)
    UI["Layout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
    UI["Layout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
    UI["Layout"]["Parent"] = UI["Frame"]

    UI["Padding"] = Instance.new("UIPadding")
    UI["Padding"]["Name"] = [[Padding]]
    UI["Padding"]["PaddingBottom"] = UDim.new(0, 24)
    UI["Padding"]["PaddingLeft"] = UDim.new(0, 24)
    UI["Padding"]["PaddingRight"] = UDim.new(0, 24)
    UI["Padding"]["PaddingTop"] = UDim.new(0, 24)
    UI["Padding"]["Parent"] = UI["Frame"]

    UI["Stroke"] = Instance.new("UIStroke")
    UI["Stroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
    UI["Stroke"]["Color"] = Color3.fromRGB(255, 0, 0)
    UI["Stroke"]["Name"] = [[Stroke]]
    UI["Stroke"]["Thickness"] = 2
    UI["Stroke"]["Parent"] = UI["Frame"]

    UI["StrokeGradient"] = Instance.new("UIGradient")
    UI["StrokeGradient"]["Color"] = ColorSequence.new{
        ColorSequenceKeypoint.new(0.000, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.500, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1.000, Color3.fromRGB(0, 0, 0))
    }
    UI["StrokeGradient"]["Name"] = [[StrokeGradient]]
    UI["StrokeGradient"]["Parent"] = UI["Stroke"]

    local titleText = "You have been blacklisted!"
    if UserData.Title then
        titleText = UserData.Title
    end

    UI["Title"] = Instance.new("TextLabel")
    UI["Title"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Title"]["BackgroundTransparency"] = 1
    UI["Title"]["BorderSizePixel"] = 0
    UI["Title"]["FontFace"] = Font.new([[rbxasset://fonts/families/Sarpanch.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    UI["Title"]["LayoutOrder"] = 1
    UI["Title"]["Name"] = [[Title]]
    UI["Title"]["Size"] = UDim2.new(1, 0, 0, 40)
    UI["Title"]["Text"] = titleText
    UI["Title"]["TextColor3"] = Color3.fromRGB(255, 60, 60)
    UI["Title"]["TextScaled"] = true
    UI["Title"]["TextWrapped"] = true
    UI["Title"]["Parent"] = UI["Frame"]

    UI["TitleConstraint"] = Instance.new("UISizeConstraint")
    UI["TitleConstraint"]["Name"] = [[TitleConstraint]]
    UI["TitleConstraint"]["MaxSize"] = Vector2.new(math.huge, 40)
    UI["TitleConstraint"]["Parent"] = UI["Title"]

    local reasonText = "Reason: " .. (UserData.Reason or "Unknown")
    local byText = "By: " .. (UserData.By or "System")

    UI["Description"] = Instance.new("TextLabel")
    UI["Description"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Description"]["BackgroundTransparency"] = 1
    UI["Description"]["BorderSizePixel"] = 0
    UI["Description"]["FontFace"] = Font.new([[rbxasset://fonts/families/Sarpanch.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    UI["Description"]["LayoutOrder"] = 2
    UI["Description"]["Name"] = [[Description]]
    UI["Description"]["Size"] = UDim2.new(1, 0, 0, 60)
    UI["Description"]["Text"] = reasonText .. "\n" .. byText
    UI["Description"]["TextColor3"] = Color3.fromRGB(200, 200, 200)
    UI["Description"]["TextScaled"] = true
    UI["Description"]["TextWrapped"] = true
    UI["Description"]["TextXAlignment"] = Enum.TextXAlignment.Left
    UI["Description"]["TextYAlignment"] = Enum.TextYAlignment.Center
    UI["Description"]["Parent"] = UI["Frame"]

    UI["Buttons"] = Instance.new("Frame")
    UI["Buttons"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Buttons"]["BackgroundTransparency"] = 1
    UI["Buttons"]["BorderSizePixel"] = 0
    UI["Buttons"]["LayoutOrder"] = 3
    UI["Buttons"]["Name"] = [[Buttons]]
    UI["Buttons"]["Size"] = UDim2.new(1, 0, 0, 45)
    UI["Buttons"]["Parent"] = UI["Frame"]

    UI["ButtonsLayout"] = Instance.new("UIListLayout")
    UI["ButtonsLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
    UI["ButtonsLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
    UI["ButtonsLayout"]["Name"] = [[ButtonsLayout]]
    UI["ButtonsLayout"]["Padding"] = UDim.new(0, 12)
    UI["ButtonsLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
    UI["ButtonsLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
    UI["ButtonsLayout"]["Parent"] = UI["Buttons"]

    UI["ButtonsConstraint"] = Instance.new("UISizeConstraint")
    UI["ButtonsConstraint"]["MaxSize"] = Vector2.new(9999, 45)
    UI["ButtonsConstraint"]["Name"] = [[ButtonsConstraint]]
    UI["ButtonsConstraint"]["Parent"] = UI["Buttons"]

    UI["Understood"] = Instance.new("TextButton")
    UI["Understood"]["BackgroundColor3"] = Color3.fromRGB(255, 0, 0)
    UI["Understood"]["BackgroundTransparency"] = 0.9
    UI["Understood"]["BorderSizePixel"] = 0
    UI["Understood"]["FontFace"] = Font.new([[rbxasset://fonts/families/Sarpanch.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    UI["Understood"]["LayoutOrder"] = 1
    UI["Understood"]["Name"] = [[Understood]]
    UI["Understood"]["Size"] = UDim2.new(1, 0, 1, 0)
    UI["Understood"]["Text"] = [[I Understand]]
    UI["Understood"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Understood"]["TextScaled"] = true
    UI["Understood"]["TextWrapped"] = true
    UI["Understood"]["Parent"] = UI["Buttons"]

    UI["UnderstoodCorner"] = Instance.new("UICorner")
    UI["UnderstoodCorner"]["CornerRadius"] = UDim.new(0, 4)
    UI["UnderstoodCorner"]["Name"] = [[UnderstoodCorner]]
    UI["UnderstoodCorner"]["Parent"] = UI["Understood"]

    UI["UnderstoodStroke"] = Instance.new("UIStroke")
    UI["UnderstoodStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
    UI["UnderstoodStroke"]["Color"] = Color3.fromRGB(255, 0, 0)
    UI["UnderstoodStroke"]["Name"] = [[UnderstoodStroke]]
    UI["UnderstoodStroke"]["Thickness"] = 2
    UI["UnderstoodStroke"]["Parent"] = UI["Understood"]

    UI["UnderstoodStrokeGradient"] = Instance.new("UIGradient")
    UI["UnderstoodStrokeGradient"]["Color"] = ColorSequence.new{
        ColorSequenceKeypoint.new(0.000, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.500, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1.000, Color3.fromRGB(0, 0, 0))
    }
    UI["UnderstoodStrokeGradient"]["Name"] = [[UnderstoodStrokeGradient]]
    UI["UnderstoodStrokeGradient"]["Parent"] = UI["UnderstoodStroke"]

    AnimateScreenGui(UI["BlacklistUI"])

    local function CloseUI()
        local slideOut = BetterTween(UI["Frame"], 0.3, {Size = UDim2.new(0, 0, 0, 0)}, "Quad", "In")
        slideOut:Play()
        slideOut.Completed:Connect(function()
            UI["BlacklistUI"]:Destroy()
            ExistingUI = nil
        end)
    end

    local slideIn = BetterTween(UI["Frame"], 0.5, {Size = UDim2.new(0.4, 0, 0.35, 0)}, "Quad", "Out")
    slideIn:Play()

    UI["Understood"]["MouseButton1Click"]:Connect(function()
        CloseUI()
    end)

    UI["Understood"]["MouseEnter"]:Connect(function()
        local hoverTween = BetterTween(UI["Understood"], 0.15, {BackgroundTransparency = 0.7}, "Quad", "Out")
        hoverTween:Play()
    end)

    UI["Understood"]["MouseLeave"]:Connect(function()
        local leaveTween = BetterTween(UI["Understood"], 0.15, {BackgroundTransparency = 0.9}, "Quad", "Out")
        leaveTween:Play()
    end)

    UI["Understood"]["MouseButton1Down"]:Connect(function()
        local pressTween = BetterTween(UI["Understood"], 0.05, {BackgroundTransparency = 0.5}, "Quad", "Out")
        pressTween:Play()
    end)

    UI["Understood"]["MouseButton1Up"]:Connect(function()
        local releaseTween = BetterTween(UI["Understood"], 0.1, {BackgroundTransparency = 0.7}, "Quad", "Out")
        releaseTween:Play()
    end)

    ExistingUI = UI["BlacklistUI"]
end

function Blacklist.IsBlacklisted()
    local UserData = Users[LocalPlayer.UserId]

    if not UserData then
        return false
    end

    CreateBlacklistUI(UserData)
    return true
end

return Blacklist