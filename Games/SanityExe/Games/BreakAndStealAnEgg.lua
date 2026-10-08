if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Env = (type(getgenv) == "function" and getgenv()) or _G

local function GetService(Name)
    local Svc = game:GetService(Name)
    return cloneref and cloneref(Svc) or Svc
end

local Players = GetService("Players")
local ReplicatedStorage = GetService("ReplicatedStorage")
local CollectionService = GetService("CollectionService")
local UserInputService = GetService("UserInputService")
local RunService = GetService("RunService")
local VirtualUser = GetService("VirtualUser")
local TeleportService = GetService("TeleportService")
local CoreGui = GetService("CoreGui")
local Workspace = GetService("Workspace")
local StarterGui = GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

local UI = Env.__Sanity.VoidUI

if not UI then
    warn("[Sanity.exe]: Failed to load VoidUI")
    return
end

local function Notify(Title, Text, Duration)
    if not pcall(function() UI:Notify(Title, Text, Duration) end) then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = Title,
                Text = Text,
                Duration = Duration
            })
        end)
    end
end

local Settings = {
    LoadTimeout = 30,
    RequireTimeout = 3,
    MaxFailures = 5,
    FailWindow = 10,
    TickDelay = 0.05,
    TpSettle = 0.2,
    GrabTimeout = 2,
    CarryGrace = 2.5,
    StandRadius = 6,
    SpeedFallback = 120,
    SkipFor = 4,
    BankTimeout = 2.5,
    HitSlice = 1.2,
    TripCost = 1,
    EggOffset = Vector3.new(0, 3, 3.5),
    PromptMatch = 30,
    BreakPickupRadius = 40,
    EquipInterval = 2,
    BuyInterval = 1.5,
    ClaimInterval = 31,
    EggInterval = 5,
    EggSpacing = 8,
    SellInterval = 4,
    EspInterval = 0.4,
    BatRange = 15,
    BatGap = 0.72,
    RejoinDelay = 5
}

local Runtime = {
    Alive = true,
    Connections = {},
    Requests = {},
    Messages = {},
    Failures = {},
    Halted = {},
    Last = {},
    Status = "Idle",
    Steals = 0,
    Broken = 0,
    Banked = 0,
    StartCash = nil,
    StartAt = os.clock(),
    HitTokens = 3,
    HitStamp = os.clock(),
    BreakSpot = nil,
    Opt = {
        AutoSteal = false,
        Take = "Upgrades Only",
        StealRarities = {},
        StealMinValue = 0,
        AutoBreak = false,
        BreakZone = "Best",
        MaxHits = 40,
        RobCarriers = false,
        AutoPlace = false,
        AutoSell = false,
        KeepRarities = {},
        AutoUpgrade = false,
        UpgradeTargets = {
            Pickaxe = true,
            Base = true,
            Trail = true,
            Treadmill = true
        },
        AutoBuyPickaxe = false,
        AutoUpgradePlot = false,
        AutoTrail = false,
        AutoTreadmill = false,
        CashReserve = 0,
        AutoClaim = false,
        AutoHatch = false,
        BatTarget = nil,
        BatLoop = false,
        BatAura = false,
        EspPickups = false,
        EspEggs = false,
        EspPlayers = false,
        EspMinRarity = "Common",
        SpeedOn = false,
        WalkSpeed = Settings.SpeedFallback,
        InfJump = false,
        Noclip = false,
        AntiAfk = false,
        AutoRejoin = false
    }
}

local Shared = ReplicatedStorage:WaitForChild("Shared", Settings.LoadTimeout)

local Modules = {
    Remote = {}
}

setmetatable(Modules.Remote, {
    __index = function(Store, Name)
        local Found = ReplicatedStorage:FindFirstChild(Name)

        if not Found then
            local Nested = ReplicatedStorage:FindFirstChild(Name, true)

            if Nested and (Nested:IsA("BaseRemoteEvent") or Nested:IsA("RemoteFunction")) then
                Found = Nested
            end
        end

        if Found then
            rawset(Store, Name, Found)
        end

        return Found
    end
})

local function LoadProtected(Module)
    local Finished = false
    local Worked = false
    local Result

    task.spawn(function()
        pcall(setthreadidentity, 2)

        local Read, Identity = pcall(getthreadidentity)

        if Read and Identity == 2 then
            Worked, Result = pcall(require, Module)
        end

        Finished = true
    end)

    local Deadline = os.clock() + Settings.RequireTimeout

    while not Finished and os.clock() < Deadline do
        task.wait(0.05)
    end

    return Worked, Result
end

local function LoadShared(Name)
    local Module = Shared and Shared:FindFirstChild(Name)

    if not Module then
        local Nested = Shared and Shared:FindFirstChild(Name, true)
        Module = Nested and Nested:IsA("ModuleScript") and Nested or nil
    end

    if not Module then
        return nil
    end

    local Worked, Result = pcall(require, Module)

    if Worked then
        return Result
    end

    local Retry, RetryResult = LoadProtected(Module)

    if Retry then
        return RetryResult
    end

    return nil
end

do
    local Library = {
        Eggs = "EggConfig",
        Rewards = "EggRewards",
        Rarity = "EggRarity",
        Pickaxe = "PickaxeConfig",
        Zones = "ZonesConfig",
        Plot = "PlotUpgradeConfig",
        Treadmill = "TreadmillUpgradeConfig",
        Trails = "TrailsConfig",
        Bat = "BatConfig",
        Speed = "SpeedConfig"
    }

    for Key, ModuleName in pairs(Library) do
        Modules[Key] = LoadShared(ModuleName)
    end

    Runtime.Opt.WalkSpeed = Modules.Speed
        and Modules.Speed.MaxWalkSpeed
        or Settings.SpeedFallback
end

Modules.Needs = {
    AutoSteal = {"Rewards"},
    AutoBreak = {"Pickaxe", "Eggs", "Rewards", "Remote.EggHitRequest"},
    RobCarriers = {"Bat", "Remote.BatHitRequest"},
    AutoPlace = {"Remote.PetsInventoryRemote"},
    AutoSell = {"Rewards", "Remote.BackpackSellRemote"},
    AutoClaim = {"Remote.IndexRemote", "Remote.OfflineRewardRemote"},
    AutoHatch = {"Remote.MergeMachineRemote"},
    AutoBuyPickaxe = {"Pickaxe"},
    AutoUpgradePlot = {"Plot"},
    AutoTrail = {"Trails"},
    AutoTreadmill = {"Treadmill"},
    SpeedOn = {"Speed"},
    EspEggs = {"Pickaxe"},
    BatLoop = {"Bat", "Remote.BatHitRequest"},
    BatAura = {"Bat", "Remote.BatHitRequest"}
}

function Modules.Missing(Name)
    for _, Path in ipairs(Modules.Needs[Name] or {}) do
        local Current = Modules

        for Part in Path:gmatch("[^.]+") do
            Current = type(Current) == "table" and Current[Part] or nil
        end

        if Current == nil then
            return Path
        end
    end

    return nil
end

local Rarities = Modules.Rarity and Modules.Rarity.Ladder() or {}
local RarityIndex = {}

for Position, RarityName in ipairs(Rarities) do
    RarityIndex[RarityName] = Position
end

local WorldZones = {}

for ZoneId, ZoneData in pairs(Modules.Zones and Modules.Zones.Zones or {}) do
    WorldZones[#WorldZones + 1] = {
        Index = ZoneId,
        Name = ZoneData.Name or ("Zone" .. ZoneId),
        Rarity = ZoneData.Rarity,
        Power = ZoneData.RequiredPower or 0
    }
end

table.sort(WorldZones, function(Left, Right)
    return Left.Index < Right.Index
end)

local RewardPool = {}

for _, Reward in ipairs(Modules.Rewards and Modules.Rewards.Pool or {}) do
    local ZoneId = Reward.Zone

    if ZoneId then
        RewardPool[ZoneId] = RewardPool[ZoneId] or {}
        RewardPool[ZoneId][#RewardPool[ZoneId] + 1] = {
            Name = Reward.Name,
            Chance = Reward.Chance or 1
        }
    end
end

local function ShortNumber(Number)
    Number = tonumber(Number) or 0

    local Units = {
        "",
        "K",
        "M",
        "B",
        "T",
        "Qa",
        "Qi",
        "Sx",
        "Sp",
        "Oc",
        "No",
        "Dc"
    }

    local Unit = 1

    while math.abs(Number) >= 1000 and Unit < #Units do
        Number /= 1000
        Unit += 1
    end

    return Unit == 1 and ("%d%s"):format(Number, Units[Unit])
        or ("%.2f%s"):format(Number, Units[Unit])
end

local function Avatar()
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not (Humanoid and Root and Humanoid.Health > 0) then
        return nil
    end

    return Character, Humanoid, Root
end

local function Bind(Signal, Handler)
    local Connection = Signal:Connect(Handler)
    Runtime.Connections[#Runtime.Connections + 1] = Connection
    return Connection
end

local function Send(Name, ...)
    local Remote = Modules.Remote[Name]

    if Remote then
        Remote:FireServer(...)
    end
end

local function GetAttr(Name, Fallback)
    local Value = LocalPlayer:GetAttribute(Name)
    return Value == nil and Fallback or Value
end

local function AvailableCash()
    return GetAttr("Cash", 0) - (Runtime.Opt.CashReserve or 0)
end

local function Warp(TargetCFrame)
    local _, _, Root = Avatar()

    if not Root then
        return false
    end

    Root.AssemblyLinearVelocity = Vector3.zero
    Root.CFrame = TargetCFrame

    return true
end

local function BaseSpeed()
    local Earned = Modules.Speed
        and Modules.Speed.SpeedPowerToWalkSpeed(GetAttr("SpeedPower", 0))
        or 0

    return math.max(Runtime.NaturalSpeed or 0, Earned)
end

local function UpdateSpeed()
    local _, Humanoid = Avatar()

    if not Humanoid then
        return
    end

    if Runtime.Opt.SpeedOn then
        if not Runtime.SpeedWritten then
            Runtime.NaturalSpeed = Humanoid.WalkSpeed
        end

        Runtime.SpeedWritten = math.max(Runtime.Opt.WalkSpeed, BaseSpeed())
        Humanoid.WalkSpeed = Runtime.SpeedWritten
    elseif Runtime.SpeedWritten then
        Runtime.SpeedWritten = nil
        Humanoid.WalkSpeed = BaseSpeed()
    end
end

local function MonitorSpeed(Humanoid)
    if Runtime.SpeedConnection then
        Runtime.SpeedConnection:Disconnect()
    end

    Runtime.SpeedWritten = nil

    Runtime.SpeedConnection = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if Humanoid.WalkSpeed == Runtime.SpeedWritten then
            return
        end

        Runtime.NaturalSpeed = Humanoid.WalkSpeed

        if Runtime.Opt.SpeedOn then
            UpdateSpeed()
        end
    end)
end

local function Collision(Enabled)
    local Character = LocalPlayer.Character

    if not Character then
        return
    end

    for _, Part in ipairs(Character:GetChildren()) do
        if Part:IsA("BasePart") then
            if Enabled then
                if Part.CanCollide then
                    Runtime.NoclipParts = Runtime.NoclipParts or {}
                    Runtime.NoclipParts[Part] = true
                    Part.CanCollide = false
                end
            elseif Runtime.NoclipParts and Runtime.NoclipParts[Part] then
                Part.CanCollide = true
            end
        end
    end

    if not Enabled then
        Runtime.NoclipParts = nil
    end
end

local Plot = {}

function Plot.GetOwned()
    local Cached = Runtime.Plot

    if Cached and Cached.Parent and Cached:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
        return Cached
    end

    local Plots = Workspace:FindFirstChild("Plots")

    if not Plots then
        return nil
    end

    for _, Candidate in ipairs(Plots:GetChildren()) do
        if Candidate:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            Runtime.Plot = Candidate
            return Candidate
        end
    end

    return nil
end

function Plot.GetHitbox()
    local Owned = Plot.GetOwned()

    if not Owned then
        return nil
    end

    local Cached = Runtime.Hitbox

    if Cached and Cached[1] == Owned and Cached[2] and Cached[2]:IsDescendantOf(Owned) then
        return Cached[2]
    end

    local Hitbox = Owned:FindFirstChild("Hitbox", true)

    Runtime.Hitbox = Hitbox and {Owned, Hitbox} or nil

    return Hitbox
end

function Plot.ReturnHome()
    local Hitbox = Plot.GetHitbox()

    if Hitbox then
        Warp(Hitbox.CFrame + Vector3.new(0, 2, 0))
    end
end

function Plot.LowestValue()
    local Cached = Runtime.FloorCache

    if Cached and os.clock() - Cached[1] < 1 then
        return Cached[2]
    end

    local Owned = Plot.GetOwned()
    local Placed = Owned and Owned:FindFirstChild("PlacedAnimals")
    local Floor = 0

    if Placed and #Placed:GetChildren() >= (Owned:GetAttribute("MaxAnimals") or math.huge) then
        Floor = math.huge

        for _, Animal in ipairs(Placed:GetChildren()) do
            Floor = math.min(
                Floor,
                Animal:GetAttribute("CashPerSecond") or 0
            )
        end
    end

    Runtime.FloorCache = {os.clock(), Floor}

    return Floor
end

function Plot.ValueFloor()
    if Runtime.Opt.Take == "Everything" then
        return -1
    end

    return Plot.LowestValue()
end

function Plot.CarryInfo()
    return GetAttr("CarryCount", 0), GetAttr("SatchelCapacity", 1)
end

function Plot.Deposit()
    local Hitbox = Plot.GetHitbox()

    if not Hitbox then
        return false
    end

    Runtime.Status = "Banking"

    local Before = Plot.CarryInfo()
    local Deadline = os.clock() + Settings.BankTimeout

    repeat
        Warp(Hitbox.CFrame + Vector3.new(0, 2, 0))
        task.wait(0.05)
    until Plot.CarryInfo() == 0 or os.clock() > Deadline

    local Finished = Plot.CarryInfo() == 0

    if Finished then
        Runtime.Banked += Before
        Runtime.BreakSpot = nil
        Runtime.Last.Banked = os.clock()
    end

    return Finished
end

local Loot = {}

function Loot.GetValue(Model)
    local AnimalName = Model:GetAttribute("AnimalName")

    if type(AnimalName) ~= "string" or not Modules.Rewards then
        return 0
    end

    local Worked, Value = pcall(
        Modules.Rewards.PlacedCashPerSecond,
        AnimalName,
        Model:GetAttribute("SizeMult") or 1,
        Model:GetAttribute("Mutation"),
        Model:GetAttribute("WeightKg"),
        Model:GetAttribute("Variant")
    )

    return Worked and Value or 0
end

function Loot.FindPrompt(Model)
    local Position = Model:GetPivot().Position
    local Closest
    local DistanceLimit = Settings.PromptMatch

    for _, Prompt in ipairs(CollectionService:GetTagged("SmartPrompt")) do
        if Prompt.Name == "StealPrompt" then
            local Anchor = Prompt.Parent

            if Anchor and Anchor:IsA("BasePart") then
                local Distance = (Anchor.Position - Position).Magnitude

                if Distance < DistanceLimit then
                    Closest = Prompt
                    DistanceLimit = Distance
                end
            end
        end
    end

    return Closest
end

function Loot.IsAllowed(Model, Value)
    local Options = Runtime.Opt

    if next(Options.StealRarities)
        and not Options.StealRarities[Model:GetAttribute("Rarity") or ""] then
        return false
    end

    return Value >= (Options.StealMinValue or 0)
end

function Loot.FindNext()
    local Folder = Workspace:FindFirstChild("AnimalPickups")

    if not Folder then
        return nil
    end

    local Floor = Plot.ValueFloor()
    local Selected
    local SelectedValue = Floor

    for _, Model in ipairs(Folder:GetChildren()) do
        local Value = Loot.GetValue(Model)

        if Value <= SelectedValue then
            continue
        end

        if os.clock() < (Runtime.Skip and Runtime.Skip[Model] or 0) then
            continue
        end

        local NearBreak = Runtime.BreakSpot
            and (Model:GetPivot().Position - Runtime.BreakSpot).Magnitude < Settings.BreakPickupRadius

        if (Runtime.Opt.AutoSteal and Loot.IsAllowed(Model, Value))
            or (Runtime.Opt.AutoBreak and NearBreak) then
            Selected = Model
            SelectedValue = Value
        end
    end

    return Selected
end

function Loot.HoldPrompt(Prompt)
    if not Prompt then
        return
    end

    pcall(function()
        Prompt:InputHoldBegin()
        task.wait((Prompt.HoldDuration or 0.5) + 0.15)
        Prompt:InputHoldEnd()
    end)
end

function Loot.OtherCarriers()
    local Total = 0

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            Total += Player:GetAttribute("CarryCount") or 0
        end
    end

    return Total
end

function Loot.WaitForCarry(Model, Before, Others)
    local Started = os.clock()
    local RemovedAt

    repeat
        task.wait(0.05)

        if Plot.CarryInfo() > Before then
            return true
        end

        if not Model.Parent then
            RemovedAt = RemovedAt or os.clock()

            if Loot.OtherCarriers() > Others then
                return false
            end
        end
    until os.clock() > (RemovedAt and RemovedAt + Settings.CarryGrace or Started + Settings.GrabTimeout)

    return false
end

function Loot.Take(Model)
    local Prompt = Loot.FindPrompt(Model)

    Runtime.Skip = Runtime.Skip or setmetatable({}, {__mode = "k"})

    if not Prompt then
        Runtime.Skip[Model] = os.clock() + Settings.SkipFor
        return false
    end

    Runtime.Status = "Stealing " .. tostring(Model:GetAttribute("AnimalName"))

    local Before = Plot.CarryInfo()
    local Others = Loot.OtherCarriers()
    local Anchor = Prompt.Parent

    if not Anchor or not Anchor:IsA("BasePart") then
        return false
    end

    Warp(CFrame.new(Anchor.Position))
    task.wait(Settings.TpSettle)

    Loot.HoldPrompt(Prompt)

    local Success = Loot.WaitForCarry(Model, Before, Others)

    if Success then
        Runtime.Steals += 1
    else
        Runtime.Skip[Model] = os.clock() + Settings.SkipFor
    end

    return Success
end

local Mining = {}

function Mining.Damage()
    return Modules.Pickaxe.GetDamage(GetAttr("PickaxeTier", 1))
end

function Mining.IsAlive(Egg)
    return Egg
        and Egg.Parent
        and not Egg:GetAttribute("Broken")
        and (Egg:GetAttribute("Health") or 0) > 0
end

function Mining.ExpectedValue(Egg)
    Runtime.EggWorth = Runtime.EggWorth or setmetatable({}, {__mode = "k"})

    local Cached = Runtime.EggWorth[Egg]

    if Cached then
        return Cached
    end

    local Zone = Egg:GetAttribute("ZoneIndex")
    local Weight = Egg:GetAttribute("WeightKg")
    local Total = 0
    local Chances = 0

    for _, Reward in ipairs(RewardPool[Zone] or {}) do
        local Worked, Value = pcall(
            Modules.Rewards.PlacedCashPerSecond,
            Reward.Name,
            nil,
            nil,
            Weight
        )

        if Worked then
            Total += Reward.Chance * Value
            Chances += Reward.Chance
        end
    end

    local Worth = Chances > 0 and Total / Chances or 0

    Runtime.EggWorth[Egg] = Worth

    return Worth
end

function Mining.Select()
    local Options = Runtime.Opt
    local Damage = Mining.Damage()
    local Floor = Plot.ValueFloor()
    local Selected
    local BestScore

    local Burst = Modules.Eggs.HitBurst
    local Cooldown = Modules.Eggs.HitCooldown
    local WantedZone = Options.BreakZone ~= "Best"
        and tonumber(tostring(Options.BreakZone):match("%d+"))
        or nil

    for _, Egg in ipairs(CollectionService:GetTagged("BreakableEgg")) do
        if not Mining.IsAlive(Egg) then
            continue
        end

        if WantedZone and Egg:GetAttribute("ZoneIndex") ~= WantedZone then
            continue
        end

        local Hits = math.ceil(
            Egg:GetAttribute("Health") / Damage
        )

        if Hits > Options.MaxHits then
            continue
        end

        local Worth = Mining.ExpectedValue(Egg)

        if Worth <= Floor then
            continue
        end

        local Score = Worth / (
            math.max(Hits - Burst, 0) * Cooldown + Settings.TripCost
        )

        if not Selected or Score > BestScore then
            Selected = Egg
            BestScore = Score
        end
    end

    return Selected
end

function Mining.Equip()
    local Character, Humanoid = Avatar()

    if not Character then
        return false
    end

    if Character:FindFirstChild("Pickaxe") then
        return true
    end

    local Tool = LocalPlayer.Backpack:FindFirstChild("Pickaxe")

    if not Tool and Modules.Pickaxe and Modules.Pickaxe.ToolName then
        Tool = LocalPlayer.Backpack:FindFirstChild(Modules.Pickaxe.ToolName)
    end

    if not Tool then
        return false
    end

    Humanoid:EquipTool(Tool)

    return true
end

function Mining.Token()
    local Now = os.clock()
    local Cooldown = Modules.Eggs.HitCooldown

    Runtime.HitTokens = math.min(
        Modules.Eggs.HitBurst,
        Runtime.HitTokens + (Now - Runtime.HitStamp) / Cooldown
    )

    Runtime.HitStamp = Now

    if Runtime.HitTokens >= 1 then
        Runtime.HitTokens -= 1
        return 0
    end

    return (1 - Runtime.HitTokens) * Cooldown
end

function Mining.Strike(Egg)
    if not Mining.Equip() then
        Runtime.Status = "No pickaxe"
        return
    end

    Runtime.Status = ("Breaking %s"):format(
        tostring(Egg:GetAttribute("EggType"))
    )

    Runtime.BreakSpot = Egg.Position

    local Remote = Modules.Remote.EggHitRequest
    local Deadline = os.clock() + Settings.HitSlice

    while Mining.IsAlive(Egg)
        and Runtime.Opt.AutoBreak
        and os.clock() < Deadline do

        Warp(CFrame.new(
            Egg.Position + Settings.EggOffset,
            Egg.Position
        ))

        local WaitFor

        repeat
            WaitFor = Mining.Token()

            if WaitFor > 0 then
                task.wait(WaitFor)
            end
        until WaitFor == 0

        if Remote then
            Remote:FireServer(Egg)
        end
    end

    if not Mining.IsAlive(Egg) then
        Runtime.Broken += 1
    end
end

local Club = {}

function Club.Equip()
    local Character, Humanoid = Avatar()

    if not Character then
        return false
    end

    if Character:FindFirstChild(Modules.Bat.ToolName) then
        return true
    end

    local Tool = LocalPlayer.Backpack:FindFirstChild(Modules.Bat.ToolName)

    if not Tool then
        return false
    end

    Humanoid:EquipTool(Tool)

    return true
end

function Club.GetRoot(Player)
    local Character = Player and Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not (Humanoid and Root and Humanoid.Health > 0) then
        return nil
    end

    return Root
end

function Club.Hit(Player, Approach)
    local Target = Club.GetRoot(Player)

    if not Target then
        return false
    end

    if os.clock() - (Runtime.Last.Bat or 0) < Settings.BatGap then
        return false
    end

    if not Club.Equip() then
        return false
    end

    if Approach then
        Warp(Target.CFrame * CFrame.new(0, 0, 3))
        task.wait(Settings.TpSettle)
    end

    Runtime.Last.Bat = os.clock()

    Send("BatHitRequest", Player)

    return true
end

function Club.FindCarrier()
    local Selected
    local Highest = 0

    for _, Player in ipairs(Players:GetPlayers()) do
        local Count = Player ~= LocalPlayer
            and (Player:GetAttribute("CarryCount") or 0)
            or 0

        if Count > Highest and Club.GetRoot(Player) then
            Selected = Player
            Highest = Count
        end
    end

    return Selected
end

function Club.Aura()
    local _, _, Root = Avatar()

    if not Root then
        return
    end

    local Range = Settings.BatRange
        * GetAttr("BatHitboxMultiplier", 1)
        + Modules.Bat.Targeting.HitTolerance

    for _, Player in ipairs(Players:GetPlayers()) do
        local Target = Player ~= LocalPlayer and Club.GetRoot(Player)

        if Target and (Target.Position - Root.Position).Magnitude <= Range then
            if Club.Hit(Player, false) then
                return
            end
        end
    end
end

local Inventory = {}

function Inventory.Tools()
    local Items = {}

    for _, Tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if Tool:IsA("Tool") and CollectionService:HasTag(Tool, "AnimalTool") then
            Items[#Items + 1] = Tool
        end
    end

    return Items
end

function Inventory.PlaceBest()
    if #Inventory.Tools() == 0 then
        return
    end

    Send("PetsInventoryRemote", "EquipBest", nil)
end

function Inventory.SellLeftovers()
    local Keep = Runtime.Opt.KeepRarities

    if Runtime.Opt.AutoPlace
        and os.clock() - (Runtime.Last.Banked or 0) < Settings.EquipInterval * 2 then
        return 0
    end

    local Floor = Runtime.Opt.AutoPlace and Plot.LowestValue() or math.huge
    local Batch = {}

    for _, Tool in ipairs(Inventory.Tools()) do
        if Keep[Tool:GetAttribute("Rarity") or ""]
            or Loot.GetValue(Tool) > Floor then
            continue
        end

        Batch[#Batch + 1] = Tool
    end

    if #Batch == 0 then
        return 0
    end

    local Remote = Modules.Remote.BackpackSellRemote

    if not Remote then
        return 0
    end

    local Worked = pcall(Remote.InvokeServer, Remote, Batch)

    return Worked and #Batch or 0
end

local Claiming = {}

function Claiming.All()
    Send("IndexRemote", "ClaimAll", nil)
    Send("OfflineRewardRemote", "Claim")

    if not Runtime.GroupClaimed then
        Send("GroupRewardRemote", "Joined")
        Send("GroupRewardRemote", "Claim")
    end

    if not Runtime.DiscordClaimed then
        Send("DiscordRewardRemote", "Verify", LocalPlayer.Name)
    end
end

function Claiming.Listen()
    local function Observe(Remote, Key)
        if not Remote then
            return
        end

        Bind(Remote.OnClientEvent, function(Type, Info)
            if Type == "State"
                and type(Info) == "table"
                and Info.Claimed then
                Runtime[Key] = true
            end
        end)

        Remote:FireServer("Get")
    end

    Observe(Modules.Remote.GroupRewardRemote, "GroupClaimed")
    Observe(Modules.Remote.DiscordRewardRemote, "DiscordClaimed")
end

local Hatching = {}

function Hatching.Tools()
    local Items = {}

    for _, Tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if Tool:IsA("Tool") and CollectionService:HasTag(Tool, "MergeEggTool") then
            Items[#Items + 1] = Tool
        end
    end

    return Items
end

function Hatching.Process()
    local Finished = 0
    local ServerTime = Workspace:GetServerTimeNow()

    for _, Egg in ipairs(CollectionService:GetTagged("MergeEggPlaced")) do
        if Egg:GetAttribute("OwnerUserId") == LocalPlayer.UserId
            and (Egg:GetAttribute("ReadyAtServerTime") or math.huge) <= ServerTime then

            Send(
                "MergeMachineRemote",
                "HatchEgg",
                Egg:GetAttribute("EggId")
            )

            Finished += 1
        end
    end

    local Tools = Hatching.Tools()
    local Hitbox = #Tools > 0 and Plot.GetHitbox()

    if not Hitbox then
        return Finished
    end

    local _, Humanoid = Avatar()

    for Index, Tool in ipairs(Tools) do
        if Humanoid then
            Humanoid:EquipTool(Tool)
        end

        local Offset = Vector3.new(
            (Index % 3 - 1) * Settings.EggSpacing,
            -Hitbox.Size.Y / 2 + 0.5,
            math.floor(Index / 3) * Settings.EggSpacing
        )

        Send(
            "MergeMachineRemote",
            "PlaceEgg",
            Tool,
            Hitbox.Position + Offset
        )

        Finished += 1

        task.wait(0.2)
    end

    return Finished
end

local Travel = {}

function Travel.ZoneNames()
    local Names = {}

    for _, Zone in ipairs(WorldZones) do
        Names[#Names + 1] = Zone.Name
    end

    return Names
end

function Travel.GoZone(Name)
    local Build = Workspace:FindFirstChild("Build")
    local Builds = Build and Build:FindFirstChild("ZoneBuilds")
    local Zone = Builds and Builds:FindFirstChild(Name)

    if not Zone then
        return
    end

    local Eggs = Zone:FindFirstChild("Eggs")
    local Spot = Eggs and Eggs:FindFirstChildWhichIsA("BasePart", true)
    local Position = Spot and Spot.Position or Zone:GetPivot().Position

    Warp(CFrame.new(Position + Vector3.new(0, 6, 0)))
end

function Travel.Destinations()
    local List = {"My Base"}
    local Booths = Workspace:FindFirstChild("Booths")

    if Booths then
        for _, Booth in ipairs(Booths:GetChildren()) do
            List[#List + 1] = Booth.Name
        end
    end

    if Workspace:FindFirstChild("EggMachine") then
        List[#List + 1] = "Egg Machine"
    end

    return List
end

function Travel.Go(Name)
    if Name == "My Base" then
        Plot.ReturnHome()
        return
    end

    local Target

    if Name == "Egg Machine" then
        Target = Workspace:FindFirstChild("EggMachine")
    else
        local Booths = Workspace:FindFirstChild("Booths")
        Target = Booths and Booths:FindFirstChild(Name)
    end

    if Target then
        Warp(CFrame.new(
            Target:GetPivot().Position + Vector3.new(0, 4, 6)
        ))
    end
end

function Travel.Player(Name)
    local Player = Players:FindFirstChild(Name or "")
    local Root = Club.GetRoot(Player)

    if Root then
        Warp(Root.CFrame * CFrame.new(0, 0, 3))
    end
end

local OverlayESP = {
    Tags = {}
}

local RarityColors = {
    Common = Color3.fromRGB(200, 200, 200),
    Uncommon = Color3.fromRGB(110, 230, 110),
    Rare = Color3.fromRGB(80, 170, 255),
    Epic = Color3.fromRGB(190, 110, 255),
    Legendary = Color3.fromRGB(255, 190, 60),
    Mythic = Color3.fromRGB(255, 80, 120)
}

function OverlayESP.Container()
    local Folder = Runtime.EspFolder

    if Folder and Folder.Parent then
        return Folder
    end

    Folder = Instance.new("Folder")
    Folder.Name = "BreakStealEggEsp"

    local Worked = pcall(function()
        Folder.Parent = gethui and gethui() or CoreGui
    end)

    if not Worked then
        Folder.Parent = LocalPlayer:WaitForChild("PlayerGui", Settings.LoadTimeout)
    end

    Runtime.EspFolder = Folder

    return Folder
end

function OverlayESP.Label(Adornee, Text, Color)
    local Tag = OverlayESP.Tags[Adornee]

    if not Tag then
        Tag = Instance.new("BillboardGui")
        Tag.AlwaysOnTop = true
        Tag.Size = UDim2.fromOffset(200, 34)
        Tag.StudsOffset = Vector3.new(0, 3, 0)
        Tag.MaxDistance = 5000

        local Label = Instance.new("TextLabel")
        Label.Name = "Text"
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.fromScale(1, 1)
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 13
        Label.TextStrokeTransparency = 0.3
        Label.Parent = Tag

        Tag.Parent = OverlayESP.Container()
        OverlayESP.Tags[Adornee] = Tag
    end

    Tag.Adornee = Adornee
    Tag.Text.Text = Text
    Tag.Text.TextColor3 = Color

    return Tag
end

function OverlayESP.Refresh()
    local Options = Runtime.Opt
    local _, _, Root = Avatar()
    local Origin = Root and Root.Position or Vector3.zero
    local Seen = {}
    local Minimum = RarityIndex[Options.EspMinRarity] or 1

    if Options.EspPickups then
        local Folder = Workspace:FindFirstChild("AnimalPickups")

        if Folder then
            for _, Model in ipairs(Folder:GetChildren()) do
                local Rarity = Model:GetAttribute("Rarity") or "Common"
                local Part = Model.PrimaryPart
                    or Model:FindFirstChildWhichIsA("BasePart", true)

                if Part and (RarityIndex[Rarity] or 1) >= Minimum then
                    Seen[Part] = true

                    OverlayESP.Label(
                        Part,
                        ("%s [%s] %.0fkg\n$%s/s · %dm"):format(
                            tostring(Model:GetAttribute("AnimalName")),
                            Rarity,
                            Model:GetAttribute("WeightKg") or 0,
                            ShortNumber(Loot.GetValue(Model)),
                            (Part.Position - Origin).Magnitude
                        ),
                        RarityColors[Rarity] or Color3.fromRGB(255, 120, 255)
                    )
                end
            end
        end
    end

    if Options.EspEggs then
        local Damage = Mining.Damage()

        for _, Egg in ipairs(CollectionService:GetTagged("BreakableEgg")) do
            if Mining.IsAlive(Egg) then
                Seen[Egg] = true

                local Hits = math.ceil(
                    Egg:GetAttribute("Health") / Damage
                )

                OverlayESP.Label(
                    Egg,
                    ("%s · Z%s\n%s HP · %d hits"):format(
                        tostring(Egg:GetAttribute("EggType")),
                        tostring(Egg:GetAttribute("ZoneIndex")),
                        ShortNumber(Egg:GetAttribute("Health")),
                        Hits
                    ),
                    Hits <= Runtime.Opt.MaxHits
                        and Color3.fromRGB(120, 255, 140)
                        or Color3.fromRGB(255, 120, 100)
                )
            end
        end
    end

    if Options.EspPlayers then
        for _, Player in ipairs(Players:GetPlayers()) do
            local PlayerRoot = Player ~= LocalPlayer and Club.GetRoot(Player)

            if PlayerRoot then
                Seen[PlayerRoot] = true

                local Carry = Player:GetAttribute("CarryCount") or 0

                OverlayESP.Label(
                    PlayerRoot,
                    ("%s · %dm%s"):format(
                        Player.DisplayName,
                        (PlayerRoot.Position - Origin).Magnitude,
                        Carry > 0
                            and ("\nCarrying " .. tostring(Player:GetAttribute("Carrying")))
                            or ""
                    ),
                    Carry > 0
                        and Color3.fromRGB(255, 200, 60)
                        or Color3.fromRGB(255, 255, 255)
                )
            end
        end
    end

    for Adornee, Tag in pairs(OverlayESP.Tags) do
        if not Seen[Adornee] or not Adornee.Parent then
            Tag:Destroy()
            OverlayESP.Tags[Adornee] = nil
        end
    end
end

function OverlayESP.Clear()
    for Adornee, Tag in pairs(OverlayESP.Tags) do
        Tag:Destroy()
        OverlayESP.Tags[Adornee] = nil
    end
end

local Connection = {}

function Connection.Rejoin()
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            LocalPlayer
        )
    end
end

function Connection.Initialize()
    Bind(LocalPlayer.Idled, function()
        if not Runtime.Opt.AntiAfk then
            return
        end

        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    Bind(UserInputService.JumpRequest, function()
        if not Runtime.Opt.InfJump then
            return
        end

        local _, Humanoid = Avatar()

        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    Bind(RunService.Stepped, function()
        if Runtime.Opt.Noclip then
            Collision(true)
        end
    end)

    Bind(LocalPlayer.CharacterAdded, function(CharacterAdded)
        Runtime.NoclipParts = nil

        local Humanoid = CharacterAdded:WaitForChild("Humanoid", 10)

        if not Humanoid then
            return
        end

        MonitorSpeed(Humanoid)
    end)

    local _, Humanoid = Avatar()

    if Humanoid then
        MonitorSpeed(Humanoid)
    end

    local Overlay = CoreGui:FindFirstChild("RobloxPromptGui")

    Overlay = Overlay and Overlay:FindFirstChild("promptOverlay")

    if Overlay then
        Bind(Overlay.ChildAdded, function(Child)
            if Child.Name ~= "ErrorPrompt"
                or not Runtime.Opt.AutoRejoin
                or Runtime.Rejoining then
                return
            end

            Runtime.Rejoining = true

            task.delay(Settings.RejoinDelay, function()
                Connection.Rejoin()
            end)
        end)
    end
end

local Upgrades = {}

function Upgrades.Pickaxe()
    local Tier = GetAttr("PickaxeTier", 1)
    local Cash = AvailableCash()
    local Best

    if not Modules.Pickaxe then
        return false
    end

    for NextTier = Tier + 1, #Modules.Pickaxe.Tiers do
        if Modules.Pickaxe.GetPrice(NextTier) > Cash then
            break
        end

        Best = NextTier
    end

    if not Best then
        return false
    end

    Send("PickaxeShopRequest", "Buy", Best)

    return true
end

function Upgrades.Plot()
    local Owned = Plot.GetOwned()

    if not Owned or not Modules.Plot then
        return false
    end

    local Cost = Modules.Plot.UpgradeCost(
        Owned:GetAttribute("PlotLevel") or 1
    )

    if not Cost or Cost > AvailableCash() then
        return false
    end

    Send("UpgradePlotRequest")

    return true
end

function Upgrades.Trail()
    if not Modules.Trails then
        return false
    end

    local Owned = {}

    for Id in tostring(GetAttr("OwnedTrails", "")):gmatch("%d+") do
        Owned[tonumber(Id)] = true
    end

    local Candidate

    for _, Trail in ipairs(Modules.Trails.Trails) do
        if not Owned[Trail.Id]
            and Trail.Price <= AvailableCash()
            and (not Candidate or Trail.Multiplier > Candidate.Multiplier) then
            Candidate = Trail
        end
    end

    local Equipped = GetAttr("EquippedTrail", 1)
    local BestOwned

    for _, Trail in ipairs(Modules.Trails.Trails) do
        if Owned[Trail.Id]
            and (not BestOwned or Trail.Multiplier > BestOwned.Multiplier) then
            BestOwned = Trail
        end
    end

    if Candidate then
        Send("TrailShopRequest", "Buy", Candidate.Id)
        task.wait(0.3)
        Send("TrailShopRequest", "Equip", Candidate.Id)
        return true
    end

    if BestOwned and BestOwned.Id ~= Equipped then
        Send("TrailShopRequest", "Equip", BestOwned.Id)
    end

    return false
end

function Upgrades.Treadmill()
    local Owned = Plot.GetOwned()

    if not Owned or not Modules.Treadmill then
        return false
    end

    if not Owned:GetAttribute("TreadmillUnlocked") then
        Send("UnlockTreadmillRequest")
        return true
    end

    local Level = Owned:GetAttribute("TreadmillLevel") or 1

    if Level >= Modules.Treadmill.MaxLevel then
        return false
    end

    if Modules.Treadmill.UpgradeCost(Level) > AvailableCash() then
        return false
    end

    Send("UpgradeTreadmillRequest")

    return true
end

function Upgrades.Sync()
    local Options = Runtime.Opt

    Options.AutoBuyPickaxe = Options.AutoUpgrade
        and Options.UpgradeTargets.Pickaxe
        and not Modules.Missing("AutoBuyPickaxe")

    Options.AutoUpgradePlot = Options.AutoUpgrade
        and Options.UpgradeTargets.Base
        and not Modules.Missing("AutoUpgradePlot")

    Options.AutoTrail = Options.AutoUpgrade
        and Options.UpgradeTargets.Trail
        and not Modules.Missing("AutoTrail")

    Options.AutoTreadmill = Options.AutoUpgrade
        and Options.UpgradeTargets.Treadmill
        and not Modules.Missing("AutoTreadmill")
end

function Upgrades.AllNow()
    local Targets = Runtime.Opt.UpgradeTargets
    local Bought = false

    if Targets.Base and not Modules.Missing("AutoUpgradePlot") and Upgrades.Plot() then
        Bought = true
    end

    if Targets.Pickaxe and not Modules.Missing("AutoBuyPickaxe") and Upgrades.Pickaxe() then
        Bought = true
    end

    if Targets.Trail and not Modules.Missing("AutoTrail") and Upgrades.Trail() then
        Bought = true
    end

    if Targets.Treadmill and not Modules.Missing("AutoTreadmill") and Upgrades.Treadmill() then
        Bought = true
    end

    if not Bought then
        Notify("Break and Steal an Egg", "Nothing to upgrade yet", 4)
    end
end

function Upgrades.Tick()
    local Options = Runtime.Opt
    local Owned = Plot.GetOwned()

    local PlotCost = Owned
        and Modules.Plot
        and Modules.Plot.UpgradeCost(Owned:GetAttribute("PlotLevel") or 1)
        or math.huge

    local PickTier = GetAttr("PickaxeTier", 1)
    local PickaxeData = Modules.Pickaxe

    local PickCost = PickaxeData
        and PickTier < #PickaxeData.Tiers
        and PickaxeData.GetPrice(PickTier + 1)
        or math.huge

    if Options.AutoUpgradePlot and PlotCost <= PickCost and Upgrades.Plot() then
        return
    end

    if Options.AutoBuyPickaxe and Upgrades.Pickaxe() then
        return
    end

    if Options.AutoUpgradePlot and Upgrades.Plot() then
        return
    end

    if Options.AutoTrail and Upgrades.Trail() then
        return
    end

    if Options.AutoTreadmill then
        Upgrades.Treadmill()
    end
end

local Automation = {}

function Automation.Return()
    local Origin = Runtime.FarmOrigin

    if not Origin then
        return
    end

    Runtime.FarmOrigin = nil
    Runtime.BreakSpot = nil

    local _, _, Root = Avatar()

    if Root
        and not (Plot.CarryInfo() > 0 and Plot.Deposit())
        and (Root.Position - Origin.Position).Magnitude > Settings.StandRadius then
        Warp(Origin)
    end

    Runtime.Status = "Idle"
end

function Automation.Rest()
    local Options = Runtime.Opt

    if not (Options.AutoSteal or Options.AutoBreak or Options.RobCarriers) then
        Runtime.Status = "Idle"
    end
end

function Automation.Step()
    local Options = Runtime.Opt

    if not (Options.AutoSteal or Options.AutoBreak or Options.RobCarriers) then
        Automation.Return()
        return
    end

    local _, _, Root = Avatar()

    if not Root then
        Runtime.Status = "Waiting for respawn"
        return
    end

    Runtime.FarmOrigin = Runtime.FarmOrigin or Root.CFrame

    local Carry, Capacity = Plot.CarryInfo()
    local Target = Carry < Capacity and Loot.FindNext() or nil

    if Carry >= Capacity
        or (Carry > 0 and not Target)
        or (GetAttr("BeingChased", false) and Carry > 0) then
        Plot.Deposit()
        return
    end

    if Target then
        Loot.Take(Target)
        return
    end

    if Options.RobCarriers then
        local Victim = Club.FindCarrier()

        if Victim then
            Runtime.Status = "Robbing " .. Victim.Name

            local VictimRoot = Club.GetRoot(Victim)

            if VictimRoot then
                Runtime.BreakSpot = VictimRoot.Position
            end

            Club.Hit(Victim, true)
            return
        end
    end

    if Options.AutoBreak then
        local Egg = Mining.Select()

        if Egg then
            Mining.Strike(Egg)
            return
        end

        Runtime.Status = "No egg beats your base"
        return
    end

    Runtime.Status = "Waiting for animals"
end

local Loop = {}

function Loop.Safe(Key, Callback)
    local Worked, Error = pcall(Callback)
    local Label = type(Key) == "table" and Key[1] or Key

    if Worked then
        Runtime.Failures[Label] = nil
        return
    end

    local Failures = Runtime.Failures
    local Streak = Failures[Label]

    if not Streak then
        Streak = {
            Count = 0,
            Since = os.clock()
        }

        Failures[Label] = Streak
    end

    Streak.Count += 1

    if Streak.Count < Settings.MaxFailures
        or os.clock() - Streak.Since < Settings.FailWindow then
        return
    end

    local Reason = tostring(Error):match("[^\n]*")

    for _, Flag in ipairs(type(Key) == "table" and Key or {Key}) do
        if Runtime.Opt[Flag] ~= true then
            continue
        end

        Failures[Label] = nil
        Runtime.Opt[Flag] = false
        Runtime.Halted[#Runtime.Halted + 1] = {
            Flag,
            Reason
        }
    end
end

function Loop.Interval(Stamp, Key, Delay, Callback)
    if os.clock() - (Runtime.Last[Stamp] or 0) < Delay then
        return
    end

    Runtime.Last[Stamp] = os.clock()

    Loop.Safe(Key, Callback)
end

function Loop.Background()
    local Options = Runtime.Opt

    if Options.AutoPlace then
        Loop.Interval(
            "Place",
            "AutoPlace",
            Settings.EquipInterval,
            Inventory.PlaceBest
        )
    end

    if Options.AutoSell then
        Loop.Interval(
            "Sell",
            "AutoSell",
            Settings.SellInterval,
            Inventory.SellLeftovers
        )
    end

    if Options.AutoBuyPickaxe
        or Options.AutoUpgradePlot
        or Options.AutoTrail
        or Options.AutoTreadmill then
        Loop.Interval(
            "Shop",
            "AutoUpgrade",
            Settings.BuyInterval,
            Upgrades.Tick
        )
    end

    if Options.AutoClaim then
        Loop.Interval(
            "Claim",
            "AutoClaim",
            Settings.ClaimInterval,
            Claiming.All
        )
    end

    if Options.EspPickups
        or Options.EspEggs
        or Options.EspPlayers then
        Loop.Interval(
            "Esp",
            "Esp",
            Settings.EspInterval,
            OverlayESP.Refresh
        )
    elseif next(OverlayESP.Tags) then
        OverlayESP.Clear()
    end
end

function Loop.Features()
    local Options = Runtime.Opt

    if Options.BatLoop and Options.BatTarget then
        Loop.Safe("BatLoop", function()
            Club.Hit(
                Players:FindFirstChild(Options.BatTarget),
                true
            )
        end)

        return
    end

    if Options.BatAura then
        Loop.Safe("BatAura", Club.Aura)
    end

    if Options.AutoHatch then
        Loop.Interval(
            "Eggs",
            "AutoHatch",
            Settings.EggInterval,
            Hatching.Process
        )
    end

    Loop.Safe(
        {"AutoSteal", "AutoBreak", "RobCarriers"},
        Automation.Step
    )
end

function Loop.Start()
    Connection.Initialize()
    Loop.Safe("Rewards", Claiming.Listen)

    task.spawn(function()
        while Runtime.Alive do
            Loop.Background()
            task.wait(0.1)
        end
    end)

    task.spawn(function()
        while Runtime.Alive do
            Loop.Features()
            task.wait(Settings.TickDelay)
        end
    end)
end

function Loop.Shutdown()
    Runtime.Alive = false

    for _, Connection in ipairs(Runtime.Connections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end

    table.clear(Runtime.Connections)

    if Runtime.SpeedConnection then
        Runtime.SpeedConnection:Disconnect()
    end

    Runtime.Opt.SpeedOn = false

    UpdateSpeed()
    Collision(false)
    OverlayESP.Clear()

    if Runtime.EspFolder then
        Runtime.EspFolder:Destroy()
    end
end

local HomeTab = UI:New("Tab", {
    Text = "Main"
})

local FarmingTab = UI:New("Tab", {
    Text = "Farming"
})

local PlotTab = UI:New("Tab", {
    Text = "Base"
})

local MovementTab = UI:New("Tab", {
    Text = "Player"
})

local EspTab = UI:New("Tab", {
    Text = "Visuals"
})

local CombatTab = UI:New("Tab", {
    Text = "Troll"
})

local OptionsTab = UI:New("Tab", {
    Text = "Settings"
})

local StatusPanel = UI:New("Section", {
    Parent = HomeTab,
    Text = "Status"
})

UI:New("Label", {
    Parent = StatusPanel,
    Text = "Break and Steal an Egg"
})

UI:New("Label", {
    Parent = StatusPanel,
    Text = "Status: Idle"
})

local StealPanel = UI:New("Section", {
    Parent = FarmingTab,
    Text = "Auto Steal"
})

UI:New("Toggle", {
    Parent = StealPanel,
    Text = "Auto Steal",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.AutoSteal = Value
    end
})

UI:New("Dropdown", {
    Parent = StealPanel,
    Text = "Take",
    Options = {
        "Upgrades Only",
        "Everything"
    },
    Default = "Upgrades Only",
    Callback = function(Value)
        Runtime.Opt.Take = Value or "Upgrades Only"
    end
})

UI:New("Input", {
    Parent = StealPanel,
    Text = "Min Cash/s",
    Placeholder = "0",
    Callback = function(Value)
        Runtime.Opt.StealMinValue = tonumber(Value) or 0
    end
})

UI:New("Button", {
    Parent = StealPanel,
    Text = "Steal Best Now",
    Callback = function()
        local Folder = Workspace:FindFirstChild("AnimalPickups")
        local Best
        local Highest = -1

        for _, Model in ipairs(Folder and Folder:GetChildren() or {}) do
            local Value = Loot.GetValue(Model)

            if Value > Highest then
                Best = Model
                Highest = Value
            end
        end

        if Best and Loot.Take(Best) then
            Plot.Deposit()
        end
    end
})

UI:New("Button", {
    Parent = StealPanel,
    Text = "Bank Now",
    Callback = function()
        Plot.Deposit()
    end
})

local BreakPanel = UI:New("Section", {
    Parent = FarmingTab,
    Text = "Auto Break"
})

UI:New("Toggle", {
    Parent = BreakPanel,
    Text = "Auto Break Eggs",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.AutoBreak = Value
    end
})

local ZoneOptions = {"Best"}

for _, Zone in ipairs(WorldZones) do
    ZoneOptions[#ZoneOptions + 1] = Zone.Name
end

UI:New("Dropdown", {
    Parent = BreakPanel,
    Text = "Zone",
    Options = ZoneOptions,
    Default = "Best",
    Callback = function(Value)
        Runtime.Opt.BreakZone = Value or "Best"
    end
})

UI:New("Slider", {
    Parent = BreakPanel,
    Text = "Max Hits Per Egg",
    Min = 1,
    Max = 200,
    Default = 40,
    Callback = function(Value)
        Runtime.Opt.MaxHits = tonumber(Value) or 40
    end
})

local RobPanel = UI:New("Section", {
    Parent = FarmingTab,
    Text = "Rob Players"
})

UI:New("Toggle", {
    Parent = RobPanel,
    Text = "Rob Carriers",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.RobCarriers = Value
    end
})

local AnimalPanel = UI:New("Section", {
    Parent = PlotTab,
    Text = "Animals"
})

UI:New("Toggle", {
    Parent = AnimalPanel,
    Text = "Auto Place Best",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.AutoPlace = Value
    end
})

UI:New("Button", {
    Parent = AnimalPanel,
    Text = "Place Best Now",
    Callback = function()
        Inventory.PlaceBest()
    end
})

local SellPanel = UI:New("Section", {
    Parent = PlotTab,
    Text = "Sell"
})

UI:New("Toggle", {
    Parent = SellPanel,
    Text = "Auto Sell Leftovers",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.AutoSell = Value
    end
})

UI:New("Button", {
    Parent = SellPanel,
    Text = "Sell All Now",
    Callback = function()
        local Count = Inventory.SellLeftovers()
        Notify("Break and Steal an Egg", "Sold " .. tostring(Count) .. " animals", 4)
    end
})

local UpgradePanel = UI:New("Section", {
    Parent = PlotTab,
    Text = "Upgrades"
})

UI:New("Toggle", {
    Parent = UpgradePanel,
    Text = "Auto Upgrade",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.AutoUpgrade = Value
        Upgrades.Sync()
    end
})

UI:New("Dropdown", {
    Parent = UpgradePanel,
    Text = "Upgrade",
    Options = {
        "Pickaxe",
        "Base",
        "Trail",
        "Treadmill"
    },
    Default = "Pickaxe",
    Callback = function(Value)
        table.clear(Runtime.Opt.UpgradeTargets)

        if type(Value) == "table" then
            for _, Name in pairs(Value) do
                Runtime.Opt.UpgradeTargets[Name] = true
            end
        elseif type(Value) == "string" then
            Runtime.Opt.UpgradeTargets[Value] = true
        end

        Upgrades.Sync()
    end
})

UI:New("Input", {
    Parent = UpgradePanel,
    Text = "Keep Cash",
    Placeholder = "0",
    Callback = function(Value)
        Runtime.Opt.CashReserve = tonumber(Value) or 0
    end
})

UI:New("Button", {
    Parent = UpgradePanel,
    Text = "Upgrade Now",
    Callback = function()
        Upgrades.AllNow()
    end
})

local HatchPanel = UI:New("Section", {
    Parent = PlotTab,
    Text = "Eggs"
})

UI:New("Toggle", {
    Parent = HatchPanel,
    Text = "Auto Hatch Eggs",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.AutoHatch = Value
    end
})

UI:New("Button", {
    Parent = HatchPanel,
    Text = "Hatch Eggs Now",
    Callback = function()
        Hatching.Process()
    end
})

local RewardPanel = UI:New("Section", {
    Parent = PlotTab,
    Text = "Rewards"
})

UI:New("Toggle", {
    Parent = RewardPanel,
    Text = "Auto Claim",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.AutoClaim = Value
    end
})

UI:New("Button", {
    Parent = RewardPanel,
    Text = "Claim Now",
    Callback = function()
        Claiming.All()
    end
})

local MovementPanel = UI:New("Section", {
    Parent = MovementTab,
    Text = "Movement"
})

UI:New("Toggle", {
    Parent = MovementPanel,
    Text = "Speed",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.SpeedOn = Value
        UpdateSpeed()
    end
})

UI:New("Slider", {
    Parent = MovementPanel,
    Text = "Walk Speed",
    Min = 16,
    Max = 300,
    Default = Runtime.Opt.WalkSpeed,
    Callback = function(Value)
        Runtime.Opt.WalkSpeed = tonumber(Value) or Runtime.Opt.WalkSpeed

        if Runtime.Opt.SpeedOn then
            UpdateSpeed()
        end
    end
})

UI:New("Toggle", {
    Parent = MovementPanel,
    Text = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.InfJump = Value
    end
})

UI:New("Toggle", {
    Parent = MovementPanel,
    Text = "Noclip",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.Noclip = Value

        if not Value then
            Collision(false)
        end
    end
})

local TravelPanel = UI:New("Section", {
    Parent = MovementTab,
    Text = "Teleport"
})

UI:New("Dropdown", {
    Parent = TravelPanel,
    Text = "Zone",
    Options = Travel.ZoneNames(),
    Callback = function(Value)
        if Value then
            Travel.GoZone(Value)
        end
    end
})

UI:New("Dropdown", {
    Parent = TravelPanel,
    Text = "Place",
    Options = Travel.Destinations(),
    Callback = function(Value)
        if Value then
            Travel.Go(Value)
        end
    end
})

local EspPanel = UI:New("Section", {
    Parent = EspTab,
    Text = "ESP"
})

UI:New("Toggle", {
    Parent = EspPanel,
    Text = "Animals",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.EspPickups = Value
    end
})

UI:New("Toggle", {
    Parent = EspPanel,
    Text = "Eggs",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.EspEggs = Value
    end
})

UI:New("Toggle", {
    Parent = EspPanel,
    Text = "Players",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.EspPlayers = Value
    end
})

UI:New("Dropdown", {
    Parent = EspPanel,
    Text = "Min Rarity",
    Options = Rarities,
    Default = Rarities[1] or "Common",
    Callback = function(Value)
        Runtime.Opt.EspMinRarity = Value or "Common"
    end
})

local CombatPanel = UI:New("Section", {
    Parent = CombatTab,
    Text = "Bat"
})

local function GetPlayerNames()
    local Names = {}

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            Names[#Names + 1] = Player.Name
        end
    end

    table.sort(Names)

    return Names
end

UI:New("Dropdown", {
    Parent = CombatPanel,
    Text = "Target",
    Options = GetPlayerNames(),
    Callback = function(Value)
        Runtime.Opt.BatTarget = Value
    end
})

UI:New("Toggle", {
    Parent = CombatPanel,
    Text = "Loop Bat Target",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.BatLoop = Value
    end
})

UI:New("Button", {
    Parent = CombatPanel,
    Text = "Bat Target Now",
    Callback = function()
        Club.Hit(
            Players:FindFirstChild(Runtime.Opt.BatTarget or ""),
            true
        )
    end
})

UI:New("Toggle", {
    Parent = CombatPanel,
    Text = "Bat Aura",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.BatAura = Value
    end
})

local SessionPanel = UI:New("Section", {
    Parent = OptionsTab,
    Text = "Session"
})

UI:New("Toggle", {
    Parent = SessionPanel,
    Text = "Anti AFK",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.AntiAfk = Value
    end
})

UI:New("Toggle", {
    Parent = SessionPanel,
    Text = "Auto Rejoin",
    Default = false,
    Callback = function(Value)
        Runtime.Opt.AutoRejoin = Value
    end
})

UI:New("Button", {
    Parent = SessionPanel,
    Text = "Rejoin Now",
    Callback = function()
        Connection.Rejoin()
    end
})

task.spawn(function()
    Loop.Start()
end)

Notify("Sanity.exe", "Loaded successfully!", 3)