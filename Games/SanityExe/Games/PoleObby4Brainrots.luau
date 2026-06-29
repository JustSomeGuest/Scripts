if not game:IsLoaded() then
    game.Loaded:Wait()
end

local function Check(t, val, fb)
    if type(val) == t then
        return val
    end

    if fb ~= nil then
        if type(fb) == "function" then
            return function(...)
                warn("[Expect]: Missing executor functionality. Using fallback function.")
                return fb(...)
            end
        end

        warn("[Expect]: Value has unexpected type. Using fallback value.")
    end

    return fb
end

local CloneRef = Check("function", cloneref, function(...) return ... end)

local Services = setmetatable({}, {
    __index = function(self, name)
        local ok, c = pcall(function()
            return CloneRef(game:GetService(name))
        end)
        if ok then
            rawset(self, name, c)
            return c
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

local Players = Services.Players
local Player = Players.LocalPlayer
local Workspace = Services.Workspace
local UserInput = Services.UserInputService
local RunSvc = Services.RunService
local StarterGui = Services.StarterGui
local PlayerGui = Player:WaitForChild("PlayerGui")

local Shared = (function()
    local ok, env = pcall(getgenv)
    return (ok and env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local UI = Shared.VoidUI

if not UI then
    warn("[Sanity.exe]: Failed to load VoidUI")
    return
end

local MainTab = UI:New("Tab", {
    Text = "Main"
})

local function Alert(Title, Text, Duration, Icon)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = Title or "Sanity.exe",
            Text = Text or "",
            Duration = Duration or 4,
            Icon = Icon or nil
        })
    end)
end

local Spawns = Workspace:FindFirstChild("BrainrotSpawns")
local Mobs = Workspace:FindFirstChild("Mobs")
local Bases = Workspace:FindFirstChild("Bases")

if not Spawns then
    Spawns = Workspace:WaitForChild("BrainrotSpawns", 10)
    if not Spawns then
        Alert("Sanity.exe", "BrainrotSpawns folder not found", 4)
        return
    end
end

if not Mobs then
    Mobs = Workspace:WaitForChild("Mobs", 10)
    if not Mobs then
        Alert("Sanity.exe", "Mobs folder not found", 4)
        return
    end
end

if not Bases then
    Bases = Workspace:WaitForChild("Bases", 10)
    if not Bases then
        Alert("Sanity.exe", "Bases folder not found", 4)
        return
    end
end

local Home = nil
local Busy = false
local CarryCount = 0
local MaxCarry = 0
local HomeBase = nil

local function GetMaxCarry()
    local MainUI = PlayerGui:FindFirstChild("MainUI")
    if not MainUI then
        return 1
    end
    
    local Menus = MainUI:FindFirstChild("Menus")
    if not Menus then
        return 1
    end
    
    local UpgradeShop = Menus:FindFirstChild("UpgradeShop")
    if not UpgradeShop then
        return 1
    end
    
    local Handler = UpgradeShop:FindFirstChild("Handler")
    if not Handler then
        return 1
    end
    
    local Carry = Handler:FindFirstChild("Carry")
    if not Carry then
        return 1
    end
    
    local Stats = Carry:FindFirstChild("Stats")
    if not Stats then
        return 1
    end
    
    local Stat1 = Stats:FindFirstChild("1")
    if not Stat1 then
        return 1
    end
    
    local TextLabel = Stat1:FindFirstChild("TextLabel")
    if not TextLabel or not TextLabel:IsA("TextLabel") then
        return 1
    end
    
    local MaxCarryText = TextLabel.Text
    local Num = tonumber(MaxCarryText)
    if Num then
        return Num
    end
    
    return 1
end

local function GetRoot()
    local Char = Player.Character
    if not Char then
        return nil
    end
    return Char:FindFirstChild("HumanoidRootPart") or Char:FindFirstChild("Head")
end

local function SaveHome()
    local Root = GetRoot()
    if Root then
        Home = Root.Position
        return true
    end
    return false
end

local function Go(Pos)
    local Root = GetRoot()
    if Root then
        Root.CFrame = CFrame.new(Pos)
    end
end

local function GoHome()
    if Home then
        Go(Home)
        return true
    end
    return false
end

local function GoToBase()
    if HomeBase then
        Go(HomeBase)
        return true
    end
    return false
end

local function GoTo(Target)
    local Root = GetRoot()
    if Root and Target then
        Root.CFrame = Target.CFrame
        return true
    end
    return false
end

local function GetPos(Model)
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

local function IsOnPlate(Brainrot, Plate)
    local BrainPos = GetPos(Brainrot)
    if not BrainPos then
        return false
    end

    local PlateSize = Plate.Size
    local HalfX = PlateSize.X / 2
    local HalfY = PlateSize.Y / 2
    local HalfZ = PlateSize.Z / 2

    local Rel = Plate.CFrame:PointToObjectSpace(BrainPos)

    local CornerBuffer = 3
    local DistX = math.abs(Rel.X)
    local DistZ = math.abs(Rel.Z)

    local HeightAboveTop = Rel.Y - HalfY

    if DistX <= HalfX + CornerBuffer and DistZ <= HalfZ + CornerBuffer and HeightAboveTop >= -1 and HeightAboveTop <= 25 then
        return true
    end

    return false
end

local function GetNearest(Plate)
    local Best = nil
    local BestDist = math.huge
    local PlatePos = Plate.Position

    for _, Mob in ipairs(Mobs:GetChildren()) do
        if Mob:IsA("Model") then
            local RootPart = Mob:FindFirstChild("RootPart")
            if RootPart then
                local Prompt = RootPart:FindFirstChild("ProximityPrompt")
                if Prompt then
                    local Pos = GetPos(Mob)
                    if Pos then
                        local Dist = (Pos - PlatePos).Magnitude
                        if IsOnPlate(Mob, Plate) and Dist < BestDist then
                            BestDist = Dist
                            Best = Mob
                        end
                    end
                end
            end
        end
    end

    return Best
end

local function Hold(Prompt, Duration)
    if not Prompt then
        return false
    end

    local Fired = false
    local Con = Prompt.Triggered:Connect(function()
        Fired = true
    end)

    pcall(function()
        Prompt:InputHoldBegin()
        task.wait((Duration or Prompt.HoldDuration or 0.5) + 0.15)
        Prompt:InputHoldEnd()
    end)

    Con:Disconnect()

    return Fired
end

local function Grab(Brainrot)
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

    for _ = 1, 2 do
        local Pos = GetPos(Brainrot)
        if not Pos then
            return false
        end

        Go(Pos + Vector3.new(0, 2, 0))
        task.wait(0.25)

        if Hold(Prompt, Prompt.HoldDuration or 0.5) then
            return true
        end

        task.wait(0.15)
    end

    return false
end

local function GetMyBase()
    for _, Base in ipairs(Bases:GetChildren()) do
        local Title = Base:FindFirstChild("Title")
        if Title then
            local TitleGui = Title:FindFirstChild("TitleGui")
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

local function GetPlayerBaseHome()
    local Base = GetMyBase()
    if not Base then
        return nil
    end

    local HomePart = Base:FindFirstChild("Home")
    if HomePart then
        HomeBase = HomePart.Position
        return HomePart
    end

    return Base
end

local function GetFreeSlot()
    local Base = GetMyBase()
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

local function GetSlotPos(Slot)
    if not Slot then
        return nil
    end

    local BasePart = Slot:FindFirstChild("Base")
    if BasePart then
        return BasePart.Position
    end

    return nil
end

local function Place(Slot)
    if not Slot then
        return false
    end

    local PlacePrompt = GetPlacePrompt(Slot)
    if not PlacePrompt then
        return false
    end

    for _ = 1, 2 do
        local SlotPos = GetSlotPos(Slot)
        if not SlotPos then
            return false
        end

        Go(SlotPos + Vector3.new(0, 3, 0))
        task.wait(0.25)

        if Hold(PlacePrompt, PlacePrompt.HoldDuration or 0.5) then
            task.wait(0.5)
            return true
        end

        task.wait(0.15)
    end

    return false
end

local function Bring(Plate, TierName)
    if not Plate then
        Alert("Sanity.exe", "Waiting for terrain to spawn.", 3)
        return false
    end

    if Busy then
        return false
    end

    local Brainrot = GetNearest(Plate)
    if not Brainrot then
        Alert("Sanity.exe", "Waiting for brainrots to spawn.", 3)
        return false
    end

    Busy = true

    SaveHome()

    if not Grab(Brainrot) then
        GoHome()
        Busy = false
        return false
    end

    local Slot = GetFreeSlot()
    if not Slot then
        GoHome()
        Busy = false
        return false
    end

    if not Place(Slot) then
        GoHome()
        Busy = false
        return false
    end

    GoHome()
    Busy = false
    return true
end

local function Farm(Plate, DoPlace)
    if not Plate then
        return
    end

    if Busy then
        return
    end

    Busy = true

    if DoPlace then
        local Slot = GetFreeSlot()
        if not Slot then
            Busy = false
            return
        end
    end

    local Brainrot = GetNearest(Plate)
    if not Brainrot then
        Busy = false
        return
    end

    SaveHome()

    if not Grab(Brainrot) then
        GoHome()
        Busy = false
        return
    end

    if DoPlace then
        local Slot = GetFreeSlot()
        if Slot then
            if not Place(Slot) then
                GoHome()
                Busy = false
                return
            end
        else
            GoHome()
            Busy = false
            return
        end
    else
        CarryCount = CarryCount + 1
        MaxCarry = GetMaxCarry()
        if CarryCount >= MaxCarry then
            GoToBase()
            CarryCount = 0
            Busy = false
            return
        end
    end

    GoHome()
    Busy = false
end

local TierOrder = {
    "Common",
    "Rare",
    "Epic",
    "Legendary",
    "Mythical",
    "Secret",
    "OG",
    "Exclusive",
    "Admin"
}

local ValidTiers = {}
for _, TierName in ipairs(TierOrder) do
    local PF = Spawns:FindFirstChild(TierName)
    if PF then
        local Plate = PF:FindFirstChild("Plate")
        if Plate then
            table.insert(ValidTiers, {
                Name = TierName,
                Plate = Plate
            })
        end
    end
end

if #ValidTiers == 0 then
    warn("[Sanity.exe]: No valid spawn tiers found!")
    return
end

UI:New("Section", {
    Text = "Teleports",
    Parent = MainTab
})

UI:New("Button", {
    Text = "Teleport to Base",
    Parent = MainTab,
    Callback = function()
        local HomePart = GetPlayerBaseHome()
        if HomePart then
            GoTo(HomePart)
            Alert("Sanity.exe", "Teleported to base", 3)
        else
            Alert("Sanity.exe", "Base not found", 3)
        end
    end
})

UI:New("Divider", {
    Parent = MainTab
})

UI:New("Section", {
    Text = "Brainrots",
    Parent = MainTab
})

for i, TierData in ipairs(ValidTiers) do
    local TierName = TierData.Name
    local Plate = TierData.Plate
    local IsLast = (i == #ValidTiers)
    
    UI:New("Label", {
        Text = TierName,
        Parent = MainTab
    })
    
    UI:New("Button", {
        Text = "Grab Brainrot",
        Parent = MainTab,
        Callback = function()
            Bring(Plate, TierName)
        end
    })
    
    local On1 = false
    local Con1 = nil
    
    UI:New("Toggle", {
        Text = "AutoFarm (Grab Only)",
        Parent = MainTab,
        Default = false,
        Callback = function(State)
            On1 = State
            
            if Con1 then
                Con1:Disconnect()
                Con1 = nil
            end
            
            if State then
                Con1 = RunSvc.RenderStepped:Connect(function()
                    if On1 then
                        Farm(Plate, false)
                    end
                end)
            end
        end
    })
    
    local On2 = false
    local Con2 = nil
    
    UI:New("Toggle", {
        Text = "AutoFarm (Grab & Place)",
        Parent = MainTab,
        Default = false,
        Callback = function(State)
            On2 = State
            
            if Con2 then
                Con2:Disconnect()
                Con2 = nil
            end
            
            if State then
                Con2 = RunSvc.RenderStepped:Connect(function()
                    if On2 then
                        Farm(Plate, true)
                    end
                end)
            end
        end
    })
    
    if not IsLast then
        UI:New("Divider", {
            Parent = MainTab
        })
    end
end