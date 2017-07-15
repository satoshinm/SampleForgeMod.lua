function Initialize(Plugin)
    Plugin:SetName("SampleForgeMod")
    Plugin:SetVersion(1)

    LOG("Initializing SampleForgeMod...")

    cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_FORGE_MODS, OnPlayerForgeMods)
    
    LOG("Initialized SampleForgeMod!")

    return true
end

function OnPlayerForgeMods(Client, Mods)
    LOG("SampleForgeMod received forge mods connection")
    -- LOG("Mods: " .. Mods)

    return false -- Allow all connections
end
