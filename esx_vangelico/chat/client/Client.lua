
--[[RegisterKey("Y", function()
    if PlayerData and PlayerData.gang.name == "STAFF" then
        SetNuiFocus(true, true)
        SendNUIMessage({ 
            action = 'display',
            playername = GetPlayerName(PlayerId()),
            status = 'sent',
            staff = 5,
        })
    end
end)]]

RegisterNUICallback('messagesent', function(data, cb)
    TriggerServerEvent('messagerecieved', data)
end)

RegisterNUICallback('imagesent', function(data, cb)
    TriggerServerEvent('imagereceived', data)
end)

RegisterNetEvent('sendmessage')
AddEventHandler('sendmessage', function(data, playername)
    SendNUIMessage({
        type = "sendmessage",
        message = data,
        sourcename = playername,
        playername = GetPlayerName(PlayerId())
    })
end)

RegisterNetEvent('sendimage')
AddEventHandler('sendimage', function(sourcename, data) 
    SendNUIMessage({
        type = "sendimage",
        imagelink = data,
        srcname = sourcename,
    })
end)

RegisterNUICallback('exit', function(data, cb)
    SetNuiFocus(false, false) 
end)