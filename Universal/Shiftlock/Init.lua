if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local WriteFile = writefile or function() end
local IsFile = isfile or function() return false end
local IsFolder = isfolder or function() return false end
local MakeFolder = makefolder or function() end
local LoadAsset = getcustomasset or getsynasset or nil

local function HttpGet(url)
    local RequestFunc = syn and syn.request or request or http_request
    if not RequestFunc then return nil end
    local success, result = pcall(function()
        return RequestFunc({ Url = url, Method = "GET" })
    end)
    return success and result or nil
end

local function GetAsset(Path)
    if not LoadAsset then return nil end
    if not IsFolder("Shiftlock") then MakeFolder("Shiftlock") end
    if not IsFolder("Shiftlock/assets") then MakeFolder("Shiftlock/assets") end
    if not IsFile(Path) then
        local Success, Response = pcall(function() return HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Shiftlock/Assets/lock.png") end)
        if Success and Response and Response.Success and Response.Body then
            WriteFile(Path, Response.Body)
        else
            return nil
        end
    end
    return LoadAsset(Path)
end

getgenv().Shiftlock = getgenv().Shiftlock or {}

if getgenv().Shiftlock.isLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "Shiftlock",
        Text = "Shiftlock is already running!",
        Duration = 4,
        Icon = GetAsset("Shiftlock/assets/lock.png")
    })
    return
end

getgenv().Shiftlock.isLoaded = true

local PlayerGui
local Success, Result = pcall(function() return gethui() end)
if Success and Result then
    PlayerGui = Result
else
    PlayerGui = CoreGui
end

local Shiftlock = Instance.new("ScreenGui")
Shiftlock.Name = "Shiftlock"
Shiftlock.DisplayOrder = 50
Shiftlock.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Shiftlock.ResetOnSpawn = false
Shiftlock.Parent = PlayerGui

local Button = Instance.new("ImageButton")
Button.Name = "Button"
Button.BorderSizePixel = 0
Button.BackgroundTransparency = 1
Button.Size = UDim2.new(0, 54, 0, 54)
Button.Position = UDim2.new(0, 18, 0, 2)
Button.Image = GetAsset("Shiftlock/assets/lock.png") or "rbxassetid://6031098370"
Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
Button.Parent = Shiftlock

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.ZIndex = 10
Close.TextWrapped = true
Close.BorderSizePixel = 0
Close.TextScaled = true
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Close.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Close.AnchorPoint = Vector2.new(0.5, 0.5)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Text = "×"
Close.Position = UDim2.new(0.75, 4, 0.25, -4)
Close.Parent = Button

local CloseRatio = Instance.new("UIAspectRatioConstraint")
CloseRatio.Name = "CloseRatio"
CloseRatio.Parent = Close

local CloseCorner = Instance.new("UICorner")
CloseCorner.Name = "CloseCorner"
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = Close

local ButtonRatio = Instance.new("UIAspectRatioConstraint")
ButtonRatio.Name = "ButtonRatio"
ButtonRatio.Parent = Button

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.Name = "ButtonCorner"
ButtonCorner.CornerRadius = UDim.new(1, 0)
ButtonCorner.Parent = Button

Close.MouseButton1Click:Connect(function()
    Shiftlock:Destroy()
    getgenv().Shiftlock.isLoaded = false
end)

local ScreenSize = Workspace.CurrentCamera.ViewportSize

local Dragging = false
local DragStart
local StartPos

Button.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPos = Button.Position
        
        local Connection
        Connection = Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                Connection:Disconnect()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - DragStart
        local NewX = StartPos.X.Offset + Delta.X
        local NewY = StartPos.Y.Offset + Delta.Y
        local MaxX = ScreenSize.X - Button.AbsoluteSize.X
        local MaxY = ScreenSize.Y - Button.AbsoluteSize.Y
        NewX = math.clamp(NewX, 0, MaxX)
        NewY = math.clamp(NewY, 0, MaxY)
        Button.Position = UDim2.new(0, NewX, 0, NewY)
    end
end)

local function UpdateScreenSize()
    ScreenSize = Workspace.CurrentCamera.ViewportSize
end

Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScreenSize)

local ShiftlockActive = false
local RenderConnection = nil
local Player = Players.LocalPlayer

local function GetHumanoid()
    local Char = Player.Character
    if not Char then return nil end
    return Char:FindFirstChildOfClass("Humanoid")
end

local function UpdateCharacter()
    if not ShiftlockActive then return end
    local Char = Player.Character
    if not Char then return end
    local RootPart = Char:FindFirstChild("HumanoidRootPart")
    local HumanoidChar = Char:FindFirstChildOfClass("Humanoid")
    if RootPart and HumanoidChar then
        local CameraCFrame = Workspace.CurrentCamera.CFrame
        local LookDirection = CameraCFrame.LookVector
        local FlatLook = Vector3.new(LookDirection.X, 0, LookDirection.Z).Unit
        if FlatLook.Magnitude > 0 then
            RootPart.CFrame = CFrame.new(RootPart.Position, RootPart.Position + FlatLook)
        end
        HumanoidChar.AutoRotate = false
    end
end

local function EnableShiftlock()
    if ShiftlockActive then return end
    ShiftlockActive = true
    
    local Humanoid = GetHumanoid()
    if Humanoid then
        Humanoid.AutoRotate = false
    end
    
    Button.ImageColor3 = Color3.fromRGB(0, 210, 255)
    
    if RenderConnection then RenderConnection:Disconnect() end
    RenderConnection = RunService.RenderStepped:Connect(UpdateCharacter)
end

local function DisableShiftlock()
    ShiftlockActive = false
    
    if RenderConnection then
        RenderConnection:Disconnect()
        RenderConnection = nil
    end
    
    local Humanoid = GetHumanoid()
    if Humanoid then
        Humanoid.AutoRotate = true
    end
    
    Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
end

local ShiftlockEnabled = false

Button.MouseButton1Click:Connect(function()
    ShiftlockEnabled = not ShiftlockEnabled
    if ShiftlockEnabled then
        EnableShiftlock()
    else
        DisableShiftlock()
    end
end)

Player.CharacterAdded:Connect(function(NewChar)
    task.wait(0.5)
    if ShiftlockEnabled then
        local Humanoid = NewChar:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            if ShiftlockActive then
                Humanoid.AutoRotate = false
            end
        end
        EnableShiftlock()
    end
end)
