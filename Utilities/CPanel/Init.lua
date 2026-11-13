
local Base = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Utilities/CPanel/"
local MainUrl = Base .. "Main.lua"
local InitUrl = Base .. "Init.lua"
local WsPath = "CPanel/.websocketUrl"

local function ResolveUrl()
	local Seeded

	if type(getgenv) == "function" then
		pcall(function()
			local Env = getgenv()
			Seeded = Env.CPanelWebsocket
			Env.CPanelWebsocket = nil
		end)
	end

	if type(Seeded) == "string" and Seeded:match("^wss?://") then
		if type(writefile) == "function" then
			pcall(writefile, WsPath, Seeded)
		end
	end

	if type(readfile) == "function" then
		local Ok, Url = pcall(readfile, WsPath)

		if Ok then
			Url = tostring(Url):match("^%s*(.-)%s*$")
			if Url:match("^wss?://") then
				return Url
			end
		end
	end
end

ResolveUrl()

if type(queue_on_teleport) == "function" then
	pcall(queue_on_teleport, 'loadstring(game:HttpGet("' .. InitUrl .. '"))()')
else
	warn("[CPanel] queue_on_teleport is unavailable")
end

local Ok, Chunk = pcall(function()
	return loadstring(game:HttpGet(MainUrl))
end)

if not Ok then
	warn("[CPanel] could not download Main.lua: " .. tostring(Chunk))
	return
end

if type(Chunk) ~= "function" then
	warn("[CPanel] Main.lua did not compile into a runnable chunk")
	return
end

Chunk()