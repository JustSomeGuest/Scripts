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
        return Spawn
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

local HomePos = nil
local Busy = false
local CarryCount = 0
local MaxCarry = 0
local SavedPlotPosition = nil

local function SavePlotPosition()
    local Plot = GetPlayerPlot()
    if Plot then
        local Spawn = GetPlotSpawn()
        if Spawn then
            SavedPlotPosition = Spawn.Position
        else
            SavedPlotPosition = Plot.Position + Vector3.new(0, 3, 0)
        end
        return true
    end
    return false
end

SavePlotPosition()

local function GetMaxCarry()
    local GUI = PlayerGui:FindFirstChild("GUI")
    if not GUI then
        return 1
    end
    
    local Frames = GUI:FindFirstChild("Frames")
    if not Frames then
        return 1
    end
    
    local Upgrades = Frames:FindFirstChild("Upgrades")
    if not Upgrades then
        return 1
    end
    
    local ScrollingFrame = Upgrades:FindFirstChild("ScrollingFrame")
    if not ScrollingFrame then
        return 1
    end
    
    local Carry = ScrollingFrame:FindFirstChild("Carry")
    if not Carry then
        return 1
    end
    
    local Stats = Carry:FindFirstChild("Stats")
    if not Stats then
        return 1
    end
    
    local Before = Stats:FindFirstChild("Before")
    if not Before then
        return 1
    end
    
    local TextLabel = Before:FindFirstChild("Text")
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

local function Go(Pos)
    local Root = GetRoot()
    if Root then
        Root.CFrame = CFrame.new(Pos)
    end
end

local function GoHome()
    if HomePos then
        Go(HomePos)
        return true
    end
    return false
end

local function GoToPlot()
    if SavedPlotPosition then
        Go(SavedPlotPosition + Vector3.new(0, 3, 0))
        return true
    end
    
    local Spawn = GetPlotSpawn()
    if Spawn then
        SavedPlotPosition = Spawn.Position
        Go(SavedPlotPosition + Vector3.new(0, 3, 0))
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

local function GetNearestBrainrot(TierName)
    local TierPos = TierPositions[TierName]
    if not TierPos then
        return nil
    end
    
    local TierFolder = ItemSpawners:FindFirstChild(TierName)
    if not TierFolder then
        return nil
    end
    
    local Best = nil
    local BestDist = 30

    for _, Child in ipairs(TierFolder:GetChildren()) do
        if Child:IsA("Model") then
            local Mesh = Child:FindFirstChild("Mesh")
            if Mesh then
                local Prompt = Mesh:FindFirstChild("ProximityPrompt")
                if Prompt then
                    local Pos = GetPos(Child)
                    if Pos then
                        local Dist = (Pos - TierPos).Magnitude
                        if Dist < BestDist then
                            BestDist = Dist
                            Best = Child
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

    local Mesh = Brainrot:FindFirstChild("Mesh")
    if not Mesh then
        return false
    end

    local Prompt = Mesh:FindFirstChild("ProximityPrompt")
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

local function Bring(TierName)
    local TierPos = TierPositions[TierName]
    if not TierPos then
        return false
    end

    if Busy then
        return false
    end

    local Brainrot = GetNearestBrainrot(TierName)
    if not Brainrot then
        return false
    end

    Busy = true

    if not HomePos then
        local Spawn = GetPlotSpawn()
        if Spawn then
            HomePos = Spawn.Position
        end
    end

    Go(TierPos + Vector3.new(0, 3, 0))
    task.wait(0.1)

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

local function Farm(TierName, DoPlace)
    local TierPos = TierPositions[TierName]
    if not TierPos then
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

    local Brainrot = GetNearestBrainrot(TierName)
    if not Brainrot then
        Busy = false
        return
    end

    if not HomePos then
        local Spawn = GetPlotSpawn()
        if Spawn then
            HomePos = Spawn.Position
        end
    end

    Go(TierPos + Vector3.new(0, 3, 0))
    task.wait(0.1)

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
            GoToPlot()
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
                        Farm(TierName, false)
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
                        Farm(TierName, true)
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