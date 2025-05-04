ESX = nil
local PlayerData = nil, false
Spikes = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
    end
	PlayerData = ESX.GetPlayerData()
	ObjectsSubMenu()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	trafficmenu = NativeUI.CreateMenu(_U('title'), _U('subtitle'))
	_menuPool:Add(trafficmenu)
	ObjectsSubMenu()
	trafficmenu:Visible(false)
	_menuPool:MouseControlsEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	trafficmenu = NativeUI.CreateMenu(_U('title'), _U('subtitle'))
	_menuPool:Add(trafficmenu)
	ObjectsSubMenu()
	trafficmenu:Visible(false)
	_menuPool:MouseControlsEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end)

_menuPool = NativeUI.CreatePool()
trafficmenu = NativeUI.CreateMenu(_U('title'), _U('subtitle'))
_menuPool:Add(trafficmenu)

function LocalPed()
    return PlayerPedId()
end

CoolDown = 0

function ObjectsSubMenu()
	local objects = {}

	if PlayerData and PlayerData.job and Config[PlayerData.job.name] then
		for k,v in pairs(Config[PlayerData.job.name]) do
  		  	for k,v in pairs(v) do
  		  	    if k == "Displayname" then
  		  	      	table.insert(objects, v)
  		  	    end
  		  	end
		end

  		local objectlist = NativeUI.CreateListItem(_U('object_spawning'), objects, 1, _U('enter_to_spawn'))
  		local deletebutton = NativeUI.CreateItem(_U('delete'), _U('delete_help'))
  		trafficmenu:AddItem(deletebutton)
  		deletebutton.Activated = function(sender, item, index)
  		  	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
  		  	for k,v in pairs(Config[PlayerData.job.name]) do
  		  	  	local hash = GetHashKey(v.Object)
  		  	  	if DoesObjectOfTypeExistAtCoords(x, y, z, 0.9, hash, 0) then
					local object = GetClosestObjectOfType(x, y, z, 0.9, hash, false, false, false)
					TriggerServerEvent("esx_spawnObject:handleObject", ObjToNet(object))
					if hash == `p_ld_stinger_s` then
						TriggerServerEvent('ESX_spawnobject:ESXIG', ObjToNet(object))
					end
  		  	  	  	NetworkRequestControlOfEntity(object)

    				while not NetworkHasControlOfEntity(object) do
    				    Wait(100)
    				end

    				SetEntityAsMissionEntity(object, true, true)

    				while not IsEntityAMissionEntity(object) do
    					Wait(100)
					end

					ESX.Game.DeleteObject(object)
  		  	  	end
  		  	end
		end

  		trafficmenu:AddItem(objectlist)
  		objectlist.OnListSelected = function(sender, item, index)
			if GetGameTimer() - CoolDown < 3000 then return ESX.Alert("Spam Nakonid", "error") end
  		  	local Player = PlayerPedId()
			local heading = GetEntityHeading(Player)
			local forward = GetEntityForwardVector(Player)
			local playerForwardCoord = GetEntityCoords(Player) + forward * 0.5
  		  	local x, y, z = table.unpack(playerForwardCoord)
  		  	local object = item:IndexToItem(index)
  		  	for k,v in pairs(Config[PlayerData.job.name]) do
  		  	    if v.Displayname == object then
					local objectname = v.Object
					ESX.Game.SpawnObject(objectname, vector3(x, y, z-1), function(obj)
						SetEntityHeading(obj, heading)
						FreezeEntityPosition(obj, true)
						Wait(10)
						PlaceObjectOnGroundProperly(obj)
						CoolDown = GetGameTimer()
						if GetHashKey(objectname) == `p_ld_stinger_s` then
							TriggerServerEvent('esx_spawnObject:setSpike', ObjToNet(obj))
						end
					end)
  		  	    end
  		  	end
		end
	end
end

RegisterNetEvent('esx_spawnObject:setSpike')
AddEventHandler('esx_spawnObject:setSpike', function(coord, id)
	Spikes[id] = RegisterPoint(coord, 2, true)
	Spikes[id].set('InAreaOnce', function ()
		if IsPedInAnyVehicle(LocalPed(), false) then
            local vehicle = GetVehiclePedIsIn(LocalPed(), false)
            if GetPedInVehicleSeat(vehicle, -1) == LocalPed() then
				NSpike()
            end
        end
	end)
end)

RegisterNetEvent('ESX_spawnobject:ESXIG')
AddEventHandler('ESX_spawnobject:ESXIG', function (id)
	if Spikes[id] then
		Spikes[id] = Spikes[id].remove()
	end
end)

function CM()
	_menuPool:ProcessMenus()

	if IsPedInAnyVehicle(PlayerPedId(), false) then
		trafficmenu:Visible(false)
	end

	if trafficmenu:Visible() then
		SetTimeout(0, CM)
	end
end

AddEventHandler("onMultiplePress", function(keys)
	if keys["lshift"] and keys["left"] and ESX.GetPlayerData()['IsDead'] ~= 1 then
		if PlayerData and PlayerData.job and (PlayerData.job.grade > 0) and Config[PlayerData.job.name] and not IsPedInAnyVehicle(PlayerPedId(), false) then
			trafficmenu:Visible(not trafficmenu:Visible())
			CM()
		end
	end
end)

function NSpike()
	local tires = {
		{bone = "wheel_lf", index = 0},
		{bone = "wheel_rf", index = 1},
		{bone = "wheel_lm", index = 2},
		{bone = "wheel_rm", index = 3},
		{bone = "wheel_lr", index = 4},
		{bone = "wheel_rr", index = 5}
	}

	for a = 1, #tires do
		local vehicle = GetVehiclePedIsIn(LocalPed(), false)
		local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[a].bone))
		local spike = GetClosestObjectOfType(tirePos.x, tirePos.y, tirePos.z, 1.0, GetHashKey('p_ld_stinger_s'), false, false, false)
		local spikePos = GetEntityCoords(spike, false)
		local distance = GetDistanceBetweenCoords(tirePos.x, tirePos.y, tirePos.z, spikePos.x, spikePos.y, spikePos.z, false)

		if distance < 1.8 then
			if not IsVehicleTyreBurst(vehicle, tires[a].index, true) or IsVehicleTyreBurst(vehicle, tires[a].index, false) then
				SetVehicleTyreBurst(vehicle, tires[a].index, false, 1000.0)
			end
		end
	end
end

_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)