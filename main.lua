function Initialize(Plugin)
    Plugin:SetName("SampleForgeMod")
    Plugin:SetVersion(1)

    LOG("Initializing SampleForgeMod...")

    cPluginManager.AddHook(cPluginManager.HOOK_LOGIN_FORGE, OnLoginForge)

    cRoot:Get():GetServer():RegisterForgeMod("example mod", "1.2.3", 335) -- 1.12
    local isSuccess, err = pcall(function () cRoot:Get():GetServer():RegisterForgeMod("example mod", "1.2.3", 335) end)
    if not(isSuccess) then
        LOG("Passed test for duplicate mod registration: " .. err)
    else
        LOG("FAILED to detect duplicate mod registration!")
    end




    cRoot:Get():GetServer():RegisterForgeMod("ironchest", "1.12-7.0.31.818", 335) -- 1.12
    cRoot:Get():GetServer():RegisterForgeMod("ironchest", "1.11.2-7.0.25.815", 316) -- 1.11.2
    --cRoot:Get():GetServer():RegisterForgeMod("ironchest", "1.0") -- client-side detects as incompatible mod version


    cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined)
    
    LOG("Initialized SampleForgeMod!")

    return true
end

function OnDisable()
    LOG("SampleForgeMod is shutting down...")
    cRoot:Get():GetServer():UnregisterForgeMod("example mod", 335)
    cRoot:Get():GetServer():UnregisterForgeMod("ironchest", 335)
    cRoot:Get():GetServer():UnregisterForgeMod("ironchest", 316)
end

function OnPlayerJoined(Player)
    local Client = Player:GetClientHandle()

    -- TODO: This check can be performed in HOOK_LOGIN (instead of HOOK_PLAYER_JOINED),
    -- but 'return true' or Client:Kick both only cause the client to hang:
    -- https://github.com/cuberite/cuberite/issues/3868 HOOK_LOGIN causes client to hang and timeout, instead of getting kicked

    if not Client:IsForgeClient() then
        LOG("Kicking non-Forge player!")
        Client:Kick("This server requires Forge. Please install Forge on your client and reconnect.")
        return true
    end
end


function OnLoginForge(Client)
    LOG("SampleForgeMod received forge mods connection")
    local mods = Client:GetForgeMods()
    LOG("SampleForgeMod got mods: " .. mods:GetNumMods())

    for i = 1, mods:GetNumMods() do
        local name = mods:GetModNameAt(i - 1)
        local version = mods:GetModVersion(name)

        LOG("SampleForgeMod mod #" .. i .. " is " .. name .. " version " .. version)
    end

    -- Example of denying clients with a specific Forge mod from connecting
    -- This is a fairly harmless client mod for demonstrating purposes: https://minecraft.curseforge.com/projects/nofov
    -- Of course, a sophisticated player could trivially bypass this protection
    if mods:HasMod("nofov") then
        LOG("SampleForgeMod is denying NoFov user!")
        Client:Kick("You can't connect to this server with NoFov installed. Please disable this mod and reconnect.")
        return true
    end

    if not mods:HasMod("ironchest") then
        LOG("SampleForgeMod is denying non-ironchest user")
        Client:Kick("This server requires the Iron Chests mod. Please install it and reconnect.")
        return true
    end

    return false -- Allow all connections
end
