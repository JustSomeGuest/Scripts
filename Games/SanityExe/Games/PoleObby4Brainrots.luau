if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (function()
    local Success, Env = pcall(getgenv)
    return (Success and Env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local VoidUI = Shared.VoidUI

if not VoidUI then
    warn("[Sanity.exe]: Failed to load VoidUI")
    return
end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Tab = VoidUI:New("Tab", {
    Text = "Main"
})

local BrainrotSpawns = Workspace:FindFirstChild("BrainrotSpawns")
local MobsFolder = Workspace:FindFirstChild("Mobs")
local Bases = Workspace:FindFirstChild("Bases")

if not BrainrotSpawns then
    BrainrotSpawns = Workspace:WaitForChild("BrainrotSpawns", 10)
    if not BrainrotSpawns then
        return
    end
end

if not MobsFolder then
    MobsFolder = Workspace:WaitForChild("Mobs", 10)
    if not MobsFolder then
        return
    end
end

if not Bases then
    Bases = Workspace:WaitForChild("Bases", 10)
    if not Bases then
        return
    end
end

local OriginalPosition = nil
local IsBusy = false

local function GetRootPart()
    local Char = Player.Character
    if not Char then
        return nil
    end
    return Char:FindFirstChild("HumanoidRootPart") or Char:FindFirstChild("Head")
end

local function SaveOriginalPosition()
    local Root = GetRootPart()
    if Root then
        OriginalPosition = Root.Position
        return true
    end
    return false
end

local function TeleportTo(Position)
    local Root = GetRootPart()
    if Root then
        Root.CFrame = CFrame.new(Position)
    end
end

local function TeleportToOriginal()
    if OriginalPosition then
        TeleportTo(OriginalPosition)
        return true
    end
    return false
end

local function GetModelPosition(Model)
    local RootPart = Model:FindFirstChild("RootPart")
    if RootPart then
        return RootPart.Position
    end

    local PrimaryPart = Model.PrimaryPart
    if PrimaryPart then
        return PrimaryPart.Position
    end

    local HRP = Model:FindFirstChild("HumanoidRootPart")
    if HRP then
        return HRP.Position
    end

    local Head = Model:FindFirstChild("Head")
    if Head then
        return Head.Position
    end

    for _, Child in ipairs(Model:GetChildren()) do
        if Child:IsA("BasePart") then
            return Child.Position
        end
    end

    return nil
end

local function GetPlayerBase()
    for _, Base in ipairs(Bases:GetChildren()) do
        local TitleFolder = Base:FindFirstChild("Title")
        if TitleFolder then
            local TitleGui = TitleFolder:FindFirstChild("TitleGui")
            if TitleGui then
                local Frame = TitleGui:FindFirstChild("Frame")
                if Frame then
                    local PlayerName = Frame:FindFirstChild("PlayerName")
                    if PlayerName and PlayerName:IsA("TextLabel") then
                        if PlayerName.Text == Player.Name then
                            return Base
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function GetAvailableSlot()
    local Base = GetPlayerBase()
    if not Base then
        return nil
    end

    local Slots = Base:FindFirstChild("Slots")
    if not Slots then
        return nil
    end

    for _, Slot in ipairs(Slots:GetChildren()) do
        if Slot:IsA("Folder") or Slot:IsA("Model") then
            local Collect = Slot:FindFirstChild("Collect")
            if Collect and Collect:IsA("BasePart") and Collect.Transparency == 0 then
                local ActiveBrainrot = Slot:FindFirstChild("ActiveBrainrot")
                if not ActiveBrainrot then
                    local BasePart = Slot:FindFirstChild("Base")
                    if BasePart then
                        return Slot
                    end
                end
            end
        end
    end

    return nil
end

local function GetPlacePrompt(Slot)
    if not Slot then
        return nil
    end

    local BasePart = Slot:FindFirstChild("Base")
    if BasePart then
        local PlacePrompt = BasePart:FindFirstChild("PlacePrompt")
        if PlacePrompt and PlacePrompt:IsA("ProximityPrompt") then
            return PlacePrompt
        end
    end

    return nil
end

local function GetSlotPosition(Slot)
    if not Slot then
        return nil
    end

    local BasePart = Slot:FindFirstChild("Base")
    if BasePart then
        return BasePart.Position
    end

    return nil
end

local function HoldPrompt(Prompt, Duration)
    if not Prompt then
        return false
    end

    local Triggered = false
    local Connection = Prompt.Triggered:Connect(function()
        Triggered = true
    end)

    pcall(function()
        Prompt:InputHoldBegin()
        task.wait((Duration or Prompt.HoldDuration or 0.5) + 0.15)
        Prompt:InputHoldEnd()
    end)

    Connection:Disconnect()

    return Triggered
end

local function GrabBrainrot(Brainrot)
    if not Brainrot then
        return false
    end

    local RootPart = Brainrot:FindFirstChild("RootPart")
    if not RootPart then
        return false
    end

    local Prompt = RootPart:FindFirstChild("ProximityPrompt")
    if not Prompt then
        return false
    end

    for Attempt = 1, 2 do
        local Pos = GetModelPosition(Brainrot)
        if not Pos then
            return false
        end

        TeleportTo(Pos + Vector3.new(0, 2, 0))
        task.wait(0.25)

        if HoldPrompt(Prompt, Prompt.HoldDuration or 0.5) then
            return true
        end

        task.wait(0.15)
    end

    return false
end

local function PlaceBrainrot(Slot)
    if not Slot then
        return false
    end

    local PlacePrompt = GetPlacePrompt(Slot)
    if not PlacePrompt then
        return false
    end

    for Attempt = 1, 2 do
        local SlotPos = GetSlotPosition(Slot)
        if not SlotPos then
            return false
        end

        TeleportTo(SlotPos + Vector3.new(0, 3, 0))
        task.wait(0.25)

        if HoldPrompt(PlacePrompt, PlacePrompt.HoldDuration or 0.5) then
            task.wait(0.5)
            return true
        end

        task.wait(0.15)
    end

    return false
end

local function GetNearbyBrainrot(PlatePos, Radius)
    Radius = Radius or 25
    local Closest = nil
    local ClosestDist = Radius

    for _, Mob in ipairs(MobsFolder:GetChildren()) do
        if Mob:IsA("Model") then
            local RootPart = Mob:FindFirstChild("RootPart")
            if RootPart then
                local Prompt = RootPart:FindFirstChild("ProximityPrompt")
                if Prompt then
                    local Pos = GetModelPosition(Mob)
                    if Pos then
                        local Dist = (Pos - PlatePos).Magnitude
                        if Dist < ClosestDist then
                            ClosestDist = Dist
                            Closest = Mob
                        end
                    end
                end
            end
        end
    end

    return Closest
end

local function BringBrainrot(Plate)
    if not Plate then
        return false
    end

    if IsBusy then
        return false
    end

    IsBusy = true

    local Brainrot = GetNearbyBrainrot(Plate.Position)
    if not Brainrot then
        IsBusy = false
        return false
    end

    SaveOriginalPosition()

    if not GrabBrainrot(Brainrot) then
        TeleportToOriginal()
        IsBusy = false
        return false
    end

    local Slot = GetAvailableSlot()
    if not Slot then
        TeleportToOriginal()
        IsBusy = false
        return false
    end

    if not PlaceBrainrot(Slot) then
        TeleportToOriginal()
        IsBusy = false
        return false
    end

    TeleportToOriginal()
    IsBusy = false
    return true
end

local function AutoFarmBrainrots(Plate)
    if not Plate then
        return
    end

    if IsBusy then
        return
    end

    IsBusy = true

    local Brainrot = GetNearbyBrainrot(Plate.Position)
    if not Brainrot then
        IsBusy = false
        return
    end

    local Slot = GetAvailableSlot()
    if not Slot then
        IsBusy = false
        return
    end

    SaveOriginalPosition()

    if not GrabBrainrot(Brainrot) then
        TeleportToOriginal()
        IsBusy = false
        return
    end

    if not PlaceBrainrot(Slot) then
        TeleportToOriginal()
        IsBusy = false
        return
    end

    TeleportToOriginal()
    IsBusy = false
end

local SectionOrder = {
    "Common",
    "Rare",
    "Epic",
    "Legendary",
    "Mythic",
    "Secret",
    "Exclusive",
    "OG",
    "Admin"
}

local function CreatePlateSection(PlateName, IsLast)
    local PlateFolder = BrainrotSpawns:FindFirstChild(PlateName)
    if not PlateFolder then
        return
    end
    
    local Plate = PlateFolder:FindFirstChild("Plate")
    if not Plate then
        return
    end
    
    VoidUI:New("Section", {
        Text = PlateName,
        Parent = Tab
    })
    
    VoidUI:New("Button", {
        Text = "Bring Brainrot",
        Parent = Tab,
        Callback = function()
            BringBrainrot(Plate)
        end
    })
    
    local ToggleState = false
    local ToggleConnection = nil
    
    VoidUI:New("Toggle", {
        Text = "AutoFarm Brainrots",
        Parent = Tab,
        Default = false,
        Callback = function(state)
            ToggleState = state
            
            if ToggleConnection then
                ToggleConnection:Disconnect()
                ToggleConnection = nil
            end
            
            if state then
                ToggleConnection = RunService.RenderStepped:Connect(function()
                    if ToggleState then
                        AutoFarmBrainrots(Plate)
                    end
                end)
            end
        end
    })
    
    if not IsLast then
        VoidUI:New("Divider", {
            Parent = Tab
        })
    end
end

local TotalSections = #SectionOrder
local CurrentIndex = 0

for _, SectionName in ipairs(SectionOrder) do
    CurrentIndex = CurrentIndex + 1
    local IsLast = (CurrentIndex == TotalSections)
    
    local PlateFolder = BrainrotSpawns:FindFirstChild(SectionName)
    if PlateFolder then
        local Plate = PlateFolder:FindFirstChild("Plate")
        if Plate then
            CreatePlateSection(SectionName, IsLast)
        end
    end
end