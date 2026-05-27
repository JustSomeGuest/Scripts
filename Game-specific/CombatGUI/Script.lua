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
local autoBlockGui = CoreGui:FindFirstChild("AutoBlock", true)
if not autoBlockGui then return end

local txt = autoBlockGui:FindFirstChild("text", true)
if txt then txt:Destroy() end

local txt2 = autoBlockGui:FindFirstChild("text2", true)
if txt2 then txt2:Destroy() end

local main = autoBlockGui:FindFirstChild("MainFrame", true)
if not main then return end

local bg = main:FindFirstChild("Background", true)
if not bg then
    bg = Instance.new("Frame", main)
    bg.Name = "Background"
end

local titleLbl = main:FindFirstChild("Title", true)
if not titleLbl then
    titleLbl = Instance.new("TextLabel", main)
    titleLbl.Name = "Title"
end

local divider = main:FindFirstChild("Filler", true)
if not divider then
    divider = Instance.new("Frame", main)
    divider.Name = "Filler"
end

local optsMenu = main:FindFirstChild("NewFrame", true)
if not optsMenu then
    optsMenu = Instance.new("Frame", main)
    optsMenu.Name = "NewFrame"
end

local miscMenu = main:FindFirstChild("NewFrame1", true)
if not miscMenu then
    miscMenu = Instance.new("Frame", main)
    miscMenu.Name = "NewFrame1"
end

local settingsMenu = main:FindFirstChild("SettingsFrame", true)
if not settingsMenu then
    settingsMenu = Instance.new("Frame", main)
    settingsMenu.Name = "SettingsFrame"
end

local blockBtn = main:FindFirstChild("EnableButton", true)
if not blockBtn then
    blockBtn = Instance.new("TextButton", main)
    blockBtn.Name = "EnableButton"
end

local counterBtn = main:FindFirstChild("EnableButton2", true)
if not counterBtn then
    counterBtn = Instance.new("TextButton", main)
    counterBtn.Name = "EnableButton2"
end

local camBtn = main:FindFirstChild("EnableButton3", true)
if not camBtn then
    camBtn = Instance.new("TextButton", main)
    camBtn.Name = "EnableButton3"
end

local optsBtn = main:FindFirstChild("NewButton", true)
if not optsBtn then
    optsBtn = Instance.new("ImageButton", main)
    optsBtn.Name = "NewButton"
end

local miscBtn = main:FindFirstChild("NewButton1", true)
if not miscBtn then
    miscBtn = Instance.new("ImageButton", main)
    miscBtn.Name = "NewButton1"
end

local settingsBtn = main:FindFirstChild("SettingsButton", true)
if not settingsBtn then
    settingsBtn = Instance.new("ImageButton", main)
    settingsBtn.Name = "SettingsButton"
end

main.BorderSizePixel = 0
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.Size = UDim2.new(0, 280, 0, 150)
main.Position = UDim2.new(0, 14, 0, 2)
main.BackgroundTransparency = 0.5

local mainStroke = main:FindFirstChild("UIStroke", true)
if not mainStroke then
    mainStroke = Instance.new("UIStroke", main)
    mainStroke.Transparency = 0.33
    mainStroke.Thickness = 2
else
    mainStroke.Transparency = 0.33
    mainStroke.Thickness = 2
end

local mainCorner = main:FindFirstChild("UICorner", true)
if not mainCorner then
    mainCorner = Instance.new("UICorner", main)
    mainCorner.CornerRadius = UDim.new(0, 4)
end

mainCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if mainCorner.CornerRadius ~= UDim.new(0, 4) then
        mainCorner.CornerRadius = UDim.new(0, 4)
    end
end)
mainCorner.CornerRadius = UDim.new(0, 4)

bg.ZIndex = 0
bg.BorderSizePixel = 0
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.Size = UDim2.new(0, 276, 0, 110)
bg.Position = UDim2.new(0, 2, 0, 38)
bg.BackgroundTransparency = 0.5

local bgCorner = bg:FindFirstChild("UICorner", true)
if not bgCorner then
    bgCorner = Instance.new("UICorner", bg)
    bgCorner.CornerRadius = UDim.new(0, 4)
end

bgCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if bgCorner.CornerRadius ~= UDim.new(0, 4) then
        bgCorner.CornerRadius = UDim.new(0, 4)
    end
end)
bgCorner.CornerRadius = UDim.new(0, 4)

divider.BorderSizePixel = 0
divider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
divider.Size = UDim2.new(0, 276, 0, 2)
divider.Position = UDim2.new(0, 2, 0, 33)
divider.LayoutOrder = 2
divider.BackgroundTransparency = 0.5

local divCorner = divider:FindFirstChild("UICorner", true)
if not divCorner then
    divCorner = Instance.new("UICorner", divider)
    divCorner.CornerRadius = UDim.new(0, 4)
end

divCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if divCorner.CornerRadius ~= UDim.new(0, 4) then
        divCorner.CornerRadius = UDim.new(0, 4)
    end
end)
divCorner.CornerRadius = UDim.new(0, 4)

local framePos = UDim2.new(0, 286, 0, 0)

optsMenu.BorderSizePixel = 0
optsMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
optsMenu.Size = UDim2.new(0, 280, 0, 150)
optsMenu.Position = framePos
optsMenu.BackgroundTransparency = 0.5
optsMenu.Visible = false

local optsStroke = optsMenu:FindFirstChild("UIStroke", true)
if not optsStroke then
    optsStroke = Instance.new("UIStroke", optsMenu)
    optsStroke.Transparency = 0.33
    optsStroke.Thickness = 2
end

local optsCorner = optsMenu:FindFirstChild("UICorner", true)
if not optsCorner then
    optsCorner = Instance.new("UICorner", optsMenu)
    optsCorner.CornerRadius = UDim.new(0, 4)
end

optsCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if optsCorner.CornerRadius ~= UDim.new(0, 4) then
        optsCorner.CornerRadius = UDim.new(0, 4)
    end
end)
optsCorner.CornerRadius = UDim.new(0, 4)

miscMenu.BorderSizePixel = 0
miscMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
miscMenu.Size = UDim2.new(0, 280, 0, 150)
miscMenu.Position = framePos
miscMenu.BackgroundTransparency = 0.5
miscMenu.Visible = false

local miscStroke = miscMenu:FindFirstChild("UIStroke", true)
if not miscStroke then
    miscStroke = Instance.new("UIStroke", miscMenu)
    miscStroke.Transparency = 0.33
    miscStroke.Thickness = 2
end

local miscCorner = miscMenu:FindFirstChild("UICorner", true)
if not miscCorner then
    miscCorner = Instance.new("UICorner", miscMenu)
    miscCorner.CornerRadius = UDim.new(0, 4)
end

miscCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if miscCorner.CornerRadius ~= UDim.new(0, 4) then
        miscCorner.CornerRadius = UDim.new(0, 4)
    end
end)
miscCorner.CornerRadius = UDim.new(0, 4)

settingsMenu.BorderSizePixel = 0
settingsMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
settingsMenu.Size = UDim2.new(0, 280, 0, 150)
settingsMenu.Position = framePos
settingsMenu.BackgroundTransparency = 0.5
settingsMenu.Visible = false

local settingsStroke = settingsMenu:FindFirstChild("UIStroke", true)
if not settingsStroke then
    settingsStroke = Instance.new("UIStroke", settingsMenu)
    settingsStroke.Transparency = 0.33
    settingsStroke.Thickness = 2
end

local settingsCorner = settingsMenu:FindFirstChild("UICorner", true)
if not settingsCorner then
    settingsCorner = Instance.new("UICorner", settingsMenu)
    settingsCorner.CornerRadius = UDim.new(0, 4)
end

settingsCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if settingsCorner.CornerRadius ~= UDim.new(0, 4) then
        settingsCorner.CornerRadius = UDim.new(0, 4)
    end
end)
settingsCorner.CornerRadius = UDim.new(0, 4)

for _, frm in ipairs({optsMenu, miscMenu, settingsMenu}) do
    for _, child in ipairs(frm:GetDescendants()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("ImageButton") or child:IsA("TextLabel") then
            local crn = child:FindFirstChild("UICorner", true)
            if not crn then
                crn = Instance.new("UICorner", child)
                crn.CornerRadius = UDim.new(0, 4)
            else
                crn.CornerRadius = UDim.new(0, 4)
            end
            crn:GetPropertyChangedSignal("CornerRadius"):Connect(function()
                if crn.CornerRadius ~= UDim.new(0, 4) then
                    crn.CornerRadius = UDim.new(0, 4)
                end
            end)
        end
    end
end

titleLbl.TextWrapped = true
titleLbl.BorderSizePixel = 0
titleLbl.TextScaled = true
titleLbl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.FontFace = gothamMed
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.BackgroundTransparency = 1
titleLbl.Size = UDim2.new(0, 180, 0, 28)
titleLbl.Text = "TSB | Combat GUI+"
titleLbl.Position = UDim2.new(0, 2, 0, 2)

local titlePad = titleLbl:FindFirstChild("UIPadding", true)
if not titlePad then
    titlePad = Instance.new("UIPadding", titleLbl)
    titlePad.PaddingTop = UDim.new(0, 2)
    titlePad.PaddingRight = UDim.new(0, 2)
    titlePad.PaddingLeft = UDim.new(0, 2)
    titlePad.PaddingBottom = UDim.new(0, 2)
end

local titleStroke = titleLbl:FindFirstChild("UIStroke", true)
if not titleStroke then
    titleStroke = Instance.new("UIStroke", titleLbl)
    titleStroke.Transparency = 0.66
    titleStroke.Thickness = 2
end

local titleCorner = titleLbl:FindFirstChild("UICorner", true)
if not titleCorner then
    titleCorner = Instance.new("UICorner", titleLbl)
    titleCorner.CornerRadius = UDim.new(0, 4)
end

titleCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if titleCorner.CornerRadius ~= UDim.new(0, 4) then
        titleCorner.CornerRadius = UDim.new(0, 4)
    end
end)
titleCorner.CornerRadius = UDim.new(0, 4)

local openCloseBtn = titleLbl:FindFirstChild("OpenCloseButton", true)
if openCloseBtn then
    openCloseBtn:Destroy()
end

local minBtn = titleLbl:FindFirstChild("MinimizeButton", true)
if not minBtn then
    minBtn = Instance.new("TextButton", titleLbl)
    minBtn.Name = "MinimizeButton"
end
minBtn.TextWrapped = true
minBtn.BorderSizePixel = 0
minBtn.TextScaled = true
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
minBtn.FontFace = gothamMed
minBtn.BackgroundTransparency = 0.5
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Text = "-"
minBtn.Position = UDim2.new(0, 216, 0, -2)

local minCorner = minBtn:FindFirstChild("UICorner", true)
if not minCorner then
    minCorner = Instance.new("UICorner", minBtn)
    minCorner.CornerRadius = UDim.new(0, 4)
end

minCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if minCorner.CornerRadius ~= UDim.new(0, 4) then
        minCorner.CornerRadius = UDim.new(0, 4)
    end
end)
minCorner.CornerRadius = UDim.new(0, 4)

local minAspect = minBtn:FindFirstChild("UIAspectRatioConstraint", true)
if not minAspect then
    minAspect = Instance.new("UIAspectRatioConstraint", minBtn)
end

local closeBtn = titleLbl:FindFirstChild("CloseButton", true)
if not closeBtn then
    closeBtn = Instance.new("TextButton", titleLbl)
    closeBtn.Name = "CloseButton"
end
closeBtn.TextWrapped = true
closeBtn.BorderSizePixel = 0
closeBtn.TextScaled = true
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.FontFace = gothamMed
closeBtn.BackgroundTransparency = 0.5
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Text = "×"
closeBtn.Position = UDim2.new(0, 246, 0, -2)

local closeCorner = closeBtn:FindFirstChild("UICorner", true)
if not closeCorner then
    closeCorner = Instance.new("UICorner", closeBtn)
    closeCorner.CornerRadius = UDim.new(0, 4)
end

closeCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if closeCorner.CornerRadius ~= UDim.new(0, 4) then
        closeCorner.CornerRadius = UDim.new(0, 4)
    end
end)
closeCorner.CornerRadius = UDim.new(0, 4)

local closeAspect = closeBtn:FindFirstChild("UIAspectRatioConstraint", true)
if not closeAspect then
    closeAspect = Instance.new("UIAspectRatioConstraint", closeBtn)
end

closeBtn.MouseButton1Click:Connect(function()
    autoBlockGui:Destroy()
    getgenv().CombatGUI.isLoaded = false
end)

blockBtn.Text = ""
blockBtn.BackgroundTransparency = 1
blockBtn.Size = UDim2.new(0, 230, 0, 28)
blockBtn.Position = UDim2.new(0, 8, 0, 44)

local blockLbl = blockBtn:FindFirstChild("Label", true)
if not blockLbl then
    blockLbl = Instance.new("TextLabel", blockBtn)
    blockLbl.Name = "Label"
end
blockLbl.TextWrapped = true
blockLbl.TextScaled = true
blockLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
blockLbl.BackgroundTransparency = 1
blockLbl.Size = UDim2.new(1, 0, 1, 0)
blockLbl.Text = "AutoBlock: Off"

local blockPad = blockLbl:FindFirstChild("UIPadding", true)
if not blockPad then
    blockPad = Instance.new("UIPadding", blockLbl)
    blockPad.PaddingTop = UDim.new(0, 4)
    blockPad.PaddingRight = UDim.new(0, 5)
    blockPad.PaddingLeft = UDim.new(0, 5)
    blockPad.PaddingBottom = UDim.new(0, 4)
end

local blockCorner = blockBtn:FindFirstChild("UICorner", true)
if not blockCorner then
    blockCorner = Instance.new("UICorner", blockBtn)
    blockCorner.CornerRadius = UDim.new(0, 4)
else
    blockCorner.CornerRadius = UDim.new(0, 4)
end

blockCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if blockCorner.CornerRadius ~= UDim.new(0, 4) then
        blockCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local blockStroke = blockBtn:FindFirstChild("UIStroke", true)
if not blockStroke then
    blockStroke = Instance.new("UIStroke", blockBtn)
    blockStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    blockStroke.Color = Color3.fromRGB(255, 255, 255)
end

counterBtn.Text = ""
counterBtn.BackgroundTransparency = 1
counterBtn.Size = UDim2.new(0, 230, 0, 28)
counterBtn.Position = UDim2.new(0, 8, 0, 78)

local counterLbl = counterBtn:FindFirstChild("Label", true)
if not counterLbl then
    counterLbl = Instance.new("TextLabel", counterBtn)
    counterLbl.Name = "Label"
end
counterLbl.TextWrapped = true
counterLbl.TextScaled = true
counterLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
counterLbl.BackgroundTransparency = 1
counterLbl.Size = UDim2.new(1, 0, 1, 0)
counterLbl.Text = "Counter-Notifier: Off"

local counterPad = counterLbl:FindFirstChild("UIPadding", true)
if not counterPad then
    counterPad = Instance.new("UIPadding", counterLbl)
    counterPad.PaddingTop = UDim.new(0, 4)
    counterPad.PaddingRight = UDim.new(0, 5)
    counterPad.PaddingLeft = UDim.new(0, 5)
    counterPad.PaddingBottom = UDim.new(0, 4)
end

local counterCorner = counterBtn:FindFirstChild("UICorner", true)
if not counterCorner then
    counterCorner = Instance.new("UICorner", counterBtn)
    counterCorner.CornerRadius = UDim.new(0, 4)
else
    counterCorner.CornerRadius = UDim.new(0, 4)
end

counterCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if counterCorner.CornerRadius ~= UDim.new(0, 4) then
        counterCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local counterStroke = counterBtn:FindFirstChild("UIStroke", true)
if not counterStroke then
    counterStroke = Instance.new("UIStroke", counterBtn)
    counterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    counterStroke.Color = Color3.fromRGB(255, 255, 255)
end

camBtn.Text = ""
camBtn.BackgroundTransparency = 1
camBtn.Size = UDim2.new(0, 230, 0, 28)
camBtn.Position = UDim2.new(0, 8, 0, 112)

local camLbl = camBtn:FindFirstChild("Label", true)
if not camLbl then
    camLbl = Instance.new("TextLabel", camBtn)
    camLbl.Name = "Label"
end
camLbl.TextWrapped = true
camLbl.TextScaled = true
camLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
camLbl.BackgroundTransparency = 1
camLbl.Size = UDim2.new(1, 0, 1, 0)
camLbl.Text = "CamLock: Off"

local camPad = camLbl:FindFirstChild("UIPadding", true)
if not camPad then
    camPad = Instance.new("UIPadding", camLbl)
    camPad.PaddingTop = UDim.new(0, 4)
    camPad.PaddingRight = UDim.new(0, 5)
    camPad.PaddingLeft = UDim.new(0, 5)
    camPad.PaddingBottom = UDim.new(0, 4)
end

local camCorner = camBtn:FindFirstChild("UICorner", true)
if not camCorner then
    camCorner = Instance.new("UICorner", camBtn)
    camCorner.CornerRadius = UDim.new(0, 4)
end

camCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if camCorner.CornerRadius ~= UDim.new(0, 4) then
        camCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local camStroke = camBtn:FindFirstChild("UIStroke", true)
if not camStroke then
    camStroke = Instance.new("UIStroke", camBtn)
    camStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    camStroke.Color = Color3.fromRGB(255, 255, 255)
end

local function protectBtn(btn)
    btn:GetPropertyChangedSignal("Text"):Connect(function()
        if btn.Text ~= "" then
            btn.Text = ""
        end
    end)
end

protectBtn(blockBtn)
protectBtn(counterBtn)
protectBtn(camBtn)

optsBtn.BorderSizePixel = 0
optsBtn.BackgroundTransparency = 1
optsBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
optsBtn.Image = "rbxassetid://91728161555751"
optsBtn.Size = UDim2.new(0, 28, 0, 28)
optsBtn.Position = UDim2.new(0, 244, 0, 78)

local optsBtnCorner = optsBtn:FindFirstChild("UICorner", true)
if not optsBtnCorner then
    optsBtnCorner = Instance.new("UICorner", optsBtn)
    optsBtnCorner.CornerRadius = UDim.new(0, 4)
end

optsBtnCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if optsBtnCorner.CornerRadius ~= UDim.new(0, 4) then
        optsBtnCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local optsBtnAspect = optsBtn:FindFirstChild("UIAspectRatioConstraint", true)
if not optsBtnAspect then
    optsBtnAspect = Instance.new("UIAspectRatioConstraint", optsBtn)
end

local optsBtnStroke = optsBtn:FindFirstChild("UIStroke", true)
if not optsBtnStroke then
    optsBtnStroke = Instance.new("UIStroke", optsBtn)
    optsBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    optsBtnStroke.Color = Color3.fromRGB(255, 255, 255)
end

miscBtn.BorderSizePixel = 0
miscBtn.BackgroundTransparency = 1
miscBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
miscBtn.Image = "rbxassetid://12072054746"
miscBtn.Size = UDim2.new(0, 28, 0, 28)
miscBtn.Position = UDim2.new(0, 244, 0, 44)

local miscBtnCorner = miscBtn:FindFirstChild("UICorner", true)
if not miscBtnCorner then
    miscBtnCorner = Instance.new("UICorner", miscBtn)
    miscBtnCorner.CornerRadius = UDim.new(0, 4)
end

miscBtnCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if miscBtnCorner.CornerRadius ~= UDim.new(0, 4) then
        miscBtnCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local miscBtnAspect = miscBtn:FindFirstChild("UIAspectRatioConstraint", true)
if not miscBtnAspect then
    miscBtnAspect = Instance.new("UIAspectRatioConstraint", miscBtn)
end

local miscBtnStroke = miscBtn:FindFirstChild("UIStroke", true)
if not miscBtnStroke then
    miscBtnStroke = Instance.new("UIStroke", miscBtn)
    miscBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    miscBtnStroke.Color = Color3.fromRGB(255, 255, 255)
end

settingsBtn.BorderSizePixel = 0
settingsBtn.BackgroundTransparency = 1
settingsBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
settingsBtn.Image = "rbxassetid://7059346373"
settingsBtn.Size = UDim2.new(0, 28, 0, 28)
settingsBtn.Position = UDim2.new(0, 244, 0, 112)

local settingsBtnCorner = settingsBtn:FindFirstChild("UICorner", true)
if not settingsBtnCorner then
    settingsBtnCorner = Instance.new("UICorner", settingsBtn)
    settingsBtnCorner.CornerRadius = UDim.new(0, 4)
end

settingsBtnCorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    if settingsBtnCorner.CornerRadius ~= UDim.new(0, 4) then
        settingsBtnCorner.CornerRadius = UDim.new(0, 4)
    end
end)

local settingsBtnAspect = settingsBtn:FindFirstChild("UIAspectRatioConstraint", true)
if not settingsBtnAspect then
    settingsBtnAspect = Instance.new("UIAspectRatioConstraint", settingsBtn)
end

local settingsBtnStroke = settingsBtn:FindFirstChild("UIStroke", true)
if not settingsBtnStroke then
    settingsBtnStroke = Instance.new("UIStroke", settingsBtn)
    settingsBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    settingsBtnStroke.Color = Color3.fromRGB(255, 255, 255)
end

local minimized = false
local ts = game:GetService("TweenService")

local function toggleMin()
    minimized = not minimized
    local sz = minimized and UDim2.new(0, 280, 0, 32) or UDim2.new(0, 280, 0, 150)
    local tween = ts:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = sz})
    tween:Play()
    for _, child in ipairs(main:GetChildren()) do
        if child ~= titleLbl and child ~= divider and child ~= mainStroke and child ~= mainCorner and child ~= bg and child ~= optsMenu and child ~= miscMenu and child ~= settingsMenu then
            child.Visible = not minimized
        end
    end
    bg.Visible = not minimized
    divider.Visible = not minimized
    optsMenu.Visible = false
    miscMenu.Visible = false
    settingsMenu.Visible = false
    minBtn.Text = minimized and "+" or "-"
end

minBtn.MouseButton1Click:Connect(toggleMin)

local blockOn = false
local counterOn = false
local camOn = false
local camConn = nil
local rs = game:GetService("RunService")
local cam = workspace.CurrentCamera

local function getNearest()
    local lp = game:GetService("Players").LocalPlayer
    local chr = lp.Character
    if not chr then return nil end
    local root = chr:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local nearest = nil
    local shortest = math.huge
    local plrs = game:GetService("Players"):GetPlayers()
    
    for _, plr in ipairs(plrs) do
        if plr ~= lp then
            local tgt = plr.Character
            if tgt then
                local tgtRoot = tgt:FindFirstChild("HumanoidRootPart")
                if tgtRoot then
                    local dist = (root.Position - tgtRoot.Position).Magnitude
                    if dist < shortest then
                        shortest = dist
                        nearest = tgtRoot
                    end
                end
            end
        end
    end
    return nearest
end

local function startCam()
    if camConn then camConn:Disconnect() end
    camConn = rs.RenderStepped:Connect(function()
        if not camOn then return end
        local tgt = getNearest()
        if tgt then
            local lookPos = tgt.Position
            cam.CFrame = CFrame.new(cam.CFrame.Position, lookPos)
        end
    end)
end

local function stopCam()
    if camConn then
        camConn:Disconnect()
        camConn = nil
    end
end

blockBtn.MouseButton1Click:Connect(function()
    blockOn = not blockOn
    if blockBtn:FindFirstChild("Label", true) then
        blockBtn.Label.Text = blockOn and "AutoBlock: On" or "AutoBlock: Off"
    end
end)

counterBtn.MouseButton1Click:Connect(function()
    counterOn = not counterOn
    if counterBtn:FindFirstChild("Label", true) then
        counterBtn.Label.Text = counterOn and "Counter-Notifier: On" or "Counter-Notifier: Off"
    end
end)

camBtn.MouseButton1Click:Connect(function()
    camOn = not camOn
    if camBtn:FindFirstChild("Label", true) then
        camBtn.Label.Text = camOn and "CamLock: On" or "CamLock: Off"
    end
    if camOn then
        startCam()
    else
        stopCam()
    end
end)
