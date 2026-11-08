if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Env = (type(getgenv) == "function" and getgenv()) or shared or _G

local VERSION = "1.0.0"

local WebsocketUrl = nil

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

local WS_PATH = "CPanel/.websocketUrl"
local LEGACY_WS_PATH = ".websocketUrl"

local function ValidWs(url)
	return type(url) == "string" and url:match("^wss?://") ~= nil
end

local function Trim(url)
	return tostring(url):match("^%s*(.-)%s*$")
end

local function ReadWs(path)
	if type(readfile) ~= "function" then
		return nil
	end
	local ok, stored = pcall(readfile, path)
	if not ok then
		return nil
	end
	stored = tostring(stored):match("^%s*(.-)%s*$")
	if ValidWs(stored) then
		return stored
	end
	return nil
end

WebsocketUrl = ReadWs(WS_PATH) or ReadWs(LEGACY_WS_PATH)

do
	local seeded = nil
	pcall(function()
		seeded = Env.CPanelWebsocket
	end)
	pcall(function()
		Env.CPanelWebsocket = nil
	end)
	if not ValidWs(WebsocketUrl) and ValidWs(seeded) then
		WebsocketUrl = Trim(seeded)
	end
end

if ValidWs(WebsocketUrl) and type(writefile) == "function" then
	pcall(writefile, WS_PATH, tostring(WebsocketUrl):match("^%s*(.-)%s*$"))
end

local function PersistWsFile()
	if not ValidWs(WebsocketUrl) or type(writefile) ~= "function" then
		return
	end
	local expected = tostring(WebsocketUrl):match("^%s*(.-)%s*$")

	local ok, current = pcall(readfile, WS_PATH)
	if ok and Trim(current) == expected then
		return
	end

	pcall(writefile, WS_PATH, expected)
end

if not ValidWs(WebsocketUrl) then
	FailBoot("Invalid configuration: no websocket url found in " .. WS_PATH .. ".")
	return
end

local DEV_TOKEN_PATH = "CPanel/.devToken"

local function ReadToken(path)
	if type(readfile) ~= "function" then
		return nil
	end
	local ok, stored = pcall(readfile, path)
	if not ok then
		return nil
	end
	stored = tostring(stored):match("^%s*(.-)%s*$")
	if stored == "" then
		return nil
	end
	return stored
end

local DevToken = ReadToken(DEV_TOKEN_PATH)

do
	local seeded = nil
	pcall(function()
		seeded = Env.CPanelDevToken
	end)
	pcall(function()
		Env.CPanelDevToken = nil
	end)
	if not DevToken and type(seeded) == "string" then
		seeded = seeded:match("^%s*(.-)%s*$")
		if seeded ~= "" then
			DevToken = seeded
			if type(writefile) == "function" then
				pcall(writefile, DEV_TOKEN_PATH, DevToken)
			end
		end
	end
end

if not DevToken then
	warn("[CPanel] no developer token configured — this session registers as a participant (set getgenv().CPanelDevToken before loading, or create " .. DEV_TOKEN_PATH .. ")")
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
local BORDER = Color3.fromRGB(34, 34, 42)
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
	ChatLogs = {},
	ChatScopeUserId = nil,
	ChatOnlyConnected = false,
}

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
	ping = "rbxassetid://113397864512278",
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
		Funcs.PlaySound("ping", 0.26)
	elseif kind == "error" then
		Funcs.PlaySound("ping", 0.4)
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
	local text = Funcs.SafeText(args.text, 48, "CPanel")
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

local function OwnRoot()
	local character = LocalPlayer.Character
	if not character then
		return nil, "your character has not loaded yet"
	end
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil, "your character has no root part"
	end
	return root, character:FindFirstChildOfClass("Humanoid")
end

local function TeleportTo(x, y, z)
	local root, humanoid = OwnRoot()
	if not root then
		return false, humanoid
	end
	if humanoid then
		humanoid.Sit = false
	end
	root.CFrame = CFrame.new(x, y + 3, z)
	return true
end

local PlayerActions = {}

function PlayerActions.freeze()
	local root, humanoid = OwnRoot()
	if not root then
		return false, humanoid
	end
	if humanoid then
		humanoid.WalkSpeed = 0
	end
	root.Anchored = true
	return true, "character frozen"
end

function PlayerActions.unfreeze()
	local root, humanoid = OwnRoot()
	if not root then
		return false, humanoid
	end
	if humanoid then
		humanoid.WalkSpeed = 16
	end
	root.Anchored = false
	return true, "character unfrozen"
end

function PlayerActions.kill()
	local root, humanoid = OwnRoot()
	if not root then
		return false, humanoid
	end
	if not humanoid then
		return false, "your character has no humanoid"
	end
	humanoid.Health = 0
	return true, "character reset"
end

function PlayerActions.bring(args)
	local x, y, z = tonumber(args and args.x), tonumber(args and args.y), tonumber(args and args.z)
	if not x or not y or not z then
		return false, "developer did not send a position"
	end
	local ok, err = TeleportTo(x, y, z)
	if not ok then
		return false, err
	end
	return true, "moved to the developer"
end

PlayerActions["goto"] = function()
	local root, err = OwnRoot()
	if not root then
		return false, err
	end
	local position = root.Position
	return true, string.format("at %.1f, %.1f, %.1f", position.X, position.Y, position.Z)
end

PlayerActions.fling = function(args)
	local root, humanoid = OwnRoot()
	if not root then
		return false, humanoid
	end
	local force = Funcs.ClampNumber(math.floor(tonumber(args and args.force) or 5), 1, 10)
	if humanoid then
		humanoid.Sit = true
		humanoid.PlatformStand = true
	end
	local vertical = math.max(50, 170 - force * 12)
	local speed = 70 + force * 45
	local horizontal = math.sqrt(math.max(0, speed * speed - vertical * vertical))
	local angle = math.random() * math.pi * 2
	root.AssemblyLinearVelocity = Vector3.new(math.cos(angle) * horizontal, vertical, math.sin(angle) * horizontal)
	root.AssemblyAngularVelocity = Vector3.new(math.random(-25, 25), math.random(-25, 25), math.random(-25, 25))
	return true, string.format("flung at force %d", force)
end

local function PlayerActionHandler(actionName)
	return function(args)
		local handler = PlayerActions[actionName]
		if type(handler) ~= "function" then
			return false, "unsupported player action"
		end
		return handler(args or {})
	end
end

Handlers.freeze = PlayerActionHandler("freeze")
Handlers.unfreeze = PlayerActionHandler("unfreeze")
Handlers.kill = PlayerActionHandler("kill")
Handlers.bring = PlayerActionHandler("bring")
Handlers.goto = PlayerActionHandler("goto")

Handlers.notify = function(args)
	local text = Funcs.SafeText(args and args.text, 140, "")
	if text == "" then
		return false, "notification text is empty"
	end
	Funcs.StandaloneToast(Funcs.SafeText(args and args.title, 40, "CPanel"), text, "info")
	return true, "notification shown"
end

Handlers.chat_send = function(args)
	local text = Funcs.SafeText(args and args.text, 200, "")
	if text == "" then
		return false, "message is empty"
	end
	local ok, err = pcall(function()
		local TextChatService = game:GetService("TextChatService")
		local channels = TextChatService:FindFirstChild("TextChannels")
		local general = channels and channels:FindFirstChild("RBXGeneral")
		if not general then
			error("RBXGeneral channel not found")
		end
		general:SendAsync(text)
	end)
	if not ok then
		return false, Funcs.Truncate(tostring(err), 120)
	end
	return true, "sent as " .. LocalPlayer.Name
end

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

function Funcs.ApplyRole()
	local dev = (Net.role == "developer")
	if dev and not State.IsDeveloper then
		State.IsDeveloper = true
		if not UI.Window then
			Gui.Build()
		end
		Funcs.Notify("Developer access", "Authenticated as a CPanel developer.", "success")
		Gui.RequestParticipants(true)
	elseif not dev and State.IsDeveloper then
		State.IsDeveloper = false
		Gui.CloseDashboard("Developer access was removed on the server.")
	elseif dev and State.IsDeveloper then
		Gui.RequestParticipants(true)
	end
end

function Net.OnWelcome(message)
	Net.sessionId = message.sessionId
	Net.role = message.role
	if message.role == "developer" and not DevToken then
		warn("[CPanel] server granted a developer role but no developer token is configured — refusing developer UI")
		Net.role = "participant"
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
		gameId = game.GameId,
		jobId = (type(game.JobId) == "string" and game.JobId ~= "") and game.JobId or "unknown",
		placeVersion = game.PlaceVersion,
		devToken = DevToken,
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
	local corner = parent:FindFirstChildOfClass("UICorner")
	if not corner then
		corner = Instance.new("UICorner")
		corner.Parent = parent
	end
	corner.CornerRadius = UDim.new(0, radius)
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
	scroll.ScrollBarThickness = 3
	scroll.ScrollBarImageColor3 = BG3:Lerp(WHITE, 0.35)
	scroll.ScrollBarImageTransparency = 0.45
	scroll.ScrollingDirection = direction or Enum.ScrollingDirection.Y
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ScrollingEnabled = true
	scroll:SetAttribute("CPN_ThemedBar", true)
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
	button:SetAttribute("CPN_BaseBg", background)
	MkCorner(8, button)

	local hovering = false
	local tweenInfo = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local function baseBg()
		local stored = button:GetAttribute("CPN_BaseBg")
		if typeof(stored) == "Color3" then
			return stored
		end
		return background
	end

	local function isSelected()
		return button:GetAttribute("CPN_Selected") == true
	end

	local function hoverOf()
		local bg = baseBg()
		if bg.R + bg.G + bg.B < 0.2 then
			return BG3
		end
		return bg:Lerp(WHITE, 0.1)
	end

	local function restOf()
		if isSelected() then
			return ACCENT
		end
		if hovering then
			return hoverOf()
		end
		return baseBg()
	end

	local function paint(target)
		TweenService:Create(button, tweenInfo, { BackgroundColor3 = target }):Play()
	end

	button.MouseEnter:Connect(function()
		hovering = true
		paint(isSelected() and ACCENT:Lerp(WHITE, 0.1) or hoverOf())
	end)
	button.MouseLeave:Connect(function()
		hovering = false
		paint(restOf())
	end)
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			paint(isSelected() and ACCENT:Lerp(OVERLAY_BG, 0.18) or baseBg():Lerp(OVERLAY_BG, 0.2))
		end
	end)
	button.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			paint(restOf())
		end
	end)

	return button
end

local function SetButtonSelected(button, selected)
	button:SetAttribute("CPN_Selected", selected == true)
end

local function MkCard(parent, order, height)
	local card = MkFrame(BG2, UDim2.new(1, 0, 0, height or 0), parent)
	card.LayoutOrder = order or 0
	card.BorderSizePixel = 0
	MkCorner(10, card)
	local stroke = MkStroke(BORDER, 1, card)
	stroke.Transparency = 0.4
	return card
end

local function MkCardAuto(parent, order)
	local card = MkFrame(BG2, UDim2.new(1, 0, 0, 0), parent)
	card.LayoutOrder = order or 0
	card.BorderSizePixel = 0
	card.AutomaticSize = Enum.AutomaticSize.Y
	MkCorner(10, card)
	local stroke = MkStroke(BORDER, 1, card)
	stroke.Transparency = 0.4
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
	MkCorner(8, holder)

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

function Funcs.StandaloneToast(title, text, kind)
	local host = MakeOverlayGui("CPN_Notice")
	local kindColors = { info = ACCENT, success = GREEN, error = RED, warn = YELLOW }
	local accent = kindColors[kind] or ACCENT

	local toast = MkFrame(BG2, UDim2.new(0, 320, 0, TOAST_HEIGHT), host)
	toast.BorderSizePixel = 0
	toast.AnchorPoint = Vector2.new(1, 0)
	toast.Position = UDim2.new(1, 60, 0, 16)
	MkCorner(10, toast)
	local toastStroke1 = MkStroke(BORDER, 1, toast)
	toastStroke1.Transparency = 0.4

	local bar = MkFrame(accent, UDim2.new(0, 3, 1, -16), toast)
	bar.BorderSizePixel = 0
	bar.Position = UDim2.new(0, 8, 0, 8)
	MkCorner(2, bar)

	local titleLabel = MkLabel(title, F_BOLD, 13, accent, toast)
	titleLabel.Size = UDim2.new(1, -32, 0, 18)
	titleLabel.Position = UDim2.new(0, 20, 0, 10)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local bodyLabel = MkLabel(text, F_REG, 12, SUBTEXT, toast)
	bodyLabel.Size = UDim2.new(1, -32, 0, 30)
	bodyLabel.Position = UDim2.new(0, 20, 0, 27)
	bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
	bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
	bodyLabel.TextTruncate = Enum.TextTruncate.AtEnd

	if Settings.Animations then
		TweenService:Create(toast, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -14, 0, 16),
		}):Play()
	else
		toast.Position = UDim2.new(1, -14, 0, 16)
	end

	task.delay(TOAST_LIFETIME, function()
		pcall(function()
			host:Destroy()
		end)
	end)
	return true
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
	local toastStroke2 = MkStroke(BORDER, 1, toast)
	toastStroke2.Transparency = 0.4

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
			if object:GetAttribute("CPN_Immutable") ~= true then
				if object:IsA("TextLabel") or object:IsA("TextButton") then
					if object.TextColor3 == oldAccent then
						object.TextColor3 = ACCENT
					elseif object.TextColor3 == oldBG3 then
						object.TextColor3 = BG3
					elseif object.TextColor3 == oldBG2 then
						object.TextColor3 = BG2
					end
				end

				if object:IsA("GuiObject") then
					if object:IsA("ScrollingFrame") and object:GetAttribute("CPN_ThemedBar") then
						object.ScrollBarImageColor3 = BG3:Lerp(WHITE, 0.35)
					end

					local stored = object:GetAttribute("CPN_BaseBg")
					if typeof(stored) == "Color3" then
						local mapped = stored
						if stored == oldAccent then
							mapped = ACCENT
						elseif stored == oldBG3 then
							mapped = BG3
						elseif stored == oldBG2 then
							mapped = BG2
						elseif stored == oldBG then
							mapped = BG
						end
						if mapped ~= stored then
							object:SetAttribute("CPN_BaseBg", mapped)
							if object:GetAttribute("CPN_Selected") ~= true then
								object.BackgroundColor3 = mapped
							end
						end
					elseif object.BackgroundColor3 == oldBG then
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
					elseif object.Color == oldBG3 then
						object.Color = BG3
					end
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

local function Dragify(handle, target)
	target = target or handle
	local paddingX = 16
	local paddingY = 12
	local dragging = false
	local dragInput = nil
	local dragStart = nil
	local startPosition = nil
	local moved = false
	local suppressClick = false

	handle.Active = true
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragInput = input
			dragStart = input.Position
			startPosition = target.AbsolutePosition
			moved = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or (dragInput and input == dragInput) then
			local delta = input.Position - dragStart
			if math.abs(delta.X) + math.abs(delta.Y) > 4 then
				moved = true
			end

			local camera = workspace.CurrentCamera
			if not camera then
				return
			end

			local viewport = camera.ViewportSize
			local size = target.AbsoluteSize
			local anchor = target.AnchorPoint
			local left = startPosition.X + delta.X
			local top = startPosition.Y + delta.Y

			left = math.clamp(left, paddingX, math.max(paddingX, viewport.X - size.X - paddingX))
			top = math.clamp(top, paddingY, math.max(paddingY, viewport.Y - size.Y - paddingY))

			target.Position = UDim2.fromOffset(
				left + size.X * anchor.X,
				top + size.Y * anchor.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		local isMouseRelease = input.UserInputType == Enum.UserInputType.MouseButton1
		local isTouchRelease = dragInput and input == dragInput
		if dragging and (isMouseRelease or isTouchRelease) then
			dragging = false
			dragInput = nil
			if moved then
				suppressClick = true
				task.delay(0.2, function()
					suppressClick = false
				end)
			end
		end
	end)

	return function()
		return suppressClick
	end
end

local NAV_PAGES = {
	{ key = "Dashboard", label = "Dashboard" },
	{ key = "General", label = "General" },
	{ key = "Spectate", label = "Spectate" },
	{ key = "Audio", label = "Audio" },
	{ key = "Visual", label = "Visual" },
	{ key = "Fun", label = "Fun" },
	{ key = "Chat", label = "Chat Logs" },
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

local ProductNameCache = {}

function Funcs.ProductName(id, infoType, callback)
	id = tonumber(id) or 0
	if id == 0 then
		callback(nil)
		return
	end
	local key = tostring(infoType) .. ":" .. id
	if ProductNameCache[key] then
		callback(ProductNameCache[key])
		return
	end
	task.spawn(function()
		local name = nil
		pcall(function()
			local info = game:GetService("MarketplaceService"):GetProductInfo(id, infoType)
			if type(info) == "table" and type(info.Name) == "string" and info.Name ~= "" then
				name = info.Name
			end
		end)
		ProductNameCache[key] = name
		callback(name)
	end)
end

function Funcs.PlaceName(placeId, callback)
	placeId = tonumber(placeId) or 0
	if placeId == 0 then
		callback("Unknown place")
		return
	end
	Funcs.ProductName(placeId, Enum.InfoType.Asset, function(name)
		callback(name or ("Place " .. tostring(placeId)))
	end)
end

function Gui.RefreshSessionInfo()
	if not UI.SessionGame then
		return
	end

	local okName, placeName = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name
	end)
	UI.SessionGame.Text = (okName and type(placeName) == "string" and placeName ~= "") and placeName
		or ("Place " .. tostring(game.PlaceId))

	if UI.SessionIds then
		UI.SessionIds.Text = "Place ID: " .. tostring(game.PlaceId) .. "   ·   Universe ID: " .. tostring(game.GameId)
	end
	if UI.SessionJob then
		UI.SessionJob.Text = "Job ID: " .. tostring(game.JobId or "unknown")
	end
end

function Gui.RevealPage(page)
	local fade = UI.PageFade
	if not fade or not page then
		return
	end
	if Settings.Animations == false then
		fade.BackgroundTransparency = 1
		return
	end
	fade.BackgroundColor3 = BG
	fade.BackgroundTransparency = 0.55
	fade.Visible = true
	TweenService:Create(
		fade,
		TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ BackgroundTransparency = 1 }
	):Play()
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

	local function paintNav(entry, active)
		if not entry then
			return
		end
		SetButtonSelected(entry.button, active)
		local target = active and ACCENT or BG3
		TweenService:Create(
			entry.button,
			TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundColor3 = target }
		):Play()
		entry.label.TextColor3 = active and WHITE or SUBTEXT
	end

	paintNav(oldNav, false)
	paintNav(newNav, true)

	if oldPage then
		oldPage.Visible = false
	end
	UI.ActivePage = pageKey
	newPage.Visible = true
	UI.ActiveNavName = pageKey
	if pageKey == "Dashboard" then
		Gui.RenderParticipants()
		Gui.RenderSelection()
	elseif pageKey == "Chat" then
		Gui.RenderChatLogs()
	end

	local scroll = UI.PageScrolls and UI.PageScrolls[pageKey]
	if scroll then
		scroll.CanvasPosition = Vector2.zero
	end
	Gui.RevealPage(newPage)

	Funcs.PlaySound("ping", 0.18)
end

function Gui.Minimize()
	if not UI.Window then
		return
	end
	UI.Window.Visible = false
	if UI.Shadow then
		UI.Shadow.Visible = false
	end
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
	if UI.Shadow then
		UI.Shadow.Visible = true
	end
	UI.Window.Visible = true
end

function Gui.Build()
	if UI.Window then
		return
	end

	for _, child in ipairs(Hui:GetChildren()) do
		if child:IsA("ScreenGui") and child:GetAttribute("CPN_Root") == true then
			pcall(function()
				child:Destroy()
			end)
		end
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
	screen:SetAttribute("CPN_Root", true)
	screen.DisplayOrder = 2147483646
	screen.IgnoreGuiInset = true
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screen.Parent = Hui
	UI.Screen = screen

	screen.AncestryChanged:Connect(function()
		if screen.Parent or State.Shutdown then
			return
		end
		local replaced = false
		for _, child in ipairs(Hui:GetChildren()) do
			if child ~= screen and child:IsA("ScreenGui") and child:GetAttribute("CPN_Root") == true then
				replaced = true
				break
			end
		end
		if replaced then
			Funcs.Shutdown()
		end
	end)

	local toastHost = Instance.new("Frame")
	toastHost.Name = "CPN_Toasts"
	toastHost.BackgroundTransparency = 1
	toastHost.BorderSizePixel = 0
	toastHost.AnchorPoint = Vector2.new(1, 0)
	toastHost.Position = UDim2.new(1, -14, 0, 16)
	toastHost.Size = UDim2.new(0, 300, 1, -32)
	toastHost.ZIndex = 50
	toastHost.Parent = screen
	UI.ToastHost = toastHost

	local shadow = Instance.new("Frame")
	shadow.Name = "CPN_Shadow"
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.new(0.5, 1, 0.5, 6)
	shadow.Size = UDim2.new(0.82, 2, 0.74, 12)
	shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 0.85
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 0
	shadow.Parent = screen
	MkCorner(16, shadow)
	UI.Shadow = shadow

	local window = MkFrame(BG, UDim2.new(0.82, 0, 0.74, 0), screen)
	window.Name = "CPN_Window"
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.Position = UDim2.new(0.5, 0, 0.5, 0)
	window.BorderSizePixel = 0
	window.ClipsDescendants = true
	MkCorner(16, window)
	MkStroke(BORDER, 1, window)
	local sizeConstraint = Instance.new("UISizeConstraint")
	sizeConstraint.MinSize = Vector2.new(620, 380)
	sizeConstraint.MaxSize = Vector2.new(900, 520)
	sizeConstraint.Parent = window
	UI.Window = window
	Gui.ApplyTransparency()

	local topbar = MkFrame(BG2, UDim2.new(1, 0, 0, 44), window)
	topbar.BorderSizePixel = 0
	topbar.LayoutOrder = 1
	UI.Topbar = topbar
	Dragify(topbar, window)
	local topCorner = MkCorner(16, topbar)
	topCorner.CornerRadius = UDim.new(0, 0)
	topCorner.TopLeftRadius = UDim.new(0, 16)
	topCorner.TopRightRadius = UDim.new(0, 16)
	topCorner.BottomLeftRadius = UDim.new(0, 0)
	topCorner.BottomRightRadius = UDim.new(0, 0)

	local logo = MkImg(Funcs.GetAsset("CPanel/CPN_Logo.png") or Assets["CPanel/CPN_Logo.png"], WHITE, topbar)
	logo.Size = UDim2.new(0, 28, 0, 28)
	logo.Position = UDim2.new(0, 12, 0.5, -14)
	logo.ScaleType = Enum.ScaleType.Fit
	MkCorner(7, logo)

	local title = MkLabel("CPanel", F_BOLD, 16, TEXT, topbar)
	title.Size = UDim2.new(0, 74, 0, 22)
	title.Position = UDim2.new(0, 48, 0.5, -11)
	title.TextXAlignment = Enum.TextXAlignment.Left

	local statusArea = MkFrame(BG2, UDim2.new(0, 0, 0, 20), topbar)
	statusArea.BackgroundTransparency = 1
	statusArea.AutomaticSize = Enum.AutomaticSize.X
	statusArea.AnchorPoint = Vector2.new(1, 0.5)
	statusArea.Position = UDim2.new(1, -62, 0.5, 0)
	statusArea.BorderSizePixel = 0
	local statusLayout = MkList(Enum.FillDirection.Horizontal, 7, statusArea)
	statusLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UI.StatusPill = statusArea

	local statusDot = MkFrame(RED, UDim2.new(0, 8, 0, 8), statusArea)
	statusDot.BorderSizePixel = 0
	statusDot.LayoutOrder = 1
	MkCorner(4, statusDot)
	UI.StatusDot = statusDot

	local statusText = MkLabel("Connecting", F_MED, 12, RED, statusArea)
	statusText.Size = UDim2.new(0, 0, 0, 20)
	statusText.AutomaticSize = Enum.AutomaticSize.X
	statusText.LayoutOrder = 2
	statusText.TextXAlignment = Enum.TextXAlignment.Left
	UI.StatusText = statusText

	local traffic = Instance.new("Frame")
	traffic.Name = "Traffic"
	traffic.BackgroundTransparency = 1
	traffic.BorderSizePixel = 0
	traffic.Size = UDim2.new(0, 32, 0, 12)
	traffic.AnchorPoint = Vector2.new(1, 0.5)
	traffic.Position = UDim2.new(1, -16, 0.5, 0)
	traffic.Parent = topbar
	MkList(Enum.FillDirection.Horizontal, 8, traffic)

	local function TrafficDot(name, color, glyph, onClick)
		local dot = Instance.new("TextButton")
		dot.Name = name
		dot.BackgroundColor3 = color
		dot.BorderSizePixel = 0
		dot.AutoButtonColor = false
		dot.Text = ""
		dot.FontFace = F_BOLD
		dot.TextSize = 9
		dot.TextColor3 = Color3.fromRGB(40, 40, 44)
		dot.Size = UDim2.new(0, 12, 0, 12)
		dot.LayoutOrder = name == "Close" and 2 or 1
		dot.Parent = traffic
		dot:SetAttribute("CPN_Immutable", true)
		MkCorner(6, dot)

		local dim = color:Lerp(Color3.fromRGB(20, 20, 24), 0.18)
		dot.MouseEnter:Connect(function()
			dot.Text = glyph
			TweenService:Create(dot, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = dim }):Play()
		end)
		dot.MouseLeave:Connect(function()
			dot.Text = ""
			TweenService:Create(dot, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = color }):Play()
		end)
		dot.MouseButton1Click:Connect(onClick)
		return dot
	end

	TrafficDot("Minimize", Color3.fromRGB(255, 189, 46), "–", Gui.Minimize)
	TrafficDot("Close", Color3.fromRGB(255, 95, 86), "×", Funcs.Shutdown)


	local sidebar = MkScroll(window, Enum.ScrollingDirection.Y)
	sidebar.Name = "CPN_Sidebar"
	sidebar.BackgroundColor3 = BG2
	sidebar.BackgroundTransparency = 0
	sidebar.Size = UDim2.new(0, 176, 1, -44)
	sidebar.Position = UDim2.new(0, 0, 0, 44)
	sidebar.BorderSizePixel = 0
	sidebar.LayoutOrder = 2
	local sideCorner = MkCorner(0, sidebar)
	sideCorner.BottomLeftRadius = UDim.new(0, 16)
	UI.Sidebar = sidebar
	MkList(Enum.FillDirection.Vertical, 6, sidebar)
	MkPadding(10, 10, 12, 12, sidebar)

	for order, page in ipairs(NAV_PAGES) do
		local button = MkBtn(page.label, F_MED, 13, SUBTEXT, BG3, sidebar)
		button.Size = UDim2.new(1, 0, 0, 34)
		button.LayoutOrder = order
		button.TextXAlignment = Enum.TextXAlignment.Left
		MkCorner(9, button)
		MkPadding(14, 8, 0, 0, button)
		UI.NavButtons[page.key] = { button = button, label = button }
		button.MouseButton1Click:Connect(function()
			Gui.SwitchPage(page.key)
		end)
		button.MouseEnter:Connect(function()
			if button:GetAttribute("CPN_Selected") ~= true then
				button.TextColor3 = TEXT
			end
		end)
		button.MouseLeave:Connect(function()
			if button:GetAttribute("CPN_Selected") ~= true then
				button.TextColor3 = SUBTEXT
			end
		end)
	end

	local content = MkFrame(BG, UDim2.new(1, -176, 1, -44), window)
	content.Position = UDim2.new(0, 176, 0, 44)
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

	local pageFade = Instance.new("Frame")
	pageFade.Name = "CPN_PageFade"
	pageFade.BackgroundColor3 = BG
	pageFade.BackgroundTransparency = 1
	pageFade.BorderSizePixel = 0
	pageFade.Size = UDim2.new(1, 0, 1, 0)
	pageFade.ZIndex = 40
	pageFade.Active = false
	pageFade.Parent = content
	UI.PageFade = pageFade

	local showBtn = Instance.new("ImageButton")
	showBtn.Name = "CPN_ShowBtn"
	showBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
	showBtn.BackgroundTransparency = 0.08
	showBtn.BorderSizePixel = 0
	showBtn.Size = UDim2.new(0, 44, 0, 44)
	showBtn.Position = UDim2.new(0, 16, 0, 0)
	showBtn.Visible = false
	showBtn.Image = ""
	showBtn.AutoButtonColor = false
	showBtn.Parent = screen
	showBtn:SetAttribute("CPN_Immutable", true)
	MkCorner(22, showBtn)
	UI.ShowBtn = showBtn

	local showIcon = MkImg(Funcs.GetAsset("CPanel/CPN_Logo.png") or Assets["CPanel/CPN_Logo.png"], WHITE, showBtn)
	showIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	showIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	showIcon.Size = UDim2.new(0, 36, 0, 36)
	showIcon:SetAttribute("CPN_Immutable", true)
	local showBtnDragged = Dragify(showBtn)
	showBtn.MouseButton1Click:Connect(function()
		if showBtnDragged() then
			return
		end
		Gui.Restore()
	end)

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
		Gui.SetStatus(pageKey, actionKey .. (ok and " [ok] " or " [failed] ") .. message, ok)
		State.LastActionStatus = string.format("%s -> %s: %s", targetName, actionKey, message)
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
		gameId = tonumber(item.gameId) or 0,
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
		Funcs.PlaySound("ping", 0.22)
	end
end

function Gui.ViewParticipant(enabled)
	local camera = GetCamera()
	if not enabled then
		local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			Funcs.Notify("Unspectate", "Your character is not loaded.", "error")
			return
		end
		camera.CameraSubject = humanoid
		Gui.SetStatus("Spectate", "view — camera back on your character", true)
		Funcs.Notify("Spectate off", "Camera is back on your character.", "success")
		return
	end

	local selected = State.Selected
	if not selected then
		Gui.SetStatus("Spectate", "view — select a participant first", false)
		Funcs.Notify("No participant", "Select a participant in the Dashboard first.", "warn")
		return
	end

	local player = nil
	for _, candidate in ipairs(GetService("Players"):GetChildren()) do
		if candidate.UserId == selected.userId then
			player = candidate
			break
		end
	end
	local humanoid = player and player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		Gui.SetStatus("Spectate", "view — " .. selected.username .. " is in another server", false)
		Funcs.Notify("Cannot spectate", Funcs.Truncate(selected.username, 24) .. " is not in this server — use Join on them first.", "error")
		return
	end

	camera.CameraSubject = humanoid
	Gui.SetStatus("Spectate", "view — spectating " .. selected.username, true)
	Funcs.Notify("Spectating", "Now watching " .. Funcs.Truncate(selected.username, 24) .. ".", "success")
end

function Gui.JoinParticipant(entry)
	if type(entry) ~= "table" then
		return
	end
	local placeId = tonumber(entry.placeId) or 0
	if placeId == 0 then
		Funcs.Notify("Join failed", "That session did not report a place id.", "error")
		return
	end
	if placeId == game.PlaceId and entry.jobId == game.JobId then
		Funcs.Notify("Already there", "You are already in that server.", "info")
		return
	end
	local ok, err = pcall(function()
		GetService("TeleportService"):Teleport(placeId, LocalPlayer)
	end)
	if ok then
		Funcs.PlaceName(placeId, function(name)
			Funcs.Notify(
				"Joining game",
				"Teleporting to " .. Funcs.Truncate(entry.username, 24) .. "'s game — "
					.. Funcs.Truncate(name or ("place " .. tostring(placeId)), 34) .. ".",
				"success"
			)
		end)
	else
		Funcs.Notify("Join failed", Funcs.Truncate(tostring(err), 120), "error")
	end
end

function Gui.HopToParticipant(entry)
	if type(entry) ~= "table" then
		return
	end
	if type(entry.jobId) ~= "string" or entry.jobId == "" or entry.jobId == "unknown" then
		Funcs.Notify("Server hop failed", "That session did not report a job id.", "error")
		return
	end
	if tonumber(entry.placeId) ~= game.PlaceId then
		Funcs.PlaceName(entry.placeId, function(name)
			Funcs.Notify(
				"Join that game first",
				Funcs.Truncate(entry.username, 20) .. " is in " .. Funcs.Truncate(name or ("place " .. tostring(entry.placeId)), 34)
					.. " (Place ID " .. tostring(entry.placeId) .. ") — server hop only works from inside that game. Use Join first.",
				"warn"
			)
		end)
		return
	end
	if entry.jobId == game.JobId then
		Funcs.Notify("Already there", "You are already in that server.", "info")
		return
	end
	local ok, err = pcall(function()
		GetService("TeleportService"):TeleportToPlaceInstance(entry.placeId, entry.jobId, LocalPlayer)
	end)
	if ok then
		Funcs.PlaceName(entry.placeId, function(name)
			Funcs.Notify(
				"Server hopping",
				"Joining " .. Funcs.Truncate(entry.username, 24) .. "'s server in "
					.. Funcs.Truncate(name or ("place " .. tostring(entry.placeId)), 34) .. ".",
				"success"
			)
		end)
	else
		Funcs.Notify("Server hop failed", Funcs.Truncate(tostring(err), 120), "error")
	end
end

local function ParticipantRow(parent, entry, order)
	local isSelf = (entry.sessionId == Net.sessionId)
	local isSelected = (State.Selected and State.Selected.sessionId == entry.sessionId)
	local joinable = (entry.role ~= "developer") and not isSelf

	local chipWidth = (entry.role == "developer") and 96 or 70
	local chipRight = joinable and 158 or 30
	local labelGutter = 55 + chipRight + chipWidth + 10

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
	nameLabel.Size = UDim2.new(1, -labelGutter, 0, 17)
	nameLabel.Position = UDim2.new(0, 55, 0, 9)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local detailLabel = MkLabel(entry.displayName .. "  ·  " .. tostring(entry.userId) .. "  ·  " .. entry.jobId:sub(1, 8), F_REG, 11, SUBTEXT, row)
	detailLabel.Size = UDim2.new(1, -labelGutter, 0, 15)
	detailLabel.Position = UDim2.new(0, 55, 0, 30)
	detailLabel.TextXAlignment = Enum.TextXAlignment.Left
	detailLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local chip = Instance.new("Frame")
	chip.BackgroundColor3 = (entry.role == "developer") and ACCENT or Color3.fromRGB(38, 64, 50)
	chip.BorderSizePixel = 0
	chip.AnchorPoint = Vector2.new(1, 0.5)
	chip.Position = UDim2.new(1, -chipRight, 0.5, 0)
	chip.Size = UDim2.new(0, chipWidth, 0, 20)
	chip.Parent = row
	MkCorner(10, chip)
	MkPadding(8, 8, 0, 0, chip)
	local chipText = (entry.role == "developer") and "DEVELOPER" or "ONLINE"
	local chipLabel = MkLabel(chipText, F_BOLD, 9, WHITE, chip)
	chipLabel.Size = UDim2.new(1, 0, 1, 0)
	chipLabel.TextWrapped = false
	chipLabel.TextTruncate = Enum.TextTruncate.AtEnd

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

	if joinable then
		local joinBtn = MkBtn("Join", F_BOLD, 11, WHITE, ACCENT, row)
		joinBtn.Name = "Join"
		joinBtn.Size = UDim2.new(0, 56, 0, 26)
		joinBtn.AnchorPoint = Vector2.new(1, 0.5)
		joinBtn.Position = UDim2.new(1, -28, 0.5, 0)
		MkCorner(8, joinBtn)
		joinBtn.MouseButton1Click:Connect(function()
			Gui.JoinParticipant(entry)
		end)

		local hopBtn = MkBtn("Hop", F_BOLD, 11, TEXT, BG2, row)
		hopBtn.Name = "Hop"
		hopBtn.Size = UDim2.new(0, 46, 0, 26)
		hopBtn.AnchorPoint = Vector2.new(1, 0.5)
		hopBtn.Position = UDim2.new(1, -90, 0.5, 0)
		MkCorner(8, hopBtn)
		MkStroke(BORDER, 1, hopBtn)
		hopBtn.MouseButton1Click:Connect(function()
			Gui.HopToParticipant(entry)
		end)
	end

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

	Gui.RefreshChatScopeOptions()
end

local selectionToken = 0

function Gui.RenderSelection()
	local selected = State.Selected
	selectionToken = selectionToken + 1
	local token = selectionToken

	for _, label in pairs(UI.BannerLabels or {}) do
		if selected then
			label.Text = "Selected: " .. Funcs.Truncate(selected.username, 26)
			label.TextColor3 = TEXT
		else
			label.Text = "No participant selected — open the Dashboard"
			label.TextColor3 = SUBTEXT
		end
	end

	if not UI.SelectionName then
		return
	end

	if not selected then
		UI.SelectionName.Text = "No participant selected"
		UI.SelectionDetails.Text = "Pick a participant from the list above to enable the action tabs."
		if UI.SelectionGame then
			UI.SelectionGame.Text = ""
		end
		if UI.SelectionPlace then
			UI.SelectionPlace.Text = ""
		end
		UI.SelectionMeta.Text = ""
		UI.SelectionStatus.Text = ""
		if UI.DeselectBtn then
			UI.DeselectBtn.Visible = false
		end
		return
	end

	UI.SelectionName.Text = Funcs.Truncate(selected.username, 44)
	UI.SelectionDetails.Text = Funcs.Truncate(selected.displayName, 50) .. "  ·  UserId " .. tostring(selected.userId)

	UI.SelectionMeta.Text = "Place ID " .. tostring(selected.placeId)
		.. "  ·  Universe ID " .. tostring(selected.gameId ~= 0 and selected.gameId or game.GameId)
		.. "  ·  Job " .. Funcs.Truncate(selected.jobId, 14)
		.. "  ·  Session " .. Funcs.Truncate(selected.sessionId, 10)

	UI.SelectionStatus.Text = (selected.role == "developer")
		and "Connected · DEVELOPER session (cannot be targeted)"
		or "Connected · ready for interactions"
	UI.SelectionStatus.TextColor3 = (selected.role == "developer") and YELLOW or GREEN

	if UI.DeselectBtn then
		UI.DeselectBtn.Visible = true
	end

	if not UI.SelectionGame or not UI.SelectionPlace then
		return
	end

	local here = (selected.placeId == game.PlaceId)
	local gameId = here and game.GameId or selected.gameId
	UI.SelectionGame.Text = "Game: resolving…"
	UI.SelectionPlace.Text = "Place: resolving…"

	if gameId ~= 0 then
		Funcs.ProductName(gameId, Enum.InfoType.Game, function(name)
			if token ~= selectionToken or not UI.SelectionGame then
				return
			end
			UI.SelectionGame.Text = "Game: " .. Funcs.Truncate(name or ("Universe " .. tostring(gameId)), 56)
		end)
	else
		UI.SelectionGame.Text = "Game: —"
	end

	Funcs.ProductName(selected.placeId, Enum.InfoType.Asset, function(name)
		if token ~= selectionToken or not UI.SelectionPlace then
			return
		end
		UI.SelectionPlace.Text = "Place: " .. Funcs.Truncate(name or ("Place " .. tostring(selected.placeId)), 56)
	end)
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

	local chevron = MkLabel(">", F_BOLD, 20, SUBTEXT, card)
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
	local profileCardStroke = MkStroke(BORDER, 1, profileCard)
	profileCardStroke.Transparency = 0.4

	local avatar = Instance.new("ImageLabel")
	avatar.BackgroundTransparency = 1
	avatar.BorderSizePixel = 0
	avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(LocalPlayer.UserId) .. "&width=420&height=420&format=png"
	avatar.Size = UDim2.new(0, 62, 0, 62)
	avatar.Position = UDim2.new(0, 14, 0, 31)
	avatar.Parent = profileCard
	MkCorner(10, avatar)
	MkStroke(ACCENT, 1.5, avatar)

	local devLabel = MkLabel(Funcs.Truncate(LocalPlayer.DisplayName, 20), F_BOLD, 15, TEXT, profileCard)
	devLabel.Size = UDim2.new(1, -100, 0, 20)
	devLabel.Position = UDim2.new(0, 90, 0, 24)
	devLabel.TextXAlignment = Enum.TextXAlignment.Left
	devLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local handleLabel = MkLabel("@" .. LocalPlayer.Name, F_MED, 12, ACCENT, profileCard)
	handleLabel.Size = UDim2.new(1, -100, 0, 16)
	handleLabel.Position = UDim2.new(0, 90, 0, 48)
	handleLabel.TextXAlignment = Enum.TextXAlignment.Left
	handleLabel.TextTruncate = Enum.TextTruncate.AtEnd

	local idLabel = MkLabel("UserId: " .. tostring(LocalPlayer.UserId), F_REG, 11, SUBTEXT, profileCard)
	idLabel.Size = UDim2.new(1, -100, 0, 14)
	idLabel.Position = UDim2.new(0, 90, 0, 68)
	idLabel.TextXAlignment = Enum.TextXAlignment.Left

	local roleBadge = MkLabel("Developer · authenticated via access.json", F_REG, 10, SUBTEXT, profileCard)
	roleBadge.Size = UDim2.new(1, -100, 0, 12)
	roleBadge.Position = UDim2.new(0, 90, 0, 86)
	roleBadge.TextXAlignment = Enum.TextXAlignment.Left
	roleBadge.TextTruncate = Enum.TextTruncate.AtEnd

	local connCard = MkFrame(BG2, UDim2.new(0.44, -6, 1, 0), row)
	connCard.BorderSizePixel = 0
	MkCorner(10, connCard)
	local connCardStroke = MkStroke(BORDER, 1, connCard)
	connCardStroke.Transparency = 0.4

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

	local sessionCard = MkFrame(BG2, UDim2.new(1, 0, 0, 0), scroll)
	sessionCard.BorderSizePixel = 0
	sessionCard.LayoutOrder = 2
	sessionCard.AutomaticSize = Enum.AutomaticSize.Y
	MkCorner(10, sessionCard)
	local sessionCardStroke = MkStroke(BORDER, 1, sessionCard)
	sessionCardStroke.Transparency = 0.4
	MkPadding(14, 14, 12, 12, sessionCard)
	local sessionLayout = MkList(Enum.FillDirection.Vertical, 5, sessionCard)
	sessionLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill

	MkHeading(sessionCard, "Session", 1)

	local gameLine = MkLabel("—", F_BOLD, 13, TEXT, sessionCard)
	gameLine.LayoutOrder = 2
	gameLine.Size = UDim2.new(1, 0, 0, 0)
	gameLine.AutomaticSize = Enum.AutomaticSize.Y
	gameLine.TextXAlignment = Enum.TextXAlignment.Left
	gameLine.TextWrapped = true
	UI.SessionGame = gameLine

	local idLine = MkLabel("—", F_REG, 11, SUBTEXT, sessionCard)
	idLine.LayoutOrder = 3
	idLine.Size = UDim2.new(1, 0, 0, 0)
	idLine.AutomaticSize = Enum.AutomaticSize.Y
	idLine.TextXAlignment = Enum.TextXAlignment.Left
	idLine.TextWrapped = true
	UI.SessionIds = idLine

	local jobLine = MkLabel("—", F_REG, 11, SUBTEXT, sessionCard)
	jobLine.LayoutOrder = 4
	jobLine.Size = UDim2.new(1, 0, 0, 0)
	jobLine.AutomaticSize = Enum.AutomaticSize.Y
	jobLine.TextXAlignment = Enum.TextXAlignment.Left
	jobLine.TextWrapped = true
	UI.SessionJob = jobLine

	local partCard = MkFrame(BG2, UDim2.new(1, 0, 0, 288), scroll)
	partCard.BorderSizePixel = 0
	partCard.LayoutOrder = 3
	MkCorner(10, partCard)
	local partCardStroke = MkStroke(BORDER, 1, partCard)
	partCardStroke.Transparency = 0.4

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

	local selCard = MkFrame(BG2, UDim2.new(1, 0, 0, 146), scroll)
	selCard.BorderSizePixel = 0
	selCard.LayoutOrder = 4
	MkCorner(10, selCard)
	local selCardStroke = MkStroke(BORDER, 1, selCard)
	selCardStroke.Transparency = 0.4

	local selName = MkLabel("No participant selected", F_BOLD, 14, TEXT, selCard)
	selName.Size = UDim2.new(1, -130, 0, 20)
	selName.Position = UDim2.new(0, 14, 0, 12)
	selName.TextXAlignment = Enum.TextXAlignment.Left
	selName.TextTruncate = Enum.TextTruncate.AtEnd
	UI.SelectionName = selName

	local selDetails = MkLabel("Pick a participant from the list above to enable the action tabs.", F_MED, 12, SUBTEXT, selCard)
	selDetails.Size = UDim2.new(1, -130, 0, 16)
	selDetails.Position = UDim2.new(0, 14, 0, 34)
	selDetails.TextXAlignment = Enum.TextXAlignment.Left
	selDetails.TextTruncate = Enum.TextTruncate.AtEnd
	UI.SelectionDetails = selDetails

	local selGame = MkLabel("", F_MED, 12, TEXT, selCard)
	selGame.Size = UDim2.new(1, -130, 0, 15)
	selGame.Position = UDim2.new(0, 14, 0, 56)
	selGame.TextXAlignment = Enum.TextXAlignment.Left
	selGame.TextTruncate = Enum.TextTruncate.AtEnd
	UI.SelectionGame = selGame

	local selPlace = MkLabel("", F_MED, 12, TEXT, selCard)
	selPlace.Size = UDim2.new(1, -130, 0, 15)
	selPlace.Position = UDim2.new(0, 14, 0, 74)
	selPlace.TextXAlignment = Enum.TextXAlignment.Left
	selPlace.TextTruncate = Enum.TextTruncate.AtEnd
	UI.SelectionPlace = selPlace

	local selMeta = MkLabel("", F_REG, 11, SUBTEXT, selCard)
	selMeta.Size = UDim2.new(1, -130, 0, 14)
	selMeta.Position = UDim2.new(0, 14, 0, 94)
	selMeta.TextXAlignment = Enum.TextXAlignment.Left
	selMeta.TextTruncate = Enum.TextTruncate.AtEnd
	UI.SelectionMeta = selMeta

	local selStatus = MkLabel("", F_REG, 11, SUBTEXT, selCard)
	selStatus.Size = UDim2.new(1, -130, 0, 14)
	selStatus.Position = UDim2.new(0, 14, 0, 114)
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

	local mgmtCard = MkCardAuto(scroll, 5)
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

	Gui.RefreshSessionInfo()
	Players.PlayerAdded:Connect(Gui.RefreshSessionInfo)
	Players.PlayerRemoving:Connect(Gui.RefreshSessionInfo)
end

function Gui.BuildGeneralPage()
	local scroll = PageScroll("General")
	AddSelectionBanner("General", 1)
	AddInfoCard("General", 2, "How General actions work",
		"Pick a participant in the Dashboard, then fire an action. These are commands the receiving client applies to its own character. Camera moves live on the Spectate tab, launch power on the Fun tab.")

	local order = 3

	local function SendAction(definition)
		AddActionCard(scroll, order, definition.title, definition.hint, function()
			Gui.RunAction(definition.action, "General", definition.args, definition.title, definition.onResult)
		end)
		order = order + 1
	end

	local function NoArgs()
		return {}
	end

	local function BringArgs()
		local root, err = OwnRoot()
		if not root then
			return false, err
		end
		local position = root.Position
		return { x = position.X, y = position.Y, z = position.Z }
	end

	local function GotoResult(ok, message)
		if not ok then
			return
		end
		local x, y, z = tostring(message):match("(-?%d+%.?%d+)%s*,%s*(-?%d+%.?%d+)%s*,%s*(-?%d+%.?%d+)")
		x, y, z = tonumber(x), tonumber(y), tonumber(z)
		if not x then
			return
		end
		local moved, err = TeleportTo(x, y, z)
		local who = State.Selected and State.Selected.username or "participant"
		Gui.SetStatus("General", moved and ("goto — moved to " .. who) or ("goto — " .. tostring(err)), moved)
	end

	SendAction({ action = "freeze", title = "Freeze", hint = "Immobilize the participant", args = NoArgs })
	SendAction({ action = "unfreeze", title = "Unfreeze", hint = "Restore normal movement", args = NoArgs })
	SendAction({ action = "kill", title = "Kill / Reset", hint = "Set their hp to 0 instantly", args = NoArgs })
	SendAction({ action = "bring", title = "Bring", hint = "Move the participant to you", args = BringArgs })
	SendAction({ action = "goto", title = "Goto", hint = "Move yourself to the participant", args = NoArgs, onResult = GotoResult })

	local notifyCard = MkCardAuto(scroll, order)
	order = order + 1
	MkPadding(14, 14, 12, 12, notifyCard)
	local notifyLayout = MkList(Enum.FillDirection.Vertical, 8, notifyCard)
	notifyLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkHeading(notifyCard, "Notify", 1)
	MkHint(notifyCard, "A panel-style toast on their screen — same look as this dashboard's notifications, nothing over their head.", 2)
	UI.NotifyBox = MkInput(notifyCard, "Message to show…", 3)

	SendAction({
		action = "notify",
		title = "Send notification",
		hint = "Deliver the message typed above",
		args = function()
			return { text = UI.NotifyBox and UI.NotifyBox.Text or "" }
		end,
	})
	Gui.SetStatus("General", "", nil)
end

function Gui.BuildSpectatePage()
	local scroll = PageScroll("Spectate")
	AddSelectionBanner("Spectate", 1)
	AddInfoCard("Spectate", 2, "How Spectate works",
		"Pick a participant in the Dashboard, then View to point your camera at their character. Unview puts it back on yours. They need to be in this server — use Join on the Dashboard first if they are not.")

	AddActionCard(scroll, 3, "View", "Spectate the selected participant", function()
		Gui.ViewParticipant(true)
	end)
	AddActionCard(scroll, 4, "Unview", "Put the camera back on your character", function()
		Gui.ViewParticipant(false)
	end)
	Gui.SetStatus("Spectate", "", nil)
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

	local flingCard = MkCardAuto(scroll, 2)
	MkPadding(14, 14, 12, 12, flingCard)
	local flingLayout = MkList(Enum.FillDirection.Vertical, 8, flingCard)
	flingLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkHeading(flingCard, "Fling force", 1)
	MkHint(flingCard, "1 pops them straight up and ragdolls them, 10 throws them across the map.", 2)
	UI.FlingValue = MkLabel("Force " .. tostring(State.FlingForce or 5) .. " / 10", F_MED, 12, ACCENT, flingCard)
	UI.FlingValue.LayoutOrder = 3
	local flingSlider = Gui.MakeSlider(flingCard, 1, 10, State.FlingForce or 5, 4, function(value)
		State.FlingForce = math.floor(value + 0.5)
		if UI.FlingValue then
			UI.FlingValue.Text = "Force " .. tostring(State.FlingForce) .. " / 10"
		end
	end)
	UI.Sliders["flingForce"] = { fill = flingSlider.fill }

	local flingAction
	flingAction = AddActionCard(scroll, 3, "Fling", "Launch them — power comes from the slider above", function()
		Gui.RunAction("fling", "Fun", function()
			return { force = State.FlingForce or 5 }
		end, flingAction.title)
	end)

	local paramCard = MkCardAuto(scroll, 4)
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

	local nameplateBox = MkInput(paramCard, "Nameplate text (default: CPanel)", 4)
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
		local card = AddActionCard(scroll, 5 + index, definition.title, definition.hint, nil)
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


local CHAT_KEEP_MAX = 200
local CHAT_RENDER_MAX = 40
local CHAT_SEEN = {}
local CHAT_SEEN_COUNT = 0
local ChatScopeOptions = {}
local ChatScopeUserIds = {}
local chatHooked = false

local function ChatStamp()
	local ok, stamp = pcall(function()
		return os.date("%H:%M:%S")
	end)
	return (ok and stamp) or ""
end

function Gui.ChatTargetJobId()
	if State.ChatScopeUserId then
		for _, entry in ipairs(State.Participants) do
			if entry.userId == State.ChatScopeUserId then
				return tostring(entry.jobId or ""), entry
			end
		end
	end
	return tostring(game.JobId or ""), nil
end

local function ConnectedUserIds()
	local set = {}
	for _, entry in ipairs(State.Participants) do
		set[entry.userId] = true
	end
	return set
end

function Gui.FilteredChatLogs()
	local jobId = Gui.ChatTargetJobId()
	local connected = State.ChatOnlyConnected and ConnectedUserIds() or nil
	local out = {}
	for _, entry in ipairs(State.ChatLogs) do
		if entry.jobId == jobId then
			if not connected or connected[entry.userId] or entry.userId == LocalPlayer.UserId then
				out[#out + 1] = entry
			end
		end
	end
	return out
end

function Gui.RecordChat(message)
	if type(message) ~= "table" then
		return
	end
	local textSource = message.TextSource
	local userId = tonumber(textSource and textSource.UserId) or 0
	local text = tostring(message.Text or "")
	if text == "" or userId == 0 then
		return
	end

	local messageId = tostring(message.MessageId or "")
	if messageId ~= "" then
		local key = messageId .. "|" .. userId
		if CHAT_SEEN[key] then
			return
		end
		CHAT_SEEN[key] = true
		CHAT_SEEN_COUNT = CHAT_SEEN_COUNT + 1
		if CHAT_SEEN_COUNT > 2000 then
			table.clear(CHAT_SEEN)
			CHAT_SEEN_COUNT = 0
		end
	end

	local username = nil
	if textSource then
		local ok, name = pcall(function()
			return textSource.Name
		end)
		if ok and type(name) == "string" and name ~= "" then
			username = name
		end
	end
	if not username then
		local player = Players:GetPlayerByUserId(userId)
		username = player and player.Name or ("user" .. tostring(userId))
	end

	local logs = State.ChatLogs
	logs[#logs + 1] = {
		userId = userId,
		username = username,
		text = text,
		jobId = tostring(game.JobId or ""),
		stamp = ChatStamp(),
	}
	while #logs > CHAT_KEEP_MAX do
		table.remove(logs, 1)
	end

	if UI.ActivePage == "Chat" then
		Gui.RenderChatLogs()
	end
end

function Gui.StartChatCapture()
	if chatHooked then
		return
	end
	chatHooked = true
	pcall(function()
		game:GetService("TextChatService").MessageReceived:Connect(function(message)
			pcall(function()
				Gui.RecordChat(message)
			end)
		end)
	end)
end

function Gui.RefreshChatScopeOptions()
	local previous = State.ChatScopeUserId
	table.clear(ChatScopeOptions)
	table.clear(ChatScopeUserIds)
	ChatScopeOptions[1] = "This server"
	ChatScopeUserIds[1] = false

	local index = 1
	for _, entry in ipairs(State.Participants) do
		if entry.role ~= "developer" then
			ChatScopeOptions[#ChatScopeOptions + 1] = entry.username
			ChatScopeUserIds[#ChatScopeUserIds + 1] = entry.userId
			if previous and entry.userId == previous then
				index = #ChatScopeOptions
			end
		end
	end

	if previous and index == 1 then
		State.ChatScopeUserId = nil
	end

	if UI.ChatScopeCycle then
		UI.ChatScopeCycle.SetIndex(index)
	end
end

function Gui.RenderChatLogs()
	local list = UI.ChatList
	if not list then
		return
	end

	local filtered = Gui.FilteredChatLogs()
	local jobId, scopeEntry = Gui.ChatTargetJobId()
	local elsewhere = (scopeEntry ~= nil) and (jobId ~= tostring(game.JobId or ""))

	if UI.ChatScopeLabel then
		local scopeText
		if elsewhere then
			scopeText = "No logs — " .. Funcs.Truncate(scopeEntry.username, 20) .. " is in another server"
		elseif scopeEntry then
			scopeText = "Showing this server, scoped to " .. Funcs.Truncate(scopeEntry.username, 20)
		else
			scopeText = "Showing this server"
		end
		if State.ChatOnlyConnected then
			scopeText = scopeText .. "  ·  connected only"
		end
		UI.ChatScopeLabel.Text = scopeText
	end

	for _, child in ipairs(list:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end

	if #filtered == 0 then
		local emptyText
		if elsewhere then
			emptyText = "No logs — that server is not this client's server, so nothing was ever received from it."
		elseif State.ChatOnlyConnected then
			emptyText = "No messages from connected CPanel users in this server yet."
		else
			emptyText = "Nothing logged yet — messages appear here as this client receives them."
		end
		local empty = MkLabel(emptyText, F_MED, 12, SUBTEXT, list)
		empty.Name = "ChatEmpty"
		empty.Size = UDim2.new(1, 0, 0, 0)
		empty.AutomaticSize = Enum.AutomaticSize.Y
		empty.LayoutOrder = 1
		empty.TextXAlignment = Enum.TextXAlignment.Left
		empty.TextYAlignment = Enum.TextYAlignment.Top
		empty.TextWrapped = true
		return
	end

	local first = math.max(1, #filtered - CHAT_RENDER_MAX + 1)
	for index = first, #filtered do
		local entry = filtered[index]
		local row = MkLabel("", F_REG, 12, TEXT, list)
		row.Name = "ChatRow"
		row.Size = UDim2.new(1, 0, 0, 0)
		row.AutomaticSize = Enum.AutomaticSize.Y
		row.LayoutOrder = index
		row.TextXAlignment = Enum.TextXAlignment.Left
		row.TextYAlignment = Enum.TextYAlignment.Top
		row.TextWrapped = true
		row.RichText = false
		row.TextColor3 = (entry.userId == LocalPlayer.UserId) and ACCENT or TEXT
		row.Text = string.format("[%s] %s: %s", entry.stamp, entry.username, entry.text)
	end
end

function Gui.BuildChatLogsPage()
	local scroll = PageScroll("Chat")

	local headCard = MkCardAuto(scroll, 1)
	MkPadding(14, 14, 12, 12, headCard)
	local headLayout = MkList(Enum.FillDirection.Vertical, 8, headCard)
	headLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill

	MkHeading(headCard, "Chat Logs", 1)
	MkHint(headCard, "Live messages this client can receive, grouped by the server they were said in. Only Connected Users narrows the list to messages from connected CPanel users instead of the whole server.", 2)

	local scopeRow = Instance.new("Frame")
	scopeRow.BackgroundTransparency = 1
	scopeRow.BorderSizePixel = 0
	scopeRow.Size = UDim2.new(1, 0, 0, 32)
	scopeRow.LayoutOrder = 3
	scopeRow.Parent = headCard

	local scopeCaption = MkLabel("Show", F_MED, 12, SUBTEXT, scopeRow)
	scopeCaption.Size = UDim2.new(0, 44, 1, 0)
	scopeCaption.Position = UDim2.new(0, 0, 0, 0)
	scopeCaption.TextXAlignment = Enum.TextXAlignment.Left

	UI.ChatScopeCycle = Gui.MakeCycle(scopeRow, ChatScopeOptions, 1, 0, function(_, index)
		State.ChatScopeUserId = ChatScopeUserIds[index] or nil
		Gui.RenderChatLogs()
	end)
	UI.ChatScopeCycle.button.AnchorPoint = Vector2.new(1, 0.5)
	UI.ChatScopeCycle.button.Position = UDim2.new(1, 0, 0.5, 0)
	UI.ChatScopeCycle.button.Size = UDim2.new(0, 180, 0, 30)

	UI.ChatScopeLabel = MkLabel("", F_REG, 11, SUBTEXT, headCard)
	UI.ChatScopeLabel.Size = UDim2.new(1, 0, 0, 0)
	UI.ChatScopeLabel.AutomaticSize = Enum.AutomaticSize.Y
	UI.ChatScopeLabel.LayoutOrder = 4
	UI.ChatScopeLabel.TextXAlignment = Enum.TextXAlignment.Left
	UI.ChatScopeLabel.TextWrapped = true

	local toggleRow = Instance.new("Frame")
	toggleRow.BackgroundTransparency = 1
	toggleRow.BorderSizePixel = 0
	toggleRow.Size = UDim2.new(1, 0, 0, 30)
	toggleRow.LayoutOrder = 5
	toggleRow.Parent = headCard

	local toggleLabel = MkLabel("Only Connected Users", F_MED, 13, TEXT, toggleRow)
	toggleLabel.Size = UDim2.new(1, -60, 1, 0)
	toggleLabel.Position = UDim2.new(0, 0, 0, 0)
	toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

	local onlyToggle = Gui.MakeToggle(toggleRow, State.ChatOnlyConnected, function(value)
		State.ChatOnlyConnected = value
		Gui.RenderChatLogs()
	end)
	onlyToggle.holder.AnchorPoint = Vector2.new(1, 0.5)
	onlyToggle.holder.Position = UDim2.new(1, 0, 0.5, 0)

	local logScroll = MkScroll(headCard, Enum.ScrollingDirection.Y)
	logScroll.Name = "ChatLogList"
	logScroll.BackgroundColor3 = BG3
	logScroll.BackgroundTransparency = 0
	logScroll.BorderSizePixel = 0
	logScroll.Size = UDim2.new(1, 0, 0, 236)
	logScroll.LayoutOrder = 6
	MkCorner(8, logScroll)
	MkStroke(BORDER, 1, logScroll)
	MkPadding(10, 10, 10, 10, logScroll)
	MkList(Enum.FillDirection.Vertical, 6, logScroll)
	UI.ChatList = logScroll

	local sendCard = MkCardAuto(scroll, 2)
	MkPadding(14, 14, 12, 12, sendCard)
	local sendLayout = MkList(Enum.FillDirection.Vertical, 8, sendCard)
	sendLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill

	MkHeading(sendCard, "Send as selected user", 1)
	MkHint(sendCard, "Sends TextChatService.TextChannels.RBXGeneral:SendAsync(text) on the selected participant's own client, so it goes out under their name. Pick someone in the Dashboard first.", 2)

	local sendRow = Instance.new("Frame")
	sendRow.BackgroundTransparency = 1
	sendRow.BorderSizePixel = 0
	sendRow.Size = UDim2.new(1, 0, 0, 34)
	sendRow.LayoutOrder = 3
	sendRow.Parent = sendCard

	local sendBox = MkInput(sendRow, "Message to send…", 0)
	sendBox.Size = UDim2.new(1, -118, 0, 34)
	sendBox.Position = UDim2.new(0, 0, 0, 0)
	UI.ChatSendBox = sendBox

	local sendBtn = MkBtn("Send", F_BOLD, 13, WHITE, ACCENT, sendRow)
	sendBtn.Size = UDim2.new(0, 106, 0, 34)
	sendBtn.AnchorPoint = Vector2.new(1, 0.5)
	sendBtn.Position = UDim2.new(1, 0, 0.5, 0)
	MkCorner(8, sendBtn)

	sendBtn.MouseButton1Click:Connect(function()
		Gui.RunAction("chat_send", "Chat", function()
			return { text = sendBox.Text }
		end, sendBtn)
	end)

	Gui.RefreshChatScopeOptions()
	Gui.RenderChatLogs()
	Gui.SetStatus("Chat", "", nil)
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
end

function Gui.BuildAllPages()
	Gui.BuildDashboardPage()
	Gui.BuildGeneralPage()
	Gui.BuildSpectatePage()
	Gui.BuildAudioPage()
	Gui.BuildVisualPage()
	Gui.BuildFunPage()
	Gui.BuildChatLogsPage()
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

	warn("[CPanel] shut down")
end

Funcs.LoadSettings()
Gui.ApplyTheme(Settings.Theme)
Gui.StartChatCapture()

task.spawn(function()
	Funcs.GetAsset("CPanel/CPN_Logo.png")
end)

task.spawn(function()
	while not State.Shutdown do
		task.wait(3)
		if State.Shutdown then
			return
		end
		pcall(PersistWsFile)
	end
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