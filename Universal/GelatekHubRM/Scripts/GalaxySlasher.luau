local Success, Response = pcall(function()
    return game:HttpGetAsync("https://raw.githubusercontent.com/banishercool/banishercool/main/Feslasherscript.lua")
end)

if not Success then
    Success, Response = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/banishercool/banishercool/main/Feslasherscript.lua")
    end)
end

if Success and Response then
    loadstring(Response)()
end