ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    createPedSpawn()
end)

function DoNotification(text, nType)
    ESX.ShowNotification(text, "info")
end