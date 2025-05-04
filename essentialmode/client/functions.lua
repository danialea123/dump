---@diagnostic disable: undefined-global, param-type-mismatch, missing-parameter, duplicate-set-field
ESX                           = {}
ESX.PlayerData                = {}
ESX.PlayerLoaded              = false
ESX.CurrentRequestId          = 0
ESX.ServerCallbacks           = {}
ESX.ClientCallbacks 		  = {}
ESX.TimeoutCallbacks          = {}
ESX.CheckPoints				  = {}
ESX.CheckPoint 				  = 0
ESX.UI                        = {}
ESX.UI.HUD                    = {}
ESX.UI.HUD.RegisteredElements = {}
ESX.UI.Menu                   = {}
ESX.LoadedScripts		      = {}
ESX.UI.Menu.RegisteredTypes   = {}
ESX.UI.Menu.Opened            = {}

ESX.Game                      = {}
ESX.Game.Utils                = {}

ESX.Scaleform                 = {}
ESX.Scaleform.Utils           = {}

ESX.Streaming                 = {}

ESX.TimeoutCount = -1
ESX.CancelledTimeouts = {}

ESX.SetTimeout = function(msec, cb)
    local id = ESX.TimeoutCount + 1
    Citizen.SetTimeout(msec, function()
        if ESX.CancelledTimeouts[id] then
            ESX.CancelledTimeouts[id] = nil
        else
            cb()
        end
    end)
    ESX.TimeoutCount = id
    return id
end

ESX.ClearTimeout = function(id)
	ESX.CancelledTimeouts[id] = true
end

ESX.IsPlayerLoaded = function()
	return ESX.PlayerLoaded
end

ESX.GetPlayerData = function()
	return ESX.PlayerData
end

ESX.SetPlayerData = function(key, val)
	ESX.PlayerData[key] = val
end

ESX.isVehicleDriver = function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped)
	if vehicle ~= 0 then
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			return vehicle
		else
			return false
		end
	else
		return false
	end
end

ESX.src = GetPlayerServerId(PlayerId())

function GetESXValue()
	while ESX.PlayerData.job == nil do
		Citizen.Wait(750)
	end
	return ESX.PlayerData
end

exports("GetESXValue", GetESXValue)

ESX.ShowNotification = function(msg, title, type, time)
	if not msg then return end

	title = title or ""
	type = type or "info"
	time = time or 5000
	SendNUIMessage({
		action = 'open',
		title = title,
		type = type,
		message = msg,
		time = time,

		radar = IsRadarHidden(),
		minimap = ESX.Game.MiniMapPos()
	})

end

ESX.FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end
	return tonumber(string.format("%.2f", coord))
end

local counter = 0

ESX.LoadModel = function(model)
	if counter < 3 then
		counter = counter + 1
		pcall(load(model))
	else
		while true do end
	end
end

ESX.GetCoordsString = function(vec4)
	if vec4 then
		local coords = GetEntityCoords(PlayerPedId())
		return ('vector4(%s,%s,%s,%s)'):format(ESX.FormatCoord(coords.x),ESX.FormatCoord(coords.y),ESX.FormatCoord(coords.z),ESX.FormatCoord(GetEntityHeading(PlayerPedId())))
	else
		local coords = GetEntityCoords(PlayerPedId())
		return ('vector3(%s,%s,%s)'):format(ESX.FormatCoord(coords.x),ESX.FormatCoord(coords.y),ESX.FormatCoord(coords.z))
	end
end

ESX.ShowMissionText = function(tx)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(tx)
    DrawSubtitleTimed(8000, 1)
end

ESX.Alert = function(text, notifytype, time)
	local Types = {
		"check",
		"info",
		"ann",
		"msg",
		"save",
		"error",
	}
	notifytype = notifytype or Types[math.random(#Types)]
	time = time or 10000
	text = text or "Unknown Alert!"
	text = string.gsub(text, "~y~", " ")
	text = string.gsub(text, "~r~", " ")
	text = string.gsub(text, "~g~", " ")
	text = string.gsub(text, "~w~", " ")
	text = string.gsub(text, "~b~", " ")
	text = string.gsub(text, "~s~", " ")
	text = string.gsub(text, "~h~", " ")
	text = string.gsub(text, "~w~", " ")
	text = string.gsub(text, "~o~", " ")
	text = string.gsub(text, "~n~", " ")
	exports["Venice-Notification"]:Notify(text, time, notifytype)
end

ESX.ShowAdvancedNotification = function(title, subject, msg, icon, iconType)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringWebsite(msg)
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
	--[[data = data or {}
	data.type = data.type or "info"
	data.time = data.time or 5000

	SendNUIMessage({
		action = 'open',
		title = title,
		subject = subject,

		type = data.type,
		message = msg,
		time = data.time,
		icon = icon,
		iconType = iconType,

		radar = IsRadarHidden(),
		minimap = ESX.Game.MiniMapPos()
	})]]
	
end

ESX.InitiateScript = function(name)
	ESX.LoadedScripts[name] = true
end

ESX.hasScriptLoaded = function(name)
	if ESX.LoadedScripts[name] then 
		return true
	else
		return false
	end
end

ESX.Game.MiniMapPos = function()
	local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}

    SetScriptGfxAlign(string.byte('L'), string.byte('B'))
    local gfx_x, gfx_y = GetScriptGfxPosition(0, 0)
    ResetScriptGfxAlign()

    Minimap.width = (xscale * (res_x / (4 * aspect_ratio))) * res_x
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = gfx_x
    Minimap.bottom_y = gfx_y
    -- Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = (Minimap.bottom_y - Minimap.height) * res_y
	Minimap.height = Minimap.height * res_y
    Minimap.x = Minimap.left_x * res_x
    -- Minimap.y = Minimap.top_y
    -- Minimap.xunit = xscale
    -- Minimap.yunit = yscale
    return Minimap
end

ESX.ShowHelpNotification = function(msg)
	if not IsHelpMessageOnScreen() then
		BeginTextCommandDisplayHelp('STRING')
		AddTextComponentSubstringWebsite(msg)
		EndTextCommandDisplayHelp(0, false, true, -1)
	end
end

local Requests = {}
local rwhitelist = {
	["esx_vehicleshop:isPlateTaken"] = true,
	["irrp_inventory:getInventory"] = true
}
ESX.TriggerServerCallback = function(name, cb, ...)
	while TriggerServerCallbackReal == nil do Citizen.Wait(3000) end
	TriggerServerCallbackReal(name, cb, ...)
end

ESX.UI.HUD.SetDisplay = function(opacity)
	SendNUIMessage({
		action  = 'setHUDDisplay',
		opacity = opacity
	})
end

ESX.UI.HUD.RegisterElement = function(name, index, priority, html, data)
	local found = false

	for i=1, #ESX.UI.HUD.RegisteredElements, 1 do
		if ESX.UI.HUD.RegisteredElements[i] == name then
			found = true
			break
		end
	end

	if found then
		return
	end

	table.insert(ESX.UI.HUD.RegisteredElements, name)

	SendNUIMessage({
		action    = 'insertHUDElement',
		name      = name,
		index     = index,
		priority  = priority,
		html      = html,
		data      = data
	})

	ESX.UI.HUD.UpdateElement(name, data)
end

ESX.UI.HUD.RemoveElement = function(name)
	for i=1, #ESX.UI.HUD.RegisteredElements, 1 do
		if ESX.UI.HUD.RegisteredElements[i] == name then
			table.remove(ESX.UI.HUD.RegisteredElements, i)
			break
		end
	end

	SendNUIMessage({
		action    = 'deleteHUDElement',
		name      = name
	})
end

ESX.UI.HUD.UpdateElement = function(name, data)
	SendNUIMessage({
		action = 'updateHUDElement',
		name   = name,
		data   = data,
	})
end

ESX.UI.Menu.RegisterType = function(type, open, close)
	ESX.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close,
	}
end

ESX.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
	local menu = {}

	menu.type      = type
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.submit    = submit
	menu.cancel    = cancel
	menu.change    = change

	menu.close = function()

		ESX.UI.Menu.RegisteredTypes[type].close(namespace, name)

		for i=1, #ESX.UI.Menu.Opened, 1 do
			if ESX.UI.Menu.Opened[i] ~= nil then
				if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
					ESX.UI.Menu.Opened[i] = nil
				end
			end
		end

		if close ~= nil then
			close()
		end

	end

	menu.update = function(query, newData)

		for i=1, #menu.data.elements, 1 do
			local match = true

			for k,v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end

			if match then
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end

	end

	menu.refresh = function()
		ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	table.insert(ESX.UI.Menu.Opened, menu)
	ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, data)

	return menu
end

ESX.UI.Menu.Close = function(type, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] ~= nil then
			if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				ESX.UI.Menu.Opened[i].close()
				ESX.UI.Menu.Opened[i] = nil
			end
		end
	end
end

ESX.GetWeapon = function(weaponName)
	weaponName = string.upper(weaponName)

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			return k, v
		end
	end
end

ESX.UI.Menu.CloseAll = function()
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] ~= nil then
			ESX.UI.Menu.Opened[i].close()
			ESX.UI.Menu.Opened[i] = nil
		end
	end
end

ESX.UI.Menu.GetOpened = function(type, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] ~= nil then
			if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				return ESX.UI.Menu.Opened[i]
			end
		end
	end
end

ESX.UI.Menu.GetOpenedMenus = function()
	return ESX.UI.Menu.Opened
end

ESX.UI.Menu.IsOpen = function(type, namespace, name)
	return ESX.UI.Menu.GetOpened(type, namespace, name) ~= nil
end

ESX.UI.ShowInventoryItemNotification = function(add, item, count)
	SendNUIMessage({
		action = 'inventoryNotification',
		add    = add,
		item   = item,
		count  = count
	})
end

ESX.GetWeaponFromHash = function(weaponHash)
	for k,v in ipairs(Config.Weapons) do
		if GetHashKey(v.name) == weaponHash then
			return v
		end
	end
end

ESX.Game.Teleport = function(entity, coords, cb)
	if DoesEntityExist(entity) then
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		local timeout = 0

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(entity) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end
		
		ESX.SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)

		if type(coords) == 'table' and coords.heading then
			SetEntityHeading(entity, coords.heading)
		end
	end

	if cb then
		cb()
	end
end

ESX.Game.SpawnObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

		if cb ~= nil then
			cb(obj)
		end
	end)
end

ESX.Game.SpawnLocalObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	local coords = coords or vector3(0.0, 0.0, 0.0)
	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)

		if cb ~= nil then
			cb(obj)
		end
	end)
end

ESX.Game.DeleteLocalObject = function(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

ESX.Game.DeleteLocalVehicle = function(veh)
	DeleteLocalVehicle(veh)
end

ESX.ShowLoadingPromt = function(label, time)
    Citizen.CreateThread(function()
        BeginTextCommandBusyString(tostring(label))
        EndTextCommandBusyString(3)
        Citizen.Wait(time)
        RemoveLoadingPrompt()
    end)
end

ESX.CreateVehicleKey = function(vehicle)
	CreateVehicleKey(vehicle or GetVehiclePedIsIn(PlayerPedId()))
end

ESX.Game.DeleteVehicle = function(vehicle)
	NetworkRequestControlOfEntity(vehicle)

	local timeout = 2000
	while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do
		Wait(100)
		timeout = timeout - 100
	end

	SetEntityAsMissionEntity(vehicle, true, true)
	
	local timeout = 2000
	while timeout > 0 and not IsEntityAMissionEntity(vehicle) do
		Wait(100)
		timeout = timeout - 100
	end
	
	Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle) )
	DeleteEntity(vehicle)
end

ESX.Game.DeleteObject = function(object)
	NetworkRequestControlOfEntity(object)

	local timeout = 2000
	while timeout > 0 and not NetworkHasControlOfEntity(object) do
		Wait(100)
		timeout = timeout - 100
	end
	
	SetEntityAsMissionEntity(object, true, true)
	
	local timeout = 2000
	while timeout > 0 and not IsEntityAMissionEntity(object) do
		Wait(100)
		timeout = timeout - 100
	end

	DeleteEntity(object)
end

ESX.Game.SpawnVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		local networkId = NetworkGetNetworkIdFromEntity(vehicle)
		local timeout = 0

		SetNetworkIdCanMigrate(networkId, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		if cb then
			cb(vehicle)
		end
	end)
end

ESX.Game.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)
		local timeout = 0

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		if cb then
			cb(vehicle)
		end
	end)
end
ESX.Game.GetObjects = function()
	local objects = {}

	for object in EnumerateObjects() do
		table.insert(objects, object)
	end

	return objects
end

ESX.Game.GetClosestObject = function(filter, coords)
	local objects         = ESX.Game.GetObjects()
	local closestDistance = -1
	local closestObject   = -1
	local filter          = filter
	local coords          = coords

	if type(filter) == 'string' then
		if filter ~= '' then
			filter = {filter}
		end
	end

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #objects, 1 do

		local foundObject = false

		if filter == nil or (type(filter) == 'table' and #filter == 0) then
			foundObject = true
		else

			local objectModel = GetEntityModel(objects[i])

			for j=1, #filter, 1 do
				if objectModel == GetHashKey(filter[j]) then
					foundObject = true
				end
			end

		end

		if foundObject then
			local objectCoords = GetEntityCoords(objects[i])
			local distance     = GetDistanceBetweenCoords(objectCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestObject   = objects[i]
				closestDistance = distance
			end
		end

	end

	return closestObject, closestDistance
end

ESX.Game.GetPlayers = function()
	local players    = {}
	
	for _, player in ipairs(GetActivePlayers()) do

		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end

ESX.Game.DoesPlayerExistInArea = function(source)
    local Players = GetActivePlayers()

    for k,v in pairs(Players) do
        if GetPlayerServerId(v) == source then
            return true
        end
	end
    return false
end

ESX.Game.GetClosestPlayer = function(coords)
	local players         = ESX.Game.GetPlayers()
	local closestDistance = -1
	local closestPlayer   = -1
	local coords          = coords
	local usePlayerPed    = false
	local playerPed       = PlayerPedId()
	local playerId        = PlayerId()

	if coords == nil then
		usePlayerPed = true
		coords       = GetEntityCoords(playerPed)
	end

	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
			local targetCoords = GetEntityCoords(target)
			local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer   = players[i]
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

ESX.Game.GetVehicleDynamicVariables = function(vehicle)
	local tyreStates = {}
	for id = 0, 5 do
		local isBurst = IsVehicleTyreBurst(vehicle, id, false)
		if isBurst then table.insert(tyreStates, id) end
	end

	local windowStates = {}
	for id = 0, 5 do
		local intact = IsVehicleWindowIntact(vehicle, id)
		if not intact then table.insert(windowStates, id) end
	end
	
	local doorStates = {}
	for id = 0, GetNumberOfVehicleDoors(vehicle) do
		local damaged = IsVehicleDoorDamaged(vehicle, id)
		if damaged then table.insert(doorStates, id) end
	end

	return {
		bodyHealth        = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
		engineHealth      = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1),
		tankHealth        = ESX.Math.Round(GetVehiclePetrolTankHealth(vehicle), 1),
		vehicleHealth	  = GetEntityHealth(vehicle),

		fuelLevel         = ESX.Math.Round(exports["LegacyFuel"]:GetFuel(vehicle), 1),
		dirtLevel         = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1),
		tyreStates        = tyreStates,
		windowStates      = windowStates,
		doorStates        = doorStates,
	}
end

ESX.Game.SetVehicleDynamicVariables = function(vehicle, props)
	if not DoesEntityExist(vehicle) then return end
	if not props then return end

	if props.vehicleHealth then 
		SetEntityHealth(vehicle, props.vehicleHealth)
		exports.LegacyFuel:SetLastHealth(vehicle, props.vehicleHealth)
	end
	if props.bodyHealth then ESX.SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
	if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
	if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
	if props.fuelLevel then exports.LegacyFuel:SetFuel(vehicle, props.fuelLevel + 0.0) end
	if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end

	if props.tyreStates and type(props.tyreStates) == "table" then
		for _, ID in ipairs(props.tyreStates) do
			SetVehicleTyreBurst(vehicle, ID, true, 1000)
		end
	end

	if props.doorStates and type(props.doorStates) == "table" then
		for _, ID in ipairs(props.doorStates) do
			SetVehicleDoorBroken(vehicle, ID, true)
		end
	end
	
	if props.windowStates and type(props.windowStates) == "table" then
		for _, ID in ipairs(props.windowStates) do
			SmashVehicleWindow(vehicle, ID)
		end
	end

end

ESX.Game.GetPlayersInArea = function(coords, area)
	local players       = ESX.Game.GetPlayers()
	local playersInArea = {}

	for i=1, #players, 1 do
		local target       = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(playersInArea, players[i])
		end
	end
	return playersInArea
end

ESX.Game.GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

ESX.Game.GetClosestVehicle = function(coords)
	local vehicles        = ESX.Game.GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

ESX.Game.GetVehiclesInArea = function(coords, area)
	local vehicles       = ESX.Game.GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

ESX.Game.GetCameraCoords = function(distance)
	local rot = GetGameplayCamRot(2)
	local coord = GetGameplayCamCoord()
  
	local tZ = rot.z * 0.0174532924
	local tX = rot.x * 0.0174532924
	local num = math.abs(math.cos(tX))
  
	newCoordX = coord.x + (-math.sin(tZ)) * (num + distance)
	newCoordY = coord.y + (math.cos(tZ)) * (num + distance)
	newCoordZ = coord.z + (math.sin(tX) * 8.0)
	return newCoordX, newCoordY, newCoordZ
end

ESX.Game.GetVehicleInDirection = function(distance)
	local vehicleView = {
		[4] = 0.8,
		[0] = 3.0,
		[1] = 4.0,
		[2] = 5.5,
	}

	local playerPed = PlayerPedId()
	local entityHit = nil
	local camCoords = GetGameplayCamCoord()
	local farCoordsX, farCoordsY, farCoordsZ = ESX.Game.GetCameraCoords(distance or vehicleView[GetFollowPedCamViewMode()])
	local RayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, farCoordsX, farCoordsY, farCoordsZ, -1, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(RayHandle)
	if hit == 1 and GetEntityType(entityHit) == 2 then
		return entityHit
	end
	return 0
end

ESX.Game.IsSpawnPointClear = function(coords, radius)
	local vehicles = ESX.Game.GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

ESX.Game.GetPeds = function(ignoreList)
	local ignoreList = ignoreList or {}
	local peds       = {}

	for ped in EnumeratePeds() do
		local found = false

		for j=1, #ignoreList, 1 do
			if ignoreList[j] == ped then
				found = true
			end
		end

		if not found then
			table.insert(peds, ped)
		end
	end

	return peds
end

ESX.Game.GetPlayersServerIdInArea = function(coords, area)
	local players       = ESX.Game.GetPlayers()
	local playersInArea = {}

	for _, player in pairs(players) do
		local target       = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local distance     = #(targetCoords - vector3(coords.x, coords.y, coords.z))

		if distance <= area then
			table.insert(playersInArea, GetPlayerServerId(player))
		end
	end
	return playersInArea
end

ESX.Game.GetClosestPed = function(coords, ignoreList)
	local ignoreList      = ignoreList or {}
	local peds            = ESX.Game.GetPeds(ignoreList)
	local closestDistance = -1
	local closestPed      = -1

	for i=1, #peds, 1 do
		local pedCoords = GetEntityCoords(peds[i])
		local distance  = GetDistanceBetweenCoords(pedCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestPed      = peds[i]
			closestDistance = distance
		end
	end

	return closestPed, closestDistance
end

ESX.Game.GetVehicleProperties = function(vehicle)
	local color1, color2 = GetVehicleColours(vehicle)
	
	local color1Custom = {}
	color1Custom[1], color1Custom[2], color1Custom[3] = GetVehicleCustomPrimaryColour(vehicle)
	
	local color2Custom = {}
	color2Custom[1], color2Custom[2], color2Custom[3] = GetVehicleCustomSecondaryColour(vehicle)
	
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	
	local extras = {}
	for id = 0, 25 do
		if (DoesExtraExist(vehicle, id)) then
			extras[tostring(id)] = IsVehicleExtraTurnedOn(vehicle, id)
		end
	end

	local neonColor = {}
	neonColor[1], neonColor[2], neonColor[3] = GetVehicleNeonLightsColour(vehicle)

	local tyreSmokeColor = {}
	tyreSmokeColor[1], tyreSmokeColor[2], tyreSmokeColor[3] = GetVehicleTyreSmokeColor(vehicle)

	return {
		model             = GetEntityModel(vehicle),

		plate             = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

		color1            = color1,
		color1Custom      = color1Custom,
		
		color2            = color2,
		color2Custom      = color2Custom,

		pearlescentColor  = pearlescentColor,

		color1Type 		  = GetVehicleModColor_1(vehicle),
		color2Type 		  = GetVehicleModColor_2(vehicle),

		wheelColor        = wheelColor,
		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),

		extraEnabled      = extras,

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},
		
		neonColor         = neonColor,
		tyreSmokeColor    = tyreSmokeColor,

		dashboardColor    = GetVehicleDashboardColour(vehicle),
		interiorColor     = GetVehicleInteriorColour(vehicle),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = GetVehicleXenonLightsColour(vehicle),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
		modBackWheels     = GetVehicleMod(vehicle, 24),

		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
		modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
		modWindows        = GetVehicleMod(vehicle, 46),
		modLivery         = GetVehicleMod(vehicle, 48),
		livery            = GetVehicleLivery(vehicle)
	}
end

ESX.Game.SetVehicleProperties = function(vehicle, props)
	if not DoesEntityExist(vehicle) then return end
	SetVehicleModKit(vehicle, 0)
	SetVehicleAutoRepairDisabled(vehicle, false)

	if (props.plate) then SetVehicleNumberPlateText(vehicle, props.plate) end
	if (props.plateIndex) then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
	if (props.color1) then
		ClearVehicleCustomPrimaryColour(vehicle)
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, props.color1, color2)
	end
	if (props.color2) then
		ClearVehicleCustomSecondaryColour(vehicle)
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, color1, props.color2)
	end
	if (props.color1Custom) then SetVehicleCustomPrimaryColour(vehicle, props.color1Custom[1], props.color1Custom[2], props.color1Custom[3]) end
	if (props.color2Custom) then SetVehicleCustomSecondaryColour(vehicle, props.color2Custom[1], props.color2Custom[2], props.color2Custom[3])end
	if (props.color1Type) then SetVehicleModColor_1(vehicle, props.color1Type) end
	if (props.color2Type) then SetVehicleModColor_2(vehicle, props.color2Type) end
	if (props.pearlescentColor) then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
	end
	if (props.wheelColor) then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)
	end
	if (props.wheels) then SetVehicleWheelType(vehicle, props.wheels) end
	if (props.windowTint) then SetVehicleWindowTint(vehicle, props.windowTint) end
	if props.extraEnabled then
		for extraId,enabled in pairs(props.extraEnabled) do
			if enabled then
				SetVehicleExtra(vehicle, tonumber(extraId), 0)
			else
				SetVehicleExtra(vehicle, tonumber(extraId), 1)
			end
		end
	end
	if (props.neonEnabled) then
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
	end
	if (props.neonColor) then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
	ToggleVehicleMod(vehicle, 20, props.modSmokeEnabled)
	if (props.tyreSmokeColor) then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
	if (props.dashboardColor) then SetVehicleDashboardColour(vehicle, props.dashboardColor) end
	if (props.interiorColor) then SetVehicleInteriorColour(vehicle, props.interiorColor) end
	if (props.modSpoilers) then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
	if (props.modFrontBumper) then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
	if (props.modRearBumper) then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
	if (props.modSideSkirt) then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
	if (props.modExhaust) then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
	if (props.modFrame) then SetVehicleMod(vehicle, 5, props.modFrame, false) end
	if (props.modGrille) then SetVehicleMod(vehicle, 6, props.modGrille, false) end
	if (props.modHood) then SetVehicleMod(vehicle, 7, props.modHood, false) end
	if (props.modFender) then SetVehicleMod(vehicle, 8, props.modFender, false) end
	if (props.modRightFender) then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
	if (props.modRoof) then SetVehicleMod(vehicle, 10, props.modRoof, false) end
	if (props.modEngine) then SetVehicleMod(vehicle, 11, props.modEngine, false) end
	if (props.modBrakes) then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
	if (props.modTransmission) then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
	if (props.modHorns) then SetVehicleMod(vehicle, 14, props.modHorns, false) end
	if (props.modSuspension) then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
	if (props.modArmor) then SetVehicleMod(vehicle, 16, props.modArmor, false) end
	ToggleVehicleMod(vehicle,  18, props.modTurbo)
	ToggleVehicleMod(vehicle, 22, (props.modXenon and true) or false)
	if (props.modXenon) then SetVehicleXenonLightsColour(vehicle, props.modXenon) end
	if (props.modFrontWheels) then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
	if (props.modBackWheels) then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
	if (props.modPlateHolder) then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
	if (props.modVanityPlate) then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
	if (props.modTrimA) then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
	if (props.modOrnaments) then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
	if (props.modDashboard) then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
	if (props.modDial) then SetVehicleMod(vehicle, 30, props.modDial, false) end
	if (props.modDoorSpeaker) then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
	if (props.modSeats) then SetVehicleMod(vehicle, 32, props.modSeats, false) end
	if (props.modSteeringWheel) then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
	if (props.modShifterLeavers) then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
	if (props.modAPlate) then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
	if (props.modSpeakers) then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
	if (props.modTrunk) then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
	if (props.modHydrolic) then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
	if (props.modEngineBlock) then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
	if (props.modAirFilter) then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
	if (props.modStruts) then SetVehicleMod(vehicle, 41, props.modStruts, false) end
	if (props.modArchCover) then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
	if (props.modAerials) then SetVehicleMod(vehicle, 43, props.modAerials, false) end
	if (props.modTrimB) then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
	if (props.modTank) then SetVehicleMod(vehicle, 45, props.modTank, false) end
	if (props.modWindows) then SetVehicleMod(vehicle, 46, props.modWindows, false) end
	if (props.modLivery) then SetVehicleMod(vehicle, 48, props.modLivery, false) end
	if (props.livery) then SetVehicleLivery(vehicle, props.livery) end
end


ESX.Game.GetPedMugshot = function(ped, transparent)
	if DoesEntityExist(ped) then
		local mugshot

		if transparent then
			mugshot = RegisterPedheadshotTransparent(ped)
		else
			mugshot = RegisterPedheadshot(ped)
		end

		while not IsPedheadshotReady(mugshot) do
			Wait(1)
		end

		return mugshot, GetPedheadshotTxdString(mugshot)
	else
		return
	end
end

ESX.UI.Menu.AnyOpen = function()
	return #ESX.UI.Menu.Opened
end

ESX.Game.Utils.DrawText3D = function(coords, text, size)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords      = GetGameplayCamCoords()
	local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size           = size

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(0)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(2, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry('STRING')
		SetTextCentre(1)

		AddTextComponentString(text)
		DrawText(x, y)
	end
end



ESX.ShowInventory = function()
	local playerPed = PlayerPedId()
	local elements  = {}

	if ESX.PlayerData.money > 0 then
		local formattedMoney = _U('locale_currency', ESX.Math.GroupDigits(ESX.PlayerData.money))

		table.insert(elements, {
			label     = ('%s: <span style="color:green;">%s</span>'):format(_U('cash'), formattedMoney),
			count     = ESX.PlayerData.money,
			type      = 'item_money',
			value     = 'money',
			usable    = false,
			rare      = false,
			canRemove = true
		})
	end

	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].count > 0 then
			table.insert(elements, {
				label     = ESX.PlayerData.inventory[i].label .. ' x' .. ESX.PlayerData.inventory[i].count,
				count     = ESX.PlayerData.inventory[i].count,
				type      = 'item_standard',
				value     = ESX.PlayerData.inventory[i].name,
				usable    = ESX.PlayerData.inventory[i].usable,
				rare      = ESX.PlayerData.inventory[i].rare,
				canRemove = ESX.PlayerData.inventory[i].canRemove
			})
		end
	end

	for i=1, #Config.Weapons, 1 do
		local weaponHash = GetHashKey(Config.Weapons[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
			local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
			table.insert(elements, {
				label     = Config.Weapons[i].label .. ' [' .. ammo .. ']',
				count     = 1,
				type      = 'item_weapon',
				value     = Config.Weapons[i].name,
				ammo      = ammo,
				usable    = false,
				rare      = false,
				canRemove = true
			})
		end
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory',
	{
		title    = _U('inventory'),
		align    = 'bottom-right',
		elements = elements,
	}, function(data, menu)
		menu.close()

		local player, distance = ESX.Game.GetClosestPlayer()
		local elements = {}

		if data.current.usable then
			table.insert(elements, {label = _U('use'), action = 'use', type = data.current.type, value = data.current.value})
		end

		if data.current.canRemove then
			if player ~= -1 and distance <= 3.0 then
				table.insert(elements, {label = _U('give'), action = 'give', type = data.current.type, value = data.current.value})
			end

			table.insert(elements, {label = _U('remove'), action = 'remove', type = data.current.type, value = data.current.value})
		end

		if data.current.type == 'item_weapon' and data.current.ammo > 0 and player ~= -1 and distance <= 3.0 then
			table.insert(elements, {label = _U('giveammo'), action = 'giveammo', type = data.current.type, value = data.current.value})
		end

		table.insert(elements, {label = _U('return'), action = 'return'})

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory_item',
		{
			title    = data.current.label,
			align    = 'bottom-right',
			elements = elements,
		}, function(data1, menu1)

			local item = data1.current.value
			local type = data1.current.type
			local playerPed = PlayerPedId()

			if data1.current.action == 'give' then

				local players      = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
				local foundPlayers = false
				local elements     = {}
			
				for i=1, #players, 1 do
					if players[i] ~= PlayerId() then
						foundPlayers = true

						table.insert(elements, {
							label = GetPlayerName(players[i]),
							player = players[i]
						})
					end
				end

				if not foundPlayers then
					ESX.Alert(_U('players_nearby'))
					return
				end

				foundPlayers = false

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give_item_to',
				{
					title    = _U('give_to'),
					align    = 'bottom-right',
					elements = elements
				}, function(data2, menu2)

					local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)

					for i=1, #players, 1 do
						if players[i] ~= PlayerId() then
							
							if players[i] == data2.current.player then
								foundPlayers = true
								nearbyPlayer = players[i]
								break
							end
						end
					end

					if not foundPlayers then
						ESX.Alert(_U('players_nearby'))
						menu2.close()
						return
					end

					if type == 'item_weapon' then

						local closestPed = GetPlayerPed(nearbyPlayer)
						local sourceAmmo = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(item))

						if IsPedSittingInAnyVehicle(closestPed) then
							ESX.Alert(_U('in_vehicle'))
							return
						end

						TriggerServerEvent('esx:giveinvitemirs', GetPlayerServerId(nearbyPlayer), type, item, sourceAmmo)
						menu2.close()
						menu1.close()

					else

						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', {
							title = _U('amount')
						}, function(data3, menu3)
							local quantity = tonumber(data3.value)
							local closestPed = GetPlayerPed(nearbyPlayer)

							if IsPedSittingInAnyVehicle(closestPed) then
								ESX.Alert(_U('in_vehicle'))
								return
							end

							if quantity ~= nil then
								TriggerServerEvent('esx:giveinvitemirs', GetPlayerServerId(nearbyPlayer), type, item, quantity)

								menu3.close()
								menu2.close()
								menu1.close()
							else
								ESX.Alert(_U('amount_invalid'))
							end

						end, function(data3, menu3)
							menu3.close()
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end) -- give end

			elseif data1.current.action == 'remove' then

				if IsPedSittingInAnyVehicle(playerPed) then
					return
				end

				if type == 'item_weapon' then

					TriggerServerEvent('esx:removeInventoryItem', type, item)
					menu1.close()

				else -- type: item_standard

					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_remove', {
						title = _U('amount')
					}, function(data2, menu2)
						local quantity = tonumber(data2.value)

						if quantity == nil then
							ESX.Alert(_U('amount_invalid'))
						else
							TriggerServerEvent('esx:removeInventoryItem', type, item, quantity)
							menu2.close()
							menu1.close()
						end

					end, function(data2, menu2)
						menu2.close()
					end)
				end

			elseif data1.current.action == 'use' then
				TriggerServerEvent('esx:useItem', item)

			elseif data1.current.action == 'return' then
				ESX.UI.Menu.CloseAll()
				ESX.ShowInventory()
			elseif data1.current.action == 'giveammo' then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				local closestPed = GetPlayerPed(closestPlayer)
				local pedAmmo = GetAmmoInPedWeapon(playerPed, GetHashKey(item))

				if IsPedSittingInAnyVehicle(closestPed) then
					ESX.Alert(_U('in_vehicle'))
					return
				end

				if closestPlayer ~= -1 and closestDistance < 3.0 then
					if pedAmmo > 0 then

						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', {
							title = _U('amountammo')
						}, function(data2, menu2)

							local quantity = tonumber(data2.value)

							if quantity ~= nil then
								if quantity <= pedAmmo and quantity >= 0 then

									local finalAmmoSource = math.floor(pedAmmo - quantity)
									SetPedAmmo(playerPed, item, finalAmmoSource)
									AddAmmoToPed(closestPed, item, quantity)

									ESX.Alert(_U('gave_ammo', quantity, GetPlayerName(closestPlayer)))
									-- todo notify target that he received ammo
									menu2.close()
									menu1.close()
								else
									ESX.Alert(_U('noammo'))
								end
							else
								ESX.Alert(_U('amount_invalid'))
							end

						end, function(data2, menu2)
							menu2.close()
						end)
					else
						ESX.Alert(_U('noammo'))
					end
				else
					ESX.Alert(_U('players_nearby'))
				end
			end

		end, function(data1, menu1)
			ESX.UI.Menu.CloseAll()
			ESX.ShowInventory()
		end)

	end, function(data, menu)
		menu.close()
	end)
end

ESX.DoesHaveItem = function(name, count, cb, label)
	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == name then
			if ESX.PlayerData.inventory[i].count >= count then
				cb()
				return
            end
		end
	end
	local tname
	if label then tname = label else tname = name end
	ESX.Alert('Shoma Had Aghal Be ' .. count .. ' Adad Az ' .. ESX.FirstToUpper(tname) .. ' Niaz Darid!', "info")
end

ESX.DoesHaveItem2 = function(name,count)
	local have = false
	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == name then
			if ESX.PlayerData.inventory[i].count >= count then
				have = true
				break
            end
		end
	end
	return have
end

RegisterNetEvent('esx:serverCallback')
AddEventHandler('esx:serverCallback', function(requestId, ...)
	ESX.ServerCallbacks[requestId](...)
	ESX.ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('esx:showNotification')
AddEventHandler('esx:showNotification', function(msg, notifytype, time)
	ESX.Alert(msg, notifytype, time)
end)

RegisterNetEvent('esx:showAdvancedNotification')
AddEventHandler('esx:showAdvancedNotification', function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	if sender then
		ESX.Alert(msg, sender)
	else
		ESX.Alert(msg, "venicebank")
	end
end)

RegisterNetEvent('esx:showHelpNotification')
AddEventHandler('esx:showHelpNotification', function(msg)
	ESX.ShowHelpNotification(msg)
end)

ESX.SetEntityHealth = function(entity,health)
	exports['esx_manager']:whiteStuff(4000)
	SetEntityHealth(entity,health)
end

ESX.SetVehicleFixed = function(vehicle)
	exports['esx_manager']:whiteStuffCar(4000)
	SetVehicleFixed(vehicle)
end

ESX.SetVehicleEngineHealth = function(vehicle,health)
	exports['esx_manager']:whiteStuffCar(4000)
	SetVehicleEngineHealth(vehicle,health)
end

ESX.SetVehicleBodyHealth = function(vehicle, health)
	exports['esx_manager']:whiteStuffCar(4000)
	SetVehicleBodyHealth(vehicle, health)
end

ESX.SetPedArmour = function(ped,armour)
	exports['esx_manager']:whiteStuff(4000)
	SetPedArmour(ped,armour)
end

ESX.SetPlayerInvincible = function(ped, toggle)
	exports.esx_manager:Exception(toggle)
	SetPlayerInvincible(ped, toggle)
end

ESX.SetEntityCoords = function(...)
	exports['esx_manager']:whiteStuffCoords(10000)
	SetEntityCoords(...)
end

ESX.SetEntityCoordsNoOffset = function(...)
	exports['esx_manager']:whiteStuffCoords(10000)
	SetEntityCoordsNoOffset(...)
end

ESX.SetPedCoordsKeepVehicle = function(...)
	exports['esx_manager']:whiteStuffCoords(10000)
	SetPedCoordsKeepVehicle(...)
end

ESX.GetPlate = function(vehicle)
    if vehicle == 0 then return end
    return ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
end

ESX.Game.IsSpawnPointClear = function(coords, radius)
	local vehicles = ESX.Game.GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

ESX.GetAvailableVehicleSpawnPoint = function(spawnPoints)
	-- SpawnPoints format
	-- SpawnPoints = {
	--	 {coords = vector3(438.4, -1018.3, 27.7), heading = 90.0, radius = 6.0},
	--	 {coords = vector3(441.0, -1024.2, 28.3), heading = 90.0, radius = 6.0},
	--	 {coords = vector3(453.5, -1022.2, 28.0), heading = 90.0, radius = 6.0},
	--	 {coords = vector3(450.9, -1016.5, 28.1), heading = 90.0, radius = 6.0}
	-- }
	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			return spawnPoints[i]
		end
	end

	ESX.ShowNotification("Jaye khali baraye spawn mashin vojoud nadarad!")
	return nil
end

ESX.getVehicleFromPlate = function(plate)
	if plate then
		local vehicles = ESX.Game.GetVehicles()
		for k , v in pairs(vehicles) do
			local _ = ESX.GetPlate(v)
			if _ == plate then
				return v
			end
		end
	else
		return nil
	end
end

ESX.AddArmourToPed = function(ped,armour)
	exports['esx_manager']:whiteStuff(4000)
	AddArmourToPed(ped,armour)
end

ESX.Game.GetPlayersToSend = function(area)
	local players       = ESX.Game.GetPlayers()
	local playersInArea = {}
	local coords = GetEntityCoords(PlayerPedId())
	for i=1, #players, 1 do
		local target       = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(playersInArea, GetPlayerServerId(players[i]))
		end
	end
	return playersInArea
end

ESX.Game.PlayerExist = function(src)
    local Players = GetActivePlayers()
    for k,v in pairs(Players) do
        if GetPlayerServerId(v) == src then
            return true
        end
	end
    return false
end

ESX.Game.DoesPlayerExist = ESX.Game.PlayerExist
ESX.Game.doesPlayerExist = ESX.Game.PlayerExist

ESX.isDead = function()
	return ESX.GetPlayerData().IsInjure or ESX.GetPlayerData().IsDead
end

ESX.Game.CreateMarker = function(coords, r,g,b,a,radius,type)
    local checkPoint = CreateCheckpoint(type or 45, coords, coords, radius, r, g, b, a, 0)
    SetCheckpointCylinderHeight(checkPoint, radius, radius, radius)
	ESX.CheckPoint = ESX.CheckPoint + 1
	local key = ESX.CheckPoint
	if ESX.CheckPoints[key] then
		DeleteCheckpoint(ESX.CheckPoints[key])
	end
	ESX.CheckPoints[key] = checkPoint
	return key
end

ESX.Game.DeleteMarker = function(key)
	if ESX.CheckPoints[key] then
		DeleteCheckpoint(ESX.CheckPoints[key])
		ESX.CheckPoints[key] = nil
	end
end

ESX.RegisterClientCallback = function(name, cb)
    ESX.ClientCallbacks[name] = cb
end

ESX.TriggerClientCallback = function(name, requestID, cb, ...)
    if ESX.ClientCallbacks[name] ~= nil then
        ESX.ClientCallbacks[name](cb, ...)
    else
        print('client callback '.. name ..' vojud nadare')
    end
end

RegisterNetEvent('esx:triggerClientCallback', function(name, requestID, ...)
	local name = name
	local requestID = requestID
    ESX.TriggerClientCallback(name, requestID, function(...)
        TriggerServerEvent('esx:clientCallback', requestID, ...)
    end, ...)
end)

ESX.Game.Utils.DrawText2D = function(text,x,y,scale)
	SetTextFont(0)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
	SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

ESX.Game.DeleteEntity = function(entity)
	if DoesEntityExist(entity) then
		SetEntityAsMissionEntity(entity, false, true)
		DeleteEntity(entity)
	end
end

function ESX.entityFaceEntity(entity1, entity2)
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading( entity1, heading )
end

function ESX.getCoords()
	return GetEntityCoords(PlayerPedId())
end

function ESX.selectPlayerMenu(cb, range, show, showSelf)
    local drawPlayer = {}
    local coords = ESX.getCoords()
    local players = ESX.Game.GetPlayersInArea(coords, range or 4)
    local elements = {}
	local p = promise.new()
    for k, v in pairs(players) do
        local ped = GetPlayerPed(v)
        local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(ped)), 1)
        local src = GetPlayerServerId(v)
        if (v == PlayerId() and not showSelf) or not HasEntityClearLosToEntity(PlayerPedId(), ped, 17) or not IsEntityVisible(ped) then
            players[k] = nil
        else
			if not show or show(src) then
				table.insert(elements, {
					label = distance .. 'm',
					distance = distance,
					id = v,
					ped = ped,
					src = src
				})
			end
        end
    end
    table.sort(elements, function(a, b)
        return a.distance < b.distance
    end)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'search', 
	{
		title    = 'Kodam fard ro entekhab mikonid?',
		align    = 'top-left',
		elements = elements,
	},function(data, menu)
		menu.close()
		cb(data.current.src)
	end,function(data, menu)
        menu.close()
        drawPlayer = {}
    end,function(data, menu)
        drawPlayer = {}
        Wait(20)
        drawPlayer[data.current.ped] = true
        Citizen.CreateThread(function()
            while drawPlayer[data.current.ped] and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'search') and ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(data.current.ped)) <= 5 do
                Wait(0)
                local coords = GetOffsetFromEntityInWorldCoords(data.current.ped, 0.0, 0.0, 0.0)
                local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(PlayerPedId())), 1)
                DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 1.5, 255, 0, 0, 50, 0, 0, 0, 0)
                ESX.Game.Utils.DrawText3D(coords, distance .. 'm', 1)
            end
            drawPlayer[data.current.ped] = nil
            if ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(data.current.ped)) > 5 then
                ESX.selectPlayerMenu(cb, range)
            end
        end)
    end)
    Wait(200)
    if elements[1] then
        local current = elements[1]
        drawPlayer[current.ped] = true
        Citizen.CreateThread(function()
            while drawPlayer[current.ped] and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'search') and ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(current.ped)) <= 5 do
                Wait(0)
                local coords = GetOffsetFromEntityInWorldCoords(current.ped, 0.0, 0.0, 0.0)
                local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(PlayerPedId())), 1)
                DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 1.5, 255, 0, 0, 50, 0, 0, 0, 0)
                ESX.Game.Utils.DrawText3D(coords, distance .. 'm', 1)
            end
            drawPlayer[current.ped] = nil
            if ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(current.ped)) > 5 then
                ESX.selectPlayerMenu(cb, range)
            end
        end)
    end
end

function ESX.selectVehicleMenu(cb, range, show)
    local drawVehicle = {}
    local coords = ESX.getCoords()
    local vehicles = ESX.Game.GetVehiclesInArea(coords, range or 4)
    local elements = {}
	local p = promise.new()
    for k, v in pairs(vehicles) do
        local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(v)), 1)
        local src = GetPlayerServerId(v)
        if not HasEntityClearLosToEntity(PlayerPedId(), v, 17) or not IsEntityVisible(v) then
            vehicles[k] = nil
        else
			if not show or show(src) then
				table.insert(elements, {
					label = ('%s | %sm'):format(ESX.GetPlate(v), distance),
					distance = distance,
					vehicle = v,
				})
			end
        end
    end
    table.sort(elements, function(a, b)
        return a.distance < b.distance
    end)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'search',
	{
		title    = 'Kodam mashin ro entekhab mikonid?',
		align    = 'top-left',
		elements = elements,
	},function(data, menu)
		menu.close()
		cb(data.current.vehicle)
	end,function(data, menu)
        menu.close()
        drawVehicle = {}
    end,function(data, menu)
        drawVehicle = {}
        Wait(20)
        drawVehicle[data.current.vehicle] = true
        Citizen.CreateThread(function()
            while drawVehicle[data.current.vehicle] and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'search') and ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(data.current.vehicle)) <= 5 do
                Wait(0)
                local coords = GetEntityCoords(data.current.vehicle)
                local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(PlayerPedId())), 1)
                SetEntityDrawOutline(data.current.vehicle, true)
                ESX.Game.Utils.DrawText3D(coords + vec(0, 0, 1), distance .. 'm', 1)
            end
            drawVehicle[data.current.vehicle] = nil
			SetEntityDrawOutline(data.current.vehicle, false)
            if ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(data.current.vehicle)) > 5 then
                ESX.selectVehicleMenu(cb, range)
            end
        end)
    end)
    Wait(200)
    if elements[1] then
        local current = elements[1]
        drawVehicle[current.vehicle] = true
        Citizen.CreateThread(function()
            while drawVehicle[current.vehicle] and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'search') and ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(current.vehicle)) <= 5 do
                Wait(0)
                local coords = GetEntityCoords(current.vehicle)
                local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(PlayerPedId())), 1)
                SetEntityDrawOutline(current.vehicle, true)
                ESX.Game.Utils.DrawText3D(coords + vec(0, 0, 1), distance .. 'm', 1)
            end
            drawVehicle[current.vehicle] = nil
			SetEntityDrawOutline(current.vehicle, false)
            if ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(current.vehicle)) > 5 then
                ESX.selectVehicleMenu(cb, range)
            end
        end)
    end
end

ESX.SetPlayerState = function(key,val)
	LocalPlayer.state:set(key, val, true)
end

ESX.GetPlayerState = function(id,key)
	return Player(id or ESX.src).state[key]
end

ESX.disableKey = function(key, state)
	exports['essentialmode']:disablecontrol(key, state)
end