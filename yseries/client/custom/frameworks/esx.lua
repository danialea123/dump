CreateThread(function()
    if Config.Framework ~= "esx" then return end

    debugPrint("Phone:ESX:Loading Framework")

    OnPlayerLoadedEvent = "esx:playerLoaded"
    OnPlayerUnloadedEvent = "esx:onPlayerLogout"
    OnJobUpdateEvent = "esx:setJob"

    PlayerData = {}

    local export, Framework = pcall(function()
        return exports.es_extended:getSharedObject()
    end)

    if not export then
        while not Framework do
            TriggerEvent("esx:getSharedObject", function(obj)
                Framework = obj
            end)

            Wait(500)
        end
    end

    CreateThread(function()
        while Framework.GetPlayerData().job == nil do
            Wait(100)
        end

        PlayerData = Framework.GetPlayerData()
    end)

    RegisterNetEvent(OnPlayerLoadedEvent, function(xPlayer)
        PlayerData = xPlayer

        Framework.PlayerLoaded = true

        local phoneImei = lib.callback.await('yseries:server:get-primary-phone', false, PlayerData.identifier)
        if phoneImei then
            debugPrint('Found phone for player: ', PlayerData.identifier, ' with imei: ', phoneImei)

            DataLoaded = false
            LoadPhoneData(phoneImei)
        else
            debugPrint('OnPlayerLoadedEvent: No phone found for player: ', PlayerData.identifier)
        end

        if GroupId ~= nil then
            TriggerServerEvent("yseries:server:groups:leave", GroupId)

            CurrentJobStage = "WAITING"
            GroupId = 0

            IsGroupLeader = false

            for i = 1, #GroupBlips do
                RemoveBlip(GroupBlips[i]["blip"])
                GroupBlips[i] = nil
            end
        end
    end)

    RegisterNetEvent(OnPlayerUnloadedEvent, function()
        TriggerServerEvent('yseries:server:cleanup')

        TriggerServerEvent('yseries:server:players:remove')

        PlayerData.identifier = nil

        ToggleOpen(false)
        HasPrimaryPhone = false

        SendUIAction('main:reset-phone-ui')
    end)

    while not Framework.PlayerLoaded do
        Wait(500)
    end

    RegisterNetEvent("esx:setJob", function(job)
        PlayerData.job = job
    end)

    debugPrint("Phone:ESX:Framework loaded")

    -- * Check if a player has a phone item.
    function HasPhoneItem(phoneImei)
        if not Config.Item.Require then
            return true
        end

        -- Check for unique phone IMEI in the inventory if required
        if GetResourceState("ox_inventory") == "started" then
            if Config.Item.UniquePhones and phoneImei then
                return HasImeiIdentifier(phoneImei)
            else
                -- Iterate through Config.UseableItems to check each one in the inventory
                for _, itemName in ipairs(Config.UseableItems) do
                    if (exports.ox_inventory:Search("count", itemName) or 0) > 0 then
                        return true
                    end
                end
            end
        else
            -- Fallback for other inventory systems not using ox_inventory
            local inventory = Framework.GetPlayerData()?.inventory
            if not inventory then
                print("^6[YSERIES] ^3[Warning]^0: Unsupported inventory, tell the inventory author to add support for it.")
                return false
            end

            for _, item in ipairs(inventory) do
                if lib.table.contains(Config.UseableItems, item.name) and item.count > 0 then
                    return true
                end
            end
        end

        return false
    end

    function GetCompanyEmployees(job)
        local employeesData = {}

        local employeesPromise = promise.new()
        Framework.TriggerServerCallback("esx_society:getEmployees", function(employees)
            employeesData = employees
            for i = 1, #employeesData do
                local employee = employees[i]

                employeesData[i] = {
                    source = lib.callback.await('yseries:server:get-player-source-by-citizen-id', false,
                        employee.identifier),
                    playerId = employee.identifier,
                }
            end

            employeesPromise:resolve()
        end, job)

        Citizen.Await(employeesPromise)

        return employeesData
    end

    -- * Get company data based on the player's job and grade.
    function GetCompanyData()
        local jobData = {
            job = PlayerData.job.name,
            jobLabel = PlayerData.job.label,
            gradeLevel = PlayerData.job.grade,
            gradeLabel = PlayerData.job.grade_label,
            payment = PlayerData.job.grade_salary,
            isBoss = PlayerData.job.grade_name == "boss"
        }

        if not jobData.isBoss then
            for cId = 1, #Config.Companies.Services do
                local company = Config.Companies.Services[cId]
                if company.job == jobData.job then
                    if not company.bossRanks then
                        break
                    end

                    for i = 1, #company.bossRanks do
                        if company.bossRanks[i] == PlayerData.job.grade_name then
                            jobData.isBoss = true
                            break
                        end
                    end

                    break
                end
            end
        end

        if jobData.isBoss then
            jobData.balance = lib.callback.await('yseries:server:banking:get-balance')

            local employeesPromise = promise.new()
            Framework.TriggerServerCallback("esx_society:getEmployees", function(employees)
                jobData.employees = employees
                for i = 1, #employees do
                    local employee = employees[i]

                    employees[i] = {
                        name = employee.name,
                        id = employee.identifier,

                        gradeLabel = employee.job.grade_label,
                        grade = employee.job.grade,

                        canInteract = employee.job.grade_name ~= "boss"
                    }
                end
                employeesPromise:resolve()
            end, jobData.job)

            Citizen.Await(employeesPromise)

            local gradesPromise = promise.new()
            Framework.TriggerServerCallback("esx_society:getJob", function(job)
                local grades = {}
                for i = 1, #job.grades do
                    local grade = job.grades[i]
                    grades[i] = {
                        label = grade.label,
                        grade = grade.grade
                    }
                end

                jobData.grades = grades

                gradesPromise:resolve()
            end, jobData.job)

            Citizen.Await(gradesPromise)
        end

        return jobData
    end

    -- * Hire an employee.
    function HireEmployee(source, cb)
        Framework.TriggerServerCallback("esx_society:getOnlinePlayers", function(players)
            for i = 1, #players do
                local player = players[i]
                if player.source == source then
                    Framework.TriggerServerCallback("esx_society:setJob", function()
                        cb({
                            name = player.name,
                            id = player.identifier
                        })
                    end, player.identifier, PlayerData.job.name, 0, "hire")

                    return
                end
            end
        end)
    end

    -- * Fire an employee.
    function FireEmployee(identifier, cb)
        Framework.TriggerServerCallback("esx_society:setJob", function()
            cb(true)
        end, identifier, "unemployed", 0, "fire")
    end

    -- * Promote/demote an employee.
    function SetGrade(identifier, newGrade, oldGrade, cb)
        Framework.TriggerServerCallback("esx_society:getJob", function(job)
            if newGrade > #job.grades - 1 then
                return cb(false)
            end

            Framework.TriggerServerCallback("esx_society:setJob", function()
                cb(true)
            end, identifier, PlayerData.job.name, newGrade, "promote")
        end, PlayerData.job.name)
    end

    -- * Toggle duty status.
    function ToggleDuty()
        -- Implement your own toggle duty function here.
        print("^6[YSERIES] ^1[ERROR]^7: client:custom:frameworks:esx.lua:ToggleDuty is not implemented")
        return { duty = true }
    end

    -- * Get the player's on duty status.
    function GetDutyStatus()
        print("^6[YSERIES] ^1[ERROR]^7: client:custom:frameworks:esx.lua:GetDutyStatus is not implemented")
        return true
    end

    function CreateFrameworkVehicle(vehicleData, coords)
        vehicleData.vehicle = json.decode(vehicleData.vehicle)

        if vehicleData.damages then
            vehicleData.damages = json.decode(vehicleData.damages)
        end

        while not HasModelLoaded(vehicleData.vehicle.model) do
            RequestModel(vehicleData.vehicle.model)
            Wait(500)
        end

        local vehicle = CreateVehicle(vehicleData.vehicle.model, coords.x, coords.y, coords.z, 0.0, true, false)
        SetVehicleOnGroundProperly(vehicle)
        SetVehicleNumberPlateText(vehicle, vehicleData.vehicle.plate)

        Framework.Game.SetVehicleProperties(vehicle, vehicleData.vehicle)

        if vehicleData.damages then
            SetVehicleEngineHealth(vehicle, vehicleData.damages.engineHealth)
            SetVehicleBodyHealth(vehicle, vehicleData.damages.bodyHealth)
        end

        if vehicleData.vehicle.fuel then
            exports["LegacyFuel"]:SetFuel(vehicle, vehicleData.vehicle.fuel)
        end

        SetModelAsNoLongerNeeded(vehicleData.vehicle.model)

        return vehicle
    end

    -- * Send a notification to a player.
    function Notify(messageData)
        lib.notify(messageData)
    end
end)
