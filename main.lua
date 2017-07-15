function Initialize(Plugin)
    Plugin:SetName("SampleForgeMod")
    Plugin:SetVersion(1)

    LOG("Initializing SampleForgeMod...")

    cPluginManager.AddHook(cPluginManager.HOOK_LOGIN_FORGE, OnLoginForge)
    cRoot:Get():GetServer():RegisterForgeMod(0, "foo", "1.2.3")
    
    LOG("Initialized SampleForgeMod!")

    return true
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
