if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (function()
    local Success, Env = pcall(getgenv)
    return (Success and Env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local function HttpGet(url)
    local success, result = pcall(game.HttpGetAsync, game, url)
    if success then
        return result
    end
    return game:HttpGet(url)
end

local VoidUI = loadstring(HttpGet("https://raw.githubusercontent.com/JustSomeGuest/VoidUI/Stable/Source/Init.luau"))()

if not VoidUI then
    warn("[Sanity.exe]: Failed to load VoidUI")
    return
end

VoidUI:SetTitle("Sanity.exe")

local CURRENT_PLACE_ID = game.PlaceId
local Tab = VoidUI:New("Tab", {
    Text = "Main"
})

local function LoadGameScript(filePath)
    local url = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/" .. filePath
    local success, gameScript = pcall(function()
        return HttpGet(url)
    end)

    if success and gameScript then
        local loadFunction, loadError = loadstring(gameScript)
        if loadFunction then
            local execSuccess, execErr = pcall(loadFunction)
            if not execSuccess then
                warn("[Sanity.exe]: Game script execution error: " .. tostring(execErr))
            end
        else
            warn("[Sanity.exe]: Error loading game script: " .. tostring(loadError))
        end
    else
        warn("[Sanity.exe]: Failed to download game script: " .. filePath)
        VoidUI:New("Label", {
            Text = "Error loading game!",
            Parent = Tab
        })
    end
end

local function LoadSupportedGames()
    local success, gameListData = pcall(function()
        return HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/Supported.luau")
    end)

    if not success or not gameListData then
        warn("[Sanity.exe]: Failed to load supported games list.")
        VoidUI:New("Label", {
            Text = "Failed to load supported games list.",
            Parent = Tab
        })
        return
    end

    local loadFunction, loadError = loadstring(gameListData)
    if not loadFunction then
        warn("[Sanity.exe]: Error parsing supported games list: " .. tostring(loadError))
        VoidUI:New("Label", {
            Text = "Error parsing supported games list.",
            Parent = Tab
        })
        return
    end

    local SupportedGames = loadFunction()
    local foundGame = false

    for _, gameInfo in ipairs(SupportedGames) do
        if tostring(gameInfo.PlaceId) == tostring(CURRENT_PLACE_ID) then
            foundGame = true
            local gameFilePath = gameInfo.FilePath
            if gameFilePath then
                LoadGameScript(gameFilePath)
            else
                warn("[Sanity.exe]: No file path for game: " .. gameInfo.GameName)
                VoidUI:New("Label", {
                    Text = "No file path for: " .. gameInfo.GameName,
                    Parent = Tab
                })
            end
            break
        end
    end

    if not foundGame then
        warn("[Sanity.exe]: Current game not supported. PlaceId: " .. tostring(CURRENT_PLACE_ID))
        VoidUI:New("Label", {
            Text = "Game not supported.",
            Parent = Tab
        })
        VoidUI:New("Divider", {
            Parent = Tab
        })
        VoidUI:New("Label", {
            Text = "Supported Games:",
            Parent = Tab
        })

        for _, gameInfo in ipairs(SupportedGames) do
            VoidUI:New("Button", {
                Text = gameInfo.GameName .. " (" .. tostring(gameInfo.PlaceId) .. ")",
                Parent = Tab,
                Callback = function()
                    setclipboard(tostring(gameInfo.PlaceId))
                    warn("[Sanity.exe]: Place ID copied: " .. tostring(gameInfo.PlaceId))
                end
            })
        end
    end
end

LoadSupportedGames()