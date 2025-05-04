IsDead = false

function OnRevive()
    if not IsDead then return end
    -- * Enable phone usage.
    debugPrint('Player is revived, enabling phone usage')
    PhoneDisabled = false
    IsDead = false
end

function OnDeath()
    if IsDead then return end

    debugPrint('Player is dead, disabling phone usage')

    -- * Close phone if open.
    if PhoneOpen then
        ToggleOpen(false)
    end

    -- * Leave radio channel if on one.
    if OnRadio then
        debugPrint('Player is dead, leaving radio channel')

        SendUIAction('radio:drop-channel', {})

        LeaveRadioChannel()
    end

    if PhoneData.CallData.CallId then
        debugPrint('Player is dead, hanging up phone')

        SendUIAction('kb-cancel-call')
    end

    if IsAccountLive() then
        debugPrint('Player is dead, stopping live stream')

        SendUIAction('instashots:live:stop')
    end

    SendUIAction('cleanup:on-death')

    -- * ========================== * --
    -- * ... do other stuff here ...* --
    -- * ========================== * --

    -- * Disable phone usage.
    PhoneDisabled = true
    IsDead = true
end

if Config.Framework == 'qbox' then
    AddStateBagChangeHandler('qbx_medical:deathState', ('player:%s'):format(cache.serverId), function(_, _, value)
        if value == 1 then
            OnRevive()
        elseif (Config.Death.LastStand and value == 2) or value == 3 then
            OnDeath()
        end
    end)
elseif Config.Framework == 'qb' then
    local Framework = exports['qb-core']:GetCoreObject()

    CreateThread(function()
        while true do
            Wait(Config.Death.CheckDeathTimeout)
            if LocalPlayer.state.isLoggedIn then
                Framework.Functions.GetPlayerData(function(playerData)
                    if (Config.Death.LastStand and playerData.metadata.inlaststand) or playerData.metadata.isdead then
                        OnDeath()
                    else
                        OnRevive()
                    end
                end)
            end
        end
    end)
elseif Config.Framework == 'esx' then
    RegisterNetEvent('esx:onPlayerDeath', function()
        OnDeath()
    end)

    local events = {
        'wasabi_bridge:onPlayerSpawn',
        'ars_ambulancejob:healPlayer',
        'brutal_ambulancejob:revive',
        'esx_ambulancejob:revive',
        'wasabi_ambulance:revive'
    }

    for i = 1, #events do RegisterNetEvent(events[i], function() OnRevive() end) end
end
