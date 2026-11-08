local BASE = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Utilities/CPanel/"
local MAIN_URL = BASE .. "Main.lua"
local INIT_URL = BASE .. "Init.lua"
local WS_PATH = "CPanel/.websocketUrl"
local LEGACY_WS_PATH = ".websocketUrl"

local function ValidWs(url)
	return type(url) == "string" and url:match("^wss?://") ~= nil
end

local function Trim(url)
	return (tostring(url):match("^%s*(.-)%s*$"))
end

local function SaveUrl(url)
	if type(writefile) ~= "function" then
		return
	end
	pcall(writefile, WS_PATH, Trim(url))
end

local function LoadUrl()
	if type(readfile) ~= "function" then
		return nil
	end

	for _, path in ipairs({ WS_PATH, LEGACY_WS_PATH }) do
		local ok, stored = pcall(readfile, path)
		if ok then
			stored = Trim(stored)
			if ValidWs(stored) then
				return stored
			end
		end
	end

	return nil
end

local function ResolveUrl()
	local seeded = nil
	if type(getgenv) == "function" then
		pcall(function()
			seeded = getgenv().CPanelWebsocket
		end)
	end
	if ValidWs(seeded) then
		SaveUrl(seeded)
	end

	if type(getgenv) == "function" then
		pcall(function()
			getgenv().CPanelWebsocket = nil
		end)
	end

	return LoadUrl()
end

ResolveUrl()

if type(queue_on_teleport) == "function" then
	pcall(queue_on_teleport, 'loadstring(game:HttpGet("' .. INIT_URL .. '"))()')
else
	warn("[CPanel] queue_on_teleport is unavailable — the panel will not follow you through teleports")
end

local ok, chunk = pcall(function()
	return loadstring(game:HttpGet(MAIN_URL))
end)

if not ok then
	warn("[CPanel] could not download Main.lua: " .. tostring(chunk))
	return
end

if type(chunk) ~= "function" then
	warn("[CPanel] Main.lua did not compile into a runnable chunk")
	return
end

chunk()