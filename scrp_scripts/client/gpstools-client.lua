local isMinimapEnabled = false

RegisterNetEvent('gpstools:setgps')
AddEventHandler('gpstools:setgps', function(pos)
	-- add required decimal or else it wont work
	pos.x = pos.x + 0.00
	pos.y = pos.y + 0.00

	SetNewWaypoint(pos.x, pos.y)
	ESX.ShowHelpNotification(_U('gpstools_setgps_ok'))
end)

RegisterNetEvent('gpstools:getpos')
AddEventHandler('gpstools:getpos', function()
	local playerPed = PlayerPedId()

	local pos      = GetEntityCoords(playerPed)
	local heading  = GetEntityHeading(playerPed)
	local finalPos = {}

	-- round to 2 decimals
	finalPos.x = string.format("%.2f", pos.x)
	finalPos.y = string.format("%.2f", pos.y)
	finalPos.z = string.format("%.2f", pos.z)
	finalPos.h = string.format("%.2f", heading)

	local formattedText = "x = " .. finalPos.x .. ", y = " .. finalPos.y .. ", z = " .. finalPos.z .. ', h = ' .. finalPos.h
	TriggerEvent('chatMessage', 'SYSTEM', { 0, 0, 0 }, formattedText)
	print(formattedText)
end)

RegisterNetEvent('gpstools:togglegps')
AddEventHandler('gpstools:togglegps', function()
	if not isMinimapEnabled then
		SetRadarBigmapEnabled(true, false)
		isMinimapEnabled = true
	else
		SetRadarBigmapEnabled(false, false)
		isMinimapEnabled = false
	end
end)

--[[RegisterNetEvent('gpstools:tpwaypoint')
AddEventHandler('gpstools:tpwaypoint', function()
	local playerPed = PlayerPedId()

		if(IsPedInAnyVehicle(playerPed))then
			playerPed = GetVehiclePedIsUsing(playerPed)
		end

		local WaypointHandle = GetFirstBlipInfoId(8)
		if DoesBlipExist(WaypointHandle) then
			local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
			RequestCollisionAtCoord(coord.x, coord.y, -199.5)
			while not HasCollisionLoadedAroundEntity(playerPed) do
				RequestCollisionAtCoord(coords.x, coords.y, -199.5)
				Citizen.Wait(0)
			end
			ESX.SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.5, false, false, false, true)
			ESX.Alert("Shoma be marker roye map teleport shodid!", "check")
		else
			ESX.Alert("Markeri baraye teleport shodan vojoud nadarad!", "error")
		end

end)]]

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	TriggerEvent('esx_gps:removeGPS')

	for i=1, #PlayerData.inventory, 1 do
		if PlayerData.inventory[i].name == 'gps' then
			if PlayerData.inventory[i].count > 0 then
				TriggerEvent('esx_gps:addGPS')
			end
		end
	end

end)

RegisterNetEvent('esx_gps:addGPS')
AddEventHandler('esx_gps:addGPS', function()
	DisplayRadar(true)
end)

RegisterNetEvent('esx_gps:removeGPS')
AddEventHandler('esx_gps:removeGPS', function()
	DisplayRadar(false)
end)
local coordsVisible = false

function DrawGenericText(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(7)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.40, 0.00)
end

Citizen.CreateThread(function()
    while true do
		local sleepThread = 250
		
		if coordsVisible then
			sleepThread = 5

			local playerPed = PlayerPedId()
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
			local playerH = GetEntityHeading(playerPed)

			DrawGenericText(("~g~X~w~: %s ~g~Y~w~: %s ~g~Z~w~: %s ~g~H~w~: %s"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ), FormatCoord(playerH)))
		else
		Citizen.Wait(5000)
		end

		Citizen.Wait(sleepThread)
	end
end)

FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end

	return tonumber(string.format("%.2f", coord))
end

ToggleCoords = function()
	coordsVisible = not coordsVisible
end

RegisterCommand("coords", function()
    ToggleCoords()
end)