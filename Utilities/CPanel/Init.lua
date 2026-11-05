if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Env = (type(getgenv) == "function" and getgenv()) or shared or _G

if Env.__CPanel and Env.__CPanel.IsLoaded then
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "CPanel",
			Text = "CPanel is already running!",
			Duration = 3,
		})
	end)
	warn("[CPanel] ignored duplicate load — already running")
	return
end

local VERSION = "1.0.0"

local WebsocketUrl = Env.CPanelWebsocket
local BlockEffects = (Env.CPanelBlockEffects == true)

local function FailBoot(message)
	warn("[CPanel] " .. message)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "CPanel",
			Text = message,
			Duration = 6,
		})
	end)
end

if type(WebsocketUrl) ~= "string" or WebsocketUrl == "" or not WebsocketUrl:match("^wss?://") then
	FailBoot("Invalid configuration: set getgenv().CPanelWebsocket = \"wss://your-websocket-url.example.com\" before loading.")
	return
end

local function GetService(name)
	local service = game:GetService(name)
	if type(cloneref) == "function" then
		local ok, ref = pcall(cloneref, service)
		if ok and ref then
			return ref
		end
	end
	return service
end

local Players = GetService("Players")
local HttpService = GetService("HttpService")
local RunService = GetService("RunService")
local TweenService = GetService("TweenService")
local SoundService = GetService("SoundService")
local StarterGui = GetService("StarterGui")
local UserInputService = GetService("UserInputService")
local ReplicatedStorage = GetService("ReplicatedStorage")
local Lighting = GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local WriteFile = (type(writefile) == "function") and writefile or nil
local ReadFile = (type(readfile) == "function") and readfile or nil
local DelFile = (type(delfile) == "function") and delfile or nil
local IsFile = (type(isfile) == "function") and isfile or nil
local IsFolder = (type(isfolder) == "function") and isfolder or nil
local MakeFolder = (type(makefolder) == "function") and makefolder or nil
local LoadAsset = (type(getcustomasset) == "function") and getcustomasset
	or ((type(getsynasset) == "function") and getsynasset) or nil

local HttpRequest = nil
do
	local candidate = (type(syn) == "table" and syn.request) or request or http_request
	if type(candidate) == "function" then
		HttpRequest = candidate
	end
end

local Hui = nil
do
	if type(gethui) == "function" then
		local ok, holder = pcall(gethui)
		if ok and holder then
			Hui = holder
		end
	end
	if not Hui then
		Hui = GetService("CoreGui")
	end
end

local WSConnect = nil
if type(WebSocket) == "table" and type(WebSocket.connect) == "function" then
	WSConnect = WebSocket.connect
elseif type(syn) == "table" and type(syn.websocket) == "function" then
	WSConnect = syn.websocket
end

if not WSConnect then
	FailBoot("Your executor does not expose the WebSocket API (WebSocket.connect).")
	return
end

local function LoadFont(weight, style, fallback)
	local ok, font = pcall(function()
		return Font.new("rbxasset://fonts/families/GothamSSm.json", weight, style or Enum.FontStyle.Normal)
	end)
	if ok and font then
		return font
	end
	return fallback
end

local F_BOLD = LoadFont(Enum.FontWeight.Bold, nil, Enum.Font.GothamBold)
local F_MED = LoadFont(Enum.FontWeight.Medium, nil, Enum.Font.GothamMedium)
local F_REG = LoadFont(Enum.FontWeight.Regular, nil, Enum.Font.Gotham)

local Themes = {
	["Default Dark"] = { BG = Color3.fromRGB(15, 15, 18), BG2 = Color3.fromRGB(22, 22, 27), BG3 = Color3.fromRGB(30, 30, 36), ACCENT = Color3.fromRGB(60, 130, 255) },
	["Midnight"]     = { BG = Color3.fromRGB(10, 10, 14), BG2 = Color3.fromRGB(18, 18, 24), BG3 = Color3.fromRGB(26, 26, 34), ACCENT = Color3.fromRGB(140, 80, 255) },
	["Amethyst"]     = { BG = Color3.fromRGB(20, 12, 24), BG2 = Color3.fromRGB(32, 20, 38), BG3 = Color3.fromRGB(42, 28, 50), ACCENT = Color3.fromRGB(170, 80, 255) },
	["Crimson"]      = { BG = Color3.fromRGB(22, 12, 14), BG2 = Color3.fromRGB(36, 20, 24), BG3 = Color3.fromRGB(46, 28, 32), ACCENT = Color3.fromRGB(230, 60, 80) },
	["Emerald"]      = { BG = Color3.fromRGB(12, 20, 16), BG2 = Color3.fromRGB(20, 34, 26), BG3 = Color3.fromRGB(28, 44, 34), ACCENT = Color3.fromRGB(46, 204, 113) },
	["Ocean"]        = { BG = Color3.fromRGB(12, 18, 26), BG2 = Color3.fromRGB(20, 30, 44), BG3 = Color3.fromRGB(28, 40, 56), ACCENT = Color3.fromRGB(0, 180, 216) },
}

local BG = Color3.fromRGB(15, 15, 18)
local BG2 = Color3.fromRGB(22, 22, 27)
local BG3 = Color3.fromRGB(30, 30, 36)
local ACCENT = Color3.fromRGB(60, 130, 255)
local BORDER = Color3.fromRGB(40, 40, 50)
local TEXT = Color3.fromRGB(230, 230, 235)
local SUBTEXT = Color3.fromRGB(140, 140, 150)
local WHITE = Color3.fromRGB(255, 255, 255)
local GREEN = Color3.fromRGB(70, 200, 130)
local RED = Color3.fromRGB(240, 90, 90)
local YELLOW = Color3.fromRGB(250, 190, 80)
local OVERLAY_BG = Color3.fromRGB(0, 0, 0)

local UI = {}
local Funcs = {}
local Net = {}
local Gui = {}
local Effects = {}
local Handlers = {}

local Settings = {
	Theme = "Default Dark",
	Transparency = 0,
	Animations = true,
	Sounds = true,
	Notifications = true,
	AutoReconnect = true,
	RefreshInterval = 5,
}

local State = {
	IsDeveloper = false,
	Participants = {},
	ParticipantMap = {},
	Selected = nil,
	SearchQuery = "",
	LastActionStatus = "Idle",
	queuedToasts = {},
	Shutdown = false,
}

Env.__CPanel = { IsLoaded = true, Version = VERSION }

function Funcs.UID(length)
	length = length or 16
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local out = {}
	for i = 1, length do
		local index = math.random(1, #chars)
		out[i] = chars:sub(index, index)
	end
	return table.concat(out)
end

function Funcs.ClampNumber(value, min, max)
	if value < min then
		return min
	end
	if value > max then
		return max
	end
	return value
end

function Funcs.ParseNumber(raw, min, max)
	if type(raw) == "number" then
		raw = tostring(raw)
	end
	if type(raw) ~= "string" then
		return nil
	end
	local cleaned = raw:gsub("rbxassetid://", ""):gsub("^%s+", ""):gsub("%s+$", "")
	if cleaned == "" or not cleaned:match("^%-?%d+%.?%d*$") then
		return nil
	end
	local number = tonumber(cleaned)
	if number == nil or number ~= number or number == math.huge or number == -math.huge then
		return nil
	end
	if min and number < min then
		return nil
	end
	if max and number > max then
		return nil
	end
	return number
end

function Funcs.ParseAssetId(raw)
	if type(raw) == "number" then
		raw = tostring(raw)
	end
	if type(raw) ~= "string" then
		return nil
	end
	local cleaned = raw:gsub("rbxassetid://", ""):gsub("^%s+", ""):gsub("%s+$", "")
	if not cleaned:match("^%d+$") then
		return nil
	end
	local id = tonumber(cleaned)
	if id == nil or id < 1 or id > 999999999999 then
		return nil
	end
	return math.floor(id)
end

function Funcs.ParseBool(raw, fallback)
	if type(raw) == "boolean" then
		return raw
	end
	return fallback
end

function Funcs.Truncate(text, maxLength)
	if type(text) ~= "string" then
		return ""
	end
	if #text <= maxLength then
		return text
	end
	return text:sub(1, maxLength - 1) .. "…"
end

function Funcs.SafeText(raw, maxLength, fallback)
	if type(raw) ~= "string" or raw == "" then
		return fallback or ""
	end
	local cleaned = raw:gsub("[\r\n\t]", " "):gsub("%s%s+", " ")
	return Funcs.Truncate(cleaned, maxLength or 64)
end

function Funcs.PrettyJSON(encoded)
	if type(encoded) ~= "string" then
		return ""
	end
	local out = {}
	local indent = 0
	local inString = false
	local escaped = false
	local length = #encoded

	local function NewLine()
		out[#out + 1] = "\n" .. string.rep("  ", indent)
	end

	local i = 1
	while i <= length do
		local char = encoded:sub(i, i)
		if inString then
			out[#out + 1] = char
			if escaped then
				escaped = false
			elseif char == "\\" then
				escaped = true
			elseif char == '"' then
				inString = false
			end
		else
			if char == '"' then
				inString = true
				out[#out + 1] = char
			elseif char == "{" or char == "[" then
				indent = indent + 1
				out[#out + 1] = char
				NewLine()
			elseif char == "}" or char == "]" then
				indent = indent - 1
				local last = out[#out]
				if type(last) == "string" and last:sub(1, 1) == "\n" then
					table.remove(out)
				else
					NewLine()
				end
				out[#out + 1] = char
			elseif char == "," then
				out[#out + 1] = char
				NewLine()
			elseif char == ":" then
				out[#out + 1] = ": "
			elseif char ~= " " and char ~= "\t" and char ~= "\n" and char ~= "\r" then
				out[#out + 1] = char
			end
		end
		i = i + 1
	end
	return table.concat(out)
end

function Funcs.EnsureFolder(name)
	if not IsFolder or not MakeFolder then
		return false
	end
	local ok, result = pcall(function()
		if not IsFolder(name) then
			MakeFolder(name)
		end
		return true
	end)
	return ok and result == true
end

local Assets = {
	["CPanel/CPN_Logo.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Utilities/CPanel/Logo.png",
}

local function LooksLikePNG(body)
	if type(body) ~= "string" or #body < 8 then
		return false
	end
	return body:sub(1, 8) == string.char(137) .. "PNG" .. string.char(13, 10, 26, 10)
end

function Funcs.GetAsset(path)
	if type(path) ~= "string" or path == "" then
		return nil
	end
	if path:match("^rbxasset") then
		return path
	end
	local url = Assets[path]
	if not url then
		return nil
	end
	if IsFile and IsFile(path) then
		if LoadAsset then
			local ok, asset = pcall(LoadAsset, path)
			if ok and asset then
				return asset
			end
		end
	end
	if not (HttpRequest and WriteFile and LoadAsset) then
		return url
	end
	Funcs.EnsureFolder("CPanel")
	local ok, response = pcall(function()
		return HttpRequest({ Url = url, Method = "GET" })
	end)
	if ok and response and type(response.Body) == "string" and LooksLikePNG(response.Body) then
		local wrote = pcall(WriteFile, path, response.Body)
		if wrote then
			local assetOk, asset = pcall(LoadAsset, path)
			if assetOk and asset then
				return asset
			end
		end
	end
	return url
end

local SETTINGS_PATH = "CPanel/Settings.json"
local REFRESH_CHOICES = { 2, 5, 10, 30 }

local function ValidateThemeName(name)
	if type(name) == "string" and Themes[name] then
		return name
	end
	return Settings.Theme
end

function Funcs.ValidateSettings(candidate)
	if type(candidate) ~= "table" then
		return
	end
	Settings.Theme = ValidateThemeName(candidate.Theme)
	if type(candidate.Transparency) == "number" then
		Settings.Transparency = Funcs.ClampNumber(candidate.Transparency, 0, 0.5)
	end
	Settings.Animations = Funcs.ParseBool(candidate.Animations, Settings.Animations)
	Settings.Sounds = Funcs.ParseBool(candidate.Sounds, Settings.Sounds)
	Settings.Notifications = Funcs.ParseBool(candidate.Notifications, Settings.Notifications)
	Settings.AutoReconnect = Funcs.ParseBool(candidate.AutoReconnect, Settings.AutoReconnect)
	if type(candidate.RefreshInterval) == "number" then
		local found = false
		for _, choice in ipairs(REFRESH_CHOICES) do
			if choice == candidate.RefreshInterval then
				found = true
			end
		end
		if found then
			Settings.RefreshInterval = candidate.RefreshInterval
		end
	end
end

function Funcs.LoadSettings()
	if not (ReadFile and IsFile) then
		return
	end
	local okRead, content = pcall(function()
		if not IsFile(SETTINGS_PATH) then
			return nil
		end
		return ReadFile(SETTINGS_PATH)
	end)
	if not okRead or type(content) ~= "string" or content == "" then
		return
	end
	local okDecode, decoded = pcall(function()
		return HttpService:JSONDecode(content)
	end)
	if okDecode and type(decoded) == "table" then
		Funcs.ValidateSettings(decoded)
	end
end

function Funcs.SaveSettings()
	if not WriteFile then
		return false
	end
	Funcs.EnsureFolder("CPanel")
	local payload = {
		Theme = Settings.Theme,
		Transparency = Settings.Transparency,
		Animations = Settings.Animations,
		Sounds = Settings.Sounds,
		Notifications = Settings.Notifications,
		AutoReconnect = Settings.AutoReconnect,
		RefreshInterval = Settings.RefreshInterval,
	}
	local okEncode, encoded = pcall(function()
		return HttpService:JSONEncode(payload)
	end)
	if not okEncode then
		return false
	end
	local okWrite = pcall(WriteFile, SETTINGS_PATH, Funcs.PrettyJSON(encoded) .. "\n")
	return okWrite
end

function Funcs.ResetSettings()
	Settings.Theme = "Default Dark"
	Settings.Transparency = 0
	Settings.Animations = true
	Settings.Sounds = true
	Settings.Notifications = true
	Settings.AutoReconnect = true
	Settings.RefreshInterval = 5
	if DelFile and IsFile and IsFile(SETTINGS_PATH) then
		pcall(DelFile, SETTINGS_PATH)
	end
end

local UI_SOUNDS = {
	ping = "rbxasset://sounds/electronicpingshort.wav",
}

local SoundPool = {}

function Funcs.PlaySound(kind, volume)
	if not Settings.Sounds then
		return
	end
	local path = UI_SOUNDS[kind] or UI_SOUNDS.ping
	local sound = SoundPool[kind]
	if not sound then
		local ok, created = pcall(function()
			local instance = Instance.new("Sound")
			instance.Name = "CPN_UI_" .. kind
			instance.SoundId = path
			instance.Parent = SoundService
			return instance
		end)
		if not ok then
			return
		end
		sound = created
		SoundPool[kind] = sound
	end
	pcall(function()
		sound.Volume = volume or 0.25
		sound:Play()
	end)
end

function Funcs.Notify(title, text, kind)
	if not State.IsDeveloper then
		return
	end
	if not Settings.Notifications then
		return
	end
	local entry = {
		title = Funcs.SafeText(title, 40, "CPanel"),
		text = Funcs.SafeText(text, 160, ""),
		kind = kind or "info",
	}
	if UI.ToastHost and UI.ToastHost.Parent then
		Gui.PushToast(entry)
	else
		State.queuedToasts[#State.queuedToasts + 1] = entry
		if #State.queuedToasts > 6 then
			table.remove(State.queuedToasts, 1)
		end
	end
	if kind == "success" then
		Funcs.PlaySound("ping", 0.18)
	elseif kind == "error" then
		Funcs.PlaySound("ping", 0.3)
	end
end

local MIN_DURATION = 0.2
local MAX_DURATION = 120
local DEFAULT_DURATION = 5
local FLASH_DURATION = 0.6
local MAX_ACTIVE_SOUNDS = 5

function Funcs.EffectDuration(raw, fallback)
	local value = Funcs.ParseNumber(raw, 0, 3600)
	if not value or value <= 0 then
		return fallback or DEFAULT_DURATION
	end
	return Funcs.ClampNumber(value, MIN_DURATION, MAX_DURATION)
end

function Effects.Register(category, name, duration, cleanup)
	Effects.StopByName(category, name, "replaced")
	Effects.seq = (Effects.seq or 0) + 1
	local entry = {
		id = Effects.seq,
		category = category,
		name = name,
		startedAt = os.clock(),
		duration = duration or 0,
		cleanup = cleanup,
		active = true,
	}
	Effects.entries = Effects.entries or {}
	Effects.entries[entry.id] = entry
	if entry.duration > 0 then
		task.delay(entry.duration, function()
			Effects.StopById(entry.id, "expired")
		end)
	end
	return entry.id
end

function Effects.StopById(id, reason)
	local entries = Effects.entries
	if not entries then
		return
	end
	local entry = entries[id]
	if not entry or not entry.active then
		return
	end
	entry.active = false
	entry.stoppedReason = reason or "stopped"
	entries[id] = nil
	if type(entry.cleanup) == "function" then
		pcall(entry.cleanup)
	end
end

function Effects.CollectWhere(predicate)
	local ids = {}
	local entries = Effects.entries
	if not entries then
		return ids
	end
	for id, entry in pairs(entries) do
		if predicate(entry) then
			ids[#ids + 1] = id
		end
	end
	return ids
end

function Effects.StopWhere(predicate, reason)
	local ids = Effects.CollectWhere(predicate)
	for _, id in ipairs(ids) do
		Effects.StopById(id, reason)
	end
	return #ids
end

function Effects.StopByName(category, name, reason)
	return Effects.StopWhere(function(entry)
		return entry.category == category and entry.name == name
	end, reason)
end

function Effects.StopCategory(category, reason)
	return Effects.StopWhere(function(entry)
		return entry.category == category
	end, reason)
end

function Effects.Counts()
	local counts = { audio = 0, visual = 0, fun = 0 }
	for _, entry in pairs(Effects.entries or {}) do
		if counts[entry.category] ~= nil then
			counts[entry.category] = counts[entry.category] + 1
		end
	end
	return counts
end

function Effects.Describe()
	local counts = Effects.Counts()
	return string.format("effects active — audio %d, visual %d, fun %d", counts.audio, counts.visual, counts.fun)
end

local function GetCamera()
	return workspace.CurrentCamera
end

local function GetCharacter()
	local character = LocalPlayer.Character
	if not character then
		return nil
	end
	return character, character:FindFirstChild("HumanoidRootPart"), character:FindFirstChildOfClass("Humanoid")
end

local function MakeOverlayGui(name)
	local gui = Instance.new("ScreenGui")
	gui.Name = name .. "_" .. Funcs.UID(6)
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 3000
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = Hui
	return gui
end

local function CharacterBoundCleanup(character, instance, connection)
	return function()
		if connection then
			pcall(function()
				connection:Disconnect()
			end)
			connection = nil
		end
		pcall(function()
			instance:Destroy()
		end)
	end
end

local function ListenCharacterRemoval(character, instance)
	local connection
	connection = LocalPlayer.CharacterRemoving:Connect(function(removing)
		if removing == character and connection then
			pcall(function()
				connection:Disconnect()
			end)
			connection = nil
			pcall(function()
				instance:Destroy()
			end)
		end
	end)
	return connection
end

local function ArgColor(args, fallbackR, fallbackG, fallbackB)
	local r = Funcs.ParseNumber(args.r, 0, 255) or fallbackR
	local g = Funcs.ParseNumber(args.g, 0, 255) or fallbackG
	local b = Funcs.ParseNumber(args.b, 0, 255) or fallbackB
	return Color3.fromRGB(r, g, b)
end

local function SpawnSingleton(className, parent, props, category, name, duration)
	local instance = Instance.new(className)
	instance.Name = "CPN_" .. name
	for key, value in pairs(props) do
		pcall(function()
			instance[key] = value
		end)
	end
	instance.Parent = parent
	Effects.Register(category, name, duration, function()
		pcall(function()
			instance:Destroy()
		end)
	end)
	return instance
end

local Audio = {
	sounds = {},
	current = nil,
	seq = 0,
	DefaultVolume = 1.00,
}

local function WaitForSoundLoad(sound, timeout)
	local deadline = os.clock() + (timeout or 5)
	while os.clock() < deadline do
		local okLoaded, loaded = pcall(function()
			return sound.IsLoaded
		end)
		if okLoaded and loaded == true then
			return true
		end
		local okTime, timeLength = pcall(function()
			return sound.TimeLength
		end)
		if okTime and type(timeLength) == "number" and timeLength > 0 then
			return true
		end
		task.wait(0.1)
	end
	return false
end

local function CountSounds()
	local count = 0
	for _ in pairs(Audio.sounds) do
		count = count + 1
	end
	return count
end

function Audio.DestroySound(sound)
	if Audio.current == sound then
		Audio.current = nil
	end
	Audio.sounds[sound] = nil
	pcall(function()
		sound:Stop()
	end)
	pcall(function()
		sound:Destroy()
	end)
end

function Audio.StopByKey(key)
	local stopped = Effects.StopByName("audio", key, "stopped")
	if stopped == 0 then
		for sound, entry in pairs(Audio.sounds) do
			if sound.Name == key then
				Audio.DestroySound(sound)
				stopped = 1
			end
		end
	end
	return stopped > 0
end

function Audio.Play(args)
	local assetId = Funcs.ParseAssetId(args.assetId)
	if not assetId then
		return false, "invalid audio asset id (use a numeric Roblox asset id)"
	end
	local volume = Funcs.ParseNumber(args.volume, 0.1, 10)
	if not volume then
		return false, "volume must be between 0.10 and 10.00"
	end
	if BlockEffects then
		return false, "participant has blocked CPanel effects"
	end

	while CountSounds() >= MAX_ACTIVE_SOUNDS do
		local oldest, oldestAt = nil, math.huge
		for sound, entry in pairs(Audio.sounds) do
			local marker = entry.playedAt or 0
			if marker < oldestAt then
				oldest, oldestAt = sound, marker
			end
		end
		if not oldest then
			break
		end
		Audio.StopByKey(oldest.Name)
	end

	Audio.seq = Audio.seq + 1
	local sound = Instance.new("Sound")
	sound.Name = "CPN_Sound_" .. Audio.seq
	sound.SoundId = "rbxassetid://" .. assetId
	sound.Volume = volume
	sound.Looped = (args.loop == true)
	sound.Parent = SoundService

	local loaded = WaitForSoundLoad(sound, 5)
	if not loaded then
		pcall(function()
			sound:Destroy()
		end)
		return false, "audio asset unavailable or restricted (id " .. tostring(assetId) .. ")"
	end

	pcall(function()
		sound:Play()
	end)

	Audio.sounds[sound] = {
		assetId = assetId,
		volume = volume,
		looped = sound.Looped,
		playedAt = os.clock(),
	}
	Audio.current = sound

	local entry = Audio.sounds[sound]
	Effects.Register("audio", sound.Name, 0, function()
		Audio.DestroySound(sound)
	end)

	local status = string.format("playing asset %d at volume %.2f", assetId, volume)
	if entry.looped then
		status = status .. " (looped)"
	end
	return true, status
end

function Audio.StopCurrent()
	if not Audio.current or not Audio.sounds[Audio.current] then
		return false, "no active CPanel sound"
	end
	local name = Audio.current.Name
	Audio.StopByKey(name)
	return true, "sound stopped"
end

function Audio.SetLoop(enabled)
	if not Audio.current or not Audio.sounds[Audio.current] then
		return false, "no active CPanel sound"
	end
	local sound = Audio.current
	pcall(function()
		sound.Looped = enabled == true
	end)
	Audio.sounds[sound].looped = (enabled == true)
	return true, enabled and "loop enabled" or "loop disabled"
end

function Audio.SetVolume(rawVolume)
	local volume = Funcs.ParseNumber(rawVolume, 0.1, 10)
	if not volume then
		return false, "volume must be between 0.10 and 10.00"
	end
	if not Audio.current or not Audio.sounds[Audio.current] then
		return false, "no active CPanel sound"
	end
	pcall(function()
		Audio.current.Volume = volume
	end)
	Audio.sounds[Audio.current].volume = volume
	return true, string.format("volume set to %.2f", volume)
end

function Audio.RestoreVolume()
	local count = 0
	for sound, entry in pairs(Audio.sounds) do
		pcall(function()
			sound.Volume = Audio.DefaultVolume
		end)
		entry.volume = Audio.DefaultVolume
		count = count + 1
	end
	if count == 0 then
		return false, "no active CPanel sound"
	end
	return true, string.format("restored %d sound(s) to volume %.2f", count, Audio.DefaultVolume)
end

function Audio.StopAll()
	local count = 0
	for sound in pairs(Audio.sounds) do
		count = count + 1
	end
	Effects.StopCategory("audio", "stopped")
	if count == 0 then
		return false, "no active CPanel sounds"
	end
	return true, string.format("stopped %d CPanel sound(s)", count)
end

function Audio.Status()
	local count = CountSounds()
	if count == 0 then
		return "no active sounds"
	end
	local current = Audio.current
	if not current or not Audio.sounds[current] then
		return string.format("%d active sound(s)", count)
	end
	local entry = Audio.sounds[current]
	local playing = false
	pcall(function()
		playing = current.Playing
	end)
	return string.format(
		"%d active sound(s) — current: asset %d, volume %.2f, %s, %s",
		count,
		entry.assetId,
		entry.volume,
		entry.looped and "looped" or "once",
		playing and "playing" or "stopped"
	)
end

local Visual = {}

do
	local camera = GetCamera()
	Visual.fovDefault = (camera and camera.FieldOfView) or 70
	pcall(function()
		Visual.zoomDefaultMin = LocalPlayer.CameraMinZoomDistance
		Visual.zoomDefaultMax = LocalPlayer.CameraMaxZoomDistance
	end)
	Visual.zoomDefaultMin = Visual.zoomDefaultMin or 0.5
	Visual.zoomDefaultMax = Visual.zoomDefaultMax or 12.5
end

function Visual.ScreenFlash(rawDuration)
	local duration = Funcs.EffectDuration(rawDuration, FLASH_DURATION)
	local gui = MakeOverlayGui("CPN_Flash")
	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = WHITE
	frame.BorderSizePixel = 0
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 0
	frame.Parent = gui
	Effects.Register("visual", "flash", duration, function()
		pcall(function()
			gui:Destroy()
		end)
	end)
	pcall(function()
		TweenService:Create(
			frame,
			TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundTransparency = 1 }
		):Play()
	end)
	return true, string.format("screen flash for %.1fs", duration)
end

function Visual.ColorEffect(args)
	local color = ArgColor(args, 255, 255, 255)
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	SpawnSingleton("ColorCorrectionEffect", Lighting, { TintColor = color, Contrast = 0.05 }, "visual", "color_effect", duration)
	return true, string.format("color effect applied for %.0fs", duration)
end

function Visual.Blur(args)
	local intensity = Funcs.ParseNumber(args.intensity, 1, 56) or 24
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	SpawnSingleton("BlurEffect", Lighting, { Size = intensity }, "visual", "blur", duration)
	return true, string.format("blur (%d) applied for %.0fs", math.floor(intensity), duration)
end

function Visual.FovShift(args, direction)
	local camera = GetCamera()
	if not camera then
		return false, "camera unavailable"
	end
	local amount = Funcs.ParseNumber(args.amount, 1, 80) or 30
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	local target = Funcs.ClampNumber(camera.FieldOfView + (direction * amount), 20, 120)
	camera.FieldOfView = target
	Effects.Register("visual", "fov", duration, function()
		local live = GetCamera()
		if live then
			pcall(function()
				live.FieldOfView = Visual.fovDefault
			end)
		end
	end)
	return true, string.format("FOV set to %d (restores to %d in %.0fs)", math.floor(target), math.floor(Visual.fovDefault), duration)
end

function Visual.FovReset()
	Effects.StopByName("visual", "fov", "reset")
	local camera = GetCamera()
	if not camera then
		return false, "camera unavailable"
	end
	pcall(function()
		camera.FieldOfView = Visual.fovDefault
	end)
	return true, string.format("FOV reset to %d", math.floor(Visual.fovDefault))
end

function Visual.Grayscale(args)
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	SpawnSingleton("ColorCorrectionEffect", Lighting, { Saturation = -1 }, "visual", "grayscale", duration)
	return true, string.format("grayscale applied for %.0fs", duration)
end

function Visual.InvertColors(args)
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	local ok = pcall(function()
		SpawnSingleton("ColorCorrectionEffect", Lighting, {
			TintColor = Color3.new(-1, -1, -1),
			Brightness = 1,
			Contrast = 0,
			Saturation = 0,
		}, "visual", "invert", duration)
	end)
	if not ok then
		return false, "renderer rejected the color inversion"
	end
	return true, string.format("color inversion applied for %.0fs (renderer approximation)", duration)
end

function Visual.ScreenTint(args)
	local color = ArgColor(args, 255, 60, 60)
	local transparency = Funcs.ParseNumber(args.transparency, 0, 0.95) or 0.75
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	local gui = MakeOverlayGui("CPN_Tint")
	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = color
	frame.BackgroundTransparency = transparency
	frame.BorderSizePixel = 0
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Parent = gui
	Effects.Register("visual", "tint", duration, function()
		pcall(function()
			gui:Destroy()
		end)
	end)
	return true, string.format("screen tint applied for %.0fs", duration)
end

function Visual.Restore()
	local count = Effects.StopCategory("visual", "restored")
	local camera = GetCamera()
	if camera then
		pcall(function()
			camera.FieldOfView = Visual.fovDefault
		end)
	end
	if count == 0 then
		return true, "no active visual effects (FOV restored)"
	end
	return true, string.format("restored %d visual effect(s)", count)
end

local Fun = {}

function Fun.Highlight(args, outlineOnly)
	local character = GetCharacter()
	if not character then
		return false, "character not available"
	end
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	local name = outlineOnly and "outline" or "highlight"

	local highlight = Instance.new("Highlight")
	highlight.Name = "CPN_" .. name
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	if outlineOnly then
		highlight.FillTransparency = 1
		highlight.OutlineColor = ArgColor(args, 255, 255, 255)
		highlight.OutlineTransparency = 0
	else
		highlight.FillColor = ArgColor(args, 60, 130, 255)
		highlight.FillTransparency = 0.4
		highlight.OutlineColor = WHITE
		highlight.OutlineTransparency = 0
	end
	highlight.Parent = character

	local connection = ListenCharacterRemoval(character, highlight)
	Effects.Register("fun", name, duration, CharacterBoundCleanup(character, highlight, connection))
	return true, string.format("%s applied for %.0fs", outlineOnly and "outline" or "highlight", duration)
end

function Fun.Nameplate(args)
	local character, _, humanoid = GetCharacter()
	if not character or not humanoid then
		return false, "character not available"
	end
	local head = character:FindFirstChild("Head")
	if not head then
		return false, "character head not available"
	end
	local text = Funcs.SafeText(args.text, 48, "★ CPanel ★")
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "CPN_Nameplate"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 190, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 2.6, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 60

	local plate = Instance.new("Frame")
	plate.BackgroundColor3 = ACCENT
	plate.BorderSizePixel = 0
	plate.Size = UDim2.new(1, 0, 1, 0)
	plate.Parent = billboard
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = plate

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -12, 1, 0)
	label.Position = UDim2.new(0, 6, 0, 0)
	label.FontFace = F_BOLD
	label.TextSize = 14
	label.TextColor3 = WHITE
	label.Text = text
	label.Parent = plate

	billboard.Parent = head
	local connection = ListenCharacterRemoval(character, billboard)
	Effects.Register("fun", "nameplate", duration, CharacterBoundCleanup(character, billboard, connection))
	return true, string.format("nameplate \"%s\" shown for %.0fs", text, duration)
end

function Fun.OverheadNotify(args)
	local character = GetCharacter()
	if not character then
		return false, "character not available"
	end
	local head = character:FindFirstChild("Head")
	if not head then
		return false, "character head not available"
	end
	local text = Funcs.SafeText(args.text, 48, "CPanel was here!")
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "CPN_Overhead"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 220, 0, 46)
	billboard.StudsOffset = Vector3.new(0, 3.6, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 80

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 1, 0)
	label.FontFace = F_BOLD
	label.TextSize = 20
	label.TextColor3 = YELLOW
	label.TextStrokeColor3 = OVERLAY_BG
	label.TextStrokeTransparency = 0.3
	label.Text = text
	label.Parent = billboard

	billboard.Parent = head
	pcall(function()
		TweenService:Create(label, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			TextTransparency = 0,
			TextStrokeTransparency = 0.3,
		}):Play()
		TweenService:Create(billboard, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 230, 0, 50),
		}):Play()
	end)

	local connection = ListenCharacterRemoval(character, billboard)
	Effects.Register("fun", "overhead", duration, CharacterBoundCleanup(character, billboard, connection))
	return true, string.format("overhead notification shown for %.0fs", duration)
end

function Fun.Vignette(args)
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	local gui = MakeOverlayGui("CPN_Vignette")

	local function AddEdge(size, position, rotation)
		local edge = Instance.new("Frame")
		edge.BackgroundColor3 = OVERLAY_BG
		edge.BorderSizePixel = 0
		edge.Size = size
		edge.Position = position
		edge.Parent = gui
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new(OVERLAY_BG)
		gradient.Rotation = rotation
		gradient.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1),
		})
		gradient.Parent = edge
	end

	AddEdge(UDim2.new(1, 0, 0.16, 0), UDim2.new(0, 0, 0, 0), 90)
	AddEdge(UDim2.new(1, 0, 0.16, 0), UDim2.new(0, 0, 1, 0), 270)
	AddEdge(UDim2.new(0.14, 0, 1, 0), UDim2.new(0, 0, 0, 0), 0)
	AddEdge(UDim2.new(0.14, 0, 1, 0), UDim2.new(1, 0, 0, 0), 180)

	Effects.Register("fun", "vignette", duration, function()
		pcall(function()
			gui:Destroy()
		end)
	end)
	return true, string.format("screen vignette applied for %.0fs", duration)
end

function Fun.CameraShake(args)
	local camera = GetCamera()
	if not camera then
		return false, "camera unavailable"
	end
	local intensity = Funcs.ParseNumber(args.intensity, 0.02, 1) or 0.15
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	local bindName = "CPN_Shake_" .. Funcs.UID(8)

	local okBind = pcall(function()
		RunService:BindToRenderStep(bindName, Enum.RenderPriority.Camera.Value + 1, function()
			local live = GetCamera()
			if not live then
				return
			end
			pcall(function()
				live.CFrame = live.CFrame * CFrame.Angles(
					(math.random() - 0.5) * intensity * 0.2,
					(math.random() - 0.5) * intensity * 0.2,
					(math.random() - 0.5) * intensity * 0.2
				)
			end)
		end)
	end)
	if not okBind then
		return false, "could not bind camera shake"
	end
	Effects.Register("fun", "shake", duration, function()
		pcall(function()
			RunService:UnbindFromRenderStep(bindName)
		end)
	end)
	return true, string.format("camera shake applied for %.0fs", duration)
end

function Fun.CameraZoom(args)
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	local ok = pcall(function()
		LocalPlayer.CameraMinZoomDistance = 0.5
		LocalPlayer.CameraMaxZoomDistance = 0.5
	end)
	if not ok then
		return false, "could not lock camera zoom"
	end
	Effects.Register("fun", "zoom", duration, function()
		pcall(function()
			LocalPlayer.CameraMinZoomDistance = Visual.zoomDefaultMin
			LocalPlayer.CameraMaxZoomDistance = Visual.zoomDefaultMax
		end)
	end)
	return true, string.format("camera zoomed in and locked for %.0fs", duration)
end

function Fun.LightingEffect(args)
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	local color = ArgColor(args, 255, 210, 150)
	local correction = Instance.new("ColorCorrectionEffect")
	correction.Name = "CPN_Lighting"
	correction.Saturation = 0.35
	correction.Contrast = 0.12
	correction.TintColor = color
	correction.Parent = Lighting

	local bloom = Instance.new("BloomEffect")
	bloom.Name = "CPN_LightingBloom"
	bloom.Intensity = 1.1
	bloom.Size = 28
	bloom.Threshold = 0.9
	bloom.Parent = Lighting

	Effects.Register("fun", "lighting", duration, function()
		pcall(function()
			correction:Destroy()
		end)
		pcall(function()
			bloom:Destroy()
		end)
	end)
	return true, string.format("lighting effect applied for %.0fs", duration)
end

function Fun.ParticleEffect(args)
	local character, root = GetCharacter()
	if not character or not root then
		return false, "character not available"
	end
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = "CPN_Particles"
	emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	emitter.Color = ColorSequence.new(ArgColor(args, 60, 130, 255), WHITE)
	emitter.Rate = 40
	emitter.Lifetime = NumberRange.new(0.7, 1.4)
	emitter.Speed = NumberRange.new(3, 6)
	emitter.SpreadAngle = Vector2.new(40, 40)
	emitter.Size = NumberSequence.new(0.35)
	emitter.LightEmission = 0.6
	emitter.Parent = root

	local connection = ListenCharacterRemoval(character, emitter)
	Effects.Register("fun", "particles", duration, CharacterBoundCleanup(character, emitter, connection))
	return true, string.format("particle effect applied for %.0fs", duration)
end

function Fun.Distortion(args)
	local duration = Funcs.EffectDuration(args.duration, DEFAULT_DURATION)
	local running = true
	local correction = Instance.new("ColorCorrectionEffect")
	correction.Name = "CPN_Distortion"
	correction.Parent = Lighting

	task.spawn(function()
		local startedAt = os.clock()
		while running and os.clock() - startedAt < duration + 0.2 do
			local now = os.clock()
			pcall(function()
				correction.Contrast = 0.12 + math.sin(now * 9) * 0.12
				correction.Saturation = math.sin(now * 5) * 0.7
				correction.TintColor = Color3.new(
					1 + math.sin(now * 7) * 0.08,
					1 + math.sin(now * 7 + 2) * 0.08,
					1 + math.sin(now * 7 + 4) * 0.08
				)
			end)
			task.wait(0.05)
		end
	end)

	Effects.Register("fun", "distortion", duration, function()
		running = false
		pcall(function()
			correction:Destroy()
		end)
	end)
	return true, string.format("visual distortion applied for %.0fs (approximation)", duration)
end

function Fun.Confetti(args)
	local duration = Funcs.EffectDuration(args.duration, math.max(DEFAULT_DURATION, 5))
	local gui = MakeOverlayGui("CPN_Confetti")
	local viewport = (GetCamera() and GetCamera().ViewportSize) or Vector2.new(1280, 720)

	for i = 1, 40 do
		local piece = Instance.new("Frame")
		local width = math.random(6, 12)
		local startX = math.random() * 0.96
		piece.Size = UDim2.new(0, width, 0, math.random(8, 16))
		piece.Position = UDim2.new(startX, 0, 0, -24 - math.random(0, 60))
		piece.BackgroundColor3 = Color3.fromHSV(math.random(0, 360) / 360, 0.65, 1)
		piece.BorderSizePixel = 0
		piece.Rotation = math.random(-45, 45)
		piece.Parent = gui

		local fallTime = math.max(1.6, duration - 0.6 - (i / 40))
		pcall(function()
			TweenService:Create(piece, TweenInfo.new(fallTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
				Position = UDim2.new(startX, 0, 1, 40),
				Rotation = math.random(-200, 200),
			}):Play()
		end)
	end

	Effects.Register("fun", "confetti", duration, function()
		pcall(function()
			gui:Destroy()
		end)
	end)
	return true, string.format("confetti for %.0fs", duration)
end

function Effects.RestoreCoreDefaults()
	local camera = GetCamera()
	if camera then
		pcall(function()
			camera.FieldOfView = Visual.fovDefault
		end)
	end
	pcall(function()
		LocalPlayer.CameraMinZoomDistance = Visual.zoomDefaultMin
		LocalPlayer.CameraMaxZoomDistance = Visual.zoomDefaultMax
	end)
	for sound, entry in pairs(Audio.sounds) do
		pcall(function()
			sound.Volume = Audio.DefaultVolume
		end)
		entry.volume = Audio.DefaultVolume
	end
end

function Effects.StopAll(reason)
	local count = Effects.StopWhere(function()
		return true
	end, reason or "stopped")
	Effects.RestoreCoreDefaults()
	return count
end

local function DisconnectAll(connections)
	for _, connection in ipairs(connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end
end

local function ForwardPlayerAction(action, args, message)
	local hook = Env.CPanelAuthorizePlayerActions
	if type(hook) == "function" then
		local ok, authorized, note = pcall(hook, action, args)
		if not ok then
			return false, "experience hook errored: " .. Funcs.Truncate(tostring(authorized), 100)
		end
		if authorized == true then
			return true, Funcs.SafeText(note, 120, action .. " authorized by the experience")
		end
		return false, Funcs.SafeText(note, 120, "experience declined " .. action)
	end

	local bridge = ReplicatedStorage:FindFirstChild("CPanelBridge")
	if not bridge or not bridge:IsA("RemoteEvent") then
		return false, "experience does not authorize CPanel player actions"
	end

	local requestId = Funcs.SafeText(args.requestId, 64, "")
	if requestId == "" then
		return false, "missing request id"
	end

	local result = { done = false, ok = false, message = "" }
	local connections = {}

	local function listen(source)
		local connection = source.OnClientEvent:Connect(function(rid, okValue, messageValue)
			if tostring(rid) == requestId then
				result.done = true
				result.ok = (okValue == true or okValue == "ok")
				result.message = Funcs.SafeText(tostring(messageValue or ""), 120, "")
			end
		end)
		connections[#connections + 1] = connection
	end

	listen(bridge)
	local resultEvent = ReplicatedStorage:FindFirstChild("CPanelBridgeResult")
	if resultEvent and resultEvent:IsA("RemoteEvent") then
		listen(resultEvent)
	end

	local payload = {}
	for key, value in pairs(args) do
		payload[key] = value
	end
	payload.requestId = requestId
	if message and type(message.from) == "table" then
		payload.initiatorUserId = tonumber(message.from.userId) or 0
	end

	local okFire = pcall(function()
		bridge:FireServer(action, payload)
	end)
	if not okFire then
		DisconnectAll(connections)
		return false, "could not reach the experience bridge"
	end

	local deadline = os.clock() + 8
	while not result.done and os.clock() < deadline do
		task.wait(0.05)
	end
	DisconnectAll(connections)

	if not result.done then
		return false, "no response from the experience (8s timeout)"
	end
	if result.ok then
		return true, result.message ~= "" and result.message or (action .. " applied")
	end
	return false, result.message ~= "" and result.message or (action .. " refused")
end

local function PlayerActionHandler(actionName)
	return function(args, message)
		return ForwardPlayerAction(actionName, args, message)
	end
end

Handlers.freeze = PlayerActionHandler("freeze")
Handlers.unfreeze = PlayerActionHandler("unfreeze")
Handlers.kill = PlayerActionHandler("kill")
Handlers.bring = PlayerActionHandler("bring")
Handlers.goto = PlayerActionHandler("goto")

Handlers.play_sound = function(args)
	return Audio.Play(args)
end
Handlers.stop_sound = function()
	return Audio.StopCurrent()
end
Handlers.loop_sound = function(args)
	return Audio.SetLoop(args.enabled == true)
end
Handlers.set_volume = function(args)
	return Audio.SetVolume(args.volume)
end
Handlers.restore_volume = function()
	return Audio.RestoreVolume()
end
Handlers.stop_all_sounds = function()
	return Audio.StopAll()
end
Handlers.query_audio_status = function()
	return true, Audio.Status()
end

Handlers.screen_flash = function(args)
	return Visual.ScreenFlash(args.duration)
end
Handlers.color_effect = function(args)
	return Visual.ColorEffect(args)
end
Handlers.blur = function(args)
	return Visual.Blur(args)
end
Handlers.fov_increase = function(args)
	return Visual.FovShift(args, 1)
end
Handlers.fov_decrease = function(args)
	return Visual.FovShift(args, -1)
end
Handlers.fov_reset = function()
	return Visual.FovReset()
end
Handlers.grayscale = function(args)
	return Visual.Grayscale(args)
end
Handlers.invert_colors = function(args)
	return Visual.InvertColors(args)
end
Handlers.screen_tint = function(args)
	return Visual.ScreenTint(args)
end
Handlers.restore_visual = function(args)
	return Visual.Restore()
end

Handlers.highlight = function(args)
	return Fun.Highlight(args, false)
end
Handlers.outline = function(args)
	return Fun.Highlight(args, true)
end
Handlers.nameplate = function(args)
	return Fun.Nameplate(args)
end
Handlers.overhead_notify = function(args)
	return Fun.OverheadNotify(args)
end
Handlers.vignette = function(args)
	return Fun.Vignette(args)
end
Handlers.camera_shake = function(args)
	return Fun.CameraShake(args)
end
Handlers.camera_zoom = function(args)
	return Fun.CameraZoom(args)
end
Handlers.lighting_effect = function(args)
	return Fun.LightingEffect(args)
end
Handlers.particle_effect = function(args)
	return Fun.ParticleEffect(args)
end
Handlers.distortion = function(args)
	return Fun.Distortion(args)
end
Handlers.confetti = function(args)
	return Fun.Confetti(args)
end

Handlers.stop_all_effects = function()
	local count = Effects.StopAll("stopped")
	if count == 0 then
		return true, "no active effects"
	end
	return true, count .. " effect(s) stopped and defaults restored"
end

Handlers.clear_temporary_effects = function()
	local count = Effects.StopWhere(function(entry)
		return entry.category == "visual" or entry.category == "fun"
	end, "cleared")
	if count == 0 then
		return true, "no temporary effects active"
	end
	return true, count .. " temporary effect(s) cleared"
end

Handlers.restore_default_effects = function()
	local count = Effects.StopWhere(function(entry)
		return entry.category == "visual" or entry.category == "fun"
	end, "restored")
	Effects.RestoreCoreDefaults()
	if count == 0 then
		return true, "defaults restored (no visual/fun effects active)"
	end
	return true, count .. " effect(s) cleared, defaults restored"
end

Handlers.query_effects = function()
	return true, Effects.Describe() .. " — " .. Audio.Status()
end

local function SendAck(requestId, ok, message)
	if type(requestId) ~= "string" or requestId == "" then
		return
	end
	Net.Send({
		type = "ack",
		requestId = requestId,
		ok = (ok == true),
		message = Funcs.SafeText(message, 230, ok == true and "ok" or "failed"),
	})
end

local function HandleCommand(message)
	local requestId = message.requestId
	if State.IsDeveloper then
		return SendAck(requestId, false, "developer sessions do not accept commands")
	end
	if State.Shutdown then
		return SendAck(requestId, false, "session is shutting down")
	end
	if BlockEffects then
		return SendAck(requestId, false, "participant has blocked CPanel effects")
	end

	local action = message.action
	local handler = Handlers[action]
	if type(handler) ~= "function" then
		return SendAck(requestId, false, "unknown action: " .. Funcs.SafeText(action, 40, "?"))
	end

	local args = (type(message.args) == "table") and message.args or {}
	local callOk, okResult, messageResult = pcall(handler, args, message)
	if not callOk then
		warn("[CPanel] action '" .. tostring(action) .. "' errored: " .. tostring(okResult))
		return SendAck(requestId, false, "action failed: " .. Funcs.Truncate(tostring(okResult), 120))
	end

	local finalOk = (okResult == true)
	local finalMessage
	if type(messageResult) == "string" and messageResult ~= "" then
		finalMessage = messageResult
	elseif finalOk then
		finalMessage = "done"
	else
		finalMessage = "failed"
	end
	SendAck(requestId, finalOk, finalMessage)
end

local ACK_TIMEOUT = 20
local HEARTBEAT_EVERY = 25
local WATCHDOG_AFTER = 100

Net.status = "disconnected"
Net.socket = nil
Net.open = false
Net.sessionId = nil
Net.role = nil
Net.accessList = {}
Net.pending = {}
Net.pendingTimers = {}
Net.waiters = {}
Net.lastRecv = 0
Net.pingSentAt = nil
Net.rtt = nil
Net.reconnectAttempts = 0
Net.lastPing = 0
Net.manualKick = false

function Net.Send(payload)
	if not Net.open or not Net.socket then
		return false
	end
	local okEncode, encoded = pcall(function()
		return HttpService:JSONEncode(payload)
	end)
	if not okEncode then
		return false
	end
	local okSend = pcall(function()
		Net.socket:Send(encoded)
	end)
	return okSend
end

function Net.OnOnce(msgType, callback, timeout)
	local list = Net.waiters[msgType]
	if not list then
		list = {}
		Net.waiters[msgType] = list
	end
	local waiter = { callback = callback, done = false }
	list[#list + 1] = waiter
	waiter.timer = task.delay(timeout or 6, function()
		if waiter.done then
			return
		end
		waiter.done = true
		for index, item in ipairs(list) do
			if item == waiter then
				table.remove(list, index)
				break
			end
		end
		pcall(callback, nil)
	end)
	return waiter
end

local function ResolveWaiters(msgType, message)
	local list = Net.waiters[msgType]
	if not list then
		return
	end
	for index = #list, 1, -1 do
		local waiter = list[index]
		if not waiter.done then
			waiter.done = true
			if waiter.timer then
				pcall(task.cancel, waiter.timer)
			end
			table.remove(list, index)
			pcall(waiter.callback, message)
		end
	end
end

local function ResolveAllWaiters(message)
	for msgType in pairs(Net.waiters) do
		ResolveWaiters(msgType, message)
	end
end

function Net.SettlePending(ok, reason)
	for requestId, pending in pairs(Net.pending) do
		Net.pending[requestId] = nil
		local timer = Net.pendingTimers[requestId]
		if timer then
			pcall(task.cancel, timer)
			Net.pendingTimers[requestId] = nil
		end
		pcall(pending.callback, ok, reason)
	end
end

function Net.ResolveAck(message)
	local requestId = message.requestId
	local pending = Net.pending[requestId]
	if not pending then
		return
	end
	Net.pending[requestId] = nil
	local timer = Net.pendingTimers[requestId]
	if timer then
		pcall(task.cancel, timer)
	end
	Net.pendingTimers[requestId] = nil
	pcall(pending.callback, message.ok == true, Funcs.SafeText(message.message, 200, ""))
end

function Net.SendCommand(action, args, callback)
	if not State.Selected then
		pcall(callback, false, "no participant selected")
		return false
	end
	if not Net.open then
		pcall(callback, false, "not connected to the CPanel server")
		return false
	end
	local targetId = State.Selected.sessionId
	if type(targetId) ~= "string" or targetId == "" then
		pcall(callback, false, "selected participant has no session id")
		return false
	end
	if State.Selected.role == "developer" then
		pcall(callback, false, "developer sessions cannot be targeted")
		return false
	end

	local requestId = HttpService:GenerateGUID(false)
	Net.pending[requestId] = { callback = callback }
	Net.pendingTimers[requestId] = task.delay(ACK_TIMEOUT, function()
		if Net.pending[requestId] then
			Net.pending[requestId] = nil
			Net.pendingTimers[requestId] = nil
			pcall(callback, false, "no response (timeout)")
		end
	end)

	local sent = Net.Send({
		type = "command",
		target = targetId,
		action = action,
		args = args or {},
		requestId = requestId,
	})
	if not sent then
		local timer = Net.pendingTimers[requestId]
		if timer then
			pcall(task.cancel, timer)
		end
		Net.pending[requestId] = nil
		Net.pendingTimers[requestId] = nil
		pcall(callback, false, "could not send command")
		return false
	end
	return true
end

function Funcs.IsAccessListed(userId)
	for _, id in ipairs(Net.accessList) do
		if tonumber(id) == userId then
			return true
		end
	end
	return false
end

function Funcs.ApplyRole()
	local listed = Funcs.IsAccessListed(LocalPlayer.UserId)
	if listed and not State.IsDeveloper then
		State.IsDeveloper = true
		if not UI.Window then
			Gui.Build()
		end
		Funcs.Notify("Developer access", "Authenticated as a CPanel developer.", "success")
		Gui.RequestParticipants(true)
	elseif not listed and State.IsDeveloper then
		State.IsDeveloper = false
		Gui.CloseDashboard("Developer access was removed on the server.")
	elseif listed and State.IsDeveloper then
		Gui.RequestParticipants(true)
	end
end

function Net.OnWelcome(message)
	Net.sessionId = message.sessionId
	Net.role = message.role
	if type(message.access) == "table" then
		Net.accessList = message.access
	end
	if message.role == "developer" and not Funcs.IsAccessListed(LocalPlayer.UserId) then
		warn("[CPanel] server claims developer role but our id is not in the returned access list — refusing developer UI")
	end
	Funcs.ApplyRole()
end

function Net.Route(text)
	local ok, message = pcall(function()
		return HttpService:JSONDecode(text)
	end)
	if not ok or type(message) ~= "table" or type(message.type) ~= "string" then
		warn("[CPanel] malformed message from server")
		return
	end

	local msgType = message.type
	if msgType == "welcome" then
		Net.OnWelcome(message)
	elseif msgType == "access" then
		if type(message.userids) == "table" then
			Net.accessList = message.userids
		end
		ResolveWaiters("access", message)
		Funcs.ApplyRole()
	elseif msgType == "participants" then
		ResolveWaiters("participants", message)
		if State.IsDeveloper then
			Gui.ApplyParticipantList(message.list)
		end
	elseif msgType == "command" then
		HandleCommand(message)
	elseif msgType == "ack" then
		Net.ResolveAck(message)
	elseif msgType == "ping" then
		Net.Send({ type = "pong" })
	elseif msgType == "pong" then
		if Net.pingSentAt then
			Net.rtt = math.floor((os.clock() - Net.pingSentAt) * 1000)
			Net.pingSentAt = nil
			Gui.UpdateConnection()
		end
	elseif msgType == "participant_joined" then
		if State.IsDeveloper then
			Gui.OnParticipantJoined(message.participant)
		end
	elseif msgType == "participant_left" then
		if State.IsDeveloper then
			Gui.OnParticipantLeft(message)
		end
	elseif msgType == "error" then
		warn("[CPanel] server error: " .. tostring(message.code) .. " - " .. tostring(message.message))
		if State.IsDeveloper and message.code ~= "rate_limited" then
			Funcs.Notify("Server error", Funcs.Truncate(tostring(message.message), 120), "error")
		end
		ResolveAllWaiters(message)
	else
		warn("[CPanel] unknown message type from server: " .. msgType)
	end
end

function Net.HandleClose()
	local wasOpen = Net.open
	Net.open = false
	Net.socket = nil
	Net.sessionId = nil
	Net.registered = false

	Net.SettlePending(false, "connection lost")

	if Effects.entries and next(Effects.entries) ~= nil then
		Effects.StopAll("session ended")
	end

	if not wasOpen then
		return
	end

	if State.IsDeveloper then
		Funcs.Notify("WebSocket connection lost", "Connection to the CPanel server was lost.", "error")
	end

	if State.Shutdown then
		Net.status = "disconnected"
	elseif Settings.AutoReconnect then
		Net.status = "reconnecting"
	else
		Net.status = "disconnected"
	end
	Gui.UpdateConnection()
end

function Net.TryConnectOnce()
	local ok, socketOrError = pcall(WSConnect, WebsocketUrl)
	if not ok or not socketOrError then
		Net.lastError = tostring(socketOrError)
		return false
	end

	Net.socket = socketOrError
	Net.open = true
	Net.lastRecv = os.clock()
	Net.lastPing = os.clock()

	pcall(function()
		socketOrError.OnMessage:Connect(function(messageText)
			Net.lastRecv = os.clock()
			Net.Route(messageText)
		end)
	end)
	pcall(function()
		socketOrError.OnClose:Connect(function()
			Net.HandleClose()
		end)
	end)

	local registered = Net.Send({
		type = "register",
		userId = LocalPlayer.UserId,
		username = LocalPlayer.Name,
		displayName = LocalPlayer.DisplayName,
		placeId = game.PlaceId,
		jobId = (type(game.JobId) == "string" and game.JobId ~= "") and game.JobId or "unknown",
		placeVersion = game.PlaceVersion,
	})
	if not registered then
		Net.HandleClose()
		return false
	end
	return true
end

function Net.Start()
	task.spawn(function()
		while not State.Shutdown do
			if Net.open then
				task.wait(0.4)
			else
				Net.reconnectAttempts = Net.reconnectAttempts + 1
				local firstEver = (Net.reconnectAttempts == 1)
				Net.status = firstEver and "connecting" or "reconnecting"
				Gui.UpdateConnection()

				local connected = Net.TryConnectOnce()
				if connected then
					Net.reconnectAttempts = 0
					Net.status = "connected"
					Gui.UpdateConnection()
					Funcs.Notify("WebSocket connected", "Connected to the CPanel server.", "success")
				else
					warn("[CPanel] connect attempt " .. tostring(Net.reconnectAttempts) .. " failed: " .. tostring(Net.lastError))
					if not Settings.AutoReconnect and not firstEver then
						Net.status = "disconnected"
						Gui.UpdateConnection()
						while not State.Shutdown and not Settings.AutoReconnect and not Net.manualKick do
							task.wait(1)
						end
						Net.manualKick = false
						Net.reconnectAttempts = 0
					else
						local exponent = math.min(Net.reconnectAttempts - 1, 5)
						local backoff = math.min(30, 2 ^ exponent) + (math.random() * 1.5)
						task.wait(backoff)
					end
				end
			end
		end
	end)
end

function Net.Kick(reason)
	if State.Shutdown then
		return
	end
	Net.manualKick = true
	local socket = Net.socket
	Net.socket = nil
	Net.open = false
	pcall(function()
		if socket then
			socket:Close()
		end
	end)
	Net.HandleClose()
	if reason and State.IsDeveloper then
		Funcs.Notify("Reconnecting", reason, "info")
	end
	Net.status = "connecting"
	Gui.UpdateConnection()
end

task.spawn(function()
	while not State.Shutdown do
		task.wait(6)
		if Net.open then
			if os.clock() - Net.lastRecv > WATCHDOG_AFTER then
				warn("[CPanel] no data from server for " .. tostring(WATCHDOG_AFTER) .. "s — forcing reconnect")
				local socket = Net.socket
				pcall(function()
					if socket then
						socket:Close()
					end
				end)
				task.wait(2)
				if Net.open then
					Net.HandleClose()
				end
			elseif os.clock() - Net.lastPing >= HEARTBEAT_EVERY then
				Net.lastPing = os.clock()
				Net.pingSentAt = os.clock()
				Net.Send({ type = "ping" })
			end
		end
	end
end)

local function MkCorner(radius, parent)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
	return corner
end

local function MkStroke(color, thickness, parent)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness or 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	return stroke
end

local function MkPadding(left, right, top, bottom, parent)
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, left)
	padding.PaddingRight = UDim.new(0, right)
	padding.PaddingTop = UDim.new(0, top)
	padding.PaddingBottom = UDim.new(0, bottom)
	padding.Parent = parent
	return padding
end

local function MkList(direction, padding, parent)
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = direction or Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, padding or 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = parent
	return layout
end

local function MkFrame(background, size, parent)
	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = background
	frame.BackgroundTransparency = 0
	frame.BorderSizePixel = 0
	frame.Size = size
	frame.Parent = parent
	return frame
end

local function MkLabel(text, font, size, color, parent)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Text = text
	label.FontFace = font
	label.TextSize = size
	label.TextColor3 = color
	label.TextWrapped = true
	label.Parent = parent
	return label
end

local function MkImg(image, color, parent)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.BackgroundTransparency = 1
	imageLabel.BorderSizePixel = 0
	imageLabel.Image = image or ""
	imageLabel.ImageColor3 = color or WHITE
	imageLabel.Parent = parent
	return imageLabel
end

local function MkScroll(parent, direction)
	local scroll = Instance.new("ScrollingFrame")
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
	scroll.ScrollingDirection = direction or Enum.ScrollingDirection.Y
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.Parent = parent
	return scroll
end

local function MkBtn(text, font, size, color, background, parent)
	local button = Instance.new("TextButton")
	button.BackgroundColor3 = background
	button.BorderSizePixel = 0
	button.Text = text
	button.FontFace = font
	button.TextSize = size
	button.TextColor3 = color
	button.AutoButtonColor = false
	button.Parent = parent

	local hovering = false
	local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local hoverColor = background:Lerp(WHITE, 0.1)
	if background.R + background.G + background.B < 0.2 then
		hoverColor = BG3
	end
	local pressColor = background:Lerp(OVERLAY_BG, 0.2)

	button.MouseEnter:Connect(function()
		hovering = true
		TweenService:Create(button, tweenInfo, { BackgroundColor3 = hoverColor }):Play()
	end)
	button.MouseLeave:Connect(function()
		hovering = false
		TweenService:Create(button, tweenInfo, { BackgroundColor3 = background }):Play()
	end)
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			TweenService:Create(button, tweenInfo, { BackgroundColor3 = pressColor }):Play()
		end
	end)
	button.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			TweenService:Create(button, tweenInfo, { BackgroundColor3 = hovering and hoverColor or background }):Play()
		end
	end)

	return button
end

local function MkCard(parent, order, height)
	local card = MkFrame(BG2, UDim2.new(1, 0, 0, height or 0), parent)
	card.LayoutOrder = order or 0
	card.BorderSizePixel = 0
	MkCorner(10, card)
	MkStroke(BORDER, 1, card)
	return card
end

local function MkCardAuto(parent, order)
	local card = MkFrame(BG2, UDim2.new(1, 0, 0, 0), parent)
	card.LayoutOrder = order or 0
	card.BorderSizePixel = 0
	card.AutomaticSize = Enum.AutomaticSize.Y
	MkCorner(10, card)
	MkStroke(BORDER, 1, card)
	return card
end

local function MkHeading(parent, text, order)
	local heading = MkLabel(text, F_BOLD, 14, TEXT, parent)
	heading.Size = UDim2.new(1, 0, 0, 20)
	heading.TextXAlignment = Enum.TextXAlignment.Left
	heading.LayoutOrder = order or 0
	return heading
end

local function MkHint(parent, text, order)
	local hint = MkLabel(text, F_REG, 12, SUBTEXT, parent)
	hint.Size = UDim2.new(1, 0, 0, 0)
	hint.AutomaticSize = Enum.AutomaticSize.Y
	hint.TextXAlignment = Enum.TextXAlignment.Left
	hint.TextYAlignment = Enum.TextYAlignment.Top
	hint.LayoutOrder = order or 0
	return hint
end

local function MkInput(parent, placeholder, order, width)
	local box = Instance.new("TextBox")
	box.BackgroundColor3 = BG3
	box.BorderSizePixel = 0
	box.Size = UDim2.new(width and 0 or 1, width or 0, 0, 34)
	box.PlaceholderText = placeholder or ""
	box.PlaceholderColor3 = SUBTEXT
	box.Text = ""
	box.FontFace = F_MED
	box.TextSize = 13
	box.TextColor3 = TEXT
	box.ClearTextOnFocus = false
	box.ClipsDescendants = true
	box.LayoutOrder = order or 0
	box.Parent = parent
	MkCorner(8, box)
	MkStroke(BORDER, 1, box)
	MkPadding(10, 10, 0, 0, box)
	return box
end

local function PageColumn(page)
	local layout = MkList(Enum.FillDirection.Vertical, 12, page)
	layout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkPadding(14, 14, 14, 16, page)
	return layout
end

function Gui.MakeToggle(parent, initialValue, onChange)
	local holder = MkFrame(Color3.fromRGB(45, 45, 56), UDim2.new(0, 44, 0, 24), parent)
	holder.BorderSizePixel = 0
	holder.ClipsDescendants = true
	MkCorner(12, holder)

	local knob = MkFrame(WHITE, UDim2.new(0, 18, 0, 18), holder)
	knob.BorderSizePixel = 0
	knob.Position = UDim2.new(0, 3, 0.5, -9)
	MkCorner(9, knob)

	local enabled = (initialValue == true)

	local function paint(animate)
		local targetPosition = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
		local targetColor = enabled and ACCENT or Color3.fromRGB(45, 45, 56)
		if animate and Settings.Animations then
			TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPosition }):Play()
			TweenService:Create(holder, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = targetColor }):Play()
		else
			knob.Position = targetPosition
			holder.BackgroundColor3 = targetColor
		end
	end
	paint(false)

	holder.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			enabled = not enabled
			paint(true)
			if type(onChange) == "function" then
				pcall(onChange, enabled)
			end
		end
	end)

	return {
		holder = holder,
		Set = function(value)
			enabled = (value == true)
			paint(false)
		end,
		Get = function()
			return enabled
		end,
	}
end

function Gui.MakeSlider(parent, min, max, value, order, onChange)
	local holder = MkFrame(BG3, UDim2.new(1, 0, 0, 30), parent)
	holder.BorderSizePixel = 0
	holder.LayoutOrder = order or 0

	local track = MkFrame(Color3.fromRGB(45, 45, 56), UDim2.new(1, -8, 0, 6), holder)
	track.BorderSizePixel = 0
	track.AnchorPoint = Vector2.new(0, 0.5)
	track.Position = UDim2.new(0, 4, 0.5, 0)
	MkCorner(3, track)

	local fill = MkFrame(ACCENT, UDim2.new(0, 0, 1, 0), track)
	fill.BorderSizePixel = 0
	MkCorner(3, fill)

	local knob = MkFrame(WHITE, UDim2.new(0, 14, 0, 14), track)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.BorderSizePixel = 0
	MkCorner(7, knob)

	local current = value
	local dragging = false

	local function paint()
		local ratio = (current - min) / (max - min)
		if ratio < 0 then ratio = 0 end
		if ratio > 1 then ratio = 1 end
		fill.Size = UDim2.new(ratio, 0, 1, 0)
		knob.Position = UDim2.new(ratio, 0, 0.5, 0)
	end

	local function updateFromX(x)
		local width = track.AbsoluteSize.X
		if width <= 0 then
			return
		end
		local ratio = (x - track.AbsolutePosition.X) / width
		if ratio < 0 then ratio = 0 end
		if ratio > 1 then ratio = 1 end
		current = min + (max - min) * ratio
		paint()
		if type(onChange) == "function" then
			pcall(onChange, current)
		end
	end

	holder.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateFromX(input.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateFromX(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	paint()

	return {
		holder = holder,
		fill = fill,
		knob = knob,
		Set = function(v)
			current = v
			paint()
		end,
		Get = function()
			return current
		end,
	}
end

function Gui.MakeCycle(parent, options, currentIndex, order, onChange)
	local index = currentIndex or 1
	local button = MkBtn(tostring(options[index] or ""), F_MED, 13, TEXT, BG3, parent)
	button.Size = UDim2.new(0, 170, 0, 32)
	button.LayoutOrder = order or 0
	MkCorner(8, button)

	local function refresh()
		button.Text = tostring(options[index] or "")
	end

	button.MouseButton1Click:Connect(function()
		index = index + 1
		if index > #options then
			index = 1
		end
		refresh()
		if type(onChange) == "function" then
			pcall(onChange, options[index], index)
		end
	end)

	return {
		button = button,
		Set = function(value)
			for i, option in ipairs(options) do
				if option == value then
					index = i
				end
			end
			refresh()
		end,
		Get = function()
			return options[index]
		end,
		SetIndex = function(i)
			index = i
			refresh()
		end,
	}
end

function Gui.SetStatus(pageKey, text, ok)
	local label = UI.PageStatus and UI.PageStatus[pageKey]
	if not label then
		return
	end
	label.Visible = true
	label.Text = Funcs.Truncate(text or "", 150)
	if ok == nil then
		label.TextColor3 = SUBTEXT
	elseif ok then
		label.TextColor3 = GREEN
	else
		label.TextColor3 = RED
	end
end

local TOAST_HEIGHT = 62
local TOAST_GAP = 8
local TOAST_LIFETIME = 4.5

function Gui.DismissToast(toast)
	local list = UI.ToastList
	if not list then
		return
	end
	local found = false
	for index, item in ipairs(list) do
		if item == toast then
			table.remove(list, index)
			found = true
			break
		end
	end
	if not found then
		return
	end
	local function finish()
		pcall(function()
			toast:Destroy()
		end)
	end
	if Settings.Animations then
		TweenService:Create(toast, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 40, 0, toast.Position.Y.Offset),
		}):Play()
		task.delay(0.19, finish)
	else
		finish()
	end
	for index, item in ipairs(list) do
		local targetY = (index - 1) * (TOAST_HEIGHT + TOAST_GAP)
		if Settings.Animations then
			TweenService:Create(item, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(1, 0, 0, targetY),
			}):Play()
		else
			item.Position = UDim2.new(1, 0, 0, targetY)
		end
	end
end

function Gui.PushToast(entry)
	local host = UI.ToastHost
	local list = UI.ToastList
	if not host or not list then
		return
	end
	while #list >= 5 do
		Gui.DismissToast(list[1])
	end

	local kindColors = { info = ACCENT, success = GREEN, error = RED, warn = YELLOW }
	local accent = kindColors[entry.kind] or ACCENT

	local toast = MkFrame(BG2, UDim2.new(1, 0, 0, TOAST_HEIGHT), host)
	toast.BorderSizePixel = 0
	toast.AnchorPoint = Vector2.new(1, 0)
	toast.Position = UDim2.new(1, 40, 0, #list * (TOAST_HEIGHT + TOAST_GAP))
	MkCorner(10, toast)
	MkStroke(BORDER, 1, toast)

	local bar = MkFrame(accent, UDim2.new(0, 3, 1, -16), toast)
	bar.BorderSizePixel = 0
	bar.Position = UDim2.new(0, 8, 0, 8)
	MkCorner(2, bar)

	local titleLabel = MkLabel(entry.title, F_BOLD, 13, accent, toast)
	titleLabel.Size = UDim2.new(1, -32, 0, 18)
	titleLabel.Position = UDim2.new(0, 20, 0, 10)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local bodyLabel = MkLabel(entry.text, F_REG, 12, SUBTEXT, toast)
	bodyLabel.Size = UDim2.new(1, -32, 0, 30)
	bodyLabel.Position = UDim2.new(0, 20, 0, 27)
	bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
	bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
	bodyLabel.TextTruncate = Enum.TextTruncate.AtEnd

	list[#list + 1] = toast

	if Settings.Animations then
		TweenService:Create(toast, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, 0, 0, (#list - 1) * (TOAST_HEIGHT + TOAST_GAP)),
		}):Play()
	else
		toast.Position = UDim2.new(1, 0, 0, (#list - 1) * (TOAST_HEIGHT + TOAST_GAP))
	end

	task.delay(TOAST_LIFETIME, function()
		if toast.Parent then
			Gui.DismissToast(toast)
		end
	end)
end

function Gui.FlushQueuedToasts()
	local queued = State.queuedToasts
	State.queuedToasts = {}
	for _, entry in ipairs(queued) do
		Gui.PushToast(entry)
	end
end

function Gui.ApplyTransparency()
	if UI.Window then
		UI.Window.BackgroundTransparency = Settings.Transparency
	end
end

function Gui.ApplyTheme(presetName)
	local theme = Themes[presetName] or Themes["Default Dark"]
	local oldBG, oldBG2, oldBG3, oldAccent = BG, BG2, BG3, ACCENT

	Settings.Theme = Themes[presetName] and presetName or "Default Dark"
	BG = theme.BG
	BG2 = theme.BG2
	BG3 = theme.BG3
	ACCENT = theme.ACCENT

	if UI.Screen then
		for _, object in ipairs(UI.Screen:GetDescendants()) do
			if object:IsA("GuiObject") then
				if object.BackgroundColor3 == oldBG then
					object.BackgroundColor3 = BG
				elseif object.BackgroundColor3 == oldBG2 then
					object.BackgroundColor3 = BG2
				elseif object.BackgroundColor3 == oldBG3 then
					object.BackgroundColor3 = BG3
				elseif object.BackgroundColor3 == oldAccent then
					object.BackgroundColor3 = ACCENT
				end
			elseif object:IsA("UIStroke") then
				if object.Color == oldAccent then
					object.Color = ACCENT
				end
			elseif object:IsA("TextLabel") or object:IsA("TextButton") then
				if object.TextColor3 == oldAccent then
					object.TextColor3 = ACCENT
				end
			end
		end
		if UI.ActiveNavName and UI.NavButtons and UI.NavButtons[UI.ActiveNavName] then
			UI.NavButtons[UI.ActiveNavName].button.BackgroundColor3 = ACCENT
		end
		for _, slider in pairs(UI.Sliders or {}) do
			if slider.fill then
				slider.fill.BackgroundColor3 = ACCENT
			end
		end
		Gui.ApplyTransparency()
	end

	Funcs.SaveSettings()
end

local function Dragify(dragObject, handle)
	local dragging = false
	local dragStart = nil
	local startPos = nil
	local xPadding = 14
	local yPadding = 10

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = dragObject.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local delta = input.Position - dragStart
		local viewport = (GetCamera() and GetCamera().ViewportSize) or Vector2.new(1280, 720)
		local size = dragObject.AbsoluteSize
		local newX = math.clamp(startPos.X.Offset + delta.X, xPadding, viewport.X - size.X - xPadding)
		local newY = math.clamp(startPos.Y.Offset + delta.Y, yPadding, viewport.Y - size.Y - yPadding)
		dragObject.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
	end)
end

local NAV_PAGES = {
	{ key = "Dashboard", label = "Dashboard" },
	{ key = "Player", label = "Player Actions" },
	{ key = "Audio", label = "Audio" },
	{ key = "Visual", label = "Visual Effects" },
	{ key = "Fun", label = "Fun" },
	{ key = "Settings", label = "Settings" },
}

function Gui.UpdateConnection()
	local pill = UI.StatusPill
	if not pill then
		return
	end
	local status = Net.status
	local colors = { connected = GREEN, connecting = YELLOW, reconnecting = YELLOW, disconnected = RED }
	local labels = { connected = "Connected", connecting = "Connecting", reconnecting = "Reconnecting", disconnected = "Disconnected" }
	local color = colors[status] or RED
	UI.StatusDot.BackgroundColor3 = color
	UI.StatusText.Text = labels[status] or "Disconnected"
	UI.StatusText.TextColor3 = color
	if UI.StatusStroke then
		UI.StatusStroke.Color = Color3.fromRGB(50, 50, 65)
	end
	if UI.ConnStatusText then
		UI.ConnStatusText.Text = (labels[status] or "Disconnected") .. (Net.rtt and ("  ·  " .. tostring(Net.rtt) .. " ms") or "")
		UI.ConnStatusText.TextColor3 = color
	end
	if UI.ConnEndpoint then
		UI.ConnEndpoint.Text = Funcs.Truncate(WebsocketUrl, 46)
	end
	if UI.ConnSession then
		UI.ConnSession.Text = Funcs.Truncate(Net.sessionId or "not registered", 36)
	end
	if UI.ConnCounts then
		local online = #State.Participants
		UI.ConnCounts.Text = tostring(online) .. " online  ·  attempt " .. tostring(Net.reconnectAttempts)
	end
	if UI.ReconnectBtn then
		UI.ReconnectBtn.Text = (status == "connected") and "Reconnect" or "Reconnecting…"
	end
	if UI.SettingsStatusText then
		UI.SettingsStatusText.Text = (labels[status] or "Disconnected")
		UI.SettingsStatusText.TextColor3 = color
	end
end

function Gui.SwitchPage(pageKey)
	if UI.ActivePage == pageKey then
		return
	end
	local oldPage = UI.Pages and UI.Pages[UI.ActivePage]
	local newPage = UI.Pages and UI.Pages[pageKey]
	if not newPage then
		return
	end
	local oldNav = UI.NavButtons and UI.NavButtons[UI.ActivePage]
	local newNav = UI.NavButtons and UI.NavButtons[pageKey]
	if oldNav then
		oldNav.button.BackgroundColor3 = BG3
		oldNav.label.TextColor3 = SUBTEXT
	end
	if newNav then
		newNav.button.BackgroundColor3 = ACCENT
		newNav.label.TextColor3 = WHITE
	end
	if oldPage then
		oldPage.Visible = false
	end
	UI.ActivePage = pageKey
	newPage.Visible = true
	UI.ActiveNavName = pageKey
	if pageKey == "Dashboard" then
		Gui.RenderParticipants()
		Gui.RenderSelection()
	end
	Funcs.PlaySound("ping", 0.12)
end

function Gui.Minimize()
	if not UI.Window then
		return
	end
	UI.Window.Visible = false
	if UI.ShowBtn then
		UI.ShowBtn.Visible = true
	end
end

function Gui.Restore()
	if not UI.Window then
		return
	end
	if UI.ShowBtn then
		UI.ShowBtn.Visible = false
	end
	UI.Window.Visible = true
end

function Gui.Build()
	if UI.Window then
		return
	end
	UI.Pages = UI.Pages or {}
	UI.PageScrolls = UI.PageScrolls or {}
	UI.NavButtons = UI.NavButtons or {}
	UI.PageStatus = UI.PageStatus or {}
	UI.ToastList = UI.ToastList or {}
	UI.Sliders = UI.Sliders or {}
	UI.ParticipantCards = UI.ParticipantCards or {}

	local screen = Instance.new("ScreenGui")
	screen.Name = Funcs.UID(20)
	screen.DisplayOrder = 2147483646
	screen.IgnoreGuiInset = true
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screen.Parent = Hui
	UI.Screen = screen

	local toastHost = Instance.new("Frame")
	toastHost.Name = "CPN_Toasts"
	toastHost.BackgroundTransparency = 1
	toastHost.BorderSizePixel = 0
	toastHost.AnchorPoint = Vector2.new(1, 0)
	toastHost.Position = UDim2.new(1, -14, 0, 16)
	toastHost.Size = UDim2.new(0, 300, 1, -32)
	toastHost.Parent = screen
	UI.ToastHost = toastHost

	local window = MkFrame(BG, UDim2.new(0.94, 0, 0.9, 0), screen)
	window.Name = "CPN_Window"
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.Position = UDim2.new(0.5, 0, 0.5, 0)
	window.BorderSizePixel = 0
	window.ClipsDescendants = true
	MkCorner(16, window)
	MkStroke(BORDER, 1, window)
	local sizeConstraint = Instance.new("UISizeConstraint")
	sizeConstraint.MinSize = Vector2.new(660, 460)
	sizeConstraint.MaxSize = Vector2.new(1040, 670)
	sizeConstraint.Parent = window
	UI.Window = window
	Gui.ApplyTransparency()

	local topbar = MkFrame(BG2, UDim2.new(1, 0, 0, 52), window)
	topbar.BorderSizePixel = 0
	topbar.LayoutOrder = 1
	UI.Topbar = topbar

	local logo = MkImg(Funcs.GetAsset("CPanel/CPN_Logo.png") or Assets["CPanel/CPN_Logo.png"], WHITE, topbar)
	logo.Size = UDim2.new(0, 30, 0, 30)
	logo.Position = UDim2.new(0, 14, 0.5, -15)
	MkCorner(7, logo)

	local title = MkLabel("CPanel", F_BOLD, 17, TEXT, topbar)
	title.Size = UDim2.new(0, 74, 0, 22)
	title.Position = UDim2.new(0, 52, 0, 8)
	title.TextXAlignment = Enum.TextXAlignment.Left

	local version = MkLabel("v" .. VERSION, F_REG, 11, SUBTEXT, topbar)
	version.Size = UDim2.new(0, 74, 0, 14)
	version.Position = UDim2.new(0, 52, 0, 29)
	version.TextXAlignment = Enum.TextXAlignment.Left

	local statusPill = MkFrame(BG3, UDim2.new(0, 0, 0, 26), topbar)
	statusPill.AutomaticSize = Enum.AutomaticSize.X
	statusPill.AnchorPoint = Vector2.new(0.5, 0.5)
	statusPill.Position = UDim2.new(0.32, 0, 0.5, 0)
	statusPill.BorderSizePixel = 0
	MkCorner(13, statusPill)
	UI.StatusStroke = MkStroke(Color3.fromRGB(50, 50, 65), 1, statusPill)
	local pillLayout = MkList(Enum.FillDirection.Horizontal, 7, statusPill)
	pillLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	pillLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	MkPadding(11, 11, 0, 0, statusPill)
	UI.StatusPill = statusPill

	local statusDot = MkFrame(RED, UDim2.new(0, 8, 0, 8), statusPill)
	statusDot.BorderSizePixel = 0
	statusDot.LayoutOrder = 1
	MkCorner(4, statusDot)
	UI.StatusDot = statusDot

	local statusText = MkLabel("Connecting", F_MED, 12, RED, statusPill)
	statusText.Size = UDim2.new(0, 0, 0, 26)
	statusText.AutomaticSize = Enum.AutomaticSize.X
	statusText.LayoutOrder = 2
	statusText.TextXAlignment = Enum.TextXAlignment.Left
	UI.StatusText = statusText

	local devChip = MkFrame(BG3, UDim2.new(0, 0, 0, 32), topbar)
	devChip.AutomaticSize = Enum.AutomaticSize.X
	devChip.AnchorPoint = Vector2.new(1, 0.5)
	devChip.Position = UDim2.new(1, -104, 0.5, 0)
	devChip.BorderSizePixel = 0
	MkCorner(16, devChip)
	local chipLayout = MkList(Enum.FillDirection.Horizontal, 8, devChip)
	chipLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	MkPadding(4, 12, 0, 0, devChip)

	local devAvatar = Instance.new("ImageLabel")
	devAvatar.BackgroundTransparency = 1
	devAvatar.BorderSizePixel = 0
	devAvatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(LocalPlayer.UserId) .. "&width=420&height=420&format=png"
	devAvatar.Size = UDim2.new(0, 24, 0, 24)
	devAvatar.LayoutOrder = 1
	devAvatar.Parent = devChip
	MkCorner(12, devAvatar)

	local devName = MkLabel(Funcs.Truncate(LocalPlayer.DisplayName, 16) .. "  ·  Developer", F_MED, 12, TEXT, devChip)
	devName.Size = UDim2.new(0, 0, 0, 32)
	devName.AutomaticSize = Enum.AutomaticSize.X
	devName.LayoutOrder = 2
	devName.TextXAlignment = Enum.TextXAlignment.Left

	local minimizeBtn = MkBtn("–", F_BOLD, 17, TEXT, BG3, topbar)
	minimizeBtn.Size = UDim2.new(0, 34, 0, 34)
	minimizeBtn.AnchorPoint = Vector2.new(1, 0.5)
	minimizeBtn.Position = UDim2.new(1, -62, 0.5, 0)
	minimizeBtn.Name = "Minimize"
	MkCorner(9, minimizeBtn)

	local closeBtn = MkBtn("✕", F_BOLD, 14, WHITE, Color3.fromRGB(200, 60, 70), topbar)
	closeBtn.Size = UDim2.new(0, 34, 0, 34)
	closeBtn.AnchorPoint = Vector2.new(1, 0.5)
	closeBtn.Position = UDim2.new(1, -20, 0.5, 0)
	closeBtn.Name = "Close"
	MkCorner(9, closeBtn)

	minimizeBtn.MouseButton1Click:Connect(Gui.Minimize)
	closeBtn.MouseButton1Click:Connect(function()
		Funcs.Shutdown()
	end)

	Dragify(window, topbar)

	local sidebar = MkFrame(BG2, UDim2.new(0, 176, 1, -52), window)
	sidebar.Position = UDim2.new(0, 0, 0, 52)
	sidebar.BorderSizePixel = 0
	sidebar.LayoutOrder = 2
	UI.Sidebar = sidebar
	MkList(Enum.FillDirection.Vertical, 6, sidebar)
	MkPadding(10, 10, 12, 12, sidebar)

	for order, page in ipairs(NAV_PAGES) do
		local button = MkBtn(page.label, F_MED, 13, SUBTEXT, BG3, sidebar)
		button.Size = UDim2.new(1, 0, 0, 38)
		button.LayoutOrder = order
		button.TextXAlignment = Enum.TextXAlignment.Left
		MkCorner(9, button)
		MkPadding(14, 8, 0, 0, button)
		UI.NavButtons[page.key] = { button = button, label = button }
		button.MouseButton1Click:Connect(function()
			Gui.SwitchPage(page.key)
		end)
	end

	local content = MkFrame(BG, UDim2.new(1, -176, 1, -52), window)
	content.Position = UDim2.new(0, 176, 0, 52)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.LayoutOrder = 3
	UI.Content = content

	for _, page in ipairs(NAV_PAGES) do
		local container = Instance.new("Frame")
		container.Name = page.key .. "Page"
		container.BackgroundTransparency = 1
		container.BorderSizePixel = 0
		container.Size = UDim2.new(1, 0, 1, 0)
		container.Visible = false
		container.ZIndex = 2
		container.Parent = content
		UI.Pages[page.key] = container

		local scroll = MkScroll(container)
		scroll.Name = page.key .. "Scroll"
		scroll.Size = UDim2.new(1, 0, 1, 0)
		scroll.ZIndex = 2
		PageColumn(scroll)
		UI.PageScrolls[page.key] = scroll

		local status = MkLabel("", F_MED, 12, SUBTEXT, container)
		status.Size = UDim2.new(1, -28, 0, 16)
		status.Position = UDim2.new(0, 14, 1, -20)
		status.TextXAlignment = Enum.TextXAlignment.Left
		status.ZIndex = 6
		status.Visible = false
		UI.PageStatus[page.key] = status
	end

	local showBtn = Instance.new("ImageButton")
	showBtn.Name = "CPN_ShowBtn"
	showBtn.BackgroundColor3 = BG2
	showBtn.BackgroundTransparency = 0.05
	showBtn.BorderSizePixel = 0
	showBtn.Size = UDim2.new(0, 46, 0, 46)
	showBtn.Position = UDim2.new(0, 16, 0, 72)
	showBtn.Visible = false
	showBtn.Image = ""
	showBtn.AutoButtonColor = false
	showBtn.Parent = screen
	MkCorner(23, showBtn)
	MkStroke(BORDER, 1, showBtn)
	UI.ShowBtn = showBtn

	local showIcon = MkImg(Funcs.GetAsset("CPanel/CPN_Logo.png") or Assets["CPanel/CPN_Logo.png"], WHITE, showBtn)
	showIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	showIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	showIcon.Size = UDim2.new(0.62, 0, 0.62, 0)
	showBtn.MouseButton1Click:Connect(Gui.Restore)

	Gui.BuildAllPages()
	UI.ActiveNavName = nil
	UI.ActivePage = nil
	Gui.SwitchPage("Dashboard")
	Gui.UpdateConnection()
	Gui.RenderParticipants()
	Gui.RenderSelection()
	Gui.FlushQueuedToasts()
end

function Gui.CloseDashboard(reason)
	if not UI.Window then
		return
	end
	Funcs.Notify("Access revoked", reason or "Developer dashboard closed.", "error")
	local screen = UI.Screen
	UI = {}
	pcall(function()
		if screen then
			screen:Destroy()
		end
	end)
end

function Gui.RunAction(actionKey, pageKey, argsBuilder, titleLabel, onResult)
	if not State.IsDeveloper then
		return
	end
	if titleLabel and titleLabel.Text == "Working…" then
		return
	end
	if not State.Selected then
		Gui.SetStatus(pageKey, "Select a participant first", false)
		Funcs.Notify("No participant", "Select a participant in the Dashboard first.", "warn")
		return
	end
	if State.Selected.role == "developer" then
		Gui.SetStatus(pageKey, "Developer sessions cannot be targeted", false)
		Funcs.Notify("Blocked", "Developer sessions cannot be targeted.", "error")
		return
	end

	local args = {}
	if argsBuilder then
		local built, err = argsBuilder()
		if built == false then
			local reason = Funcs.SafeText(err, 120, "invalid input")
			Gui.SetStatus(pageKey, reason, false)
			Funcs.Notify("Invalid input", reason, "error")
			return
		end
		args = built or {}
	end

	local originalText = titleLabel and titleLabel.Text
	if titleLabel then
		titleLabel.Text = "Working…"
	end
	Gui.SetStatus(pageKey, actionKey .. " — sending…", nil)

	local targetName = State.Selected and State.Selected.username or "?"
	Net.SendCommand(actionKey, args, function(ok, message)
		if titleLabel and titleLabel.Parent then
			titleLabel.Text = originalText
		end
		Gui.SetStatus(pageKey, actionKey .. (ok and " ✓ " or " ✗ ") .. message, ok)
		State.LastActionStatus = string.format("%s → %s: %s", targetName, actionKey, message)
		if type(onResult) == "function" then
			pcall(onResult, ok, message)
		end
		Funcs.Notify(
			ok and "Action completed" or "Action failed",
			actionKey .. " — " .. message,
			ok and "success" or "error"
		)
	end)
end

local function BuildEntry(item)
	return {
		sessionId = item.sessionId,
		userId = tonumber(item.userId) or 0,
		username = Funcs.SafeText(item.username, 64, "Unknown"),
		displayName = Funcs.SafeText(item.displayName, 64, "Unknown"),
		placeId = tonumber(item.placeId) or 0,
		jobId = Funcs.SafeText(item.jobId, 64, "unknown"),
		role = (item.role == "developer") and "developer" or "participant",
		connectedAt = tonumber(item.connectedAt) or 0,
	}
end

local function SortParticipants(array)
	table.sort(array, function(a, b)
		return a.username:lower() < b.username:lower()
	end)
end

function Gui.RequestParticipants(silent)
	if not Net.open then
		if not silent then
			Gui.SetStatus("Dashboard", "Not connected to the server", false)
		end
		return
	end
	Net.OnOnce("participants", function(message)
		if message and message.type == "participants" then
			Gui.ApplyParticipantList(message.list)
		elseif not silent then
			if message and type(message.message) == "string" then
				Gui.SetStatus("Dashboard", "List request failed: " .. message.message, false)
			else
				Gui.SetStatus("Dashboard", "Participant list request timed out", false)
			end
		end
	end, 6)
	Net.Send({ type = "participants" })
end

function Gui.ApplyParticipantList(list)
	if type(list) ~= "table" then
		return
	end
	local map = {}
	local array = {}
	for _, item in ipairs(list) do
		if type(item) == "table" and type(item.sessionId) == "string" then
			local entry = BuildEntry(item)
			map[entry.sessionId] = entry
			array[#array + 1] = entry
		end
	end
	SortParticipants(array)
	State.ParticipantMap = map
	State.Participants = array

	if State.Selected then
		local stillThere = map[State.Selected.sessionId]
		if stillThere then
			State.Selected = stillThere
		else
			State.Selected = nil
			Funcs.Notify("Selection cleared", "The selected participant disconnected.", "warn")
		end
	end

	Gui.RenderParticipants()
	Gui.RenderSelection()
	Gui.UpdateConnection()
end

function Gui.OnParticipantJoined(participant)
	if type(participant) ~= "table" or type(participant.sessionId) ~= "string" then
		return
	end
	if participant.sessionId == Net.sessionId then
		return
	end
	local existing = State.ParticipantMap[participant.sessionId]
	if existing then
		local fresh = BuildEntry(participant)
		for key, value in pairs(fresh) do
			existing[key] = value
		end
	else
		local entry = BuildEntry(participant)
		State.ParticipantMap[entry.sessionId] = entry
		State.Participants[#State.Participants + 1] = entry
		SortParticipants(State.Participants)
		Funcs.Notify("Participant connected", entry.username .. " connected.", "info")
	end
	Gui.RenderParticipants()
	Gui.UpdateConnection()
end

function Gui.OnParticipantLeft(message)
	if type(message) ~= "table" or type(message.sessionId) ~= "string" then
		return
	end
	if tonumber(message.userId) == LocalPlayer.UserId then
		return
	end
	local entry = State.ParticipantMap[message.sessionId]
	if not entry then
		return
	end
	State.ParticipantMap[message.sessionId] = nil
	for index, item in ipairs(State.Participants) do
		if item.sessionId == message.sessionId then
			table.remove(State.Participants, index)
			break
		end
	end
	if State.Selected and State.Selected.sessionId == message.sessionId then
		State.Selected = nil
		Funcs.Notify("Selection cleared", "The selected participant disconnected.", "warn")
	end
	Funcs.Notify("Participant disconnected", entry.username .. " disconnected.", "warn")
	Gui.RenderParticipants()
	Gui.RenderSelection()
	Gui.UpdateConnection()
end

function Gui.SelectParticipant(entry)
	State.Selected = entry
	Gui.RenderParticipants()
	Gui.RenderSelection()
	if entry then
		Gui.SetStatus("Dashboard", "Selected " .. entry.username, true)
		Funcs.PlaySound("ping", 0.15)
	end
end

local function ParticipantRow(parent, entry, order)
	local isSelf = (entry.sessionId == Net.sessionId)
	local isSelected = (State.Selected and State.Selected.sessionId == entry.sessionId)

	local row = MkFrame(BG3, UDim2.new(1, 0, 0, 56), parent)
	row.BorderSizePixel = 0
	row.LayoutOrder = order or 0
	MkCorner(10, row)
	local stroke = MkStroke(isSelected and ACCENT or BORDER, isSelected and 1.6 or 1, row)

	local avatar = Instance.new("ImageLabel")
	avatar.BackgroundTransparency = 1
	avatar.BorderSizePixel = 0
	avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(entry.userId) .. "&width=420&height=420&format=png"
	avatar.Size = UDim2.new(0, 34, 0, 34)
	avatar.Position = UDim2.new(0, 11, 0.5, -17)
	avatar.Parent = row
	MkCorner(17, avatar)

	local usernameText = entry.username
	if isSelf then
		usernameText = usernameText .. " (you)"
	end
	local nameLabel = MkLabel(usernameText, F_BOLD, 13, TEXT, row)
	nameLabel.Size = UDim2.new(1, -190, 0, 17)
	nameLabel.Position = UDim2.new(0, 55, 0, 9)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local detailLabel = MkLabel(entry.displayName .. "  ·  " .. tostring(entry.userId) .. "  ·  " .. entry.jobId:sub(1, 8), F_REG, 11, SUBTEXT, row)
	detailLabel.Size = UDim2.new(1, -190, 0, 15)
	detailLabel.Position = UDim2.new(0, 55, 0, 30)
	detailLabel.TextXAlignment = Enum.TextXAlignment.Left
	detailLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local chip = Instance.new("Frame")
	chip.BackgroundColor3 = (entry.role == "developer") and ACCENT or Color3.fromRGB(38, 64, 50)
	chip.BorderSizePixel = 0
	chip.AnchorPoint = Vector2.new(1, 0.5)
	chip.Position = UDim2.new(1, -30, 0.5, 0)
	chip.Size = UDim2.new(0, 0, 0, 20)
	chip.AutomaticSize = Enum.AutomaticSize.X
	chip.Parent = row
	MkCorner(10, chip)
	MkPadding(8, 8, 0, 0, chip)
	local chipText = (entry.role == "developer") and "DEVELOPER" or "ONLINE"
	local chipLabel = MkLabel(chipText, F_BOLD, 9, WHITE, chip)
	chipLabel.Size = UDim2.new(0, 0, 0, 20)
	chipLabel.AutomaticSize = Enum.AutomaticSize.X

	local dot = MkFrame(GREEN, UDim2.new(0, 8, 0, 8), row)
	dot.BorderSizePixel = 0
	dot.AnchorPoint = Vector2.new(1, 0.5)
	dot.Position = UDim2.new(1, -13, 0.5, 0)
	MkCorner(4, dot)

	local overlay = Instance.new("TextButton")
	overlay.BackgroundTransparency = 1
	overlay.BorderSizePixel = 0
	overlay.Text = ""
	overlay.AutoButtonColor = false
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.Parent = row
	overlay.MouseButton1Click:Connect(function()
		Gui.SelectParticipant(entry)
	end)

	return row
end

function Gui.RenderParticipants()
	local host = UI.ParticipantList
	if not host then
		return
	end
	for _, child in ipairs(host:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local query = (State.SearchQuery or ""):lower()
	local shown = 0
	for _, entry in ipairs(State.Participants) do
		local matches = true
		if query ~= "" then
			local haystack = (entry.username .. " " .. entry.displayName .. " " .. tostring(entry.userId)):lower()
			matches = haystack:find(query, 1, true) ~= nil
		end
		if matches then
			shown = shown + 1
			ParticipantRow(host, entry, shown)
		end
	end

	if UI.ParticipantCount then
		UI.ParticipantCount.Text = tostring(#State.Participants) .. " connected"
	end
	if UI.ParticipantEmpty then
		UI.ParticipantEmpty.Visible = (shown == 0)
		UI.ParticipantEmpty.Text = (#State.Participants == 0)
			and "No CPanel participants connected"
			or "No participants match your search"
	end
end

function Gui.RenderSelection()
	local selected = State.Selected

	for _, label in pairs(UI.BannerLabels or {}) do
		if selected then
			label.Text = "Selected: " .. Funcs.Truncate(selected.username, 26)
			label.TextColor3 = TEXT
		else
			label.Text = "No participant selected — open the Dashboard"
			label.TextColor3 = SUBTEXT
		end
	end

	if UI.SelectionName then
		if selected then
			UI.SelectionName.Text = Funcs.Truncate(selected.username, 44)
			UI.SelectionDetails.Text = Funcs.Truncate(selected.displayName, 50) .. "  ·  UserId " .. tostring(selected.userId)
			UI.SelectionMeta.Text = "Place " .. tostring(selected.placeId) .. "  ·  Job " .. Funcs.Truncate(selected.jobId, 38) .. "  ·  Session " .. Funcs.Truncate(selected.sessionId, 12)
			UI.SelectionStatus.Text = (selected.role == "developer")
				and "Connected · DEVELOPER session (cannot be targeted)"
				or "Connected · ready for interactions"
			UI.SelectionStatus.TextColor3 = (selected.role == "developer") and YELLOW or GREEN
			if UI.DeselectBtn then
				UI.DeselectBtn.Visible = true
			end
		else
			UI.SelectionName.Text = "No participant selected"
			UI.SelectionDetails.Text = "Pick a participant from the list above to enable the action tabs."
			UI.SelectionMeta.Text = ""
			UI.SelectionStatus.Text = ""
			if UI.DeselectBtn then
				UI.DeselectBtn.Visible = false
			end
		end
	end
end

local function PageScroll(key)
	return UI.PageScrolls and UI.PageScrolls[key]
end

local function AddSelectionBanner(pageKey, order)
	UI.BannerLabels = UI.BannerLabels or {}
	local scroll = PageScroll(pageKey)
	local card = MkCard(scroll, order, 46)
	card.ClipsDescendants = true

	local label = MkLabel("No participant selected — open the Dashboard", F_MED, 13, SUBTEXT, card)
	label.Size = UDim2.new(1, -132, 1, 0)
	label.Position = UDim2.new(0, 13, 0, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTruncate = Enum.TextTruncate.AtEnd

	local button = MkBtn("Open Dashboard", F_MED, 12, WHITE, ACCENT, card)
	button.Size = UDim2.new(0, 124, 0, 28)
	button.AnchorPoint = Vector2.new(1, 0.5)
	button.Position = UDim2.new(1, -9, 0.5, 0)
	button.MouseButton1Click:Connect(function()
		Gui.SwitchPage("Dashboard")
	end)

	UI.BannerLabels[pageKey] = label
	return label
end

local function AddActionCard(parent, order, title, hint, onClick)
	local card = MkFrame(BG3, UDim2.new(1, 0, 0, 62), parent)
	card.BorderSizePixel = 0
	card.LayoutOrder = order
	MkCorner(10, card)
	local stroke = MkStroke(BORDER, 1, card)

	local titleLabel = MkLabel(title, F_BOLD, 14, TEXT, card)
	titleLabel.Size = UDim2.new(1, -56, 0, 20)
	titleLabel.Position = UDim2.new(0, 14, 0, 12)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local hintLabel = MkLabel(hint, F_REG, 11, SUBTEXT, card)
	hintLabel.Size = UDim2.new(1, -56, 0, 16)
	hintLabel.Position = UDim2.new(0, 14, 0, 35)
	hintLabel.TextXAlignment = Enum.TextXAlignment.Left
	hintLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local chevron = MkLabel("›", F_BOLD, 20, SUBTEXT, card)
	chevron.Size = UDim2.new(0, 26, 1, 0)
	chevron.AnchorPoint = Vector2.new(1, 0)
	chevron.Position = UDim2.new(1, -8, 0, 0)

	local overlay = Instance.new("TextButton")
	overlay.BackgroundTransparency = 1
	overlay.BorderSizePixel = 0
	overlay.Text = ""
	overlay.AutoButtonColor = false
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.Parent = card

	local hoverInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local hoverBg = BG3:Lerp(WHITE, 0.07)
	overlay.MouseEnter:Connect(function()
		TweenService:Create(card, hoverInfo, { BackgroundColor3 = hoverBg }):Play()
		TweenService:Create(stroke, hoverInfo, { Color = ACCENT }):Play()
	end)
	overlay.MouseLeave:Connect(function()
		TweenService:Create(card, hoverInfo, { BackgroundColor3 = BG3 }):Play()
		TweenService:Create(stroke, hoverInfo, { Color = BORDER }):Play()
	end)
	overlay.MouseButton1Click:Connect(function()
		pcall(onClick)
	end)

	return { card = card, title = titleLabel, hint = hintLabel }
end

local function ReadOptional(box, min, max, label)
	local text = tostring(box.Text or ""):match("^%s*(.-)%s*$")
	if text == "" then
		return nil, true
	end
	local value = Funcs.ParseNumber(text, min, max)
	if value == nil then
		return nil, false, label
	end
	return value, true
end

local function AddInfoCard(pageKey, order, heading, hint)
	local scroll = PageScroll(pageKey)
	local card = MkCardAuto(scroll, order)
	MkPadding(14, 14, 12, 12, card)
	local layout = MkList(Enum.FillDirection.Vertical, 7, card)
	layout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	if heading then
		MkHeading(card, heading, 1)
	end
	if hint then
		MkHint(card, hint, 2)
	end
	return card
end

function Gui.BuildDashboardPage()
	local scroll = PageScroll("Dashboard")

	local row = Instance.new("Frame")
	row.BackgroundTransparency = 1
	row.BorderSizePixel = 0
	row.Size = UDim2.new(1, 0, 0, 124)
	row.LayoutOrder = 1
	row.Parent = scroll
	local rowLayout = MkList(Enum.FillDirection.Horizontal, 12, row)
	rowLayout.VerticalAlignment = Enum.VerticalAlignment.Top

	local profileCard = MkFrame(BG2, UDim2.new(0.56, -6, 1, 0), row)
	profileCard.BorderSizePixel = 0
	MkCorner(10, profileCard)
	MkStroke(BORDER, 1, profileCard)

	local avatar = Instance.new("ImageLabel")
	avatar.BackgroundTransparency = 1
	avatar.BorderSizePixel = 0
	avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(LocalPlayer.UserId) .. "&width=420&height=420&format=png"
	avatar.Size = UDim2.new(0, 62, 0, 62)
	avatar.Position = UDim2.new(0, 14, 0, 31)
	avatar.Parent = profileCard
	MkCorner(10, avatar)
	MkStroke(ACCENT, 1.5, avatar)

	local devLabel = MkLabel("Developer", F_BOLD, 15, TEXT, profileCard)
	devLabel.Size = UDim2.new(1, -100, 0, 20)
	devLabel.Position = UDim2.new(0, 90, 0, 24)
	devLabel.TextXAlignment = Enum.TextXAlignment.Left
	devLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local handleLabel = MkLabel("@" .. LocalPlayer.Name .. "  ·  Developer", F_MED, 12, ACCENT, profileCard)
	handleLabel.Size = UDim2.new(1, -100, 0, 16)
	handleLabel.Position = UDim2.new(0, 90, 0, 48)
	handleLabel.TextXAlignment = Enum.TextXAlignment.Left
	handleLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local idLabel = MkLabel("UserId: " .. tostring(LocalPlayer.UserId), F_REG, 11, SUBTEXT, profileCard)
	idLabel.Size = UDim2.new(1, -100, 0, 14)
	idLabel.Position = UDim2.new(0, 90, 0, 68)
	idLabel.TextXAlignment = Enum.TextXAlignment.Left

	local roleBadge = MkLabel("Authenticated via access.json on the WebSocket", F_REG, 10, SUBTEXT, profileCard)
	roleBadge.Size = UDim2.new(1, -100, 0, 12)
	roleBadge.Position = UDim2.new(0, 90, 0, 86)
	roleBadge.TextXAlignment = Enum.TextXAlignment.Left
	roleBadge.TextTruncate = Enum.TextTruncate.AtEnd

	local connCard = MkFrame(BG2, UDim2.new(0.44, -6, 1, 0), row)
	connCard.BorderSizePixel = 0
	MkCorner(10, connCard)
	MkStroke(BORDER, 1, connCard)

	local connHeading = MkLabel("Connection", F_BOLD, 13, TEXT, connCard)
	connHeading.Size = UDim2.new(1, -24, 0, 16)
	connHeading.Position = UDim2.new(0, 12, 0, 12)
	connHeading.TextXAlignment = Enum.TextXAlignment.Left

	local connStatus = MkLabel("—", F_MED, 12, SUBTEXT, connCard)
	connStatus.Size = UDim2.new(1, -24, 0, 15)
	connStatus.Position = UDim2.new(0, 12, 0, 34)
	connStatus.TextXAlignment = Enum.TextXAlignment.Left
	connStatus.TextTruncate = Enum.TextTruncate.AtEnd
	UI.ConnStatusText = connStatus

	local connEndpoint = MkLabel("—", F_REG, 11, SUBTEXT, connCard)
	connEndpoint.Size = UDim2.new(1, -24, 0, 13)
	connEndpoint.Position = UDim2.new(0, 12, 0, 53)
	connEndpoint.TextXAlignment = Enum.TextXAlignment.Left
	connEndpoint.TextTruncate = Enum.TextTruncate.AtEnd
	UI.ConnEndpoint = connEndpoint

	local connSession = MkLabel("—", F_REG, 11, SUBTEXT, connCard)
	connSession.Size = UDim2.new(1, -24, 0, 13)
	connSession.Position = UDim2.new(0, 12, 0, 70)
	connSession.TextXAlignment = Enum.TextXAlignment.Left
	connSession.TextTruncate = Enum.TextTruncate.AtEnd
	UI.ConnSession = connSession

	local connCounts = MkLabel("—", F_REG, 11, SUBTEXT, connCard)
	connCounts.Size = UDim2.new(1, -24, 0, 13)
	connCounts.Position = UDim2.new(0, 12, 0, 87)
	connCounts.TextXAlignment = Enum.TextXAlignment.Left
	UI.ConnCounts = connCounts

	local partCard = MkFrame(BG2, UDim2.new(1, 0, 0, 288), scroll)
	partCard.BorderSizePixel = 0
	partCard.LayoutOrder = 2
	MkCorner(10, partCard)
	MkStroke(BORDER, 1, partCard)

	local partHeading = MkLabel("Participants", F_BOLD, 14, TEXT, partCard)
	partHeading.Size = UDim2.new(0, 110, 0, 20)
	partHeading.Position = UDim2.new(0, 14, 0, 12)
	partHeading.TextXAlignment = Enum.TextXAlignment.Left

	local partCount = MkLabel("0 connected", F_REG, 11, SUBTEXT, partCard)
	partCount.Size = UDim2.new(0, 110, 0, 14)
	partCount.Position = UDim2.new(0, 14, 0, 32)
	partCount.TextXAlignment = Enum.TextXAlignment.Left
	UI.ParticipantCount = partCount

	local searchBox = MkInput(partCard, "Search…", 0, 170)
	searchBox.AnchorPoint = Vector2.new(1, 0)
	searchBox.Position = UDim2.new(1, -102, 0, 11)
	searchBox.ClearTextOnFocus = false
	UI.SearchBox = searchBox
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		State.SearchQuery = searchBox.Text
		Gui.RenderParticipants()
	end)

	local refreshBtn = MkBtn("Refresh", F_MED, 12, TEXT, BG3, partCard)
	refreshBtn.Size = UDim2.new(0, 84, 0, 32)
	refreshBtn.AnchorPoint = Vector2.new(1, 0)
	refreshBtn.Position = UDim2.new(1, -12, 0, 11)
	refreshBtn.MouseButton1Click:Connect(function()
		Gui.RequestParticipants(false)
	end)

	local listHost = MkScroll(partCard)
	listHost.Position = UDim2.new(0, 10, 0, 56)
	listHost.Size = UDim2.new(1, -20, 1, -68)
	MkList(Enum.FillDirection.Vertical, 6, listHost)
	MkPadding(0, 0, 0, 8, listHost)
	UI.ParticipantList = listHost

	local emptyLabel = MkLabel("No CPanel participants connected", F_MED, 13, SUBTEXT, partCard)
	emptyLabel.Size = UDim2.new(1, -20, 0, 40)
	emptyLabel.Position = UDim2.new(0, 10, 0, 70)
	emptyLabel.Visible = false
	emptyLabel.ZIndex = 4
	UI.ParticipantEmpty = emptyLabel

	local selCard = MkFrame(BG2, UDim2.new(1, 0, 0, 100), scroll)
	selCard.BorderSizePixel = 0
	selCard.LayoutOrder = 3
	MkCorner(10, selCard)
	MkStroke(BORDER, 1, selCard)

	local selName = MkLabel("No participant selected", F_BOLD, 14, TEXT, selCard)
	selName.Size = UDim2.new(1, -130, 0, 20)
	selName.Position = UDim2.new(0, 14, 0, 12)
	selName.TextXAlignment = Enum.TextXAlignment.Left
	selName.TextTruncate = Enum.TextTruncate.AtEnd
	UI.SelectionName = selName

	local selDetails = MkLabel("Pick a participant from the list above to enable the action tabs.", F_MED, 12, SUBTEXT, selCard)
	selDetails.Size = UDim2.new(1, -130, 0, 16)
	selDetails.Position = UDim2.new(0, 14, 0, 36)
	selDetails.TextXAlignment = Enum.TextXAlignment.Left
	selDetails.TextTruncate = Enum.TextTruncate.AtEnd
	UI.SelectionDetails = selDetails

	local selMeta = MkLabel("", F_REG, 11, SUBTEXT, selCard)
	selMeta.Size = UDim2.new(1, -130, 0, 14)
	selMeta.Position = UDim2.new(0, 14, 0, 56)
	selMeta.TextXAlignment = Enum.TextXAlignment.Left
	selMeta.TextTruncate = Enum.TextTruncate.AtEnd
	UI.SelectionMeta = selMeta

	local selStatus = MkLabel("", F_REG, 11, SUBTEXT, selCard)
	selStatus.Size = UDim2.new(1, -130, 0, 14)
	selStatus.Position = UDim2.new(0, 14, 0, 74)
	selStatus.TextXAlignment = Enum.TextXAlignment.Left
	selStatus.TextTruncate = Enum.TextTruncate.AtEnd
	UI.SelectionStatus = selStatus

	local deselectBtn = MkBtn("Deselect", F_MED, 12, TEXT, BG3, selCard)
	deselectBtn.Size = UDim2.new(0, 84, 0, 30)
	deselectBtn.AnchorPoint = Vector2.new(1, 0.5)
	deselectBtn.Position = UDim2.new(1, -12, 0.5, 0)
	deselectBtn.Visible = false
	deselectBtn.MouseButton1Click:Connect(function()
		Gui.SelectParticipant(nil)
	end)
	UI.DeselectBtn = deselectBtn

	local mgmtCard = MkCardAuto(scroll, 4)
	MkPadding(14, 14, 12, 12, mgmtCard)
	local mgmtLayout = MkList(Enum.FillDirection.Vertical, 8, mgmtCard)
	mgmtLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill

	MkHeading(mgmtCard, "Effect Management", 1)
	MkHint(mgmtCard, "Sent to the selected participant. All effects are temporary, reversible and clean themselves up when they expire.", 2)

	local btnRow1 = Instance.new("Frame")
	btnRow1.BackgroundTransparency = 1
	btnRow1.BorderSizePixel = 0
	btnRow1.Size = UDim2.new(1, 0, 0, 34)
	btnRow1.LayoutOrder = 3
	btnRow1.Parent = mgmtCard
	MkList(Enum.FillDirection.Horizontal, 8, btnRow1)

	local stopAllBtn = MkBtn("Stop All Effects", F_MED, 12, TEXT, BG3, btnRow1)
	stopAllBtn.Size = UDim2.new(0, 124, 0, 34)
	stopAllBtn.LayoutOrder = 1
	MkCorner(8, stopAllBtn)

	local clearTempBtn = MkBtn("Clear Temporary", F_MED, 12, TEXT, BG3, btnRow1)
	clearTempBtn.Size = UDim2.new(0, 126, 0, 34)
	clearTempBtn.LayoutOrder = 2
	MkCorner(8, clearTempBtn)

	local restoreDefaultsBtn = MkBtn("Restore Defaults", F_MED, 12, TEXT, BG3, btnRow1)
	restoreDefaultsBtn.Size = UDim2.new(0, 128, 0, 34)
	restoreDefaultsBtn.LayoutOrder = 3
	MkCorner(8, restoreDefaultsBtn)

	local btnRow2 = Instance.new("Frame")
	btnRow2.BackgroundTransparency = 1
	btnRow2.BorderSizePixel = 0
	btnRow2.Size = UDim2.new(1, 0, 0, 34)
	btnRow2.LayoutOrder = 4
	btnRow2.Parent = mgmtCard
	MkList(Enum.FillDirection.Horizontal, 8, btnRow2)

	local refreshStatusBtn = MkBtn("Refresh Status", F_MED, 12, TEXT, BG3, btnRow2)
	refreshStatusBtn.Size = UDim2.new(0, 116, 0, 34)
	refreshStatusBtn.LayoutOrder = 1
	MkCorner(8, refreshStatusBtn)

	local effectStatus = MkLabel(State.LastActionStatus or "Idle", F_REG, 11, SUBTEXT, btnRow2)
	effectStatus.Size = UDim2.new(1, -124, 1, 0)
	effectStatus.LayoutOrder = 2
	effectStatus.TextXAlignment = Enum.TextXAlignment.Left
	effectStatus.TextTruncate = Enum.TextTruncate.AtEnd
	UI.EffectStatusText = effectStatus

	local function EffectResult(ok, message)
		if UI.EffectStatusText then
			UI.EffectStatusText.Text = Funcs.Truncate(message, 90)
			UI.EffectStatusText.TextColor3 = ok and GREEN or RED
		end
	end

	stopAllBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("stop_all_effects", "Dashboard", nil, stopAllBtn, EffectResult)
	end)
	clearTempBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("clear_temporary_effects", "Dashboard", nil, clearTempBtn, EffectResult)
	end)
	restoreDefaultsBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("restore_default_effects", "Dashboard", nil, restoreDefaultsBtn, EffectResult)
	end)
	refreshStatusBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("query_effects", "Dashboard", nil, refreshStatusBtn, EffectResult)
	end)
end

function Gui.BuildPlayerPage()
	local scroll = PageScroll("Player")
	AddSelectionBanner("Player", 1)
	AddInfoCard("Player", 2, "About Player Actions",
		"These actions run on the experience's server and are only executed when the compatible experience explicitly authorizes them (CPanelBridge RemoteEvent or an experience hook). Without authorization the action is refused — no remote-event abuse, no forced character control.")

	local definitions = {
		{ action = "freeze", title = "Freeze", hint = "Temporarily immobilize the participant" },
		{ action = "unfreeze", title = "Unfreeze", hint = "Restore normal movement" },
		{ action = "kill", title = "Kill / Reset", hint = "Reset the participant's character" },
		{ action = "bring", title = "Bring", hint = "Move the participant to you (experience server)" },
		{ action = "goto", title = "Goto", hint = "Move to the participant (experience server)" },
	}
	for index, definition in ipairs(definitions) do
		local card = AddActionCard(scroll, 2 + index, definition.title, definition.hint, nil)
		local overlay = card.card:FindFirstChildOfClass("TextButton")
		if overlay then
			overlay.MouseButton1Click:Connect(function()
				Gui.RunAction(definition.action, "Player", function()
					return {}
				end, card.title)
			end)
		end
	end
	Gui.SetStatus("Player", "", nil)
end

function Gui.BuildAudioPage()
	local scroll = PageScroll("Audio")
	AddSelectionBanner("Audio", 1)

	local playCard = MkCardAuto(scroll, 2)
	MkPadding(14, 14, 12, 12, playCard)
	local playLayout = MkList(Enum.FillDirection.Vertical, 8, playCard)
	playLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill

	MkHeading(playCard, "Play Sound", 1)
	MkHint(playCard, "Numeric Roblox audio asset id — rbxassetid:// formatting is accepted. Restricted or unavailable assets are reported as failed.", 2)

	local assetBox = MkInput(playCard, "Asset ID — e.g. 1234567890", 3)
	UI.AudioAssetBox = assetBox

	local volRow = Instance.new("Frame")
	volRow.BackgroundTransparency = 1
	volRow.BorderSizePixel = 0
	volRow.Size = UDim2.new(1, 0, 0, 34)
	volRow.LayoutOrder = 4
	volRow.Parent = playCard

	local volLabel = MkLabel("Volume (0.10 – 10.00)", F_MED, 12, TEXT, volRow)
	volLabel.Size = UDim2.new(0, 140, 1, 0)
	volLabel.Position = UDim2.new(0, 0, 0, 0)
	volLabel.TextXAlignment = Enum.TextXAlignment.Left

	local volumeBox = MkInput(volRow, "1.00", 0, 90)
	volumeBox.AnchorPoint = Vector2.new(1, 0.5)
	volumeBox.Position = UDim2.new(1, -118, 0.5, 0)
	volumeBox.Text = "1.00"
	UI.AudioVolumeBox = volumeBox

	local playBtn = MkBtn("Play", F_BOLD, 13, WHITE, ACCENT, volRow)
	playBtn.Size = UDim2.new(0, 106, 0, 34)
	playBtn.AnchorPoint = Vector2.new(1, 0.5)
	playBtn.Position = UDim2.new(1, 0, 0.5, 0)
	MkCorner(8, playBtn)

	local ctrlCard = MkCardAuto(scroll, 3)
	MkPadding(14, 14, 12, 12, ctrlCard)
	local ctrlLayout = MkList(Enum.FillDirection.Vertical, 8, ctrlCard)
	ctrlLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkHeading(ctrlCard, "Sound Controls", 1)

	local function ControlRow(order, layoutOrderStart)
		local row = Instance.new("Frame")
		row.BackgroundTransparency = 1
		row.BorderSizePixel = 0
		row.Size = UDim2.new(1, 0, 0, 34)
		row.LayoutOrder = order
		row.Parent = ctrlCard
		MkList(Enum.FillDirection.Horizontal, 8, row)
		return row
	end

	local function ControlButton(parent, text, width, order)
		local button = MkBtn(text, F_MED, 12, TEXT, BG3, parent)
		button.Size = UDim2.new(0, width, 0, 34)
		button.LayoutOrder = order
		MkCorner(8, button)
		return button
	end

	local function AudioResult(ok, message)
		if UI.AudioStatusText then
			UI.AudioStatusText.Text = Funcs.Truncate(message, 120)
			UI.AudioStatusText.TextColor3 = ok and GREEN or RED
		end
	end

	local row1 = ControlRow(2)
	local stopBtn = ControlButton(row1, "Stop", 92, 1)
	local loopBtn = ControlButton(row1, "Loop", 92, 2)
	local unloopBtn = ControlButton(row1, "Disable Loop", 116, 3)
	local row2 = ControlRow(3)
	local adjustBtn = ControlButton(row2, "Adjust Volume", 124, 1)
	local restoreVolBtn = ControlButton(row2, "Restore Default", 140, 2)
	local stopAllBtn = ControlButton(row2, "Stop All Sounds", 134, 3)

	stopBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("stop_sound", "Audio", nil, stopBtn, AudioResult)
	end)
	loopBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("loop_sound", "Audio", function()
			return { enabled = true }
		end, loopBtn, AudioResult)
	end)
	unloopBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("loop_sound", "Audio", function()
			return { enabled = false }
		end, unloopBtn, AudioResult)
	end)
	adjustBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("set_volume", "Audio", function()
			local volume = Funcs.ParseNumber(volumeBox.Text, 0.1, 10)
			if not volume then
				return false, "Volume must be between 0.10 and 10.00"
			end
			return { volume = volume }
		end, adjustBtn, AudioResult)
	end)
	restoreVolBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("restore_volume", "Audio", nil, restoreVolBtn, AudioResult)
	end)
	stopAllBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("stop_all_sounds", "Audio", nil, stopAllBtn, AudioResult)
	end)

	playBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("play_sound", "Audio", function()
			local assetId = Funcs.ParseAssetId(assetBox.Text)
			if not assetId then
				return false, "Enter a numeric audio asset id (rbxassetid:// also works)"
			end
			local volume = Funcs.ParseNumber(volumeBox.Text, 0.1, 10)
			if not volume then
				return false, "Volume must be between 0.10 and 10.00"
			end
			return { assetId = assetId, volume = volume }
		end, playBtn, AudioResult)
	end)

	local statusCard = MkCardAuto(scroll, 4)
	MkPadding(14, 14, 12, 12, statusCard)
	local statusLayout = MkList(Enum.FillDirection.Vertical, 8, statusCard)
	statusLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkHeading(statusCard, "Playback Status", 1)

	local statusText = MkLabel("No status yet", F_MED, 12, SUBTEXT, statusCard)
	statusText.Size = UDim2.new(1, 0, 0, 16)
	statusText.TextXAlignment = Enum.TextXAlignment.Left
	statusText.TextTruncate = Enum.TextTruncate.AtEnd
	statusText.LayoutOrder = 2
	UI.AudioStatusText = statusText

	local queryBtn = MkBtn("Refresh Status", F_MED, 12, TEXT, BG3, statusCard)
	queryBtn.Size = UDim2.new(0, 116, 0, 32)
	queryBtn.LayoutOrder = 3
	MkCorner(8, queryBtn)
	queryBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("query_audio_status", "Audio", nil, queryBtn, AudioResult)
	end)
end

function Gui.BuildVisualPage()
	local scroll = PageScroll("Visual")
	AddSelectionBanner("Visual", 1)

	local paramCard = MkCardAuto(scroll, 2)
	MkPadding(14, 14, 12, 12, paramCard)
	local paramLayout = MkList(Enum.FillDirection.Vertical, 8, paramCard)
	paramLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkHeading(paramCard, "Parameters", 1)
	MkHint(paramCard, "Duration in seconds (0.2 – 120). Leave a field empty to use the effect's default.", 2)

	local durationRow = Instance.new("Frame")
	durationRow.BackgroundTransparency = 1
	durationRow.BorderSizePixel = 0
	durationRow.Size = UDim2.new(1, 0, 0, 34)
	durationRow.LayoutOrder = 3
	durationRow.Parent = paramCard

	local durationLabel = MkLabel("Duration (s)", F_MED, 12, TEXT, durationRow)
	durationLabel.Size = UDim2.new(0, 120, 1, 0)
	durationLabel.TextXAlignment = Enum.TextXAlignment.Left

	local durationBox = MkInput(durationRow, "5", 0, 80)
	durationBox.AnchorPoint = Vector2.new(1, 0.5)
	durationBox.Position = UDim2.new(1, 0, 0.5, 0)
	UI.VisualDurationBox = durationBox

	local colorRow = Instance.new("Frame")
	colorRow.BackgroundTransparency = 1
	colorRow.BorderSizePixel = 0
	colorRow.Size = UDim2.new(1, 0, 0, 34)
	colorRow.LayoutOrder = 4
	colorRow.Parent = paramCard

	local colorLabel = MkLabel("Color (R / G / B)", F_MED, 12, TEXT, colorRow)
	colorLabel.Size = UDim2.new(0, 130, 1, 0)
	colorLabel.TextXAlignment = Enum.TextXAlignment.Left

	local redBox = MkInput(colorRow, "R", 0, 58)
	redBox.AnchorPoint = Vector2.new(1, 0.5)
	redBox.Position = UDim2.new(1, -132, 0.5, 0)
	redBox.PlaceholderText = "R"
	UI.ColorRBox = redBox

	local greenBox = MkInput(colorRow, "G", 0, 58)
	greenBox.AnchorPoint = Vector2.new(1, 0.5)
	greenBox.Position = UDim2.new(1, -68, 0.5, 0)
	greenBox.PlaceholderText = "G"
	UI.ColorGBox = greenBox

	local blueBox = MkInput(colorRow, "B", 0, 58)
	blueBox.AnchorPoint = Vector2.new(1, 0.5)
	blueBox.Position = UDim2.new(1, -4, 0.5, 0)
	blueBox.PlaceholderText = "B"
	UI.ColorBBox = blueBox

	local function VisualArgs(extraBuilder)
		return function()
			local args = {}
			local duration, durationOk, durationErr = ReadOptional(durationBox, 0.2, 120, "Duration")
			if durationOk == false then
				return false, durationErr .. " must be 0.2 to 120 seconds"
			end
			if duration then
				args.duration = duration
			end
			if extraBuilder then
				local extra, err = extraBuilder()
				if extra == false then
					return false, err
				end
				if type(extra) == "table" then
					for key, value in pairs(extra) do
						args[key] = value
					end
				end
			end
			return args
		end
	end

	local function ReadColor()
		local r, rOk, rErr = ReadOptional(redBox, 0, 255, "Red")
		if rOk == false then
			return false, rErr .. " must be 0 to 255"
		end
		local g, gOk, gErr = ReadOptional(greenBox, 0, 255, "Green")
		if gOk == false then
			return false, gErr .. " must be 0 to 255"
		end
		local b, bOk, bErr = ReadOptional(blueBox, 0, 255, "Blue")
		if bOk == false then
			return false, bErr .. " must be 0 to 255"
		end
		return { r = r, g = g, b = b }
	end

	local definitions = {
		{ action = "screen_flash", title = "Screen Flash", hint = "Brief full-screen flash" },
		{ action = "color_effect", title = "Color Effect", hint = "Temporary color grading (uses R/G/B)", extra = ReadColor },
		{ action = "blur", title = "Blur", hint = "Temporary screen blur" },
		{ action = "fov_increase", title = "FOV Increase", hint = "Temporarily widen the camera FOV" },
		{ action = "fov_decrease", title = "FOV Decrease", hint = "Temporarily narrow the camera FOV" },
		{ action = "fov_reset", title = "FOV Reset", hint = "Restore the normal field of view" },
		{ action = "grayscale", title = "Grayscale", hint = "Temporary desaturation" },
		{ action = "invert_colors", title = "Invert Colors", hint = "Temporary color inversion (approximation)" },
		{ action = "screen_tint", title = "Screen Tint", hint = "Temporary full-screen tint (uses R/G/B)" },
		{ action = "restore_visual", title = "Restore Effects", hint = "Remove all CPanel visual effects" },
	}
	for index, definition in ipairs(definitions) do
		local card = AddActionCard(scroll, 2 + index, definition.title, definition.hint, nil)
		local overlay = card.card:FindFirstChildOfClass("TextButton")
		if overlay then
			overlay.MouseButton1Click:Connect(function()
				Gui.RunAction(definition.action, "Visual", VisualArgs(definition.extra), card.title)
			end)
		end
	end
end

function Gui.BuildFunPage()
	local scroll = PageScroll("Fun")
	AddSelectionBanner("Fun", 1)

	local paramCard = MkCardAuto(scroll, 2)
	MkPadding(14, 14, 12, 12, paramCard)
	local paramLayout = MkList(Enum.FillDirection.Vertical, 8, paramCard)
	paramLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkHeading(paramCard, "Parameters", 1)
	MkHint(paramCard, "Duration in seconds (0.2 – 120). Text and intensity apply to the matching effects.", 2)

	local durationRow = Instance.new("Frame")
	durationRow.BackgroundTransparency = 1
	durationRow.BorderSizePixel = 0
	durationRow.Size = UDim2.new(1, 0, 0, 34)
	durationRow.LayoutOrder = 3
	durationRow.Parent = paramCard

	local durationLabel = MkLabel("Duration (s)", F_MED, 12, TEXT, durationRow)
	durationLabel.Size = UDim2.new(0, 120, 1, 0)
	durationLabel.TextXAlignment = Enum.TextXAlignment.Left

	local durationBox = MkInput(durationRow, "5", 0, 80)
	durationBox.AnchorPoint = Vector2.new(1, 0.5)
	durationBox.Position = UDim2.new(1, 0, 0.5, 0)
	UI.FunDurationBox = durationBox

	local nameplateBox = MkInput(paramCard, "Nameplate text (default: ★ CPanel ★)", 4)
	UI.NameplateBox = nameplateBox

	local overheadBox = MkInput(paramCard, "Overhead notification text (default: CPanel was here!)", 5)
	UI.OverheadBox = overheadBox

	local intensityRow = Instance.new("Frame")
	intensityRow.BackgroundTransparency = 1
	intensityRow.BorderSizePixel = 0
	intensityRow.Size = UDim2.new(1, 0, 0, 34)
	intensityRow.LayoutOrder = 6
	intensityRow.Parent = paramCard

	local intensityLabel = MkLabel("Shake intensity (0.02 – 1.00)", F_MED, 12, TEXT, intensityRow)
	intensityLabel.Size = UDim2.new(0, 200, 1, 0)
	intensityLabel.TextXAlignment = Enum.TextXAlignment.Left

	local intensityBox = MkInput(intensityRow, "0.15", 0, 80)
	intensityBox.AnchorPoint = Vector2.new(1, 0.5)
	intensityBox.Position = UDim2.new(1, 0, 0.5, 0)
	intensityBox.Text = "0.15"
	UI.ShakeBox = intensityBox

	local function FunArgs(extraBuilder)
		return function()
			local args = {}
			local duration, durationOk, durationErr = ReadOptional(durationBox, 0.2, 120, "Duration")
			if durationOk == false then
				return false, durationErr .. " must be 0.2 to 120 seconds"
			end
			if duration then
				args.duration = duration
			end
			if extraBuilder then
				local extra, err = extraBuilder()
				if extra == false then
					return false, err
				end
				if type(extra) == "table" then
					for key, value in pairs(extra) do
						args[key] = value
					end
				end
			end
			return args
		end
	end

	local function ReadColor()
		local r, rOk, rErr = ReadOptional(UI.ColorRBox, 0, 255, "Red")
		if rOk == false then
			return false, rErr .. " must be 0 to 255"
		end
		local g, gOk, gErr = ReadOptional(UI.ColorGBox, 0, 255, "Green")
		if gOk == false then
			return false, gErr .. " must be 0 to 255"
		end
		local b, bOk, bErr = ReadOptional(UI.ColorBBox, 0, 255, "Blue")
		if bOk == false then
			return false, bErr .. " must be 0 to 255"
		end
		return { r = r, g = g, b = b }
	end

	local function ReadText(box, fallback)
		local text = Funcs.SafeText(box.Text, 48, "")
		if text == "" then
			return {}
		end
		return { text = text }
	end

	local function ReadShake()
		local intensity, ok, err = ReadOptional(intensityBox, 0.02, 1, "Shake intensity")
		if ok == false then
			return false, err .. " must be 0.02 to 1.00"
		end
		return { intensity = intensity }
	end

	local definitions = {
		{ action = "highlight", title = "Character Highlight", hint = "Temporary highlight on the character (uses R/G/B)", extra = ReadColor },
		{ action = "outline", title = "Character Outline", hint = "Outline-only highlight (uses R/G/B)", extra = ReadColor },
		{ action = "nameplate", title = "Nameplate Decoration", hint = "Overhead nameplate for a while", extra = function() return ReadText(nameplateBox) end },
		{ action = "overhead_notify", title = "Overhead Notification", hint = "Pulsing overhead message", extra = function() return ReadText(overheadBox) end },
		{ action = "vignette", title = "Screen Vignette", hint = "Dark vignette around the screen edges" },
		{ action = "camera_shake", title = "Camera Shake", hint = "Lightweight camera shake", extra = ReadShake },
		{ action = "camera_zoom", title = "Camera Zoom", hint = "Zoom the camera in and lock it" },
		{ action = "lighting_effect", title = "Lighting Effect", hint = "Temporary lighting mood (uses R/G/B)", extra = ReadColor },
		{ action = "particle_effect", title = "Particle Effect", hint = "Character sparkles (uses R/G/B)", extra = ReadColor },
		{ action = "distortion", title = "Visual Distortion", hint = "Pulsing color distortion (approximation)" },
		{ action = "confetti", title = "Confetti", hint = "Falling confetti on their screen" },
		{ action = "stop_all_effects", title = "Restore All Effects", hint = "Stop every active CPanel effect" },
	}
	for index, definition in ipairs(definitions) do
		local card = AddActionCard(scroll, 2 + index, definition.title, definition.hint, nil)
		local overlay = card.card:FindFirstChildOfClass("TextButton")
		if overlay then
			overlay.MouseButton1Click:Connect(function()
				local builder = nil
				if definition.extra then
					builder = FunArgs(definition.extra)
				else
					builder = FunArgs(nil)
				end
				Gui.RunAction(definition.action, "Fun", builder, card.title)
			end)
		end
	end
end

function Gui.BuildSettingsPage()
	local scroll = PageScroll("Settings")

	local appearanceCard = MkCardAuto(scroll, 1)
	MkPadding(14, 14, 12, 12, appearanceCard)
	local appearanceLayout = MkList(Enum.FillDirection.Vertical, 6, appearanceCard)
	appearanceLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkHeading(appearanceCard, "Appearance", 1)

	local themeNames = {}
	for name in pairs(Themes) do
		themeNames[#themeNames + 1] = name
	end
	table.sort(themeNames)
	local themeIndex = 1
	for index, name in ipairs(themeNames) do
		if name == Settings.Theme then
			themeIndex = index
		end
	end

	local themeRow, themeLabel = (function()
		local row = Instance.new("Frame")
		row.BackgroundTransparency = 1
		row.BorderSizePixel = 0
		row.Size = UDim2.new(1, 0, 0, 36)
		row.LayoutOrder = 2
		row.Parent = appearanceCard
		local label = MkLabel("UI theme", F_MED, 13, TEXT, row)
		label.Size = UDim2.new(1, -184, 1, 0)
		label.TextXAlignment = Enum.TextXAlignment.Left
		return row, label
	end)()

	local themeCycle = Gui.MakeCycle(appearanceCard, themeNames, themeIndex, 2, function(themeName)
		Gui.ApplyTheme(themeName)
		Funcs.Notify("Theme changed", "UI theme set to " .. tostring(themeName) .. ".", "info")
	end)
	themeCycle.button.AnchorPoint = Vector2.new(1, 0.5)
	themeCycle.button.Position = UDim2.new(1, 0, 0.5, 0)
	themeCycle.button.Size = UDim2.new(0, 170, 0, 32)
	themeCycle.button.Parent = themeRow
	themeCycle.button.LayoutOrder = 0
	themeCycle.SetIndex(themeIndex)
	UI.ThemeCycle = themeCycle

	local transparencyLabel = MkLabel("UI transparency", F_MED, 13, TEXT, appearanceCard)
	transparencyLabel.Size = UDim2.new(1, 0, 0, 16)
	transparencyLabel.TextXAlignment = Enum.TextXAlignment.Left
	transparencyLabel.LayoutOrder = 3

	local transparencySlider = Gui.MakeSlider(appearanceCard, 0, 0.5, Settings.Transparency, 4, function(value)
		Settings.Transparency = math.floor(value * 100 + 0.5) / 100
		Gui.ApplyTransparency()
		Funcs.SaveSettings()
	end)
	UI.TransparencySlider = transparencySlider
	UI.Sliders = UI.Sliders or {}
	UI.Sliders["transparency"] = { fill = transparencySlider.fill }

	local animationsRow, animationsLabel = (function()
		local row = Instance.new("Frame")
		row.BackgroundTransparency = 1
		row.BorderSizePixel = 0
		row.Size = UDim2.new(1, 0, 0, 34)
		row.LayoutOrder = 5
		row.Parent = appearanceCard
		local label = MkLabel("Animations", F_MED, 13, TEXT, row)
		label.Size = UDim2.new(1, -60, 1, 0)
		label.TextXAlignment = Enum.TextXAlignment.Left
		return row, label
	end)()
	local animationsToggle = Gui.MakeToggle(animationsRow, Settings.Animations, function(value)
		Settings.Animations = value
		Funcs.SaveSettings()
	end)
	animationsToggle.holder.AnchorPoint = Vector2.new(1, 0.5)
	animationsToggle.holder.Position = UDim2.new(1, 0, 0.5, 0)
	UI.AnimationsToggle = animationsToggle

	local soundsRow = Instance.new("Frame")
	soundsRow.BackgroundTransparency = 1
	soundsRow.BorderSizePixel = 0
	soundsRow.Size = UDim2.new(1, 0, 0, 34)
	soundsRow.LayoutOrder = 6
	soundsRow.Parent = appearanceCard
	local soundsLabel = MkLabel("Interface sounds", F_MED, 13, TEXT, soundsRow)
	soundsLabel.Size = UDim2.new(1, -60, 1, 0)
	soundsLabel.TextXAlignment = Enum.TextXAlignment.Left
	local soundsToggle = Gui.MakeToggle(soundsRow, Settings.Sounds, function(value)
		Settings.Sounds = value
		Funcs.SaveSettings()
	end)
	soundsToggle.holder.AnchorPoint = Vector2.new(1, 0.5)
	soundsToggle.holder.Position = UDim2.new(1, 0, 0.5, 0)
	UI.SoundsToggle = soundsToggle

	local notifCard = MkCardAuto(scroll, 2)
	MkPadding(14, 14, 12, 12, notifCard)
	local notifLayout = MkList(Enum.FillDirection.Vertical, 6, notifCard)
	notifLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkHeading(notifCard, "Notifications", 1)

	local notifRow = Instance.new("Frame")
	notifRow.BackgroundTransparency = 1
	notifRow.BorderSizePixel = 0
	notifRow.Size = UDim2.new(1, 0, 0, 34)
	notifRow.LayoutOrder = 2
	notifRow.Parent = notifCard
	local notifLabel = MkLabel("Toast notifications", F_MED, 13, TEXT, notifRow)
	notifLabel.Size = UDim2.new(1, -60, 1, 0)
	notifLabel.TextXAlignment = Enum.TextXAlignment.Left
	local notifToggle = Gui.MakeToggle(notifRow, Settings.Notifications, function(value)
		Settings.Notifications = value
		Funcs.SaveSettings()
	end)
	notifToggle.holder.AnchorPoint = Vector2.new(1, 0.5)
	notifToggle.holder.Position = UDim2.new(1, 0, 0.5, 0)
	UI.NotificationsToggle = notifToggle

	local netCard = MkCardAuto(scroll, 3)
	MkPadding(14, 14, 12, 12, netCard)
	local netLayout = MkList(Enum.FillDirection.Vertical, 6, netCard)
	netLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkHeading(netCard, "Connection", 1)

	local netStatusRow = Instance.new("Frame")
	netStatusRow.BackgroundTransparency = 1
	netStatusRow.BorderSizePixel = 0
	netStatusRow.Size = UDim2.new(1, 0, 0, 24)
	netStatusRow.LayoutOrder = 2
	netStatusRow.Parent = netCard
	local netStatusLabel = MkLabel("WebSocket status", F_MED, 13, TEXT, netStatusRow)
	netStatusLabel.Size = UDim2.new(1, -140, 1, 0)
	netStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
	local netStatusValue = MkLabel("—", F_MED, 12, SUBTEXT, netStatusRow)
	netStatusValue.Size = UDim2.new(0, 130, 1, 0)
	netStatusValue.AnchorPoint = Vector2.new(1, 0)
	netStatusValue.Position = UDim2.new(1, 0, 0, 0)
	netStatusValue.TextXAlignment = Enum.TextXAlignment.Right
	UI.SettingsStatusText = netStatusValue

	MkHint(netCard, "Endpoint: " .. WebsocketUrl, 3)

	local autoRow = Instance.new("Frame")
	autoRow.BackgroundTransparency = 1
	autoRow.BorderSizePixel = 0
	autoRow.Size = UDim2.new(1, 0, 0, 34)
	autoRow.LayoutOrder = 4
	autoRow.Parent = netCard
	local autoLabel = MkLabel("Auto-reconnect", F_MED, 13, TEXT, autoRow)
	autoLabel.Size = UDim2.new(1, -60, 1, 0)
	autoLabel.TextXAlignment = Enum.TextXAlignment.Left
	local autoToggle = Gui.MakeToggle(autoRow, Settings.AutoReconnect, function(value)
		Settings.AutoReconnect = value
		Funcs.SaveSettings()
	end)
	autoToggle.holder.AnchorPoint = Vector2.new(1, 0.5)
	autoToggle.holder.Position = UDim2.new(1, 0, 0.5, 0)
	UI.AutoReconnectToggle = autoToggle

	local intervalRow = Instance.new("Frame")
	intervalRow.BackgroundTransparency = 1
	intervalRow.BorderSizePixel = 0
	intervalRow.Size = UDim2.new(1, 0, 0, 36)
	intervalRow.LayoutOrder = 5
	intervalRow.Parent = netCard
	local intervalLabel = MkLabel("Participant list refresh", F_MED, 13, TEXT, intervalRow)
	intervalLabel.Size = UDim2.new(1, -184, 1, 0)
	intervalLabel.TextXAlignment = Enum.TextXAlignment.Left

	local intervalOptions = {}
	for _, choice in ipairs(REFRESH_CHOICES) do
		intervalOptions[#intervalOptions + 1] = tostring(choice) .. "s"
	end
	local intervalIndex = 1
	for index, choice in ipairs(REFRESH_CHOICES) do
		if choice == Settings.RefreshInterval then
			intervalIndex = index
		end
	end
	local intervalCycle = Gui.MakeCycle(intervalRow, intervalOptions, intervalIndex, 0, function(optionText)
		local seconds = tonumber((tostring(optionText):gsub("s", "")))
		if seconds then
			Settings.RefreshInterval = seconds
			Funcs.SaveSettings()
		end
	end)
	intervalCycle.button.AnchorPoint = Vector2.new(1, 0.5)
	intervalCycle.button.Position = UDim2.new(1, 0, 0.5, 0)
	UI.RefreshCycle = intervalCycle

	local reconnectBtn = MkBtn("Reconnect now", F_MED, 13, TEXT, BG3, netCard)
	reconnectBtn.Size = UDim2.new(1, 0, 0, 34)
	reconnectBtn.LayoutOrder = 6
	MkCorner(8, reconnectBtn)
	reconnectBtn.MouseButton1Click:Connect(function()
		Net.Kick("Manual reconnect requested.")
	end)
	UI.ReconnectBtn = reconnectBtn

	local resetBtn = MkBtn("Reset UI settings", F_MED, 13, WHITE, Color3.fromRGB(150, 70, 70), netCard)
	resetBtn.Size = UDim2.new(1, 0, 0, 34)
	resetBtn.LayoutOrder = 7
	MkCorner(8, resetBtn)
	resetBtn.MouseButton1Click:Connect(function()
		Funcs.ResetSettings()
		UI.ThemeCycle.Set(Settings.Theme)
		UI.TransparencySlider.Set(Settings.Transparency)
		UI.AnimationsToggle.Set(Settings.Animations)
		UI.SoundsToggle.Set(Settings.Sounds)
		UI.NotificationsToggle.Set(Settings.Notifications)
		UI.AutoReconnectToggle.Set(Settings.AutoReconnect)
		for index, choice in ipairs(REFRESH_CHOICES) do
			if choice == Settings.RefreshInterval then
				UI.RefreshCycle.SetIndex(index)
			end
		end
		Gui.ApplyTheme(Settings.Theme)
		Funcs.Notify("Settings reset", "UI settings restored to defaults.", "info")
	end)

	local aboutCard = MkCardAuto(scroll, 4)
	MkPadding(14, 14, 12, 12, aboutCard)
	local aboutLayout = MkList(Enum.FillDirection.Vertical, 8, aboutCard)
	aboutLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkHeading(aboutCard, "About CPanel", 1)

	local aboutText = Instance.new("TextLabel")
	aboutText.BackgroundTransparency = 1
	aboutText.BorderSizePixel = 0
	aboutText.FontFace = F_REG
	aboutText.TextSize = 12
	aboutText.TextColor3 = SUBTEXT
	aboutText.RichText = true
	aboutText.TextWrapped = true
	aboutText.TextXAlignment = Enum.TextXAlignment.Left
	aboutText.TextYAlignment = Enum.TextYAlignment.Top
	aboutText.Size = UDim2.new(1, 0, 0, 0)
	aboutText.AutomaticSize = Enum.AutomaticSize.Y
	aboutText.LayoutOrder = 2
	aboutText.Parent = aboutCard
	aboutText.Text = [[<b>CPanel</b> v]] .. VERSION .. [[ — executor-style control panel with a shared WebSocket backend.

<b>How access works:</b> developer ids live in access.json on the WebSocket server (never in client code). Clients ask the socket who has access, and only listed UserIds get this dashboard.

<b>Security note:</b> Roblox gives the server no way to verify who a client really is, so access checks are a soft gate — treat them as convenience, not as a security boundary.

All effects are local, temporary and reversible. Player Actions only run in experiences that explicitly authorize them.]]

	local aboutLogo = Instance.new("ImageLabel")
	aboutLogo.BackgroundTransparency = 1
	aboutLogo.BorderSizePixel = 0
	aboutLogo.Image = Funcs.GetAsset("CPanel/CPN_Logo.png") or Assets["CPanel/CPN_Logo.png"]
	aboutLogo.Size = UDim2.new(0, 44, 0, 44)
	aboutLogo.LayoutOrder = 3
	aboutLogo.Parent = aboutCard
	MkCorner(9, aboutLogo)
end

function Gui.BuildAllPages()
	Gui.BuildDashboardPage()
	Gui.BuildPlayerPage()
	Gui.BuildAudioPage()
	Gui.BuildVisualPage()
	Gui.BuildFunPage()
	Gui.BuildSettingsPage()
end

function Funcs.Shutdown()
	if State.Shutdown then
		return
	end
	State.Shutdown = true

	Net.SettlePending(false, "CPanel was shut down")
	Effects.StopAll("shutdown")

	local socket = Net.socket
	Net.socket = nil
	Net.open = false
	pcall(function()
		if socket then
			socket:Close()
		end
	end)

	for _, sound in pairs(SoundPool) do
		pcall(function()
			sound:Destroy()
		end)
	end
	SoundPool = {}

	local screen = UI.Screen
	UI = {}
	pcall(function()
		if screen then
			screen:Destroy()
		end
	end)

	if Env.__CPanel then
		Env.__CPanel.IsLoaded = false
	end
	warn("[CPanel] shut down")
end

Funcs.LoadSettings()
Gui.ApplyTheme(Settings.Theme)

task.spawn(function()
	Funcs.GetAsset("CPanel/CPN_Logo.png")
end)

task.spawn(function()
	while not State.Shutdown do
		task.wait(math.max(2, tonumber(Settings.RefreshInterval) or 5))
		if State.IsDeveloper and Net.open then
			Gui.RequestParticipants(true)
		end
	end
end)

Net.Start()
