---@diagnostic disable: undefined-global, missing-parameter, undefined-field, lowercase-global, param-type-mismatch
local Spam = false
local time = 3000

function playDiceAnimation()
    local ped = PlayerPedId()
    RequestAnimDict("anim@mp_player_intcelebrationmale@wank")
    while not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@wank") do
        Wait(0)
    end

    TaskPlayAnim(ped, "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, -8.0, 3000, 49, 0, false, false, false)
    RemoveAnimDict("anim@mp_player_intcelebrationmale@wank")
end

RegisterCommand('dice', function()
    if Spam then return ESX.Alert("Lotfan Spam Nakonid", "info") end
    Spam = true
    Citizen.SetTimeout(3000, function()
        Spam = false
    end)
    playDiceAnimation()
    Citizen.Wait(2500)
    TriggerServerEvent('esx_dice:rollDice', ESX.Game.GetPlayersToSend(50))
end)

RegisterNetEvent('esx_dice:diceRolled')
AddEventHandler('esx_dice:diceRolled', function(source, result)
    if ESX then
        if ESX.Game.DoesPlayerExistInArea(source) then
            DisplayThis(GetPlayerFromServerId(source), result)
        end
    end
end)

function DisplayThis(mePlayer, text)
    local displaying = true
    local text = "🎲 "..text
    local offset = 1 + (1*0.14)
    Citizen.CreateThread(function()
        Wait(time)
        displaying = false
    end)
    Citizen.CreateThread(function()
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 50 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text)
            end
        end
    end)
end

function DrawText3D(x, y, z, text)
    local onScreen, x, y = World3dToScreen2d(x, y, z)
    local scale = 0.35

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x, y)

        local factor = string.len(text) / 370
        DrawRect(x, y + 0.015, 0.015 + factor, 0.03, 0, 0, 0, 150)
    end
end