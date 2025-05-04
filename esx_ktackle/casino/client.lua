---@diagnostic disable: undefined-global, missing-parameter, undefined-field, param-type-mismatch
local inCasino = false
local spinningObject = nil
local spinningCar = nil
local carOnShow = GetHashKey('jester')

function IsTable(T)
	return type(T) == 'table'
end

function SetIplPropState(interiorId, props, state, refresh)
	if refresh == nil then refresh = false end
	if IsTable(interiorId) then
		for key, value in pairs(interiorId) do
			SetIplPropState(value, props, state, refresh)
		end
	else
		if IsTable(props) then
			for key, value in pairs(props) do
				SetIplPropState(interiorId, value, state, refresh)
			end
		else
			if state then
				if not IsInteriorPropEnabled(interiorId, props) then EnableInteriorProp(interiorId, props) end
			else
				if IsInteriorPropEnabled(interiorId, props) then DisableInteriorProp(interiorId, props) end
			end
		end
		if refresh == true then RefreshInterior(interiorId) end
	end
end
  
Citizen.CreateThread(function()
	Wait(0)
	RequestIpl('vw_casino_main')
	RequestIpl('vw_dlc_casino_door')
	RequestIpl('hei_dlc_casino_door')
	RequestIpl("hei_dlc_windows_casino")
	RequestIpl("vw_casino_penthouse")
	SetIplPropState(274689, "Set_Pent_Tint_Shell", true, true)
	SetInteriorEntitySetColor(274689, "Set_Pent_Tint_Shell", 3)
	RequestIpl("hei_dlc_windows_casino_lod")
	RequestIpl("vw_casino_carpark")
	RequestIpl("vw_casino_garage")
	RequestIpl("hei_dlc_casino_aircon")
	RequestIpl("hei_dlc_casino_aircon_lod")
	RequestIpl("hei_dlc_casino_door")
	RequestIpl("hei_dlc_casino_door_lod")
	RequestIpl("hei_dlc_vw_roofdoors_locked")
	RequestIpl("vw_ch3_additions")
	RequestIpl("vw_ch3_additions_long_0")
	RequestIpl("vw_ch3_additions_strm_0")
	RequestIpl("vw_dlc_casino_door")
	RequestIpl("vw_dlc_casino_door_lod")
	RequestIpl("vw_casino_billboard")
	RequestIpl("vw_casino_billboard_lod(1)")
	RequestIpl("vw_casino_billboard_lod")
	RequestIpl("vw_int_placement_vw")
	RequestIpl("vw_dlc_casino_apart")
	
	local interiorID = GetInteriorAtCoords(1100.000, 220.000, -50.000)
	
	if IsValidInterior(interiorID) then
		RefreshInterior(interiorID)
	end
end)


--TELEPORT
key_to_teleport = 38

positions = {

	-- cassino main door
    {
		{935.8365, 46.94, 80.09, 0}, -- enter
		{1090.00, 207.00, -50.0, 358}, -- leave
		{205,89,0}, -- colour
	}, 
}

local player = PlayerPedId()

Citizen.CreateThread(function ()
    local blipCoord = AddBlipForCoord(923.72, 47.12, 81.11)

    SetBlipSprite (blipCoord, 617)
    SetBlipDisplay(blipCoord, 4)
    SetBlipScale  (blipCoord, 0.6)
    SetBlipColour (blipCoord, 27)
    SetBlipAsShortRange(blipCoord, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Casino')
    EndTextCommandSetBlipName(blipCoord)

    while true do
        Citizen.Wait(1)
        local player = PlayerPedId()
        local playerLoc = GetEntityCoords(player)
		Sleep = true
        for _,location in ipairs(positions) do
            teleport_text = location[4]
            loc1 = {
                x=location[1][1],
                y=location[1][2],
                z=location[1][3],
                heading=location[1][4]
            }
            loc2 = {
                x=location[2][1],
                y=location[2][2],
                z=location[2][3],
                heading=location[2][4]
            }
            Red = location[3][1]
            Green = location[3][2]
            Blue = location[3][3]

			if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 2) then
				Sleep = false
				drawNativeNotification('Press ~INPUT_PICKUP~ To Enter')
				DrawMarker(1, loc1.x, loc1.y, loc1.z+0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, Red, Green, Blue, 100, false, true, 2, false, false, false, false)
                if IsControlJustReleased(1, key_to_teleport) then
					DoScreenFadeOut(500)
    				Wait(500)
                    SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                    SetEntityHeading(player, loc2.heading)
					DoScreenFadeIn(500)
					enterCasino(false)
		            Citizen.Wait(1)
			        enterCasino(true)
					scanned = true
					scanwait = 200
                end
			elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 2) then
				Sleep = false
				drawNativeNotification('Press ~INPUT_PICKUP~ To Exit')
				DrawMarker(1, loc2.x, loc2.y, loc2.z+0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, Red, Green, Blue, 100, false, true, 2, false, false, false, false)
                if IsControlJustReleased(1, key_to_teleport) then
					DoScreenFadeOut(500)
    				Wait(500)
                    SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                    SetEntityHeading(player, loc1.heading)
					DoScreenFadeIn(500)
					enterCasino(false)
		            Citizen.Wait(1)
			        enterCasino(false)
					scanned = false
					scanwait = 200
                end
            end            
        end
		if Sleep then Citizen.Wait(750) end
    end
end)

function drawNativeNotification(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function CheckPos(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1^2

    local t2 = y-cy
    local t21 = t2^2

    local t3 = z - cz
    local t31 = t3^2

    return (t12 + t21 + t31) <= radius^2
end

--END TELEPORT

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- CAR FOR WINS
function drawCarForWins()
	if DoesEntityExist(spinningCar) then
	  DeleteEntity(spinningCar)
	end
	RequestModel(carOnShow)
	while not HasModelLoaded(carOnShow) do
		Citizen.Wait(0)
	end
	SetModelAsNoLongerNeeded(carOnShow)
	spinningCar = CreateVehicle(carOnShow, 1100.0, 220.0, -51.0 + 0.05, 0.0, 0, 0)
	Wait(0)
	SetVehicleDirtLevel(spinningCar, 0.0)
	SetVehicleOnGroundProperly(spinningCar)
	Wait(0)
	FreezeEntityPosition(spinningCar, 1)
end

-- END CAR FOR WINS

function enterCasino(pIsInCasino, pFromElevator, pCoords, pHeading)
	if pIsInCasino == inCasino then return end
	inCasino = pIsInCasino
	if DoesEntityExist(spinningCar) then
	  DeleteEntity(spinningCar)
	end
	Wait(500)
	spinMeRightRoundBaby()
	showDiamondsOnScreenBaby()
	playSomeBackgroundAudioBaby()
end
  
function spinMeRightRoundBaby()
	Citizen.CreateThread(function()
	    while inCasino do
		if not spinningObject or spinningObject == 0 or not DoesEntityExist(spinningObject) then
		  spinningObject = GetClosestObjectOfType(1100.0, 220.0, -51.0, 10.0, -1561087446, 0, 0, 0)
		  drawCarForWins()
		end
		if spinningObject ~= nil and spinningObject ~= 0 then
		  local curHeading = GetEntityHeading(spinningObject)
		  local curHeadingCar = GetEntityHeading(spinningCar)
		  if curHeading >= 360 then
			curHeading = 0.0
			curHeadingCar = 0.0
		  elseif curHeading ~= curHeadingCar then
			curHeadingCar = curHeading
		  end
		  SetEntityHeading(spinningObject, curHeading + 0.075)
		  SetEntityHeading(spinningCar, curHeadingCar + 0.075)
		end
		Wait(0)
	  end
	  spinningObject = nil
	end)
end
  
-- Casino Screens
local Playlists = {
	"CASINO_DIA_PL", -- diamonds
	"CASINO_SNWFLK_PL", -- snowflakes
	"CASINO_WIN_PL", -- win
	"CASINO_HLW_PL", -- skull
}
 
-- Render
function CreateNamedRenderTargetForModel(name, model)
	local handle = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end
  
	return handle
end

-- render tv 
function showDiamondsOnScreenBaby()
	Citizen.CreateThread(function()
	  local model = GetHashKey("vw_vwint01_video_overlay")
	  local timeout = 21085 -- 5000 / 255
  
	  local handle = CreateNamedRenderTargetForModel("CasinoScreen_01", model)
  
	  RegisterScriptWithAudio(0)
	  SetTvChannel(-1)
	  SetTvVolume(0)
	  SetScriptGfxDrawOrder(4)
	  SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
	  SetTvChannel(2)
	  EnableMovieSubtitles(1)
  
	function doAlpha()
		Citizen.SetTimeout(timeout, function()
		SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
		SetTvChannel(2)
		doAlpha()
		end)
	end
	doAlpha()
  
	Citizen.CreateThread(function()
	while inCasino do
	  SetTextRenderId(handle)
	  DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
	  SetTextRenderId(GetDefaultScriptRendertargetRenderId())
	  Citizen.Wait(0)
	end
	SetTvChannel(-1)
	ReleaseNamedRendertarget(GetHashKey("CasinoScreen_01"))
	SetTextRenderId(GetDefaultScriptRendertargetRenderId())
	end)
   end)
end
  
function playSomeBackgroundAudioBaby()
	Citizen.CreateThread(function()
	  local function audioBanks()
		while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL", false, -1) do
		  Citizen.Wait(0)
		end
		while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01", false, -1) do
		  Citizen.Wait(0)
		end
		while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_02", false, -1) do
		  Citizen.Wait(0)
		end
		while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_03", false, -1) do
		  Citizen.Wait(0)
		end
	  end
	  audioBanks()
	  while inCasino do
		if not IsStreamPlaying() and LoadStream("casino_walla", "DLC_VW_Casino_Interior_Sounds") then
		  PlayStreamFromPosition(1111, 230, -47)
		end
		if IsStreamPlaying() and not IsAudioSceneActive("DLC_VW_Casino_General") then
		  StartAudioScene("DLC_VW_Casino_General")
		end
		Citizen.Wait(1000)
	  end
	  if IsStreamPlaying() then
		StopStream()
	  end
	  if IsAudioSceneActive("DLC_VW_Casino_General") then
		StopAudioScene("DLC_VW_Casino_General")
	  end
	end)
end

local locations = {
    {
        coords = vector3(969.69,63.07,111.6),
        coords2 = vector4(967.2,63.99,111.6, 34.3),
        text = 'Press ~INPUT_PICKUP~ To Exit'
    },
    {
        coords = vector3(967.2,63.99,111.6),
        coords2 = vector4(969.69,63.07,111.6, 238.44),
        text = 'Press ~INPUT_PICKUP~ To Enter',
    },
	{
        coords = vector3(1085.86,214.88,-50.2),
        coords2 = vector4(964.07,59.05,111.6, 100.44),
        text = 'Press ~INPUT_PICKUP~ To Enter',
    },
	{
        coords = vector3(964.07,59.05,111.6),
        coords2 = vector4(1085.86,214.88,-50.2, 135.44),
        text = 'Press ~INPUT_PICKUP~ To Enter',
    },
}

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)

local Coords = nil
local NearCoords = nil
local Head = nil 

AddEventHandler("onKeyDown", function(key)
    if key == "e" then
		if NearCoords then
			ESX.TriggerServerCallback('esx:LockStatus', function(result)
				if result or PlayerData.gang.name == "Sicilian" then
					ESX.SetEntityCoords(PlayerPedId(), Coords)
					SetEntityHeading(PlayerPedId(), Head)
				else
					ESX.Alert('Dar Ghofl Ast', "error")
				end
			end)
		elseif PlayerData.gang.name == "Sicilian" then
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  vector3(980.17,56.89,116.16),  true) < 1.5 then
				ESX.TriggerServerCallback('esx:LockStatus', function(result)
					TriggerServerEvent("esx:LockStatus")
					if result then 
						ESX.Alert("Dar Ghofl Shod", "check")
					else
						ESX.Alert("Dar Baaz Shod", "check")
					end
				end)
			end
		end
    end
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(4)
		local Sleep = true
		for k, v in pairs(locations) do
			local distance = #(GetEntityCoords(PlayerPedId()) - v.coords)
			if distance < 2.0 then
				Sleep = false
				DrawMarker(27, v.coords, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 36, 237, 157, 200, 0, 0, 0, 0)
				NearCoords, Coords, Head = true, v.coords2, v.coords2.w
			end
		end
		if Sleep then Citizen.Wait(750) NearCoords = false end
    end
end)

local Pedaret = {
	vector3(980.17,56.89,116.16),
}

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(4)
		local Sleep = true
		for k, v in pairs(Pedaret) do
			local distance = #(GetEntityCoords(PlayerPedId()) - v)
			if distance <= 1.5 then
				Sleep = false
				DrawMarker(2, v, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 230, 237, 157, 200, 0, 0, 0, 0)
			end
		end
		if Sleep then Citizen.Wait(750) end
    end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(1000)
	end

	while not ESX.GetPlayerData().gang do
		Citizen.Wait(1000)
	end
	
	--[[if ESX.GetPlayerData().identifier == "steam:1100001580c2e48" or ESX.GetPlayerData().gang.name == "STAFF" then
		CustomThread()
	end
	if ESX.GetPlayerData().identifier == "steam:11000014ad595fb" or ESX.GetPlayerData().gang.name == "STAFF" then
		CustomThread2()
	end]]
	--[[if ESX.GetPlayerData().identifier == "steam:110000144741619" or ESX.GetPlayerData().gang.name == "STAFF" then
		CustomThread3()
	end]]
end)

local KireKhar = {
	["Inventory"] = vector3(971.43,69.33,116.16),
	["Locker"] = vector3(975.12,64.83,116.16),
	["Vehicle"] = vector3(918.49,51.7,80.9),
}

local KireKhar2 = {
	["Inventory"] = vector3(-1416.31,6755.45,3.05),
	["Locker"] = vector3(-1443.13,6757.99,5.88),
	["Vehicle"] = vector3(-584.31,6168.45,5.58),
}

local KireKhar3 = {
	["Inventory"] = vector3(5433.09,-5569.43,54.12),
	["Locker"] = vector3(5434.42,-5574.46,54.15),
	["Vehicle"] = vector3(5406.32,-5569.89,53.98),
}

local Markers = {
    ["Inventory"] = 42,
    ["Exit"] = 21,
    ["Locker"] = 31,
	["Vehicle"] = 36,
}

local Colors = {
    ["Inventory"] = {r =255 , g = 134, b = 93},
    ["Exit"] = {r =240 , g = 19, b = 40},
    ["Locker"] = {r = 255, g = 250, b = 210},
	["Vehicle"] = {r = 200, g = 50, b = 50},
}

function CustomThread2()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(3)
			local coord = GetEntityCoords(PlayerPedId())
			local Sleep = true
			for k, v in pairs(KireKhar2) do
				if GetDistanceBetweenCoords(coord, v, true) <= 6.0 then
					Sleep = false
                    DrawMarker(Markers[k], v, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Colors[k].r, Colors[k].g, Colors[k].b, 255, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(coord, v, true) <= 1.0 then
						if IsControlJustReleased(0, 38) then
							if k == "Inventory" then
								TriggerEvent("esx_inventoryhud:OpenHouseInventory")
							elseif k == "Locker" then
								OpenLocker()
							elseif k == "Vehicle" then
								if not IsPedInAnyVehicle(PlayerPedId()) then
									OpenVehicleMenu(v)
								else
									exports.esx_advancedgarage:StoreOwnedCarsMenu()
								end
							end
						end
					end
				end
			end
			if Sleep then Citizen.Wait(750) end
		end
	end)
end

function CustomThread3()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(3)
			local coord = GetEntityCoords(PlayerPedId())
			local Sleep = true
			for k, v in pairs(KireKhar3) do
				if GetDistanceBetweenCoords(coord, v, true) <= 6.0 then
					Sleep = false
                    DrawMarker(Markers[k], v, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Colors[k].r, Colors[k].g, Colors[k].b, 255, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(coord, v, true) <= 1.0 then
						if IsControlJustReleased(0, 38) then
							if k == "Inventory" then
								TriggerEvent("esx_inventoryhud:OpenHouseInventory")
							elseif k == "Locker" then
								OpenLocker()
							elseif k == "Vehicle" then
								if not IsPedInAnyVehicle(PlayerPedId()) then
									OpenVehicleMenu(v)
								else
									exports.esx_advancedgarage:StoreOwnedCarsMenu()
								end
							end
						end
					end
				end
			end
			if Sleep then Citizen.Wait(750) end
		end
	end)
end

function OpenVehicleMenu(v)
	local elements = {}

	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedCars', function(ownedCars)
		if #ownedCars == 0 then
			ESX.Alert('Shoma hich mashini dar in garage nadarid')
		else
			for _,v in pairs(ownedCars) do
				local hashVehicule = v.vehicle.model
				local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule)
				if vehicleName == "Unknown" then
					vehicleName = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(hashVehicule))
				end
				local plate        = v.plate
				local labelvehicle
				if IsModelValid(hashVehicule) then
					if v.stored then
						labelvehicle = '| '..plate..' | '..vehicleName..' |'
					elseif v.imp then
						labelvehicle = '| '..plate..' | '..vehicleName..' |'..' <span style="color:red; border-bottom: 1px solid red;">Police Impound</span>'
					else
						labelvehicle = '| '..plate..' | '..vehicleName..' |'
					end
					table.insert(elements, {label = labelvehicle, value = v})
				end
			end
			
            camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
					
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car', {
				title    = "Vehicle Garage",
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				if not data.current.value.imp then
					if data.current.value.stored then
						--[[if not DoesEntityExist(localVeh) then return end
						DeleteVehicle(localVeh)
						localVeh = nil
						ClearFocus()
						RenderScriptCams(false, false, 0, true, false)
						DestroyCam(camera, false)]]
						menu.close()
						Wait(math.random(0, 500))
						--[[TriggerEvent('mythic_progbar:client:progress', {
							name = 'cast',
							duration = math.random(13000, 15000),
							label = 'Spawning Car...',
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							}
						}, function(status)
							if not status then]]
								local foundSpawn, spawnPoint = true, {coords = vector3(v.x, v.y, v.z), heading = 133.0}
								if foundSpawn then
									--ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle, damages)
										local vehicle = data.current.value.vehicle
										local damages = data.current.value.damages
										ESX.Game.SpawnVehicle(vehicle.model, spawnPoint.coords, spawnPoint.heading, function(callback_vehicle)
											vehicle.plate = data.current.value.plate
											ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
											SetVehRadioStation(callback_vehicle, "OFF")
											SetVehicleDoorShut(callback_vehicle, 0, false)
											SetVehicleDoorShut(callback_vehicle, 1, false)
											SetVehicleDoorShut(callback_vehicle, 2, false)
											SetVehicleDoorShut(callback_vehicle, 3, false)
											SetVehicleDoorShut(callback_vehicle, 4, false)
											SetVehicleDoorShut(callback_vehicle, 5, false)
											--SetVehicleDoorsLockedForAllPlayers(callback_vehicle, true)
											exports.esx_advancedgarage:setDamages(callback_vehicle, damages)
											ESX.CreateVehicleKey(callback_vehicle)
											TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
										end)
										TriggerServerEvent('esx_advancedgarage:setVehicleState', data.current.value.plate, false)
									--end, data.current.value.plate)
								else
									ESX.Alert("Mahal Spawn Mashin Ra Khali Konid", "error")
								end
							--end
						--end)
					else
						ESX.Alert("Mashin Impound Ast", "error")
					end
				else
					ESX.Alert("Mashin Shoma Dar Impound Police Ast, Be Edare Police Morajee Konid", "info")
				end
			end, function(data, menu)
				menu.close()
			end, function(data, menu)

			end, function()

			end)
		end
	end)
end

function CustomThread()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(3)
			local coord = GetEntityCoords(PlayerPedId())
			local Sleep = true
			for k, v in pairs(KireKhar) do
				if GetDistanceBetweenCoords(coord, v, true) <= 6.0 then
					Sleep = false
                    DrawMarker(Markers[k], v, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Colors[k].r, Colors[k].g, Colors[k].b, 255, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(coord, v, true) <= 1.0 then
						if IsControlJustReleased(0, 38) then
							if k == "Inventory" then
								TriggerEvent("esx_inventoryhud:OpenHouseInventory")
							elseif k == "Locker" then
								OpenLocker()
							elseif k == "Vehicle" then
								if not IsPedInAnyVehicle(PlayerPedId()) then
									OpenVehicleMenu(v)
								else
									exports.esx_advancedgarage:StoreOwnedCarsMenu()
								end
							end
						end
					end
				end
			end
			if Sleep then Citizen.Wait(750) end
		end
	end)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(3)
			local coord = GetEntityCoords(PlayerPedId())
			--local Sleep = true
			--for k, v in pairs(KireKhar) do
			local v = vector3(946.03,14.0,116.16)
				if GetDistanceBetweenCoords(coord, v, true) <= 6.0 then
					--Sleep = false
                    DrawMarker(21, v, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 100, 150, 200, 255, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(coord, v, true) <= 1.0 then
						if IsControlJustReleased(0, 38) then
							OpenBuyMenu()
						end
					end
				else
					Citizen.Wait(750)
				end
			--end
			--if Sleep then Citizen.Wait(750) end
		end
	end)
end

function OpenLocker()
	TriggerEvent("codem-apperance:OpenWardrobe")
end

local PedCoord = {
	["u_f_m_casinocash_01"] = vector4(1088.1,221.4,-50.2,178.39),
	["s_m_m_highsec_01"] = vector4(1084.67,215.87,-50.2,258.71),
}

local StreetCoord = {
	["s_m_m_highsec_01"] = vector4(191.43,-3168.56,5.79,89.85),
	["s_m_m_highsec_02"] = vector4(208.1,-3166.92,5.81,87.25),
	["s_m_y_devinsec_01"] = vector4(241.44,-3179.7,-0.19,269.07),
	["ig_thornton"] = vector4(241.43,-3174.02,-0.19,267.37),
	["ig_vincent"] = vector4(261.72,-3169.27,3.24,93.75),
	["u_m_m_jewelsec_01"] = vector4(254.94,-3165.08,3.32,0.61),
}

Citizen.CreateThread(function()
	for k, v in pairs(PedCoord) do
		RequestModel(GetHashKey(k))
		while not HasModelLoaded(GetHashKey(k)) do
			Citizen.Wait(100)
		end
		local ped = CreatePed(26, GetHashKey(k), v.x, v.y, v.z, v.w, false, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		FreezeEntityPosition(ped, true)
	end
end)

Citizen.CreateThread(function()
	for k, v in pairs(StreetCoord) do
		RequestModel(GetHashKey(k))
		while not HasModelLoaded(GetHashKey(k)) do
			Citizen.Wait(100)
		end
		local ped = CreatePed(26, GetHashKey(k), v.x, v.y, v.z-0.9, v.w, false, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		FreezeEntityPosition(ped, true)
	end
end)

function OpenBuyMenu()
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Coffee", value = "coffee"},
        {label = "Hot Choclate", value = "hotchoc"},
        {label = "Cappuccino", value = "cappuccino"},
        {label = "Espresso", value = "espresso"},
        {label = "MilkShake", value = "milkshake"},
        {label = "Mohito", value = "mohito"},
        {label = "Ice Tea", value = "icetea"},
        {label = "Bubble Tea", value = "bubbletea"},
		{label = "Whiskey", value = "whiskey"},
		{label = "Vodka", value = "vodka"},
		{label = "Bastani", value = "bastani"},
        {label = "Waffle", value = "waffle"},
		{label = "Ab Porteghal", value = "abporteghal"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
		title    = 'Starbucks',
		align    = 'center',
		elements = elem
	}, function(data, menu)
        if data.current.value == "donut" or data.current.value == "cupcake" or data.current.value == "crossan" or data.current.value == "cakechoc" then return TriggerServerEvent("esx_casino:AddItem", data.current.value) end
        SetEntityCoords(PlayerPedId(), 946.03,14.0,116.16)
        SetEntityHeading(PlayerPedId(), 54.36)
        ExecuteCommand("e mechanic4")
        exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
        TriggerEvent("mythic_progbar:client:progress",{
            name = "unloc",
            duration = 7000,
            label =  data.current.label,
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
        }, function(status)
            if not status then
                exports.essentialmode:DisableControl(false)
                TriggerEvent("dpemote:enable", true)
                TriggerEvent("dpclothingAbuse", false)
                TriggerServerEvent("esx_casino:AddItem", data.current.value)
                ClearPedTasks(PlayerPedId())
            end
        end)
        --TriggerEvent("InteractSound_CL:PlayOnOne", "starbucks", 0.3)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

--[[RegisterCommand("pedmenu", function()
	local coord = GetEntityCoords(PlayerPedId())
	local ver = vector3(937.73,31.96,112.55)
	if #(coord - ver) >= 100.0 then return end
	if ESX.GetPlayerData().identifier == "steam:1100001580c2e48" or ESX.GetPlayerData().gang.name == "STAFF" then
		OpenPedMenu()
	end
end)]]

function OpenPedMenu()
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Wick", value = "wick"},
        {label = "mp_m_g_vagfun_01", value = "mp_m_g_vagfun_01"},
        {label = "a_m_m_hasjew_01", value = "a_m_m_hasjew_01"},
		{label = "Reset Ped", value = "mp_m_freemode_01"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbu_order', {
		title    = 'Ped Menu',
		align    = 'center',
		elements = elem
	}, function(data, menu)
		local model = GetHashKey(data.current.value)
		RequestModel(model)
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(0)
		end
		exports.esx_manager:setException(true)
		SetPlayerModel(PlayerId(), model)
		SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
		exports.esx_manager:ModelUpdated()
		Citizen.Wait(2000)
		TriggerEvent('esx:restoreLoadout')
		if data.current.value == "mp_m_freemode_01" then
			exports.esx_manager:ModelUpdated()
			exports.esx_manager:setException(false)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin == nil then
					TriggerEvent('skinchanger:loadSkin', {sex = 0})
				else
					TriggerEvent('skinchanger:loadSkin', skin)
				end
			end)
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

--[[RegisterCommand("petmenu", function()
	local coord = GetEntityCoords(PlayerPedId())
	local ver = vector3(937.73,31.96,112.55)
	if #(coord - ver) >= 100.0 then return end
	if ESX.GetPlayerData().identifier == "steam:1100001580c2e48" or ESX.GetPlayerData().gang.name == "STAFF" then
		ESX.TriggerServerCallback("diamond_housing:DoesHaveApartment", function(y, p, s, z, h)
			if #z > 0 then
				exports.diamond_housing:OpenPetsMenu(z, h)
				ESX.UI.Menu.CloseAll()
			else
				ESX.Alert("Shoma Hich Heyvan Khanegi Nadarid", "error")
			end
		end, 1)
	end
end)]]

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	TriggerServerEvent('sr_clubjob:checkDancers')
	TriggerServerEvent('sr_clubjob:checkvDancers')
end)

Config.StripDancerPeds = {
    { model="u_f_y_danceburl_01", x=912.24, y=46.46, z=111.66, a=1.08, animation="mini@strip_club@private_dance@part2", animationName="priv_dance_p2"},
    { model="mp_f_stripperlite", x=913.72, y=56.27, z=111.66, a=146.12, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
    --{ model="csb_stripper_01", x=102.26, y=-1289.92, z=29.26, a=292.05, animation="mini@strip_club@private_dance@idle", animationName="priv_dance_idle"},
}

Config.StripDancerPeds2 = {
    { model="s_f_y_stripper_02", x=257.26, y = -3179.5, z = 3.24, a = 283.8, animation="mini@strip_club@private_dance@part2", animationName="priv_dance_p2"},
    { model="s_f_y_stripperlite", x=257.58, y = -3182.52, z = 3.24, a = 250.35, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
    --{ model="csb_stripper_01", x=102.26, y=-1289.92, z=29.26, a=292.05, animation="mini@strip_club@private_dance@idle", animationName="priv_dance_idle"},
}

local StripPeds2, NightClubPeds2 = {}, {}
local function TriggerStripDancers2()
    -- Dancers
    for k,v in ipairs(Config.StripDancerPeds2) do
        RequestModel(GetHashKey(v.model))

        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(0)
        end

        RequestAnimDict(v.animation)
        
        while not HasAnimDictLoaded(v.animation) do
            Wait(1)
        end
        
        local stripPed = CreatePed(1, GetHashKey(v.model), v.x, v.y, v.z-1, v.a, false, false)
        table.insert(StripPeds2, stripPed)
        
        SetEntityInvincible(stripPed, true)
        SetBlockingOfNonTemporaryEvents(stripPed, true)
        
        Wait(500)
        
        FreezeEntityPosition(stripPed, true)
        SetPedFleeAttributes(stripPed, 0, 0)
        SetPedArmour(stripPed, 100)
        SetPedMaxHealth(stripPed, 100)
        SetPedDiesWhenInjured(stripPed, false)
        TaskPlayAnim(stripPed, v.animation, v.animationName, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        SetModelAsNoLongerNeeded(GetHashKey(v.model))
    end
end

Citizen.CreateThread(TriggerStripDancers2)

-- START DANCERS
local StripPeds, NightClubPeds = {}, {}
local function TriggerStripDancers()
    -- Dancers
    for k,v in ipairs(Config.StripDancerPeds) do
        RequestModel(GetHashKey(v.model))

        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(0)
        end

        RequestAnimDict(v.animation)
        
        while not HasAnimDictLoaded(v.animation) do
            Wait(1)
        end
        
        local stripPed = CreatePed(1, GetHashKey(v.model), v.x, v.y, v.z-1, v.a, false, false)
        table.insert(StripPeds, stripPed)
        
        SetEntityInvincible(stripPed, true)
        SetBlockingOfNonTemporaryEvents(stripPed, true)
        
        Wait(500)
        
        FreezeEntityPosition(stripPed, true)
        SetPedFleeAttributes(stripPed, 0, 0)
        SetPedArmour(stripPed, 100)
        SetPedMaxHealth(stripPed, 100)
        SetPedDiesWhenInjured(stripPed, false)
        TaskPlayAnim(stripPed, v.animation, v.animationName, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        SetModelAsNoLongerNeeded(GetHashKey(v.model))
    end
end

RegisterNetEvent('sr_clubjob:ToggleStripDancers')
AddEventHandler('sr_clubjob:ToggleStripDancers', function(toggle)
    if toggle then
        CreateThread(TriggerStripDancers)
    else
        for k,v in pairs(StripPeds) do
            DeletePed(v)
        end
        StripPeds = {}
    end
end)

--[[RegisterCommand("dancer", function()
	local coord = GetEntityCoords(PlayerPedId())
	local ver = vector3(937.73,31.96,112.55)
	if #(coord - ver) >= 100.0 then return end
	if ESX.GetPlayerData().identifier == "steam:1100001580c2e48" or ESX.GetPlayerData().gang.name == "STAFF" then
		TriggerServerEvent("esx_casino:DancerState")
		ESX.Alert("Taghirat Emaal Shod", "info")
	end
end)]]

Config.VStripDancerPeds = {
    { model="s_f_y_stripper_02", x=-835.54, y = -719.92, z = 28.06, a=249.6, animation="mini@strip_club@private_dance@part2", animationName="priv_dance_p2"},
    { model="s_f_y_stripperlite", x=-839.32, y = -727.83, z = 27.31, a=183.81, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
    { model="csb_stripper_02", x=-829.46, y = -719.77,z = 28.06, a=148.19, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
	--{ model="mp_f_stripperlite", x=102.3, y = -1290.13, z = 28.25, a=292.84, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
}

-- START DANCERS
local VStripPeds, VNightClubPeds = {}, {}
local function TriggerVStripDancers()
    -- Dancers
    for k,v in ipairs(Config.VStripDancerPeds) do
        RequestModel(GetHashKey(v.model))

        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(0)
        end

        RequestAnimDict(v.animation)
        
        while not HasAnimDictLoaded(v.animation) do
            Wait(1)
        end
        
        local stripPed = CreatePed(1, GetHashKey(v.model), v.x, v.y, v.z-1, v.a, false, false)
        table.insert(VStripPeds, stripPed)
        
        SetEntityInvincible(stripPed, true)
        SetBlockingOfNonTemporaryEvents(stripPed, true)
        
        Wait(500)
        
        FreezeEntityPosition(stripPed, true)
        SetPedFleeAttributes(stripPed, 0, 0)
        SetPedArmour(stripPed, 100)
        SetPedMaxHealth(stripPed, 100)
        SetPedDiesWhenInjured(stripPed, false)
        TaskPlayAnim(stripPed, v.animation, v.animationName, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        SetModelAsNoLongerNeeded(GetHashKey(v.model))
    end
end

RegisterNetEvent('sr_clubjob:TogglevStripDancers')
AddEventHandler('sr_clubjob:TogglevStripDancers', function(toggle)
	if toggle then
        CreateThread(TriggerVStripDancers)
    else
        for k,v in pairs(VStripPeds) do
            DeletePed(v)
        end
        VStripPeds = {}
    end
end)

--[[local Vodafone = {
	vector3(-1568.75,-579.39,115.71),
	vector3(-1535.4,-580.98,25.71)
}

local Pazuki = true
local index = 1

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		local coord = GetEntityCoords(PlayerPedId())
		Pazuki = true
		for k, v in pairs(Vodafone) do
			local dis = #(coord - v)
			if dis <= 1.5 then
				DrawMarker(0, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 40, 180, 50, 100, false, true, 2, false, false, false, false)
				Pazuki = false
				if k == 1 then
					index = 2
				else
					index = 1
				end
			end
		end
		if Pazuki then Citizen.Wait(750) end
	end
end)

AddEventHandler("onKeyDown", function(k)
	if k == "e" then
		if not Pazuki then
			DoScreenFadeOut(500)
			while not IsScreenFadedOut() do
				Citizen.Wait(100)
			end
			RequestCollisionAtCoord(Vodafone[index])
			ESX.SetEntityCoords(PlayerPedId(), Vodafone[index])
			while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
				ESX.SetEntityCoords(PlayerPedId(), Vodafone[index])
				Citizen.Wait(10)
			end
			DoScreenFadeIn(500)
		end
	end
end)]]