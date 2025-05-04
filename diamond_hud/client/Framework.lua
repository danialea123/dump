IsNUIReady = false
ESX = nil
PlayerData = nil
offHud = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNUICallback('NUIReady', function(data, cb)
	IsNUIReady = true
end)

function TriggerThread()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2500)
            if IsPauseMenuActive() or offHud then
                SendNUIMessage({action = 'hideAllHud'})
            else
                SendNUIMessage({action = 'ShowAllHud'})
            end
        end
    end)
end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function ()
    while not IsNUIReady or not PlayerData do
        Citizen.Wait(5000)
    end
    SendNUIMessage({ action = 'ShowAllHud' })
    SendNUIMessage({ action = 'HideElement' }) 
    SendNUIMessage({ action = 'resetPosition' }) 
    SendNUIMessage({ action = 'ResetColor' }) 
    SendNUIMessage({action = 'speed1'})
    TriggerThread()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        while not IsNUIReady or not PlayerData do
            Citizen.Wait(5000)
        end
        SendNUIMessage({ action = 'setColors' })
        SendNUIMessage({ action = 'setPosition' })
        SendNUIMessage({ action = 'ShowAllHud' })
        SendNUIMessage({ action = 'HideElement' }) 
        SendNUIMessage({ action = 'resetPosition' })
        SendNUIMessage({ action = 'ResetColor' })
        SendNUIMessage({action = 'speed1'})
        TriggerThread()
    end
end)

Citizen.CreateThread(function() 
    while not IsNUIReady or not PlayerData do
        Citizen.Wait(5000)
    end
    if Config.Microphone == false then 
        SendNUIMessage({action = 'microphoneHide'})
    end
    if Config.USEJob == false then 
        SendNUIMessage({action = 'jobHide'})
    end
    if Config.USEScorePlayer == false then 
        SendNUIMessage({action = 'pedONLINEHide'})
    end
    if Config.USEPlayerID == false then 
        SendNUIMessage({action = 'pedIDHide'})
    end
    if Config.USELogo == false then 
        SendNUIMessage({action = 'logoHide'})
    end
    if Config.USELogoTEXT == false then 
        SendNUIMessage({action = 'logoTextHide'})
    end
    if Config.USEAmmoHUD == false then 
        SendNUIMessage({action = 'hideAmmo'})
    end
    if Config.USEKeybindHUD == false then 
        SendNUIMessage({action = 'Hidekeybindsall'})
    end
    if Config.USESafeZone == false then 
        SendNUIMessage({action = 'zonehide'})
    end
    if Config.USEMoneyCash == false then 
        SendNUIMessage({action = 'hidecash'})
    end
    if Config.USEMoneyBank == false then 
        SendNUIMessage({action = 'hidebank'})
    end
    if Config.USEMoneyDuty == false then 
        SendNUIMessage({action = 'hideduty'})
    end
    if Config.USEClock == false then 
        SendNUIMessage({action = 'hideclock'})
    end
end)

--[[RegisterCommand(Config.Openpanel,function ()
    SetNuiFocus(true, true) 
    SendNUIMessage({
        action = 'menuShow'
    })
end)]]

RegisterNUICallback("exit" , function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'menuHide'
    })
end)

AddEventHandler("toggleHUD", function(toggle)
    offHud = toggle
    TriggerEvent("weaponind", toggle)
end)