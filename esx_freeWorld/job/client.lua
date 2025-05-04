RegisterNetEvent('D-jobot:openUI')
AddEventHandler('D-jobot:openUI', function(businessLabel, businessText, status)
    SendNUIMessage({
        display = true,
        businessLabel = businessLabel,
        businessText = businessText,
        status = status,
        displayTime = Configs.DisplayTime or 5000
    })
end)

RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)