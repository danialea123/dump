ConfigDoorbin = {}

ConfigDoorbin.Binoculars = {
    fov_max = 70.0,
    fov_min = 5.0, -- max zoom level (smaller fov is more zoom)
    zoomspeed = 10.0, -- camera zoom speed
    speed_lr = 8.0, -- speed by which the camera pans left-right
    speed_ud = 8.0, -- speed by which the camera pans up-down
    storeBinoclarKey = 177
}

local binoculars = false
local fov = (ConfigDoorbin.Binoculars.fov_max+ConfigDoorbin.Binoculars.fov_min)*0.5
local cooldown = false

local function IsPedAllowedToBinocular()
    local ped = PlayerPedId()
    return not (IsPedDeadOrDying(ped, 1) 
        or IsPedInAnyVehicle(ped, true) 
        or IsPedCuffed(ped)
        or cooldown)
end

local function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1)
    HideHudComponentThisFrame(2)
    HideHudComponentThisFrame(3)
    HideHudComponentThisFrame(4)
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(13)
    HideHudComponentThisFrame(11)
    HideHudComponentThisFrame(12)
    HideHudComponentThisFrame(15)
    HideHudComponentThisFrame(18)
    HideHudComponentThisFrame(19)
    
    -- Disable weapon scrolling and switching
    DisableControlAction(0, 14, true) -- INPUT_WEAPON_WHEEL_NEXT
    DisableControlAction(0, 15, true) -- INPUT_WEAPON_WHEEL_PREV
    DisableControlAction(0, 16, true) -- INPUT_SELECT_NEXT_WEAPON
    DisableControlAction(0, 17, true) -- INPUT_SELECT_PREV_WEAPON
    DisableControlAction(0, 99, true) -- INPUT_VEH_SELECT_NEXT_WEAPON
    DisableControlAction(0, 100, true) -- INPUT_VEH_SELECT_PREV_WEAPON
    DisableControlAction(0, 37, true) -- INPUT_SELECT_WEAPON
    DisableControlAction(0, 157, true) -- INPUT_SELECT_WEAPON_UNARMED
    DisableControlAction(0, 158, true) -- INPUT_SELECT_WEAPON_MELEE
    DisableControlAction(0, 159, true) -- INPUT_SELECT_WEAPON_SHOTGUN
    DisableControlAction(0, 160, true) -- INPUT_SELECT_WEAPON_SMG
    DisableControlAction(0, 161, true) -- INPUT_SELECT_WEAPON_AUTO_RIFLE
    DisableControlAction(0, 162, true) -- INPUT_SELECT_WEAPON_SNIPER
    DisableControlAction(0, 163, true) -- INPUT_SELECT_WEAPON_HEAVY
    DisableControlAction(0, 164, true) -- INPUT_SELECT_WEAPON_SPECIAL
end

local function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        local new_z = rotation.z + rightAxisX*-1.0*(ConfigDoorbin.Binoculars.speed_ud)*(zoomvalue+0.1)
        local new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(ConfigDoorbin.Binoculars.speed_lr)*(zoomvalue+0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
        SetEntityHeading(PlayerPedId(),new_z)
    end
end

local function HandleZoom(cam)
    local lPed = PlayerPedId()
    if not IsPedSittingInAnyVehicle(lPed) then
        if IsControlJustPressed(0,241) then -- Scrollup
            fov = math.max(fov - ConfigDoorbin.Binoculars.zoomspeed, ConfigDoorbin.Binoculars.fov_min)
        end
        if IsControlJustPressed(0,242) then
            fov = math.min(fov + ConfigDoorbin.Binoculars.zoomspeed, ConfigDoorbin.Binoculars.fov_max)
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
    else
        if IsControlJustPressed(0,17) then -- Scrollup
            fov = math.max(fov - ConfigDoorbin.Binoculars.zoomspeed, ConfigDoorbin.Binoculars.fov_min)
        end
        if IsControlJustPressed(0,16) then
            fov = math.min(fov + ConfigDoorbin.Binoculars.zoomspeed, ConfigDoorbin.Binoculars.fov_max)
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
    end
end

function BinocularLoop()
    CreateThread(function()
        local lPed = PlayerPedId()
        
        if not IsPedAllowedToBinocular() then return end
        
        cooldown = true
        SetTimeout(2000, function() cooldown = false end)

        if IsPedInAnyVehicle(lPed, true) then return end

        if not IsPedSittingInAnyVehicle(lPed) then
            TaskStartScenarioInPlace(lPed, "WORLD_HUMAN_BINOCULARS", 0, true)
            PlayPedAmbientSpeechNative(lPed, "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
        end

        Wait(2500)

        SetTimecycleModifier("default")
        SetTimecycleModifierStrength(0.3)
        local scaleform = RequestScaleformMovie("BINOCULARS")
        while not HasScaleformMovieLoaded(scaleform) do
            Wait(10)
        end

        local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
        AttachCamToEntity(cam, lPed, 0.0,0.0,1.0, true)
        SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed), 2)
        SetCamFov(cam, fov)
        RenderScriptCams(true, false, 0, true, false)
        PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
        PushScaleformMovieFunctionParameterInt(0)
        PopScaleformMovieFunctionVoid()

        while binoculars and not IsPedDeadOrDying(lPed, 1) do
            if IsControlJustPressed(0, ConfigDoorbin.Binoculars.storeBinoclarKey) or IsPedCuffed(lPed) then
                binoculars = false
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                ClearPedTasks(lPed)
            end

            local zoomvalue = (1.0/(ConfigDoorbin.Binoculars.fov_max-ConfigDoorbin.Binoculars.fov_min))*(fov-ConfigDoorbin.Binoculars.fov_min)
            CheckInputRotation(cam, zoomvalue)
            HandleZoom(cam)
            HideHUDThisFrame()
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            Wait(0)
        end
        binoculars = false
        ClearTimecycleModifier()
        fov = (ConfigDoorbin.Binoculars.fov_max+ConfigDoorbin.Binoculars.fov_min)*0.5
        RenderScriptCams(false, false, 0, true, false)
        SetScaleformMovieAsNoLongerNeeded(scaleform)
        DestroyCam(cam, false)
        SetNightvision(false)
        SetSeethrough(false)
    end)
end

RegisterNetEvent('binoculars:Toggle', function()
    if not IsPedAllowedToBinocular() then return end
    binoculars = not binoculars

    if binoculars then
        BinocularLoop()
        return
    end

    ClearPedTasks(PlayerPedId())
end)
