if not isfolder("GelatekHubRemastered") then
	makefolder("GelatekHubRemastered")
end

if not isfolder("GelatekHubRemastered/Audios") then
	makefolder("GelatekHubRemastered/Audios")
end

local Repo = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/GelatekHubRM/Audios/"
local Files = {
	"GaleFighter.mp3",
	"Ender.mp3",
	"DualUltima.mp3",
	"Carnage.mp3",
	"NeptunianV.mp3",
	"Chips.mp3",
	"VoodooDoll.mp3",
}

local HowMuch = #Files

task.spawn(function()
	warn("Downloading.")
	task.wait(0.2)
	warn("Downloading..")
	task.wait(0.2)
	warn("Downloading...")
end)

for Index, FileName in ipairs(Files) do
	local Path = "GelatekHubRemastered/Audios/" .. FileName

	if not isfile(Path) then
		local Success, Result = pcall(function()
			return game:HttpGet(Repo .. FileName)
		end)

		if Success and Result then
			local WriteSuccess = pcall(function()
				writefile(Path, Result)
			end)

			if WriteSuccess then
				warn(
					FileName:gsub("%.mp3$", "") ..
					" Downloaded! " ..
					Index .. "/" .. HowMuch
				)
			end
		end
	end
end