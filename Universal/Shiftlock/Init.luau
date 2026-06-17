if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (function() local Success, Env = pcall(getgenv); return (Success and Env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {}) end)()

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

local cloneref = expect("function", cloneref, function() return end)

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

local WriteFile = expect("function", writefile, function() return end)
local IsFile = expect("function", isfile, function() return end)
local IsFolder = expect("function", isfolder, function() return end)
local MakeFolder = expect("function", makefolder, function() return end)
local LoadAsset = expect("function", getcustomasset, expect("function", getsynasset, nil))

local Players = Services.Players
local RunService = Services.RunService
local UserInputService = Services.UserInputService
local Workspace = Services.Workspace
local Success, Hui = pcall(function() return gethui and gethui() end)
local CoreGui = Success and Hui or Services.CoreGui

local Player = Players.LocalPlayer
local ScreenSize = Workspace.CurrentCamera.ViewportSize
local ShiftlockEnabled = false
local ShiftlockActive = false
local RenderConnection = nil

local Assets = {
    ["Shiftlock/Assets/lock.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Shiftlock/Assets/lock.png",
}

local function HttpGet(url)
    local RequestFunc = expect("function", syn and syn.request, 
        expect("function", request, 
            expect("function", http_request, nil)))
    
    if not RequestFunc then
        return nil
    end
    
    local success, result = pcall(function()
        return RequestFunc({
            Url = url,
            Method = "GET"
        })
    end)
    
    return success and result or nil
end

local function GetAsset(Path)
    if not LoadAsset then
        return nil
    end

    local Asset = Assets[Path]
    if not Asset then
        return nil
    end

    if not IsFolder("Shiftlock") then
        MakeFolder("Shiftlock")
    end

    if not IsFolder("Shiftlock/Assets") then
        MakeFolder("Shiftlock/Assets")
    end

    if not IsFile(Path) then
        local Success, Response = pcall(function()
            return HttpGet(Asset)
        end)

        if not Success or not Response or not Response.Success or not Response.Body then
            return nil
        end

        WriteFile(Path, Response.Body)
    end

    return LoadAsset(Path)
end

Shared.Shiftlock = Shared.Shiftlock or {}

if Shared.Shiftlock.isLoaded then
    Services.StarterGui:SetCore("SendNotification", {
        Title = "Shiftlock",
        Text = "Shiftlock is already running!",
        Icon = GetAsset("Shiftlock/Assets/lock.png"),
        Duration = 4
    })
    return
end

Shared.Shiftlock.isLoaded = true

local ShiftlockGui = Instance.new("ScreenGui")
ShiftlockGui.Name = "Shiftlock"
ShiftlockGui.DisplayOrder = 50
ShiftlockGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ShiftlockGui.ResetOnSpawn = false
ShiftlockGui.Parent = CoreGui

local Button = Instance.new("ImageButton")
Button.Name = "Button"
Button.BorderSizePixel = 0
Button.BackgroundTransparency = 1
Button.Size = UDim2.new(0, 54, 0, 54)
Button.Position = UDim2.new(0, 18, 0, 2)
Button.Image = GetAsset("Shiftlock/Assets/lock.png")
Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
Button.Parent = ShiftlockGui

local ButtonRatio = Instance.new("UIAspectRatioConstraint")
ButtonRatio.Name = "ButtonRatio"
ButtonRatio.Parent = Button

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.Name = "ButtonCorner"
ButtonCorner.CornerRadius = UDim.new(1, 0)
ButtonCorner.Parent = Button

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
    local HumanoidChar = GetHumanoid()
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

local function Dragify(Frame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function ClampPosition(newX, newY)
        local viewport = Workspace.CurrentCamera.ViewportSize
        local size = Frame.AbsoluteSize
        local padding = 3

        local maxX = viewport.X - size.X - padding
        local maxY = viewport.Y - size.Y - padding
        local minX = padding
        local minY = padding

        newX = math.clamp(newX, minX, maxX)
        newY = math.clamp(newY, minY, maxY)

        return newX, newY
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            newX, newY = ClampPosition(newX, newY)
            Frame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        end
    end)
end

local function UpdateScreenSize()
    ScreenSize = Workspace.CurrentCamera.ViewportSize
end

Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScreenSize)

Dragify(Button)

Button.MouseButton1Click:Connect(function()
    ShiftlockEnabled = not ShiftlockEnabled
    if ShiftlockEnabled then
        EnableShiftlock()
    else
        DisableShiftlock()
    end
end)

Close.MouseButton1Click:Connect(function()
    DisableShiftlock()
    ShiftlockGui:Destroy()
    Shared.Shiftlock.isLoaded = false
end)

Player.CharacterAdded:Connect(function(NewChar)
    task.wait(0.5)
    if ShiftlockEnabled then
        local Humanoid = NewChar:FindFirstChildOfClass("Humanoid")
        if Humanoid and ShiftlockActive then
            Humanoid.AutoRotate = false
        end
        EnableShiftlock()
    end
end)