---@diagnostic disable: undefined-global
local calledEmployees = {}

local function GetCompany(company)
    for i = 1, #Config.Companies.Services do
        local jobData = Config.Companies.Services[i]
        if jobData.job == company then
            return jobData
        end
    end
end

RegisterNUICallback('companies:get-company', function(_, cb)
    local jobDetails = GetCompanyData()
    cb(jobDetails)
end)

-- * Get all companies with their data.
RegisterNUICallback('companies:get', function(_, cb)
    -- * Get companies along with `open` status.
    local companies = lib.callback.await('yseries:server:companies:get', false)
    cb(companies)
end)

local function EnrichCompanyData(conversations)
    for i = 1, #conversations do
        local conversation = conversations[i]

        local jobData = GetCompany(conversation.company)
        if jobData then
            conversation.company = {
                icon = jobData.icon,
                name = jobData.name,
                job = jobData.job
            }
        end
    end

    return conversations
end

local function shuffleTable(t)
    local n = #t
    while n > 1 do
        local k = math.random(n)
        t[n], t[k] = t[k], t[n]
        n = n - 1
    end
end

function CleanupOnAnsweredCall()
    for i = 1, #calledEmployees do
        local employee = calledEmployees[i]

        if employee.phoneNumber ~= PhoneData.CallData?.TargetData?.number then
            TriggerServerEvent('yseries:server:companies:cancel-call', employee.source)
        end
    end

    calledEmployees = {}
end

RegisterNuiCallback('companies:cleanup-call-data', function(_, cb)
    debugPrint('Companies: Canceling call.')

    cb({})

    CleanupOnAnsweredCall()
end)

RegisterNUICallback('companies:call', function(job, cb)
    debugPrint('Companies: Trying to call company - ', job)

    local employees = GetCompanyEmployees(job)

    if not employees or #employees == 0 then
        debugPrint('Companies: No employees found for job - ', job)
        cb({ success = false })
        return
    end

    shuffleTable(employees)

    local numEmployeesToSelect = math.min(#employees, Config.Companies.MaxEmployeesToCall)
    local selectedEmployees = {}
    for i = 1, numEmployeesToSelect do
        table.insert(selectedEmployees, employees[i])
    end

    cb({ success = true })

    for _, emp in pairs(selectedEmployees) do
        local phoneNumber = lib.callback.await('yseries:server:get-phone-number-by-citizen-id', false, emp.playerId)
        if not phoneNumber then
            goto continue
        end

        local isCalled = lib.callback.await('yseries:server:companies:call-employee', false, phoneNumber, emp.source,
            Device.number)
        if isCalled then
            debugPrint('Companies: Employee called with phone number', phoneNumber, 'and source', emp.source)
            calledEmployees[#calledEmployees + 1] = {
                phoneNumber = phoneNumber,
                source = emp.source
            }
        end

        ::continue::
    end
end)

RegisterNUICallback('companies:has-company-messages', function(_, cb)
    local job = PlayerData.job?.name
    local jobData = {}
    for i = 1, #Config.Companies.Services do
        local service = Config.Companies.Services[i]
        if service.job == job then
            jobData = service
            goto continue
        end
    end

    ::continue::

    cb(jobData?.canMessage)
end)

RegisterNUICallback('companies:send-message', function(messageData, cb)
    print(json.encode(messageData))
    local result = lib.callback.await('yseries:server:companies:send-message', false, messageData,CurrentPhoneImei)
    TriggerServerEvent("gksphone:gkcs:jbmessage", nil, nil, nil, nil, nil, json.encode({messageData.company}))
    if result then
        cb({ messageId = result?.messageId, channelId = result?.channelId, timestamp = result?.messageTimestamp, success = true })
    else
        cb({ success = false })
    end
end)

-- * Get recent conversations.
RegisterNUICallback('companies:get-company-conversations', function(page, cb)
    local conversationsResult = lib.callback.await('yseries:server:companies:get-company-conversations', false,
        PlayerData.job?.name, page)

    conversationsResult.job = PlayerData.job?.name

    cb(conversationsResult)
end)

-- * Get recent conversations.
RegisterNUICallback('companies:get-user-conversations', function(page, cb)
    local conversationsResult = lib.callback.await('yseries:server:companies:get-user-conversations', false,
        CurrentPhoneImei, page)

    local enhancedData = EnrichCompanyData(conversationsResult.conversations)

    conversationsResult.job = PlayerData.job?.name
    conversationsResult.conversations = enhancedData

    cb(conversationsResult)
end)

-- * Get conversation between user and company.
RegisterNUICallback('companies:get-conversation', function(company, cb)
    local result = lib.callback.await('yseries:server:companies:get-conversation', false, company, CurrentPhoneImei)

    cb(result)
end)

-- * Get conversation by channel id.
RegisterNUICallback('companies:get-conversation-by-channelId', function(data, cb)
    local result = lib.callback.await('yseries:server:companies:get-conversation-by-channelId', false, data)

    cb(result)
end)

RegisterNUICallback('companies:employee:toggle-duty', function(_, cb)
    local company = GetCompany(PlayerData.job.name)

    if ToggleDuty and company.management.duty then
        local dutyStatus = ToggleDuty()

        cb({
            duty = dutyStatus
        })
    end
end)

RegisterNUICallback('companies:employee:get-duty-status', function(_, cb)
    cb(GetDutyStatus())
end)

RegisterNUICallback('companies:boss:deposit', function(amount, cb)
    local company = GetCompany(PlayerData.job.name)
    local currentbalance = -1
    local success = false

    if company.management.deposit then
        success = DepositMoney(amount)
        if success then
            currentbalance = lib.callback.await('yseries:server:banking:get-balance', false)
        end
    end

    cb({ success = success, balance = currentbalance })
end)

RegisterNUICallback('companies:boss:withdraw', function(amount, cb)
    local company = GetCompany(PlayerData.job.name)
    local currentbalance = -1
    local success = false

    if company.management.withdraw then
        success = WithdrawMoney(amount)
        if success then
            currentbalance = lib.callback.await('yseries:server:banking:get-balance', false)
        end
    end

    cb({ success = success, balance = currentbalance })
end)

RegisterNUICallback('companies:boss:hire', function(data, cb)
    local company = GetCompany(PlayerData.job.name)

    if HireEmployee and company.management.hire then
        HireEmployee(data.player, cb)

        if Config.Framework == "qb" and GetResourceState("qb-menu") == "started" then
            local timer = GetGameTimer() + 250
            while GetGameTimer() < timer do
                Wait(100)
                exports["qb-menu"]:closeMenu()
            end
        end
    end
end)

RegisterNUICallback('companies:boss:get-closest-players', function(_, cb)
    local Candidates = {}

    local Ped = PlayerPedId()
    local location = GetEntityCoords(Ped)

    local players = lib.getNearbyPlayers(location, 5)
    for i = 1, #players do
        local player = players[i]

        if player then
            local playerId = GetPlayerServerId(player.id)

            local playerData = lib.callback.await('yseries:server:companies:get-player-data', false, playerId)

            Candidates[#Candidates + 1] = playerData
        end
    end

    cb(Candidates)
end)

RegisterNUICallback('companies:boss:fire', function(id, cb)
    local company = GetCompany(PlayerData.job.name)

    if FireEmployee and company.management.fire then
        FireEmployee(id, cb)

        if Config.Framework == "qb" and GetResourceState("qb-menu") == "started" then
            local timer = GetGameTimer() + 250
            while GetGameTimer() < timer do
                Wait(100)
                exports["qb-menu"]:closeMenu()
            end
        end
    end
end)

RegisterNUICallback('companies:boss:set-grade', function(data, cb)
    local company = GetCompany(PlayerData.job.name)

    if SetGrade and company.management.promote then
        SetGrade(data.employeeId, data.grade, data.oldGrade, cb)

        if Config.Framework == "qb" and GetResourceState("qb-menu") == "started" then
            local timer = GetGameTimer() + 250
            while GetGameTimer() < timer do
                Wait(100)
                exports["qb-menu"]:closeMenu()
            end
        end
    end
end)

RegisterNetEvent('yseries:client:companies:update-conversation', function(message)
    SendUIAction('companies:update-conversation', message)
end)

RegisterNetEvent('yseries:client:companies:get-employee-called', function(callerNumber)
    SendUIAction('companies:get-employee-called', { callerNumber = callerNumber })
end)

RegisterNetEvent('yseries:client:companies:cancel-call', function()
    SendUIAction('s-cancel-call')
end)

-- * Deposit money into the company account.
---@param amount number
---@return boolean
function DepositMoney(amount)
    if PlayerData.money["cash"] >= amount then
        local success = lib.callback.await('yseries:server:banking:deposit', false, amount)

        return success
    else
        debugPrint('Not enough money!')

        return false
    end
end

-- * Withdraw money from the company account.
---@param amount number
---@return boolean
function WithdrawMoney(amount)
    if amount > 0 then
        local currentBalance = lib.callback.await('yseries:server:banking:get-balance')
        if currentBalance >= amount then
            local withdraw = lib.callback.await('yseries:server:banking:withdraw', false, amount)

            return withdraw
        else
            debugPrint('Not enough money!')
            return false
        end
    else
        debugPrint("Value must be > 0!")
        return false
    end
end
