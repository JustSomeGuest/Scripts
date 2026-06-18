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
local TweenSvc = Services.TweenService
local inf = math.huge

local Notification = Instance.new("ScreenGui")
Notification.AutoLocalize = false
Notification.IgnoreGuiInset = true
Notification.Name = "Notification"
Notification.ResetOnSpawn = false
Notification.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
Notification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Notification.Parent = CoreGui

local Popup = Instance.new("CanvasGroup")
Popup.AnchorPoint = Vector2.new(1, 0)
Popup.AutomaticSize = Enum.AutomaticSize.Y
Popup.BackgroundColor3 = Color3.fromRGB(25, 25, 29)
Popup.BorderSizePixel = 0
Popup.Name = "Popup"
Popup.Position = UDim2.new(1, 80, 0, 12)
Popup.Size = UDim2.new(0, 224, 0, 0)
Popup.GroupTransparency = 1
Popup.Rotation = 8
Popup.Parent = Notification

local PopupCorner = Instance.new("UICorner")
PopupCorner.CornerRadius = UDim.new(0, 6)
PopupCorner.Parent = Popup

local PopupStroke = Instance.new("UIStroke")
PopupStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
PopupStroke.Color = Color3.fromRGB(71, 71, 81)
PopupStroke.Parent = Popup

local PopupLayout = Instance.new("UIListLayout")
PopupLayout.Padding = UDim.new(0, 2)
PopupLayout.SortOrder = Enum.SortOrder.LayoutOrder
PopupLayout.Parent = Popup

local Title = Instance.new("TextLabel")
Title.AutomaticSize = Enum.AutomaticSize.Y
Title.BackgroundTransparency = 1
Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Title.LayoutOrder = 1
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 34)
Title.Text = "✨ Welcome!"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextWrapped = true
Title.Parent = Popup

local TitlePadding = Instance.new("UIPadding")
TitlePadding.PaddingTop = UDim.new(0, 6)
TitlePadding.PaddingBottom = UDim.new(0, 4)
TitlePadding.PaddingLeft = UDim.new(0, 8)
TitlePadding.PaddingRight = UDim.new(0, 8)
TitlePadding.Parent = Title

local TitleSize = Instance.new("UISizeConstraint")
TitleSize.MaxSize = Vector2.new(inf, 34)
TitleSize.MinSize = Vector2.new(0, 30)
TitleSize.Parent = Title

local TitleStroke = Instance.new("UIStroke")
TitleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TitleStroke.Color = Color3.fromRGB(71, 71, 81)
TitleStroke.Parent = Title

local Body = Instance.new("TextLabel")
Body.AutomaticSize = Enum.AutomaticSize.Y
Body.BackgroundTransparency = 1
Body.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
Body.LayoutOrder = 2
Body.Name = "Body"
Body.Size = UDim2.new(1, 0, 0, 0)
Body.Text = "Thanks for trying this out.\nMade by JustAGuest. Enjoy!"
Body.TextColor3 = Color3.fromRGB(201, 201, 201)
Body.TextSize = 19
Body.TextWrapped = true
Body.TextXAlignment = Enum.TextXAlignment.Left
Body.TextYAlignment = Enum.TextYAlignment.Top
Body.Parent = Popup

local BodyPadding = Instance.new("UIPadding")
BodyPadding.PaddingTop = UDim.new(0, 2)
BodyPadding.PaddingBottom = UDim.new(0, 6)
BodyPadding.PaddingLeft = UDim.new(0, 8)
BodyPadding.PaddingRight = UDim.new(0, 8)
BodyPadding.Parent = Body

local SlideIn = TweenSvc:Create(
    Popup,
    TweenInfo.new(0.75, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {
        Position = UDim2.new(1, -12, 0, 12),
        GroupTransparency = 0,
        Rotation = 0
    }
)

SlideIn:Play()
SlideIn.Completed:Wait()

task.wait(4)

local Lift = TweenSvc:Create(
    Popup,
    TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {
        Position = UDim2.new(1, -12, 0, 6)
    }
)

Lift:Play()
Lift.Completed:Wait()

local SlideOut = TweenSvc:Create(
    Popup,
    TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
    {
        Position = UDim2.new(1, 80, 0, -12),
        GroupTransparency = 1,
        Rotation = -8
    }
)

SlideOut:Play()
SlideOut.Completed:Wait()

Notification:Destroy()