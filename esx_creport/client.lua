---@diagnostic disable: undefined-field, missing-parameter
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local Spam = false
local MenuOpen = false
local URL = nil

RegisterCommand("creport", function()
    if MenuOpen then return end
    if Spam then return end
    Spam = true
    Citizen.SetTimeout(2000, function()
        Spam = false
    end)
    ESX.TriggerServerCallback("esx_creport:GetDataIfExist", function(reported, data) 
        if reported and reported >= 3 then 
            ESX.Alert("Shoma Har Restart Faghat 3 Nafar Ra Mitavanid Report Konid", "info")
        else
            OpenNui(data)
        end
    end)
end)

AddEventHandler("esx_creport:OpenUI", function()
    ExecuteCommand("creport")
end)

RegisterNuiCallback("exit", function(data, cb)
    CloseNui()
end)

RegisterNuiCallback("registerReport", function(data, cb)
    local data = data
    if Spam then return end
    Spam = true
    Citizen.SetTimeout(2000, function()
        Spam = false
    end)
    if tonumber(data.ID) and tonumber(data.ID) >= 1 and tonumber(data.ID) <= 2000 and string.len(data.Res) <= 65 and #data.ref >= 1 then
        if tonumber(data.ID) == GetPlayerServerId(PlayerId()) then return ESX.Alert("Shoma Nemitavanid ID Khod Ra Report Konid", "error") end
        ESX.TriggerServerCallback('esx_creport:SubmitData', function(success, msg)
            if success then
                CloseNui() 
                ESX.Alert("Report Shoma Sabt Shod", "check")
                exports['screenshot-basic']:requestScreenshotUpload(URL, 'files[]', {encoding='webp',quality=0.5}, function(data)
                end)
            else
                ESX.Alert(msg, "info")
            end
        end, data)
    else
        ESX.Alert("Shoma ID Ya Tozihat Ra Dorost Vared Nakardid", "error")
    end
end)

function CloseNui()
    MenuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ 
        toggle = false
    }) 
    ESX.UI.Menu.CloseAll()
end

function OpenNui(info)
    MenuOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ 
        toggle = true,
        data = info,
    }) 
end

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
    TriggerServerEvent("esx_creport:PlayerRevive")
end)

AddEventHandler("esx:onPlayerDeath", function(data)
    TriggerServerEvent("esx_creport:PlayerIsDead", data)
end)

RegisterNetEvent("esx_creport:sendUploadURL")
AddEventHandler("esx_creport:sendUploadURL", function(url)
    URL = url
end)