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
    local mods = Client:GetForgeMods()
    LOG("SampleForgeMod got mods: " .. mods:GetNumMods())

    for i = 1, mods:GetNumMods() do
        local name = mods:GetModNameAt(i - 1)
        local version = mods:GetModVersionAt(i - 1)

        LOG("SampleForgeMod mod #" .. i .. " is " .. name .. " version " .. version)
    end

    return false -- Allow all connections
end
