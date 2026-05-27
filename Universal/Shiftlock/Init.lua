if not game:IsLoaded() then game.Loaded:Wait() end

local CloneRef = cloneref or function(...) return ... end

local Services = setmetatable({}, {
    __index = function(self, name)
        local success, cache = pcall(function()
            return CloneRef(game:GetService(name))
        end)
        if success then
            rawset(self, name, cache)
            return cache
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

local Players = Services.Players
local RunService = Services.RunService
local CoreGui = Services.CoreGui
local UserInputService = Services.UserInputService
local GuiService = Services.GuiService
local Workspace = Services.Workspace
local StarterGui = Services.StarterGui

local WriteFile = writefile or function() end
local IsFile = isfile or function() return false end
local IsFolder = isfolder or function() return false end
local MakeFolder = makefolder or function() end

local LoadAsset = getcustomasset or getsynasset or nil

local Assets = {
    ["Shiftlock/assets/lock.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Shiftlock/Assets/lock.png",
}

local function HttpGet(url)
    local RequestFunc = syn and syn.request or request or http_request
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

    if not IsFolder("Shiftlock/assets") then
        MakeFolder("Shiftlock/assets")
    end

    if Asset:match("^rbxassetid://") then
        return Asset
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

getgenv().Shiftlock = getgenv().Shiftlock or {}

if getgenv().Shiftlock.isLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "Shiftlock",
        Text = "Shiftlock is already running!",
        Duration = 4
    })
    return
end

getgenv().Shiftlock.isLoaded = true

local PlayerGui
local Success, Result = pcall(function()
    return gethui()
end)
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
Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Button.BackgroundTransparency = 0.3
Button.Size = UDim2.new(0, 54, 0, 54)
Button.Position = UDim2.new(0, 18, 0, 2)
Button.Image = ""
Button.Parent = Shiftlock

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.Name = "ButtonCorner"
ButtonCorner.CornerRadius = UDim.new(1, 0)
ButtonCorner.Parent = Button

local ButtonRatio = Instance.new("UIAspectRatioConstraint")
ButtonRatio.Name = "ButtonRatio"
ButtonRatio.Parent = Button

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Name = "ButtonStroke"
ButtonStroke.Transparency = 0.3
ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
ButtonStroke.Parent = Button

local ButtonPadding = Instance.new("UIPadding")
ButtonPadding.Name = "ButtonPadding"
ButtonPadding.PaddingTop = UDim.new(0, 4)
ButtonPadding.PaddingRight = UDim.new(0, 4)
ButtonPadding.PaddingLeft = UDim.new(0, 4)
ButtonPadding.PaddingBottom = UDim.new(0, 4)
ButtonPadding.Parent = Button

local Icon = Instance.new("ImageLabel")
Icon.Name = "Icon"
Icon.BorderSizePixel = 0
Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Icon.BackgroundTransparency = 1
Icon.Size = UDim2.new(1, 0, 1, 0)
Icon.Image = GetAsset("Shiftlock/assets/lock.png") or "rbxassetid://6031098370"
Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
Icon.Parent = Button

local IconCorner = Instance.new("UICorner")
IconCorner.Name = "IconCorner"
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = Icon

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.TextWrapped = true
Close.BorderSizePixel = 0
Close.TextScaled = true
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Close.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Close.AnchorPoint = Vector2.new(0.5, 0.5)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Text = "×"
Close.Position = UDim2.new(0.8, 4, 0.3, -8)
Close.Parent = Button

local CloseCorner = Instance.new("UICorner")
CloseCorner.Name = "CloseCorner"
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = Close

local CloseRatio = Instance.new("UIAspectRatioConstraint")
CloseRatio.Name = "CloseRatio"
CloseRatio.Parent = Close

Close.MouseButton1Click:Connect(function()
    Shiftlock:Destroy()
    getgenv().Shiftlock.isLoaded = false
end)

local function Dragify(Object)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPos

    local function Update(Input)
        local Delta = Input.Position - DragStart
        local NewPos = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )

        local ViewportSize = Workspace.CurrentCamera.ViewportSize
        local GuiInset = GuiService:GetGuiInset()

        local AbsoluteSize = Object.AbsoluteSize

        local MinX = 0
        local MinY = GuiInset.Y
        local MaxX = ViewportSize.X - AbsoluteSize.X
        local MaxY = ViewportSize.Y - AbsoluteSize.Y

        local ClampedX = math.clamp(NewPos.X.Offset, MinX, MaxX)
        local ClampedY = math.clamp(NewPos.Y.Offset, MinY, MaxY)

        Object.Position = UDim2.new(
            StartPos.X.Scale,
            ClampedX,
            StartPos.Y.Scale,
            ClampedY
        )
    end

    Object.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then

            Dragging = true
            DragStart = Input.Position
            StartPos = Object.Position

            local Connection
            Connection = Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                    Connection:Disconnect()
                end
            end)
        end
    end)

    Object.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            Update(Input)
        end
    end)
end

Dragify(Button)

local ShiftlockActive = false
local CamConnection = nil
local Player = Players.LocalPlayer
local OriginalCFrame = nil

local function GetCharacterRoot()
    local Char = Player.Character
    if not Char then return nil end
    return Char:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    local Char = Player.Character
    if not Char then return nil end
    return Char:FindFirstChildOfClass("Humanoid")
end

local function EnableShiftlock()
    local RootPart = GetCharacterRoot()
    local Humanoid = GetHumanoid()
    if not RootPart or not Humanoid then return end
    
    ShiftlockActive = true
    
    Icon.ImageColor3 = Color3.fromRGB(0, 210, 255)
    ButtonStroke.Color = Color3.fromRGB(0, 210, 255)
    
    if not OriginalCFrame then
        OriginalCFrame = Workspace.CurrentCamera.CFrame
    end
    
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    Workspace.CurrentCamera.CameraSubject = RootPart
    
    local LastRootPos = RootPart.Position
    local LastCameraPos = Workspace.CurrentCamera.CFrame.Position
    
    local function UpdateCamera()
        if not ShiftlockActive then return end
        local CurrentRoot = GetCharacterRoot()
        if not CurrentRoot then return end
        
        local CurrentRootPos = CurrentRoot.Position
        local RootVel = (CurrentRootPos - LastRootPos) / RunService.RenderStepped:Wait()
        LastRootPos = CurrentRootPos
        
        local Camera = Workspace.CurrentCamera
        local NewCameraPos = LastCameraPos + RootVel
        LastCameraPos = NewCameraPos
        
        local LookPos = CurrentRootPos + Vector3.new(0, 3, 0)
        Camera.CFrame = CFrame.new(NewCameraPos, LookPos)
    end
    
    if CamConnection then CamConnection:Disconnect() end
    CamConnection = RunService.RenderStepped:Connect(UpdateCamera)
    
    local function OnCharacterAdded()
        task.wait(0.5)
        if ShiftlockActive then
            LastRootPos = GetCharacterRoot().Position
            LastCameraPos = Workspace.CurrentCamera.CFrame.Position
        end
    end
    
    getgenv().Shiftlock.CharacterAddedConn = Player.CharacterAdded:Connect(OnCharacterAdded)
end

local function DisableShiftlock()
    ShiftlockActive = false
    
    Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
    
    if CamConnection then
        CamConnection:Disconnect()
        CamConnection = nil
    end
    if getgenv().Shiftlock.CharacterAddedConn then
        getgenv().Shiftlock.CharacterAddedConn:Disconnect()
        getgenv().Shiftlock.CharacterAddedConn = nil
    end
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    if OriginalCFrame then
        Workspace.CurrentCamera.CFrame = OriginalCFrame
        OriginalCFrame = nil
    end
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

Player.CharacterAdded:Connect(function()
    if ShiftlockEnabled then
        task.wait(0.5)
        EnableShiftlock()
    end
end)
