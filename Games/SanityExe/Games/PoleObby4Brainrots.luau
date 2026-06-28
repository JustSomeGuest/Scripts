if not game:IsLoaded() then
    game.Loaded:Wait()
end

local function check(t, val, fb)
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

local cref = check("function", cloneref, function(...) return ... end)

local svc = setmetatable({}, {
    __index = function(self, name)
        local ok, c = pcall(function()
            return cref(game:GetService(name))
        end)
        if ok then
            rawset(self, name, c)
            return c
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

local plrs = svc.Players
local plr = plrs.LocalPlayer
local ws = svc.Workspace
local uis = svc.UserInputService
local rs = svc.RunService
local sgui = svc.StarterGui
local pgui = plr:WaitForChild("PlayerGui")

local Shared = (function()
    local ok, env = pcall(getgenv)
    return (ok and env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local ui = Shared.VoidUI

if not ui then
    warn("[Sanity.exe]: Failed to load VoidUI")
    return
end

local tab = ui:New("Tab", {
    Text = "Main"
})

local function alert(t, txt, dur, icon)
    pcall(function()
        sgui:SetCore("SendNotification", {
            Title = t or "Sanity.exe",
            Text = txt or "",
            Duration = dur or 4,
            Icon = icon or nil
        })
    end)
end

local spawns = ws:FindFirstChild("BrainrotSpawns")
local mobs = ws:FindFirstChild("Mobs")
local bases = ws:FindFirstChild("Bases")

if not spawns then
    spawns = ws:WaitForChild("BrainrotSpawns", 10)
    if not spawns then
        alert("Sanity.exe", "BrainrotSpawns folder not found", 4)
        return
    end
end

if not mobs then
    mobs = ws:WaitForChild("Mobs", 10)
    if not mobs then
        alert("Sanity.exe", "Mobs folder not found", 4)
        return
    end
end

if not bases then
    bases = ws:WaitForChild("Bases", 10)
    if not bases then
        alert("Sanity.exe", "Bases folder not found", 4)
        return
    end
end

local home = nil
local busy = false
local carryCount = 0
local maxCarry = 0

local function getMaxCarry()
    local mainUI = pgui:FindFirstChild("MainUI")
    if not mainUI then
        return 1
    end
    
    local menus = mainUI:FindFirstChild("Menus")
    if not menus then
        return 1
    end
    
    local upgradeShop = menus:FindFirstChild("UpgradeShop")
    if not upgradeShop then
        return 1
    end
    
    local handler = upgradeShop:FindFirstChild("Handler")
    if not handler then
        return 1
    end
    
    local carry = handler:FindFirstChild("Carry")
    if not carry then
        return 1
    end
    
    local stats = carry:FindFirstChild("Stats")
    if not stats then
        return 1
    end
    
    local stat1 = stats:FindFirstChild("1")
    if not stat1 then
        return 1
    end
    
    local textLabel = stat1:FindFirstChild("TextLabel")
    if not textLabel or not textLabel:IsA("TextLabel") then
        return 1
    end
    
    local maxCarryText = textLabel.Text
    local num = tonumber(maxCarryText)
    if num then
        return num
    end
    
    return 1
end

local function root()
    local char = plr.Character
    if not char then
        return nil
    end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end

local function saveHome()
    local r = root()
    if r then
        home = r.Position
        return true
    end
    return false
end

local function go(pos)
    local r = root()
    if r then
        r.CFrame = CFrame.new(pos)
    end
end

local function goHome()
    if home then
        go(home)
        return true
    end
    return false
end

local function posOf(m)
    local rp = m:FindFirstChild("RootPart")
    if rp then
        return rp.Position
    end

    local pp = m.PrimaryPart
    if pp then
        return pp.Position
    end

    local hrp = m:FindFirstChild("HumanoidRootPart")
    if hrp then
        return hrp.Position
    end

    local hd = m:FindFirstChild("Head")
    if hd then
        return hd.Position
    end

    for _, c in ipairs(m:GetChildren()) do
        if c:IsA("BasePart") then
            return c.Position
        end
    end

    return nil
end

local function isOnPlate(brainrot, plate)
    local brainPos = posOf(brainrot)
    if not brainPos then
        return false
    end

    local plateSize = plate.Size
    local halfX = plateSize.X / 2
    local halfY = plateSize.Y / 2
    local halfZ = plateSize.Z / 2

    local rel = plate.CFrame:PointToObjectSpace(brainPos)

    local cornerBuffer = 3
    local distX = math.abs(rel.X)
    local distZ = math.abs(rel.Z)

    local heightAboveTop = rel.Y - halfY

    if distX <= halfX + cornerBuffer and distZ <= halfZ + cornerBuffer and heightAboveTop >= -1 and heightAboveTop <= 25 then
        return true
    end

    return false
end

local function near(plate)
    local best = nil
    local bestDist = math.huge
    local platePos = plate.Position

    for _, m in ipairs(mobs:GetChildren()) do
        if m:IsA("Model") then
            local rp = m:FindFirstChild("RootPart")
            if rp then
                local p = rp:FindFirstChild("ProximityPrompt")
                if p then
                    local pos = posOf(m)
                    if pos then
                        local d = (pos - platePos).Magnitude
                        if isOnPlate(m, plate) and d < bestDist then
                            bestDist = d
                            best = m
                        end
                    end
                end
            end
        end
    end

    return best
end

local function hold(p, dur)
    if not p then
        return false
    end

    local fired = false
    local con = p.Triggered:Connect(function()
        fired = true
    end)

    pcall(function()
        p:InputHoldBegin()
        task.wait((dur or p.HoldDuration or 0.5) + 0.15)
        p:InputHoldEnd()
    end)

    con:Disconnect()

    return fired
end

local function grab(b)
    if not b then
        return false
    end

    local rp = b:FindFirstChild("RootPart")
    if not rp then
        return false
    end

    local p = rp:FindFirstChild("ProximityPrompt")
    if not p then
        return false
    end

    for _ = 1, 2 do
        local pos = posOf(b)
        if not pos then
            return false
        end

        go(pos + Vector3.new(0, 2, 0))
        task.wait(0.25)

        if hold(p, p.HoldDuration or 0.5) then
            return true
        end

        task.wait(0.15)
    end

    return false
end

local function myBase()
    for _, b in ipairs(bases:GetChildren()) do
        local tf = b:FindFirstChild("Title")
        if tf then
            local tg = tf:FindFirstChild("TitleGui")
            if tg then
                local fr = tg:FindFirstChild("Frame")
                if fr then
                    local pn = fr:FindFirstChild("PlayerName")
                    if pn and pn:IsA("TextLabel") then
                        if pn.Text == plr.Name then
                            return b
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function freeSlot()
    local b = myBase()
    if not b then
        return nil
    end

    local slots = b:FindFirstChild("Slots")
    if not slots then
        return nil
    end

    for _, s in ipairs(slots:GetChildren()) do
        if s:IsA("Folder") or s:IsA("Model") then
            local col = s:FindFirstChild("Collect")
            if col and col:IsA("BasePart") and col.Transparency == 0 then
                local ab = s:FindFirstChild("ActiveBrainrot")
                if not ab then
                    local bp = s:FindFirstChild("Base")
                    if bp then
                        return s
                    end
                end
            end
        end
    end

    return nil
end

local function prompt(s)
    if not s then
        return nil
    end

    local bp = s:FindFirstChild("Base")
    if bp then
        local pp = bp:FindFirstChild("PlacePrompt")
        if pp and pp:IsA("ProximityPrompt") then
            return pp
        end
    end

    return nil
end

local function slotPos(s)
    if not s then
        return nil
    end

    local bp = s:FindFirstChild("Base")
    if bp then
        return bp.Position
    end

    return nil
end

local function place(s)
    if not s then
        return false
    end

    local pp = prompt(s)
    if not pp then
        return false
    end

    for _ = 1, 2 do
        local sp = slotPos(s)
        if not sp then
            return false
        end

        go(sp + Vector3.new(0, 3, 0))
        task.wait(0.25)

        if hold(pp, pp.HoldDuration or 0.5) then
            task.wait(0.5)
            return true
        end

        task.wait(0.15)
    end

    return false
end

local function bring(plate)
    if not plate then
        return false
    end

    if busy then
        return false
    end

    busy = true

    local b = near(plate)
    if not b then
        busy = false
        return false
    end

    saveHome()

    if not grab(b) then
        goHome()
        busy = false
        return false
    end

    local s = freeSlot()
    if not s then
        goHome()
        busy = false
        return false
    end

    if not place(s) then
        goHome()
        busy = false
        return false
    end

    goHome()
    busy = false
    return true
end

local function farm(plate, doPlace)
    if not plate then
        return
    end

    if busy then
        return
    end

    busy = true

    if doPlace then
        local s = freeSlot()
        if not s then
            busy = false
            return
        end
    end

    local b = near(plate)
    if not b then
        busy = false
        return
    end

    saveHome()

    if not grab(b) then
        goHome()
        busy = false
        return
    end

    if doPlace then
        local s = freeSlot()
        if s then
            if not place(s) then
                goHome()
                busy = false
                return
            end
        else
            goHome()
            busy = false
            return
        end
    else
        carryCount = carryCount + 1
        maxCarry = getMaxCarry()
        if carryCount >= maxCarry then
            goHome()
            carryCount = 0
            busy = false
            return
        end
    end

    goHome()
    busy = false
end

local tiers = {
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

local function addSection(name, last)
    local pf = spawns:FindFirstChild(name)
    if not pf then
        return
    end
    
    local plate = pf:FindFirstChild("Plate")
    if not plate then
        return
    end
    
    ui:New("Label", {
        Text = name,
        Parent = tab
    })
    
    ui:New("Button", {
        Text = "Bring Brainrot",
        Parent = tab,
        Callback = function()
            bring(plate)
        end
    })
    
    local on1 = false
    local con1 = nil
    
    ui:New("Toggle", {
        Text = "AutoFarm Brainrots (Grab Only)",
        Parent = tab,
        Default = false,
        Callback = function(state)
            on1 = state
            
            if con1 then
                con1:Disconnect()
                con1 = nil
            end
            
            if state then
                con1 = rs.RenderStepped:Connect(function()
                    if on1 then
                        farm(plate, false)
                    end
                end)
            end
        end
    })
    
    local on2 = false
    local con2 = nil
    
    ui:New("Toggle", {
        Text = "AutoFarm Brainrots (Grab & Place)",
        Parent = tab,
        Default = false,
        Callback = function(state)
            on2 = state
            
            if con2 then
                con2:Disconnect()
                con2 = nil
            end
            
            if state then
                con2 = rs.RenderStepped:Connect(function()
                    if on2 then
                        farm(plate, true)
                    end
                end)
            end
        end
    })
    
    if not last then
        ui:New("Divider", {
            Parent = tab
        })
    end
end

local total = #tiers
local n = 0

for _, name in ipairs(tiers) do
    n = n + 1
    local last = (n == total)
    
    local pf = spawns:FindFirstChild(name)
    if pf then
        local plate = pf:FindFirstChild("Plate")
        if plate then
            addSection(name, last)
        end
    end
end