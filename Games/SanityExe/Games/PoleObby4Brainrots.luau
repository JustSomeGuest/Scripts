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

local VoidUI = Shared.VoidUI

local SUPPORTED_GAMES_LIST = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/Supported.luau"
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
            pcall(loadFunction)
        else
            warn("[Sanity.exe]: Error loading game script: " .. tostring(loadError))
        end
    else
        warn("[Sanity.exe]: Failed to download game script: " .. filePath)
        VoidUI:New("Label", {
            Text = "Error loading game!",
            Parent = Tabgh://repo/JustSomeGuest/Scripts@main/Games/SanityExe/Games/PoleObby4Brainrots.luau
        })
    end
end

local function LoadSupportedGames()
    local success, gameListData = pcall(function()
        return HttpGet(SUPPORTED_GAMES_LIST)
    end)

    if not success or not gameListData then
        warn("[Sanity.exe]: Failed to load supported games list.")
        VoidUI:SetTitle("Sanity.exe")
        VoidUI:New("Label", {
            Text = "Failed to load supported games list.",
            Parent = Tab
        })
        return
    end

    local loadFunction, loadError = loadstring(gameListData)
    if not loadFunction then
        warn("[Sanity.exe]: Error parsing supported games list: " .. tostring(loadError))
        VoidUI:SetTitle("Sanity.exe")
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
            VoidUI:SetTitle("Sanity.exe • " .. gameInfo.GameName)
            local gameFilePath = gameInfo.FilePath
            if gameFilePath then
                LoadGameScript(gameFilePath)
            end
            break
        end
    end

    if not foundGame then
        VoidUI:SetTitle("Sanity.exe")
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