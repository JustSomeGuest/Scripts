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

local UI = Env.__Sanity.VoidUI

if not UI then
    warn("[Sanity.exe]: Failed to load VoidUI")
    return
end

local function Notify(Title, Text, Duration)
    if not pcall(function()
        UI:Notify(Title, Text, Duration)
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

local MainTab = UI:New("Tab", {
    Text = "Egg Farm"
})

local TeleportTab = UI:New("Tab", {
    Text = "Teleports"
})

local EggHitRequest = ReplicatedStorage:FindFirstChild("EggHitRequest")
local PlaceAnimalRemote = ReplicatedStorage:FindFirstChild("PlaceAnimalRemote")

local Enabled = false
local Running = false
local HitDelay = 0.05
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

    if not Root then
        return false
    end

    Root.CFrame = CFrame.new(Pos)
    return true
end

local function GoToBase()
    local Position = GetBasePosition()

    if not Position then
        return false
    end

    return Go(Position + Vector3.new(0, 3, 0))
end

local function GetZone(ZoneName)
    local Build = Workspace:FindFirstChild("Build")

    if not Build then
        return nil
    end

    local ZoneBuilds = Build:FindFirstChild("ZoneBuilds")

    if not ZoneBuilds then
        return nil
    end

    return ZoneBuilds:FindFirstChild(ZoneName)
end

local function GetZoneEggs(ZoneName)
    local Result = {}

    if ZoneName == "All Zones" then
        for ZoneIndex = 1, 9 do
            local Zone = GetZone("Zone" .. ZoneIndex)
            local Eggs = Zone and Zone:FindFirstChild("Eggs")

            if Eggs then
                for _, EggFolder in ipairs(Eggs:GetChildren()) do
                    local Egg = EggFolder:FindFirstChild("Egg")

                    if Egg and Egg:IsA("BasePart") then
                        table.insert(Result, Egg)
                    end
                end
            end
        end

        return Result
    end

    local Zone = GetZone(ZoneName)

    if not Zone then
        return Result
    end

    local Eggs = Zone:FindFirstChild("Eggs")

    if not Eggs then
        return Result
    end

    for _, EggFolder in ipairs(Eggs:GetChildren()) do
        local Egg = EggFolder:FindFirstChild("Egg")

        if Egg and Egg:IsA("BasePart") then
            table.insert(Result, Egg)
        end
    end

    return Result
end

local function IsValidEgg(Egg, ZoneName)
    if not Egg or not Egg.Parent then
        return false
    end

    if ZoneName == "All Zones" then
        for _, ZoneEgg in ipairs(GetZoneEggs("All Zones")) do
            if ZoneEgg == Egg then
                return true
            end
        end

        return false
    end

    local Zone = GetZone(ZoneName)

    if not Zone then
        return false
    end

    local Eggs = Zone:FindFirstChild("Eggs")

    if not Eggs then
        return false
    end

    return Egg:IsDescendantOf(Eggs)
end

local function GetNextEgg(ZoneName)
    local Root = GetRoot()

    if not Root then
        return nil
    end

    local Closest = nil
    local ClosestDistance = math.huge

    for _, Egg in ipairs(GetZoneEggs(ZoneName)) do
        if IsValidEgg(Egg, ZoneName) then
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

local function GetPickupParts(Origin)
    local AnimalPickups = Workspace:FindFirstChild("AnimalPickups")

    if not AnimalPickups then
        return {}
    end

    local Result = {}

    for _, Object in ipairs(AnimalPickups:GetDescendants()) do
        if Object:IsA("BasePart") then
            local Distance = (Object.Position - Origin).Magnitude

            if Distance <= 35 then
                table.insert(Result, Object)
            end
        end
    end

    table.sort(Result, function(A, B)
        return (A.Position - Origin).Magnitude < (B.Position - Origin).Magnitude
    end)

    return Result
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
        if Object:IsA("Model")
            and Object:GetAttribute("AnimalName")
            and not Snapshot[Object] then
            return Object
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

        if PromptAnchor and Prompt and Prompt.Enabled then
            if PromptAnchor:IsA("BasePart") then
                if (PromptAnchor.Position - Pickup.Position).Magnitude <= 20 then
                    return Prompt
                end
            else
                return Prompt
            end
        end

        task.wait(0.03)
    end

    return nil
end

local function Hold(Prompt)
    if not Prompt then
        return false
    end

    local Fired = false

    local Connection = Prompt.Triggered:Connect(function()
        Fired = true
    end)

    local Duration = Prompt.HoldDuration or 0.5

    local Success = pcall(function()
        Prompt:InputHoldBegin()
        task.wait(Duration + 0.2)
        Prompt:InputHoldEnd()
    end)

    Connection:Disconnect()

    return Success and Fired
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

    if not Hold(Prompt) then
        return nil
    end

    GoToBase()

    local Deadline = os.clock() + 8

    while Enabled and os.clock() < Deadline do
        local Animal = GetNewAnimal(AnimalSnapshot)

        if Animal then
            return Animal
        end

        task.wait(0.03)
    end

    return nil
end

local function BreakEgg(Egg, ZoneName)
    if not IsValidEgg(Egg, ZoneName) then
        return false
    end

    if not Go(Egg.Position + Vector3.new(0, 3, 0)) then
        return false
    end

    task.wait(0.05)

    if not EquipPickaxe() then
        return false
    end

    for Counter = 1, 20 do
        if not Enabled or not IsValidEgg(Egg, ZoneName) then
            return false
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

    while Enabled and os.clock() < Deadline do
        if not IsValidEgg(Egg, ZoneName) then
            return false
        end

        local Broken = Egg:GetAttribute("Broken")
        local Health = Egg:GetAttribute("Health")

        if Broken == true or (Health and Health <= 0) then
            return true
        end

        task.wait(0.03)
    end

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
            0
        )
    end)
end

local function CollectEggPets(Egg)
    local Origin = Egg.Position
    local LastPickup = nil
    local EmptySince = nil

    while Enabled do
        local Pickups = GetPickupParts(Origin)
        local Pickup = Pickups[1]

        if Pickup and Pickup ~= LastPickup then
            EmptySince = nil
            LastPickup = Pickup

            local Animal = StealPickup(Pickup)

            if Animal then
                PlaceAnimal(Animal)
                LastPickup = nil
                task.wait(0.05)
            else
                LastPickup = nil
                task.wait(0.1)
            end
        else
            if not EmptySince then
                EmptySince = os.clock()
            end

            if os.clock() - EmptySince >= 5 then
                break
            end

            task.wait(0.05)
        end
    end
end

local function FarmCycle()
    local ZoneName = SelectedZone

    local Egg = GetNextEgg(ZoneName)

    if not Egg then
        return false
    end

    if not IsValidEgg(Egg, ZoneName) then
        return false
    end

    if not BreakEgg(Egg, ZoneName) then
        return false
    end

    if not IsValidEgg(Egg, ZoneName) then
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
                task.wait(0.2)
            end
        end

        Running = false
    end)
end

UI:New("Section", {
    Parent = MainTab,
    Text = "Controls"
})

UI:New("Toggle", {
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

UI:New("Dropdown", {
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

UI:New("Slider", {
    Parent = MainTab,
    Text = "Hit Delay",
    Min = 0,
    Max = 0.5,
    Default = 0.05,
    Callback = function(Value)
        HitDelay = Value
    end
})

UI:New("Divider", {
    Parent = TeleportTab
})

UI:New("Section", {
    Parent = TeleportTab,
    Text = "Teleports"
})

UI:New("Button", {
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

    UI:New("Button", {
        Parent = TeleportTab,
        Text = "Teleport to " .. ZoneName,
        Callback = function()
            local Eggs = GetZoneEggs(ZoneName)
            local Egg = Eggs[1]

            if Egg then
                Go(Egg.Position + Vector3.new(0, 3, 0))
                Notify("Sanity.exe", "Teleported to " .. ZoneName, 3)
                return
            end

            Notify("Sanity.exe", ZoneName .. " not found", 3)
        end
    })
end

Notify("Sanity.exe", "Loaded successfully!", 3)