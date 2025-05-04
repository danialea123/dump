---@diagnostic disable: param-type-mismatch, missing-parameter
lib.locale()

if Config.HouseType == "OnlyMission" or Config.HouseType == "Both" then
    local missionzones = {}
    local MissionOccupied = {}
    local JobPED = nil
    local Spawned = false
    CreateThread(function()
        while true do
            Wait(1000)
            local Coords = GetEntityCoords(PlayerPedId())
            local distance = #(Coords - vec3(Config.StartMission.Ped.coords.x, Config.StartMission.Ped.coords.y, Config.StartMission.Ped.coords.z))
            if distance < 20 and not Spawned then
                Spawned = true
                RequestModel(Config.StartMission.Ped.model)

                while not HasModelLoaded(Config.StartMission.Ped.model) do
                    Wait(0)
                end

                NPC = CreatePed(4, Config.StartMission.Ped.model, Config.StartMission.Ped.coords, false, true)
                JobPED = NPC
                if Config.InteractionType == 'textui' or Config.InteractionType == "3dtext" then
                    npctxtui = lib.zones.sphere({
                        coords = GetEntityCoords(NPC),
                        radius = 1,
                        debug = Config.Debug,
                        inside = function(self)
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent('d-houserobbery:localize')
                            end

                            if Config.InteractionType == "3dtext" then
                                Draw3DText(self.coords, string.format("[~g~E~w~] - %s", locale('GetJob')))
                            end
                        end,
                        onEnter = function()
                            if Config.InteractionType == "textui" then
                                TextUIShow('[E] - ' .. locale('GetJob'))
                            end
                        end,
                        onExit = function()
                            if Config.InteractionType == "textui" then
                                TextUIHide()
                            end
                        end
                    })
                elseif Config.InteractionType == 'target' then
                    SetTimeout(1000, function()
                        local target = Target()
                        if target then
                            target:AddTargetEntity(NPC, {
                                options = {
                                    {
                                        event = "d-houserobbery:localize",
                                        icon = "fas fa-store",
                                        label = locale("GetJob"),
                                        action = function()
                                            TriggerEvent("d-houserobbery:localize")
                                        end
                                    },
                                },
                                distance = 2
                            })
                        else
                            print("TEMP2")
                        end
                    end)
                end
                for i = 0, 255, 51 do
                    Wait(50)
                    SetEntityAlpha(NPC, i, false)
                end
                FreezeEntityPosition(NPC, true)
                SetEntityInvincible(NPC, true)
                SetBlockingOfNonTemporaryEvents(NPC, true)
                TaskStartScenarioInPlace(NPC, Config.StartMission.Ped.scenario, 0, true)
            elseif distance >= 20 and Spawned then
                for i = 255, 0, -51 do
                    Wait(50)
                    SetEntityAlpha(JobPED, i, false)
                end
                DeletePed(JobPED)
                Spawned = false
                if Config.InteractionType == 'textui' then
                    npctxtui:remove()
                end
            end
        end
    end)



    local finding = false
    local AlreadyEntered = false
    local CurrentHouse = nil
    local FoundHouse = false
    local FoundChance = false
    local random_house = nil
    local notifyCalled = false
    local Blips = {}
    RegisterNetEvent("d-houserobbery:localize")
    AddEventHandler("d-houserobbery:localize", function()
        if not finding then
            if Config.StartMission.time.enabled then
                local h = GetClockHours()
                
                if Config.StartMission.time.from > Config.StartMission.time.to then
                    if h < Config.StartMission.time.from and h >= Config.StartMission.time.to then
                        Notify('success', locale('success'), locale('NoMission'))
                        return
                    end
                else
                    if h < Config.StartMission.time.from or h >= Config.StartMission.time.to then
                        Notify('success', locale('success'), locale('NoMission'))
                        return
                    end
                end
            end
            while not FoundChance do
                Wait(0)
                for k, v in each(Config.Tier) do
                    if math.random(100) <= v.chance then
                        FoundChance = k
                    end
                end
            end
            FoundHouse = nil
            local houses = {}
            for house, v in pairs(Config.HousesToRob) do
            if Config.Tier[FoundChance] == v.Residence then
                table.insert(houses, house)
                end
            end

            random_house = houses[math.random(#houses)]
            local FoundHouse = Config.HousesToRob[random_house]
            house = FoundHouse
            TriggerServerEvent('d-houserobbery:localize', 'newmission', FoundHouse)
            StartMission(house)
            FoundHouse = false
            FoundChance = false
        else
            TriggerServerEvent('d-houserobbery:localize', 'cancelmission', FoundHouse)
            Notify("success", locale("success"), locale("MissionText4"))
            RemoveMission()
        end
    end)

    RegisterNetEvent("d-houserobbery:missionoccupied")
    AddEventHandler("d-houserobbery:missionoccupied", function(house)
        MissionOccupied[house] = true
    end)


    StartMission = function(house)
        if not finding then
            if Config.StartMission.Vehicle.enabled then
                local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(Config.StartMission.Vehicle.SpawnPoints)
                if foundSpawn then
                    Notify("success", locale("success"), locale("VehicleSpawned"))
                    SpawnVehicle(Config.StartMission.Vehicle.Model, spawnPoint.Coords, spawnPoint.Heading)
                end
            end
            TriggerServerEvent('d-houserobbery:missionoccupied', house)
            finding = true
            local coords = house.Coords
            local Radius = math.random(50, 200) + 0.0
            local RadiusCoords = vec3(coords.x + math.random(10, 20), coords.y + math.random(10, 20), coords.z)
            local blip = AddBlipForRadius(RadiusCoords, Radius)
            SetBlipColour(blip, 1)
            SetBlipAlpha(blip, 128)

            local blip2 = AddBlipForCoord(RadiusCoords)
            SetBlipSprite(blip2, 492)
            SetBlipDisplay(blip2, 4)
            SetBlipScale(blip2, 0.9)
            SetBlipColour(blip2, 1)
            SetBlipAsShortRange(blip2, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(locale("HouseArea"))
            EndTextCommandSetBlipName(blip2)

            if Config.StartMission.SendToTechGuy then
                local blip3 = AddBlipForCoord(Config.Shop.Ped.coords)
                SetBlipSprite(blip3, 280)
                SetBlipDisplay(blip3, 4)
                SetBlipScale(blip3, 0.9)
                SetBlipColour(blip3, 1)
                SetBlipAsShortRange(blip3, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(Config.Shop.blip.name)
                EndTextCommandSetBlipName(blip3)

                table.insert(Blips, blip3)
                SetNewWaypoint(Config.Shop.Ped.coords.xy)
            end

            table.insert(Blips, blip)
            table.insert(Blips, blip2)

            Notify('info', locale('info'), locale('MissionText'))
            Wait(1000)
            if Config.StartMission.SendToTechGuy then
                Notify('info', locale('info'), locale('MissionText6'))
            end
            TriggerServerEvent("d-houserobbery:missionsync", random_house)
            CreateThread(function()
                local sleep = 500
                while true do
                    local Coords = GetEntityCoords(PlayerPedId())
                    local distance = #(Coords - coords.xyz)
                    if distance < 100 and not AlreadyEntered then
                        EnteredRadius(house)
                        if distance < 2 then
                            RemoveMission()
                            Notify('info', locale('info'), locale("MissionText5"))
                            break
                        end
                    else
                        AlreadyEntered = false
                    end
                    Wait(sleep)
                end
            end)
        end
    end

    EnteredRadius = function(house)
        if not AlreadyEntered then
            AlreadyEntered = true
            CurrentHouse = house
            if not notifyCalled then
                notifyCalled = true
                Notify('info', locale('info'), locale('MissionText2'))
            end
        end
    end

    RemoveMission = function()
        if finding then
            notifyCalled = false
            finding = false
            AlreadyEntered = false
            CurrentHouse = nil
            FoundHouse = false
            FoundChance = false
            random_house = nil
            for k,v in pairs(Blips) do
                RemoveBlip(v)
            end
            Blips = {}
        end
    end

    RegisterNetEvent("d-houserobbery:gethelp")
    AddEventHandler("d-houserobbery:gethelp", function()
        if finding then
            if not CurrentHouse or not AlreadyEntered then
                Notify('error', locale('error'), locale('MissionText3'))
            else
                HelpText = CurrentHouse.Hints[math.random(1, #CurrentHouse.Hints)]
                Notify('info', locale('info'), HelpText)
            end
        else
            Notify('info', locale('info'), locale("notfinding"))
        end
    end)

    RegisterNetEvent("d-houserobbery:missionsync")
    AddEventHandler("d-houserobbery:missionsync", function(houseid)
        if Config.InteractionType == 'textui' and Config.HouseType == "OnlyMission" then
            if not missionzones[houseid] then
                missionzones[houseid] = lib.zones.sphere({
                    coords = Config.HousesToRob[houseid].Coords.xyz,
                    radius = 1,
                    debug = Config.Debug,
                    inside = function(self)
                        if IsControlJustReleased(0, 38) and not doingAction then
                            if not enterable(houseid) then
                                enterHouse(houseid, true)
                            else
                                enterHouse(houseid, false)
                            end
                        end

                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, string.format("[~g~E~w~] - %s", not enterable(houseid) and locale('breakdoor_label') or locale('enter_label')))
                        end
                    end,
                    onEnter = function()
                        if Config.InteractionType == "textui" then
                            local text = locale('enter_label')
                            if not enterable(houseid) then
                                text = locale('breakdoor_label')
                            end
                            TextUIShow('[E] - ' .. text)   
                        end 
                    end,
                    onExit = function()
                        if Config.InteractionType == "textui" then
                            TextUIHide()
                        end
                    end
                })
            end
        elseif Config.InteractionType == 'target' and Config.HouseType == "OnlyMission" then
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
                                    canInteract = function(entity, distance, data)
                                        return not enterable(houseid)
                                    end
                                },
                                {  
                                    icon = 'fas fa-house',
                                    label = locale('enter_label'),
                                    action = function()
                                        enterHouse(houseid, false)
                                    end,
                                    canInteract = function(entity, distance, data)
                                        return enterable(houseid)
                                    end
                                }   
                            },
                            distance = 2.5,
                        })
                    end
                else
                    print("TEMP3")
                end
            end)
        end
    end)
end

RegisterNetEvent("d-houserobbery:missionoccupiedreset")
AddEventHandler("d-houserobbery:missionoccupiedreset", function()
    MissionOccupied = {}
end)