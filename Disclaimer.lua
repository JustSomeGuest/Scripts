local Disclaimer = {}

Disclaimer.Script = nil

local function Notify(message)
    local StarterGui = game:GetService("StarterGui")
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

    local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    ScreenGui.Name = "Disclaimer"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Enabled = false

    local Container = Instance.new("Frame", ScreenGui)
    Container.Name = "Container"
    Container.Size = UDim2.new(0.6, 0, 0.8, 0)
    Container.Position = UDim2.new(0.2, 0, 0.1, 0)
    Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0

    local Shadow = Instance.new("ImageLabel", Container)
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

    local MainFrame = Instance.new("Frame", Container)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BorderSizePixel = 0
    MainFrame.ZIndex = 2

    local MainLayout = Instance.new("UIListLayout", MainFrame)
    MainLayout.Name = "Layout"
    MainLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    MainLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
    MainLayout.Padding = UDim.new(0, 3)
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local MainPadding = Instance.new("UIPadding", MainFrame)
    MainPadding.Name = "Padding"
    MainPadding.PaddingTop = UDim.new(0, 4)
    MainPadding.PaddingRight = UDim.new(0, 4)
    MainPadding.PaddingLeft = UDim.new(0, 4)
    MainPadding.PaddingBottom = UDim.new(0, 4)

    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.Name = "Corner"
    MainCorner.CornerRadius = UDim.new(0, 4)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 182, 0, 24)
    Title.Position = UDim2.new(0, 6, 0, 4)
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

    local TitleSizeConstraint = Instance.new("UISizeConstraint", Title)
    TitleSizeConstraint.MaxSize = Vector2.new(math.huge, 40)

    local TitleGradient = Instance.new("UIGradient", Title)
    TitleGradient.Name = "Gradient"
    TitleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.000, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.471, Color3.fromRGB(189, 0, 0)),
        ColorSequenceKeypoint.new(1.000, Color3.fromRGB(189, 0, 0))
    }

    local Body = Instance.new("ScrollingFrame", MainFrame)
    Body.Name = "Body"
    Body.Size = UDim2.new(1, 0, 1, 0)
    Body.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Body.BackgroundTransparency = 1
    Body.BorderSizePixel = 0
    Body.ScrollingDirection = Enum.ScrollingDirection.Y
    Body.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Body.ScrollBarThickness = 4
    Body.LayoutOrder = 2

    local BodyPadding = Instance.new("UIPadding", Body)
    BodyPadding.Name = "Padding"
    BodyPadding.PaddingTop = UDim.new(0, 4)
    BodyPadding.PaddingRight = UDim.new(0, 6)
    BodyPadding.PaddingLeft = UDim.new(0, 4)
    BodyPadding.PaddingBottom = UDim.new(0, 4)

    local BodyLayout = Instance.new("UIListLayout", Body)
    BodyLayout.Name = "Layout"
    BodyLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    BodyLayout.Padding = UDim.new(0, 2)
    BodyLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Label = Instance.new("TextLabel", Body)
    Label.Name = "Label"
    Label.Size = UDim2.new(1, 0, 0, 0)
    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.BorderSizePixel = 0
    Label.Text = "By selecting <b>\"Accept\"</b>, you acknowledge that using this script violates Roblox's Terms of Service and may result in moderation actions.\n\nPossible consequences include warnings, temporary suspensions, permanent account termination, or removal from the current game by moderators or automated anti-cheat systems.\n\nBy continuing, you confirm that you understand these risks and choose to proceed at your own discretion.\n\nYou accept full responsibility for any consequences that may arise from the use of this script.\n\nThe creator (<b>JustAGuest</b>) provides no guarantees regarding safety, detection, or functionality, and assumes no responsibility for any bans, losses, or damages resulting from its use.\n\nIf you do not agree with this disclaimer, you should immediately decline and discontinue use of this script."
    Label.TextWrapped = true
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Top
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Label.RichText = true
    Label.AutomaticSize = Enum.AutomaticSize.Y

    local Options = Instance.new("Frame", MainFrame)
    Options.Name = "Options"
    Options.Size = UDim2.new(1, 0, 0, 34)
    Options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Options.BackgroundTransparency = 1
    Options.BorderSizePixel = 0
    Options.LayoutOrder = 3

    local OptionsSizeConstraint = Instance.new("UISizeConstraint", Options)
    OptionsSizeConstraint.MaxSize = Vector2.new(math.huge, 40)

    local OptionsPadding = Instance.new("UIPadding", Options)
    OptionsPadding.Name = "Padding"
    OptionsPadding.PaddingTop = UDim.new(0, 2)
    OptionsPadding.PaddingRight = UDim.new(0, 2)
    OptionsPadding.PaddingLeft = UDim.new(0, 2)
    OptionsPadding.PaddingBottom = UDim.new(0, 2)

    local OptionsLayout = Instance.new("UIListLayout", Options)
    OptionsLayout.Name = "Layout"
    OptionsLayout.FillDirection = Enum.FillDirection.Horizontal
    OptionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    OptionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    OptionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
    OptionsLayout.Padding = UDim.new(0, 6)
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Accept = Instance.new("TextButton", Options)
    Accept.Name = "Accept"
    Accept.Size = UDim2.new(0.5, -3, 1, 0)
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

    local AcceptPadding = Instance.new("UIPadding", Accept)
    AcceptPadding.Name = "Padding"
    AcceptPadding.PaddingTop = UDim.new(0, 2)
    AcceptPadding.PaddingRight = UDim.new(0, 2)
    AcceptPadding.PaddingLeft = UDim.new(0, 2)
    AcceptPadding.PaddingBottom = UDim.new(0, 2)

    local AcceptStroke = Instance.new("UIStroke", Accept)
    AcceptStroke.Name = "Stroke"
    AcceptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AcceptStroke.Thickness = 2
    AcceptStroke.Color = Color3.fromRGB(0, 86, 207)

    local AcceptCorner = Instance.new("UICorner", Accept)
    AcceptCorner.Name = "Corner"
    AcceptCorner.CornerRadius = UDim.new(0, 4)

    local Decline = Instance.new("TextButton", Options)
    Decline.Name = "Decline"
    Decline.Size = UDim2.new(0.5, -3, 1, 0)
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

    local DeclinePadding = Instance.new("UIPadding", Decline)
    DeclinePadding.Name = "Padding"
    DeclinePadding.PaddingTop = UDim.new(0, 2)
    DeclinePadding.PaddingRight = UDim.new(0, 2)
    DeclinePadding.PaddingLeft = UDim.new(0, 2)
    DeclinePadding.PaddingBottom = UDim.new(0, 2)

    local DeclineStroke = Instance.new("UIStroke", Decline)
    DeclineStroke.Name = "Stroke"
    DeclineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    DeclineStroke.Thickness = 2
    DeclineStroke.Color = Color3.fromRGB(216, 0, 0)

    local DeclineCorner = Instance.new("UICorner", Decline)
    DeclineCorner.Name = "Corner"
    DeclineCorner.CornerRadius = UDim.new(0, 4)

    local TweenService = game:GetService("TweenService")

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
