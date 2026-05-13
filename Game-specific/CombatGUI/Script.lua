getgenv().CombatGUI = getgenv().CombatGUI or {}

if getgenv().CombatGUI.isLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Combat GUI+",
        Text = "Combat GUI+ is already running!",
        Duration = 4
    })
    error("Combat GUI+ is already running", 0)
end

getgenv().CombatGUI.isLoaded = true

loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/CombatGUI/main/TSBCombatGUI"))()

task.wait(0.5)

local gothamMed = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local gothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local CoreGui = game:GetService("CoreGui")
local AutoBlockGui = CoreGui:FindFirstChild("AutoBlock", true)
if not AutoBlockGui then return end

local text = AutoBlockGui:FindFirstChild("text", true)
if text then text:Destroy() end

local text2 = AutoBlockGui:FindFirstChild("text2", true)
if text2 then text2:Destroy() end

local MainFrame = AutoBlockGui:FindFirstChild("MainFrame", true)
if not MainFrame then return end

local ContentBackground = MainFrame:FindFirstChild("Background", true)
if not ContentBackground then
    ContentBackground = Instance.new("Frame", MainFrame)
    ContentBackground.Name = "Background"
end

local TitleLabel = MainFrame:FindFirstChild("Title", true)
if not TitleLabel then
    TitleLabel = Instance.new("TextLabel", MainFrame)
    TitleLabel.Name = "Title"
end

local TopDivider = MainFrame:FindFirstChild("Filler", true)
if not TopDivider then
    TopDivider = Instance.new("Frame", MainFrame)
    TopDivider.Name = "Filler"
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

local AutoBlockBtn = MainFrame:FindFirstChild("EnableButton", true)
if not AutoBlockBtn then
    AutoBlockBtn = Instance.new("TextButton", MainFrame)
    AutoBlockBtn.Name = "EnableButton"
end

local CounterBtn = MainFrame:FindFirstChild("EnableButton2", true)
if not CounterBtn then
    CounterBtn = Instance.new("TextButton", MainFrame)
    CounterBtn.Name = "EnableButton2"
end

local CamLockBtn = MainFrame:FindFirstChild("EnableButton3", true)
if not CamLockBtn then
    CamLockBtn = Instance.new("TextButton", MainFrame)
    CamLockBtn.Name = "EnableButton3"
end

local OptionsBtn = MainFrame:FindFirstChild("NewButton", true)
if not OptionsBtn then
    OptionsBtn = Instance.new("ImageButton", MainFrame)
    OptionsBtn.Name = "NewButton"
end

local MiscBtn = MainFrame:FindFirstChild("NewButton1", true)
if not MiscBtn then
    MiscBtn = Instance.new("ImageButton", MainFrame)
    MiscBtn.Name = "NewButton1"
end

local SettingsBtn = MainFrame:FindFirstChild("SettingsButton", true)
if not SettingsBtn then
    SettingsBtn = Instance.new("ImageButton", MainFrame)
    SettingsBtn.Name = "SettingsButton"
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

ContentBackground.ZIndex = 0
ContentBackground.BorderSizePixel = 0
ContentBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ContentBackground.Size = UDim2.new(0, 276, 0, 110)
ContentBackground.Position = UDim2.new(0, 2, 0, 38)
ContentBackground.BackgroundTransparency = 0.5

local ContentCorner = ContentBackground:FindFirstChild("UICorner", true)
if not ContentCorner then
    ContentCorner = Instance.new("UICorner", ContentBackground)
    ContentCorner.CornerRadius = UDim.new(0, 4)
end

ContentCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if ContentCorner.CornerRadius ~= UDim.new(0, 4) then
        ContentCorner.CornerRadius = UDim.new(0, 4)
    end
end)
ContentCorner.CornerRadius = UDim.new(0, 4)

TopDivider.BorderSizePixel = 0
TopDivider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopDivider.Size = UDim2.new(0, 276, 0, 2)
TopDivider.Position = UDim2.new(0, 2, 0, 33)
TopDivider.LayoutOrder = 2
TopDivider.BackgroundTransparency = 0.5

local TopDividerCorner = TopDivider:FindFirstChild("UICorner", true)
if not TopDividerCorner then
    TopDividerCorner = Instance.new("UICorner", TopDivider)
    TopDividerCorner.CornerRadius = UDim.new(0, 4)
end

TopDividerCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if TopDividerCorner.CornerRadius ~= UDim.new(0, 4) then
        TopDividerCorner.CornerRadius = UDim.new(0, 4)
    end
end)
TopDividerCorner.CornerRadius = UDim.new(0, 4)

local framePosition = UDim2.new(0,286,0,0)

OptionsMenu.BorderSizePixel = 0
OptionsMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OptionsMenu.Size = UDim2.new(0, 280, 0, 150)
OptionsMenu.Position = framePosition
OptionsMenu.BackgroundTransparency = 0.5
OptionsMenu.Visible = false

local OptionsMenuStroke = OptionsMenu:FindFirstChild("UIStroke", true)
if not OptionsMenuStroke then
    OptionsMenuStroke = Instance.new("UIStroke", OptionsMenu)
    OptionsMenuStroke.Transparency = 0.33
    OptionsMenuStroke.Thickness = 2
end

local OptionsMenuCorner = OptionsMenu:FindFirstChild("UICorner", true)
if not OptionsMenuCorner then
    OptionsMenuCorner = Instance.new("UICorner", OptionsMenu)
    OptionsMenuCorner.CornerRadius = UDim.new(0, 4)
end

OptionsMenuCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if OptionsMenuCorner.CornerRadius ~= UDim.new(0, 4) then
        OptionsMenuCorner.CornerRadius = UDim.new(0, 4)
    end
end)
OptionsMenuCorner.CornerRadius = UDim.new(0, 4)

MiscMenu.BorderSizePixel = 0
MiscMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiscMenu.Size = UDim2.new(0, 280, 0, 150)
MiscMenu.Position = framePosition
MiscMenu.BackgroundTransparency = 0.5
MiscMenu.Visible = false

local MiscMenuStroke = MiscMenu:FindFirstChild("UIStroke", true)
if not MiscMenuStroke then
    MiscMenuStroke = Instance.new("UIStroke", MiscMenu)
    MiscMenuStroke.Transparency = 0.33
    MiscMenuStroke.Thickness = 2
end

local MiscMenuCorner = MiscMenu:FindFirstChild("UICorner", true)
if not MiscMenuCorner then
    MiscMenuCorner = Instance.new("UICorner", MiscMenu)
    MiscMenuCorner.CornerRadius = UDim.new(0, 4)
end

MiscMenuCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if MiscMenuCorner.CornerRadius ~= UDim.new(0, 4) then
        MiscMenuCorner.CornerRadius = UDim.new(0, 4)
    end
end)
MiscMenuCorner.CornerRadius = UDim.new(0, 4)

SettingsMenu.BorderSizePixel = 0
SettingsMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SettingsMenu.Size = UDim2.new(0, 280, 0, 150)
SettingsMenu.Position = framePosition
SettingsMenu.BackgroundTransparency = 0.5
SettingsMenu.Visible = false

local SettingsMenuStroke = SettingsMenu:FindFirstChild("UIStroke", true)
if not SettingsMenuStroke then
    SettingsMenuStroke = Instance.new("UIStroke", SettingsMenu)
    SettingsMenuStroke.Transparency = 0.33
    SettingsMenuStroke.Thickness = 2
end

local SettingsMenuCorner = SettingsMenu:FindFirstChild("UICorner", true)
if not SettingsMenuCorner then
    SettingsMenuCorner = Instance.new("UICorner", SettingsMenu)
    SettingsMenuCorner.CornerRadius = UDim.new(0, 4)
end

SettingsMenuCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if SettingsMenuCorner.CornerRadius ~= UDim.new(0, 4) then
        SettingsMenuCorner.CornerRadius = UDim.new(0, 4)
    end
end)
SettingsMenuCorner.CornerRadius = UDim.new(0, 4)

for _, frame in ipairs({OptionsMenu, MiscMenu, SettingsMenu}) do
    for _, child in ipairs(frame:GetDescendants()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("ImageButton") or child:IsA("TextLabel") then
            local corner = child:FindFirstChild("UICorner", true)
            if not corner then
                corner = Instance.new("UICorner", child)
                corner.CornerRadius = UDim.new(0, 4)
            else
                corner.CornerRadius = UDim.new(0, 4)
            end
            corner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
                if corner.CornerRadius ~= UDim.new(0, 4) then
                    corner.CornerRadius = UDim.new(0, 4)
                end
            end)
        end
    end
end

TitleLabel.TextWrapped = true
TitleLabel.BorderSizePixel = 0
TitleLabel.TextScaled = true
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.FontFace = gothamMed
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

local MinimizeBtn = TitleLabel:FindFirstChild("MinimizeButton", true)
if not MinimizeBtn then
    MinimizeBtn = Instance.new("TextButton", TitleLabel)
    MinimizeBtn.Name = "MinimizeButton"
end
MinimizeBtn.TextWrapped = true
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.TextScaled = true
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.FontFace = gothamMed
MinimizeBtn.BackgroundTransparency = 0.5
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Text = "-"
MinimizeBtn.Position = UDim2.new(0, 216, 0, -2)

local MinimizeCorner = MinimizeBtn:FindFirstChild("UICorner", true)
if not MinimizeCorner then
    MinimizeCorner = Instance.new("UICorner", MinimizeBtn)
    MinimizeCorner.CornerRadius = UDim.new(0, 4)
end

MinimizeCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if MinimizeCorner.CornerRadius ~= UDim.new(0, 4) then
        MinimizeCorner.CornerRadius = UDim.new(0, 4)
    end
end)
MinimizeCorner.CornerRadius = UDim.new(0, 4)

local MinimizeAspect = MinimizeBtn:FindFirstChild("UIAspectRatioConstraint", true)
if not MinimizeAspect then
    MinimizeAspect = Instance.new("UIAspectRatioConstraint", MinimizeBtn)
end

local CloseBtn = TitleLabel:FindFirstChild("CloseButton", true)
if not CloseBtn then
    CloseBtn = Instance.new("TextButton", TitleLabel)
    CloseBtn.Name = "CloseButton"
end
CloseBtn.TextWrapped = true
CloseBtn.BorderSizePixel = 0
CloseBtn.TextScaled = true
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CloseBtn.FontFace = gothamMed
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Text = "×"
CloseBtn.Position = UDim2.new(0, 246, 0, -2)

local CloseCorner = CloseBtn:FindFirstChild("UICorner", true)
if not CloseCorner then
    CloseCorner = Instance.new("UICorner", CloseBtn)
    CloseCorner.CornerRadius = UDim.new(0, 4)
end

CloseCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if CloseCorner.CornerRadius ~= UDim.new(0, 4) then
        CloseCorner.CornerRadius = UDim.new(0, 4)
    end
end)
CloseCorner.CornerRadius = UDim.new(0, 4)

local CloseAspect = CloseBtn:FindFirstChild("UIAspectRatioConstraint", true)
if not CloseAspect then
    CloseAspect = Instance.new("UIAspectRatioConstraint", CloseBtn)
end

CloseBtn.MouseButton1Click:Connect(function()
    AutoBlockGui:Destroy()
    getgenv().CombatGUI.isLoaded = false
end)

AutoBlockBtn.Text = ""
AutoBlockBtn.BackgroundTransparency = 1
AutoBlockBtn.Size = UDim2.new(0, 230, 0, 28)
AutoBlockBtn.Position = UDim2.new(0, 8, 0, 44)

local AutoBlockLabel = AutoBlockBtn:FindFirstChild("Label", true)
if not AutoBlockLabel then
    AutoBlockLabel = Instance.new("TextLabel", AutoBlockBtn)
    AutoBlockLabel.Name = "Label"
end
AutoBlockLabel.TextWrapped = true
AutoBlockLabel.TextScaled = true
AutoBlockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBlockLabel.BackgroundTransparency = 1
AutoBlockLabel.Size = UDim2.new(1, 0, 1, 0)
AutoBlockLabel.Text = "AutoBlock: Off"

local AutoBlockPadding = AutoBlockLabel:FindFirstChild("UIPadding", true)
if not AutoBlockPadding then
    AutoBlockPadding = Instance.new("UIPadding", AutoBlockLabel)
    AutoBlockPadding.PaddingTop = UDim.new(0, 4)
    AutoBlockPadding.PaddingRight = UDim.new(0, 5)
    AutoBlockPadding.PaddingLeft = UDim.new(0, 5)
    AutoBlockPadding.PaddingBottom = UDim.new(0, 4)
end

local AutoBlockCorner = AutoBlockBtn:FindFirstChild("UICorner", true)
if not AutoBlockCorner then
    AutoBlockCorner = Instance.new("UICorner", AutoBlockBtn)
    AutoBlockCorner.CornerRadius = UDim.new(0, 4)
else
    AutoBlockCorner.CornerRadius = UDim.new(0, 4)
end

AutoBlockCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if AutoBlockCorner.CornerRadius ~= UDim.new(0, 4) then
        AutoBlockCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local AutoBlockStroke = AutoBlockBtn:FindFirstChild("UIStroke", true)
if not AutoBlockStroke then
    AutoBlockStroke = Instance.new("UIStroke", AutoBlockBtn)
    AutoBlockStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AutoBlockStroke.Color = Color3.fromRGB(255, 255, 255)
end

CounterBtn.Text = ""
CounterBtn.BackgroundTransparency = 1
CounterBtn.Size = UDim2.new(0, 230, 0, 28)
CounterBtn.Position = UDim2.new(0, 8, 0, 78)

local CounterLabel = CounterBtn:FindFirstChild("Label", true)
if not CounterLabel then
    CounterLabel = Instance.new("TextLabel", CounterBtn)
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

local CounterCorner = CounterBtn:FindFirstChild("UICorner", true)
if not CounterCorner then
    CounterCorner = Instance.new("UICorner", CounterBtn)
    CounterCorner.CornerRadius = UDim.new(0, 4)
else
    CounterCorner.CornerRadius = UDim.new(0, 4)
end

CounterCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if CounterCorner.CornerRadius ~= UDim.new(0, 4) then
        CounterCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local CounterStroke = CounterBtn:FindFirstChild("UIStroke", true)
if not CounterStroke then
    CounterStroke = Instance.new("UIStroke", CounterBtn)
    CounterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    CounterStroke.Color = Color3.fromRGB(255, 255, 255)
end

CamLockBtn.Text = ""
CamLockBtn.BackgroundTransparency = 1
CamLockBtn.Size = UDim2.new(0, 230, 0, 28)
CamLockBtn.Position = UDim2.new(0, 8, 0, 112)

local CamLockLabel = CamLockBtn:FindFirstChild("Label", true)
if not CamLockLabel then
    CamLockLabel = Instance.new("TextLabel", CamLockBtn)
    CamLockLabel.Name = "Label"
end
CamLockLabel.TextWrapped = true
CamLockLabel.TextScaled = true
CamLockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CamLockLabel.BackgroundTransparency = 1
CamLockLabel.Size = UDim2.new(1, 0, 1, 0)
CamLockLabel.Text = "CamLock: Off"

local CamLockPadding = CamLockLabel:FindFirstChild("UIPadding", true)
if not CamLockPadding then
    CamLockPadding = Instance.new("UIPadding", CamLockLabel)
    CamLockPadding.PaddingTop = UDim.new(0, 4)
    CamLockPadding.PaddingRight = UDim.new(0, 5)
    CamLockPadding.PaddingLeft = UDim.new(0, 5)
    CamLockPadding.PaddingBottom = UDim.new(0, 4)
end

local CamLockCorner = CamLockBtn:FindFirstChild("UICorner", true)
if not CamLockCorner then
    CamLockCorner = Instance.new("UICorner", CamLockBtn)
    CamLockCorner.CornerRadius = UDim.new(0, 4)
end

CamLockCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if CamLockCorner.CornerRadius ~= UDim.new(0, 4) then
        CamLockCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local CamLockStroke = CamLockBtn:FindFirstChild("UIStroke", true)
if not CamLockStroke then
    CamLockStroke = Instance.new("UIStroke", CamLockBtn)
    CamLockStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    CamLockStroke.Color = Color3.fromRGB(255, 255, 255)
end

local function protectButton(button)
    button:GetPropertyChangedSignal("Text"):Connect(function()
        if button.Text ~= "" then
            button.Text = ""
        end
    end)
end

protectButton(AutoBlockBtn)
protectButton(CounterBtn)
protectButton(CamLockBtn)

OptionsBtn.BorderSizePixel = 0
OptionsBtn.BackgroundTransparency = 1
OptionsBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OptionsBtn.Image = "rbxassetid://91728161555751"
OptionsBtn.Size = UDim2.new(0, 28, 0, 28)
OptionsBtn.Position = UDim2.new(0, 244, 0, 78)

local OptionsBtnCorner = OptionsBtn:FindFirstChild("UICorner", true)
if not OptionsBtnCorner then
    OptionsBtnCorner = Instance.new("UICorner", OptionsBtn)
    OptionsBtnCorner.CornerRadius = UDim.new(0, 4)
end

OptionsBtnCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if OptionsBtnCorner.CornerRadius ~= UDim.new(0, 4) then
        OptionsBtnCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local OptionsBtnAspect = OptionsBtn:FindFirstChild("UIAspectRatioConstraint", true)
if not OptionsBtnAspect then
    OptionsBtnAspect = Instance.new("UIAspectRatioConstraint", OptionsBtn)
end

local OptionsBtnStroke = OptionsBtn:FindFirstChild("UIStroke", true)
if not OptionsBtnStroke then
    OptionsBtnStroke = Instance.new("UIStroke", OptionsBtn)
    OptionsBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    OptionsBtnStroke.Color = Color3.fromRGB(255, 255, 255)
end

MiscBtn.BorderSizePixel = 0
MiscBtn.BackgroundTransparency = 1
MiscBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MiscBtn.Image = "rbxassetid://12072054746"
MiscBtn.Size = UDim2.new(0, 28, 0, 28)
MiscBtn.Position = UDim2.new(0, 244, 0, 44)

local MiscBtnCorner = MiscBtn:FindFirstChild("UICorner", true)
if not MiscBtnCorner then
    MiscBtnCorner = Instance.new("UICorner", MiscBtn)
    MiscBtnCorner.CornerRadius = UDim.new(0, 4)
end

MiscBtnCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if MiscBtnCorner.CornerRadius ~= UDim.new(0, 4) then
        MiscBtnCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local MiscBtnAspect = MiscBtn:FindFirstChild("UIAspectRatioConstraint", true)
if not MiscBtnAspect then
    MiscBtnAspect = Instance.new("UIAspectRatioConstraint", MiscBtn)
end

local MiscBtnStroke = MiscBtn:FindFirstChild("UIStroke", true)
if not MiscBtnStroke then
    MiscBtnStroke = Instance.new("UIStroke", MiscBtn)
    MiscBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MiscBtnStroke.Color = Color3.fromRGB(255, 255, 255)
end

SettingsBtn.BorderSizePixel = 0
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SettingsBtn.Image = "rbxassetid://7059346373"
SettingsBtn.Size = UDim2.new(0, 28, 0, 28)
SettingsBtn.Position = UDim2.new(0, 244, 0, 112)

local SettingsBtnCorner = SettingsBtn:FindFirstChild("UICorner", true)
if not SettingsBtnCorner then
    SettingsBtnCorner = Instance.new("UICorner", SettingsBtn)
    SettingsBtnCorner.CornerRadius = UDim.new(0, 4)
end

SettingsBtnCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if SettingsBtnCorner.CornerRadius ~= UDim.new(0, 4) then
        SettingsBtnCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local SettingsBtnAspect = SettingsBtn:FindFirstChild("UIAspectRatioConstraint", true)
if not SettingsBtnAspect then
    SettingsBtnAspect = Instance.new("UIAspectRatioConstraint", SettingsBtn)
end

local SettingsBtnStroke = SettingsBtn:FindFirstChild("UIStroke", true)
if not SettingsBtnStroke then
    SettingsBtnStroke = Instance.new("UIStroke", SettingsBtn)
    SettingsBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SettingsBtnStroke.Color = Color3.fromRGB(255, 255, 255)
end

local isMinimized = false
local ts = game:GetService("TweenService")

local function toggleMinimize()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 280, 0, 32) or UDim2.new(0, 280, 0, 150)
    local tween = ts:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize})
    tween:Play()
    for _, child in ipairs(MainFrame:GetChildren()) do
        if child ~= TitleLabel and child ~= TopDivider and child ~= MainStroke and child ~= MainCorner and child ~= ContentBackground and child ~= OptionsMenu and child ~= MiscMenu and child ~= SettingsMenu then
            child.Visible = not isMinimized
        end
    end
    ContentBackground.Visible = not isMinimized
    TopDivider.Visible = not isMinimized
    OptionsMenu.Visible = false
    MiscMenu.Visible = false
    SettingsMenu.Visible = false
    MinimizeBtn.Text = isMinimized and "+" or "-"
end

MinimizeBtn.MouseButton1Click:Connect(toggleMinimize)

local autoBlockEnabled = false
local counterEnabled = false
local camEnabled = false
local camConn = nil
local rs = game:GetService("RunService")
local cam = workspace.CurrentCamera

local function GetNearestPlr()
    local lp = game:GetService("Players").LocalPlayer
    local char = lp.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart", true)
    if not root then return nil end
    
    local nearest = nil
    local shortest = math.huge
    local plrs = game:GetService("Players"):GetPlayers()
    
    for _, plr in ipairs(plrs) do
        if plr ~= lp then
            local targetChar = plr.Character
            if targetChar then
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart", true)
                if targetRoot then
                    local dist = (root.Position - targetRoot.Position).Magnitude
                    if dist < shortest then
                        shortest = dist
                        nearest = targetRoot
                    end
                end
            end
        end
    end
    return nearest
end

local function StartCam()
    if camConn then camConn:Disconnect() end
    camConn = rs.RenderStepped:Connect(function()
        if not camEnabled then return end
        local target = GetNearestPlr()
        if target then
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
        end
    end)
end

local function StopCam()
    if camConn then
        camConn:Disconnect()
        camConn = nil
    end
end

AutoBlockBtn.MouseButton1Click:Connect(function()
    autoBlockEnabled = not autoBlockEnabled
    if AutoBlockBtn:FindFirstChild("Label", true) then
        AutoBlockBtn.Label.Text = autoBlockEnabled and "AutoBlock: On" or "AutoBlock: Off"
    end
end)

CounterBtn.MouseButton1Click:Connect(function()
    counterEnabled = not counterEnabled
    if CounterBtn:FindFirstChild("Label", true) then
        CounterBtn.Label.Text = counterEnabled and "Counter-Notifier: On" or "Counter-Notifier: Off"
    end
end)

CamLockBtn.MouseButton1Click:Connect(function()
    camEnabled = not camEnabled
    if CamLockBtn:FindFirstChild("Label", true) then
        CamLockBtn.Label.Text = camEnabled and "CamLock: On" or "CamLock: Off"
    end
    if camEnabled then
        StartCam()
    else
        StopCam()
    end
end)
