local isAiming, isDefaultName, currentCrosshair = false, false, 1

CreateThread(function()
    --if GetCurrentResourceName() == 'nyam_crosshair' then
        isDefaultName = true
        local cachedCrosshair = GetResourceKvpInt('crosshair')
        if cachedCrosshair > 0 then
            currentCrosshair = cachedCrosshair
        end
    --end
    if not isDefaultName then
        print('nyam_crosshair: !WARNING! resource renamed..')
        print('nyam_crosshair: !WARNING! it wont save kvp to users local data..')
        print('nyam_crosshair: !WARNING! please keep it default name..')
        print('nyam_crosshair: !WARNING! so people will be able to use servers-wide same reticle than setting it again n again.')
    end
    for i = 1, 13 do
        SendNUIMessage({type = "DisplayCrosshair", enable = false, style = i})
        Wait(0)
    end
    --[[CreateThread(function()
        while true do
            HideHudComponentThisFrame(14)
            Wait(7)
        end
    end)]]
    while true do
        ManageReticle()
        Citizen.Wait(500)
    end
end)

RegisterNetEvent("crosshair")
AddEventHandler("crosshair", function()
    CrossHair()
end)

CrossHair = function()
    SetNuiFocus(true, true)
    SendNUIMessage({type = "EnableCrosshairMenu", enable = true})
end

ManageReticle = function()
    if not IsEntityDead(PlayerPedId()) and currentCrosshair ~= 13 then
        if (IsPlayerFreeAiming(PlayerId())) then
            if not isAiming then
                SendNUIMessage({type = "DisplayCrosshair", enable = true, style = currentCrosshair})
                isAiming = true
            end
        else
            if isAiming then
                SendNUIMessage({type = "DisplayCrosshair", enable = false, style = currentCrosshair})
                isAiming = false
            end
        end
    else
        Citizen.Wait(750)
    end
end

RegisterNUICallback('escape', function(data, cb)
    SetNuiFocus(false, false)    
    SendNUIMessage({type = "EnableCrosshairMenu", enable = false})
    cb('ok')
end)

RegisterNUICallback('setCrosshair', function(data, cb)
    crosshairIndex = tonumber(data['crosshairIndex'])

    currentCrosshair = crosshairIndex
    if isDefaultName then
        SetResourceKvpInt('crosshair', currentCrosshair)
    end
    cb('ok')
end)