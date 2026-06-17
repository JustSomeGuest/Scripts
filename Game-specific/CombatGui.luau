if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (pcall(getgenv) and getgenv()) or warn("[Shared]: getgenv() isn't supported by this executor.")

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

local CoreGui = Services.CoreGui
local StarterGui = Services.StarterGui

Shared.CombatGUI = Shared.CombatGUI or {}

if Shared.CombatGUI.isLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "Combat GUI+",
        Text = "Combat GUI+ is already running!",
        Duration = 4
    })
    error("Combat GUI+ is already running", 0)
end

Shared.CombatGUI.isLoaded = true

local function load(url)
    local Success, Response = pcall(game.HttpGet, game, url)
    return loadstring(Success and Response or game:HttpGet(url))()
end

load("https://raw.githubusercontent.com/Cyborg883/CombatGUI/main/TSBCombatGUI")

task.wait(0.5)

local GothamMedium = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local GothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local AutoBlockGui = CoreGui:FindFirstChild("AutoBlock", true)
if not AutoBlockGui then return end

local Text = AutoBlockGui:FindFirstChild("text", true)
if Text then Text:Destroy() end

local Text2 = AutoBlockGui:FindFirstChild("text2", true)
if Text2 then Text2:Destroy() end

local MainFrame = AutoBlockGui:FindFirstChild("MainFrame", true)
if not MainFrame then return end

local Background = MainFrame:FindFirstChild("Background", true)
if not Background then
    Background = Instance.new("Frame", MainFrame)
    Background.Name = "Background"
end

local TitleLabel = MainFrame:FindFirstChild("Title", true)
if not TitleLabel then
    TitleLabel = Instance.new("TextLabel", MainFrame)
    TitleLabel.Name = "Title"
end

local Divider = MainFrame:FindFirstChild("Filler", true)
if not Divider then
    Divider = Instance.new("Frame", MainFrame)
    Divider.Name = "Filler"
end

local OptionsMenu = MainFrame:FindFirstChild("NewFrame", true)
if not OptionsMenu then
    OptionsMenu = Instance.new("Frame", MainFrame)
    OptionsMenu.Name = "NewFrame"
end

local MiscMenu = MainFrame:FindFirstChild("NewFrame1", true)
if not MiscMenu then
    MiscMenu = Instance.new("Frame", MainFrame)
    MiscMenu.Name = "NewFrame1"
end

local SettingsMenu = MainFrame:FindFirstChild("SettingsFrame", true)
if not SettingsMenu then
    SettingsMenu = Instance.new("Frame", MainFrame)
    SettingsMenu.Name = "SettingsFrame"
end

local BlockButton = MainFrame:FindFirstChild("EnableButton", true)
if not BlockButton then
    BlockButton = Instance.new("TextButton", MainFrame)
    BlockButton.Name = "EnableButton"
end

local CounterButton = MainFrame:FindFirstChild("EnableButton2", true)
if not CounterButton then
    CounterButton = Instance.new("TextButton", MainFrame)
    CounterButton.Name = "EnableButton2"
end

local CameraButton = MainFrame:FindFirstChild("EnableButton3", true)
if not CameraButton then
    CameraButton = Instance.new("TextButton", MainFrame)
    CameraButton.Name = "EnableButton3"
end

local OptionsButton = MainFrame:FindFirstChild("NewButton", true)
if not OptionsButton then
    OptionsButton = Instance.new("ImageButton", MainFrame)
    OptionsButton.Name = "NewButton"
end

local MiscButton = MainFrame:FindFirstChild("NewButton1", true)
if not MiscButton then
    MiscButton = Instance.new("ImageButton", MainFrame)
    MiscButton.Name = "NewButton1"
end

local SettingsButton = MainFrame:FindFirstChild("SettingsButton", true)
if not SettingsButton then
    SettingsButton = Instance.new("ImageButton", MainFrame)
    SettingsButton.Name = "SettingsButton"
end

MainFrame.BorderSizePixel = 0
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 150)
MainFrame.Position = UDim2.new(0, 14, 0, 2)
MainFrame.BackgroundTransparency = 0.5

local MainStroke = MainFrame:FindFirstChild("UIStroke", true)
if not MainStroke then
    MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Transparency = 0.33
    MainStroke.Thickness = 2
else
    MainStroke.Transparency = 0.33
    MainStroke.Thickness = 2
end

local MainCorner = MainFrame:FindFirstChild("UICorner", true)
if not MainCorner then
    MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 4)
end

MainCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if MainCorner.CornerRadius ~= UDim.new(0, 4) then
        MainCorner.CornerRadius = UDim.new(0, 4)
    end
end)
MainCorner.CornerRadius = UDim.new(0, 4)

Background.ZIndex = 0
Background.BorderSizePixel = 0
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.Size = UDim2.new(0, 276, 0, 110)
Background.Position = UDim2.new(0, 2, 0, 38)
Background.BackgroundTransparency = 0.5

local BackgroundCorner = Background:FindFirstChild("UICorner", true)
if not BackgroundCorner then
    BackgroundCorner = Instance.new("UICorner", Background)
    BackgroundCorner.CornerRadius = UDim.new(0, 4)
end

BackgroundCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if BackgroundCorner.CornerRadius ~= UDim.new(0, 4) then
        BackgroundCorner.CornerRadius = UDim.new(0, 4)
    end
end)
BackgroundCorner.CornerRadius = UDim.new(0, 4)

Divider.BorderSizePixel = 0
Divider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Divider.Size = UDim2.new(0, 276, 0, 2)
Divider.Position = UDim2.new(0, 2, 0, 33)
Divider.LayoutOrder = 2
Divider.BackgroundTransparency = 0.5

local DividerCorner = Divider:FindFirstChild("UICorner", true)
if not DividerCorner then
    DividerCorner = Instance.new("UICorner", Divider)
    DividerCorner.CornerRadius = UDim.new(0, 4)
end

DividerCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if DividerCorner.CornerRadius ~= UDim.new(0, 4) then
        DividerCorner.CornerRadius = UDim.new(0, 4)
    end
end)
DividerCorner.CornerRadius = UDim.new(0, 4)

local FramePos = UDim2.new(0, 286, 0, 0)

OptionsMenu.BorderSizePixel = 0
OptionsMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OptionsMenu.Size = UDim2.new(0, 280, 0, 150)
OptionsMenu.Position = FramePos
OptionsMenu.BackgroundTransparency = 0.5
OptionsMenu.Visible = false

local OptionsStroke = OptionsMenu:FindFirstChild("UIStroke", true)
if not OptionsStroke then
    OptionsStroke = Instance.new("UIStroke", OptionsMenu)
    OptionsStroke.Transparency = 0.33
    OptionsStroke.Thickness = 2
end

local OptionsCorner = OptionsMenu:FindFirstChild("UICorner", true)
if not OptionsCorner then
    OptionsCorner = Instance.new("UICorner", OptionsMenu)
    OptionsCorner.CornerRadius = UDim.new(0, 4)
end

OptionsCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if OptionsCorner.CornerRadius ~= UDim.new(0, 4) then
        OptionsCorner.CornerRadius = UDim.new(0, 4)
    end
end)
OptionsCorner.CornerRadius = UDim.new(0, 4)

MiscMenu.BorderSizePixel = 0
MiscMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiscMenu.Size = UDim2.new(0, 280, 0, 150)
MiscMenu.Position = FramePos
MiscMenu.BackgroundTransparency = 0.5
MiscMenu.Visible = false

local MiscStroke = MiscMenu:FindFirstChild("UIStroke", true)
if not MiscStroke then
    MiscStroke = Instance.new("UIStroke", MiscMenu)
    MiscStroke.Transparency = 0.33
    MiscStroke.Thickness = 2
end

local MiscCorner = MiscMenu:FindFirstChild("UICorner", true)
if not MiscCorner then
    MiscCorner = Instance.new("UICorner", MiscMenu)
    MiscCorner.CornerRadius = UDim.new(0, 4)
end

MiscCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if MiscCorner.CornerRadius ~= UDim.new(0, 4) then
        MiscCorner.CornerRadius = UDim.new(0, 4)
    end
end)
MiscCorner.CornerRadius = UDim.new(0, 4)

SettingsMenu.BorderSizePixel = 0
SettingsMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SettingsMenu.Size = UDim2.new(0, 280, 0, 150)
SettingsMenu.Position = FramePos
SettingsMenu.BackgroundTransparency = 0.5
SettingsMenu.Visible = false

local SettingsStroke = SettingsMenu:FindFirstChild("UIStroke", true)
if not SettingsStroke then
    SettingsStroke = Instance.new("UIStroke", SettingsMenu)
    SettingsStroke.Transparency = 0.33
    SettingsStroke.Thickness = 2
end

local SettingsCorner = SettingsMenu:FindFirstChild("UICorner", true)
if not SettingsCorner then
    SettingsCorner = Instance.new("UICorner", SettingsMenu)
    SettingsCorner.CornerRadius = UDim.new(0, 4)
end

SettingsCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if SettingsCorner.CornerRadius ~= UDim.new(0, 4) then
        SettingsCorner.CornerRadius = UDim.new(0, 4)
    end
end)
SettingsCorner.CornerRadius = UDim.new(0, 4)

for _, Frame in ipairs({OptionsMenu, MiscMenu, SettingsMenu}) do
    for _, Child in ipairs(Frame:GetDescendants()) do
        if Child:IsA("Frame") or Child:IsA("TextButton") or Child:IsA("ImageButton") or Child:IsA("TextLabel") then
            local Corner = Child:FindFirstChild("UICorner", true)
            if not Corner then
                Corner = Instance.new("UICorner", Child)
                Corner.CornerRadius = UDim.new(0, 4)
            else
                Corner.CornerRadius = UDim.new(0, 4)
            end
            Corner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
                if Corner.CornerRadius ~= UDim.new(0, 4) then
                    Corner.CornerRadius = UDim.new(0, 4)
                end
            end)
        end
    end
end

TitleLabel.TextWrapped = true
TitleLabel.BorderSizePixel = 0
TitleLabel.TextScaled = true
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.FontFace = GothamMedium
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(0, 180, 0, 28)
TitleLabel.Text = "TSB | Combat GUI+"
TitleLabel.Position = UDim2.new(0, 2, 0, 2)

local TitlePadding = TitleLabel:FindFirstChild("UIPadding", true)
if not TitlePadding then
    TitlePadding = Instance.new("UIPadding", TitleLabel)
    TitlePadding.PaddingTop = UDim.new(0, 2)
    TitlePadding.PaddingRight = UDim.new(0, 2)
    TitlePadding.PaddingLeft = UDim.new(0, 2)
    TitlePadding.PaddingBottom = UDim.new(0, 2)
end

local TitleStroke = TitleLabel:FindFirstChild("UIStroke", true)
if not TitleStroke then
    TitleStroke = Instance.new("UIStroke", TitleLabel)
    TitleStroke.Transparency = 0.66
    TitleStroke.Thickness = 2
end

local TitleCorner = TitleLabel:FindFirstChild("UICorner", true)
if not TitleCorner then
    TitleCorner = Instance.new("UICorner", TitleLabel)
    TitleCorner.CornerRadius = UDim.new(0, 4)
end

TitleCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if TitleCorner.CornerRadius ~= UDim.new(0, 4) then
        TitleCorner.CornerRadius = UDim.new(0, 4)
    end
end)
TitleCorner.CornerRadius = UDim.new(0, 4)

local OpenCloseButton = TitleLabel:FindFirstChild("OpenCloseButton", true)
if OpenCloseButton then
    OpenCloseButton:Destroy()
end

local MinimizeButton = TitleLabel:FindFirstChild("MinimizeButton", true)
if not MinimizeButton then
    MinimizeButton = Instance.new("TextButton", TitleLabel)
    MinimizeButton.Name = "MinimizeButton"
end
MinimizeButton.TextWrapped = true
MinimizeButton.BorderSizePixel = 0
MinimizeButton.TextScaled = true
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinimizeButton.FontFace = GothamMedium
MinimizeButton.BackgroundTransparency = 0.5
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Text = "-"
MinimizeButton.Position = UDim2.new(0, 216, 0, -2)

local MinimizeCorner = MinimizeButton:FindFirstChild("UICorner", true)
if not MinimizeCorner then
    MinimizeCorner = Instance.new("UICorner", MinimizeButton)
    MinimizeCorner.CornerRadius = UDim.new(0, 4)
end

MinimizeCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if MinimizeCorner.CornerRadius ~= UDim.new(0, 4) then
        MinimizeCorner.CornerRadius = UDim.new(0, 4)
    end
end)
MinimizeCorner.CornerRadius = UDim.new(0, 4)

local MinimizeAspect = MinimizeButton:FindFirstChild("UIAspectRatioConstraint", true)
if not MinimizeAspect then
    MinimizeAspect = Instance.new("UIAspectRatioConstraint", MinimizeButton)
end

local CloseButton = TitleLabel:FindFirstChild("CloseButton", true)
if not CloseButton then
    CloseButton = Instance.new("TextButton", TitleLabel)
    CloseButton.Name = "CloseButton"
end
CloseButton.TextWrapped = true
CloseButton.BorderSizePixel = 0
CloseButton.TextScaled = true
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.FontFace = GothamMedium
CloseButton.BackgroundTransparency = 0.5
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Text = "×"
CloseButton.Position = UDim2.new(0, 246, 0, -2)

local CloseCorner = CloseButton:FindFirstChild("UICorner", true)
if not CloseCorner then
    CloseCorner = Instance.new("UICorner", CloseButton)
    CloseCorner.CornerRadius = UDim.new(0, 4)
end

CloseCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if CloseCorner.CornerRadius ~= UDim.new(0, 4) then
        CloseCorner.CornerRadius = UDim.new(0, 4)
    end
end)
CloseCorner.CornerRadius = UDim.new(0, 4)

local CloseAspect = CloseButton:FindFirstChild("UIAspectRatioConstraint", true)
if not CloseAspect then
    CloseAspect = Instance.new("UIAspectRatioConstraint", CloseButton)
end

CloseButton.MouseButton1Click:Connect(function()
    AutoBlockGui:Destroy()
    Shared.CombatGUI.isLoaded = false
end)

BlockButton.Text = ""
BlockButton.BackgroundTransparency = 1
BlockButton.Size = UDim2.new(0, 230, 0, 28)
BlockButton.Position = UDim2.new(0, 8, 0, 44)

local BlockLabel = BlockButton:FindFirstChild("Label", true)
if not BlockLabel then
    BlockLabel = Instance.new("TextLabel", BlockButton)
    BlockLabel.Name = "Label"
end
BlockLabel.TextWrapped = true
BlockLabel.TextScaled = true
BlockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BlockLabel.BackgroundTransparency = 1
BlockLabel.Size = UDim2.new(1, 0, 1, 0)
BlockLabel.Text = "AutoBlock: Off"

local BlockPadding = BlockLabel:FindFirstChild("UIPadding", true)
if not BlockPadding then
    BlockPadding = Instance.new("UIPadding", BlockLabel)
    BlockPadding.PaddingTop = UDim.new(0, 4)
    BlockPadding.PaddingRight = UDim.new(0, 5)
    BlockPadding.PaddingLeft = UDim.new(0, 5)
    BlockPadding.PaddingBottom = UDim.new(0, 4)
end

local BlockCorner = BlockButton:FindFirstChild("UICorner", true)
if not BlockCorner then
    BlockCorner = Instance.new("UICorner", BlockButton)
    BlockCorner.CornerRadius = UDim.new(0, 4)
else
    BlockCorner.CornerRadius = UDim.new(0, 4)
end

BlockCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if BlockCorner.CornerRadius ~= UDim.new(0, 4) then
        BlockCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local BlockStroke = BlockButton:FindFirstChild("UIStroke", true)
if not BlockStroke then
    BlockStroke = Instance.new("UIStroke", BlockButton)
    BlockStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BlockStroke.Color = Color3.fromRGB(255, 255, 255)
end

CounterButton.Text = ""
CounterButton.BackgroundTransparency = 1
CounterButton.Size = UDim2.new(0, 230, 0, 28)
CounterButton.Position = UDim2.new(0, 8, 0, 78)

local CounterLabel = CounterButton:FindFirstChild("Label", true)
if not CounterLabel then
    CounterLabel = Instance.new("TextLabel", CounterButton)
    CounterLabel.Name = "Label"
end
CounterLabel.TextWrapped = true
CounterLabel.TextScaled = true
CounterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CounterLabel.BackgroundTransparency = 1
CounterLabel.Size = UDim2.new(1, 0, 1, 0)
CounterLabel.Text = "Counter-Notifier: Off"

local CounterPadding = CounterLabel:FindFirstChild("UIPadding", true)
if not CounterPadding then
    CounterPadding = Instance.new("UIPadding", CounterLabel)
    CounterPadding.PaddingTop = UDim.new(0, 4)
    CounterPadding.PaddingRight = UDim.new(0, 5)
    CounterPadding.PaddingLeft = UDim.new(0, 5)
    CounterPadding.PaddingBottom = UDim.new(0, 4)
end

local CounterCorner = CounterButton:FindFirstChild("UICorner", true)
if not CounterCorner then
    CounterCorner = Instance.new("UICorner", CounterButton)
    CounterCorner.CornerRadius = UDim.new(0, 4)
else
    CounterCorner.CornerRadius = UDim.new(0, 4)
end

CounterCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if CounterCorner.CornerRadius ~= UDim.new(0, 4) then
        CounterCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local CounterStroke = CounterButton:FindFirstChild("UIStroke", true)
if not CounterStroke then
    CounterStroke = Instance.new("UIStroke", CounterButton)
    CounterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    CounterStroke.Color = Color3.fromRGB(255, 255, 255)
end

CameraButton.Text = ""
CameraButton.BackgroundTransparency = 1
CameraButton.Size = UDim2.new(0, 230, 0, 28)
CameraButton.Position = UDim2.new(0, 8, 0, 112)

local CameraLabel = CameraButton:FindFirstChild("Label", true)
if not CameraLabel then
    CameraLabel = Instance.new("TextLabel", CameraButton)
    CameraLabel.Name = "Label"
end
CameraLabel.TextWrapped = true
CameraLabel.TextScaled = true
CameraLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CameraLabel.BackgroundTransparency = 1
CameraLabel.Size = UDim2.new(1, 0, 1, 0)
CameraLabel.Text = "CamLock: Off"

local CameraPadding = CameraLabel:FindFirstChild("UIPadding", true)
if not CameraPadding then
    CameraPadding = Instance.new("UIPadding", CameraLabel)
    CameraPadding.PaddingTop = UDim.new(0, 4)
    CameraPadding.PaddingRight = UDim.new(0, 5)
    CameraPadding.PaddingLeft = UDim.new(0, 5)
    CameraPadding.PaddingBottom = UDim.new(0, 4)
end

local CameraCorner = CameraButton:FindFirstChild("UICorner", true)
if not CameraCorner then
    CameraCorner = Instance.new("UICorner", CameraButton)
    CameraCorner.CornerRadius = UDim.new(0, 4)
end

CameraCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if CameraCorner.CornerRadius ~= UDim.new(0, 4) then
        CameraCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local CameraStroke = CameraButton:FindFirstChild("UIStroke", true)
if not CameraStroke then
    CameraStroke = Instance.new("UIStroke", CameraButton)
    CameraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    CameraStroke.Color = Color3.fromRGB(255, 255, 255)
end

local function ProtectButton(Button)
    Button:GetPropertyChangedSignal("Text"):Connect(function()
        if Button.Text ~= "" then
            Button.Text = ""
        end
    end)
end

ProtectButton(BlockButton)
ProtectButton(CounterButton)
ProtectButton(CameraButton)

OptionsButton.BorderSizePixel = 0
OptionsButton.BackgroundTransparency = 1
OptionsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OptionsButton.Image = "rbxassetid://91728161555751"
OptionsButton.Size = UDim2.new(0, 28, 0, 28)
OptionsButton.Position = UDim2.new(0, 244, 0, 78)

local OptionsButtonCorner = OptionsButton:FindFirstChild("UICorner", true)
if not OptionsButtonCorner then
    OptionsButtonCorner = Instance.new("UICorner", OptionsButton)
    OptionsButtonCorner.CornerRadius = UDim.new(0, 4)
end

OptionsButtonCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if OptionsButtonCorner.CornerRadius ~= UDim.new(0, 4) then
        OptionsButtonCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local OptionsButtonAspect = OptionsButton:FindFirstChild("UIAspectRatioConstraint", true)
if not OptionsButtonAspect then
    OptionsButtonAspect = Instance.new("UIAspectRatioConstraint", OptionsButton)
end

local OptionsButtonStroke = OptionsButton:FindFirstChild("UIStroke", true)
if not OptionsButtonStroke then
    OptionsButtonStroke = Instance.new("UIStroke", OptionsButton)
    OptionsButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    OptionsButtonStroke.Color = Color3.fromRGB(255, 255, 255)
end

MiscButton.BorderSizePixel = 0
MiscButton.BackgroundTransparency = 1
MiscButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MiscButton.Image = "rbxassetid://12072054746"
MiscButton.Size = UDim2.new(0, 28, 0, 28)
MiscButton.Position = UDim2.new(0, 244, 0, 44)

local MiscButtonCorner = MiscButton:FindFirstChild("UICorner", true)
if not MiscButtonCorner then
    MiscButtonCorner = Instance.new("UICorner", MiscButton)
    MiscButtonCorner.CornerRadius = UDim.new(0, 4)
end

MiscButtonCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if MiscButtonCorner.CornerRadius ~= UDim.new(0, 4) then
        MiscButtonCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local MiscButtonAspect = MiscButton:FindFirstChild("UIAspectRatioConstraint", true)
if not MiscButtonAspect then
    MiscButtonAspect = Instance.new("UIAspectRatioConstraint", MiscButton)
end

local MiscButtonStroke = MiscButton:FindFirstChild("UIStroke", true)
if not MiscButtonStroke then
    MiscButtonStroke = Instance.new("UIStroke", MiscButton)
    MiscButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MiscButtonStroke.Color = Color3.fromRGB(255, 255, 255)
end

SettingsButton.BorderSizePixel = 0
SettingsButton.BackgroundTransparency = 1
SettingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SettingsButton.Image = "rbxassetid://7059346373"
SettingsButton.Size = UDim2.new(0, 28, 0, 28)
SettingsButton.Position = UDim2.new(0, 244, 0, 112)

local SettingsButtonCorner = SettingsButton:FindFirstChild("UICorner", true)
if not SettingsButtonCorner then
    SettingsButtonCorner = Instance.new("UICorner", SettingsButton)
    SettingsButtonCorner.CornerRadius = UDim.new(0, 4)
end

SettingsButtonCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if SettingsButtonCorner.CornerRadius ~= UDim.new(0, 4) then
        SettingsButtonCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local SettingsButtonAspect = SettingsButton:FindFirstChild("UIAspectRatioConstraint", true)
if not SettingsButtonAspect then
    SettingsButtonAspect = Instance.new("UIAspectRatioConstraint", SettingsButton)
end

local SettingsButtonStroke = SettingsButton:FindFirstChild("UIStroke", true)
if not SettingsButtonStroke then
    SettingsButtonStroke = Instance.new("UIStroke", SettingsButton)
    SettingsButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SettingsButtonStroke.Color = Color3.fromRGB(255, 255, 255)
end

local Minimized = false
local TweenService = Services.TweenService

local function ToggleMinimize()
    Minimized = not Minimized
    local Size = Minimized and UDim2.new(0, 280, 0, 32) or UDim2.new(0, 280, 0, 150)
    local Tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Size})
    Tween:Play()
    for _, Child in ipairs(MainFrame:GetChildren()) do
        if Child ~= TitleLabel and Child ~= Divider and Child ~= MainStroke and Child ~= MainCorner and Child ~= Background and Child ~= OptionsMenu and Child ~= MiscMenu and Child ~= SettingsMenu then
            Child.Visible = not Minimized
        end
    end
    Background.Visible = not Minimized
    Divider.Visible = not Minimized
    OptionsMenu.Visible = false
    MiscMenu.Visible = false
    SettingsMenu.Visible = false
    MinimizeButton.Text = Minimized and "+" or "-"
end

MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)

local BlockOn = false
local CounterOn = false
local CameraOn = false
local CameraConnection = nil
local RunService = Services.RunService
local Camera = workspace.CurrentCamera

local function GetNearestTarget()
    local Players = Services.Players
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    if not Character then return nil end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return nil end
    
    local Nearest = nil
    local ShortestDistance = math.huge
    local PlayerList = Players:GetPlayers()
    
    for _, Player in ipairs(PlayerList) do
        if Player ~= LocalPlayer then
            local TargetCharacter = Player.Character
            if TargetCharacter then
                local TargetRoot = TargetCharacter:FindFirstChild("HumanoidRootPart")
                if TargetRoot then
                    local Distance = (HumanoidRootPart.Position - TargetRoot.Position).Magnitude
                    if Distance < ShortestDistance then
                        ShortestDistance = Distance
                        Nearest = TargetRoot
                    end
                end
            end
        end
    end
    return Nearest
end

local function StartCameraLock()
    if CameraConnection then CameraConnection:Disconnect() end
    CameraConnection = RunService.RenderStepped:Connect(function()
        if not CameraOn then return end
        local Target = GetNearestTarget()
        if Target then
            local LookPosition = Target.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, LookPosition)
        end
    end)
end

local function StopCameraLock()
    if CameraConnection then
        CameraConnection:Disconnect()
        CameraConnection = nil
    end
end

BlockButton.MouseButton1Click:Connect(function()
    BlockOn = not BlockOn
    if BlockButton:FindFirstChild("Label", true) then
        BlockButton.Label.Text = BlockOn and "AutoBlock: On" or "AutoBlock: Off"
    end
end)

CounterButton.MouseButton1Click:Connect(function()
    CounterOn = not CounterOn
    if CounterButton:FindFirstChild("Label", true) then
        CounterButton.Label.Text = CounterOn and "Counter-Notifier: On" or "Counter-Notifier: Off"
    end
end)

CameraButton.MouseButton1Click:Connect(function()
    CameraOn = not CameraOn
    if CameraButton:FindFirstChild("Label", true) then
        CameraButton.Label.Text = CameraOn and "CamLock: On" or "CamLock: Off"
    end
    if CameraOn then
        StartCameraLock()
    else
        StopCameraLock()
    end
end)