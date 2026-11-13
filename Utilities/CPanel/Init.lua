local base = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Utilities/CPanel/"
local mainUrl = base .. "Main.lua"
local initUrl = base .. "Init.lua"
local wsPath = "CPanel/.websocketUrl"

local function resolveUrl()
	local seeded

	if type(getgenv) == "function" then
		pcall(function()
			local env = getgenv()
			seeded = env.CPanelWebsocket
			env.CPanelWebsocket = nil
		end)
	end

	if type(seeded) == "string" and seeded:match("^wss?://") then
		if type(writefile) == "function" then
			pcall(writefile, wsPath, seeded)
		end
	end

	if type(readfile) == "function" then
		local ok, url = pcall(readfile, wsPath)

		if ok then
			url = tostring(url):match("^%s*(.-)%s*$")
			if url:match("^wss?://") then
				return url
			end
		end
	end
end

resolveUrl()

if type(queue_on_teleport) == "function" then
	pcall(queue_on_teleport, 'loadstring(game:HttpGet("' .. initUrl .. '"))()')
else
	warn("[CPanel] queue_on_teleport is unavailable")
end

local ok, chunk = pcall(function()
	return loadstring(game:HttpGet(mainUrl))
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