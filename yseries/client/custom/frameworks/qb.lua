CreateThread(function()
    if Config.Framework ~= 'qb' then return end

    debugPrint("Phone:QB:Loading Framework")

    local Framework = exports['qb-core']:GetCoreObject()

    while not LocalPlayer.state.isLoggedIn do
        Wait(500)
    end

    debugPrint("Phone:QB:Framework loaded")

    local QBPlayerData = Framework.Functions.GetPlayerData()

    PlayerData = {
        identifier = QBPlayerData.citizenid,
        job = QBPlayerData.job,
        money = QBPlayerData.money
    }

    local function onPlayerLoggedIn()
        -- * Query yphone_holders to find if there are any phones for the player.
        -- * If there are, set the current phone imei to the first one and load the phone data.
        local phoneImei = lib.callback.await('yseries:server:get-primary-phone', false, PlayerData.identifier)
        if phoneImei then
            debugPrint('Found phone for player: ', PlayerData.identifier, ' with imei: ', phoneImei)

            DataLoaded = false
            LoadPhoneData(phoneImei)
        else
            debugPrint('onPlayerLoggedIn: No phone found for player: ', PlayerData.identifier)
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
    end

    if LocalPlayer.state.isLoggedIn then
        debugPrint("Phone:QB:Player loaded")
        QBPlayerData = Framework.Functions.GetPlayerData()

        onPlayerLoggedIn()
    end

    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(jobInfo)
        PlayerData.job = jobInfo
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        QBPlayerData = Framework.Functions.GetPlayerData()

        PlayerData = {
            identifier = QBPlayerData.citizenid,
            job = QBPlayerData.job
        }

        onPlayerLoggedIn()
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        TriggerServerEvent('yseries:server:cleanup')

        TriggerServerEvent('yseries:server:players:remove')

        PlayerData.identifier = nil
        PlayerData.job = nil

        ToggleOpen(false)
        HasPrimaryPhone = false

        SendUIAction('main:reset-phone-ui')
    end)

    -- * Check if a player has any of the usable phone items.
    function HasPhoneItem(phoneImei)
        if not Config.Item.Require then
            return true
        end

        -- Check if ox_inventory is started
        if GetResourceState("ox_inventory") == "started" then
            for _, itemName in ipairs(Config.UseableItems) do
                if (exports.ox_inventory:Search("count", itemName) or 0) > 0 then
                    return true
                end
            end

            return false -- If none of the items were found
        end

        -- Check for unique phones with IMEI
        if Config.Item.UniquePhones and phoneImei then
            return HasImeiIdentifier(phoneImei)
        else
            -- Fallback for other inventory systems or if unique phone check is not required
            for _, itemName in ipairs(Config.UseableItems) do
                if Framework.Functions.HasItem(itemName) then
                    return true
                end
            end

            return false -- If none of the items were found
        end
    end

    function GetCompanyEmployees(job)
        return lib.callback.await('yseries:server:companies:get-employees-ids', false, job)
    end

    -- * Get company data based on the player's job and grade.
    function GetCompanyData()
        if not PlayerData?.job then
            return nil
        end

        local jobData = {
            job = PlayerData.job.name,
            jobLabel = PlayerData.job.label,
            gradeLevel = PlayerData.job.grade.level,
            gradeLabel = PlayerData.job.grade.name,
            isBoss = PlayerData.job.isboss,
            payment = PlayerData.job.payment,
            duty = PlayerData.job.onduty
        }

        if jobData.isBoss then
            local employeesPromise = promise.new()
            Framework.Functions.TriggerCallback("qb-bossmenu:server:GetEmployees", function(employees)
                for i = 1, #employees do
                    local employee = employees[i]
                    employees[i] = {
                        name = employee.name,
                        id = employee.empSource,

                        gradeLabel = employee.grade.name,
                        grade = employee.grade.level,

                        canInteract = not employee.isboss
                    }
                end
                employeesPromise:resolve(employees)
            end, jobData.job)

            jobData.employees = Citizen.Await(employeesPromise)

            jobData.balance = lib.callback.await('yseries:server:banking:get-balance')

            jobData.grades = {}
            for k, v in pairs(Framework.Shared.Jobs[jobData.job].grades) do
                jobData.grades[#jobData.grades + 1] = {
                    label = v.name,
                    grade = tonumber(k)
                }
            end

            table.sort(jobData.grades, function(a, b)
                return a.grade < b.grade
            end)
        end

        return jobData
    end

    -- * Hire an employee.
    function HireEmployee(source, cb)
        TriggerServerEvent("qb-bossmenu:server:HireEmployee", source)

        cb({ success = true })
    end

    -- * Fire an employee.
    function FireEmployee(source, cb)
        TriggerServerEvent("qb-bossmenu:server:FireEmployee", source)

        cb(true)
    end

    -- * Promote/demote an employee.
    function SetGrade(identifier, newGrade, oldGrade, cb)
        local maxGrade = 0
        for grade, _ in pairs(Framework.Shared.Jobs[PlayerData.job.name].grades) do
            grade = tonumber(grade)

            if grade and grade > maxGrade then
                maxGrade = grade
            end
        end

        if newGrade > maxGrade then
            return cb(false)
        end

        TriggerServerEvent("qb-bossmenu:server:GradeUpdate", {
            cid = identifier,
            grade = newGrade,
            gradename = Framework.Shared.Jobs[PlayerData.job.name].grades[tostring(newGrade)].name
        })
        cb(true)
    end

    -- * Toggle duty status.
    function ToggleDuty()
        local _source = source
        local dutyStatus = lib.callback.await('yseries:server:companies:toggle-duty', false, _source)

        local playerIdentifier = PlayerData.identifier
        local firstName, lastName = lib.callback.await('yseries:server:utils:get-character-name', false, _source)

        local message = string.format('%s %s went %s duty', firstName, lastName, dutyStatus and 'on' or 'off')

        TriggerServerEvent('yseries:server:logs:create', 'companies', 'Companies', 'Duty status change 🪖', 'companies',
            message, nil, nil, nil, playerIdentifier)

        PlayerData.job.onduty = dutyStatus
        return dutyStatus
    end

    -- * Get the player's on duty status.
    function GetDutyStatus()
        return PlayerData.job.onduty
    end

    function CreateFrameworkVehicle(vehicleData, coords)
        vehicleData.mods = json.decode(vehicleData.mods)

        local model = tonumber(vehicleData.hash)

        if not model then
            model = GetHashKey(vehicleData.vehicle)
        end

        while not HasModelLoaded(model) do
            RequestModel(model)
            Wait(500)
        end

        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, 0.0, true, false)
        SetVehicleOnGroundProperly(vehicle)
        SetVehicleNumberPlateText(vehicle, vehicleData.plate)

        Framework.Functions.SetVehicleProperties(vehicle, vehicleData.mods)

        if GetResourceState("LegacyFuel") == "started" and vehicleData.fuel then
            exports.LegacyFuel:SetFuel(vehicle, vehicleData.fuel)
        end

        SetModelAsNoLongerNeeded(model)

        return vehicle
    end

    -- * Send a notification to a player.
    function Notify(messageData)
        lib.notify(messageData)
    end
end)
