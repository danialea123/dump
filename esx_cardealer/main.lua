---@diagnostic disable: missing-parameter
Config = Config or {}

Config.Eject = true -- If set to true, player will be ejected if they land while doing a trick

Config.SpecificVehicle = true -- If set to true, you will be able to do tricks only on some specific bikes from the 'Config.Vehicles' list
Config.Vehicles = { -- Don't use "Model Name" since there is no native to get model name from vehicle in GTA, only use "Text Label Name(s)". You can found them here: https://gta.fandom.com/wiki/Category:Motorcycles_Vehicle_Class
    "ENDURO",
    "ESSKEY",
    "MANCHEZ",
    "SANCHEZ01",
    "SANCHEZ02",
    "BF400",
}

Config.SimpleKey = 76 -- Set the key used for the simple tricks (76 is 'INPUT_VEH_HANDBRAKE' aka SPACEBAR per default)
Config.OtherKey = 73 -- Set the key used for other tricks (73 is 'INPUT_VEH_DUCK' aka X per default)
-- You can find those value here: https://docs.fivem.net/docs/game-references/controls/
local isInAnim, dictLoaded, inKeyAnim, StuntOn, key = false, false, false, nil, nil

local dict, key1, key2 = 'rcmextreme2atv', Config.SimpleKey, Config.OtherKey

RegisterKeyMapping('stunt1', 'Stunt 1', 'MOUSE_BUTTON', 'MOUSE_LEFT')
RegisterKeyMapping('stunt2', 'Stunt 2', 'MOUSE_BUTTON', 'MOUSE_RIGHT')
RegisterKeyMapping('stunt3', 'Stunt 3', 'MOUSE_BUTTON', 'MOUSE_EXTRABTN1')
RegisterKeyMapping('stunt4', 'Stunt 4', 'MOUSE_BUTTON', 'MOUSE_EXTRABTN2')

function Stunt(Anim, Start, Mid1, Mid2, Loop, StuntBool)
	isInAnim = true
	Player = PlayerPedId()
	Veh = GetVehiclePedIsIn(Player, false)
	Model = GetEntityModel(Veh)

	StuntOn = StuntBool

	if not dictLoaded then
		LoadDict()
	end

	if IsEntityInAir(Veh) then
		if Config.SpecificVehicle then
			if SpecificVehicle(Config.Vehicles, GetDisplayNameFromVehicleModel(Model)) then
				while IsControlPressed(0, key) do
					if not IsEntityPlayingAnim(Player, dict, Anim, 3) then
						TaskPlayAnimAdvanced(Player, dict, Anim, 0, 0, 0, 0, 0, 0, 8.0, 8.0, -1, 0, Start, false, false)
					elseif inKeyAnim then
						inKeyAnim = false
						StuntOn = nil
						return
					elseif GetEntityAnimCurrentTime(Player, dict, Anim) >= Mid1 and GetEntityAnimCurrentTime(Player, dict, Anim) < Mid2 and IsEntityInAir(Veh) then
						TaskPlayAnimAdvanced(Player, dict, Anim, 0, 0, 0, 0, 0, 0, 8.0, 8.0, -1, 0, Loop, false, false)
					elseif not IsEntityInAir(Veh) then
						if Config.Eject then
							Eject()
						else
							ClearPedTasks(Player)
						end
						StuntOn = nil
						return
					end
					Citizen.Wait(50)
				end
				StuntOn = nil
			end
		elseif IsThisModelABike(Model) then
			while IsControlPressed(0, key) do
				if not IsEntityPlayingAnim(Player, dict, Anim, 3) then
					TaskPlayAnimAdvanced(Player, dict, Anim, 0, 0, 0, 0, 0, 0, 8.0, 8.0, -1, 0, Start, false, false)
				elseif inKeyAnim then
					inKeyAnim = false
					StuntOn = nil
					return
				elseif GetEntityAnimCurrentTime(Player, dict, Anim) >= Mid1 and GetEntityAnimCurrentTime(Player, dict, Anim) < Mid2 and IsEntityInAir(Veh) then
					TaskPlayAnimAdvanced(Player, dict, Anim, 0, 0, 0, 0, 0, 0, 8.0, 8.0, -1, 0, Loop, false, false)
				elseif not IsEntityInAir(Veh) then
					if Config.Eject then
						Eject()
					else
						ClearPedTasks(Player)
					end
					StuntOn = nil
					return
				end
				Citizen.Wait(50)
			end
			StuntOn = nil
		end
	end
end

RegisterCommand('stunt1', function()
	if SpecificVehicle(Config.Vehicles, GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))) then
		if IsControlPressed(0, key2) then
			return
		elseif IsControlPressed(0, key1) then
			key = key1
			inKeyAnim = true
			Wait(50)
		end
		inKeyAnim = false

		if StuntOn == true or StuntOn == nil then
			Stunt('idle_b', 0.28, 0.5, 0.54, 0.50, true)
			IfInAnim()
		end
	end

end)

RegisterCommand('stunt2', function()

	if SpecificVehicle(Config.Vehicles, GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))) then
		if IsControlPressed(0, key2) then
			return
		elseif IsControlPressed(0, key1) then
			key = key1
			inKeyAnim = true
			Wait(50)
		end
		inKeyAnim = false

		if StuntOn == false or StuntOn == nil then
			Stunt('idle_c', 0.15, 0.44, 0.52, 0.46, false)
			IfInAnim()
		end
	end

end)

RegisterCommand('stunt3', function()

	if SpecificVehicle(Config.Vehicles, GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))) then
		if IsControlPressed(0, key2) then
			key = key2
			inKeyAnim = true
			Wait(50)
		elseif IsControlPressed(0, key1) then
			return
		end
		inKeyAnim = false

		if StuntOn == true or StuntOn == nil then
			Stunt('idle_d', 0.18, 0.69, 0.71, 0.20, true)
			IfInAnim()
		end
	end

end)

RegisterCommand('stunt4', function()

	if SpecificVehicle(Config.Vehicles, GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))) then
		if IsControlPressed(0, key2) then
			key = key2
			inKeyAnim = true
			Wait(50)
		elseif IsControlPressed(0, key1) then
			return
		end
		inKeyAnim = false
	
		if StuntOn == false or StuntOn == nil then
			Stunt('idle_e', 0.15, 0.35, 0.37, 0.35, false)
			IfInAnim()
		end
	end
	

end)

function Eject()
	Veh = GetVehiclePedIsIn(Player, false)
	Vehv = GetEntityVelocity(Veh)
	ESX.SetEntityCoords(Player, GetEntityCoords(Veh, 0.0, 0.0, -0.7))
    SetPedToRagdoll(Player, 2800, 2800, 0, 0, 0, 0)
    SetEntityVelocity(Player, Vehv.x * 1.5, Vehv.y * 1.5, Vehv.z)
end

function IfInAnim()
	if isInAnim then
		InAnim = false
		ClearPedTasks(PlayerPedId())
	end
end

function LoadDict()
	while not HasAnimDictLoaded(dict) do
		Wait(20)
		RequestAnimDict(dict)
	end
	dictLoaded = true
end

function SpecificVehicle(table, val)
	if Config.SpecificVehicle == true then
		for i=1,#table do
			if table[i] == val then
				return true
			end
		end
		return false
	end
	return true
end
