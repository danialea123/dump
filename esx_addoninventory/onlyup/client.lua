---@diagnostic disable: undefined-global, param-type-mismatch, missing-parameter
local StartCoord = vector3(3741.62,-1523.37,842.75)
local Started = false
local CheckPoint = {
    [1] = {
        coord = vector3(3740.75,-1411.17,841.61),
        reached = false,
        id = 1,
    },
    [2] = {
        coord = vector3(3751.7,-1447.59,861.9),
        reached = false,
        id = 2,
    },
    [3] = {
        coord = vector3(3724.05,-1412.2,896.65),
        reached = false,
        id = 3,
    },
    [4] = {
        coord = vector3(3694.58,-1260.13,902.95),
        reached = false,
        id = 4,
    },
}

function Escape()
    Citizen.CreateThread(function()
        while not Started do
            Citizen.Wait(3)
            local coord = GetEntityCoords(PlayerPedId())
            SetPedCanRagdollFromPlayerImpact(PlayerPedId(), false)
            SetPedCanRagdoll(PlayerPedId(), false)
            DisablePlayerFiring(PlayerPedId(), true)
            DisableControlAction(0,24,true) -- disable attack
            --[[DisableControlAction(0,47,false) -- disable weapon]]
            DisableControlAction(0,58,true) -- disable weapon
            DisableControlAction(0,263,true) -- disable melee
            DisableControlAction(0,264,true) -- disable melee
            DisableControlAction(0,257,true) -- disable melee
            DisableControlAction(0,140,true) -- disable melee
            DisableControlAction(0,141,true) -- disable melee
            DisableControlAction(0,142,true) -- disable melee
            DisableControlAction(0,143,true) -- disable melee
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 69, true) -- Melee Attack 1
            DisableControlAction(0, 70, true)
            DisableControlAction(0, 92, true)
            if ESX.GetPlayerData()['IsDead'] then
				Citizen.Wait(3000)
				TriggerEvent("esx_ambulancejob:revive")
                Citizen.Wait(2000)
			end  
            if #(coord - StartCoord) >= 25 then
                SetEntityCoords(PlayerPedId(), StartCoord, false, false, false, false)
            end
            DrawMarker(1, StartCoord.x, StartCoord.y, StartCoord.z - 30, 0, 0, 0, 0, 0, 0, 25 * 2.0, 25 * 2.0, 80.0, 100, 255, 100, 250, 0, 0, 0, 0)
        end
    end)
end

function CheckPoints()
    Citizen.CreateThread(function()
        while Started do
            Citizen.Wait(3)
            local coord = GetEntityCoords(PlayerPedId())
            SetPedCanRagdollFromPlayerImpact(PlayerPedId(), false)
            SetPedCanRagdoll(PlayerPedId(), false)
            DisablePlayerFiring(PlayerPedId(), true)
            DisableControlAction(0,24,true) -- disable attack
            --[[DisableControlAction(0,47,false) -- disable weapon]]
            DisableControlAction(0,58,true) -- disable weapon
            DisableControlAction(0,263,true) -- disable melee
            DisableControlAction(0,264,true) -- disable melee
            DisableControlAction(0,257,true) -- disable melee
            DisableControlAction(0,140,true) -- disable melee
            DisableControlAction(0,141,true) -- disable melee
            DisableControlAction(0,142,true) -- disable melee
            DisableControlAction(0,143,true) -- disable melee
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 69, true) -- Melee Attack 1
            DisableControlAction(0, 70, true)
            DisableControlAction(0, 92, true)
			if ESX.GetPlayerData()['IsDead'] then
				Citizen.Wait(3000)
				TriggerEvent("esx_ambulancejob:revive")
                Citizen.Wait(2000)
			end   
            if GetEntityHealth(PlayerPedId()) < 200 then
                ESX.SetEntityHealth(PlayerPedId(), 200)
            end     
            DrawMarker(1, 3900.95,-1149.51,849.18, 0, 0, 0, 0, 0, 0, 3 * 2.0, 3 * 2.0, 2.5, 20, 205, 100, 250, 0, 0, 0, 0)
            if #(coord - vector3(3900.95,-1149.51,849.18)) <= 4.0 then
                Started = false
            end
            for k, v in pairs(CheckPoint) do
                local dis = #(coord - v.coord)
                if dis <= 20 then
                    if dis <= 2.0 then
                        v.reached = true
                    end
                    if v.reached then
                        DrawMarker(6, v.coord, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 51, 255, 51, 200, false, true, 2, false, false, false, false)
                        DrawMarker(20, v.coord, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 51, 255, 51, 200, false, true, 2, false, false, false, false)
                    else
                        DrawMarker(6, v.coord, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 51, 255, 255, 200, false, true, 2, false, false, false, false)
                        DrawMarker(20, v.coord, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 51, 255, 255, 200, false, true, 2, false, false, false, false)
                    end
                end
            end
        end
    end)
end

function CheckFall()
    Citizen.CreateThread(function()
        while Started do
            Citizen.Wait(1000)
            local coord = GetEntityCoords(PlayerPedId())
            local Check = GetLastCheckPoint()
            if not Check then
                if StartCoord.z - coord.z >= 100.0 then
                    Teleport(StartCoord)
                end
            else
                if CheckPoint[Check].coord.z - coord.z >= 100.0 then
                    Teleport(CheckPoint[Check].coord)
                end
            end
        end
        Joined = false
        Teleport(lastCoord)
        exports.esx_manager:setException(false)
        ESX.SetPlayerInvincible(PlayerPedId(), false)
        EnableAllControlActions(0)
        if not Exit then
            TriggerServerEvent("esx_onlyUP:ResetCoord")
        end
    end)
end

function GetLastCheckPoint()
    Check = false
    local p = 0
    for k, v in pairs(CheckPoint) do
        if v.reached and k > p then
            Check = k
            p = k
        end
    end
    return Check
end

RegisterNetEvent("esx_onlyUP:JoinEvent")
AddEventHandler("esx_onlyUP:JoinEvent", function()
    if GetInvokingResource() then return end
    TriggerEvent("pma-voice:mutePlayer")
    lastCoord = GetEntityCoords(PlayerPedId())
    Joined = true
    Exit = false
    Teleport(StartCoord)
    Escape()
end)

RegisterNetEvent("esx_onlyUP:ExitEvent")
AddEventHandler("esx_onlyUP:ExitEvent", function()
    if GetInvokingResource() then return end
    Exit = true
    if not Started then
        TriggerEvent("pma-voice:mutePlayer")
    end
    Joined = false
    Started = false
    Teleport(lastCoord)
end)

RegisterNetEvent("esx_onlyUP:StartEvent")
AddEventHandler("esx_onlyUP:StartEvent", function()
    if GetInvokingResource() then return end
    if Joined then
        Started = true
        Exit = false
        CheckPoints()
        CheckFall()
        exports.esx_manager:setException(true)
        ESX.SetPlayerInvincible(PlayerPedId(), true)
        TriggerEvent("pma-voice:mutePlayer")
    end
end)

function Teleport(coords)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    local timeout = 0
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(100)
    end
    ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) and timeout < 5000 do
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
        Citizen.Wait(500)
        timeout = timeout + 500
    end
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
    DoScreenFadeIn(500)
end

local Hashes = {
    [GetHashKey("bmwm4")] = true,
    [GetHashKey("gxa90")] = true,
    [GetHashKey("laferrari")] = true,
    [GetHashKey("Y1700MAX")] = true,
    [GetHashKey("e63amg")] = true,
    [GetHashKey("amggtr")] = true,
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        if vehicle then
            local model = GetEntityModel(vehicle)
            if Hashes[model] then
                SetVehicleDirtLevel(vehicle, 0.0)
            end
        end
    end
end)