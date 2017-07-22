function Initialize(Plugin)
    Plugin:SetName("SampleForgeMod")
    Plugin:SetVersion(1)

    LOG("Initializing SampleForgeMod...")

    cPluginManager.AddHook(cPluginManager.HOOK_LOGIN_FORGE, OnLoginForge)
    cRoot:Get():GetServer():RegisterForgeMod("foo", "1.2.3")
    cRoot:Get():GetServer():RegisterForgeModForProtocol("special mod", "7", 335)

    cPluginManager.AddHook(cPluginManager.HOOK_LOGIN, OnLogin)
    cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined)
    
    LOG("Initialized SampleForgeMod!")

    return true
end

function OnLogin(Client, ProtocolVersion, UserName)
    LOG("SampleForgeMod received OnLogin")
    if Client:IsModded() then
        LOG("Client is modded!")
    else
        LOG("Client is NOT modded")
        -- TODO: fix this, logs "Sending a DC" but client stays on "Logging in..."
        -- https://github.com/cuberite/cuberite/issues/3868 HOOK_LOGIN causes client to hang and timeout, instead of getting kicked
        -- Client:Kick("This server requires Forge. Please install Forge on your client and reconnect.")
        -- return true
        --
        -- As a workaround (see below), kick in OnPlayerJoined instead:
    end
end

function OnPlayerJoined(Player)
    local Client = Player:GetClientHandle()

    if not Client:IsModded() then
        LOG("Kicking non-modded player!")
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
        local version = mods:GetModVersionAt(i - 1)

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

    return false -- Allow all connections
end
