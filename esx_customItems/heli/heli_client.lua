--local ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        --TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(500)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local fov_max = 110
local fov_min = 7.5 
local zoomspeed = 3.0 
local speed_lr = 8.0 
local speed_ud = 8.0 
local toggle_helicam = 51 
local toggle_vision = 25 
local toggle_rappel = 154 --X--
local toggle_spotlight = 183 --G--
local toggle_lock_on = 22 --X--
local minHeightAboveGround = 1.5 
local useMilesPerHour = false 

local helicam = false 
local eligAbleHelis = {
    {model = GetHashKey("polmash"), rappel =  true},
    {model = GetHashKey("polsp"), rappel = true},
    {model = GetHashKey("polmav"), rappel = true},
    {model = GetHashKey("polmedik"), rappel = true},
    {model = GetHashKey("fblsp"), rappel = true},
    {model = GetHashKey("newsheli"), rappel = true},
    {model = GetHashKey("newsheli2"), rappel = true},
}

local fov = (fov_max + fov_min) * 0.5
local vision_state = 0 
local spotlight_state = false

local whiteListedJobs = {
	["police"] = true,
	["forces"] = true,
    ["sheriff"] = true,
    ["ambulance"] = true,
    ["medic"] = true,
    ["fbi"] = true,
}

AddEventHandler("onKeyDown", function(key)
    if (key == "e" or key == "x") and ESX.GetPlayerData()['IsDead'] ~= 1 then
        local data = IsPlayerInPolmav()
        if data or (IsVehicleModel(GetVehiclePedIsIn(PlayerPedId()), GetHashKey("buzzard2")) and ESX.GetPlayerData().job.name == "fbi") then
            local rap
            if (IsVehicleModel(GetVehiclePedIsIn(PlayerPedId()), GetHashKey("buzzard2")) and ESX.GetPlayerData().job.name == "fbi") then
                rap = false
            else
                rap = data.rappel
            end
            local lPed = PlayerPedId() 
            local heli = GetVehiclePedIsIn(lPed)
            local highEnough = IsHeliHighEnough(heli)
			if key == "e" and highEnough then
				if GetPedInVehicleSeat(heli, -1) == lPed or GetPedInVehicleSeat(heli, 0) == lPed then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					helicam = not helicam
					if helicam then HandleHeliCam() SendNUIMessage({type = 'show'}) end
                else
                    ESX.Alert("~r~Shoma Nemitavanid Az Seat Haye Aghab Az Camera Use Konid", "error")
                    PlaySoundFrontend(-1, "5_Second_Timer","DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false)
				end
            elseif key == "x" and highEnough and rap then
                if GetPedInVehicleSeat(heli, 1) == lPed or GetPedInVehicleSeat(heli, 2) == lPed then
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    SetPedCanRagdoll(lPed, false)
					TaskRappelFromHeli(lPed, 1)
					Citizen.SetTimeout(15000, function()
						SetPedCanRagdoll(lPed, true)
					end)
                else
                    ESX.Alert("~r~Can't Rappel From This Seat", "error")
                    PlaySoundFrontend(-1, "5_Second_Timer","DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false)
                end
            end 
        end
	end
end)

function HandleHeliCam()
    Citizen.CreateThread(function()
        while helicam do
            Citizen.Wait(200)
            if helicam then
                local scaleform = RequestScaleformMovie("DRONE_CAM")
                while not HasScaleformMovieLoaded(scaleform) do
                    Citizen.Wait(0)
                end
                local lPed = PlayerPedId()
                local heli = GetVehiclePedIsIn(lPed)
                local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
                AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)
                SetCamRot(cam, 0.0, 0.0, GetEntityHeading(heli))
                SetCamFov(cam, fov)
                RenderScriptCams(true, false, 0, 1, 0)    
                local locked_on_vehicle = nil
                while helicam and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == heli) and IsHeliHighEnough(heli) do
                    if IsControlJustPressed(0, toggle_helicam) then 
                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                        helicam = false
                        SendNUIMessage({type = 'hide'})
                    end
                    if IsControlJustPressed(0, toggle_vision) and PlayerData.job and whiteListedJobs[PlayerData.job.name] then
                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                        ChangeVision()
                    end
                    DisableControlAction(0, 75, true)
                    DisableControlAction(27, 75, true)  
                    local vehicle = nil  
                    if locked_on_vehicle then
                        if DoesEntityExist(locked_on_vehicle) then
                            vehicle = locked_on_vehicle
                            PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
                            if IsControlJustPressed(0, toggle_lock_on) then
                                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                locked_on_vehicle = nil
                                local rot = GetCamRot(cam, 2)
                                local fov = GetCamFov(cam)
                                local old
                                cam = cam
                                DestroyCam(old_cam, false)
                                cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
                                AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)
                                SetCamRot(cam, rot, 2)
                                SetCamFov(cam, fov)
                                RenderScriptCams(true, false, 0, 1, 0)
                            end
                        else
                            locked_on_vehicle = nil 
                        end
                    else
                        local zoomvalue = (1.0 / (fov_max - fov_min)) *
                        (fov - fov_min)
                        CheckInputRotation(cam, zoomvalue)
                        local vehicle_detected = GetVehicleInView(cam)
                        if DoesEntityExist(vehicle_detected) then
                            vehicle = vehicle_detected
                            if IsControlJustPressed(0, toggle_lock_on) then
                                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                locked_on_vehicle = vehicle_detected
                            end
                        end
                    end
                    HandleZoom(cam)
                    HideHUDThisFrame()    
                    BeginScaleformMovieMethod(scaleform, "SET_DISPLAY_CONFIG")
                    ScaleformMovieMethodAddParamInt(0)
                    ScaleformMovieMethodAddParamInt(0)
                    ScaleformMovieMethodAddParamFloat(0.0)
                    ScaleformMovieMethodAddParamFloat(0.0)
                    ScaleformMovieMethodAddParamFloat(0.0)
                    ScaleformMovieMethodAddParamFloat(0.0)
                    ScaleformMovieMethodAddParamBool(true)
                    ScaleformMovieMethodAddParamBool(true)
                    ScaleformMovieMethodAddParamBool(false)
                    EndScaleformMovieMethod()  
                    BeginScaleformMovieMethod(scaleform, "SET_ALT_FOV_HEADING")
                    ScaleformMovieMethodAddParamFloat(GetEntityCoords(heli).z)
                    ScaleformMovieMethodAddParamFloat(zoomvalue)
                    ScaleformMovieMethodAddParamFloat(GetCamRot(cam, 2).z)
                    EndScaleformMovieMethod() 
                    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                    local playerCoords = GetEntityCoords(lPed)
                    local streetname = GetStreetNameFromHashKey(
                    GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z))
                    local roadHashNearHeli
                    if vehicle == nil then
                        SendNUIMessage({type = "update", info = {fov = fov, numPlate = "", vehRoadName = "", vehHeading = -1, locked = not not locked_on_vehicle, camtype = vision_state, speed = "", spotlight = spotlight_state}})
                    else
                        local vehicleCoords = GetEntityCoords(vehicle)
                        local vehstreetname =
                            GetStreetNameFromHashKey(
                            GetStreetNameAtCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z))
                        local vehspd = ""
                        if useMilesPerHour then
                            vehspd = string.format("%." .. (numDecimalPlaces or 0) .. "f", GetEntitySpeed(vehicle) * 2.236936) .. " mph"
                        else
                            vehspd = string.format("%." .. (numDecimalPlaces or 0) .. "f", GetEntitySpeed(vehicle) * 3.6) .. " kmh"
                        end
                        SendNUIMessage({type = "update", info = {fov = fov, numPlate = GetVehicleNumberPlateText(vehicle), vehRoadName = vehstreetname, vehHeading = GetEntityHeading(vehicle), locked = not not locked_on_vehicle, camtype = vision_state, speed = vehspd, spotlight = spotlight_state}})
                    end
                    Citizen.Wait(10)
                end
                helicam = false
                fov = (fov_max + fov_min) * 0.5 
                RenderScriptCams(false, false, 0, 1, 0) 
                SetScaleformMovieAsNoLongerNeeded(scaleform) 
                DestroyCam(cam, false)
                SetNightvision(false)
                SetSeethrough(false)
                SendNUIMessage({type = "hide"})
                vision_state = 0
                spotlight_state = false
            end
        end
    end)
end

function IsPlayerInPolmav()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    for index, data in ipairs(eligAbleHelis) do
        if IsVehicleModel(vehicle, data.model) then
            return data
        end
    end
    return false
end

function IsHeliHighEnough(heli)
    return GetEntityHeightAboveGround(heli) > minHeightAboveGround
end

function ChangeVision()
    if vision_state == 0 then
        SetNightvision(true)
        vision_state = 1
    elseif vision_state == 1 then
        SetNightvision(false)
        SetSeethrough(true)
        vision_state = 2
    else
        SetSeethrough(false)
        vision_state = 0
    end
end

function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1) 
    HideHudComponentThisFrame(2) 
    HideHudComponentThisFrame(3) 
    HideHudComponentThisFrame(4) 
    HideHudComponentThisFrame(7) 
    HideHudComponentThisFrame(8) 
    HideHudComponentThisFrame(9) 
    HideHudComponentThisFrame(11) 
    HideHudComponentThisFrame(12) 
    HideHudComponentThisFrame(13) 
    HideHudComponentThisFrame(15) 
    HideHudComponentThisFrame(18) 
    HideHudComponentThisFrame(19)
    HideHudComponentThisFrame(21) 
end

function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
        new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 *
        (speed_lr) * (zoomvalue + 0.1)), -89.5) 
        SetCamRot(cam, new_x, 0.0, new_z, 2)
    end
end

function HandleZoom(cam)
    if IsControlJustPressed(0, 241) then 
        fov = math.max(fov - zoomspeed, fov_min)
    end
    if IsControlJustPressed(0, 242) then
        fov = math.min(fov + zoomspeed, fov_max) 
    end
    local current_fov = GetCamFov(cam)
    if math.abs(fov - current_fov) < 0.1 then 
        fov = current_fov
    end
    SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
end

function GetVehicleInView(cam)
    local coords = GetCamCoord(cam)
    local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
    local rayhandle = StartShapeTestRay(coords, coords + (forward_vector * 350.0), 10, GetVehiclePedIsIn(PlayerPedId()), 0)
    local _, _, _, _, entityHit = GetShapeTestResult(rayhandle)
    if entityHit > 0 and IsEntityAVehicle(entityHit) then
        return entityHit
    else
        return nil
    end
end

local currentPlayerId = GetPlayerServerId(PlayerId())

function HandleSpotlight(cam)
    if IsControlJustPressed(0, toggle_spotlight) then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        spotlight_state = not spotlight_state
        if spotlight_state then
            TriggerServerEvent("heli:spotlight_on", currentPlayerId, 0)
        else
            TriggerServerEvent("heli:spotlight_off", currentPlayerId, 0)
        end
    end
    if spotlight_state then
        local rotation = GetCamRot(cam, 2)
        local forward_vector = RotAnglesToVec(rotation)
        local camcoords = GetCamCoord(cam)
        DrawSpotLight(camcoords, forward_vector, 255, 255, 255, 300.0, 0.5, 0.5, 7.50, 75.0)
        TriggerServerEvent("heli:spotlight_update", currentPlayerId, {comcoords = camcoords, forward_vector = forward_vector})
    end
end

function RotAnglesToVec(rot) 
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end