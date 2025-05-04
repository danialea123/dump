---@diagnostic disable: missing-parameter, undefined-global, undefined-field
ESX = nil
local carMenuOpen = false
local SpamProtect = false
local response = true
local find = false
local oCars = {}
local dict = "anim@mp_player_intmenu@key_fob@"

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
	while not ESX.GetPlayerData().job do
		PlayerData = ESX.GetPlayerData()
		Citizen.Wait(100)
	end
	RequestAnimDict('anim@mp_player_intmenu@key_fob@')
	while not HasAnimDictLoaded('anim@mp_player_intmenu@key_fob@') do
		Citizen.Wait(100)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, oldjob)
	PlayerData.job = job
end)

exports("canLockVehicle", function(veh)
	local vehicle = veh or GetVehiclePedIsIn(PlayerPedId())
	local plate = GetVehicleNumberPlateText(vehicle)
	if vehicle and plate then
		if Config.Jobs[PlayerData.job.name] and (Config.Jobs[PlayerData.job.name].models[GetEntityModel(vehicle)] or string.sub(plate, 1, string.len(Config.Jobs[PlayerData.job.name].plate)) == Config.Jobs[PlayerData.job.name].plate) then
			return true
		else
			return false
		end
	else
		return false
	end
end)

RegisterKey("U", function()
	if not ESX then return end
	if ESX.isDead() then return end
	if ESX.GetPlayerData().isSentenced then return end
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        carMenuOpen = not carMenuOpen
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local doorData = {}
        local doorNum = GetVehicleModelNumberOfSeats(GetEntityModel(veh)) - 1
        for i = 0, 3 do
            local opened = false
            if GetVehicleDoorAngleRatio(veh, i) > 0.0 then
                opened = true
            end
            table.insert(doorData, {
                doorNum = tostring(i),
                opened = opened
            })
        end
        local mySeat = nil
        if doorNum > 10 then
            for i = -1, doorNum do
                if GetPedInVehicleSeat(veh, i) == 0 then
                else
                    mySeat = i
                end
            end
        elseif doorNum == 1 then
            for i = -1, doorNum - 1 do
                if GetPedInVehicleSeat(veh, i) == 0 then
                else
                    mySeat = i
                end
            end
        elseif doorNum == 0 then
            for i = -1, doorNum + 1 do
                if GetPedInVehicleSeat(veh, i) == 0 then
                else
                    mySeat = i
                end
            end
        else
            for i = -1, doorNum - 1 do
                if GetPedInVehicleSeat(veh, i) == 0 then
                else
                    mySeat = i
                end
            end
        end
        local retval, lights, highbeams = GetVehicleLightsState(veh)
        local hoodOpen = false
        if GetVehicleDoorAngleRatio(veh, 4) > 0.0 then
            hoodOpen = true
        end
        local trunkOpen = false
        if GetVehicleDoorAngleRatio(veh, 5) > 0.0 then
            trunkOpen = true
        end
		
        local indicatorState = GetVehicleIndicatorLights(veh)
        while mySeat == nil do Citizen.Wait(0) end
		SetNuiFocus(carMenuOpen, carMenuOpen)
        SendNUIMessage({
            action = "openCarMenu", resourceName = GetCurrentResourceName(), state = carMenuOpen, align = Config.Menu.Align, styleType = Config.Menu.StyleType, carData = {
                doorNum = 4,--GetVehicleModelNumberOfSeats(GetEntityModel(veh)),
				seatCount = GetVehicleModelNumberOfSeats(GetEntityModel(veh)),
                doorData = doorData,
                vehConvertible = IsVehicleAConvertible(veh, false),
                vehConvertibleState = GetConvertibleRoofState(veh),
                engineState = GetIsVehicleEngineRunning(veh),
                playerSeat = mySeat,
                intLightState = IsVehicleInteriorLightOn(veh),
                lightsOn = lights,
                highbeamsOn = highbeams,
                trunk = trunkOpen,
                hood = hoodOpen,
                indicatorState = indicatorState
            }
        })
    else
		CheckNearCars('esx_advancedgarage:DoesHaveKey')
    end
end)

RegisterNUICallback('callback', function(data)
    if data.action == "nuiFocus" then
        carMenuOpen = false
        SetNuiFocus(false, false)
    elseif data.action == "convertVeh" then
        PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if data.state == false then
            RaiseConvertibleRoof(veh, false)
        else
            LowerConvertibleRoof(veh, false)
        end
    elseif data.action == "window" then
        PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local num = data.num - 1
        if data.state == true then
            RollDownWindow(veh, num)
        else
            RollUpWindow(veh, num)
        end
    elseif data.action == "changeSeat" then
        PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if data.num == "driver" then
            if IsVehicleSeatFree(veh, -1) then
                SetPedIntoVehicle(PlayerPedId(), veh, -1)
            end
        else
            local num = tonumber(data.num)
            if IsVehicleSeatFree(veh, num) then
                SetPedIntoVehicle(PlayerPedId(), veh, num)
            end
        end
    elseif data.action == "engine" then
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		local plate = ESX.Math.Trim(GetVehicleNumberPlateText(veh))
		if ESX.DoesHaveItem2("key_"..plate, 1) then
			PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
			if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then 
				SetVehicleEngineOn(veh, data.state, false, true)
			end
		else
			ESX.Alert("Shoma Switch In Mashin Ra Nadarid", "error")
		end
    elseif data.action == "alarm" then
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		local plate = ESX.Math.Trim(GetVehicleNumberPlateText(veh))
		if ESX.DoesHaveItem2("key_"..plate, 1) then
			PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
			CheckNearCars('esx_advancedgarage:DoesHaveKey')
		else
			ESX.Alert("Shoma Switch In Mashin Ra Nadarid", "error")
		end
    elseif data.action == "intLight" then
        PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        SetVehicleInteriorlight(veh, data.state)
    elseif data.action == "lights" then
        PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if data.name == "normal" then
            SetVehicleLights(veh, 1)
            Citizen.Wait(500)
            SetVehicleLights(veh, 3)
        elseif data.name == "highbeams" then
            SetVehicleLights(veh, 1)
            Citizen.Wait(500)
            SetVehicleLights(veh, 3)
            SetVehicleFullbeam(veh, true)
        end
    elseif data.action == "door" then
        PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if data.state == true then
            if data.number == "trunk" then
                SetVehicleDoorOpen(veh, 5, false, false)
            elseif data.number == "hood" then
                SetVehicleDoorOpen(veh, 4, false, false)
            else
                SetVehicleDoorOpen(veh, tonumber(data.number), false, false)
            end
        else
            if data.number == "trunk" then
                SetVehicleDoorShut(veh, 5, false)
            elseif data.number == "hood" then
                SetVehicleDoorShut(veh, 4, false)
            else
                SetVehicleDoorShut(veh, tonumber(data.number), false)
            end
        end
    elseif data.action == "indicator" then
        PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        SetVehicleIndicatorLights(veh, data.name, data.state)
    end
end)

function CheckNearCars(event)
	if not SpamProtect then
		local coords = GetEntityCoords(PlayerPedId())
		local hasAlreadyLocked = false
		local carstrie = GetVehiclesInAreaSorted(coords, 30)
		local notowned = 0
		if #carstrie > 0 then
			SpamProtect = true
			SetTimeout(5000, function()
				SpamProtect = false
				find = false
				response = true
			end)
			response = true
			find = false
			for i=1, #carstrie, 1 do
				local time = GetGameTimer()
				while not response or (GetGameTimer() - time > 5000) do
					Wait(0)
				end
				if find then
					break
				end
				local plate = ESX.Math.Trim(GetVehicleNumberPlateText(carstrie[i]))
				local net = VehToNet(carstrie[i])
				local lock = GetVehicleDoorLockStatus(carstrie[i])
				local vehicleLabel = ESX.GetVehicleLabelFromHash(GetEntityModel(carstrie[i]))
				if event then
					response = false
					ESX.TriggerServerCallback(event, function(owner)
						response = true
						if owner then
							if lock == 1 then
								LockCar(net, vehicleLabel)
							elseif lock then
								UnlockCar(net, vehicleLabel)
							end
							find = true
						else
							notowned = notowned + 1
						end
					end, event == 'JobLock' and net or event == 'esx_advancedgarage:DoesHaveKey' and plate)
				else
					for k,v in pairs(oCars) do
						if v == net then
							if not lock then
								LockCar(net, vehicleLabel)
							elseif lock then
								UnlockCar(net, vehicleLabel)
							end
							break
						end
					end
				end
			end
			while not response do Citizen.Wait(150) end
			if notowned == #carstrie then
				ESX.Alert("Hich Mashini Atraf Shoma Nist Ya Shoma Kelid Mashin Haye Atraf Ra Nadarid", "info")
			end
		end
	else
		ESX.Alert("~r~Lotfan Spam nakonid", "error")
	end
end

function LockCar(vehicle, name)
	local vehicle = vehicle
	TriggerServerEvent('esx_carlock:SyncCarLock', vehicle, true)
	SetEntityDrawOutlineColor(51, 255, 255, 150)
	SetEntityDrawOutline(NetToVeh(vehicle), true)
	Citizen.SetTimeout(1000, function()
		SetEntityDrawOutline(NetToVeh(vehicle), false)
	end)
	CarLocker(vehicle, true)
	PlayVehicleDoorCloseSound(vehicle, 1)
	ESX.Alert('Shoma ~y~'..name..'~s~ ra ~r~ghofl~s~ kardid~s~.', "check")
	TriggerEvent("InteractSound_CL:PlayOnOne", "lock", 0.5)
	local text = '* vasile naghlie ro ghofl mikone *'
	--ExecuteCommand("me "..text)
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
		TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
	end
end

function UnlockCar(vehicle, name)
	local vehicle = vehicle
	TriggerServerEvent('esx_carlock:SyncCarLock', vehicle, false)
	SetEntityDrawOutlineColor(51, 255, 255, 150)
	SetEntityDrawOutline(NetToVeh(vehicle), true)
	Citizen.SetTimeout(1000, function()
		SetEntityDrawOutline(NetToVeh(vehicle), false)
	end)
	CarLocker(vehicle, false)
	PlayVehicleDoorOpenSound(vehicle, 0)
	ESX.Alert('Shoma ~y~'..name..'~s~ ra ~g~baz~s~ kardid~s~.', "check")
	TriggerEvent("InteractSound_CL:PlayOnOne", "unlock", 0.5)
	local text = '* vasile naghlie ro Baz mikone *'
	--ExecuteCommand("me "..text)
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
		TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
	end
end

function CarLocker(vehicle, toggle)
	if vehicle and vehicle ~= 0 then
		if toggle then
			SetVehicleDoorShut(NetToVeh(vehicle), 0, false)
			SetVehicleDoorShut(NetToVeh(vehicle), 1, false)
			SetVehicleDoorShut(NetToVeh(vehicle), 2, false)
			SetVehicleDoorShut(NetToVeh(vehicle), 3, false)
			SetVehicleDoorShut(NetToVeh(vehicle), 4, false)
			SetVehicleDoorShut(NetToVeh(vehicle), 5, false)
			SetVehicleDoorsLocked(vehicle, 2)
			--SetVehicleDoorsLockedForAllPlayers(NetToVeh(vehicle), true)
		else
			SetVehicleDoorsLocked(vehicle, 1)
			--SetVehicleDoorsLockedForAllPlayers(NetToVeh(vehicle), false)
		end
	end
end

GetVehiclesInAreaSorted = function(coords, area)
	local vehicles       = ESX.Game.GetVehicles()
	local vehiclesInArea = {}
	local temp 			 = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = #(vehicleCoords - vector3(coords.x, coords.y, coords.z))

		if distance <= area then
			table.insert(temp, {vehicle = vehicles[i], distance = distance})
		end
	end

	for i=1, #temp do
		local lower = Sort(temp)
		table.insert(vehiclesInArea, temp[lower].vehicle)
		table.remove(temp, lower)
	end

	return vehiclesInArea
end

function Sort(table)
	local lower = -1
	local index = 1
	for i=1, #table do
		if lower == -1 or table[i].distance < lower then
			lower = table[i].distance
			index = i
		end
	end
	return index
end

local List = {}
local Copy = {
    ["catcafe"] = vector3(-581.99,-1070.52,22.33),
    ['artist'] = vector3(97.67,210.61,107.91),
    ["blackmarket"] = vector3(137.65,-1777.76,29.74),    
    ["bahamas"] = vector3(-1387.63,-586.43,30.21),
    ["scardealer"] = vector3(-104.3,-2014.22,18.02),
    ["triad"] = vector3(-826.89,-701.17,28.06),
    ["kharchang"] = vector3(-1525.95,-1324.95,3.84),    
    ["streetclub"] = vector3(128.05,-1299.27,29.23),
	["cardealer"] = vector3(-1689.06,-883.77,8.98),

}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        local coord = GetEntityCoords(PlayerPedId())
		local Pause = true
		for k, v in pairs(List) do
			if #(v.coords - coord) <= 10.0 then
				Pause = false
				local data = v.Data
				DrawText3D(v.coords.x, v.coords.y, v.coords.z+2.5, "Dar Soorat Baste Boodan Maghaze Mitavanid Ba Shomare Haye Zir Tamas Begirid:")
				if data[1] then
					DrawText3D(v.coords.x, v.coords.y, v.coords.z+2.5, "\n~b~"..data[1].name.." ~y~"..data[1].phone.."\n")
				end
				if data[2] and not data[1] then
					DrawText3D(v.coords.x, v.coords.y, v.coords.z+2.5, "\n~b~"..data[2].name.." ~y~"..data[2].phone.."\n")
				elseif data[2] then
					DrawText3D(v.coords.x, v.coords.y, v.coords.z+2.5, "\n\n~b~"..data[2].name.." ~y~"..data[2].phone.."\n\n")
				end
				if data[3] and not data[1] and not data[2] then
					DrawText3D(v.coords.x, v.coords.y, v.coords.z+2.5, "\n~b~"..data[3].name.." ~y~"..data[3].phone.."\n")
				elseif data[3] and data[2] and not data[1] then
					DrawText3D(v.coords.x, v.coords.y, v.coords.z+2.5, "\n\n~b~"..data[3].name.." ~y~"..data[3].phone.."\n\n")
				elseif data[3] and not data[2] and data[1] then
					DrawText3D(v.coords.x, v.coords.y, v.coords.z+2.5, "\n\n~b~"..data[3].name.." ~y~"..data[3].phone.."\n\n")
				elseif data[3] then
					DrawText3D(v.coords.x, v.coords.y, v.coords.z+2.5, "\n\n\n~b~"..data[3].name.." ~y~"..data[3].phone.."\n\n\n")
				end
			end
		end
		if Pause then Citizen.Wait(1000) end
    end
end)

RegisterNetEvent("esx:UpdateJobPhoneInfo")
AddEventHandler("esx:UpdateJobPhoneInfo", function(name, data)
	if data.Active then
		List[name] = data
		List[name].coords = Copy[name]
	else
		List[name] = nil
	end
end)

RegisterNetEvent("esx:UpdateAllJobsPhone")
AddEventHandler("esx:UpdateAllJobsPhone", function(data)
	for k, v in pairs(data) do
		if v.Active then
			List[k] = v
			List[k].coords = Copy[k]
		else
			List[k] = nil
		end
	end
end)

local Protect = GetGameTimer()

RegisterCommand("pn", function()
	if GetGameTimer() - Protect <= 3000 then return end
	Protect = GetGameTimer()
    if Copy[PlayerData.job.name] and PlayerData.job.grade >= 4 then
		OpenMenu()
    end
end)

function OpenMenu()
	local coord = GetEntityCoords(PlayerPedId())
	if #(coord - Copy[PlayerData.job.name]) > 10.0 then return ESX.Alert("Shoma Bayad Nazdik Dar Asli Maghaze Khod Bashid", "info") end 
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback("esx:GetJobPhoneDetails", function(result)
		local elements = {}
		if result.Active then
			table.insert(elements, {label = ("Vaziat Display Matn: ✔️"), value = 'change'})
		else
			table.insert(elements, {label = ("Vaziat Display Matn: ❌"), value = 'change'})
		end
		table.insert(elements, {label = '=========================', value = nil})
		if result.Data[1] then
			table.insert(elements, {label = "Matn 1: "..result.Data[1].name.." "..result.Data[1].phone, value = 1})
		else
			table.insert(elements, {label = "Matn 1: ", value = 1})
		end
		if result.Data[2] then
			table.insert(elements, {label = "Matn 2: "..result.Data[2].name.." "..result.Data[2].phone, value = 2})
		else
			table.insert(elements, {label = "Matn 2: ", value = 2})
		end
		if result.Data[3] then
			table.insert(elements, {label = "Matn 3: "..result.Data[3].name.." "..result.Data[3].phone, value = 3})
		else
			table.insert(elements, {label = "Matn 3: ", value = 3})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'matn_menu',{
			title    = "Job Phone Text",
			align    = 'center',
			elements = elements
		}, function(data, menu)
			local action = data.current.value
			if action then
				if action == "change" then
					if not result.Active and not result.Data[1] and not result.Data[2] and not result.Data[3] then
						ESX.Alert("Shoma Baraye Toggle Kardan Payam Hadeaghal Bayad 1 Matn Neveshte Bashid", "info")
					else
						ESX.Alert("Tanzimat Save Shod", "check")
						menu.close()
						TriggerServerEvent("esx:changePhoneSettings", "toggle")
						Citizen.Wait(2000)
						OpenMenu()
					end
				else
					Citizen.Wait(1000)
					menu.close()
					ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'carry',
					{
						title 	 = 'Modiriat Matn '..action,
						align    = 'center',
						question = "Ghasd Hazf Ya Edit Matn "..action.." Ra Darid?",
						elements = {
							{label = 'Edit', value = 'edit'},
							{label = 'Delete', value = 'Delete'},
						}
					}, function(data2, menu2)
						if data2.current.value == "Delete" then
							if result.Data[action] then
								menu2.close()
								ESX.Alert("Tanzimat Save Shod", "check")
								TriggerServerEvent("esx:changePhoneSettings", "delete", action)
								Citizen.Wait(2000)
								OpenMenu()
							else
								ESX.Alert("Matni Baraye Hazf Kardan Vojud Nadarad", "info")
							end
						end
						if data2.current.value == "edit" then
							local input = lib.inputDialog('Taaghir Matn '..action, {'Esm Mored Nazar (HadAksar 10 Character)', 'Shomare Mobile (HadAksar 10 Character)'})
							if input and input[1] and input[2] then
								if tonumber(input[2]) and string.len(input[2]) <= 10 and string.len(input[1]) <= 10 then
									menu2.close()
									ESX.Alert("Tanzimat Save Shod", "check")
									TriggerServerEvent("esx:changePhoneSettings", "edit", action, input[1], input[2])
									Citizen.Wait(2000)
									OpenMenu()
								else
									ESX.Alert("HadAksar 10 Character Va Shomare Mobile Faghat Number", "info")
								end
							else
								ESX.Alert("Vorudi Na Motabar", "info")
							end
						end
					end, function(data2, menu2)
						OpenMenu()
					end)
				end
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end