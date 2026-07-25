if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (function()
    local Success, Env = pcall(getgenv)
    return (Success and Env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

if not Shared.Click then
    Shared.Click = true

    local cloneref = cloneref or function(o)
        return o
    end

    local Services = setmetatable({}, {
        __index = function(Self, Name)
            local Success, Service = pcall(function()
                return cloneref(game:GetService(Name))
            end)

            if not Success then
                error("Invalid Service: " .. tostring(Name))
            end

            rawset(Self, Name, Service)
            return Service
        end
    })

    local Hui = (gethui and gethui()) or Services.CoreGui

    local Sounds = Instance.new("ScreenGui")
    Sounds.Name = "Sounds"
    Sounds.ResetOnSpawn = false
    Sounds.IgnoreGuiInset = true
    Sounds.Parent = Hui

    local Click = Instance.new("Sound")
    Click.SoundId = "rbxassetid://6895079853"
    Click.Volume = 0.2
    Click.Name = "Click"
    Click.Parent = Sounds

    local Connected = {}

    local function PlayClick()
        Click:Stop()
        Click:Play()
    end

    local function ConnectBtn(Object)
        if (Object:IsA("TextButton") or Object:IsA("ImageButton")) and not Connected[Object] then
            Connected[Object] = true
            Object.MouseButton1Click:Connect(PlayClick)
        end
    end

    local function Scan(Object)
        for _, Descendant in ipairs(Object:GetDescendants()) do
            ConnectBtn(Descendant)
        end

        Object.DescendantAdded:Connect(ConnectBtn)
    end

    Scan(game)
    Scan(Services.CoreGui)

    if gethui and gethui() then
        Scan(gethui())
    end
end