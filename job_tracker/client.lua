---@diagnostic disable: missing-parameter, lowercase-global
local ESX = nil
local PlayerData = {}
local onDuty = false
local inVeh = false
local lastSirenState = false
local longBlips = {}
local nearBlips = {}
local myBlip = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
    while ESX.GetPlayerData().job == nil do
        Wait(100)
    end
	PlayerData = ESX.GetPlayerData()
    if Config.blipGroup.renameGroup then
        AddTextEntryByHash(`BLIP_OTHPLYR`, Config.blipGroup.groupName..'~w~')
    end
    checkJob()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
    checkJob()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    if onDuty then
        goOffDuty()
    end
    checkJob()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if Config.bigmapTags then
        DisplayPlayerNameTagsOnBlips(false)
    end
    removeAllBlips()
end)

if Config.useBaseEvents then
    AddEventHandler("esx_jobtracker:enteredVehicle", function(veh, seat, vehiclelabel)
        inVeh = true
        if onDuty then
            inVehChecks(veh, seat, vehiclelabel)
            local cfg = Config.emergencyJobs[PlayerData.job.name].vehBlip and Config.emergencyJobs[PlayerData.job.name].vehBlip[GetEntityModel(veh)] or nil
            TriggerServerEvent('esx_jobtracker:enteredVeh', cfg)
        end
    end)

    AddEventHandler("esx_jobtracker:leftVehicle", function(veh, seat, vehiclelabel)
        inVeh = false
        if lastSirenState then
            lastSirenState = false
            Citizen.Wait(1000)
            TriggerServerEvent('esx_jobtracker:toggleSiren', false)
        end
        if onDuty then
            TriggerServerEvent('esx_jobtracker:leftVeh')
        end
    end)
else
    Citizen.CreateThread(function()
        while true do
            if onDuty then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= 0 and not inVeh then
                    inVeh = true
                    inVehChecks(veh)
                    local cfg = Config.emergencyJobs[PlayerData.job.name].vehBlip and Config.emergencyJobs[PlayerData.job.name].vehBlip[GetEntityModel(veh)] or nil
                    TriggerServerEvent('esx_jobtracker:enteredVeh', cfg)
                elseif veh == 0 and inVeh then
                    inVeh = false
                    if lastSirenState then
                        lastSirenState = false
                        Citizen.Wait(1000)
                        TriggerServerEvent('esx_jobtracker:toggleSiren', false)
                    end
                    if onDuty then
                        TriggerServerEvent('esx_jobtracker:leftVeh')
                    end
                end
                Citizen.Wait(750)
            else
                Citizen.Wait(1000)
            end
        end
    end)
end

function inVehChecks(veh, seat, vehiclelabel)
    Citizen.CreateThread(function()
        while inVeh do
            if IsVehicleSirenOn(veh) and not lastSirenState then
                lastSirenState = true
                Citizen.Wait(1000)
                TriggerServerEvent('esx_jobtracker:toggleSiren', true)
            elseif not IsVehicleSirenOn(veh) and lastSirenState then
                lastSirenState = false
                Citizen.Wait(1000)
                TriggerServerEvent('esx_jobtracker:toggleSiren', false)
            end
            Citizen.Wait(500)
        end
    end)
end

function checkJob()
    if PlayerData and PlayerData.job and Config.emergencyJobs[PlayerData.job.name] and Config.emergencyJobs[PlayerData.job.name].ignoreDuty then
        goOnDuty()
    end
end

function goOnDuty()
    onDuty = true
    TriggerServerEvent('esx_jobtracker:setDuty', true)
    if Config.notifications.enable and Config.notifications.useMythic then
    elseif Config.notifications.enable then
        ESX.Alert(Config.notifications.onDutyText)
    end
    if Config.bigmapTags then
        SetBigmapActive(false, false)
        DisplayPlayerNameTagsOnBlips(true)
    end
    if inVeh then
        TriggerServerEvent('esx_jobtracker:enteredVeh', Config.emergencyJobs[PlayerData.job.name].vehBlip[GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))])
    end
end

AddEventHandler('esx_jobtracker:goOnDuty', goOnDuty)

function goOffDuty()
    onDuty = false
    TriggerServerEvent('esx_jobtracker:setDuty', false)

    if Config.notifications.enable and Config.notifications.useMythic then
    elseif Config.notifications.enable then
        ESX.Alert(Config.notifications.offDutyText)
    end

    if Config.bigmapTags then
        DisplayPlayerNameTagsOnBlips(false)
    end
    removeAllBlips()
end

AddEventHandler('esx_jobtracker:goOffDuty', goOffDuty)
AddEventHandler('esx_jobtracker:toggleDuty', function(bool)
    if bool then
        goOnDuty()
    else
        goOffDuty()
    end
end)

function removeAllBlips()
    restoreBlip(myBlip.blip or GetMainPlayerBlipId())
    for k, v in pairs(nearBlips) do
        RemoveBlip(v.blip)
    end
    for k, v in pairs(longBlips) do
        RemoveBlip(v.blip)
    end
    nearBlips = {}
    longBlips = {}
    myBlip = {}
end

RegisterNetEvent('esx_jobtracker:removeUser')
AddEventHandler('esx_jobtracker:removeUser', function(plyId)
    if nearBlips[plyId] then
        RemoveBlip(nearBlips[plyId].blip)
        nearBlips[plyId] = nil
    end
    if longBlips[plyId] then
        RemoveBlip(longBlips[plyId].blip)
        longBlips[plyId] = nil
    end
end)

--[[RegisterCommand("showgps", function()
    if showgps then return end
    showgps = true
    TriggerEvent("gangGPS:online")
    for k, v in pairs(nearBlips) do
        SetBlipAlpha(v.blip, 255)
    end
    for k, v in pairs(longBlips) do
        SetBlipAlpha(v.blip, 255)
    end
    Citizen.SetTimeout(30000, function()
        showgps = false
        for k, v in pairs(nearBlips) do
            SetBlipAlpha(v.blip, 0)
        end
        for k, v in pairs(longBlips) do
            SetBlipAlpha(v.blip, 0)
        end
    end)
end)]]

RegisterNetEvent('esx_jobtracker:receiveData')
AddEventHandler('esx_jobtracker:receiveData', function(myId, data) 
    for k, v in pairs(data) do
        local cId = GetPlayerFromServerId(v.playerId)
        local canSee = Config.emergencyJobs[v.job].canSee and Config.emergencyJobs[v.job].canSee[PlayerData.job.name]
        if canSee then
            if myId ~= v.playerId then
                if cId ~= -1 then
                    if nearBlips[v.playerId] == nil then  
                        if longBlips[v.playerId] then
                            RemoveBlip(longBlips[v.playerId].blip)
                            longBlips[v.playerId] = nil
                        end
                        nearBlips[v.playerId] = {}
                        nearBlips[v.playerId].blip = AddBlipForEntity(GetPlayerPed(cId))
                        setupBlip(nearBlips[v.playerId].blip, v)
                    end
                    if v.inVeh and not nearBlips[v.playerId].inVeh then 
                        nearBlips[v.playerId].inVeh = true
                        vehBlipSetup(nearBlips[v.playerId].blip, v)
                    elseif not v.inVeh and nearBlips[v.playerId].inVeh then 
                        nearBlips[v.playerId].inVeh = false
                        vehBlipSetup(nearBlips[v.playerId].blip, v)
                    end
                    if v.siren and not nearBlips[v.playerId].siren then  
                        nearBlips[v.playerId].siren = true
                        nearBlips[v.playerId].sirenState = 1
                    elseif not v.siren and nearBlips[v.playerId].siren then  
                        nearBlips[v.playerId].siren = false
                        if v.inVeh then
                            vehBlipSetup(nearBlips[v.playerId].blip, v)
                        else
                            setupBlip(nearBlips[v.playerId].blip, v)
                        end
                    elseif nearBlips[v.playerId].siren then  
                        nearBlips[v.playerId].sirenState = v.flashColors[nearBlips[v.playerId].sirenState + 1] and nearBlips[v.playerId].sirenState + 1 or 1
                        updateBlipFlash(nearBlips[v.playerId].blip, v.flashColors[nearBlips[v.playerId].sirenState])
                    end
                else
                    if longBlips[v.playerId] == nil then 
                        if nearBlips[v.playerId] then
                            RemoveBlip(nearBlips[v.playerId].blip)
                            nearBlips[v.playerId] = nil
                        end
                        longBlips[v.playerId] = {}
                        longBlips[v.playerId].blip = AddBlipForCoord(v.coords)
                        setupBlip(longBlips[v.playerId].blip, v)
                        if v.inVeh then
                            vehBlipSetup(longBlips[v.playerId].blip, v)
                        end
                    else
                        if longBlips[v.playerId] then
                            RemoveBlip(longBlips[v.playerId].blip)
                        end
                        longBlips[v.playerId].blip = AddBlipForCoord(v.coords)
                        setupBlip(longBlips[v.playerId].blip, v)
                        if v.inVeh then
                            vehBlipSetup(longBlips[v.playerId].blip, v)
                        end
                    end
                    if v.inVeh and not longBlips[v.playerId].inVeh then 
                        longBlips[v.playerId].inVeh = true
                        vehBlipSetup(longBlips[v.playerId].blip, v)
                    elseif not v.inVeh and longBlips[v.playerId].inVeh then 
                        longBlips[v.playerId].inVeh = false
                        vehBlipSetup(longBlips[v.playerId].blip, v)
                    end
                    if v.siren and not longBlips[v.playerId].siren then 
                        longBlips[v.playerId].siren = true
                        longBlips[v.playerId].sirenState = 1
                    elseif not v.siren and longBlips[v.playerId].siren then  
                        longBlips[v.playerId].siren = false
                        if v.inVeh then
                            vehBlipSetup(longBlips[v.playerId].blip, v)
                        else
                            setupBlip(longBlips[v.playerId].blip, v)
                        end
                    elseif longBlips[v.playerId].siren then 
                        longBlips[v.playerId].sirenState = v.flashColors[longBlips[v.playerId].sirenState + 1] and longBlips[v.playerId].sirenState + 1 or 1
                        updateBlipFlash(longBlips[v.playerId].blip, v.flashColors[longBlips[v.playerId].sirenState])
                    end
                end
            elseif Config.selfBlip then
                if myBlip.blip == nil then 
                    myBlip.blip = GetMainPlayerBlipId()
                    while myBlip.blip == nil do
                        Citizen.Wait(100)
                    end
                    setupBlip(myBlip.blip, v)
                end
                if v.inVeh and not myBlip.inVeh then 
                    myBlip.inVeh = true
                    vehBlipSetup(myBlip.blip, v)
                elseif not v.inVeh and myBlip.inVeh then
                    myBlip.inVeh = false
                    vehBlipSetup(myBlip.blip, v)
                end
                if v.siren and not myBlip.siren then  
                    myBlip.siren = true
                    myBlip.sirenState = 1
                elseif not v.siren and myBlip.siren then 
                    myBlip.siren = false
                    if v.inVeh then
                        vehBlipSetup(myBlip.blip, v)
                    else
                        setupBlip(myBlip.blip, v)
                    end
                elseif myBlip.siren then 
                    myBlip.sirenState = v.flashColors[myBlip.sirenState + 1] ~= nil and myBlip.sirenState + 1 or 1
                    updateBlipFlash(myBlip.blip, v.flashColors[myBlip.sirenState])
                end
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(Config.usePrefix and v.prefix..' '..v.name or v.name)
                EndTextCommandSetBlipName(myBlip.blip)
            end
        end
    end
end)

function setupBlip(blip, data)
	SetBlipSprite(blip, 1)
	SetBlipDisplay(blip, 2)
	SetBlipScale(blip, Config.emergencyJobs[data.job].blip.scale or 0.9)
	SetBlipColour(blip, Config.emergencyJobs[data.job].blip.color)
    SetBlipFlashes(blip, false)
    ShowHeightOnBlip(blip, false)
    SetBlipShowCone(blip, Config.blipCone)
    SetBlipCategory(blip, 7)
    ShowHeadingIndicatorOnBlip(blip, false)
    SetBlipRotation(blip, true)
	BeginTextCommandSetBlipName("STRING")
    if Config.font.useCustom then
        AddTextComponentString("<font face='"..Config.font.name.."'>"..data.prefix.." "..data.name.."</font>")
    else
        AddTextComponentString(Config.usePrefix and data.prefix..' '..data.name or data.name)
    end
	EndTextCommandSetBlipName(blip)
end

function vehBlipSetup(blip, data)
    if data.inVeh then
        SetBlipSprite(blip, 523)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, Config.emergencyJobs[data.job].blip.scale or 0.9)
        SetBlipColour(blip, data.vehColor)
        SetBlipShowCone(blip, Config.blipCone)
        SetBlipRotation(blip, false)
        BeginTextCommandSetBlipName("STRING")
        if Config.font.useCustom then
            AddTextComponentString("<font face='"..Config.font.name.."'>"..data.prefix.." "..data.name.."</font>")
        else
            AddTextComponentString(Config.usePrefix and data.prefix..' '..data.name or data.name)
        end
        EndTextCommandSetBlipName(blip)
        SetBlipCategory(blip, 7)
        ShowHeadingIndicatorOnBlip(blip, false)
        SetBlipRotation(blip, false)
    else
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, Config.emergencyJobs[data.job].blip.scale or 0.9)
        SetBlipColour(blip, Config.emergencyJobs[data.job].blip.color)
        SetBlipShowCone(blip, Config.blipCone)
        ShowHeadingIndicatorOnBlip(blip, false)
        SetBlipRotation(blip, true)
        BeginTextCommandSetBlipName("STRING")
        if Config.font.useCustom then
            AddTextComponentString("<font face='"..Config.font.name.."'>"..data.prefix.." "..data.name.."</font>")
        else
            AddTextComponentString(Config.usePrefix and data.prefix..' '..data.name or data.name)
        end
        EndTextCommandSetBlipName(blip)
        SetBlipCategory(blip, 7)
    end
end

function updateBlipFlash(blip, color)
    SetBlipColour(blip, color)
end

function restoreBlip(blip) 
    SetBlipSprite(blip, 6)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipRotation(blip, false)
    ShowHeadingIndicatorOnBlip(blip, false)
    SetBlipColour(blip, 0)
    SetBlipShowCone(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(GetPlayerName(PlayerId()))
    EndTextCommandSetBlipName(blip)
    SetBlipCategory(blip, 1)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10 * 60 * 1000)
        removeAllBlips()
    end
end)