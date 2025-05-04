---@diagnostic disable: undefined-global, missing-parameter
local executado = false
local IsNUIReady = false
POINTS = {
    ["parking"] = vec3(213.309891, -813.085693, 30.728882),
    ["hospital"] = vec3(-703.49,278.14,83.74),
    ["pd"] = vec3(414.329681, -969.613159, 29.465210),
    ["mechanici"] = vector3(1294.55,-727.67,64.67),
    ["sandy"] = vec3(1862.492310, 3678.145020, 33.643921),
    ["gamecenter"] = vec3(1388.57, 6537.9, 17.71),
}

--[[RegisterCommand("test", function()
    TriggerEvent('vrp:ToogleLoginMenu')
end)]]

RegisterNUICallback('NUIReady', function(data, cb)
    IsNUIReady = true
end)

RegisterNetEvent("ToggleLoginMenu")
AddEventHandler("ToggleLoginMenu",function()
    while not IsNUIReady do Citizen.Wait(2500) end
    local newPlayer
    TriggerEvent("loading:IsNewPlayer", function(newbie)
        newPlayer = newbie
    end)
    while newPlayer == nil do Wait(500) end 
    if newPlayer then return end 
    SetEntityInvincible(PlayerPedId(),false)--MQCU
    FreezeEntityPosition(PlayerPedId(),true)
    SetNuiFocus(true, true)
    SetTimecycleModifier("hud_def_blur")
    local favorito = GetResourceKvpString('local')
    SendNUIMessage({
        action = "show",
        favorito = favorito
    })
end)

RegisterNUICallback("selecionar", function(data) 
    ClearTimecycleModifier()

    SetNuiFocus(false, false)

    local position = { h = 0.0 }

    if data.name == "last" then
        local coords = GetEntityCoords(PlayerPedId())
        position.x, position.y, position.z = coords.x, coords.y, coords.z
        TriggerEvent("login:SetupNewStuff")
    else
        position.x, position.y, position.z = POINTS[data.name].x+0.0001, POINTS[data.name].y+0.0001, POINTS[data.name].z+0.0001
        TriggerEvent("login:SetupNewStuff", position)
    end

    --SpawnPlayer(position)

    --[[if data.name ~= "last" and GetEntityHealth(PlayerPedId()) > 101 then
        local timeout = 0
		RequestCollisionAtCoord(POINTS[data.name].x+0.0001, POINTS[data.name].y+0.0001, POINTS[data.name].z+0.0001)
		StartPlayerTeleport(PlayerId(),POINTS[data.name].x+0.0001, POINTS[data.name].y+0.0001, POINTS[data.name].z+0.0001, true, true, true)
		while not HasPlayerTeleportFinished(PlayerId()) or not HasCollisionLoadedAroundEntity(PlayerPedId()) do
			timeout = timeout + 5
			if timeout > 75 then 
                SetEntityCoords(PlayerPedId(), POINTS[data.name].x+0.0001, POINTS[data.name].y+0.0001, POINTS[data.name].z+0.0001, 1,0,0,1)
				break
			end
			Wait(200)
		end
		StopPlayerTeleport(PlayerId())
        SetEntityCoords(PlayerPedId(), POINTS[data.name].x+0.0001, POINTS[data.name].y+0.0001, POINTS[data.name].z+0.0001, 1,0,0,1)
    end
    SetEntityInvincible(PlayerPedId(),false)--MQCU
    FreezeEntityPosition(PlayerPedId(),false)
    SetNuiFocus(false, false)
    TriggerEvent("ToogleBackCharacter")]]
end)

function SpawnPlayer(Location)
    local pos = Location
    local ped = PlayerPedId()
    
    SetNuiFocus(false, false)

    InitialSetup()
    Citizen.Wait(500)
    ESX.SetEntityCoords(ped, pos.x, pos.y, pos.z)
    Citizen.Wait(500)
    ESX.SetEntityCoords(ped, pos.x, pos.y, pos.z)
    SetEntityHeading(ped, pos.h)
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    SetEntityVisible(GetPlayerPed(-1), true)
    Citizen.Wait(500)
    SetNuiFocus(false, false)

    ShutdownLoadingScreen()
    
    ClearScreen()
    Citizen.Wait(0)
    DoScreenFadeOut(0)

    ShutdownLoadingScreenNui()
    
    ClearScreen()
    Citizen.Wait(0)
    ClearScreen()
    DoScreenFadeIn(500)
    while not IsScreenFadedIn() do
        Citizen.Wait(0)
        ClearScreen()
    end
    
    local timer = GetGameTimer()

    while true do
        ClearScreen()
        Citizen.Wait(0)
        
        if GetGameTimer() - timer > 500 then
            
            ToggleSound(false)
            SwitchInPlayer(PlayerPedId())
            ClearScreen()
            while GetPlayerSwitchState() ~= 12 do
                Citizen.Wait(0)
                ClearScreen()
            end

            break
        end
    end
    
    ClearDrawOrigin()
end

exports("SpawnPlayer", SpawnPlayer)

RegisterNUICallback("favoritar", function(data) 
    SetResourceKvp("local",data.name)
end)

