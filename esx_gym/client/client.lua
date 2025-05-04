---@diagnostic disable: missing-parameter, lowercase-global, cast-local-type, undefined-field, undefined-global
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local disabledNotifySkillInfo = false

local myProp = nil
local myProp2 = nil

myStatistics = nil
local myStamina = nil


conditionBooster = 1.0
strengthBooster = 1.0

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    while not ESX do
        Citizen.Wait(200)
    end
    if ESX.IsPlayerLoaded() then
        PlayerData = ESX.GetPlayerData()
        TriggerServerEvent('esx_gym:sv:restartPlayer')
    end
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

function requestProp(prop)
    RequestModel(prop)
    while not HasModelLoaded(prop) do
        Citizen.Wait(100)
        RequestModel(prop)
    end
end

addSkill = function(name, value)
    TriggerServerEvent('esx_gym:sv:addValue', name, value)
end

exports('addSkill', addSkill)

getSkill = function(name)
    return myStatistics[name]
end

exports('getSkill', getSkill)

removeSkill = function(name, value)
    TriggerServerEvent('esx_gym:sv:removeValue', name, value)
end

exports('removeSkill', removeSkill)

openStatisticsMenu = function()
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'openMenu', stats = myStatistics})
end

RegisterNUICallback('action', function(data, cb)
    if data.action == "load" then
        SendNUIMessage({action = 'load', statisticsmenu = Config.StatisticsMenu})
    elseif data.action == "closeMenu" then
        SetNuiFocus(false, false)
        SendNUIMessage({action = 'closeMenu'})
    elseif data.action == "notifyStatus" then
        disabledNotifySkillInfo = tonumber(data.status)
    end
end)

RegisterNetEvent('esx_gym:cl:setTaken', function(gymId, pointId, boolean)
    Config.Gyms[gymId].points[pointId].taken = boolean
end)

RegisterNetEvent('esx_gym:cl:updateStatistic', function(statistics)
    myStatistics = statistics
    SendNUIMessage({action = 'updateMenu', stats = myStatistics})
end)

RegisterNetEvent('esx_gym:notification', function(message, isSkillInfo)
    if isSkillInfo and (disabledNotifySkillInfo == 1) then
        return
    end
    ESX.ShowNotification(message)
end)

RegisterCommand("gym", function()
    openStatisticsMenu()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.RefreshTimeAddStats)
        local myPed = PlayerPedId()
        local myVehicle = GetVehiclePedIsUsing(myPed)
        removeCondition = true
        if IsPedSwimmingUnderWater(myPed) and Config.StatisticsMenu['condition'] then
            addSkill("condition", type(Config.AddStatsValues['Swimming']) == "number" and (Config.AddStatsValues['Swimming']/10.0)*conditionBooster or (math.random(Config.AddStatsValues['Swimming'][1], Config.AddStatsValues['Swimming'][2])/10.0)*conditionBooster)
            removeCondition = false
        elseif DoesEntityExist(myVehicle) then
            local isDriver = GetPedInVehicleSeat(myVehicle, -1) == PlayerPedId()
            if isDriver then
                local speed = GetEntitySpeed(myVehicle) * 3.6
                local vehicleClass = GetVehicleClass(myVehicle)
                if vehicleClass == 13 and speed >= Config.AddStatsValues['Cycling'].minimumSpeed and Config.StatisticsMenu['condition'] then
                    addSkill("condition", type(Config.AddStatsValues['Cycling'].value) == "number" and (Config.AddStatsValues['Cycling'].value/10.0)*conditionBooster or (math.random(Config.AddStatsValues['Cycling'].value[1], Config.AddStatsValues['Cycling'].value[2])/10.0)*conditionBooster)
                    removeCondition = false
                end
            end
        end
        if myStatistics then
            if myStatistics['condition'] then
                if myStatistics['condition'] >= 70.0 then
                    if Config.EnableRunSpeedModifier then
                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.09)
                    end
                    if Config.EnableStaminaModifier then
                        StatSetInt(GetHashKey('MP0_STAMINA'), 15, true)
                    end
                elseif myStatistics['condition'] >= 50.0 then
                    if Config.EnableRunSpeedModifier then
                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.07)
                    end
                    if Config.EnableStaminaModifier then
                        StatSetInt(GetHashKey('MP0_STAMINA'), 10, true)
                    end
                elseif myStatistics['condition'] >= 20.0 then
                    if Config.EnableRunSpeedModifier then
                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.05)
                    end
                    if Config.EnableStaminaModifier then
                        StatSetInt(GetHashKey('MP0_STAMINA'), 5, true)
                    end
                else
                    if Config.EnableRunSpeedModifier then
                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                    end
                    if Config.EnableStaminaModifier then
                        StatSetInt(GetHashKey('MP0_STAMINA'), 0, true)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.RefreshTimeRemoveStats)
        if removeCondition and Config.StatisticsMenu['condition'] then
            removeSkill("condition", type(Config.RemoveStatsValues['RemoveCondition']) == "number" and Config.RemoveStatsValues['RemoveCondition']/10.0 or math.random(Config.RemoveStatsValues['RemoveCondition'][1], Config.RemoveStatsValues['RemoveCondition'][2])/10.0)
        end
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Activities) do
        local models = {}
        table.insert(models, k)
        exports['diamond_target']:AddTargetModel(models, {
            options = {
                {
                    icon = v.icon,
                    label = v.label,
                    action = function(entity)
                        startAction({entity = entity, label = v.label}, v)
                    end,
                }
            }
        })
    end
end)

local isWorking = false
local lastTrainingTime = 0
local trainingCooldown = 2000 -- 2 seconds cooldown

function startAction(data, data2)
    if GetGameTimer() - lastTrainingTime < trainingCooldown then
        return ESX.ShowNotification(Config.Translate[Config.Language]['training_cooldown'])
    end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local targetCoords = GetEntityCoords(data.entity)
    local distance = #(playerCoords - targetCoords)
    
    if distance > 3.0 then
        return ESX.ShowNotification(Config.Translate[Config.Language]['too_far'])
    end

    local Ecoords = GetEntityCoords(data.entity)
    ESX.TriggerServerCallback('esx_gym:sv:getTaken', function(takenCheck)
        if takenCheck then
            return ESX.ShowNotification(Config.Translate[Config.Language]['place_taken'])
        end
        if data2.needTogo then
            local heading = GetEntityHeading(data.entity)
            local modelHash = GetEntityModel(data.entity)
            local offsetX, offsetY = 0.0, 0.0
            local dd = 0.5
            if modelHash == GetHashKey('apa_p_apdlc_treadmill_s') then
                heading = heading - 180.0
                offsetX = math.sin(math.rad(heading)) * 0.1
                offsetY = math.cos(math.rad(heading)) * 0.1
                dd = 0.1
            elseif modelHash == GetHashKey('prop_muscle_bench_05') then
                heading = heading
                if ESX.Math.Round(heading) == 35 then
                    -- local cc = GetEntityCoords(PlayerPedId())
                    -- local pp = GetOffsetFromEntityGivenWorldCoords(data.entity, cc.x, cc.y, cc.z)
                    -- print(json.encode(pp))
                    offsetX = -0.2
                    offsetY = 0.35
                else
                    offsetX = 0.28
                    offsetY = -0.37
                end
                dd = 0.8
                Ecoords = vector3(
                    Ecoords.x,
                    Ecoords.y, 
                    Ecoords.z - 1.1
                )
                needsync = true
            elseif modelHash == GetHashKey('prop_muscle_bench_03') then
                heading = heading + 180.0
                if ESX.Math.Round(heading) == 215 then
                    offsetX = 0.4
                    offsetY = -0.5
                    Ecoords = vector3(
                        Ecoords.x,
                        Ecoords.y, 
                        Ecoords.z - 1.25
                    )
                elseif ESX.Math.Round(heading) == 485 then
                    offsetX = -0.35
                    offsetY = -0.2
                    Ecoords = vector3(
                        Ecoords.x,
                        Ecoords.y, 
                        Ecoords.z - 1.25
                    )
                elseif ESX.Math.Round(heading) == 305 then
                    offsetX = 0.5
                    offsetY = 0.4
                    Ecoords = vector3(
                        Ecoords.x,
                        Ecoords.y, 
                        Ecoords.z - 1.25
                    )
                end
                dd = 0.5
                needsync = true
            elseif modelHash == GetHashKey('prop_muscle_bench_01') then
                if ESX.Math.Round(heading) == 125 then
                    offsetX = 0.3
                    offsetY = 0.3
                else
                    offsetX = -0.20
                    offsetY = 0.20
                end
                Ecoords = vector3(
                    Ecoords.x,
                    Ecoords.y, 
                    Ecoords.z + 0.3
                )
                needsync = true
                dd = 0.1
            elseif modelHash == GetHashKey('prop_yoga_mat_01') or 
                modelHash == GetHashKey('prop_yoga_mat_02') or 
                modelHash == GetHashKey('prop_yoga_mat_03') or 
                modelHash == GetHashKey('p_yoga_mat_01_s') or 
                modelHash == GetHashKey('p_yoga_mat_02_s') or 
                modelHash == GetHashKey('p_yoga_mat_03_s') then
                heading = heading + 95.0
                dd = 0.1
            end
            
            heading = heading % 360
            
            local targetX = Ecoords.x + offsetX
            local targetY = Ecoords.y + offsetY
            TaskGoStraightToCoord(PlayerPedId(), targetX, targetY, Ecoords.z, 1.0, -1, heading, 1)
            
            while true do
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance2D = #(vector2(playerCoords.x, playerCoords.y) - vector2(targetX, targetY))
                if distance2D <= dd then
                    break
                end
                if IsControlJustPressed(0, Config.Keys['stop']) then
                    break
                end
                Citizen.Wait(1)
            end
            
            SetEntityHeading(PlayerPedId(), heading)

            if needsync then
                SetEntityCoords(PlayerPedId(), targetX, targetY, Ecoords.z, false)
            end
        end

        FreezeEntityPosition(PlayerPedId(), true)
        SetEntityCollision(PlayerPedId(), false, false)
        for k, v in pairs(Config.Animations[data2.animName]) do
            loadAnimDict(v[1])
        end

        isWorking = true
        TriggerServerEvent('esx_gym:sv:setTaken', data.entity, data.label, true)
        ESX.disableKey("x", true)
        SendNUIMessage({action = 'openHelpKeys'})
        if Config.Animations[data2.animName].enter then
            TaskPlayAnim(PlayerPedId(), Config.Animations[data2.animName].enter[1], Config.Animations[data2.animName].enter[2], 8.0, -8.0, Config.Animations[data2.animName].enter[3], 0, 0.0, 0, 0, 0)
            Citizen.Wait(Config.Animations[data2.animName].enter[3])
        end
        Citizen.CreateThread(function()
            TaskPlayAnim(PlayerPedId(), Config.Animations[data2.animName].idle[1], Config.Animations[data2.animName].idle[2], 8.0, -8.0, Config.Animations[data2.animName].idle[3], 1, 0.0, 0, 0, 0)
            if data2.prop then
                requestProp(GetHashKey(data2.prop.name))
                local myCoords = GetEntityCoords(PlayerPedId())
                myProp = CreateObject(GetHashKey(data2.prop.name), myCoords, true, true, true)
                AttachEntityToEntity(myProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), data2.prop.attachBone), data2.prop.placement[1] + 0.0, data2.prop.placement[2] + 0.0, data2.prop.placement[3] + 0.0, data2.prop.placement[4] + 0.0, data2.prop.placement[5] + 0.0, data2.prop.placement[6] + 0.0, true, true, false, false, 1, true)
                SetModelAsNoLongerNeeded(myProp)
            end
            if data2.prop2 then
                requestProp(GetHashKey(data2.prop2.name))
                local myCoords = GetEntityCoords(PlayerPedId())
                myProp2 = CreateObject(GetHashKey(data2.prop2.name), myCoords, true, true, true)
                AttachEntityToEntity(myProp2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), data2.prop2.attachBone), data2.prop2.placement[1] + 0.0, data2.prop2.placement[2] + 0.0, data2.prop2.placement[3] + 0.0, data2.prop2.placement[4] + 0.0, data2.prop2.placement[5] + 0.0, data2.prop2.placement[6] + 0.0, true, true, false, false, 1, true)
                SetModelAsNoLongerNeeded(myProp2)
            end
            local sessionStartTime = GetGameTimer()
            local maxSessionDuration = 300000 -- 5 minutes
            local totalGains = 0.0
            local maxGainsPerSession = 20.0

            while isWorking do
                if GetGameTimer() - sessionStartTime > maxSessionDuration then
                    ESX.ShowNotification(Config.Translate[Config.Language]['session_timeout'])
                    stopAction(data.entity, data.label, Config.Animations[data2.animName])
                    break
                end

                if IsControlJustPressed(0, Config.Keys['train']) then
                    if GetGameTimer() - lastTrainingTime < trainingCooldown then
                        ESX.ShowNotification(Config.Translate[Config.Language]['training_cooldown'])
                        Citizen.Wait(1000)
                    else
                        lastTrainingTime = GetGameTimer()
                        myStamina = GetPlayerStamina(PlayerId())
                        local crashedSkillbar = false
                        if myStamina > (getSkill('condition') >= 10.0 and ((data2.removeStamina * 100) / getSkill('condition')) or getSkill('condition') < 10.0 and ((data2.removeStamina*10.0))) then
                            if not crashedSkillbar then
                                TaskPlayAnim(PlayerPedId(), Config.Animations[data2.animName].training[1], Config.Animations[data2.animName].training[2], 8.0, -8.0, Config.Animations[data2.animName].training[3], 0, 0.0, 0, 0, 0)
                                Citizen.Wait(Config.Animations[data2.animName].training[3])
                                TaskPlayAnim(PlayerPedId(), Config.Animations[data2.animName].idle[1], Config.Animations[data2.animName].idle[2], 8.0, -8.0, Config.Animations[data2.animName].idle[3], 1, 0.0, 0, 0, 0)
                                SetPlayerStamina(PlayerId(), myStamina - (getSkill('condition') >= 10.0 and ((data2.removeStamina * 100) / getSkill('condition')) or getSkill('condition') < 10.0 and ((data2.removeStamina*10.0))))
                                if data2.addSkill and data2.addSkill.skill and data2.addSkill.value then
                                    local gain = (type(data2.addSkill.value) == 'number' and (data2.addSkill.value/10) or (math.random(data2.addSkill.value[1], data2.addSkill.value[2])/10))*strengthBooster
                                    if totalGains + gain > maxGainsPerSession then
                                        ESX.ShowNotification(Config.Translate[Config.Language]['max_session_gains'])
                                        stopAction(data.entity, data.label, Config.Animations[data2.animName])
                                        break
                                    end
                                    totalGains = totalGains + gain
                                    addSkill("strenght", gain)
                                    if modelHash == GetHashKey('apa_p_apdlc_treadmill_s') then
                                        addSkill("condition", type(Config.AddStatsValues['Running']) == "number" and (Config.AddStatsValues['Running']/10.0)*conditionBooster or (math.random(Config.AddStatsValues['Running'][1], Config.AddStatsValues['Running'][2])/10.0)*conditionBooster)
                                    end
                                end
                            end
                        else
                            ESX.ShowNotification(Config.Translate[Config.Language]['out_of_breath'])
                            Citizen.Wait(1000)
                        end
                    end
                end
                if IsControlJustPressed(0, Config.Keys['stop']) then
                    stopAction(data.entity, data.label, Config.Animations[data2.animName])
                end
                Citizen.Wait(1)
            end
        end)
    end, data.entity, data.label)
end

function stopAction(entity, label, anim)
    if anim.exit then
        TaskPlayAnim(PlayerPedId(), anim.exit[1], anim.exit[2], 8.0, -8.0, anim.exit[3], 0, 0.0, 0, 0, 0)
        Citizen.Wait(anim.exit[3])
    else
        ClearPedTasks(PlayerPedId())
    end
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityCollision(PlayerPedId(), true, true)
    TriggerServerEvent('esx_gym:sv:setTaken', entity, label, false)
    ESX.disableKey("x", false)
    SendNUIMessage({action = 'closeHelpKeys'})
    if myProp then
        DeleteObject(myProp)
    end
    if myProp2 then
        DeleteObject(myProp2)
    end
    isWorking = false
    myProp = nil
    myProp2 = nil
end

Citizen.CreateThread(function()
    local coord = vector3(-1201.09,-1568.76,4.61)
    local startblip = AddBlipForCoord(coord.x, coord.y, coord.z)
    SetBlipSprite(startblip, 311)
    SetBlipDisplay(startblip, 2)
    SetBlipScale(startblip, 0.4)
    SetBlipColour(startblip, 47)
    SetBlipAsShortRange(startblip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Gym")
    EndTextCommandSetBlipName(startblip)
end)