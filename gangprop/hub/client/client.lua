---@diagnostic disable: undefined-field, undefined-global
ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do 
        Citizen.Wait(100)
    end
    PlayerData = ESX.GetPlayerData()
end)

local ShowPhub = false
local JobData = {}
local AllData = {
    ["police"] = {},
    ["sheriff"] = {},
    ["forces"] = {},
}
local Jobs = {
    ["police"]  = true,
    ["sheriff"] = true,
    ["forces"]  = true,
    ["offpolice"]  = true,
    ["offsheriff"] = true,
    ["offforces"]  = true,
}

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if Jobs[PlayerData.job.name] then
        TriggerServerEvent("esx_policehub:JobChanged", PlayerData.job.name)
    else
        SendNUIMessage({
            action = "Hide"
        })
    end
    PlayerData.job = job
end)

RegisterNetEvent('esx_policehub:firstData', function(args)
    if Jobs[PlayerData.job.name] then
        AllData = args
        JobData = AllData[PlayerData.job.name]
        SendNUIMessage({
            action = "Refresh",
            Data = JobData,
            Officers = GetTableSize(JobData)
        })
    end
end)

RegisterNetEvent('esx_policehub:updateData', function(job, hex, data)
    local job = job
    local hex = hex
    local data = data
    while not PlayerData.job do Citizen.Wait(100) end
    if Jobs[PlayerData.job.name] then
        AllData[job][hex] = data
        JobData = AllData[PlayerData.job.name]
        SendNUIMessage({
            action = "Refresh",
            Data = JobData,
            Officers = GetTableSize(JobData)
        })
    end
end)

RegisterNetEvent('esx_policehub:removeData', function(job, hex)
    local job = job
    local hex = hex
    while not PlayerData.job do Citizen.Wait(100) end
    if Jobs[PlayerData.job.name] then
        AllData[job][hex] = nil
        JobData = AllData[PlayerData.job.name]
        SendNUIMessage({
            action = "Refresh",
            Data = JobData,
            Officers = GetTableSize(JobData)
        })
    end
end)

function GetTableSize(Data)
    local Counter = 0
    for k, v in pairs(Data) do
        Counter = Counter + 1
    end
    return Counter
end

RegisterCommand('phub', function()
    if Jobs[PlayerData.job.name] then
        if not ShowPhub then
            ShowPhub = true
            SendNUIMessage({
                action = 'open'
            })
        else
            ShowPhub = false
            SendNUIMessage({
                action = "Hide"
            })
        end
    end
end, false)

exports("isOpen", function()
    return ShowPhub
end)

RegisterCommand('ToggleFocs', function()
    if Jobs[PlayerData.job.name] and ShowPhub then
        SetNuiFocus(true, true)
    end
end, false)

RegisterKeyMapping('ToggleFocs', 'Toggle Policb Foucs', 'keyboard', "F11")

RegisterNUICallback('hide', function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('Duty', function()
    TriggerServerEvent("esx_policehub:SetDutyStatus")
end)

RegisterNUICallback("CallSign", function()
    local input = lib.inputDialog('Change Call Sign', {
        { type = 'input', label = 'New Call Sign', placeholder = 'P-1', required = true },
    })
    TriggerServerEvent("PoliceHub:Server:CallSignNew", input[1])
end)

local perm = {
    ["police"] = 10,
    ["sheriff"]= 8,
    ["forces"] = 8
}

RegisterNUICallback("Commander", function(data, Cb)
    if PlayerData.job.grade >= perm[PlayerData.job.name] then
        TriggerServerEvent("PoliceHub:Commander:Add")
    else
        ESX.Alert("Shoma Be In Mored Dastresi Nadarid", "info")
    end
end)

RegisterNUICallback("Dispatch", function(data, Cb)
    TriggerServerEvent("PoliceHub:Disptach:Add")
end)

RegisterNUICallback('Break', function()
    local InputNumber = lib.inputDialog('Break Time', {
        { type = 'number', label = 'Time', placeholder = '1', required = true, min = 1, max = 30 },
    })

    TriggerServerEvent("PoliceHub:Break:Add", tonumber(InputNumber[1]))
end)