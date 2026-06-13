if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Global = (pcall(getgenv) and getgenv()) or warn("[Disclaimer]: Executor doesn't support getgenv()")

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

local Success, Hui = pcall(function() return gethui and gethui() end)
local CoreGui = Success and Hui or Services.CoreGui
local TweenService = Services.TweenService
local StarterGui = Services.StarterGui

local Disclaimer = {}

Disclaimer.Script = nil

local function Notify(message)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Disclaimer",
            Text = message,
            Duration = 5
        })
    end)
end

local function CreateDisclaimer()
    if getgenv().Disclaimer and getgenv().Disclaimer.isLoaded then
        return nil
    end

    getgenv().Disclaimer = getgenv().Disclaimer or {}
    getgenv().Disclaimer.isLoaded = true

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Disclaimer"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(0.6, 0, 0.8, 0)
    Container.Position = UDim2.new(0, 164, 0, 32)
    Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.Parent = ScreenGui

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1.059, 0, 1.088, 0)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Shadow.BackgroundTransparency = 1
    Shadow.BorderSizePixel = 0
    Shadow.Image = "rbxassetid://15298624572"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.2
    Shadow.Parent = Container

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BorderSizePixel = 0
    MainFrame.ZIndex = 2
    MainFrame.Parent = Container

    local Options = Instance.new("Frame")
    Options.Name = "Options"
    Options.Size = UDim2.new(0, 70, 0, 34)
    Options.Position = UDim2.new(0, 0, 0, 34)
    Options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Options.BackgroundTransparency = 1
    Options.BorderSizePixel = 0
    Options.LayoutOrder = 3
    Options.Parent = MainFrame

    local Accept = Instance.new("TextButton")
    Accept.Name = "Accept"
    Accept.Size = UDim2.new(0.2, 0, 0.3, 0)
    Accept.BackgroundColor3 = Color3.fromRGB(0, 107, 255)
    Accept.BorderSizePixel = 0
    Accept.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Accept.Text = "Accept"
    Accept.TextScaled = true
    Accept.TextWrapped = true
    Accept.TextColor3 = Color3.fromRGB(255, 255, 255)
    Accept.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Accept.ZIndex = 10
    Accept.ClipsDescendants = true
    Accept.LayoutOrder = 1
    Accept.Parent = Options

    local AcceptStroke = Instance.new("UIStroke")
    AcceptStroke.Name = "Stroke"
    AcceptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AcceptStroke.Thickness = 2
    AcceptStroke.Color = Color3.fromRGB(0, 86, 207)
    AcceptStroke.Parent = Accept

    local AcceptCorner = Instance.new("UICorner")
    AcceptCorner.Name = "Corner"
    AcceptCorner.CornerRadius = UDim.new(0, 4)
    AcceptCorner.Parent = Accept

    local AcceptPadding = Instance.new("UIPadding")
    AcceptPadding.Name = "Padding"
    AcceptPadding.PaddingTop = UDim.new(0, 2)
    AcceptPadding.PaddingRight = UDim.new(0, 2)
    AcceptPadding.PaddingLeft = UDim.new(0, 2)
    AcceptPadding.PaddingBottom = UDim.new(0, 2)
    AcceptPadding.Parent = Accept

    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.Name = "Layout"
    OptionsLayout.FillDirection = Enum.FillDirection.Horizontal
    OptionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    OptionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    OptionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
    OptionsLayout.Padding = UDim.new(0, 8)
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Parent = Options

    local OptionsSC = Instance.new("UISizeConstraint")
    OptionsSC.Name = "OptionsSC"
    OptionsSC.MinSize = Vector2.new(0, 28)
    OptionsSC.MaxSize = Vector2.new(math.huge, 32)
    OptionsSC.Parent = Options

    local Decline = Instance.new("TextButton")
    Decline.Name = "Decline"
    Decline.Size = UDim2.new(0.2, 0, 0.3, 0)
    Decline.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Decline.BorderSizePixel = 0
    Decline.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Decline.Text = "Decline"
    Decline.TextScaled = true
    Decline.TextWrapped = true
    Decline.TextColor3 = Color3.fromRGB(255, 255, 255)
    Decline.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Decline.ZIndex = 10
    Decline.ClipsDescendants = true
    Decline.LayoutOrder = 2
    Decline.Parent = Options

    local DeclineStroke = Instance.new("UIStroke")
    DeclineStroke.Name = "Stroke"
    DeclineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    DeclineStroke.Thickness = 2
    DeclineStroke.Color = Color3.fromRGB(216, 0, 0)
    DeclineStroke.Parent = Decline

    local DeclineCorner = Instance.new("UICorner")
    DeclineCorner.Name = "Corner"
    DeclineCorner.CornerRadius = UDim.new(0, 4)
    DeclineCorner.Parent = Decline

    local DeclinePadding = Instance.new("UIPadding")
    DeclinePadding.Name = "Padding"
    DeclinePadding.PaddingTop = UDim.new(0, 2)
    DeclinePadding.PaddingRight = UDim.new(0, 2)
    DeclinePadding.PaddingLeft = UDim.new(0, 2)
    DeclinePadding.PaddingBottom = UDim.new(0, 2)
    DeclinePadding.Parent = Decline

    local OptionsPadding = Instance.new("UIPadding")
    OptionsPadding.Name = "Padding"
    OptionsPadding.PaddingTop = UDim.new(0, 2)
    OptionsPadding.PaddingRight = UDim.new(0, 2)
    OptionsPadding.PaddingLeft = UDim.new(0, 2)
    OptionsPadding.PaddingBottom = UDim.new(0, 2)
    OptionsPadding.Parent = Options

    local Description = Instance.new("TextLabel")
    Description.Name = "Description"
    Description.Size = UDim2.new(0, 92, 0, 16)
    Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Description.BackgroundTransparency = 1
    Description.BorderSizePixel = 0
    Description.Text = "By selecting <b>\"Accept\"</b>, you acknowledge that using this script violates Roblox's Terms of Service and may result in moderation actions.\n\nPossible consequences include warnings, temporary suspensions, permanent account termination, or removal from the current game by moderators or automated anti-cheat systems.\n\nBy continuing, you confirm that you understand these risks and choose to proceed at your own discretion.\n\nYou accept full responsibility for any consequences that may arise from the use of this script.\n\nThe creator (<b>JustAGuest</b>) provides no guarantees regarding safety, detection, or functionality, and assumes no responsibility for any bans, losses, or damages resulting from its use.\n\nIf you do not agree with this disclaimer, you should immediately decline and discontinue use of this script."
    Description.TextWrapped = true
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.TextScaled = true
    Description.TextSize = 12
    Description.TextColor3 = Color3.fromRGB(255, 255, 255)
    Description.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Description.RichText = true
    Description.LayoutOrder = 2
    Description.Parent = MainFrame

    local MainLayout = Instance.new("UIListLayout")
    MainLayout.Name = "Layout"
    MainLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    MainLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
    MainLayout.Padding = UDim.new(0, 4)
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainLayout.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 462, 0, 224)
    Title.Position = UDim2.new(0, -56, 0, 6)
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.BorderSizePixel = 0
    Title.Text = "⚠️ DISCLAIMER"
    Title.TextScaled = true
    Title.TextWrapped = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Title.LayoutOrder = 1
    Title.Parent = MainFrame

    local TitleSC = Instance.new("UISizeConstraint")
    TitleSC.Name = "TitleSC"
    TitleSC.MinSize = Vector2.new(0, 24)
    TitleSC.MaxSize = Vector2.new(math.huge, 28)
    TitleSC.Parent = Title

    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Name = "Gradient"
    TitleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.000, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.471, Color3.fromRGB(189, 0, 0)),
        ColorSequenceKeypoint.new(1.000, Color3.fromRGB(189, 0, 0))
    }
    TitleGradient.Parent = Title

    local MainCorner = Instance.new("UICorner")
    MainCorner.Name = "Corner"
    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Parent = MainFrame

    local MainPadding = Instance.new("UIPadding")
    MainPadding.Name = "Padding"
    MainPadding.PaddingTop = UDim.new(0, 4)
    MainPadding.PaddingRight = UDim.new(0, 4)
    MainPadding.PaddingLeft = UDim.new(0, 4)
    MainPadding.PaddingBottom = UDim.new(0, 4)
    MainPadding.Parent = MainFrame

    local isAnimating = false

    local function bounceTween(object, goal, time, style, direction)
        if not object or not object.Parent then return end
        local tween = TweenService:Create(
            object,
            TweenInfo.new(time, style, direction),
            goal
        )
        tween:Play()
        tween.Completed:Wait()
    end

    local function SlideIn()
        if isAnimating then return end
        isAnimating = true

        ScreenGui.Enabled = true

        Container.Position = UDim2.new(0.2, 0, -0.8, 0)

        bounceTween(
            Container,
            { Position = UDim2.new(0.2, 0, 0.2, 0) },
            0.45,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        )

        bounceTween(
            Container,
            { Position = UDim2.new(0.2, 0, 0.1, 0) },
            0.18,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        )

        isAnimating = false
    end

    local function SlideOut(callback)
        if isAnimating then return end
        isAnimating = true

        if Container and Container.Parent then
            local moveTween = TweenService:Create(
                Container,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                { Position = UDim2.new(0.2, 0, -0.9, 0) }
            )
            moveTween:Play()
            moveTween.Completed:Wait()
        end

        ScreenGui.Enabled = false
        ScreenGui:Destroy()

        isAnimating = false
        getgenv().Disclaimer.isLoaded = false

        if callback then
            task.spawn(callback)
        end
    end

    Accept.MouseButton1Click:Connect(function()
        task.spawn(function()
            SlideOut(function()
                local URL = Disclaimer.Script
                if not URL or URL == "" then
                    Notify("No script URL has been assigned to Disclaimer.Script")
                    return
                end

                local ok, res = pcall(function()
                    return game:HttpGet(URL)
                end)

                if not ok then
                    Notify("Failed to load script from: " .. tostring(URL))
                    return
                end

                local scriptFunc, err = loadstring(res)
                if not scriptFunc then
                    Notify("Script compilation error: " .. tostring(err))
                    return
                end

                local ok2, execErr = pcall(scriptFunc)
                if not ok2 then
                    Notify("Script execution error: " .. tostring(execErr))
                end
            end)
        end)
    end)

    Decline.MouseButton1Click:Connect(function()
        task.spawn(SlideOut)
    end)

    task.spawn(SlideIn)

    return true
end

function Disclaimer:Start()
    CreateDisclaimer()
    return self
end

setmetatable(Disclaimer, {
    __call = function(self)
        return self:Start()
    end
})

return Disclaimer
