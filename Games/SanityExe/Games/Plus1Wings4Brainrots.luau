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

local TeleportTab = UI:New("Tab", {
    Text = "Teleports"
})

local function Notify(Title, Text, Duration, Icon)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = Title or "Sanity.exe",
            Text = Text or "",
            Duration = Duration or 4,
            Icon = Icon or nil
        })
    end)
end

local function GetPlayerPlot()
    local Plots = Workspace:FindFirstChild("Plots")
    if not Plots then
        return nil
    end
    
    local PlayerName = Player.Name
    for _, Plot in ipairs(Plots:GetChildren()) do
        if Plot.Name == "Plot_" .. PlayerName then
            return Plot
        end
    end
    return nil
end

local function GetPlotSpawn()
    local Plot = GetPlayerPlot()
    if not Plot then
        return nil
    end
    
    local Floor1 = Plot:FindFirstChild("Floor1")
    if not Floor1 then
        return nil
    end
    
    local Spawn = Floor1:FindFirstChild("spawn")
    if Spawn then
        return Spawn.Position
    end
    
    return nil
end

local function GetFreeSlot()
    local Plot = GetPlayerPlot()
    if not Plot then
        return nil
    end
    
    for FloorNum = 1, 3 do
        local Floor = Plot:FindFirstChild("Floor" .. FloorNum)
        if Floor then
            local Slots = Floor:FindFirstChild("Slots")
            if Slots then
                for _, Slot in ipairs(Slots:GetChildren()) do
                    if Slot:IsA("Folder") or Slot:IsA("Model") then
                        local Stand = Slot:FindFirstChild("Stand")
                        if Stand then
                            local Part = Stand:FindFirstChild("Part")
                            if Part and Part:IsA("BasePart") and Part.Transparency == 0 then
                                local SpawnPrompt = Slot:FindFirstChild("Spawn")
                                if SpawnPrompt then
                                    local PlacePrompt = SpawnPrompt:FindFirstChild("ProximityPrompt")
                                    if PlacePrompt then
                                        return Slot
                                    end
                                end
                            end
                        end
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
    
    local Spawn = Slot:FindFirstChild("Spawn")
    if Spawn then
        local Prompt = Spawn:FindFirstChild("ProximityPrompt")
        if Prompt then
            return Prompt
        end
    end
    
    return nil
end

local function GetSlotPos(Slot)
    if not Slot then
        return nil
    end
    
    local Stand = Slot:FindFirstChild("Stand")
    if Stand then
        local Part = Stand:FindFirstChild("Part")
        if Part and Part:IsA("BasePart") then
            return Part.Position
        end
    end
    
    return nil
end

local ItemSpawners = Workspace:FindFirstChild("ItemSpawners")

if not ItemSpawners then
    ItemSpawners = Workspace:WaitForChild("ItemSpawners", 10)
    if not ItemSpawners then
        Notify("Sanity.exe", "ItemSpawners folder not found", 4)
        return
    end
end

local TierPositions = {
    Common = Vector3.new(34.124996185302734, -0.4796893000602722, 134.0006103515625),
    Uncommon = Vector3.new(35.00000762939453, 0.5203498005867004, 295.3023986816406),
    Rare = Vector3.new(31.67853546142578, -0.4796893000602722, 516.22607421875),
    Epic = Vector3.new(31.849994659423828, -0.4796893000602722, 824.543701171875),
    Legendary = Vector3.new(33.599998474121094, -0.4796893000602722, 1253.241455078125),
    Mythical = Vector3.new(31.324993133544922, -0.4796893000602722, 1821.6500244140625),
    Secret = Vector3.new(32.17498016357422, -0.4796893000602722, 2554.925537109375),
    Celestial = Vector3.new(35.04998779296875, -0.4796893000602722, 4051.859619140625),
    Cosmic = Vector3.new(34.04998779296875, -0.4796893000602722, 6135.2001953125),
    God = Vector3.new(32.549983978271484, -0.4796893000602722, 10007.447265625)
}

local function CleanKillParts()
    local KillParts = Workspace:FindFirstChild("KillParts")
    if KillParts then
        for _, Child in ipairs(KillParts:GetChildren()) do
            pcall(function()
                Child:Destroy()
            end)
        end
    end
end

CleanKillParts()

Workspace.ChildAdded:Connect(function(Child)
    if Child.Name == "KillParts" then
        Child.ChildAdded:Connect(function(Obj)
            pcall(function()
                Obj:Destroy()
            end)
        end)
        CleanKillParts()
    end
end)

local Busy = false
local CarryCount = 0
local MaxCarry = 1
local SavedPlotPosition = nil

local function SavePlotPosition()
    local Plot = GetPlayerPlot()
    if Plot then
        local SpawnPos = GetPlotSpawn()
        if SpawnPos then
            SavedPlotPosition = SpawnPos
        else
            SavedPlotPosition = Plot.Position + Vector3.new(0, 3, 0)
        end
        return true
    end
    return false
end

SavePlotPosition()

local function GetMaxCarry()
    local Upgrades = Player:FindFirstChild("Upgrades")
    if not Upgrades then
        return 1
    end
    
    local CarryLevel = Upgrades:FindFirstChild("CarryLevel")
    if not CarryLevel then
        return 1
    end
    
    local Value = CarryLevel.Value
    if Value and Value > 0 then
        return Value
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

local function Go(Pos)
    local Root = GetRoot()
    if Root then
        Root.CFrame = CFrame.new(Pos)
    end
end

local function GoToPlot()
    if SavedPlotPosition then
        Go(SavedPlotPosition)
        return true
    end
    
    local SpawnPos = GetPlotSpawn()
    if SpawnPos then
        SavedPlotPosition = SpawnPos
        Go(SavedPlotPosition)
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

local function GetBrainrots(TierName)
    local TierFolder = ItemSpawners:FindFirstChild(TierName)
    if not TierFolder then
        return {}
    end
    
    local Brainrots = {}
    for _, Child in ipairs(TierFolder:GetChildren()) do
        if Child:IsA("Model") then
            local Mesh = Child:FindFirstChild("Mesh")
            if Mesh then
                local Prompt = Mesh:FindFirstChild("ProximityPrompt")
                if Prompt then
                    table.insert(Brainrots, Child)
                end
            end
        end
    end
    
    return Brainrots
end

local function GetClosestBrainrot(TierName, CurrentPos)
    local Brainrots = GetBrainrots(TierName)
    if #Brainrots == 0 then
        return nil
    end
    
    local Best = nil
    local BestDist = math.huge
    
    for _, Brainrot in ipairs(Brainrots) do
        local Pos = GetPos(Brainrot)
        if Pos then
            local Dist = (Pos - CurrentPos).Magnitude
            if Dist < BestDist then
                BestDist = Dist
                Best = Brainrot
            end
        end
    end
    
    return Best
end

local function Grab(Brainrot)
    if not Brainrot then
        return false
    end

    local Mesh = Brainrot:FindFirstChild("Mesh")
    if not Mesh then
        return false
    end

    local Prompt = Mesh:FindFirstChild("ProximityPrompt")
    if not Prompt then
        return false
    end

    local Pos = GetPos(Brainrot)
    if Pos then
        Go(Pos + Vector3.new(0, 2, 0))
        task.wait(0.15)
    end

    fireproximityprompt(Prompt)
    return true
end

local function Place(Slot)
    if not Slot then
        return false
    end

    local PlacePrompt = GetPlacePrompt(Slot)
    if not PlacePrompt then
        return false
    end

    local SlotPos = GetSlotPos(Slot)
    if SlotPos then
        Go(SlotPos + Vector3.new(0, 3, 0))
        task.wait(0.15)
    end

    fireproximityprompt(PlacePrompt)
    task.wait(0.5)
    return true
end

local function Bring(TierName)
    if Busy then
        return false
    end

    local TierPos = TierPositions[TierName]
    if not TierPos then
        return false
    end

    local Brainrots = GetBrainrots(TierName)
    if #Brainrots == 0 then
        return false
    end

    Busy = true

    local Root = GetRoot()
    if Root then
        local StartPos = Root.Position
        local ClosestBrainrot = GetClosestBrainrot(TierName, StartPos)
        
        if ClosestBrainrot then
            Grab(ClosestBrainrot)
            task.wait(0.1)
            
            local Slot = GetFreeSlot()
            if Slot then
                Place(Slot)
            end
        end
    end

    GoToPlot()
    Busy = false
    return true
end

local function FarmGrabOnly(TierName)
    local TierPos = TierPositions[TierName]
    if not TierPos then
        return
    end

    if Busy then
        return
    end

    MaxCarry = GetMaxCarry()
    if CarryCount >= MaxCarry then
        GoToPlot()
        task.wait(1)
        CarryCount = 0
        return
    end

    local Brainrots = GetBrainrots(TierName)
    if #Brainrots == 0 then
        return
    end

    Busy = true

    Go(TierPos + Vector3.new(0, 3, 0))
    task.wait(0.1)

    local Root = GetRoot()
    if Root then
        local StartPos = Root.Position
        local ClosestBrainrot = GetClosestBrainrot(TierName, StartPos)
        
        if ClosestBrainrot then
            if Grab(ClosestBrainrot) then
                CarryCount = CarryCount + 1
            end
        end
    end

    GoToPlot()
    Busy = false
end

local function FarmGrabAndPlace(TierName)
    local TierPos = TierPositions[TierName]
    if not TierPos then
        return
    end

    if Busy then
        return
    end

    local Slot = GetFreeSlot()
    if not Slot then
        return
    end

    local Brainrots = GetBrainrots(TierName)
    if #Brainrots == 0 then
        return
    end

    Busy = true

    Go(TierPos + Vector3.new(0, 3, 0))
    task.wait(0.1)

    local Root = GetRoot()
    if Root then
        local StartPos = Root.Position
        local ClosestBrainrot = GetClosestBrainrot(TierName, StartPos)
        
        if ClosestBrainrot then
            if Grab(ClosestBrainrot) then
                task.wait(0.1)
                Slot = GetFreeSlot()
                if Slot then
                    Place(Slot)
                end
            end
        end
    end

    GoToPlot()
    Busy = false
end

local TierOrder = {
    "Common",
    "Uncommon",
    "Rare",
    "Epic",
    "Legendary",
    "Mythical",
    "Secret",
    "Celestial",
    "Cosmic",
    "God"
}

UI:New("Section", {
    Text = "Teleports",
    Parent = TeleportTab
})

UI:New("Button", {
    Text = "Teleport to Plot",
    Parent = TeleportTab,
    Callback = function()
        if GoToPlot() then
            Notify("Sanity.exe", "Teleported to plot", 3)
        else
            Notify("Sanity.exe", "Plot not found", 3)
        end
    end
})

for _, TierName in ipairs(TierOrder) do
    UI:New("Button", {
        Text = "Teleport to " .. TierName,
        Parent = TeleportTab,
        Callback = function()
            local Pos = TierPositions[TierName]
            if Pos then
                Go(Pos + Vector3.new(0, 3, 0))
                Notify("Sanity.exe", "Teleported to " .. TierName, 3)
            else
                Notify("Sanity.exe", "Position not found", 3)
            end
        end
    })
end

UI:New("Divider", {
    Parent = TeleportTab
})

UI:New("Section", {
    Text = "Brainrots",
    Parent = MainTab
})

local TotalTiers = #TierOrder

for i, TierName in ipairs(TierOrder) do
    local IsLast = (i == TotalTiers)
    
    UI:New("Label", {
        Text = TierName,
        Parent = MainTab
    })
    
    UI:New("Button", {
        Text = "Bring Brainrot",
        Parent = MainTab,
        Callback = function()
            Bring(TierName)
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
                        FarmGrabOnly(TierName)
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
                        FarmGrabAndPlace(TierName)
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

Notify("Sanity.exe", "Loaded successfully!", 3)