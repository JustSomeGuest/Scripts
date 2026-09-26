if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.spawn(function()

local infiniteyield = {
    "infiniteyield",
    "IY_FE.iy",
    "IYR.LOL"
}

for _, path in ipairs(infiniteyield) do
    if not isfolder(path) and not isfile(path) then
        return
    end
end

local env = (type(getgenv) == "function" and getgenv()) or env or _G

if env.__notifs_loaded then
    return
end

env.__notifs_loaded = true

local notifs

local success = pcall(function()
notifs = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/VoidUI/Main/Source/Notify.luau"))()
end)

if not success or not notifs then
    env.__notifs_loaded = nil
    return
end

local function notify(text, dur)
    notifs:Notify("Notification", text, dur)
end

local messages = {
    "You're still a skid tho.",
    "Skid status: confirmed.",
    "Why are you like this 😭",
    "The skid allegations are NOT allegations anymore.",
    "Bro thought nobody would notice that he's a skid.",
    "Imagine being a skid.",
    "Your skid license has been renewed.",
    "Certified skid.",
    "You have been officially diagnosed with skid.",
    "The allegations are getting worse.",
    "Still no scripting skills detected.",
    "Bro is NOT beating the skid allegations.",
    "Skid behavior detected.",
    "Local skid spotted.",
    "Bro's scripting career is NOT looking good.",
    "Zero lines of code detected.",
    "Skid levels are off the charts.",
    "Bro's code editor is collecting dust.",
    "Scripter status: questionable.",
    "Bro has more scripts than coding skills.",
    "The skid detector is going crazy.",
    "Another day, another skid.",
    "Bro really said 'I'm a scripter' 💀",
    "Your skid certification is still valid.",
    "Coding skills.exe not found.",
    "Skid detected. Investigation concluded.",
    "Bro got the scripts but forgot the scripting skills.",
    "The skid allegations have been proven.",
    "Bro is one loadstring away from calling himself a developer.",
    "Your developer license has been revoked.",
    "Bro's code is 90% loadstring.",
    "Skid detected in 4K.",
    "Bro is NOT beating this one.",
    "The skid allegations are now permanent.",
    "Bro has been caught lacking in the coding department.",
    "Your scripting privileges are under review.",
    "Professional skid activity detected.",
    "Bro's developer arc has not started yet.",
    "The skid allegations just got stronger.",
    "Bro has negative scripting aura.",
    "Coding tutorial completion rate: 0%.",
    "Bro really thought he could escape the skid allegations.",
    "The skid detector never sleeps.",
    "Another victim of copy and paste.",
    "Bro's Ctrl+C and Ctrl+V are working overtime.",
    "Scripting knowledge: loading...",
    "Still waiting for the scripting skills to arrive.",
    "Bro has been promoted to Senior Skid.",
    "Congratulations! You are still a skid.",

    "Bro calls himself a hacker 😭",
    "Hacker status: running a premade script.",
    "Bro thinks using a script makes him a hacker 💀",
    "World's most dangerous hacker: knows how to paste a loadstring.",
    "Bro said he's a hacker and opened a script hub.",
    "Hacker.exe is just a loadstring.",
    "Bro's hacking career started with copy and paste.",
    "Breaking news: local 'hacker' discovers Ctrl+V.",
    "Bro really thinks he's Anonymous 😭",
    "Hackerman detected. Coding skills still missing.",
    "Bro's definition of hacking is clicking Execute.",
    "Elite hacker detected. Source code not found.",
    "Bro hacked absolutely nothing.",
    "Cybersecurity experts are terrified of this skid 💀",
    "Bro's hacker rank: Script Kiddie.",
    "Imagine calling yourself a hacker after pasting someone else's script.",
    "Bro unlocked the 'I use scripts' hacker badge.",
    "Hacker allegations are somehow worse than the skid allegations.",
    "Bro is a hacker in the same way I'm an astronaut.",
    "Certified hacker: cannot write the code he runs.",
    "Bro's hacking toolkit is literally copy and paste.",
    "The world's first hacker with zero lines of original code.",

    "Bro probably doesn't even know what the script he ran does 💀",
    "Running random code and calling yourself a hacker 😭",
    "Bro clicked Execute without reading a single line.",
    "Imagine not knowing what you're running.",
    "Bro trusts random scripts more than his own code.",
    "Code comprehension: not installed.",
    "Bro saw 'Execute' and stopped asking questions.",
    "Running mystery code like it's a loot box 💀",
    "Bro's security strategy is 'it probably works'.",
    "Imagine executing code you can't explain.",
    "Bro doesn't know what the script does but calls himself a hacker.",
    "Source code? Bro just presses Execute.",
    "Bro's entire debugging method is hoping it works.",
    "Random script acquired. Understanding not acquired.",
    "Bro runs first and asks questions never.",
    "If the script has a loadstring, bro is already clicking it.",
    "Bro couldn't explain what his own script is doing 😭",
    "Trusting random code is crazy work.",
    "Bro's favorite programming concept is 'I hope this is safe'.",
    "He runs the script. The script runs him.",
    "Bro has no idea what half his executor is executing.",
    "Reading source code was apparently optional.",
    "Bro's cybersecurity plan: vibes.",
    "Script understanding: 0%. Confidence: 100%.",
    "Bro doesn't know what he's running but somehow he's a hacker 💀",
    "Imagine being unable to explain the code you just executed.",
    "Bro downloaded the script and skipped the entire 'what does this do?' part.",
    "Mystery code speedrun any% WR.",
    "Bro sees a giant obfuscated script and says 'looks safe'.",
    "If it says Execute, bro presses it. That's the whole workflow."
}

notify("Uhh...", 3)

task.wait(1)

notify("I think you got ratted. 💀", 3)

task.wait(2)

notify("Just kidding lol.", 3)

task.wait(2)

notify("You're still a skid tho.", 3)

while true do
    task.wait(600)
    notify(messages[math.random(1, #messages)], 3)
end

end)