---@diagnostic disable: undefined-field, undefined-global, param-type-mismatch, missing-parameter
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while not ESX.GetPlayerData().job do
        Citizen.Wait(500)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

Positions = {
    ["BallasEmpire"] = {
        [1] = vector3(-2076.435, -521.8549, 13.71057),
        [2] = vector3(-2249.723, -605.0505, 13.87915)
    },
    ["HangOvers"] = {
        [1] = vector3(935.83, 46.75, 81.1),
        [2] = vector3(965.04, 58.52, 112.55),
    },
    ["weazel"] = {
        [1] = vector3(-568.9583, -927.6, 36.77808),
        [2] = vector3(-575.8286, -920.3868, 23.77002),
    },
    ["streetclub"] = {
        [1] = vector3(132.41,-1287.46,29.27),
        [2] = vector3(132.75,-1292.85,29.27),
    },
    ["Sicilian"] = {
        [1] = vector3(969.41,67.57,112.55),
        [2] = vector3(978.23,62.15,120.24),
    },

    ["police"] = {
        [1] = vector3(447.53,-998.81,34.97),
        [2] = vector3(-1074.6,-824.66,23.46),
    },
    ["sheriff"] = {
        [1] = vector3(1850.13,3675.52,38.93),
        [2] = vector3(-451.24,5995.28,37.0),
    },
    ["forces"] = {
        [1] = vector3(590.22,-6.84,82.76),
        [2] = vector3(381.49,-1608.79,30.2),
    },
    ["mechanic"] = {
        [1] = vector3(1374.31,-712.84,74.16),
        [2] = vector3(1182.76,2640.53,38.22),
    },
    ["benny"] = {
        [1] = vector3(-572.21,-1796.99,26.84),
        [2] = vector3(1182.76,2640.53,38.22),
    },
    ["taxi"] = {
        [1] = vector3(1696.07,3594.86,35.62),
        [2] = vector3(909.6,-153.29,74.22),
    },
}

Citizen.CreateThread(function()
	while ESX == nil do 
	    Citizen.Wait(0) 
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    while ESX.GetPlayerData().gang == nil do
		Citizen.Wait(10)
	end

    while PlayerData == nil do
		Citizen.Wait(10)
	end

    -- Citizen.CreateThread(function()
    --     InstallTeleport(Positions["everyone"])
    -- end)

    if Positions[PlayerData.job.name] then
        Citizen.CreateThread(function()
            InstallTeleport(Positions[PlayerData.job.name])
        end)
    end
    
    if Positions[PlayerData.gang.name] then
        Citizen.CreateThread(function()
            InstallTeleport(Positions[PlayerData.gang.name])
        end)
    end

    -- if PlayerData.job.name == "forces" then
    --     Citizen.CreateThread(function()
    --         InstallTeleport(Positions["forces2"])
    --     end)
    -- end

end)

function InstallTeleport(handler)
    Citizen.CreateThread(function()
        local Point = RegisterPoint(handler[1], 15, true)
        local BPoint= RegisterPoint(handler[2], 15, true)
        Point.set("Tag", "teleporter")
        BPoint.set("Tag", "teleporter")
        Point.set("InArea", function()
            DrawMarker(0, handler[1], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 40, 180, 50, 150, false, true, 2, false, false, false, false)
			if #(GetEntityCoords(PlayerPedId()) - handler[1]) < 1.5 then
				ESX.ShowHelpNotification('Dokmeye ~INPUT_CONTEXT~ Baraye Teleport Kardan')
				if IsControlJustReleased(0, 38) then
					Wait(math.random(1,500))
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(100)
                    end
                    RequestCollisionAtCoord(handler[2])
                    ESX.SetEntityCoords(PlayerPedId(), handler[2])
                    SetEntityHeading(PlayerPedId(), 250.0)
                    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                        ESX.SetEntityCoords(PlayerPedId(), handler[2])
                        Citizen.Wait(10)
                    end
                    DoScreenFadeIn(500)
				end
			end
        end)
        BPoint.set("InArea", function()
            DrawMarker(0, handler[2], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 40, 180, 50, 100, false, true, 2, false, false, false, false)
			if #(GetEntityCoords(PlayerPedId()) - handler[2]) < 1.5 then
				ESX.ShowHelpNotification('Dokmeye ~INPUT_CONTEXT~ Baraye Teleport Kardan')
				if IsControlJustReleased(0, 38) then
					Wait(math.random(1,500))
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(100)
                    end
                    RequestCollisionAtCoord(handler[1])
                    ESX.SetEntityCoords(PlayerPedId(), handler[1])
                    SetEntityHeading(PlayerPedId(), 250.0)
                    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                        ESX.SetEntityCoords(PlayerPedId(), handler[1])
                        Citizen.Wait(10)
                    end
                    DoScreenFadeIn(500)
				end
			end
        end)
    end)
end

local Timer = 0

AddEventHandler("PlayerLoadedToGround", function()
    if ESX.GetPlayerData().aduty and ESX.GetPlayerData().permission_level > 1 then
        AddEventHandler("onMultiplePress", function(keys)
            if keys["lshift"] and keys["e"] and ESX.GetPlayerData()['IsDead'] ~= 1 then
                if GetGameTimer() - Timer > 3000 then
                    SetKeyThread()
                    Timer = GetGameTimer()
                end
            end
        end)
    end
end)

function SetKeyThread()
    ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)
        if isAduty then
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
                SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.5, false, false, false, true)
                ESX.Alert("Shoma be marker roye map teleport shodid!", "check")
            else
                ESX.Alert("Markeri baraye teleport shodan vojoud nadarad!", "error")
            end 
        else    
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}})
        end
    end)
end