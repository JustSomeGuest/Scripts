local BASE = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Utilities/CPanel/"
local MAIN_URL = BASE .. "Main.lua"
local INIT_URL = BASE .. "Init.lua"

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