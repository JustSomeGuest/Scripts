loadstring(game:HttpGet("https://raw.githubusercontent.com/banishercool/banishercool/main/Green%20Baseplate%20Reanimate.lua.txt"))()

local player = game.Players.LocalPlayer
local char = player.Character

local Align = function(Part0, Part1, Mesh)
    local Aligns = {
        AlignOrientation = Instance.new("AlignOrientation", Part0),
        AlignPosition = Instance.new("AlignPosition", Part0)
    }

    local Attachments = {
        Attach0 = Instance.new("Attachment", Part0),
        Attach1 = Instance.new("Attachment", Part1)
    }

    local m = Part0:FindFirstChildOfClass("SpecialMesh")

    if Mesh and m then
        m:Destroy()
    end

    Part0:BreakJoints()

    Aligns.AlignOrientation.Attachment0 = Attachments.Attach0
    Aligns.AlignOrientation.Attachment1 = Attachments.Attach1
    Aligns.AlignOrientation.Responsiveness = math.huge
    Aligns.AlignOrientation.RigidityEnabled = true

    Aligns.AlignPosition.Attachment0 = Attachments.Attach0
    Aligns.AlignPosition.Attachment1 = Attachments.Attach1
    Aligns.AlignPosition.Responsiveness = math.huge
    Aligns.AlignPosition.RigidityEnabled = true
    Aligns.AlignPosition.MaxForce = 999999999

    spawn(function()
        while _G.loop do
            local mag = (Part0.Position - (Part1.CFrame * Attachments.Attach0.CFrame:Inverse()).p).Magnitude

            if mag >= 5 then
                Part0.CFrame = Part1.CFrame * Attachments.Attach0.CFrame:Inverse()
            end

            Part0.Velocity = Vector3.new(0, 35, 0)
            game:GetService("RunService").Heartbeat:Wait()
        end
    end)

    return {Attachments.Attach0, Attachments, Aligns}
end

local hat = Align(char["Starslayer Railgun"].Handle, char["Right Arm"], false)

local cf =
    char["Right Arm"].CFrame
    * CFrame.new(0, -2, -0.70)
    * CFrame.Angles(math.rad(0), math.rad(100), 175.15)

hat[1].CFrame = cf:Inverse() * char["Right Arm"].CFrame

loadstring(game:HttpGet("https://raw.githubusercontent.com/ian49972/SCRIPTS/main/M41451"))()