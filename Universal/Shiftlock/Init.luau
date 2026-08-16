if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G

local function GetService(Service)
    local Service = game:GetService(Service)
    return cloneref and cloneref(Service) or Service
end

local Hui = gethui and gethui() or GetService("CoreGui")
local Players, RunService, UIS, Workspace, StarterGui = GetService("Players"), GetService("RunService"), GetService("UserInputService"), GetService("Workspace"), GetService("StarterGui")

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
local GetAsset = getcustomasset or getsynasset or function() return end

local Player = Players.LocalPlayer
local ScreenSize = Workspace.CurrentCamera.ViewportSize
local Enabled = false
local Active = false
local RenderConn = nil

local function HttpGet(url)
    local Request = http_request or request or syn and syn.request
    if not Request then return nil end
    local success, result = pcall(function()
        return Request({Url = url, Method = "GET"})
    end)
    return success and result or nil
end

if not IsFile("Shiftlock.png") then
    local Response = HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Shiftlock/Assets/lock.png")
    if Response and Response.Success and Response.Body then
        WriteFile("Shiftlock.png", Response.Body)
    end
end

Shared.Shiftlock = Shared.Shiftlock or {}

if Shared.Shiftlock.IsLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "Shiftlock",
        Text = "Shiftlock is already running!",
        Icon = GetAsset("Shiftlock.png"),
        Duration = 4
    })
    return
end

Shared.Shiftlock.IsLoaded = true

local UI = {}

UI.ScreenGui = Instance.new("ScreenGui")
UI.ScreenGui.DisplayOrder = 1
UI.ScreenGui.Name = UID()
UI.ScreenGui.ResetOnSpawn = false
UI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.ScreenGui.Parent = Hui

UI.Button = Instance.new("ImageButton")
UI.Button.BackgroundTransparency = 1
UI.Button.BorderSizePixel = 0
UI.Button.Image = GetAsset("Shiftlock.png")
UI.Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
UI.Button.Name = "Shiftlock"
UI.Button.Position = UDim2.new(0, 18, 0, 2)
UI.Button.Size = UDim2.new(0, 54, 0, 54)
UI.Button.Parent = UI.ScreenGui

UI.ButtonRatio = Instance.new("UIAspectRatioConstraint")
UI.ButtonRatio.Name = "ShiftlockRatio"
UI.ButtonRatio.Parent = UI.Button

UI.ButtonCorner = Instance.new("UICorner")
UI.ButtonCorner.CornerRadius = UDim.new(1, 0)
UI.ButtonCorner.Name = "ShiftlockCorner"
UI.ButtonCorner.Parent = UI.Button

UI.Close = Instance.new("TextButton")
UI.Close.AnchorPoint = Vector2.new(0.5, 0.5)
UI.Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
UI.Close.BorderSizePixel = 0
UI.Close.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.Close.Name = "Close"
UI.Close.Position = UDim2.new(0.75, 4, 0.25, -4)
UI.Close.Size = UDim2.new(0, 20, 0, 20)
UI.Close.Text = "×"
UI.Close.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.Close.TextScaled = true
UI.Close.TextWrapped = true
UI.Close.ZIndex = 10
UI.Close.Parent = UI.Button

UI.CloseRatio = Instance.new("UIAspectRatioConstraint")
UI.CloseRatio.Name = "CloseRatio"
UI.CloseRatio.Parent = UI.Close

UI.CloseCorner = Instance.new("UICorner")
UI.CloseCorner.CornerRadius = UDim.new(1, 0)
UI.CloseCorner.Name = "CloseCorner"
UI.CloseCorner.Parent = UI.Close

local function GetHum()
    local Char = Player.Character
    if not Char then return nil end
    return Char:FindFirstChildOfClass("Humanoid")
end

local function UpdChar()
    if not Active then return end
    local Char = Player.Character
    if not Char then return end
    local RootPart = Char:FindFirstChild("HumanoidRootPart")
    local HumChar = GetHum()
    if RootPart and HumChar then
        local CameraCFrame = Workspace.CurrentCamera.CFrame
        local LookDirection = CameraCFrame.LookVector
        local FlatLook = Vector3.new(LookDirection.X, 0, LookDirection.Z).Unit
        if FlatLook.Magnitude > 0 then
            RootPart.CFrame = CFrame.new(RootPart.Position, RootPart.Position + FlatLook)
        end
        HumChar.AutoRotate = false
    end
end

local function Enable()
    if Active then return end
    Active = true
    local Hum = GetHum()
    if Hum then
        Hum.AutoRotate = false
    end
    UI.Button.ImageColor3 = Color3.fromRGB(0, 210, 255)
    if RenderConn then RenderConn:Disconnect() end
    RenderConn = RunService.RenderStepped:Connect(UpdChar)
end

local function Disable()
    Active = false
    if RenderConn then
        RenderConn:Disconnect()
        RenderConn = nil
    end
    local Hum = GetHum()
    if Hum then
        Hum.AutoRotate = true
    end
    UI.Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
end

local dragging = false
local dragInput
local dragStart
local startPos

local function Clamp(newX, newY)
    local viewport = Workspace.CurrentCamera.ViewportSize
    local size = UI.Button.AbsoluteSize
    local padding = 3
    local maxX = viewport.X - size.X - padding
    local maxY = viewport.Y - size.Y - padding
    local minX = padding
    local minY = padding
    newX = math.clamp(newX, minX, maxX)
    newY = math.clamp(newY, minY, maxY)
    return newX, newY
end

UI.Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = UI.Button.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UI.Button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y
        newX, newY = Clamp(newX, newY)
        UI.Button.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
    end
end)

Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    ScreenSize = Workspace.CurrentCamera.ViewportSize
end)

UI.Button.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    if Enabled then
        Enable()
    else
        Disable()
    end
end)

UI.Close.MouseButton1Click:Connect(function()
    Disable()
    UI.ScreenGui:Destroy()
    Shared.Shiftlock.IsLoaded = false
end)

Player.CharacterAdded:Connect(function(NewChar)
    task.wait(0.5)
    if Enabled then
        local Hum = NewChar:FindFirstChildOfClass("Humanoid")
        if Hum and Active then
            Hum.AutoRotate = false
        end
        Enable()
    end
end)

return UI