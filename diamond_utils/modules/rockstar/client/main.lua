---@diagnostic disable: unused-local, missing-parameter, undefined-field
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterCommand('rec', function(source, args)
    ESX.TriggerServerCallback('drp_rockstar:checkAccess', function(hasAccess)
        if hasAccess then
            StartRecording(1)
        else
            ESX.ShowNotification('Shoma dastresi be Rockstar Editor nadarid!')
        end
    end)
end)
  
RegisterCommand('stoprec', function(source, args)
    ESX.TriggerServerCallback('drp_rockstar:checkAccess', function(hasAccess)
        if hasAccess then
            StopRecordingAndSaveClip()
        else
            ESX.ShowNotification('Shoma dastresi be Rockstar Editor nadarid!')
        end
    end)
end)  

RegisterCommand('startedit', function(source, args)
    ESX.TriggerServerCallback('drp_rockstar:checkAccess', function(hasAccess)
        if hasAccess then
            ActivateRockstarEditor()
        else
            ESX.ShowNotification('Shoma dastresi be Rockstar Editor nadarid!')
        end
    end)
end)