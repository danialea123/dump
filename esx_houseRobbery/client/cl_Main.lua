---@diagnostic disable: undefined-global, lowercase-global, param-type-mismatch, missing-parameter, missing-parameter
local currentHouse = nil
local housesData = {}
local doingAction = false
local Placing = false
local carrying = false
local CurrentProp = nil
local Lasers = {}
local AllObjects = {}
local InTheHouse = false
local propRobbed = {}
local SpawnedObject = {}
local CreatedProps = {}
local HouseHacked = {}
local HousePowdered = {}
local PedSpawned = {}
local HouseLasered = {}
local PedDead = {}
local Spheres = {}
local leaving = false
local tabletObj = nil
local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = `prop_cs_tablet`
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)
local Hacking = false
local Lockpicking = false
local NPC = nil
local hittedbylaser = false
--DEV

RegisterNetEvent("d-houserobbery:reset")
AddEventHandler("d-houserobbery:reset", function(house)
    for _, v in pairs(AllObjects) do
        SetEntityAsMissionEntity(v, false, true)
        DeleteObject(v)
        if DoesEntityExist(v) then
            TriggerServerEvent("d-houserobbery:removeobject", ObjToNet(v))
        end
    end
    for _, v in pairs(CreatedProps) do
        SetEntityAsMissionEntity(v, false, true)
        DeleteObject(v)
        if DoesEntityExist(v) then
            TriggerServerEvent("d-houserobbery:removeobject", ObjToNet(v))
        end
    end
    housesData[house] = nil
    Lasers[house] = nil
    propRobbed[house] = nil
    SpawnedObject[house] = nil
    CreatedProps[house] = nil
    HouseHacked[house] = nil
    HousePowdered[house] = nil
    PedSpawned[house] = nil
    HouseLasered[house] = nil
    PedDead[house] = nil
    Spheres[house] = nil
end)

RegisterNetEvent("d-houserobbery:powder")
AddEventHandler("d-houserobbery:powder", function()
    if currentHouse then
        local hash = `prop_paper_bag_small`
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(100)
            RequestModel(hash)
        end
        local prop = CreateObject(hash, GetEntityCoords(cache.ped), true, true, true)
        AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.18, 0.0, -0.1, -50.0, -100.0,
            -120.0, true, true, false, false, 1, true)
        lib.requestAnimDict("mp_player_int_upperwank")
        TaskPlayAnim(cache.ped, "mp_player_int_upperwank", "mp_player_int_wank_01", 3.0, 1.0, -1, 49, 0, false, false,
            false)
        RemoveAnimDict("mp_player_int_upperwank")
        local coords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 2.0, -0.2)
        local rotation = GetEntityRotation(cache.ped)
        if not HasNamedPtfxAssetLoaded("core") then
            RequestNamedPtfxAsset("core")
            while not HasNamedPtfxAssetLoaded("core") do
                Wait(0)
            end
        end
        UseParticleFxAssetNextCall("core")
        particles = StartParticleFxLoopedAtCoord("ent_dst_dust", coords.x, coords.y
        , coords.z, rotation.x + 0.0, rotation.y, rotation.z + 90.0, 2.0, false, false, false, false)
        SetTimeout(500, function()
            UseParticleFxAssetNextCall("core")
            particles2 = StartParticleFxLoopedAtCoord("ent_dst_dust", coords.x, coords.y
            , coords.z, rotation.x + 0.0, rotation.y, rotation.z + 90.0, 2.0, false, false, false, false)
        end)
        SetTimeout(1000, function()
            UseParticleFxAssetNextCall("core")
            particles3 = StartParticleFxLoopedAtCoord("ent_dst_dust", coords.x, coords.y
            , coords.z, rotation.x + 0.0, rotation.y, rotation.z + 90.0, 2.0, false, false, false, false)
        end)
        SetTimeout(1500, function()
            UseParticleFxAssetNextCall("core")
            particles4 = StartParticleFxLoopedAtCoord("ent_dst_dust", coords.x, coords.y
            , coords.z, rotation.x + 0.0, rotation.y, rotation.z + 90.0, 2.0, false, false, false, false)
        end)
        SetTimeout(2000, function()
            UseParticleFxAssetNextCall("core")
            particles5 = StartParticleFxLoopedAtCoord("ent_dst_dust", coords.x, coords.y
            , coords.z, rotation.x + 0.0, rotation.y, rotation.z + 90.0, 2.0, false, false, false, false)
        end)
        ProgressBar(2500, locale('powdering'))
        DetachEntity(prop, false, false)
        DeleteEntity(prop)
        ClearPedTasks(cache.ped)
        StopParticleFxLooped(particles, 0)
        StopParticleFxLooped(particles2, 0)
        StopParticleFxLooped(particles3, 0)
        StopParticleFxLooped(particles4, 0)
        StopParticleFxLooped(particles5, 0)
        Notify('success', locale('success'), locale('usedpowder'))
        for b, g in pairs(Lasers) do
            g.setColor(255, 0, 0, 175)
            HousePowdered[currentHouse] = true
            TriggerServerEvent('d-houserobbery:AddPowderHouse', currentHouse)
        end
    else
        Notify('success', locale('success'), locale('NeedTobeInHouse'))
    end
end)

RegisterNetEvent("d-houserobbery:sync")
AddEventHandler("d-houserobbery:sync", function(data, requestedInstance)
    housesData = data
    if requestedInstance then
        lib.callback('d-houserobbery:getident', false, function(value)
            local char = value
            for house, houseData in pairs(housesData) do
                if houseData.players then
                    for _, player in each(houseData.players) do
                        if player == char then
                            teleport(Config.HousesToRob[house].Coords.xyz)
                            TriggerServerEvent("d-houserobbery:leaveHouse", house)
                            break
                        end
                    end
                end
            end
        end)
    end
end)

if Config.HouseType == "AllHouses" or Config.HouseType == "Both" then
    if Config.InteractionType == 'textui' or Config.InteractionType == "3dtext" then
        for house, data in pairs(Config.HousesToRob) do
            lib.zones.sphere({
                coords = data.Coords.xyz,
                radius = 1,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) and not doingAction then
                        if not enterable(house) then
                            enterHouse(house, true)
                        else
                            enterHouse(house, false)
                        end
                    end

                    if Config.InteractionType == "3dtext" then
                        Draw3DText(self.coords,
                            string.format("[~g~E~w~] - %s",
                                not enterable(house) and locale('breakdoor_label') or locale("enter_label")))
                    end
                end,
                onEnter = function()
                    if Config.InteractionType == "textui" then
                        local text = locale('enter_label')
                        if not enterable(house) then
                            text = locale('breakdoor_label')
                        end
                        TextUIShow("[E] - " .. text)
                    end
                end,
                onExit = function()
                    if Config.InteractionType == "textui" then
                        TextUIHide()
                    end
                end
            })
        end
    elseif Config.InteractionType == 'target' then
        for house, data in pairs(Config.HousesToRob) do
            SetTimeout(1000, function()
                target = Target()
                target:AddCircleZone("d-houserobbery_place" .. house, data.Coords.xyz, 1.5, {
                    name = "d-houserobbery_place" .. house,
                    debugPoly = Config.Debug,
                }, {
                    options = {
                        {
                            icon = 'fas fa-house',
                            label = locale('breakdoor_label'),
                            action = function(entity)
                                enterHouse(house, true)
                            end,
                            canInteract = function(entity, distance, data)
                                return (housesData and not enterable(house))
                            end
                        },
                        {
                            icon = 'fas fa-door-open',
                            label = locale('enter_label'),
                            action = function(entity)
                                enterHouse(house, false)
                            end,
                            canInteract = function(entity, distance, data)
                                return (housesData and enterable(house))
                            end
                        }
                    },
                    distance = 2.5,
                })
            end)
        end
    end
end

function enterable(house)
    if housesData[house] == nil or housesData[house].locked == nil or housesData[house].locked then
        return false
    end
    return true
end

function enterHouse(house, locked)
    if Config.HouseType == "OnlyMission" or Config.HouseType == "Both" then
        RemoveMission()
    end
    if locked then
        if Config.NightRob.enabled then
            local h = GetClockHours()

            if Config.NightRob.time.from > Config.NightRob.time.to then
                if h < Config.NightRob.time.from and h >= Config.NightRob.time.to then
                    Notify('success', locale('success'), locale('NeedNight'))
                    return
                end
            else
                if h < Config.NightRob.time.from or h >= Config.NightRob.time.to then
                    Notify('success', locale('success'), locale('NeedNight'))
                    return
                end
            end
        end
        if Config.NeedBag.enabled then
            if GetPedDrawableVariation(cache.ped, 5) == Config.NeedBag.var then
            else
                Notify('success', locale('success'), locale('NeedBag'))
                return
            end
        end
        lib.registerContext({
            id = 'RobberyHouse',
            title = locale('header'),
            options = {
                [locale('breakdoor_label')] = {
                    arrow = false,
                    event = 'd-houserobbery:serverlockpick',
                    args = { house = house },
                    description = locale('reqitems_label'),
                }
            }
        })
        lib.showContext('RobberyHouse')
    else
        currentHouse = house
        teleport(Config.HousesToRob[house].Residence.InsidePositions.Exit.coords)
        createZones(house)

        TriggerServerEvent("d-houserobbery_instance:joinInstance", "rob_house_" .. house)
        TriggerServerEvent("d-houserobbery:joinHouse", house)
        DoorSound()
        OnHouseEnter()
    end
end

RegisterNetEvent("d-houserobbery:serverlockpick")
AddEventHandler("d-houserobbery:serverlockpick", function(data)
    TriggerServerEvent("d-houserobbery:lockpick", data.house)
end)

function searchPlace(currentPlace)
    if not carrying then
        local wasRobbed = false
        for _, place in each(housesData[currentHouse].robbed) do
            if place == currentPlace then
                wasRobbed = true
                break
            end
        end
        if not wasRobbed then
            doingAction = true
            TaskTurnPedToFaceCoord(cache.ped,
                Config.HousesToRob[currentHouse].Residence.InsidePositions[currentPlace].coords, 1000)
            TaskStartScenarioInPlace(cache.ped, "PROP_HUMAN_BUM_BIN", 0, true)
            ProgressBar(4000, locale('searching'))
            ClearPedTasks(cache.ped)
            table.insert(housesData[currentHouse].robbed, currentPlace)
            TriggerServerEvent("d-houserobbery:robbedHousePlace", currentHouse, currentPlace)
        else
            Notify('error', locale('error'), locale('emptyplace'))
        end
        doingAction = false
    end
end

function leaveHouse(house)
    for _, v in pairs(CreatedProps) do
        SetEntityAsMissionEntity(v, false, true)
        DeleteObject(v)
    end
    local attachentity
    GetEntityAttachedTo(cache.ped)

    teleport(Config.HousesToRob[house].Coords.xyz)
    TriggerServerEvent("d-houserobbery_instance:quitInstance")
    if attachentity ~= 0 then
        TriggerServerEvent('d-houserobbery_instance:addEntityToPlayerInstance', attachentity)
    end
    TriggerServerEvent("d-houserobbery:leaveHouse", house)
    Wait(1000)
    currentHouse = nil
    leaving = false
    OnHouseLeave()
end

function teleport(coords)
    DoScreenFadeOut(1000)
    Wait(1000)
    FreezeEntityPosition(cache.ped, true)
    ESX.SetEntityCoords(cache.ped, coords.xyz)
    SetEntityHeading(cache.ped, coords.w)

    while not HasCollisionLoadedAroundEntity(cache.ped) do
        RequestCollisionAtCoord(coords)
        Wait(0)
    end
    FreezeEntityPosition(cache.ped, false)
    SetTimeout(900, function()
        ClearPedTasks(cache.ped)
    end)
    Wait(500)
    Wait(500)
    ClearPedTasks(cache.ped)
    DoScreenFadeIn(1500)
end

RegisterNetEvent("d-houserobbery:SpawnPed")
AddEventHandler("d-houserobbery:SpawnPed", function(house, exist)
    CreateThread(function()
        local timecycleEnabled = false
        while true do
            local sleep = 1500
            if Config.TimeChange then
                if currentHouse then
                    sleep = 0
                    if Config.TimeSync == 'cd_easytime' then
                        TriggerEvent('cd_easytime:PauseSync', true)
                    end
                    SetTimecycleModifier("mp_x17dlc_base_dark")
                    SetTimecycleModifierStrength(1.0)
                    timecycleEnabled = true
                    NetworkOverrideClockTime(2, 0, 0)
                elseif timecycleEnabled and not currentHouse then
                    if Config.TimeSync == 'cd_easytime' then
                        TriggerEvent('cd_easytime:PauseSync', false)
                    end
                    ClearTimecycleModifier()
                    timecycleEnabled = false
                end
            end
            Wait(sleep)
        end
    end)
    if not PedSpawned[house] then
        PedSpawned[house] = true
        if math.random(100) <= Config.HousesToRob[house].Residence.Ped.chance then
            local Attack = false
            RequestModel(Config.HousesToRob[house].Residence.Ped.model)

            while not HasModelLoaded(Config.HousesToRob[house].Residence.Ped.model) do
                Wait(100)
            end
            NPC = CreatePed(4, Config.HousesToRob[house].Residence.Ped.model,
                Config.HousesToRob[house].Residence.Ped.coords.x, Config.HousesToRob[house].Residence.Ped.coords.y,
                Config.HousesToRob[house].Residence.Ped.coords.z, Config.HousesToRob[house].Residence.Ped.coords.w, true,
                true)
            if Config.HousesToRob[house].Residence.Ped.weapon.enabled then
                if math.random(100) <= Config.HousesToRob[house].Residence.Ped.weapon.chance then
                    GiveWeaponToPed(NPC, Config.HousesToRob[house].Residence.Ped.weapon.weapon, 90, true, true)
                    if Config.HousesToRob[house].Residence.Ped.weapon.DisableWeaponDrop then
                        SetPedDropsWeaponsWhenDead(NPC, false)
                    end
                end
            end
            TaskStartScenarioInPlace(NPC, "WORLD_HUMAN_BUM_SLUMPED", 0, true)
            table.insert(AllObjects, NPC)
            table.insert(CreatedProps, NPC)
            SetTimeout(1100, function()
                if DoesEntityExist(NPC) then
                    TriggerServerEvent('d-houserobbery_instance:addEntityToPlayerInstance', PedToNet(NPC))
                end
            end)
            CreateThread(function()
                while true do
                    sleep = 0
                    NPC = NPC
                    if Attack then
                        TaskCombatPed(NPC, cache.ped, 0, 16)
                    end
                    if GetEntityHealth(NPC) == 0 then

                    end
                    if currentHouse and (IsPedJumping(cache.ped) and not Attack) or (IsPedShooting(cache.ped) and not Attack) or (IsPedRunning(cache.ped) and not Attack) or (GetEntityPlayerIsFreeAimingAt(PlayerId(-1)) == NPC and not Attack) then
                        Attack = true
                        Dispatch(Config.HousesToRob[house].Coords.xyz, "houserobbery")
                    end
                    Wait(sleep)
                end
            end)
        end
    end
end)

RegisterNetEvent("d-houserobbery:lockpick")
AddEventHandler("d-houserobbery:lockpick", function(house)
    Lockpicking = true
    doLockpickAnimation(Config.HousesToRob[house].Coords.xyz)
    
    if not cache.vehicle then
        exports['ps-ui']:Circle(function(success)
            if success then
                doingAction = true
                SetTimeout(1100, function()
                    FreezeEntityPosition(cache.ped, true)
                end)
                ProgressBar(1500, locale('lockpicking'))
                Lockpicking = false
                doingAction = false
                local Residence = Config.HousesToRob[house].Residence
                -- if math.random(100) <= Residence.ReportChanceWhenEntering then
                --     Dispatch(Config.HousesToRob[house].Coords.xyz, "houserobbery")
                --     AlarmSound()
                --     Notify('error', locale('Alarm'), locale('startedalarm'))
                -- end
                TriggerServerEvent("d-houserobbery:unlockHouse", house)
                enterHouse(house, false)
                FreezeEntityPosition(cache.ped, false)
            else
                Lockpicking = false
                Notify('error', locale('lockpick'), locale('brokendoor'))
            end
        end, 4, 10)
    end
end)

local zonesmaked = {}
function createZones(house)
    SetTimeout(2000, function()
        if not PedSpawned[house] then
            TriggerServerEvent("d-houserobbery:SpawnPed", house)
        end
    end)
    if Config.InteractionType ~= 'target' then
        for place, v in pairs(Config.HousesToRob[house].Residence.InsidePositions) do
            if not zonesmaked[house .. place .. v.coords] then
                zonesmaked[house .. place .. v.coords] = true
                lib.zones.sphere({
                    coords = v.coords.xyz,
                    radius = 1,
                    debug = Config.Debug,
                    inside = function(self)
                        if (IsControlJustReleased(0, 38) and not doingAction) or (IsControlJustReleased(0, 38) and carrying) then
                            if place == "Exit" then
                                leaveHouse(house)
                            else
                                searchPlace(place)
                            end
                        end

                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords,
                                string.format("[~g~E~w~] - %s",
                                    place == "Exit" and locale('exit_label') or locale("search_label")))
                        end
                    end,
                    onEnter = function()
                        if carrying and place == "Exit" then
                            leaving = true
                            local model = GetEntityModel(CurrentProp)
                            for _, v in pairs(GetGamePool('CObject')) do
                                if IsEntityAttachedToEntity(cache.ped, v) then
                                    if GetEntityModel(v) == model then
                                        SetEntityAsMissionEntity(v, true, true)
                                        DeleteObject(v)
                                    end
                                end
                            end

                            leaveHouse(house)
                        end
                        if Config.InteractionType == "textui" then
                            local text = locale('search_label')
                            if place == "Exit" then
                                text = locale('exit_label')
                            end
                            TextUIShow("[E] - " .. text)
                        end
                    end,
                    onExit = function()
                        if Config.InteractionType == "textui" then
                            TextUIHide()
                        end
                    end
                })
            end
        end
        SetTimeout(2000, function()
            for k, v in pairs(Config.HousesToRob[house].Residence.CreateProps) do
                RequestModel(v.model)
                while not HasModelLoaded(v.model) do
                    Wait(0)
                end
                local AlreadyRobbed = false
                for _, place in each(housesData[house].robbed) do
                    if place == k then
                        AlreadyRobbed = true
                    end
                end
                if not AlreadyRobbed then
                    object = CreateObject(v.model, v.Coords.xyz, false, true, false)
                    SpawnedObject[house .. k] = true
                    SetEntityHeading(object, v.Coords.w)
                    PlaceObjectOnGroundProperly(object)
                    table.insert(AllObjects, object)
                    table.insert(CreatedProps, object)
                    if not zonesmaked[house .. k .. v.Coords] then
                        zonesmaked[house .. k .. v.Coords] = true
                        TriggerServerEvent('d-houserobbery:propcheck2', object, k, house)
                        lib.zones.sphere({
                            coords = v.Coords.xyz,
                            radius = 1.5,
                            debug = Config.Debug,
                            inside = function(self)
                                object = object
                                if not IsEntityAttached(object) then
                                    if Config.InteractionType == "3dtext" then
                                        if not IsEntityAttached(object) and not propRobbed[house .. k] then
                                            if v.model == GetEntityModel(object) then
                                                local playerPos = GetEntityCoords(PlayerPedId())
                                                local objPos = GetEntityCoords(object)
                                                local distance = #(playerPos - objPos)
                                                if distance <= 2 then
                                                    Draw3DText(GetEntityCoords(object), locale('Take3D') .. v.Label)
                                                end
                                            end
                                        end
                                    end
                                    if IsControlJustReleased(0, 38) and not doingAction and not carrying then
                                        house = currentHouse
                                        TriggerServerEvent("d-houserobbery:robbedHouseProp", house, k)
                                        local AlreadyRobbed = false
                                        for _, place in each(housesData[house].robbed) do
                                            if place == k then
                                                propRobbed[house .. k] = true
                                                AlreadyRobbed = true
                                            end
                                        end
                                        if not AlreadyRobbed then
                                            doingAction = true
                                            TaskTurnPedToFaceCoord(cache.ped, v.Coords.xyz, 1000)
                                            if not v.NeedTrunk then
                                                clip = "grab"
                                                dict = "anim@scripted@heist@ig1_table_grab@cash@male@"
                                                RequestAnimDict(dict)
                                                while (not HasAnimDictLoaded(dict)) do Wait(0) end
                                                TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false,
                                                    false)
                                                ProgressBar(1500, locale('taking', v.Label))
                                                if DoesEntityExist(object) then
                                                    TriggerServerEvent("d-houserobbery:robbedpropcreated", v.model,
                                                        house, k, ObjToNet(object), false)
                                                else
                                                    TriggerServerEvent("d-houserobbery:robbedpropcreated", v.model,
                                                        house, k, nil, false)
                                                end
                                                objects = GetGamePool("CObject")
                                                for i = 1, #objects do
                                                    if v.model == GetEntityModel(objects[i]) then
                                                        SetEntityAlpha(objects[i], 0, false)
                                                    end
                                                end
                                            else
                                                TaskStartScenarioInPlace(cache.ped, "PROP_HUMAN_BUM_BIN", 0, true)
                                                ProgressBar(4500, locale('taking', v.Label))
                                            end
                                            ClearPedTasks(cache.ped)
                                            objects = GetGamePool("CObject")
                                            for i = 1, #objects do
                                                if v.model == GetEntityModel(objects[i]) then
                                                    if DoesEntityExist(objects[i]) then
                                                        TriggerServerEvent('d-houserobbery:propcheck2', objects[i], k,
                                                            house, ObjToNet(object))
                                                    end
                                                    DeleteEntity(objects[i])
                                                    if DoesEntityExist(objects[i]) then
                                                        TriggerServerEvent("d-houserobbery:removeobject",
                                                            ObjToNet(objects[i]))
                                                    end
                                                end
                                            end
                                            doingAction = false
                                            carrying = true
                                            text = locale("TextUI")
                                            if v.NeedTrunk then
                                                TextUIShow(text)
                                                Notify('info', locale('info'), locale('LeaveHouse'))
                                                while carrying and not Placing do
                                                    Wait(0)
                                                    if not IsTextUIShowed() then
                                                        TextUIShow(text)
                                                    end
                                                    if not IsEntityPlayingAnim(cache.ped, v.CarryAnim.dict, v.CarryAnim.anim, 3) and not leaving then
                                                        local hash = v.model
                                                        RequestModel(hash)
                                                        while not HasModelLoaded(hash) do
                                                            Wait(100)
                                                            RequestModel(hash)
                                                        end
                                                        AttachedProp = CreateObject(hash, GetEntityCoords(cache.ped),
                                                            true, true, false)

                                                        AttachEntityToEntity(AttachedProp, cache.ped,
                                                            GetPedBoneIndex(cache.ped, v.propPlacement.bone),
                                                            v.propPlacement.pos, v.propPlacement.rot, true, true, false,
                                                            false, 1, true)

                                                        dict = v.CarryAnim.dict
                                                        clip = v.CarryAnim.anim
                                                        CurrentProp = AttachedProp
                                                        RequestAnimDict(dict)
                                                        while (not HasAnimDictLoaded(dict)) do Wait(0) end
                                                        TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false,
                                                            false, false)
                                                        --doingAction = false
                                                    end
                                                    if IsControlJustReleased(0, 104) and not Pressed then
                                                        local ped = cache.ped
                                                        local coordA = GetEntityCoords(ped, true)
                                                        local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0,
                                                            0.0)
                                                        local vehicle = getVehicleInDirection(coordA, coordB)
                                                        if DoesEntityExist(vehicle) and IsVehicleSeatFree(vehicle, -1) then
                                                            local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(vehicle))
                                                            if dist <= 3.5 then
                                                                if GetEntityBoneIndexByName(vehicle, "boot") ~= -1 then
                                                                    SetVehicleDoorOpen(vehicle, 5, false, false)
                                                                else
                                                                    local boneId = GetEntityBoneIndexByName(vehicle,
                                                                        'door_pside_r')

                                                                    if boneId ~= -1 then
                                                                        SetVehicleDoorOpen(vehicle, 3, false, false)
                                                                    end
                                                                    local boneId2 = GetEntityBoneIndexByName(vehicle,
                                                                        'door_dside_r')

                                                                    if boneId2 ~= -1 then
                                                                        SetVehicleDoorOpen(vehicle, 2, false, false)
                                                                    end
                                                                end
                                                                local model = GetEntityModel(CurrentProp)
                                                                SetEntityAsMissionEntity(CurrentProp, true, true)
                                                                RemoveProp(v.Item, CurrentProp, v.NeedTrunk, vehicle,
                                                                    model, "created", house, k)
                                                                Pressed = true
                                                                carrying = false
                                                                Pressed = false
                                                            else
                                                                Notify("error", locale("error"), locale("Trunk"))
                                                            end
                                                        else
                                                            Notify("error", locale("error"), locale("Trunk"))
                                                        end
                                                    end
                                                    if IsControlJustReleased(0, 47) and not Pressed then
                                                        if not currentHouse then
                                                            PlaceObject(GetEntityModel(CurrentProp), locale("PutDown"),
                                                                CurrentProp, 0.0, house)
                                                            Pressed = true
                                                            local model = GetEntityModel(CurrentProp)
                                                            for _, v in pairs(GetGamePool('CObject')) do
                                                                if IsEntityAttachedToEntity(cache.ped, v) then
                                                                    if GetEntityModel(v) == model then
                                                                        SetEntityAsMissionEntity(v, true, true)
                                                                        DeleteObject(v)
                                                                    end
                                                                end
                                                            end
                                                            carrying = false
                                                            Pressed = false
                                                        end
                                                    end
                                                end
                                            else
                                                local model = GetEntityModel(CurrentProp)
                                                SetEntityAsMissionEntity(CurrentProp, true, true)
                                                RemoveProp(v.Item, CurrentProp, v.NeedTrunk, vehicle, model, "created",
                                                    house, k)
                                                Pressed = true
                                                carrying = false
                                                Pressed = false
                                            end
                                        end
                                    end
                                end
                            end,
                            onEnter = function()
                                house = currentHouse
                                if not IsEntityAttached(object) and not propRobbed[house .. k] then
                                    objects = GetGamePool("CObject")
                                    for i = 1, #objects do
                                        if v.model == GetEntityModel(object) then
                                            if Config.InteractionType ~= "3dtext" then
                                                TextUIShow(locale('Take') .. v.Label)
                                            end
                                        end
                                    end
                                end
                            end,
                            onExit = function()
                                if Config.InteractionType ~= "3dtext" then
                                    TextUIHide()
                                end
                            end
                        })
                    end
                end
            end
        end)
        SetTimeout(2000, function()
            for k, v in pairs(Config.HousesToRob[house].Residence.Safes) do
                RequestModel(v.model)
                while not HasModelLoaded(v.model) do
                    Wait(0)
                end
                local object = CreateObject(v.model, v.Coords.xyz, false, true, false)
                SetEntityHeading(object, v.Coords.w)
                PlaceObjectOnGroundProperly(object)
                FreezeEntityPosition(object, true)
                table.insert(AllObjects, object)
                table.insert(CreatedProps, object)
                if not zonesmaked[house .. k .. v.Coords] then
                    zonesmaked[house .. k .. v.Coords] = true
                    lib.zones.sphere({
                        coords = v.Coords.xyz,
                        radius = 2,
                        debug = Config.Debug,
                        inside = function(self)
                            if IsControlJustReleased(0, 38) and not doingAction then
                                local HaveLaptop = true
                                if v.NeedItem then
                                    HaveLaptop = false
                                    lib.callback('d-houserobbery:getitem', false, function(value)
                                        if value then
                                            HaveLaptop = true
                                        else
                                            HaveLaptop = false
                                            Notify('error', locale('error'), locale('NeedLockpick'))
                                            return
                                        end
                                    end, v.Item)
                                end
                                SetTimeout(500, function()
                                    house = currentHouse
                                    if not doingAction and HaveLaptop then
                                        for _, place in each(housesData[house].robbed) do
                                            if place == k then
                                                propRobbed[house .. k] = true
                                            end
                                        end
                                        if not propRobbed[house .. k] and not LockpickingSafe then
                                            LockpickingSafe = true
                                            FreezeEntityPosition(cache.ped, true)
                                            if LockPickMinigame() then
                                                LockpickingSafe = false
                                                FreezeEntityPosition(cache.ped, false)
                                                Notify('success', locale('success'), locale('opened'))
                                                TriggerServerEvent("d-houserobbery:robbedHouseProp", house, k)
                                                TriggerServerEvent("d-houserobbery:RobbedSafe", house, k)
                                            else
                                                LockpickingSafe = false
                                                FreezeEntityPosition(cache.ped, false)
                                                Notify('error', locale('error'), locale('failed'))
                                            end
                                        else
                                            Notify('success', locale('success'), locale('alreadyopened'))
                                        end
                                    end
                                end)
                            end

                            if Config.InteractionType == "3dtext" then
                                Draw3DText(self.coords, string.format("[~g~E~w~] - %s", v.Label))
                            end
                        end,
                        onEnter = function()
                            if Config.InteractionType == "textui" then
                                TextUIShow("[E] - " .. v.Label)
                            end
                        end,
                        onExit = function()
                            if Config.InteractionType == "textui" then
                                TextUIHide()
                            end
                        end
                    })
                end
            end
        end)
        SetTimeout(2000, function()
            for k, v in pairs(Config.HousesToRob[house].Residence.HackDevice) do
                RequestModel(v.model)
                while not HasModelLoaded(v.model) do
                    Wait(0)
                end
                local object = CreateObject(v.model, v.Coords.xyz, false, true, false)
                SetEntityHeading(object, v.Coords.w)
                FreezeEntityPosition(object, true)
                if not zonesmaked[house .. k .. v.Coords] then
                    zonesmaked[house .. k .. v.Coords] = true
                    lib.zones.sphere({
                        coords = v.Coords.xyz,
                        radius = 1,
                        debug = Config.Debug,
                        inside = function(self)
                            if IsControlJustReleased(0, 38) and not doingAction then
                                local HaveLaptop = true
                                if v.NeedItem then
                                    HaveLaptop = false
                                    lib.callback('d-houserobbery:getitem', false, function(value)
                                        if value then
                                            HaveLaptop = true
                                        else
                                            HaveLaptop = false
                                            Notify('error', locale('error'), locale('NeedLaptop'))
                                            return
                                        end
                                    end, v.Item)
                                end
                                SetTimeout(500, function()
                                    house = currentHouse
                                    if not HouseHacked[house] and HaveLaptop then
                                        Hacking = true
                                        doAnimation()
                                        FreezeEntityPosition(cache.ped, true)
                                        if HackingMinigame() then
                                            Hacking = false
                                            FreezeEntityPosition(cache.ped, false)
                                            Notify('success', locale('success'), locale('hacked'))
                                            TriggerServerEvent("d-houserobbery:AddHackedHouse", house)
                                        else
                                            Dispatch(Config.HousesToRob[house].Coords.xyz, "houserobbery")
                                            AlarmSound()
                                            Notify('error', locale('Alarm'), locale('startedalarm'))
                                            Notify('error', locale('error'), locale('failed'))
                                            Hacking = false
                                            FreezeEntityPosition(cache.ped, false)
                                        end
                                    elseif HouseHacked[house] and not HaveLaptop then
                                        Notify('success', locale('success'), locale('AlreadyHacked'))
                                    end
                                end)
                            end

                            if Config.InteractionType == "3dtext" then
                                if not carrying then
                                    Draw3DText(self.coords, string.format("[~g~E~w~] - %s", v.Label))
                                end
                            end
                        end,
                        onEnter = function()
                            if Config.InteractionType == "textui" then
                                if not carrying then
                                    TextUIShow("[E] - " .. v.Label)
                                end
                            end
                        end,
                        onExit = function()
                            if Config.InteractionType == "textui" then
                                if not carrying then
                                    TextUIHide()
                                end
                            end
                        end
                    })
                end
            end
        end)
        for k, v in pairs(Config.HousesToRob[house].Residence.Lasers) do
            TriggerServerEvent('d-houserobbery:CheckLaser', house)
            TriggerServerEvent("d-houserobbery:CheckHackedHouse", house)
            TriggerServerEvent('d-houserobbery:CheckPowderHouse', house)
            if math.random(100) <= Config.HousesToRob[house].Residence.LaserChance and not HouseLasered[house] then
                if math.random(100) <= v.chance then
                    if not HouseHacked[house] and not v.spawned then
                        hittedbylaser = false
                        v.spawned = true
                        local k = Laser.new(
                            v.FromCoords,
                            { v.ToCoords },
                            { travelTimeBetweenTargets = { 1.0, 1.0 }, waitTimeAtTargets = { 0.0, 0.0 },
                                randomTargetSelection = true, name = "Laser" .. k }
                        )
                        k.setVisible(true)
                        k.setActive(true)
                        k.setMoving(true)
                        if HousePowdered[house] then
                            k.setColor(255, 0, 0, 100)
                        else
                            if v.Visible then
                                k.setColor(255, 0, 0, 100)
                            else
                                k.setColor(255, 0, 0, 0)
                            end
                        end
                        k.onPlayerHit(function(playerBeingHit, hitPos)
                            if playerBeingHit and not hittedbylaser then
                                hittedbylaser = true
                                AlarmSound()
                                Dispatch(Config.HousesToRob[house].Coords.xyz, "houserobbery")
                                Notify('error', locale('Alarm'), locale('startedalarm'))
                            end
                        end)
                        table.insert(Lasers, k)
                        TriggerServerEvent('d-houserobbery:lasercheck', k, house)
                        TriggerServerEvent("d-houserobbery:CheckHackedHouse", house)
                    end
                end
            end
        end
        TriggerServerEvent("d-houserobbery:AddLaser", house)
        for k, v in pairs(Config.HousesToRob[house].Residence.StaticProps) do
            local objects = GetGamePool("CObject")
            for i = 1, #objects do
                if v.model == GetEntityModel(objects[i]) then
                    coords = GetEntityCoords(objects[i])
                    TriggerServerEvent('d-houserobbery:propcheck', objects[i], k, house, GetEntityModel(objects[i]))
                    if not zonesmaked[house .. k .. coords] then
                        zonesmaked[house .. k .. coords] = true
                        lib.zones.sphere({
                            coords = coords.xyz,
                            radius = 1,
                            debug = Config.Debug,
                            inside = function(self)
                                house = currentHouse
                                objects = GetGamePool("CObject")
                                for i = 1, #objects do
                                    if not IsEntityAttached(objects[i]) and currentHouse and v.model == GetEntityModel(objects[i]) then
                                        if Config.InteractionType == "3dtext" then
                                            local playerPos = GetEntityCoords(PlayerPedId())
                                            local objPos = GetEntityCoords(objects[i])
                                            local distance = #(playerPos - objPos)
                                            if distance <= 2 then
                                                Draw3DText(GetEntityCoords(objects[i]), locale('Take3D') .. v.Label)
                                            end
                                        end
                                        if IsControlJustReleased(0, 38) and not doingAction and not carrying then
                                            TriggerServerEvent("d-houserobbery:robbedHouseProp", house, k)
                                            local AlreadyRobbed = false
                                            for _, place in each(housesData[house].robbed) do
                                                if place == k then
                                                    propRobbed[house .. k] = true
                                                    AlreadyRobbed = true
                                                end
                                            end
                                            if not AlreadyRobbed then
                                                doingAction = true
                                                if not v.NeedTrunk then
                                                    local clip = "grab"
                                                    local dict = "anim@scripted@heist@ig1_table_grab@cash@male@"
                                                    RequestAnimDict(dict)
                                                    while (not HasAnimDictLoaded(dict)) do Wait(0) end
                                                    TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false,
                                                        false)
                                                    ProgressBar(1500, locale('taking', v.Label))
                                                    TriggerServerEvent("d-houserobbery:robbedpropstatic", v.model,
                                                        house, k, nil, false)
                                                    ClearPedTasks(cache.ped)
                                                else
                                                    TaskStartScenarioInPlace(cache.ped, "PROP_HUMAN_BUM_BIN", 0, true)
                                                    ProgressBar(4000, locale('taking', v.Label))
                                                    ClearPedTasks(cache.ped)
                                                end
                                                objects = GetGamePool("CObject")
                                                for i = 1, #objects do
                                                    if v.model == GetEntityModel(objects[i]) then
                                                        TriggerServerEvent('d-houserobbery:propcheck', objects[i], k,
                                                            house, GetEntityModel(objects[i]))
                                                    end
                                                end
                                                doingAction = false
                                                if v.NeedTrunk then
                                                    carrying = true
                                                    Notify('info', locale('info'), locale('LeaveHouse'))
                                                    text = locale("TextUI")
                                                    TextUIShow(text)
                                                    while carrying and not Placing do
                                                        Wait(0)
                                                        if not IsTextUIShowed() then
                                                            TextUIShow(text)
                                                        end
                                                        if not IsEntityPlayingAnim(cache.ped, v.CarryAnim.dict, v.CarryAnim.anim, 3) and not leaving then
                                                            local hash = v.model
                                                            RequestModel(hash)
                                                            while not HasModelLoaded(hash) do
                                                                Wait(100)
                                                                RequestModel(hash)
                                                            end
                                                            AttachedProp = CreateObject(hash, GetEntityCoords(cache.ped),
                                                                true, true, false)

                                                            AttachEntityToEntity(AttachedProp, cache.ped,
                                                                GetPedBoneIndex(cache.ped, v.propPlacement.bone),
                                                                v.propPlacement.pos, v.propPlacement.rot, true, true,
                                                                false, false, 1, true)

                                                            dict = v.CarryAnim.dict
                                                            clip = v.CarryAnim.anim
                                                            CurrentProp = AttachedProp
                                                            RequestAnimDict(dict)
                                                            while (not HasAnimDictLoaded(dict)) do Wait(0) end
                                                            TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0,
                                                                false, false, false)
                                                            --doingAction = false
                                                        end
                                                        if IsControlJustReleased(0, 104) and not Pressed then
                                                            local ped = cache.ped
                                                            local coordA = GetEntityCoords(ped, true)
                                                            local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0,
                                                                0.0)
                                                            local vehicle = getVehicleInDirection(coordA, coordB)
                                                            if DoesEntityExist(vehicle) and IsVehicleSeatFree(vehicle, -1) then
                                                                local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(vehicle))
                                                                if dist <= 3.5 then
                                                                    if GetEntityBoneIndexByName(vehicle, "boot") ~= -1 then
                                                                        SetVehicleDoorOpen(vehicle, 5, false, false)
                                                                    else
                                                                        local boneId = GetEntityBoneIndexByName(
                                                                        vehicle, 'door_pside_r')

                                                                        if boneId ~= -1 then
                                                                            SetVehicleDoorOpen(vehicle, 3, false,
                                                                                false)
                                                                        end
                                                                        local boneId2 = GetEntityBoneIndexByName(
                                                                        vehicle, 'door_dside_r')

                                                                        if boneId2 ~= -1 then
                                                                            SetVehicleDoorOpen(vehicle, 2, false,
                                                                                false)
                                                                        end
                                                                    end
                                                                    local model = GetEntityModel(CurrentProp)
                                                                    SetEntityAsMissionEntity(CurrentProp, true, true)
                                                                    RemoveProp(v.Item, CurrentProp, v.NeedTrunk,
                                                                        vehicle, model, "static", house, k)
                                                                    Pressed = true
                                                                    carrying = false
                                                                    Pressed = false
                                                                else
                                                                    Notify("error", locale("error"), locale("Trunk"))
                                                                end
                                                            else
                                                                Notify("error", locale("error"), locale("Trunk"))
                                                            end
                                                        end
                                                        if IsControlJustReleased(0, 47) and not Pressed then
                                                            if not currentHouse then
                                                                PlaceObject(GetEntityModel(CurrentProp),
                                                                    locale("PutDown"), CurrentProp, 0.0, house)
                                                                Pressed = true
                                                                local model = GetEntityModel(CurrentProp)
                                                                for _, v in pairs(GetGamePool('CObject')) do
                                                                    if IsEntityAttachedToEntity(cache.ped, v) then
                                                                        if GetEntityModel(v) == model then
                                                                            SetEntityAsMissionEntity(v, true, true)
                                                                            DeleteObject(v)
                                                                        end
                                                                    end
                                                                end
                                                                carrying = false
                                                                Pressed = false
                                                            end
                                                        end
                                                    end
                                                else
                                                    local model = GetEntityModel(CurrentProp)
                                                    SetEntityAsMissionEntity(CurrentProp, true, true)
                                                    RemoveProp(v.Item, CurrentProp, v.NeedTrunk, vehicle, model, "static",
                                                        house, k)
                                                    Pressed = true
                                                    carrying = false
                                                    Pressed = false
                                                end
                                            end
                                        end
                                    end
                                end
                            end,
                            onEnter = function()
                                if not IsEntityAttached(objects[i]) and currentHouse then
                                    objects = GetGamePool("CObject")
                                    for i = 1, #objects do
                                        if v.model == GetEntityModel(objects[i]) then
                                            if Config.InteractionType ~= "3dtext" then
                                                TextUIShow(locale('Take') .. v.Label)
                                            end
                                        end
                                    end
                                end
                            end,
                            onExit = function()
                                if Config.InteractionType ~= "3dtext" then
                                    TextUIHide()
                                end
                            end
                        })
                    end
                end
            end
        end
    elseif Config.InteractionType == 'target' then
        for place, v in pairs(Config.HousesToRob[house].Residence.InsidePositions) do
            if not zonesmaked[house .. place .. v.coords] then
                zonesmaked[house .. place .. v.coords] = true
                if place == "Exit" then
                    target:AddCircleZone("d-houserobbery_robberyplace" .. place .. house, v.coords.xyz, 1.0, {
                        name = "d-houserobbery_robberyplace" .. place .. house,
                        useZ = true,
                        debugPoly = Config.Debug,
                    }, {
                        options = {
                            {
                                action = function()
                                    if (not doingAction) or (carrying) then
                                        if place == "Exit" then
                                            leaveHouse(currentHouse)
                                        else
                                            searchPlace(place)
                                        end
                                    end
                                end,
                                icon = "fas fa-door-open",
                                label = locale('exit_label')
                            }
                        },
                        distance = 1.0
                    })
                else
                    target:AddCircleZone("d-houserobbery_robberyplace" .. place .. house, v.coords.xyz, 1.0, {
                        name = "d-houserobbery_robberyplace" .. place .. house,
                        useZ = true,
                        debugPoly = Config.Debug,
                    }, {
                        options = {
                            {
                                action = function()
                                    if place == "Exit" then
                                        leaveHouse(currentHouse)
                                    else
                                        searchPlace(place)
                                    end
                                end,
                                icon = place == "Exit" and "fas fa-door-open" or "fas fa-search",
                                label = place == "Exit" and locale('exit_label') or locale('search_label')
                            }
                        },
                        distance = 1.0
                    })
                end
                lib.zones.sphere({
                    coords = v.coords.xyz,
                    radius = 1,
                    debug = Config.Debug,
                    onEnter = function()
                        if carrying and place == "Exit" and house == currentHouse then
                            leaving = true
                            local model = GetEntityModel(CurrentProp)
                            for _, v in pairs(GetGamePool('CObject')) do
                                if IsEntityAttachedToEntity(cache.ped, v) then
                                    if GetEntityModel(v) == model then
                                        SetEntityAsMissionEntity(v, true, true)
                                        DeleteObject(v)
                                    end
                                end
                            end

                            leaveHouse(currentHouse)
                        end
                    end
                })
            end
        end
        SetTimeout(2000, function()
            for k, v in pairs(Config.HousesToRob[house].Residence.CreateProps) do
                RequestModel(v.model)
                while not HasModelLoaded(v.model) do
                    Wait(0)
                end
                local AlreadyRobbed = false
                for _, place in each(housesData[house].robbed) do
                    if place == k then
                        AlreadyRobbed = true
                    end
                end
                if not AlreadyRobbed then
                    object = CreateObject(v.model, v.Coords.xyz, false, true, false)
                    SpawnedObject[house .. k] = true
                    SetEntityHeading(object, v.Coords.w)
                    PlaceObjectOnGroundProperly(object)
                    table.insert(AllObjects, object)
                    table.insert(CreatedProps, object)
                    if not zonesmaked[house .. k .. v.Coords] then
                        zonesmaked[house .. k .. v.Coords] = true
                        if DoesEntityExist(object) and NetworkGetEntityIsNetworked(object) then
                            TriggerServerEvent('d-houserobbery:propcheck2', object, k, house, ObjToNet(object),
                                GetEntityModel(object))
                        else
                            TriggerServerEvent('d-houserobbery:propcheck2', object, k, house, nil,
                                GetEntityModel(object))
                        end
                        target:AddCircleZone("d-houserobbery_robberyplace" .. k, v.Coords.xyz, 1.0, {
                            name = "d-houserobbery_robberyplace" .. k,
                            useZ = true,
                            debugPoly = Config.Debug,
                        }, {
                            options = {
                                {
                                    action = function()
                                        house = currentHouse
                                        object = object
                                        if not IsEntityAttached(object) then
                                            if not doingAction and not carrying then
                                                TriggerServerEvent("d-houserobbery:robbedHouseProp", house, k)
                                                local AlreadyRobbed = false
                                                for _, place in each(housesData[house].robbed) do
                                                    if place == k then
                                                        propRobbed[house .. k] = true
                                                        AlreadyRobbed = true
                                                    end
                                                end
                                                if not AlreadyRobbed then
                                                    zonesmaked[house .. k .. v.Coords] = false
                                                    target:RemoveZone("d-houserobbery_robberyplace" .. k)
                                                    doingAction = true
                                                    TaskTurnPedToFaceCoord(cache.ped, v.Coords.xyz, 1000)
                                                    if not v.NeedTrunk then
                                                        clip = "grab"
                                                        dict = "anim@scripted@heist@ig1_table_grab@cash@male@"
                                                        RequestAnimDict(dict)
                                                        while (not HasAnimDictLoaded(dict)) do Wait(0) end
                                                        TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false,
                                                            false, false)
                                                        ProgressBar(1500, locale('taking', v.Label))
                                                        if DoesEntityExist(object) and NetworkGetEntityIsNetworked(object) then
                                                            TriggerServerEvent("d-houserobbery:robbedpropcreated",
                                                                v.model, house, k, ObjToNet(object), false)
                                                        else
                                                            TriggerServerEvent("d-houserobbery:robbedpropcreated",
                                                                v.model, house, k, object, false)
                                                        end
                                                        objects = GetGamePool("CObject")
                                                        for i = 1, #objects do
                                                            if v.model == GetEntityModel(objects[i]) then
                                                                SetEntityAlpha(objects[i], 0, false)
                                                            end
                                                        end
                                                    else
                                                        TaskStartScenarioInPlace(cache.ped, "PROP_HUMAN_BUM_BIN", 0, true)
                                                        ProgressBar(4500, locale('taking', v.Label))
                                                    end
                                                    ClearPedTasks(cache.ped)
                                                    objects = GetGamePool("CObject")
                                                    for i = 1, #objects do
                                                        if v.model == GetEntityModel(objects[i]) then
                                                            if DoesEntityExist(object) and DoesEntityExist(object) and NetworkGetEntityIsNetworked(object) then
                                                                TriggerServerEvent('d-houserobbery:propcheck2',
                                                                    objects[i], k, house, ObjToNet(object),
                                                                    GetEntityModel(objects[i]))
                                                            else
                                                                TriggerServerEvent('d-houserobbery:propcheck2',
                                                                    objects[i], k, house, nil, GetEntityModel(objects[i]))
                                                            end
                                                            DeleteEntity(objects[i])
                                                            if DoesEntityExist(objects[i]) and NetworkGetEntityIsNetworked(objects[i]) then
                                                                TriggerServerEvent("d-houserobbery:removeobject",
                                                                    ObjToNet(objects[i]))
                                                            else
                                                                TriggerServerEvent("d-houserobbery:removeobject", nil)
                                                            end
                                                        end
                                                    end
                                                    doingAction = false
                                                    carrying = true
                                                    if v.NeedTrunk then
                                                        Notify('info', locale('info'), locale('LeaveHouse'))
                                                        text = locale("TextUI")
                                                        TextUIShow(text)
                                                        while carrying and not Placing do
                                                            Wait(0)
                                                            if not IsTextUIShowed() then
                                                                TextUIShow(text)
                                                            end
                                                            if not IsEntityPlayingAnim(cache.ped, v.CarryAnim.dict, v.CarryAnim.anim, 3) and not leaving then
                                                                local hash = v.model
                                                                RequestModel(hash)
                                                                while not HasModelLoaded(hash) do
                                                                    Wait(100)
                                                                    RequestModel(hash)
                                                                end
                                                                AttachedProp = CreateObject(hash,
                                                                    GetEntityCoords(cache.ped), true, true, false)

                                                                AttachEntityToEntity(AttachedProp, cache.ped,
                                                                    GetPedBoneIndex(cache.ped, v.propPlacement.bone),
                                                                    v.propPlacement.pos, v.propPlacement.rot, true, true,
                                                                    false, false, 1, true)

                                                                dict = v.CarryAnim.dict
                                                                clip = v.CarryAnim.anim
                                                                CurrentProp = AttachedProp
                                                                RequestAnimDict(dict)
                                                                while (not HasAnimDictLoaded(dict)) do Wait(0) end
                                                                TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0,
                                                                    false, false, false)
                                                                --doingAction = false
                                                            end
                                                            if IsControlJustReleased(0, 104) and not Pressed then
                                                                local ped = cache.ped
                                                                local coordA = GetEntityCoords(ped, true)
                                                                local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0,
                                                                    5.0, 0.0)
                                                                local vehicle = getVehicleInDirection(coordA, coordB)
                                                                if DoesEntityExist(vehicle) and IsVehicleSeatFree(vehicle, -1) then
                                                                    local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(vehicle))
                                                                    if dist <= 3.5 then
                                                                        if GetEntityBoneIndexByName(vehicle, "boot") ~= -1 then
                                                                            SetVehicleDoorOpen(vehicle, 5, false, false)
                                                                        else
                                                                            local boneId = GetEntityBoneIndexByName(
                                                                            vehicle, 'door_pside_r')

                                                                            if boneId ~= -1 then
                                                                                SetVehicleDoorOpen(vehicle, 3, false,
                                                                                    false)
                                                                            end
                                                                            local boneId2 = GetEntityBoneIndexByName(
                                                                            vehicle, 'door_dside_r')

                                                                            if boneId2 ~= -1 then
                                                                                SetVehicleDoorOpen(vehicle, 2, false,
                                                                                    false)
                                                                            end
                                                                        end
                                                                        local model = GetEntityModel(CurrentProp)
                                                                        SetEntityAsMissionEntity(CurrentProp, true, true)
                                                                        RemoveProp(v.Item, CurrentProp, v.NeedTrunk,
                                                                            vehicle, model, "created", house, k)
                                                                        Pressed = true
                                                                        carrying = false
                                                                        Pressed = false
                                                                    else
                                                                        Notify("error", locale("error"), locale("Trunk"))
                                                                    end
                                                                else
                                                                    Notify("error", locale("error"), locale("Trunk"))
                                                                end
                                                            end
                                                            if IsControlJustReleased(0, 47) and not Pressed then
                                                                if not currentHouse then
                                                                    PlaceObject(GetEntityModel(CurrentProp),
                                                                        locale("PutDown"), CurrentProp, 0.0, house)
                                                                    Pressed = true
                                                                    local model = GetEntityModel(CurrentProp)
                                                                    for _, v in pairs(GetGamePool('CObject')) do
                                                                        if IsEntityAttachedToEntity(cache.ped, v) then
                                                                            if GetEntityModel(v) == model then
                                                                                SetEntityAsMissionEntity(v, true, true)
                                                                                DeleteObject(v)
                                                                            end
                                                                        end
                                                                    end
                                                                    carrying = false
                                                                    Pressed = false
                                                                end
                                                            end
                                                        end
                                                    else
                                                        local model = GetEntityModel(CurrentProp)
                                                        SetEntityAsMissionEntity(CurrentProp, true, true)
                                                        RemoveProp(v.Item, CurrentProp, v.NeedTrunk, vehicle, model,
                                                            "static", house, k)
                                                        Pressed = true
                                                        carrying = false
                                                        Pressed = false
                                                    end
                                                end
                                            end
                                        end
                                    end,
                                    icon = "fas fa-door-open",
                                    label = v.Label
                                }
                            },
                            distance = 1.0
                        })
                    end
                end
            end
        end)
        SetTimeout(2000, function()
            for k, v in pairs(Config.HousesToRob[house].Residence.Safes) do
                RequestModel(v.model)
                while not HasModelLoaded(v.model) do
                    Wait(0)
                end
                local object = CreateObject(v.model, v.Coords.xyz, false, true, false)
                SetEntityHeading(object, v.Coords.w)
                PlaceObjectOnGroundProperly(object)
                FreezeEntityPosition(object, true)
                table.insert(AllObjects, object)
                table.insert(CreatedProps, object)
                if not zonesmaked[house .. k .. v.Coords] then
                    zonesmaked[house .. k .. v.Coords] = true
                    target:AddCircleZone("d-houserobbery_robberyplace" .. k .. house, v.Coords.xyz, 1.0, {
                        name = "d-houserobbery_robberyplace" .. k .. house,
                        useZ = true,
                        debugPoly = Config.Debug,
                    }, {
                        options = {
                            {
                                action = function()
                                    house = currentHouse
                                    local HaveLaptop = true
                                    if v.NeedItem then
                                        HaveLaptop = false
                                        lib.callback('d-houserobbery:getitem', false, function(value)
                                            if value then
                                                HaveLaptop = true
                                            else
                                                HaveLaptop = false
                                                Notify('error', locale('error'), locale('NeedLockpick'))
                                                return
                                            end
                                        end, v.Item)
                                    end
                                    SetTimeout(500, function()
                                        if not doingAction and HaveLaptop then
                                            for _, place in each(housesData[house].robbed) do
                                                if place == k then
                                                    propRobbed[house .. k] = true
                                                end
                                            end
                                            if not propRobbed[house .. k] and not LockpickingSafe then
                                                LockpickingSafe = true
                                                FreezeEntityPosition(cache.ped, true)
                                                if LockPickMinigame() then
                                                    LockpickingSafe = false
                                                    FreezeEntityPosition(cache.ped, false)
                                                    Notify('success', locale('success'), locale('opened'))
                                                    TriggerServerEvent("d-houserobbery:robbedHouseProp", house, k)
                                                    TriggerServerEvent("d-houserobbery:RobbedSafe", house, k)
                                                else
                                                    LockpickingSafe = false
                                                    FreezeEntityPosition(cache.ped, false)
                                                    Notify('error', locale('error'), locale('failed'))
                                                end
                                            else
                                                Notify('success', locale('success'), locale('alreadyopened'))
                                            end
                                        end
                                    end)
                                end,
                                icon = "fas fa-door-open",
                                label = v.Label
                            }
                        },
                        distance = 1.0
                    })
                end
            end
        end)
        SetTimeout(2000, function()
            for k, v in pairs(Config.HousesToRob[house].Residence.HackDevice) do
                RequestModel(v.model)
                while not HasModelLoaded(v.model) do
                    Wait(0)
                end
                local object = CreateObject(v.model, v.Coords.xyz, false, true, false)
                SetEntityHeading(object, v.Coords.w)
                FreezeEntityPosition(object, true)
                table.insert(AllObjects, object)
                table.insert(CreatedProps, object)
                if not zonesmaked[house .. k .. v.Coords] then
                    zonesmaked[house .. k .. v.Coords] = true
                    target:AddCircleZone("d-houserobbery_robberyplace" .. k, v.Coords.xyz, 1.0, {
                        name = "d-houserobbery_robberyplace" .. k,
                        useZ = true,
                        debugPoly = Config.Debug,
                    }, {
                        options = {
                            {
                                action = function()
                                    local HaveLaptop = true
                                    if v.NeedItem then
                                        HaveLaptop = false
                                        lib.callback('d-houserobbery:getitem', false, function(value)
                                            if value then
                                                HaveLaptop = true
                                            else
                                                HaveLaptop = false
                                                Notify('error', locale('error'), locale('NeedLaptop'))
                                                return
                                            end
                                        end, v.Item)
                                    end
                                    SetTimeout(500, function()
                                        if not doingAction and HaveLaptop then
                                            if not HouseHacked[house] then
                                                Hacking = true
                                                doAnimation()
                                                FreezeEntityPosition(cache.ped, true)
                                                if HackingMinigame() then
                                                    Hacking = false
                                                    FreezeEntityPosition(cache.ped, false)
                                                    Notify('success', locale('success'), locale('hacked'))
                                                    TriggerServerEvent("d-houserobbery:AddHackedHouse", house)
                                                else
                                                    Dispatch(Config.HousesToRob[house].Coords.xyz, "houserobbery")
                                                    AlarmSound()
                                                    Notify('error', locale('Alarm'), locale('startedalarm'))
                                                    Hacking = false
                                                    FreezeEntityPosition(cache.ped, false)
                                                    Notify('error', locale('error'), locale('failed'))
                                                end
                                            elseif HouseHacked[house] and not HaveLaptop then
                                                Notify('success', locale('success'), locale('AlreadyHacked'))
                                            end
                                        end
                                    end)
                                end,
                                icon = "fas fa-door-open",
                                label = v.Label
                            }
                        },
                        distance = 1.0
                    })
                end
            end
        end)
        for k, v in pairs(Config.HousesToRob[house].Residence.Lasers) do
            TriggerServerEvent('d-houserobbery:CheckLaser', house)
            TriggerServerEvent("d-houserobbery:CheckHackedHouse", house)
            TriggerServerEvent('d-houserobbery:CheckPowderHouse', house)
            if math.random(100) <= Config.HousesToRob[house].Residence.LaserChance then
                if math.random(100) <= v.chance then
                    if not HouseHacked[house] and not v.spawned and not HouseLasered[house] then
                        hittedbylaser = false
                        v.spawned = true
                        local k = Laser.new(
                            v.FromCoords,
                            { v.ToCoords },
                            { travelTimeBetweenTargets = { 1.0, 1.0 }, waitTimeAtTargets = { 0.0, 0.0 },
                                randomTargetSelection = true, name = "Laser" .. k }
                        )
                        k.setVisible(true)
                        k.setActive(true)
                        k.setMoving(true)
                        if HousePowdered[house] then
                            k.setColor(255, 0, 0, 100)
                        else
                            if v.Visible then
                                k.setColor(255, 0, 0, 100)
                            else
                                k.setColor(255, 0, 0, 0)
                            end
                        end
                        k.onPlayerHit(function(playerBeingHit, hitPos)
                            if playerBeingHit and not hittedbylaser then
                                hittedbylaser = true
                                AlarmSound()
                                Dispatch(Config.HousesToRob[house].Coords.xyz, "houserobbery")
                                Notify('error', locale('Alarm'), locale('startedalarm'))
                            end
                        end)
                        table.insert(Lasers, k)
                        TriggerServerEvent('d-houserobbery:lasercheck', k, house)
                        TriggerServerEvent("d-houserobbery:CheckHackedHouse", house)
                    end
                end
            end
        end
        TriggerServerEvent("d-houserobbery:AddLaser", house)
        for k, v in pairs(Config.HousesToRob[house].Residence.StaticProps) do
            local objects = GetGamePool("CObject")
            for i = 1, #objects do
                if v.model == GetEntityModel(objects[i]) then
                    coords = GetEntityCoords(objects[i])
                    TriggerServerEvent('d-houserobbery:propcheck', objects[i], k, house, GetEntityModel(objects[i]))
                    if not zonesmaked["drc_house_prop" .. k .. house] then
                        zonesmaked["drc_house_prop" .. k .. house] = true
                        target:AddCircleZone("drc_house_prop" .. k .. house, coords.xyz, 1.0, {
                            name = "drc_house_prop" .. k .. house,
                            useZ = true,
                            debugPoly = Config.Debug,
                        }, {
                            options = {
                                {
                                    action = function()
                                        objects = nil
                                        objects = GetGamePool("CObject")
                                        for i = 1, #objects do
                                            if not IsEntityAttached(objects[i]) and currentHouse and v.model == GetEntityModel(objects[i]) then
                                                if not doingAction and not carrying then
                                                    TriggerServerEvent("d-houserobbery:robbedHouseProp", house, k)
                                                    local AlreadyRobbed = false
                                                    for _, place in each(housesData[house].robbed) do
                                                        if place == k then
                                                            propRobbed[house .. k] = true
                                                            AlreadyRobbed = true
                                                        end
                                                    end
                                                    if not AlreadyRobbed then
                                                        zonesmaked["drc_house_prop" .. k .. i .. house] = false
                                                        target:RemoveZone("drc_house_prop" .. k .. i .. house)
                                                        doingAction = true
                                                        if not v.NeedTrunk then
                                                            clip = "grab"
                                                            dict = "anim@scripted@heist@ig1_table_grab@gold@male@"
                                                            RequestAnimDict(dict)
                                                            while (not HasAnimDictLoaded(dict)) do Wait(0) end
                                                            TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0,
                                                                false, false, false)
                                                            ProgressBar(1500, locale('taking', v.Label))
                                                            TriggerServerEvent("d-houserobbery:robbedpropstatic",
                                                                v.model, house, k, nil, false)
                                                        else
                                                            TaskStartScenarioInPlace(cache.ped, "PROP_HUMAN_BUM_BIN", 0,
                                                                true)
                                                            ProgressBar(4500, locale('taking', v.Label))
                                                        end
                                                        ClearPedTasks(cache.ped)
                                                        objects = GetGamePool("CObject")
                                                        for i = 1, #objects do
                                                            if v.model == GetEntityModel(objects[i]) then
                                                                TriggerServerEvent('d-houserobbery:propcheck',
                                                                    objects[i], k, house, GetEntityModel(objects[i]))
                                                            end
                                                        end
                                                        doingAction = false
                                                        carrying = true
                                                        text = locale("TextUI")
                                                        SetTimeout(1000, function()
                                                            if v.model == GetEntityModel(objects[i]) then
                                                                TriggerServerEvent('d-houserobbery:propcheck',
                                                                    objects[i], k, house, GetEntityModel(objects[i]))
                                                            end
                                                        end)
                                                        if v.NeedTrunk then
                                                            Notify('info', locale('info'), locale('LeaveHouse'))
                                                            TextUIShow(text)
                                                            while carrying and not Placing do
                                                                Wait(0)
                                                                if not IsTextUIShowed() then
                                                                    TextUIShow(text)
                                                                end
                                                                if not IsEntityPlayingAnim(cache.ped, v.CarryAnim.dict, v.CarryAnim.anim, 3) and not leaving then
                                                                    local hash = v.model
                                                                    RequestModel(hash)
                                                                    while not HasModelLoaded(hash) do
                                                                        Wait(100)
                                                                        RequestModel(hash)
                                                                    end
                                                                    AttachedProp = CreateObject(hash,
                                                                        GetEntityCoords(cache.ped), true, true, false)

                                                                    AttachEntityToEntity(AttachedProp, cache.ped,
                                                                        GetPedBoneIndex(cache.ped, v.propPlacement.bone),
                                                                        v.propPlacement.pos, v.propPlacement.rot, true,
                                                                        true, false, false, 1, true)

                                                                    dict = v.CarryAnim.dict
                                                                    clip = v.CarryAnim.anim
                                                                    CurrentProp = AttachedProp
                                                                    RequestAnimDict(dict)
                                                                    while (not HasAnimDictLoaded(dict)) do Wait(0) end
                                                                    TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49,
                                                                        0, false, false, false)
                                                                    --doingAction = false
                                                                end
                                                                if IsControlJustReleased(0, 104) and not Pressed then
                                                                    local ped = cache.ped
                                                                    local coordA = GetEntityCoords(ped, true)
                                                                    local coordB = GetOffsetFromEntityInWorldCoords(ped,
                                                                        0.0, 5.0, 0.0)
                                                                    local vehicle = getVehicleInDirection(coordA, coordB)
                                                                    if DoesEntityExist(vehicle) and IsVehicleSeatFree(vehicle, -1) then
                                                                        local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(vehicle))
                                                                        if dist <= 3.5 then
                                                                            if GetEntityBoneIndexByName(vehicle, "boot") ~= -1 then
                                                                                SetVehicleDoorOpen(vehicle, 5, false,
                                                                                    false)
                                                                            else
                                                                                local boneId = GetEntityBoneIndexByName(
                                                                                vehicle, 'door_pside_r')

                                                                                if boneId ~= -1 then
                                                                                    SetVehicleDoorOpen(vehicle, 3, false,
                                                                                        false)
                                                                                end
                                                                                local boneId2 = GetEntityBoneIndexByName(
                                                                                vehicle, 'door_dside_r')

                                                                                if boneId2 ~= -1 then
                                                                                    SetVehicleDoorOpen(vehicle, 2, false,
                                                                                        false)
                                                                                end
                                                                            end
                                                                            local model = GetEntityModel(CurrentProp)
                                                                            SetEntityAsMissionEntity(CurrentProp, true,
                                                                                true)
                                                                            RemoveProp(v.Item, CurrentProp, v.NeedTrunk,
                                                                                vehicle, model, "static", house, k)
                                                                            Pressed = true
                                                                            carrying = false
                                                                            Pressed = false
                                                                        else
                                                                            Notify("error", locale("error"),
                                                                                locale("Trunk"))
                                                                        end
                                                                    else
                                                                        Notify("error", locale("error"), locale("Trunk"))
                                                                    end
                                                                end
                                                                if IsControlJustReleased(0, 47) and not Pressed then
                                                                    if not currentHouse then
                                                                        PlaceObject(GetEntityModel(CurrentProp),
                                                                            locale("PutDown"), CurrentProp, 0.0, house)
                                                                        Pressed = true
                                                                        local model = GetEntityModel(CurrentProp)
                                                                        for _, v in pairs(GetGamePool('CObject')) do
                                                                            if IsEntityAttachedToEntity(cache.ped, v) then
                                                                                if GetEntityModel(v) == model then
                                                                                    SetEntityAsMissionEntity(v, true,
                                                                                        true)
                                                                                    DeleteObject(v)
                                                                                end
                                                                            end
                                                                        end
                                                                        carrying = false
                                                                        Pressed = false
                                                                    end
                                                                end
                                                            end
                                                        else
                                                            local model = GetEntityModel(CurrentProp)
                                                            SetEntityAsMissionEntity(CurrentProp, true, true)
                                                            RemoveProp(v.Item, CurrentProp, v.NeedTrunk, vehicle, model,
                                                                "static", house, k)
                                                            Pressed = true
                                                            carrying = false
                                                            Pressed = false
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end,
                                    icon = "fas fa-door-open",
                                    label = v.Label
                                }
                            },
                            distance = 1.0
                        })
                    end
                end
            end
        end
    end
end

function PlaceObject(prop, text, entity, heading, house)
    if not Placing then
        Placing = true
        carrying = false
        Wait(100)
        local ped = cache.ped
        dict = "anim@heists@money_grab@briefcase"
        clip = "put_down_case"
        RequestAnimDict(dict)
        while (not HasAnimDictLoaded(dict)) do Wait(0) end
        TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
        ProgressBar(1000, text)
        Wait(100)
        local model = prop
        while not HasModelLoaded(model) do
            RequestModel(model)
            Wait(0)
        end
        ClearPedTasks(ped)
        lib.hideTextUI()
        position = GetOffsetFromEntityInWorldCoords(ped, 0, 1.1, -0.98)
        local object = CreateObject(model, position, true, false)
        PlaceObjectOnGroundProperly(object)
        --table.insert(AllObjects, object)
        Placing = false
        Pressed = false
        SetEntityHeading(object, GetEntityHeading(ped) + heading)
        for k, v in pairs(Config.HousesToRob[house].Residence.StaticProps) do
            if v.model == prop then
                coords = GetEntityCoords(object)
                if not zonesmaked[house .. k .. coords] and not IsEntityAttached(object) then
                    zonesmaked[house .. k .. coords] = true
                    Spheres[house .. k] = lib.zones.sphere({
                        coords = GetEntityCoords(object),
                        radius = 2,
                        debug = Config.Debug,
                        inside = function(self)
                            objects = GetGamePool("CObject")
                            for i = 1, #objects do
                                if model == GetEntityModel(objects[i]) then
                                    if Config.InteractionType == "3dtext" then
                                        local playerPos = GetEntityCoords(PlayerPedId())
                                        local objPos = GetEntityCoords(objects[i])
                                        local distance = #(playerPos - objPos)
                                        if distance <= 2 then
                                            Draw3DText(GetEntityCoords(objects[i]), locale('Take3D') .. v.Label)
                                        end
                                    end
                                    object = objects[i]
                                    if (IsControlJustReleased(0, 38) and not doingAction) then
                                        Spheres[house .. k]:remove()
                                        if DoesEntityExist(object) and not IsEntityAttached(object) then
                                            if IsControlJustReleased(0, 38) and not doingAction and not carrying then
                                                doingAction = true
                                                TaskStartScenarioInPlace(cache.ped, "PROP_HUMAN_BUM_BIN", 0, true)
                                                ProgressBar(7500, locale('taking', v.Label))
                                                objects = GetGamePool("CObject")
                                                for i = 1, #objects do
                                                    if model == GetEntityModel(objects[i]) then
                                                        SetEntityAlpha(objects[i], 0)
                                                        if DoesEntityExist(objects[i]) then
                                                            TriggerServerEvent("d-houserobbery:PickUp",
                                                                ObjToNet(objects[i]))
                                                        else
                                                            TriggerServerEvent("d-houserobbery:PickUp", objects[i])
                                                        end
                                                    end
                                                end
                                                ClearPedTasks(cache.ped)
                                                doingAction = false
                                                carrying = true
                                                text = locale("TextUI")
                                                TextUIShow(text)
                                                while carrying and not Placing do
                                                    Wait(0)
                                                    if not IsTextUIShowed() then
                                                        TextUIShow(text)
                                                    end
                                                    if not IsEntityPlayingAnim(cache.ped, v.CarryAnim.dict, v.CarryAnim.anim, 3) and not leaving then
                                                        local hash = v.model
                                                        RequestModel(hash)
                                                        while not HasModelLoaded(hash) do
                                                            Wait(100)
                                                            RequestModel(hash)
                                                        end
                                                        AttachedProp = CreateObject(hash, GetEntityCoords(cache.ped),
                                                            true, true, false)

                                                        AttachEntityToEntity(AttachedProp, cache.ped,
                                                            GetPedBoneIndex(cache.ped, v.propPlacement.bone),
                                                            v.propPlacement.pos, v.propPlacement.rot, true, true, false,
                                                            false, 1, true)

                                                        dict = v.CarryAnim.dict
                                                        clip = v.CarryAnim.anim
                                                        CurrentProp = AttachedProp
                                                        RequestAnimDict(dict)
                                                        while (not HasAnimDictLoaded(dict)) do Wait(0) end
                                                        TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false,
                                                            false, false)
                                                        --doingAction = false
                                                    end
                                                    if IsControlJustReleased(0, 104) and not Pressed then
                                                        local coordA = GetEntityCoords(ped, true)
                                                        local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0,
                                                            0.0)
                                                        local vehicle = getVehicleInDirection(coordA, coordB)
                                                        if DoesEntityExist(vehicle) and IsVehicleSeatFree(vehicle, -1) then
                                                            local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(vehicle))
                                                            if dist <= 3.5 then
                                                                if GetEntityBoneIndexByName(vehicle, "boot") ~= -1 then
                                                                    SetVehicleDoorOpen(vehicle, 5, false, false)
                                                                else
                                                                    local boneId = GetEntityBoneIndexByName(vehicle,
                                                                        'door_pside_r')

                                                                    if boneId ~= -1 then
                                                                        SetVehicleDoorOpen(vehicle, 3, false, false)
                                                                    end
                                                                    local boneId2 = GetEntityBoneIndexByName(vehicle,
                                                                        'door_dside_r')

                                                                    if boneId2 ~= -1 then
                                                                        SetVehicleDoorOpen(vehicle, 2, false, false)
                                                                    end
                                                                end
                                                                local model = GetEntityModel(CurrentProp)
                                                                SetEntityAsMissionEntity(CurrentProp, true, true)
                                                                RemoveProp(v.Item, CurrentProp, v.NeedTrunk, vehicle,
                                                                    model, "static", house, k)
                                                                Pressed = true
                                                                carrying = false
                                                                Pressed = false
                                                            else
                                                                Notify("error", locale("error"), locale("Trunk"))
                                                            end
                                                        else
                                                            Notify("error", locale("error"), locale("Trunk"))
                                                        end
                                                    end
                                                    if IsControlJustReleased(0, 47) and not Pressed then
                                                        if not currentHouse then
                                                            PlaceObject(GetEntityModel(CurrentProp), locale("PutDown"),
                                                                CurrentProp, 0.0, house)
                                                            Pressed = true
                                                            local model = GetEntityModel(CurrentProp)
                                                            for _, v in pairs(GetGamePool('CObject')) do
                                                                if IsEntityAttachedToEntity(cache.ped, v) then
                                                                    if GetEntityModel(v) == model then
                                                                        SetEntityAsMissionEntity(v, true, true)
                                                                        DeleteObject(v)
                                                                    end
                                                                end
                                                            end
                                                            carrying = false
                                                            Pressed = false
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end,
                        onEnter = function()
                            if not IsEntityAttached(object) and not currentHouse then
                                objects = GetGamePool("CObject")
                                for i = 1, #objects do
                                    if v.model == GetEntityModel(objects[i]) then
                                        if Config.InteractionType ~= "3dtext" then
                                            TextUIShow(locale('Take') .. v.Label)
                                        end
                                    end
                                end
                            end
                        end,
                        onExit = function()
                            if Config.InteractionType ~= "3dtext" then
                                TextUIHide()
                            end
                        end
                    })
                end
            end
        end
        for k, v in pairs(Config.HousesToRob[house].Residence.CreateProps) do
            local objects = GetGamePool("CObject")
            for i = 1, #objects do
                if v.model == prop then
                    coords = GetEntityCoords(object)
                    if not zonesmaked[house .. coords] and not IsEntityAttached(objects[i]) and object == objects[i] then
                        zonesmaked[house .. coords] = true
                        Spheres[house .. k] = lib.zones.sphere({
                            coords = GetEntityCoords(objects[i]),
                            radius = 2,
                            debug = Config.Debug,
                            inside = function(self)
                                objects = GetGamePool("CObject")
                                for i = 1, #objects do
                                    if v.model == GetEntityModel(objects[i]) then
                                        if Config.InteractionType == "3dtext" then
                                            local playerPos = GetEntityCoords(PlayerPedId())
                                            local objPos = GetEntityCoords(objects[i])
                                            local distance = #(playerPos - objPos)
                                            if distance <= 2 then
                                                Draw3DText(GetEntityCoords(objects[i]), locale('Take3D') .. v.Label)
                                            end
                                        end
                                        if (IsControlJustReleased(0, 38) and not doingAction) then
                                            object = objects[i]
                                            Spheres[house .. k]:remove()
                                            if DoesEntityExist(object) and not IsEntityAttached(object) then
                                                if IsControlJustReleased(0, 38) and not doingAction and not carrying then
                                                    doingAction = true
                                                    TaskStartScenarioInPlace(cache.ped, "PROP_HUMAN_BUM_BIN", 0, true)
                                                    ProgressBar(7500, locale('taking', v.Label))
                                                    objects = GetGamePool("CObject")
                                                    for i = 1, #objects do
                                                        if model == GetEntityModel(objects[i]) then
                                                            if DoesEntityExist(objects[i]) and NetworkGetEntityIsNetworked(objects[i]) then
                                                                TriggerServerEvent("d-houserobbery:PickUp",
                                                                    ObjToNet(objects[i]))
                                                            else
                                                                TriggerServerEvent("d-houserobbery:PickUp", objects[i])
                                                            end
                                                            DeleteEntity(objects[i])
                                                            SetEntityAlpha(objects[i], 0)
                                                        end
                                                    end
                                                    DeleteEntity(object)
                                                    if DoesEntityExist(object) and NetworkGetEntityIsNetworked(object) then
                                                        TriggerServerEvent("d-houserobbery:removeobject",
                                                            ObjToNet(object))
                                                    else
                                                        TriggerServerEvent("d-houserobbery:removeobject", object)
                                                    end
                                                    ClearPedTasks(cache.ped)
                                                    doingAction = false
                                                    carrying = true
                                                    text = locale("TextUI")
                                                    TextUIShow(text)
                                                    while carrying and not Placing do
                                                        Wait(0)
                                                        if not IsTextUIShowed() then
                                                            TextUIShow(text)
                                                        end
                                                        if not IsEntityPlayingAnim(cache.ped, v.CarryAnim.dict, v.CarryAnim.anim, 3) and not leaving then
                                                            local hash = v.model
                                                            RequestModel(hash)
                                                            while not HasModelLoaded(hash) do
                                                                Wait(100)
                                                                RequestModel(hash)
                                                            end
                                                            AttachedProp = CreateObject(hash, GetEntityCoords(cache.ped),
                                                                true, true, false)

                                                            AttachEntityToEntity(AttachedProp, cache.ped,
                                                                GetPedBoneIndex(cache.ped, v.propPlacement.bone),
                                                                v.propPlacement.pos, v.propPlacement.rot, true, true,
                                                                false, false, 1, true)

                                                            dict = v.CarryAnim.dict
                                                            clip = v.CarryAnim.anim
                                                            CurrentProp = AttachedProp
                                                            RequestAnimDict(dict)
                                                            while (not HasAnimDictLoaded(dict)) do Wait(0) end
                                                            TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0,
                                                                false, false, false)
                                                            --doingAction = false
                                                        end
                                                        if IsControlJustReleased(0, 104) and not Pressed then
                                                            local coordA = GetEntityCoords(ped, true)
                                                            local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0,
                                                                0.0)
                                                            local vehicle = getVehicleInDirection(coordA, coordB)
                                                            if DoesEntityExist(vehicle) and IsVehicleSeatFree(vehicle, -1) then
                                                                local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(vehicle))
                                                                if dist <= 3.5 then
                                                                    if GetEntityBoneIndexByName(vehicle, "boot") ~= -1 then
                                                                        SetVehicleDoorOpen(vehicle, 5, false, false)
                                                                    else
                                                                        local boneId = GetEntityBoneIndexByName(vehicle,
                                                                            'door_pside_r')

                                                                        if boneId ~= -1 then
                                                                            SetVehicleDoorOpen(vehicle, 3, false, false)
                                                                        end
                                                                        local boneId2 = GetEntityBoneIndexByName(vehicle,
                                                                            'door_dside_r')

                                                                        if boneId2 ~= -1 then
                                                                            SetVehicleDoorOpen(vehicle, 2, false, false)
                                                                        end
                                                                    end
                                                                    local model = GetEntityModel(CurrentProp)
                                                                    SetEntityAsMissionEntity(CurrentProp, true, true)
                                                                    RemoveProp(v.Item, CurrentProp, v.NeedTrunk, vehicle,
                                                                        model, "created", house, k)
                                                                    Pressed = true
                                                                    carrying = false
                                                                    Pressed = false
                                                                else
                                                                    Notify("error", locale("error"), locale("Trunk"))
                                                                end
                                                            else
                                                                Notify("error", locale("error"), locale("Trunk"))
                                                            end
                                                        end
                                                        if IsControlJustReleased(0, 47) and not Pressed then
                                                            if not currentHouse then
                                                                PlaceObject(GetEntityModel(AttachedProp),
                                                                    locale("PutDown"), AttachedProp, 0.0, house)
                                                                Pressed = true
                                                                local model = GetEntityModel(CurrentProp)
                                                                for _, v in pairs(GetGamePool('CObject')) do
                                                                    if IsEntityAttachedToEntity(cache.ped, v) then
                                                                        if GetEntityModel(v) == model then
                                                                            SetEntityAsMissionEntity(v, true, true)
                                                                            DeleteObject(v)
                                                                        end
                                                                    end
                                                                end
                                                                carrying = false
                                                                Pressed = false
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end,
                            onEnter = function()
                                if not IsEntityAttached(object) and not currentHouse then
                                    objects = GetGamePool("CObject")
                                    for i = 1, #objects do
                                        if v.model == GetEntityModel(objects[i]) then
                                            if Config.InteractionType ~= "3dtext" then
                                                TextUIShow(locale('Take3D') .. v.Label)
                                            end
                                        end
                                    end
                                end
                            end,
                            onExit = function()
                                if Config.InteractionType ~= "3dtext" then
                                    TextUIHide()
                                end
                            end
                        })
                    end
                end
            end
        end
    end
end

RegisterNetEvent("d-houserobbery:deleteObject")
AddEventHandler("d-houserobbery:deleteObject", function(netId)
    if NetworkDoesEntityExistWithNetworkId(netId) then
        local entity = NetToObj(netId)
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end
end)

RegisterNetEvent("d-houserobbery:propcheck")
AddEventHandler("d-houserobbery:propcheck", function(object, value, house, model)
    if currentHouse == house then
        local objects = GetGamePool("CObject")
        for i = 1, #objects do
            local propalpha = 255
            for k, v in pairs(Config.HousesToRob[house].Residence.StaticProps) do
                if v.model == GetEntityModel(objects[i]) and v.model == model and not IsEntityAttached(objects[i]) then
                    SetEntityAlpha(objects[i], propalpha, false)
                    if currentHouse == house then
                        for _, place in each(housesData[currentHouse].robbed) do
                            if place == value then
                                propRobbed[house .. value] = true
                            end
                        end
                        if propRobbed[house .. value] then
                            propalpha = 0
                            SetEntityCollision(objects[i], false, true)
                            SetEntityAlpha(objects[i], propalpha, false)
                        else
                            propalpha = 255
                        end
                        SetEntityAsMissionEntity(objects[i], true, false)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("d-houserobbery:propcheck2")
AddEventHandler("d-houserobbery:propcheck2", function(object, value, house, model)
    if currentHouse == house then
        local objects = GetGamePool("CObject")
        for i = 1, #objects do
            local propalpha = 255
            for k, v in pairs(Config.HousesToRob[house].Residence.CreateProps) do
                if v.model == GetEntityModel(objects[i]) and k == value and not IsEntityAttached(objects[i]) then
                    SetEntityAlpha(objects[i], 255, false)
                    if currentHouse == house then
                        for _, place in each(housesData[currentHouse].robbed) do
                            if place == value == k then
                                propRobbed[house .. value] = true
                            end
                        end
                        if propRobbed[house .. value] then
                            propalpha = 0
                            SetEntityCollision(objects[i], false, true)
                            SetEntityAlpha(objects[i], propalpha, false)
                        else
                            propalpha = 255
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("d-houserobbery:lasercheck")
AddEventHandler("d-houserobbery:lasercheck", function(laser, house)
    Wait(1500)
    if currentHouse == house then
        if HouseHacked[house] then
            for b, g in pairs(Lasers) do
                g.setActive(false)
                g.setVisible(true)
            end
        else
            for k, v in pairs(Config.HousesToRob[house].Residence.Lasers) do
                if "Laser" .. k == laser.name and not v.spawned then
                    if not HouseHacked[house] then
                        hittedbylaser = false
                        v.spawned = true
                        local k = Laser.new(
                            v.FromCoords,
                            { v.ToCoords },
                            { travelTimeBetweenTargets = { 1.0, 1.0 }, waitTimeAtTargets = { 0.0, 0.0 },
                                randomTargetSelection = true, name = "Laser" .. k }
                        )
                        k.setVisible(true)
                        k.setActive(true)
                        k.setMoving(true)
                        if HousePowdered[house] then
                            k.setColor(255, 0, 0, 100)
                        else
                            if v.Visible then
                                k.setColor(255, 0, 0, 100)
                            else
                                k.setColor(255, 0, 0, 0)
                            end
                        end
                        k.onPlayerHit(function(playerBeingHit, hitPos)
                            if playerBeingHit and not hittedbylaser then
                                hittedbylaser = true
                                AlarmSound()
                                Dispatch(Config.HousesToRob[house].Coords.xyz, "houserobbery")
                                Notify('error', locale('Alarm'), locale('startedalarm'))
                            end
                        end)
                        table.insert(Lasers, k)
                        TriggerServerEvent('d-houserobbery:lasercheck', k, house)
                        TriggerServerEvent("d-houserobbery:CheckHackedHouse", house)
                    end
                end
            end
            -- for b, g in pairs(Lasers) do
            --     if g.name == laser.name then
            --         g.setVisible(true)
            --         g.setActive(true)
            --         g.setMoving(true)
            --         if HousePowdered[house] then
            --             g.setColor(255, 0, 0, 100)
            --         end
            --     end
            -- end
        end
    end
end)

RegisterNetEvent("d-houserobbery:PowderSync")
AddEventHandler("d-houserobbery:PowderSync", function(house)
    if currentHouse == house then
        if not HouseHacked[house] then
            for b, g in pairs(Lasers) do
                g.setColor(255, 0, 0, 100)
                HousePowdered[house] = true
            end
        end
    end
end)

RegisterNetEvent("d-houserobbery:HackedSync")
AddEventHandler("d-houserobbery:HackedSync", function(house)
    if currentHouse == house then
        HouseHacked[house] = true
        for b, g in pairs(Lasers) do
            g.setActive(false)
            g.setVisible(true)
        end
    end
end)

RegisterNetEvent("d-houserobbery:LaserSync")
AddEventHandler("d-houserobbery:LaserSync", function(house)
    if currentHouse == house then
        HouseLasered[house] = true
    end
end)

RegisterNetEvent("d-houserobbery:PickUpProp")
AddEventHandler("d-houserobbery:PickUpProp", function(netId)
    if NetworkDoesEntityExistWithNetworkId(netId) then
        local entity = NetToObj(netId)
        if DoesEntityExist(entity) then
            SetEntityAlpha(entity, 0, false)
            SetEntityCollision(entity, false, true)
            DeleteEntity(entity)
        end
    end
end)


function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10,
        PlayerPedId(), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

function RemoveProp(item, entity, TrunkNeeded, vehicle, model, type, house, place)
    lib.hideTextUI()
    ClearPedTasks(cache.ped)
    if TrunkNeeded then
        if vehicle then
            dict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
            clip = "plant_floor"
            RequestAnimDict(dict)
            while (not HasAnimDictLoaded(dict)) do Wait(0) end
            TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
            Wait(100)
            ProgressBar(1000, locale("TrunkPut"))
            ClearPedTasks(cache.ped)
            if DoesEntityExist(entity) then
                if type == "created" then
                    TriggerServerEvent("d-houserobbery:robbedpropcreated", model, house, place, ObjToNet(entity),
                        TrunkNeeded)
                else
                    TriggerServerEvent("d-houserobbery:robbedpropstatic", model, house, place, ObjToNet(entity),
                        TrunkNeeded)
                end
            end

            if GetEntityBoneIndexByName(vehicle, "boot") ~= -1 then
                SetVehicleDoorShut(vehicle, 5, false, false)
            else
                local boneId = GetEntityBoneIndexByName(vehicle, 'door_pside_r')

                if boneId ~= -1 then
                    SetVehicleDoorShut(vehicle, 3, false, false)
                end
                local boneId2 = GetEntityBoneIndexByName(vehicle, 'door_dside_r')

                if boneId2 ~= -1 then
                    SetVehicleDoorShut(vehicle, 2, false, false)
                end
            end
        end
        --else
        --    if DoesEntityExist(entity) then
        --     if type == "created" then
        --       TriggerServerEvent("d-houserobbery:robbedpropcreated", model, house, place, ObjToNet(entity), TrunkNeeded)
        --   else
        --      TriggerServerEvent("d-houserobbery:robbedpropstatic", model, house, place, ObjToNet(entity), TrunkNeeded)
        -- end
        --end
    end
    for _, v in pairs(GetGamePool('CObject')) do
        if IsEntityAttachedToEntity(cache.ped, v) then
            if GetEntityModel(v) == model then
                SetEntityAsMissionEntity(v, true, true)
                DeleteObject(v)
            end
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, v in pairs(AllObjects) do
            SetEntityAsMissionEntity(v, false, true)
            DeleteObject(v)
            if DoesEntityExist(v) then
                TriggerServerEvent("d-houserobbery:removeobject", ObjToNet(v))
            end
        end
        for _, v in pairs(CreatedProps) do
            SetEntityAsMissionEntity(v, false, true)
            DeleteObject(v)
            if DoesEntityExist(v) then
                TriggerServerEvent("d-houserobbery:removeobject", ObjToNet(v))
            end
        end
    end
end)

function doAnimation()
    if not Hacking then return end
    RequestAnimDict(tabletDict)
    while not HasAnimDictLoaded(tabletDict) do Wait(100) end
    RequestModel(tabletProp)
    while not HasModelLoaded(tabletProp) do Wait(100) end
    local ped = PlayerPedId()
    tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
    local tabletBoneIndex = GetPedBoneIndex(ped, tabletBone)
    AttachEntityToEntity(tabletObj, ped, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x,
        tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
    SetModelAsNoLongerNeeded(tabletProp)
    CreateThread(function()
        while Hacking do
            Wait(0)
            if not IsEntityPlayingAnim(ped, tabletDict, tabletAnim, 3) then
                TaskPlayAnim(ped, tabletDict, tabletAnim, 3.0, 1.0, -1, 49, 0, false, false, false)
            end
        end
        ClearPedSecondaryTask(ped)
        Wait(250)
        DetachEntity(tabletObj, true, false)
        DeleteEntity(tabletObj)
    end)
end

function doLockpickAnimation(coords)
    if not Lockpicking then return end
    local Lockpickprop = `prop_tool_screwdvr01`
    RequestAnimDict("mp_arresting")
    while not HasAnimDictLoaded("mp_arresting") do Wait(100) end
    RequestModel(Lockpickprop)
    while not HasModelLoaded(Lockpickprop) do Wait(100) end
    local ped = PlayerPedId()
    lockpickobject = CreateObject(Lockpickprop, 0.0, 0.0, 0.0, true, true, false)
    local LockpickBoneIndex = GetPedBoneIndex(ped, 57005)
    AttachEntityToEntity(lockpickobject, ped, LockpickBoneIndex, 0.14, 0.06, 0.02, 51.0, -90.0, -40.0, true, true, false,
        false, 1, true)
    SetModelAsNoLongerNeeded(Lockpickprop)
    TaskTurnPedToFaceCoord(cache.ped, coords, 1000)
    CreateThread(function()
        while Lockpicking do
            Wait(0)
            if not IsEntityPlayingAnim(ped, "mp_arresting", "a_uncuff", 3) then
                TaskPlayAnim(ped, "mp_arresting", "a_uncuff", 3.0, 1.0, -1, 49, 0, false, false, false)
            end
        end
        ClearPedSecondaryTask(ped)
        Wait(250)
        DetachEntity(lockpickobject, true, false)
        DeleteEntity(lockpickobject)
    end)
end

if Config.InteractionType == 'target' and Config.HouseType == "OnlyMission" then
    SetTimeout(1000, function()
        local target = Target()
        if target then
            if not missionzones[houseid] then
                missionzones[houseid] = target:AddCircleZone("d-houserobbery_RobHouse_".. houseid, Config.HousesToRob[houseid].Coords.xyz, 1.5, {
                    name = "d-houserobbery_RobHouse_".. houseid,
                    debugPoly = Config.Debug,
                }, {
                    options = {
                        {  
                            icon = 'fas fa-house',
                            label = locale('breakdoor_label'),
                            action = function()
                                enterHouse(houseid, true)
                            end,
                            canInteract = function()
                                return not enterable(houseid)
                            end
                        },
                        {  
                            icon = 'fas fa-house',
                            label = locale('enter_label'),
                            action = function()
                                enterHouse(houseid, false)
                            end,
                            canInteract = function()
                                return enterable(houseid)
                            end
                        }   
                    },
                    distance = 2.5,
                })
            end
        else
            print("TEMP5")
        end
    end)
end
