if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Env = (type(getgenv) == "function" and getgenv()) or _G

local function GetService(Name)
    local Svc = game:GetService(Name)
    return cloneref and cloneref(Svc) or Svc
end

local Players = GetService("Players")
local Player = Players.LocalPlayer
local Workspace = GetService("Workspace")
local ReplicatedStorage = GetService("ReplicatedStorage")
local StarterGui = GetService("StarterGui")

local VoidUI = Env.__Sanity.VoidUI

if not VoidUI then
    warn("[Sanity.exe]: Failed to load VoidUI")
    return
end

VoidUI:SetTheme("Midnight")
VoidUI:SetTitle("Egg Autofarm")

local function Notify(Title, Text, Duration)
    if not pcall(function()
        VoidUI:Notify(Title, Text, Duration)
    end) then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = Title,
                Text = Text,
                Duration = Duration
            })
        end)
    end
end

local MainTab = VoidUI:New("Tab", {
    Text = "Egg Farm"
})

local TeleportTab = VoidUI:New("Tab", {
    Text = "Teleports"
})

local EggHitRequest = ReplicatedStorage:FindFirstChild("EggHitRequest")
local PlaceAnimalRemote = ReplicatedStorage:FindFirstChild("PlaceAnimalRemote")

local Enabled = false
local Running = false
local HitDelay = 0.05
local PlacementIndex = 19
local SelectedZone = "All Zones"

local function GetRoot()
    local Character = Player.Character

    if not Character then
        return nil
    end

    return Character:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    local Character = Player.Character

    if not Character then
        return nil
    end

    return Character:FindFirstChildOfClass("Humanoid")
end

local function GetPickaxe()
    local PlayerFolder = Workspace:FindFirstChild(Player.Name)

    if PlayerFolder then
        local Pickaxe = PlayerFolder:FindFirstChild("Pickaxe")

        if Pickaxe then
            return Pickaxe
        end
    end

    local Character = Player.Character

    if Character then
        local Pickaxe = Character:FindFirstChild("Pickaxe")

        if Pickaxe then
            return Pickaxe
        end
    end

    local Backpack = Player:FindFirstChildOfClass("Backpack")

    if Backpack then
        local Pickaxe = Backpack:FindFirstChild("Pickaxe")

        if Pickaxe then
            return Pickaxe
        end
    end

    return nil
end

local function EquipPickaxe()
    local Humanoid = GetHumanoid()
    local Pickaxe = GetPickaxe()

    if not Humanoid or not Pickaxe then
        return false
    end

    local Character = Player.Character

    if Pickaxe.Parent ~= Character then
        Humanoid:EquipTool(Pickaxe)
    end

    local Deadline = os.clock() + 2

    repeat
        task.wait(0.03)

        if not Enabled then
            return false
        end
    until Pickaxe.Parent == Character or os.clock() >= Deadline

    return Pickaxe.Parent == Character
end

local function GetBase()
    local Plots = Workspace:FindFirstChild("Plots")

    if not Plots then
        return nil
    end

    for _, Plot in ipairs(Plots:GetChildren()) do
        local Hitbox = Plot:FindFirstChild("Hitbox")

        if Hitbox then
            local PlayerInfo = Hitbox:FindFirstChild("PlayerInfoUi")

            if PlayerInfo then
                local NameLabel = PlayerInfo:FindFirstChild("Name")

                if NameLabel
                    and NameLabel:IsA("TextLabel")
                    and NameLabel.Text == "Your Base" then
                    return Hitbox
                end
            end
        end
    end

    return nil
end

local function GetBasePosition()
    local Base = GetBase()

    if not Base then
        return nil
    end

    return Base.CFrame:PointToWorldSpace(
        Vector3.new(-6.5440483, -10.7333343, -1.0213241)
    )
end

local function Go(Pos)
    local Root = GetRoot()

    if Root then
        Root.CFrame = CFrame.new(Pos)
        return true
    end

    return false
end

local function GoToBase()
    local Position = GetBasePosition()

    if not Position then
        return false
    end

    return Go(Position + Vector3.new(0, 3, 0))
end

local function GetZoneEggs()
    local Result = {}

    local Build = Workspace:FindFirstChild("Build")
    local ZoneBuilds = Build and Build:FindFirstChild("ZoneBuilds")

    if not ZoneBuilds then
        return Result
    end

    local function CollectZone(ZoneName)
        local Zone = ZoneBuilds:FindFirstChild(ZoneName)

        if not Zone then
            return
        end

        local Eggs = Zone:FindFirstChild("Eggs")

        if not Eggs then
            return
        end

        for _, EggFolder in ipairs(Eggs:GetChildren()) do
            local Egg = EggFolder:FindFirstChild("Egg")

            if Egg and Egg:IsA("BasePart") then
                table.insert(Result, Egg)
            end
        end
    end

    if SelectedZone == "All Zones" then
        for ZoneIndex = 1, 9 do
            CollectZone("Zone" .. ZoneIndex)
        end
    else
        CollectZone(SelectedZone)
    end

    return Result
end

local function GetNextEgg()
    local Root = GetRoot()

    if not Root then
        return nil
    end

    local Closest = nil
    local ClosestDistance = math.huge

    for _, Egg in ipairs(GetZoneEggs()) do
        if Egg.Parent then
            local Broken = Egg:GetAttribute("Broken")
            local Health = Egg:GetAttribute("Health")

            if Broken ~= true and (Health == nil or Health > 0) then
                local Distance = (Egg.Position - Root.Position).Magnitude

                if Distance < ClosestDistance then
                    ClosestDistance = Distance
                    Closest = Egg
                end
            end
        end
    end

    return Closest
end

local function SnapshotPickups()
    local AnimalPickups = Workspace:FindFirstChild("AnimalPickups")
    local Snapshot = {}

    if not AnimalPickups then
        return Snapshot
    end

    for _, Object in ipairs(AnimalPickups:GetDescendants()) do
        Snapshot[Object] = true
    end

    return Snapshot
end

local function GetPickup(Snapshot, Origin)
    local AnimalPickups = Workspace:FindFirstChild("AnimalPickups")

    if not AnimalPickups then
        return nil
    end

    local Closest = nil
    local ClosestDistance = math.huge

    for _, Object in ipairs(AnimalPickups:GetDescendants()) do
        if Object:IsA("BasePart") and not Snapshot[Object] then
            local Distance = (Object.Position - Origin).Magnitude

            if Distance <= 150 and Distance < ClosestDistance then
                ClosestDistance = Distance
                Closest = Object
            end
        end
    end

    return Closest
end

local function SnapshotAnimals()
    local Snapshot = {}

    if type(getnilinstances) ~= "function" then
        return Snapshot
    end

    for _, Object in ipairs(getnilinstances()) do
        if Object:IsA("Model") and Object:GetAttribute("AnimalName") then
            Snapshot[Object] = true
        end
    end

    return Snapshot
end

local function GetNewAnimal(Snapshot)
    if type(getnilinstances) ~= "function" then
        return nil
    end

    for _, Object in ipairs(getnilinstances()) do
        if Object:IsA("Model") and Object:GetAttribute("AnimalName") then
            if not Snapshot[Object] then
                return Object
            end
        end
    end

    return nil
end

local function GetStealPrompt()
    local PromptAnchor = Workspace:FindFirstChild("PromptAnchor")

    if not PromptAnchor then
        return nil
    end

    local Prompt = PromptAnchor:FindFirstChild("StealPrompt", true)

    if Prompt and Prompt:IsA("ProximityPrompt") then
        return PromptAnchor, Prompt
    end

    return nil
end

local function WaitForPrompt(Pickup)
    local Deadline = os.clock() + 15

    while Enabled and os.clock() < Deadline do
        if not Pickup or not Pickup.Parent then
            return nil
        end

        local Root = GetRoot()

        if Root then
            Root.CFrame = CFrame.new(
                Pickup.Position + Vector3.new(0, 2, 0)
            )
        end

        local PromptAnchor, Prompt = GetStealPrompt()

        if PromptAnchor and Prompt then
            local CloseEnough = true

            if PromptAnchor:IsA("BasePart") then
                CloseEnough = (
                    PromptAnchor.Position - Pickup.Position
                ).Magnitude <= 15
            end

            if CloseEnough and Prompt.Enabled then
                return Prompt
            end
        end

        task.wait(0.03)
    end

    return nil
end

local function Hold(Prompt, Duration)
    if not Prompt then
        return false
    end

    local Fired = false

    local Connection = Prompt.Triggered:Connect(function()
        Fired = true
    end)

    pcall(function()
        Prompt:InputHoldBegin()
        task.wait((Duration or Prompt.HoldDuration or 0.5) + 0.15)
        Prompt:InputHoldEnd()
    end)

    Connection:Disconnect()

    return Fired
end

local function StealPickup(Pickup)
    if not Pickup or not Pickup.Parent then
        return nil
    end

    local AnimalSnapshot = SnapshotAnimals()
    local Prompt = WaitForPrompt(Pickup)

    if not Prompt then
        return nil
    end

    Hold(Prompt, Prompt.HoldDuration or 0.5)

    GoToBase()

    local Deadline = os.clock() + 8

    repeat
        local Animal = GetNewAnimal(AnimalSnapshot)

        if Animal then
            return Animal
        end

        task.wait(0.02)
    until not Enabled or os.clock() >= Deadline

    return nil
end

local function BreakEgg(Egg)
    local Root = GetRoot()

    if not Root or not Egg or not Egg.Parent then
        return false
    end

    Go(Egg.Position + Vector3.new(0, 3, 0))
    task.wait(0.05)

    if not EquipPickaxe() then
        return false
    end

    for Counter = 1, 20 do
        if not Enabled or not Egg.Parent then
            break
        end

        local Broken = Egg:GetAttribute("Broken")
        local Health = Egg:GetAttribute("Health")

        if Broken == true or (Health and Health <= 0) then
            return true
        end

        pcall(function()
            EggHitRequest:FireServer(Egg, Counter)
        end)

        task.wait(HitDelay)
    end

    local Deadline = os.clock() + 3

    repeat
        task.wait(0.03)

        if not Enabled then
            return false
        end

        if not Egg.Parent then
            return true
        end

        local Broken = Egg:GetAttribute("Broken")
        local Health = Egg:GetAttribute("Health")

        if Broken == true or (Health and Health <= 0) then
            return true
        end
    until os.clock() >= Deadline

    return false
end

local function PlaceAnimal(Animal)
    if not Animal then
        return false
    end

    local BasePosition = GetBasePosition()

    if not BasePosition then
        return false
    end

    Go(BasePosition + Vector3.new(0, 3, 0))
    task.wait(0.03)

    return pcall(function()
        PlaceAnimalRemote:FireServer(
            Animal,
            BasePosition,
            PlacementIndex
        )
    end)
end

local function CollectEggPets(Egg)
    local Origin = Egg.Position
    local PickupSnapshot = SnapshotPickups()
    local EmptySince = nil

    while Enabled do
        local Pickup = GetPickup(PickupSnapshot, Origin)

        if Pickup then
            EmptySince = nil

            local Animal = StealPickup(Pickup)

            if Animal then
                PlaceAnimal(Animal)
                PickupSnapshot = SnapshotPickups()
                task.wait(0.05)
            else
                task.wait(0.1)
            end
        else
            if not EmptySince then
                EmptySince = os.clock()
            end

            if os.clock() - EmptySince >= 3 then
                break
            end

            task.wait(0.03)
        end
    end
end

local function FarmCycle()
    local Root = GetRoot()

    if not Root then
        return false
    end

    local Egg = GetNextEgg()

    if not Egg then
        return false
    end

    if not BreakEgg(Egg) then
        return false
    end

    CollectEggPets(Egg)

    return true
end

local function StartAutofarm()
    if Running then
        return
    end

    Running = true

    task.spawn(function()
        while Enabled do
            local Success = FarmCycle()

            if not Success then
                task.wait(0.15)
            end
        end

        Running = false
    end)
end

VoidUI:New("Section", {
    Parent = MainTab,
    Text = "Controls"
})

VoidUI:New("Toggle", {
    Parent = MainTab,
    Text = "Autofarm",
    Default = false,
    Callback = function(State)
        Enabled = State

        if State then
            StartAutofarm()
        end
    end
})

VoidUI:New("Dropdown", {
    Parent = MainTab,
    Text = "Zone",
    Options = {
        "All Zones",
        "Zone1",
        "Zone2",
        "Zone3",
        "Zone4",
        "Zone5",
        "Zone6",
        "Zone7",
        "Zone8",
        "Zone9"
    },
    Default = "All Zones",
    Callback = function(Option)
        SelectedZone = Option
    end
})

VoidUI:New("Slider", {
    Parent = MainTab,
    Text = "Hit Delay",
    Min = 0,
    Max = 0.5,
    Default = 0.05,
    Callback = function(Value)
        HitDelay = Value
    end
})

VoidUI:New("Slider", {
    Parent = MainTab,
    Text = "Placement Index",
    Min = 1,
    Max = 50,
    Default = 19,
    Callback = function(Value)
        PlacementIndex = math.floor(Value)
    end
})

VoidUI:New("Divider", {
    Parent = TeleportTab
})

VoidUI:New("Section", {
    Parent = TeleportTab,
    Text = "Teleports"
})

VoidUI:New("Button", {
    Parent = TeleportTab,
    Text = "Teleport to Base",
    Callback = function()
        if GoToBase() then
            Notify("Sanity.exe", "Teleported to base", 3)
        else
            Notify("Sanity.exe", "Base not found", 3)
        end
    end
})

for ZoneIndex = 1, 9 do
    local ZoneName = "Zone" .. ZoneIndex

    VoidUI:New("Button", {
        Parent = TeleportTab,
        Text = "Teleport to " .. ZoneName,
        Callback = function()
            local Build = Workspace:FindFirstChild("Build")
            local ZoneBuilds = Build and Build:FindFirstChild("ZoneBuilds")
            local Zone = ZoneBuilds and ZoneBuilds:FindFirstChild(ZoneName)
            local Eggs = Zone and Zone:FindFirstChild("Eggs")

            if Eggs then
                local EggFolder = Eggs:GetChildren()[1]
                local Egg = EggFolder and EggFolder:FindFirstChild("Egg")

                if Egg and Egg:IsA("BasePart") then
                    Go(Egg.Position + Vector3.new(0, 3, 0))
                    Notify("Sanity.exe", "Teleported to " .. ZoneName, 3)
                    return
                end
            end

            Notify("Sanity.exe", ZoneName .. " not found", 3)
        end
    })
end

Notify("Sanity.exe", "Loaded successfully!", 3)