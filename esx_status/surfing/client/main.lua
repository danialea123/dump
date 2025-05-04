---@diagnostic disable: param-type-mismatch, missing-parameter, missing-parameter
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                             = nil
local PlayerData                = {}
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
	while not ESX.GetPlayerData().job do
		Citizen.Wait(1000)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

function OpenVehicleMenu() -- Menu location véhicules
	local elements = {}
	if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" then
		elements = {
			{label = 'Police Boat', value = 'predator', price = 500},
		}
	else
		elements = {
			{label = 'Jet Ski', value = 'seashark', price = 500},
			{label = 'Surf Board', value = 'surfboard', price = 500}
		}
	end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_menu',
        {
            title = 'Tafarojgah Saheli',
			align    = 'center',
            elements = elements
        },
        function(data, menu)
            --for i=1, #elements, 1 do
				local coords      = GetEntityCoords(PlayerPedId())
				local isInMarker  = false
				for k,v in pairs(Config.Zones) do
					if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
						isInMarker  = true
					end
				end
				if not isInMarker then
					menu.close()
					return
				end
                local playerPed = GetPlayerPed(-1)
                local platenum = math.random(00001, 99998)
				--local coords    = Config.Zones.LocationVehicleEntering.Pos, Config.Zones.LocationVehicleEntering2.Pos, Config.Zones.LocationVehicleEntering3.Pos
				local price     = data.current.price
                ESX.Game.SpawnVehicle(data.current.value, GetEntityCoords(PlayerPedId()), 200.0, function(vehicle)
                    TaskWarpPedIntoVehicle(playerPed, vehicle, -1) -- Téléportation du joueur dans le véhicule
                    --SetVehicleNumberPlateText(vehicle, 'LOCATION' .. platenum) -- Modification de la plaque d'immatriculation en LOCATION
					ESX.CreateVehicleKey(vehicle)
					exports.LegacyFuel:SetFuel(vehicle, 100.0)
					if data.current.value == "surfboard" then
						Citizen.CreateThread(function()
							while DoesEntityExist(vehicle) do
								Citizen.Wait(5)
								ForceVehicleEngineAudio(vehicle, 0)
							end
						end)
					end
                end)
                --TriggerServerEvent('esx_location:Buy', price) -- Event permetant de faire payer le joueur
                --break
            --end
            	menu.close()
    end,
    function(data, menu)
        menu.close()
        CurrentAction     = 'locationVehicle_menu'
        CurrentActionMsg  = '~INPUT_CONTEXT~ Alugar Prancha'
        CurrentActionData = {}
    end
    )
end

AddEventHandler('esx_location:hasExitedMarker', function(zone)
    CurrentAction = nil
end)

AddEventHandler('esx_location:hasEnteredMarker', function(zone)

    if zone == 'LocationVehicleEntering3' then
        CurrentAction     = 'locationVehicle_menu'
        CurrentActionMsg  = '~INPUT_CONTEXT~ Alugar Pracha'
        CurrentActionData = {}
	end

	if zone == 'LocationVehicleEntering2' then
        CurrentAction     = 'locationVehicle_menu'
        CurrentActionMsg  = '~INPUT_CONTEXT~ Alugar Pracha'
        CurrentActionData = {}
	end

	if zone == 'LocationVehicleEntering' then
        CurrentAction     = 'locationVehicle_menu'
        CurrentActionMsg  = '~INPUT_CONTEXT~ Alugar Pracha'
        CurrentActionData = {}
	end

	if zone == 'LocationVehicleEntering4' then
        CurrentAction     = 'locationVehicle_menu'
        CurrentActionMsg  = '~INPUT_CONTEXT~ Alugar Pracha'
        CurrentActionData = {}
	end

	if zone == 'LocationVehicleEntering5' then
        CurrentAction     = 'locationVehicle_menu'
        CurrentActionMsg  = '~INPUT_CONTEXT~ Alugar Pracha'
        CurrentActionData = {}
	end

	if zone == 'LocationVehicleEntering6' then
        CurrentAction     = 'locationVehicle_menu'
        CurrentActionMsg  = '~INPUT_CONTEXT~ Alugar Pracha'
        CurrentActionData = {}
	end

	if zone == 'LocationVehicleEntering7' then
        CurrentAction     = 'locationVehicle_menu'
        CurrentActionMsg  = '~INPUT_CONTEXT~ Alugar Pracha'
        CurrentActionData = {}
	end

end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3)
		local coords = GetEntityCoords(PlayerPedId())
		local Break = true
		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				Break = false
				DrawMarker(35, v.Pos.x, v.Pos.y, v.Pos.z+1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x+0.5, v.Size.y, v.Size.z+1.0, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				DrawMarker(25, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x+0.5, v.Size.y, v.Size.z+1.0, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
		if Break then Citizen.Wait(750) end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil
		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end
		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_location:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_location:hasExitedMarker', LastZone)
		end
		if not isInMarker then
			TriggerEvent("esx_location:hasExitedMarker")
		end
	end
end)

-- Key controls
AddEventHandler("onKeyDown", function(key)
	if key == "e" then
		if CurrentAction ~= nil then
            if (GetGameTimer() - GUI.Time) > 300 then
                if CurrentAction == 'locationVehicle_menu' then
					if IsPedInAnyVehicle(PlayerPedId()) then
						ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
					end
                    OpenVehicleMenu()
				end
				CurrentAction = nil
				GUI.Time      = GetGameTimer()
            end
		end
    end  
end)

-- Blips
Citizen.CreateThread(function()	

    local blip = AddBlipForCoord(Config.Zones.LocationVehicleEntering.Pos.x, Config.Zones.LocationVehicleEntering.Pos.y, Config.Zones.LocationVehicleEntering.Pos.z)
    
	SetBlipSprite (blip, 409)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.6)
	SetBlipColour (blip, 0)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Surfing Area")
    EndTextCommandSetBlipName(blip)
	
    local blip = AddBlipForCoord(Config.Zones.LocationVehicleEntering2.Pos.x, Config.Zones.LocationVehicleEntering2.Pos.y, Config.Zones.LocationVehicleEntering2.Pos.z)
    
	SetBlipSprite (blip, 409)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.6)
	SetBlipColour (blip, 0)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Surfing Area")
    EndTextCommandSetBlipName(blip)
	
	local blip = AddBlipForCoord(Config.Zones.LocationVehicleEntering3.Pos.x, Config.Zones.LocationVehicleEntering3.Pos.y, Config.Zones.LocationVehicleEntering3.Pos.z)
    
	SetBlipSprite (blip, 409)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.6)
	SetBlipColour (blip, 0)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Surfing Area")
    EndTextCommandSetBlipName(blip)

	local blip = AddBlipForCoord(Config.Zones.LocationVehicleEntering4.Pos.x, Config.Zones.LocationVehicleEntering4.Pos.y, Config.Zones.LocationVehicleEntering4.Pos.z)
    
	SetBlipSprite (blip, 409)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.6)
	SetBlipColour (blip, 0)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Surfing Area")
    EndTextCommandSetBlipName(blip)

	local blip = AddBlipForCoord(Config.Zones.LocationVehicleEntering5.Pos.x, Config.Zones.LocationVehicleEntering5.Pos.y, Config.Zones.LocationVehicleEntering5.Pos.z)
    
	SetBlipSprite (blip, 409)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.6)
	SetBlipColour (blip, 0)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Surfing Area")
    EndTextCommandSetBlipName(blip)

	local blip = AddBlipForCoord(Config.Zones.LocationVehicleEntering6.Pos.x, Config.Zones.LocationVehicleEntering6.Pos.y, Config.Zones.LocationVehicleEntering6.Pos.z)
    
	SetBlipSprite (blip, 409)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.6)
	SetBlipColour (blip, 0)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Surfing Area")
    EndTextCommandSetBlipName(blip)
 
end)