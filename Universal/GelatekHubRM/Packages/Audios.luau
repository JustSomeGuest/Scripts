if not isfolder("GelatekHubRemastered") then
	makefolder("GelatekHubRemastered")
end

if not isfolder("GelatekHubRemastered/Audios") then
	makefolder("GelatekHubRemastered/Audios")
end

local Repo = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/GelatekHubRM/Audios/"
local Files = {
	"GaleFighter.mp3",
	"Ender.mp3",
	"Caducus.mp3",
	"DualUltima.mp3",
	"Carnage.mp3",
	"NeptunianV.mp3",
	"ZenithBattleRifle70.mp3",
	"Chips.mp3",
	"VoidScythe.mp3",
	"VoodooDoll.mp3",
	"Quenox.mp3",
	"Goner.mp3"
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
		writefile(
			Path,
			game:HttpGet(Repo .. FileName)
		)

		warn(
			FileName:gsub("%.mp3$", "") ..
			" Downloaded! " ..
			Index .. "/" .. HowMuch
		)
	end
end