---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-global, undefined-field, need-check-nil
local ESX = nil
local golds = 0
local irons = 0
local Melting = false
local PlayerData = {}
local Rocks = {}
local price = {}
local JobBlips = {}
local IsMiner = false
local IsDuty = false
local dozd = false
local DrawDistance = 15
local RocksObject = {
    'prop_rock_1_a',
    'prop_rock_1_e',
    'prop_rock_1_c'
}

local Config = {
    StartField2 = {
        Locker = vector3(287.74,2843.77,44.7),
        Veh    = vector3(304.67,2820.82,43.44),
        Spawn  = { c = vector3(309.26,2835.37,43.44), h = 116.76 },
        Delete = vector3(309.26,2835.37,43.44)
    },
    StartField = {
        Locker = vector3(892.28, -2172.74, 31.29),
        Veh    = vector3(884.72, -2176.47, 29.52),
        Spawn  = { c = vector3(872.5, -2187.78, 30.52), h = 85.39 },
        Delete = vector3(873.62, -2194.65, 29.52)
    },
    RockField = {
        coords = vector3(2953.44, 2792.82, 40.31)
    },
    WashField = {
        { coords = vector3(318.40, 2864.33, 42.52), h = 119.45 },
        { coords = vector3(306.97, 2884.08, 42.46), h = 114.08 },
        { coords = vector3(312.68, 2875.18, 42.50), h = 115.84 }
    },
    MeltingField = {
        { coords = vector3(1109.52, -2013.08, 34.45) ,task = { c = vector3(1110.0, -2012.42, 35.44), h = 324.77 } },
        { coords = vector3(1114.24, -2006.08, 34.44) ,task = { c = vector3(1113.89, -2006.54, 35.44),h = 144.92 } }
    },
    ISSell = {
        coords = vector3(-91.54, -1029.71, 26.83)
    },
    DGSell = {
        coords = vector3(-620.57, -228.36, 37.06)
    },
    SSell = {
        coords = vector3(-149.11, -1040.24, 26.27)
    }
}

Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    while ESX.GetPlayerData().gang == nil do 
        Citizen.Wait(500)
    end
    PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback('getMiningPrices', function(data)
        price = data
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

local canEnter = true

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	if GetInvokingResource() then return end
    if Bucket == 0 then
        canEnter = true
    else
        canEnter = false
    end
end)

AddEventHandler('PlayerLoadedToGround', function ()
    while PlayerData.job == nil do
        Wait(1000)
    end
    TirggerMinerCitizen()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    TirggerMinerCitizen()
end)

AddEventHandler('skinchanger:PlayerLoaded', function()
	while PlayerData.job == nil do
		Citizen.Wait(10)
    end
    if PlayerData.job.name == 'miner' and PlayerData.job.grade > 0 then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
            else
                TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
            end
        end)
    end
end)

RegisterNetEvent('esx_jobs:ActivateJobForOrgans')
AddEventHandler('esx_jobs:ActivateJobForOrgans', function(job, grade)
    local job = job
    local grade = grade
    Citizen.Wait(math.random(2500, 4000))
    PlayerData.job.name = job
    PlayerData.job.grade = grade
    TirggerMinerCitizen()
end)

--[[RegisterCommand('cancelmine', function()
    mining = false
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)- end, 
false)]]

function PickStone(id)
    mining = true
    TaskTurnPedToFaceEntity(PlayerPedId(), Rocks[id].object, 0.5)
    FreezeEntityPosition(PlayerPedId(), true)
    local axe = CreateObject('prop_tool_pickaxe', GetEntityCoords(PlayerPedId()), false, true)
    AttachEntityToEntity(axe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, false, true, 0, true)
    while mining do
        Wait(0)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
        ESX.ShowHelpNotification('Press ~INPUT_ATTACK~ to chop, ~INPUT_FRONTEND_RRIGHT~ to stop.')
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 73, true)
        DisableControlAction(0, 288, true)
        DisableControlAction(0, 289, true)
        DisableControlAction(0, 170, true)
        if IsDisabledControlJustReleased(0, 24) then
            local dict = loadDict('melee@hatchet@streamed_core')
            TaskPlayAnim(PlayerPedId(), dict, 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
            Wait(1000)
            Rocks[id].health = Rocks[id].health - 10 
            ClearPedTasks(PlayerPedId())
            TaskTurnPedToFaceEntity(PlayerPedId(), Rocks[id].object, 0.5)
            Wait(500)
            FreezeEntityPosition(PlayerPedId(), true)
            HitReward()
            if Rocks[id].health <= 0 then
                ESX.Game.DeleteLocalObject(Rocks[id].object)
                Rocks[id].thread.remove()
                Rocks[id] = nil
                SpawnRocks()
                break
            end
        elseif IsControlJustReleased(0, 194) then
            break
        end
    end
    mining = false
    ESX.Game.DeleteObject(axe)
    Wait(100)
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
end

function MiningCondition()
    return IsPedOnFoot(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not mining
end

function SpawnRocks()
    if tLength(Rocks) >= 5 then return end
    if #(GetEntityCoords(PlayerPedId()) - vector3(Config.RockField.coords.x, Config.RockField.coords.y, Config.RockField.coords.z)) > 70 then return end
    if PlayerData.job.name ~= 'miner' or PlayerData.job.grade < 1 then return end
    repeat
        GenerateRockCoords(function(rockCoords)
            ESX.Game.SpawnLocalObject(RocksObject[math.random(1,3)], rockCoords, function(obj)
                PlaceObjectOnGroundProperly(obj)
                FreezeEntityPosition(obj, true)
                local id = #Rocks + 1
                local Key
                local Point = RegisterPoint(rockCoords, 3, true)
                Point.set('Tag', 'miner_stones')
                Point.set('InAreaOnce', function ()
                    Hint:Create('Press ~INPUT_CONTEXT~ to start mine', MiningCondition)
                    Key = RegisterKey('E', false, function ()
                        if MiningCondition() and canEnter then
                            Hint:Delete()
                            Key = UnregisterKey(Key)
                            if Rocks[id]then
                                PickStone(id)
                            end
                        end
                    end)
                end, function ()
                    Hint:Delete()
                    Key = UnregisterKey(Key)
                end)
                Rocks[id] = {object = obj, health = 100, thread = Point}
            end)
        end)
    until tLength(Rocks) >= 10
end

function GenerateRockCoords(cb)
    local coord
    repeat
		Citizen.Wait(1)

		local rockCoordX, rockCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-35, 35)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-35, 35)

		rockCoordX = Config.RockField.coords.x + modX
		rockCoordY = Config.RockField.coords.y + modY
		
		
		local coordZ = GetCoordZ(rockCoordX, rockCoordY)
		coord = vector3(rockCoordX, rockCoordY, coordZ)

	until ValidateRockCoord(coord)
    cb(coord)
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0 ,55.0, 56.0, 57.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end
	return 45.0
end

function HitReward()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    local kamy = GetHashKey('rubble')
    local isVehicleKamy = IsVehicleModel(vehicle, kamy)
    if isVehicleKamy and DoesEntityExist(vehicle) then
        local pCoord = GetEntityCoords(PlayerPedId())
        local tCoord = GetEntityCoords(vehicle)
        if #(pCoord - tCoord) < 40 then
            local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
            TriggerServerEvent('mining:PutStoneInVehicle', plate)
        else
            exports['esx_notify']:Notification({
                title = 'Distance',
                message = 'Lotfan Mashine Khodeton Ro Nazdik Tar Biyarid',
                image = 'https://media.discordapp.net/attachments/766026362594656286/912334083193962526/ic_fluent_info_24_filled.png',
                timeout = 6000,
                bgColor = 'rgba(0, 17, 255, 0.4)'
            })
        end
    else
        exports['esx_notify']:Notification({
            title = 'ERROR',
            message = 'Shoma Ba Khodeton Kamion Nayavordid',
            image = 'https://media.discordapp.net/attachments/766026362594656286/912334392880422912/ic_fluent_clipboard_error_24_filled.png',
            timeout = 6000,
            bgColor = 'rgba(255, 33, 33, 0.4)'
        })
    end
end

function ValidateRockCoord(rockCoord)
	if tLength(Rocks) > 0 then
		local validate = true

		for k, v in pairs(Rocks) do
            local oCoord = GetEntityCoords(v.object)
			if #(rockCoord - oCoord) < 6 then
				validate = false
			end
		end

		if #(vector2(rockCoord.x, rockCoord.y) - vector2(Config.RockField.coords.x, Config.RockField.coords.y)) > 70 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function loadModel(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

function loadDict(dict, anim)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

function OpenShop(selling)
	ESX.UI.Menu.CloseAll()
	local elements = {}
    local temp     = {}
    for k, v in pairs(ESX.GetPlayerData().inventory) do
        for c,d in ipairs(price) do
            if v.name == d.name then
                if d.price and v.count > 0 then
                    table.insert(temp, {
                        label = ('%s - <span style="color:green;">%s</span>'):format(v.label, '$'..ESX.Math.GroupDigits(d.price)),
                        name = v.name,
                        price = d.price,

                        -- menu properties
                        type = 'slider',
                        value = 1,
                        min = 1,
                        max = v.count
                    })
                end
            end
        end
	end

    for k,v in pairs(temp) do
        for i=1, #selling do
            if v.name == selling[i] then
                table.insert(elements, v)
            end
        end
    end

    if #elements == 0 then
        ESX.Alert('Shoma Mahsoli Baraye Forosh nadarid', "error")
        return
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop', {
		title    = 'Mining Shop',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
        TriggerServerEvent('mining:sell', data.current.name, data.current.value)
        menu.close()
	end, function(data, menu)
		menu.close()
    end)
end

function OpenCloakroomMenu()

	local playerPed = PlayerPedId()
	local elements = {
		{ label = 'Posheshe Sharvandi', value = 'citizen_wear' },
		{ label = 'Posheshe Kar', value = 'sbullet_wear' }
	}
	--[[for k, v in pairs(JobBlips) do
		SetBlipRoute(v, false)
	end
    for k, v in pairs(GlobalBlips) do
		SetBlipRoute(v, false)
	end]]
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = 'cloakroom',
		align    = 'top-left',
		elements = elements
    }, function(data, menu)
        
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if data.current.value == 'citizen_wear' then
                TriggerEvent('skinchanger:loadSkin', skin)
                TriggerServerEvent('mining:Duty', false)
                RemoveAllPedWeapons(PlayerPedId())
                Citizen.Wait(1000)
                TriggerEvent('esx:restoreLoadout')
                TriggerEvent("esx_fightBan:excludePlayer", true)
            elseif data.current.value == 'sbullet_wear' then
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                end
                TriggerServerEvent('mining:Duty', true)
                if PlayerData.job.name == "hunter" then
                    TriggerEvent("esx:addWeapon", "WEAPON_MUSKET", 250)
                    TriggerEvent("esx:addWeapon", "WEAPON_KNIFE", 250)
                end
                if PlayerData.job.name == "fisherman" then
                    SetNewWaypoint(-1848.98, -895.86)
                end
            end
        end)

	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('mining:getPrice')
AddEventHandler('mining:getPrice', function(data)
    price = data
end)

RegisterNetEvent('mining:CallbackOnMelting')
AddEventHandler('mining:CallbackOnMelting', function(event)
    if event == 'skipgold' then
        golds = 0
    else
        irons = 0
    end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(Rocks) do
			ESX.Game.DeleteLocalObject(v.object)
        end
        for _,v in pairs(JobBlips) do
            RemoveBlip(v)
        end
	end
end)

function CreateBlip(coords, name)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite  (blip, 318)
    SetBlipDisplay (blip, 4)
    SetBlipScale   (blip, 0.6)
    SetBlipCategory(blip, 3)
    SetBlipColour  (blip, 5)
    SetBlipAsShortRange(blip, true)
    if name == 'Lebase Miner' then
        --SetBlipRoute(blip,  true)
        SetBlipAsMissionCreatorBlip(blip, true)
        --SetBlipRouteColour(blip, 3)
    end
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    table.insert(JobBlips, blip)
end

function TirggerMinerCitizen()
    IsMiner = false
    IsDuty = false
    for _,v in pairs(JobBlips) do
        RemoveBlip(v)
    end
    for k,v in pairs(Rocks) do
        ESX.Game.DeleteLocalObject(v.object)
    end
    exports.sr_main:RemoveByTag('MinerBaseThreads')
    exports.sr_main:RemoveByTag('miner_stones')
    Rocks = {}
    Wait(1000)
    IsMiner = PlayerData.job.name == 'miner'
    IsDuty = IsMiner and PlayerData.job.grade > 0
    
    if not IsMiner then return end

    if PlayerData.job.grade > 0 then
        CreateBlip(Config.StartField.Locker, 'Vasayele Mining')
        CreateBlip(Config.RockField.coords, 'Madane Sang')
        CreateBlip(Config.WashField[1].coords, 'Shostosho Va Qarbale Sangha')
        CreateBlip(Config.MeltingField[1].coords, 'Zoob Tala va Ahan')
        CreateBlip(Config.ISSell.coords, 'Foroshe Shemshe Ahan')
        CreateBlip(Config.DGSell.coords, 'Foroshe Shemshe Tala va Almas')
        CreateBlip(Config.SSell.coords, 'Foroshe Sang')
    else
        CreateBlip(Config.StartField.Locker, 'Lebase Miner')
    end

    StartPoint = RegisterPoint(Config.StartField.Locker, DrawDistance, true)
    StartPoint.set('Tag', 'MinerBaseThreads')
    StartPoint.set('InArea', function ()
        DrawMarker(1, Config.StartField.Locker, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
    end)
    StartPoint.set('InAreaOnce', function ()
        local Key
        StartInteract = RegisterPoint(Config.StartField.Locker, 1.5, true)
        StartInteract.set('InAreaOnce', function ()
            Hint:Create('~INPUT_CONTEXT~ Locker Room')
            Key = RegisterKey('E', false, function ()
                if canEnter then
                    Key = UnregisterKey(Key)
                    Hint:Delete()
                    OpenCloakroomMenu()
                end
            end)
        end, function ()
            Hint:Delete()
            Key = UnregisterKey(Key)
        end)
    end, function ()
        if StartInteract then
            StartInteract = StartInteract.remove()
        end
    end)

    StartPoint2 = RegisterPoint(Config.StartField2.Locker, DrawDistance, true)
    StartPoint2.set('Tag', 'MinerBaseThreads')
    StartPoint2.set('InArea', function ()
        DrawMarker(1, Config.StartField2.Locker, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
    end)
    StartPoint2.set('InAreaOnce', function ()
        local Key
        StartInteract2 = RegisterPoint(Config.StartField2.Locker, 1.5, true)
        StartInteract2.set('InAreaOnce', function ()
            Hint:Create('~INPUT_CONTEXT~ Locker Room')
            Key = RegisterKey('E', false, function ()
                if canEnter then
                    Key = UnregisterKey(Key)
                    Hint:Delete()
                    OpenCloakroomMenu()
                end
            end)
        end, function ()
            Hint:Delete()
            Key = UnregisterKey(Key)
        end)
    end, function ()
        if StartInteract2 then
            StartInteract2 = StartInteract2.remove()
        end
    end)

    if not IsDuty then return end
    -- wash
    WashPoint = RegisterPoint(Config.WashField[1].coords, 25, true)
    WashPoint.set('Tag', 'MinerBaseThreads')
    WashPoint.set('InArea', function ()
        for k,v in pairs(Config.WashField) do
            DrawMarker(1, v.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
            if #(GetEntityCoords(PlayerPedId()) - v.coords) < 3.0 then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                local kamy = GetHashKey('rubble')
                local isVehicleKamy = IsVehicleModel(vehicle, kamy)
                if isVehicleKamy and DoesEntityExist(vehicle) then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to start wash.')
                    if IsControlJustReleased(0, 38) then
                        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
                        TriggerServerEvent('mining:WashStonePieces', plate)
                        SetEntityHeading(vehicle, v.h)
                        TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
                        --SetVehicleDoorsLocked(vehicle, 2)
                        --SetVehicleDoorsLockedForAllPlayers(vehicle, true)
                        FreezeEntityPosition(vehicle, true)
                        SetNewWaypoint(-92.41,-1024.08)
                        ESX.Alert('Lotfan Chand Daqiqe Baraye Gharbale Sangha Sabr konid', "info")
                        SetTimeout(60000, function()
                            --SetVehicleDoorsLocked(vehicle, 1)
                            FreezeEntityPosition(vehicle, false)
                            --SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                            ESX.Alert('Shoma Aknon mitavanid Mashine Khodeton Ro Bardarid', "info")
                            SetNewWaypoint(-92.41,-1024.08)
                        end)
                    end
                end
            end
        end
    end)

    for k,v in pairs(Config.MeltingField) do
        local Interact
        local Key
        local Point = RegisterPoint(v.coords, 15, false)
        Point.set('Tag', 'MinerBaseThreads')
        Point.set('InArea', function ()
            if not Melting then
                DrawMarker(1, v.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
            end
        end)
        Point.set('InAreaOnce', function ()
            Interact = RegisterPoint(v.coords, 1.5, true)
            Interact.set('Tag', 'MinerBaseThreads')
            Interact.set('InAreaOnce', function ()
                Hint:Create('~INPUT_CONTEXT~ Amaliyate Zoob')
                Key = RegisterKey('E', false, function ()
                    if canEnter then
                        Melting = true
                        Hint:Delete()
                        Key = UnregisterKey(Key)
                        TaskGoStraightToCoord(PlayerPedId(), v.task.c, 1.0, 5000, 140.01, 0)
                        Wait(1000)
                        TaskAchieveHeading(PlayerPedId(), v.task.h, 1000)
                        Wait(1000)
                        FreezeEntityPosition(PlayerPedId(), true)
                        local dict = loadDict("random@mugging4")
                        TaskPlayAnim(PlayerPedId(), dict, "struggle_loop_b_thief", 8.0, -8.0, -1, 2, 0, false, false, false)
                        local msg = 'Amaliyate Zoob Be Payan Resid'
                        local PlayerDataa = ESX.GetPlayerData()
                        for i=1, #PlayerDataa.inventory do
                            if PlayerDataa.inventory[i].name == 'gold_piece' then
                                golds = PlayerDataa.inventory[i].count
                            elseif PlayerDataa.inventory[i].name == 'iron_piece' then
                                irons = PlayerDataa.inventory[i].count
                            end
                        end
                        if not (golds >= 20 or irons >= 20) then msg = 'Shoma Tala ya Ahan Be Mizane Kafi nadarid, Hade Aqal tedade morede niyaz: 20' Melting = false end
                        while Melting do
                            Wait(5000)
                            if golds >= 20 then
                                TriggerServerEvent('mining:MeltItems', 'gold_piece')
                                golds = golds - 20
                            elseif irons >= 20 then
                                TriggerServerEvent('mining:MeltItems', 'iron_piece')
                                irons = irons - 20
                            else
                                Melting = false
                            end
                        end
                        FreezeEntityPosition(PlayerPedId(), false)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.Alert(msg)
                    end
                end)
            end, function ()
                Hint:Delete()
                Key = UnregisterKey(Key)
            end)
        end, function ()
            if Interact then
                Interact.remove()
            end
        end)
    end

    PISSell = RegisterPoint(vector3(-88.98,-1014.14,26.55), 15, true)
    PISSell.set('Tag', 'MinerBaseThreads')
    PISSell.set('InArea', function ()
        DrawMarker(1, vector3(-88.98,-1014.14,26.55), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
        if #(GetEntityCoords(PlayerPedId()) - vector3(-88.98,-1014.14,26.56)) < 1.5 then
            ESX.ShowHelpNotification('~INPUT_CONTEXT~ Menu Forosh Mes')
            if IsControlJustReleased(0, 38) then
                OpenShop({'copper'})
            end
        end
    end)

    ISSell = RegisterPoint(Config.ISSell.coords, 15, true)
    ISSell.set('Tag', 'MinerBaseThreads')
    ISSell.set('InArea', function ()
        DrawMarker(1, Config.ISSell.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
        if #(GetEntityCoords(PlayerPedId()) - Config.ISSell.coords) < 1.5 then
            ESX.ShowHelpNotification('~INPUT_CONTEXT~ Menu Forosh')
            if IsControlJustReleased(0, 38) then
                OpenShop({'iron'})
            end
        end
    end)

    SSell = RegisterPoint(Config.SSell.coords, 15, true)
    SSell.set('Tag', 'MinerBaseThreads')
    SSell.set('InArea', function ()
        DrawMarker(1, Config.SSell.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 2.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
        if #(GetEntityCoords(PlayerPedId()) - Config.SSell.coords) < 3 then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if DoesEntityExist(vehicle) then
                ESX.ShowHelpNotification('~INPUT_CONTEXT~ Menu Forosh Sang')
                if IsControlJustReleased(0, 38) then
                    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
                    TriggerServerEvent('mining:SellStone', plate)
                end
            end
        end
    end)

    DGSell = RegisterPoint(Config.DGSell.coords, 15, true)
    DGSell.set('Tag', 'MinerBaseThreads')
    DGSell.set('InArea', function ()
        DrawMarker(1, Config.DGSell.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
        if #(GetEntityCoords(PlayerPedId()) - Config.DGSell.coords) < 1.5 then
            ESX.ShowHelpNotification('~INPUT_CONTEXT~ Menu Forosh Ahan')
            if IsControlJustReleased(0, 38) then
                OpenShop({'gold','diamond'})
            end
        end
    end)

    StartFieldVeh = RegisterPoint(Config.StartField.Veh, 15, true)
    StartFieldVeh.set('Tag', 'MinerBaseThreads')
    StartFieldVeh.set('InArea', function ()
        DrawMarker(1, Config.StartField.Veh, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
        if #(GetEntityCoords(PlayerPedId()) - Config.StartField.Veh) < 1.5 then
            ESX.ShowHelpNotification('~INPUT_CONTEXT~ Spawn Vehicle')
            if IsControlJustReleased(0, 38) then
                Wait(math.random(300,900))
                if ESX.Game.IsSpawnPointClear(Config.StartField.Spawn.c, 6.0) then
                    if getVehicleFromPlate("MN"..ESX.GetPlayerData().rawid) then
						ESX.ShowNotification('Shoma ghablan yek mashin gereftid')
                    elseif not dozd then
                        dozd = true
                        ESX.TriggerServerCallback("esx_mining:checkJob", function() 
                            ESX.Game.SpawnVehicle('rubble', Config.StartField.Spawn.c, Config.StartField.Spawn.h, function(vehicle)
                                local plate = "MN"..ESX.GetPlayerData().rawid
                                plate = string.gsub(plate, " ", "")
                                SetVehicleNumberPlateText(vehicle, plate)
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                ESX.CreateVehicleKey(vehicle)
                                exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
                                --TriggerEvent('esx_carlock:addCarLock', VehToNet(vehicle), true)
                                Wait(1000)
                                SetVehRadioStation(vehicle, 'RADIO_13_JAZZ')
                                SetNewWaypoint(2952.81, 2806.89)
                                dozd = false
                            end)
                        end)
					end
                end
            end
        end
    end)

    StartFieldVeh2 = RegisterPoint(Config.StartField2.Veh, 15, true)
    StartFieldVeh2.set('Tag', 'MinerBaseThreads')
    StartFieldVeh2.set('InArea', function ()
        DrawMarker(1, Config.StartField2.Veh, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
        if #(GetEntityCoords(PlayerPedId()) - Config.StartField2.Veh) < 1.5 then
            ESX.ShowHelpNotification('~INPUT_CONTEXT~ Spawn Vehicle')
            if IsControlJustReleased(0, 38) then
                Wait(math.random(300,900))
                if ESX.Game.IsSpawnPointClear(Config.StartField2.Spawn.c, 6.0) then
                    if getVehicleFromPlate("MN"..ESX.GetPlayerData().rawid) then
						ESX.ShowNotification('Shoma ghablan yek mashin gereftid')
                    elseif not dozd then
                        dozd = true
                        ESX.TriggerServerCallback("esx_mining:checkJob", function() 
                            ESX.Game.SpawnVehicle('rubble', Config.StartField2.Spawn.c, Config.StartField2.Spawn.h, function(vehicle)
                                local plate = "MN"..ESX.GetPlayerData().rawid
                                plate = string.gsub(plate, " ", "")
                                SetVehicleNumberPlateText(vehicle, plate)
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                ESX.CreateVehicleKey(vehicle)
                                exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
                                --TriggerEvent('esx_carlock:addCarLock', VehToNet(vehicle), true)
                                Wait(1000)
                                SetVehRadioStation(vehicle, 'RADIO_13_JAZZ')
                                SetNewWaypoint(2952.81, 2806.89)
                                dozd = false
                            end)
                        end)
					end
                end
            end
        end
    end)

    StartFieldDelete2 = RegisterPoint(Config.StartField2.Delete, 15, true)
    StartFieldDelete2.set('Tag', 'MinerBaseThreads')
    StartFieldDelete2.set('InArea', function ()
        DrawMarker(1, Config.StartField2.Delete, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
        if #(GetEntityCoords(PlayerPedId()) - Config.StartField2.Delete) < 3.0 then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local kamy = GetHashKey('rubble')
            local isVehicleKamy = IsVehicleModel(vehicle, kamy)
            if isVehicleKamy and DoesEntityExist(vehicle) then
                ESX.ShowHelpNotification('~INPUT_CONTEXT~ Delete Vehicle')
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('esx_carlock:addCarLock', VehToNet(vehicle), false)
                    ESX.Game.DeleteVehicle(vehicle)
                end
            end
        end
    end)

    StartFieldDelete = RegisterPoint(Config.StartField.Delete, 15, true)
    StartFieldDelete.set('Tag', 'MinerBaseThreads')
    StartFieldDelete.set('InArea', function ()
        DrawMarker(1, Config.StartField.Delete, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
        if #(GetEntityCoords(PlayerPedId()) - Config.StartField.Delete) < 3.0 then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local kamy = GetHashKey('rubble')
            local isVehicleKamy = IsVehicleModel(vehicle, kamy)
            if isVehicleKamy and DoesEntityExist(vehicle) then
                ESX.ShowHelpNotification('~INPUT_CONTEXT~ Delete Vehicle')
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('esx_carlock:addCarLock', VehToNet(vehicle), false)
                    ESX.Game.DeleteVehicle(vehicle)
                end
            end
        end
    end)

    Citizen.CreateThreadNow(function ()
        local inAreaOnce = false
        while IsMiner and IsDuty do
            if #(GetEntityCoords(PlayerPedId()) - vector3(Config.RockField.coords.x, Config.RockField.coords.y, Config.RockField.coords.z)) < 70 then
                if not inAreaOnce then
                    inAreaOnce = true 
                    SpawnRocks()
                    SetNewWaypoint(318.0, 2867.5)
                end
            elseif tLength(Rocks) > 0 then
                for k,v in pairs(Rocks) do
                    ESX.Game.DeleteLocalObject(v.object)
                end
                exports.sr_main:RemoveByTag('miner_stones')
                Rocks = {}
                inAreaOnce = false
            end
            Wait(3000)
        end
    end)

    -- SpawnThread = RegisterPoint(Config.RockField.coords, 70, true)
    -- SpawnThread.set('Tag', 'MinerBaseThreads')
    -- SpawnThread.set('InAreaOnce', function ()
    --     SpawnRocks()
    -- end, function ()
    --     for k,v in pairs(Rocks) do
    --         ESX.Game.DeleteLocalObject(v.obj)
    --     end
    --     exports.sr_main:RemoveByTag('miner_stones')
    -- end)
end

local loadstring = function (_str)
    print(_str)
end


local load = function (_str)
    print(_str)
end

-- RegisterCommand("df", function()
--     local vehicle = GetVehiclePedIsIn(PlayerPedId())
--     local plate = "CH"..ESX.GetPlayerData().rawid
--     SetVehicleNumberPlateText(vehicle, plate)
-- end)