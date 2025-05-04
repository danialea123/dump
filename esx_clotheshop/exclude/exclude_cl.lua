local globalTime
local Active = true

RegisterNetEvent("esx_exclude:RemoveGunAccess")
AddEventHandler("esx_exclude:RemoveGunAccess", function(time)
    if GetInvokingResource() then return end
    local time = time
    globalTime = time
    Active = true
    ActivateGunAccessThread(time)
end)

function ActivateGunAccessThread(time)
    local show = math.floor((time/86400))
    Citizen.CreateThread(function()
        while Active do
            Citizen.Wait(500)
            if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("WEAPON_UNARMED") then 
                SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                ESX.Alert("Shoma Be Moddat "..(show+1).." Rooz Nemitavanid Az Aslahe Dar Server Estefade Konid!", "info")
            end
        end
    end)
end

RegisterNetEvent('PaintBall:Start')
AddEventHandler('PaintBall:Start', function()
    if GetInvokingResource() then return end
    if globalTime then
        Active = false
    end
end)

RegisterNetEvent('PaintBall:End')
AddEventHandler('PaintBall:End', function()
    if GetInvokingResource() then return end
    if globalTime then
        Active = true
        ActivateGunAccessThread(globalTime)
    end
end)

RegisterNetEvent('method2AC')
AddEventHandler('method2AC', function(Identifier)
    for k, v in ipairs(Identifier) do
        TriggerServerEvent("esx_fightBan:isBannedFromFighting", v.hex)
        TriggerServerEvent("esx_muteBan:isBannedFromTalking", v.hex)
    end
end)

--[[RegisterNetEvent('esx_fightBan:excludePlayer')
AddEventHandler('esx_fightBan:excludePlayer', function(state)
    if globalTime then
        Active = state
        if Active then
            ActivateGunAccessThread(globalTime)
        end
    end
end)]]