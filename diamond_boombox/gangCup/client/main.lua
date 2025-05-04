---@diagnostic disable: missing-parameter, undefined-field
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local isReady = false


RegisterNUICallback('ready', function(data, cb)
    isReady = true
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

function Display(status)
    if not isReady then return end
    if status then
        ESX.TriggerServerCallback('gang_cup:server:getData', function(leaderboardData, currentGang, cupType)
            SetNuiFocus(true, true)
            SendNUIMessage({
                type = 'openLeaderboard',
                data = leaderboardData,
                currentGang = currentGang,
                cupType = cupType
            })
        end)
    else
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = 'closeLeaderboard'
        })
    end
end

RegisterCommand('leaderboard', function()
    Display(true)
end)