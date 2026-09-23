if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not isfolder("infiniteyield") or not isfile("IY_FE.iy") then
    return
end

local Notifs = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/VoidUI/Main/Source/Notify.luau"))()

local function Notify(Text, Dur)
    Notifs:Notify("Notification", Text, Dur)
end

local Messages = {
    "You're still a skid tho.",
    "Bro really uses Infinite Yield 💀",
    "Skid status: confirmed.",
    "Infinite Yield detected.",
    "Why are you using Infinite Yield 😭",
    "The skid allegations are NOT allegations anymore.",
    "Bro thought nobody would notice.",
    "I can smell the Infinite Yield from here.",
    "Imagine using Infinite Yield.",
    "Your skid license has been renewed.",
    "Certified skid behavior.",
    "You have been officially diagnosed with skid.",
    "The allegations are getting worse.",
    "Still no scripting skills detected.",
    "Bro is NOT beating the skid allegations."
}

Notify("Uhh...", 3)

task.wait(1)

Notify("I think you got ratted. 💀", 3)

task.wait(2)

Notify("Just kidding lol.", 3)

task.wait(2)

Notify("You're still a skid tho.", 3)

while true do
    task.wait(600)
    Notify(Messages[math.random(1, #Messages)], 3)
end