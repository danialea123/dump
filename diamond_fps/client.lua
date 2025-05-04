---@diagnostic disable: lowercase-global, missing-parameter
local isUI = false 
local openOne = false
local sun_details, ObjectRender,PedRender, CarsDistance, renderupdate, renderupdate2, ClearEvents, Reflections_Lights,Raind_Wind,Clear_Blood_Dirt,Disable_Fire_Effect,Scenarios_Delete = 2, 4, 4, 4, false, false , false, true, false, false, false, false

RegisterCommand("fpsmenu", function ()
    OpenUI()
end)

Citizen.CreateThread(function()
    while true do
		if isUI then
            updateFPS()
		else
			Citizen.Wait(3000)
		end
		Citizen.Wait(1500)
    end
end)

RegisterNUICallback("close", function ()
    SetNuiFocus(0,0)
    isUI = false 
end)

RegisterNUICallback("Settings", function ()
    ActivateFrontendMenu(`FE_MENU_VERSION_LANDING_MENU`, false, -1)
end)

RegisterNUICallback("reset", function ()
    sun_details, ObjectRender,PedRender, CarsDistance, renderupdate, renderupdate2, ClearEvents, Reflections_Lights,Raind_Wind,Clear_Blood_Dirt,Disable_Fire_Effect, Scenarios_Delete = 2, 4, 4, 4, false, false , false, true, false, false, false, false
    SetTimecycleModifier()
    ClearTimecycleModifier()
    ClearExtraTimecycleModifier()
    if GetGameBuildNumber() >= 2372 then
        SetArtificialLightsState(false)    
    else
        SetBlackout(false)
    end
    CascadeShadowsClearShadowSampleType()
    CascadeShadowsSetAircraftMode(false)
    CascadeShadowsEnableEntityTracker(true)
    CascadeShadowsSetDynamicDepthMode(false)
    CascadeShadowsSetAircraftMode(true)
    CascadeShadowsEnableEntityTracker(false)
    CascadeShadowsSetDynamicDepthMode(true)
    CascadeShadowsSetEntityTrackerScale(5.0)
    CascadeShadowsSetDynamicDepthValue(5.0)
    CascadeShadowsSetCascadeBoundsScale(5.0)
    SetFlashLightFadeDistance(3.0)
    SetLightsCutoffDistanceTweak(3.0)
    openOne = false
end)

RegisterNUICallback("ChangeSetting", function (data)
    typ = data.typ
    menuid = data.menuid
    altid = data.altid
    if typ == "on_off" then 
        if Config.FpsMenu[menuid][altid].func == "ClearEvents" then 
            ClearEvents = not ClearEvents
        elseif Config.FpsMenu[menuid][altid].func == "Reflections_Lights" then 
            if GetGameBuildNumber() >= 2372 then
                SetArtificialLightsState(Reflections_Lights)    
            else
                SetBlackout(Reflections_Lights)
            end
            Reflections_Lights = not Reflections_Lights
        elseif Config.FpsMenu[menuid][altid].func == "Raind_Wind" then 
            Raind_Wind = not Raind_Wind
        elseif Config.FpsMenu[menuid][altid].func == "Clear_Blood_Dirt" then 
            Clear_Blood_Dirt = not Clear_Blood_Dirt
        elseif Config.FpsMenu[menuid][altid].func == "Disable_Fire_Effect" then 
            Disable_Fire_Effect = not Disable_Fire_Effect
        elseif Config.FpsMenu[menuid][altid].func == "Scenarios_Delete" then 
            Scenarios_Delete = not Scenarios_Delete
        end
    else 
        num = tonumber(data.num)
        if Config.FpsMenu[menuid][altid].func == "shadow_ranger" then 
            CascadeShadowsClearShadowSampleType()
            CascadeShadowsSetAircraftMode(false)
            CascadeShadowsEnableEntityTracker(true)
            CascadeShadowsSetDynamicDepthMode(false)
            if num == 5 then 
                CascadeShadowsSetAircraftMode(true)
                CascadeShadowsEnableEntityTracker(false)
                CascadeShadowsSetDynamicDepthMode(true)
                CascadeShadowsSetEntityTrackerScale(5.0)
                CascadeShadowsSetDynamicDepthValue(5.0)
                CascadeShadowsSetCascadeBoundsScale(5.0)
                SetFlashLightFadeDistance(3.0)
                SetLightsCutoffDistanceTweak(3.0)
            else 
                CascadeShadowsSetEntityTrackerScale(5.0 / num)
                CascadeShadowsSetDynamicDepthValue(5.0 / num)
                CascadeShadowsSetCascadeBoundsScale(5.0 / num)
                SetFlashLightFadeDistance(0.0)
                SetLightsCutoffDistanceTweak(0.0)
            end
        elseif Config.FpsMenu[menuid][altid].func == "Sun_Details" then 
            if num == 1 then 
                SetTimecycleModifier('yell_tunnel_nodirect')
            elseif num == 2 then 
                SetTimecycleModifier()
                ClearTimecycleModifier()
                ClearExtraTimecycleModifier()
            else 
                SetTimecycleModifier('MP_Powerplay_blend')
                SetExtraTimecycleModifier('reflection_correct_ambient')    
                RopeDrawShadowEnabled(false) 
            end
            sun_details = not sun_details 
        elseif Config.FpsMenu[menuid][altid].func == "ObjectRender" then 
            ObjectRender = num
            renderupdate = true
        elseif Config.FpsMenu[menuid][altid].func == "PedRender" then 
            PedRender = num
            renderupdate = true 
        elseif Config.FpsMenu[menuid][altid].func == "CarsDistance" then 
            CarsDistance = num
            renderupdate2 = true
        end
    end  
end)
 
function addURL()
    SendNUIMessage{
        action = "addURL",
        url = Config.URL
    }
end


function OpenUI()
    isUI = true
    SendNUIMessage{
        action = "OpenMenu"
    }
    SetNuiFocus(1,1)
    updateFPS()
    if not openOne then 
        addMenus()
        addURL()
    end
    openOne = true
end

function addMenus()
    for k, v in pairs(Config.FpsMenu) do
        for l, y in pairs(v) do
            SendNUIMessage{
                action = "addMenus",
                menu = k,
                details = y,
                menuid = k,
                altid = l,
            }     
        end
    end
end

function updateFPS()
    Fps = GetFPS()
    SendNUIMessage({
        action = "fpsupdate",
        Fps = Fps
    })
end

function GetFPS()
	local fps = math.floor(1.0 / GetFrameTime())
	return fps
end

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(
        function()
            local iter, id = initFunc()
            if not id or id == 0 then
                disposeFunc(iter)
                return
            end

            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)

            local next = true
            repeat
                coroutine.yield(id)
                next, id = moveFunc(iter)
            until not next

            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end
    )
end

function GetWorldObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function GetWorldPeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function GetWorldVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function GetWorldPickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

Citizen.CreateThread(function()
    while true do
        if ObjectRender == 3 or PedRender == 3 then

            if PedRender == 3 then 
                
                for ped in GetWorldPeds() do
                    if not IsEntityOnScreen(ped) then
                        SetEntityAlpha(ped, 0)
                        SetEntityAsNoLongerNeeded(ped)
                    else
                        if GetEntityAlpha(ped) == 0 then
                            SetEntityAlpha(ped, 255)
                        elseif GetEntityAlpha(ped) ~= 210 then
                            SetEntityAlpha(ped, 210)
                        end
                    end

                    SetPedAoBlobRendering(ped, false)
                    Citizen.Wait(1)
                end
            end

            if ObjectRender == 3 then 
                
                for obj in GetWorldObjects() do
                    if not IsEntityOnScreen(obj) then
                        SetEntityAlpha(obj, 0)
                        SetEntityAsNoLongerNeeded(obj)
                    else
                        if GetEntityAlpha(obj) == 0 then
                            SetEntityAlpha(obj, 255)
                        elseif GetEntityAlpha(obj) ~= 170 then
                            SetEntityAlpha(obj, 170)
                        end
                    end
                    Citizen.Wait(1)
                end
            end

            DisableOcclusionThisFrame()
            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
            OverrideLodscaleThisFrame(0.4)
        elseif ObjectRender == 2 or PedRender == 2 then

            if PedRender == 2 then 
             
                for ped in GetWorldPeds() do
                    if not IsEntityOnScreen(ped) then
                        SetEntityAlpha(ped, 0)
                        SetEntityAsNoLongerNeeded(ped)
                    else
                        if GetEntityAlpha(ped) == 0 then
                            SetEntityAlpha(ped, 255)
                        elseif GetEntityAlpha(ped) ~= 210 then
                            SetEntityAlpha(ped, 210)
                        end
                    end
                    SetPedAoBlobRendering(ped, false)

                    Citizen.Wait(1)
                end
            end

            if ObjectRender == 2 then 
                
                for obj in GetWorldObjects() do
                    if not IsEntityOnScreen(obj) then
                        SetEntityAlpha(obj, 0)
                        SetEntityAsNoLongerNeeded(obj)
                    else
                        if GetEntityAlpha(obj) == 0 then
                            SetEntityAlpha(obj, 255)
                        elseif GetEntityAlpha(ped) ~= 210 then
                            SetEntityAlpha(ped, 210)
                        end
                    end
                    Citizen.Wait(1)
                end
            end
            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
            OverrideLodscaleThisFrame(0.6)
        elseif ObjectRender == 1 or PedRender == 1 then

            if PedRender == 1 then
			    
                for ped in GetWorldPeds() do
                    if not IsEntityOnScreen(ped) then
                        SetEntityAlpha(ped, 0)
                        SetEntityAsNoLongerNeeded(ped)
                    else
                        if GetEntityAlpha(ped) == 0 then
                            SetEntityAlpha(ped, 255)
                        end
                    end

                    SetPedAoBlobRendering(ped, false)
                    Citizen.Wait(1)
                end
            end

            if ObjectRender == 1 then 
                
                for obj in GetWorldObjects() do
                    if not IsEntityOnScreen(obj) then
                        SetEntityAlpha(obj, 0)
                        SetEntityAsNoLongerNeeded(obj)
                    else
                        if GetEntityAlpha(obj) == 0 then
                            SetEntityAlpha(obj, 255)
                        end
                    end
                    Citizen.Wait(1)
                end
            end
            OverrideLodscaleThisFrame(0.8)
        elseif ObjectRender == 4 or PedRender == 4 then
            if renderupdate then 
                for ped in GetWorldPeds() do
                    SetEntityAlpha(ped, 255)
                end
                for obj in GetWorldObjects() do
                    SetEntityAlpha(obj, 255)
                end
                renderupdate = false
            end
            Citizen.Wait(1500)
        end
        Citizen.Wait(8)
    end
end)

Citizen.CreateThread(function()
    while true do
        if  CarsDistance == 4 then
            if renderupdate2 then 
                renderupdate2 = false
                local playerPed = PlayerPedId()
                local vehicles = GetGamePool('CVehicle')
                for _, vehicle in ipairs(vehicles) do
                    --SetEntityNoCollisionEntity(vehicle, playerPed, false)
                    SetEntityVisible(vehicle, true, false)
                    ResetEntityAlpha(vehicle)
                end
            end 
            Citizen.Wait(1500)
            else 
                local playerPed = PlayerPedId()
                local playerPos = GetEntityCoords(playerPed)

                local vehicles = GetGamePool('CVehicle')
                for _, vehicle in ipairs(vehicles) do
                    local vehiclePos = GetEntityCoords(vehicle)
                    local distance = #(playerPos - vehiclePos)
                    if CarsDistance == 3 then 
                        carsdistance_total = 400
                    elseif CarsDistance == 2 then
                        carsdistance_total = 250 
                    elseif CarsDistance == 1 then 
                        carsdistance_total = 150
                    end
                    if distance > carsdistance_total then
                        --SetEntityNoCollisionEntity(vehicle, playerPed, true)
                        SetEntityVisible(vehicle, false, false)
                        SetEntityAlpha(vehicle, 0, false)
                        SetVehicleAsNoLongerNeeded(vehicle)
                    else
                        --SetEntityNoCollisionEntity(vehicle, playerPed, false)
                        SetEntityVisible(vehicle, true, false)
                        ResetEntityAlpha(vehicle)
                    end
                end
            end
        Citizen.Wait(1000) -- 
    end
end)

Citizen.CreateThread(function()
    while true do
        if ClearEvents then 
            ped = PlayerPedId()
            ClearAllBrokenGlass()
            ClearAllHelpMessages()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearPedBloodDamage(ped)
            ClearPedWetness(ped)
            ClearPedEnvDirt(ped)
            ResetPedVisibleDamage(ped)
            ClearExtraTimecycleModifier()
            ClearTimecycleModifier()
            ClearOverrideWeather()
            ClearHdArea()
            DisableVehicleDistantlights(false)
            DisableScreenblurFade()
            Wait(300) 
        else
            Wait(1500)
        end 
    end
end)

Citizen.CreateThread(function()
    while true do
        if Raind_Wind then 
            SetWind(0.0)
            SetWindSpeed(0.0)
            SetRainLevel(0.0)
            SetSnowLevel(0.0)
        end
        if Clear_Blood_Dirt then 
            local playerPed = PlayerPedId()
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedWetness(playerPed)
            ClearPedEnvDirt(playerPed)
        end
        Citizen.Wait(5000)
    end
end)


Citizen.CreateThread(function()
    while true do
        if Disable_Fire_Effect then
            local isFireActive = false
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)
            
            local vehicles = GetGamePool('CVehicle')
            for _, vehicle in ipairs(vehicles) do
                local vehiclePos = GetEntityCoords(vehicle)
                local distance = #(playerPos - vehiclePos)
                if IsEntityOnFire(vehicle) and distance < 50.0 then
                    isFireActive = true
                    SetEntityProofs(vehicle, false, true, false, false, false, false, false, false)
                    RemoveParticleFxFromEntity(vehicle)
                end
            end

            local peds = GetGamePool('CPed')
            for _, ped in ipairs(peds) do
                local pedPos = GetEntityCoords(ped)
                local distance = #(playerPos - pedPos)
                if IsEntityOnFire(ped) and distance < 50.0 then
                    isFireActive = true
                    SetEntityProofs(ped, false, true, false, false, false, false, false, false)
                    RemoveParticleFxFromEntity(ped)
                end
            end

            local objects = GetGamePool('CObject')
            for _, object in ipairs(objects) do
                local objectPos = GetEntityCoords(object)
                local distance = #(playerPos - objectPos)
                if IsEntityOnFire(object) and distance < 50.0 then
                    isFireActive = true
                    SetEntityProofs(object, false, true, false, false, false, false, false, false)
                    RemoveParticleFxFromEntity(object)
                end
            end
            
            if isFireActive then
                Citizen.Wait(100)
            else 
                Citizen.Wait(5000)
            end
        else
            Citizen.Wait(7500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if Scenarios_Delete then 
            SetGarbageTrucks(false)
            SetRandomBoats(false)
            SetCreateRandomCops(false)
            SetCreateRandomCopsNotOnScenarios(false)
            SetCreateRandomCopsOnScenarios(false)
        end
        Citizen.Wait(60000)
    end
end)

