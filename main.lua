function Initialize(Plugin)
    Plugin:SetName("SampleForgeMod")
    Plugin:SetVersion(1)

    LOG("Initializing SampleForgeMod...")

    cPluginManager.AddHook(cPluginManager.HOOK_LOGIN_FORGE, OnLoginForge)
    
    LOG("Initialized SampleForgeMod!")

    return true
end

function OnLoginForge(Client)
    LOG("SampleForgeMod received forge mods connection")
    -- TODO: Client:GetForgeMods()

    return false -- Allow all connections
end
