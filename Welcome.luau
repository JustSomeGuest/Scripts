if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Shared = (function() local Success, Env = pcall(getgenv); return (Success and Env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {}) end)()

local function expect(expected, value, fallback)
    if type(value) == expected then
        return value
    end
    if fallback \~= nil then
        if type(fallback) == "function" then
            return function(...) warn("[Expect]: Missing executor functionality. Using fallback function.") return fallback(...) end
        end
        warn("[Expect]: Value has unexpected type. Using fallback value.")
    end
    return fallback
end

local cloneref = expect("function", cloneref, function(...) return ... end)
local inf = expect("number", math.huge, 1e9)

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
local TweenSvc = Services.TweenService

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
Popup.Position = UDim2.new(1, 300, 0, 12)
Popup.Size = UDim2.new(0, 224, 0, 0)
Popup.GroupTransparency = 1
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
Title.Size = UDim2.new(1, 0, 0, 0)
Title.Text = "✨ Welcome!"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextWrapped = true
Title.Parent = Popup

local TitlePadding = Instance.new("UIPadding")
TitlePadding.PaddingBottom = UDim.new(0, 4)
TitlePadding.PaddingLeft = UDim.new(0, 4)
TitlePadding.PaddingRight = UDim.new(0, 4)
TitlePadding.PaddingTop = UDim.new(0, 4)
TitlePadding.Parent = Title

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
BodyPadding.PaddingBottom = UDim.new(0, 4)
BodyPadding.PaddingLeft = UDim.new(0, 4)
BodyPadding.PaddingRight = UDim.new(0, 4)
BodyPadding.PaddingTop = UDim.new(0, 2)
BodyPadding.Parent = Body

local TweenInfoIn  = TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TweenInfoOut = TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

local targetPosition = UDim2.new(1, -12, 0, 12)

local slideIn = TweenSvc:Create(Popup, TweenInfoIn, {
    Position = targetPosition,
    GroupTransparency = 0
})

slideIn:Play()

task.delay(4, function()
    local slideOut = TweenSvc:Create(Popup, TweenInfoOut, {
        Position = UDim2.new(1, 300, 0, 12),
        GroupTransparency = 1
    })
    
    slideOut:Play()
    slideOut.Completed:Wait()
    Notification:Destroy()
end)