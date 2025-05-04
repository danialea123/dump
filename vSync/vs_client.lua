ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = true
local blackout = false
local isSyncActive = true
local gamehour , gameminute, gamesecond = 0, 0, 0
local lgamehour , lgameminute, lgamesecond = 0, 0, 0

RegisterNetEvent('vSync:updateWeather')
AddEventHandler('vSync:updateWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

--[[RegisterNetEvent("realtime:events")
AddEventHandler("realtime:events", function(h, m, s)
	NetworkOverrideClockTime(h, m, s)
end)]]

RegisterNetEvent('vSync:updateTime')
AddEventHandler('vSync:updateTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
    local hour = math.floor(((baseTime+timeOffset)/60)%24)
    local minute = math.floor((baseTime+timeOffset)%60)
    NetworkOverrideClockTime(hour, minute, 0)
    SetMillisecondsPerGameMinute(15000)
end)

RegisterNetEvent('game:updateTime')

Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0)
            Citizen.Wait(15000)
        end
        Citizen.Wait(1000) -- Wait 0 seconds to prevent crashing.
        SetBlackout(blackout)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        if lastWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
            N_0xc54a08c85ae4d410(3.0)
            RequestScriptAudioBank("ICE_FOOTSTEPS", false)
            RequestScriptAudioBank("SNOW_FOOTSTEPS", false)
            RequestNamedPtfxAsset("core_snow")
            while not HasNamedPtfxAssetLoaded("core_snow") do
                Citizen.Wait(0)
            end
            UseParticleFxAssetNextCall("core_snow")
        else
            SetForceVehicleTrails(false)
            N_0xc54a08c85ae4d410(0.0)
            SetForcePedFootstepsTracks(false)            
            RemoveNamedPtfxAsset("core_snow")
            ReleaseNamedScriptAudioBank("ICE_FOOTSTEPS")
            ReleaseNamedScriptAudioBank("SNOW_FOOTSTEPS")
        end
    end
end)

local Timer = 0

AddEventHandler("onKeyUP", function(key)
    if key == "q" then 
        if ESX.GetPlayerData().isSentenced or ESX.isDead() then return end
        RequestAnimDict('anim@mp_snowball') -- pre-load the animation
        if IsNextWeatherType('XMAS') and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPlayerFreeAiming(PlayerId()) and not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) and GetInteriorFromEntity(PlayerPedId()) == 0 and not IsPedShooting(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInCover(PlayerPedId(), 0) and GetGameTimer() - Timer > 5000 then
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_SNOWBALL"), true)
            exports.essentialmode:DisableControl(true)
            TriggerEvent("dpemote:enable", false)
            TriggerEvent("dpclothingAbuse", true)
            Citizen.Wait(50)
            TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0)
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_SNOWBALL'), 2, false, true)
            Timer = GetGameTimer()
            SetTimeout(2250, function()
                exports.essentialmode:DisableControl(false)
                TriggerEvent("dpemote:enable", true)
                TriggerEvent("dpclothingAbuse", false)
            end)
        end
    end
end)

Citizen.CreateThread(function()
    TriggerServerEvent('vSync:requestSync')
    SetMillisecondsPerGameMinute(15000)
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/weather', 'Change the weather.', {{ name="weatherType", help="Available types: extrasunny, clear, neutral, smog, foggy, overcast, clouds, clearing, rain, thunder, snow, blizzard, snowlight, xmas & halloween"}})
    TriggerEvent('chat:addSuggestion', '/blackout', 'Toggle blackout mode.')
end)

-- Display a notification above the minimap.
function ShowNotification(text, blink)
    if blink == nil then blink = false end
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(blink, false)
end

RegisterNetEvent('vSync:notify')
AddEventHandler('vSync:notify', function(message, blink)
    ShowNotification(message, blink)
end)

RegisterNetEvent('vSync:toggle')
AddEventHandler('vSync:toggle', function(status)
    isSyncActive = status
    TriggerServerEvent('vSync:requestSync')
end)

AddEventHandler("diamond_housing:garage", function(a, b)
    TriggerServerEvent('esx_advancedgarage:setVehicleState', a, b)
end)

local coord1 = vector3(1608.44,1076.4,81.92)
local coord2 = vector3(1768.13,6355.49,36.33)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(750)
        local coord = GetEntityCoords(PlayerPedId())
        local clock = GetClockHours()
        if clock >= 1 and clock <= 5 and #(coord - coord1) <= 70.0 then
            Citizen.Wait(200)
            local head = GetEntityHeading(PlayerPedId())
            if (head <= 70 and head >= 0) or head > 250 and not inZone then
                inZone = true
                ESX.ShowNotification("شدید Danger Zone شما وارد")
                Citizen.Wait(3000)
            else
                if inZone then
                    inZone = false
                    ESX.ShowNotification("خارج شدید Danger Zone شما از ")
                    Citizen.Wait(3000)
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(750)
        local coord = GetEntityCoords(PlayerPedId())
        local clock = GetClockHours()
        if clock >= 1 and clock <= 5 and #(coord - coord2) <= 70.0 then
            Citizen.Wait(200)
            local head = GetEntityHeading(PlayerPedId())
            if head >= 170 and head <= 325 and not inZone then
                inZone = true
                ESX.ShowNotification("شدید Danger Zone شما وارد")
                Citizen.Wait(3000)
            else
                if inZone then
                    inZone = false
                    ESX.ShowNotification("خارج شدید Danger Zone شما از ")
                    Citizen.Wait(3000)
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

exports("inZone", function()
    return inZone
end)