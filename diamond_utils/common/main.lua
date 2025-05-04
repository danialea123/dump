---@diagnostic disable: undefined-field, missing-parameter, undefined-global, lowercase-global
SUN = {
	World = 0
}
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

	while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
    Rich()
end)

Citizen.CreateThreadNow(function()
    while true do
		SUN.PlayerPedId = PlayerPedId()
		SUN.PlayerId = PlayerId()
		SUN.PlayerCoords = GetEntityCoords(SUN.PlayerPedId)
		SUN.VehiclePlayerIsIn = GetVehiclePedIsIn(SUN.PlayerPedId, false)
		SUN.PlayerIsDriver = GetPedInVehicleSeat(SUN.VehiclePlayerIsIn, -1) == SUN.PlayerPedId
		SUN.IsPlayerShooting = IsPedShooting(SUN.PlayerPedId)
		SUN.CurrentWeaponModel = GetSelectedPedWeapon(SUN.PlayerPedId)
		if IsUsingKeyboard() == false then
			--if not SUN.SendAssAlarm then
			--	SUN.SendAssAlarm = true
				--TriggerServerEvent("sc:adminalarm",'Using aim assist')
			--end
			SetCurrentPedWeapon(PlayerPedId(), -1569615261, true)
		end
		Citizen.Wait(100)
    end
end)

local lastVehicle = nil
local isDriver = false

function disableFiring()
	DisablePlayerFiring(SUN.PlayerId,true)
	DisableControlAction(0,24,true) -- disable attack
	DisableControlAction(0,47,true) -- disable weapon
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
end

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/autolock', 'Jahat on/off kardan halat auto lock', {
    })
	while true do
		Citizen.Wait(500)
		local vehicle = SUN.VehiclePlayerIsIn
		if DoesEntityExist(vehicle) then
			if lastVehicle ~= vehicle then 
				lastVehicle = vehicle
				TriggerEvent('enterVehicle', SUN.VehiclePlayerIsIn, SUN.PlayerIsDriver)
				if SUN.PlayerIsDriver then
					isDriver = true
				end
			else
				if not isDriver and SUN.PlayerIsDriver then
					isDriver = true
					TriggerEvent('enterVehicle', SUN.VehiclePlayerIsIn, true)
				elseif isDriver and not SUN.PlayerIsDriver then
					TriggerEvent('exitVehicle', SUN.VehiclePlayerIsIn, true)
					isDriver = false
				end
			end
		else
			if lastVehicle then
				TriggerEvent('exitVehicle', lastVehicle,isDriver)
				if isDriver then
					isDriver = false
				end
				lastVehicle = nil
			end
		end
	end
end)

local wThread = false
--[[AddEventHandler('enterVehicle',function(vehicle,iD)
	if iD and GetResourceKvpInt("disableAutoLock") == 0 then
		wThread = true
		local gerefte = 0
		while wThread do
			Citizen.Wait(1000)
			local lock = GetVehicleDoorsLockedForPlayer(vehicle)
			if not lock then
				if IsControlPressed(0,32) then
					gerefte = gerefte + 1
				end
				if gerefte >= 3 then
					gerefte = 0
					ManageLock(ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
					Citizen.Wait(3000)
					local lock = GetVehicleDoorsLockedForPlayer(vehicle)
					if not lock then
						break
					else
						Citizen.Wait(2000)
					end
				end
			end
		end
	end
end)]]

function ManageLock(plate)
    ESX.TriggerServerCallback('esx_advancedgarage:DoesHaveKey', function(newaccess)
		if newaccess then
            TriggerEvent("InteractSound_CL:PlayOnOne", "lock", 0.5)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            SetVehicleDoorShut(vehicle, 0, false)
            SetVehicleDoorShut(vehicle, 1, false)
            SetVehicleDoorShut(vehicle, 2, false)
            SetVehicleDoorShut(vehicle, 3, false)
            --SetVehicleDoorsLockedForAllPlayers(vehicle, true)
            PlayVehicleDoorCloseSound(vehicle, 1)
            ESX.Alert("[Auto Lock] Mashin Shoma Besoorat Khodkar Ghofl Shod", "info")
        end
    end, plate)
end

AddEventHandler('exitVehicle',function(vehicle,iD)
	wThread = false
end)

RegisterCommand('autolock',function()
    if GetResourceKvpInt("disableAutoLock") == 0 then
        SetResourceKvpInt("disableAutoLock",1)
        ESX.Alert('Halat auto lock off shod', "check")
    else
        SetResourceKvpInt("disableAutoLock",0)
        ESX.Alert('Halat auto lock on shod', "check")
    end
end)

local inVeh = false
local vehicle = 0
local whitelist = {
    [`19raptor`] = true,
    [`n17`] = true,
    [`TRX`] = true,
    [`dubsta3`] = true,
    [`Yosemite3`] = true,
    [`blazer`] = true,
    [`sanchez`] = true,
    [`sanchez2`] = true,
    [`manchez`] = true,
    [`bf400`] = true,
    [`bifta`] = true,
    [`brawler`] = true,
    [`caracara2`] = true,
    [`guardian`] = true,
    [`trophytruck2`] = true,
    [`trophytruck`] = true,
    [`sandking`] = true,
    [`riata`] = true,
    [`rebel2`] = true,
    [`bfinjection`] = true,
    [`kamacho`] = true,
    [`mesa3`] = true,
    [`contender`] = true,
    [`so`] = true,
    [`pmso`] = true,
    [`polkch`] = true,
    [`shacara`] = true,
    [`Marauder`] = true,
    [`bodhi2`] = true,
    [`sunsetoffpride`] = true,
    [`enduro`] = true,
    [`faction3`] = true,
    [`monster`] = true,
    [`Outlaw`] = true,
    [`Everon`] = true,
    --- ? cars
    [`raid`] = true,
-- cargo
    [`youga`] = true,
-- job center
    [`phantom`] = true,
    [`rubble`] = true,
    [`benson`] = true,
    [`youga2`] = true, 
-- job dolati
    [`riot`] = true,
    [`riot2`] = true,
    [`1200RT`] = true,
    [`Africat`] = true,
    [`insurgent2`] = true,
    [`policeb1`] = true,
    [`sunsetpm`] = true,
    [`POLDUBS`] = true,
    [`sunsetut`] = true,
    ----
    [`vigilante`] = true,
    [`monster`] = true,
    [`oppressor`] = true,
    --- zir daryai ?!
    [`Avisa`] = true,
    [`Submersible`] = true,
    [`Submersible2`] = true,

}

local semiOffroad = {
-- suv
    [`fq2`] = 60,
    [`granger`] = 60,
    [`gresley`] = 60,
    [`huntley`] = 60,
    [`landstalker`] = 60,
    [`mesa`] = 60,
    [`patriot`] = 60,
    [`baller2`] = 60,
    [`baller3`] = 60,
    [`cavalcade2`] = 60,
    [`dubsta`] = 60,
    [`dubsta2`] = 60,
    [`radi`] = 60,
    [`rocoto`] = 60,
    [`seminole`] = 60,
    [`xls`] = 60,
    [`rr5`] = 60,
-- other
    [`ruffian`] = 60,
    [`vader`] = 60,
    [`nemesis`] = 60,
    [`pcj`] = 60,
    [`urus`] = 60,
    [`g65`] = 60,
    [`lex`] = 60,
    [`bmwg07`] = 60,
    [`bison`] = 60,
    [`bobcatxl`] = 60,
    [`maz`] = 60,
    [`rmodx6`] = 60,
    [`rsq8m`] = 60,
    [`sclkuz`] = 60,
    [`Hellion`] = 60,
    [`novak`] = 60,
    [`toros`] = 60,
    [`Vagrant`] = 60,
    [`rrst`] = 60,
-- job dolati
    [`mdoff2`] = 60,
    [`POLREB`] = 60,
    [`POLROS`] = 60,
    [`taxio`] = 60,
    [`stelvio`] = 60,
    [`transmbv`] = 60,
}

AddEventHandler('exitVehicle',function()
    inVeh = false
end)

--[[AddEventHandler('enterVehicle',function(_,isDriver)
    vehicle = _
    if isDriver then
        if not inVeh then
            inVeh = true
            Citizen.CreateThread(function()
                local speed = 100
                local changed = false
                local timer = 0
                local baseSpeed = 0
                local neg = 0
                local maxSpeed__ = getMaxSpeedInOffroad(GetEntityModel(vehicle))
                while inVeh do
                    Citizen.Wait(1000)
                    local materialId = GetVehicleWheelSurfaceMaterial(vehicle, 1)
                    if materialId == 4 or materialId == 1 or materialId == 3 then
                        timer = 0
                        SUN.InStreet = true
                        if changed then
                            changed = false
                            neg = 0
                            baseSpeed = 0
                            maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                            SetEntityMaxSpeed(vehicle,maxSpeed)
                        end
                    else
                        SUN.InStreet = false
                        if (not IsPedInAnyBoat(SUN.PlayerPedId) and not IsPedInAnyPlane(SUN.PlayerPedId) and not IsPedInAnyHeli(SUN.PlayerPedId)) and not whitelist[GetEntityModel(vehicle)] then
                            if GetEntitySpeed(vehicle) * 3.6 >= 10 then
                                if timer >= 2 then
                                    changed = true
                                    if baseSpeed == 0 then
                                        baseSpeed = GetEntitySpeed(vehicle) * 3.6
                                        neg = (baseSpeed / 10)
                                    end
                                    if baseSpeed > maxSpeed__ then
                                        baseSpeed = baseSpeed - neg
                                        if baseSpeed < maxSpeed__ then
                                            baseSpeed = maxSpeed__
                                        end
                                    else
                                        baseSpeed = maxSpeed__
                                    end
                                    SetEntityMaxSpeed(vehicle,baseSpeed / 3.6)
                                else
                                    timer = timer + 1
                                end
                            end
                        end
                    end
                    
                end
            end)
        end
    end
end)]]

function getMaxSpeedInOffroad(hash)
    return whitelist[hash] and 1000 or semiOffroad[hash] or 30
end

exports('getMaxSpeedInOffroad',getMaxSpeedInOffroad)

local type = nil
local _menu = {
    {label = 'Reset',  value = 'reset'},
    {label = 'Ultra Low',    value = 'ulow'},
    {label = 'Low',    value = 'low'},
    {label = 'Medium', value = 'medium'},
}

RegisterCommand("fps", function()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fps', {
		title    = 'FPS Menu',
		align    = 'center',
		elements = _menu
	}, function(data, menu)
        local v = data.current.value
		if v == "reset" then
            RopeDrawShadowEnabled(true)
            CascadeShadowsSetAircraftMode(true)
            CascadeShadowsEnableEntityTracker(false)
            CascadeShadowsSetDynamicDepthMode(true)
            CascadeShadowsSetEntityTrackerScale(5.0)
            CascadeShadowsSetDynamicDepthValue(5.0)
            CascadeShadowsSetCascadeBoundsScale(5.0)
            SetFlashLightFadeDistance(10.0)
            SetLightsCutoffDistanceTweak(10.0)
            --DistantCopCarSirens(true)
            SetArtificialLightsState(false)
			SetTimecycleModifier()
			ClearTimecycleModifier()
			ClearExtraTimecycleModifier()
        elseif v == "ulow" then
			SetTimecycleModifier('yell_tunnel_nodirect')
            RopeDrawShadowEnabled(false)
            CascadeShadowsClearShadowSampleType()
            CascadeShadowsSetAircraftMode(false)
            CascadeShadowsEnableEntityTracker(true)
            CascadeShadowsSetDynamicDepthMode(false)
            CascadeShadowsSetEntityTrackerScale(0.0)
            CascadeShadowsSetDynamicDepthValue(0.0)
            CascadeShadowsSetCascadeBoundsScale(0.0)
            SetFlashLightFadeDistance(0.0)
            SetLightsCutoffDistanceTweak(0.0)
            --DistantCopCarSirens(false)
        elseif v == "low" then
			SetTimecycleModifier('yell_tunnel_nodirect')
            RopeDrawShadowEnabled(false)
            CascadeShadowsClearShadowSampleType()
            CascadeShadowsSetAircraftMode(false)
            CascadeShadowsEnableEntityTracker(true)
            CascadeShadowsSetDynamicDepthMode(false)
            CascadeShadowsSetEntityTrackerScale(0.0)
            CascadeShadowsSetDynamicDepthValue(0.0)
            CascadeShadowsSetCascadeBoundsScale(0.0)
            SetFlashLightFadeDistance(5.0)
            SetLightsCutoffDistanceTweak(5.0)
            DistantCopCarSirens(false)
        elseif v == "medium" then
			SetTimecycleModifier('yell_tunnel_nodirect')
            RopeDrawShadowEnabled(true)
            CascadeShadowsClearShadowSampleType()
            CascadeShadowsSetAircraftMode(false)
            CascadeShadowsEnableEntityTracker(true)
            CascadeShadowsSetDynamicDepthMode(false)
            CascadeShadowsSetEntityTrackerScale(5.0)
            CascadeShadowsSetDynamicDepthValue(3.0)
            CascadeShadowsSetCascadeBoundsScale(3.0)
            SetFlashLightFadeDistance(3.0)
            SetLightsCutoffDistanceTweak(3.0)
            --DistantCopCarSirens(false)
            SetArtificialLightsState(false)
		end
        type = v
	end, function(data, menu)
		menu.close()
	end)
end)

function threadFPS()
    Citizen.CreateThread(function()
        while type and type ~= 'reset' do
            if type == "ulow" then
                --// Find closest ped and set the alpha
                DisableOcclusionThisFrame()
                SetDisableDecalRenderingThisFrame()
                RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
                OverrideLodscaleThisFrame(0.4)
                SetArtificialLightsState(true)
            elseif type == "low" then
                --// Find closest ped and set the alpha
                SetDisableDecalRenderingThisFrame()
                RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
                OverrideLodscaleThisFrame(0.6)
                SetArtificialLightsState(true)
            elseif type == "medium" then
                --// Find closest ped and set the alpha
                OverrideLodscaleThisFrame(0.8)
            else
                Citizen.Wait(500)
            end
            Citizen.Wait(0)
        end
    end)
    
    --// Clear broken thing, disable rain, disable wind and other tiny thing that dont require the frame tick
    Citizen.CreateThread(function()
        while type and type ~= 'reset' do
            if type == "ulow" or type == "low" then
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
                ClearHdArea()
                ClearPedBloodDamage(PlayerPedId())
                ClearPedWetness(PlayerPedId())
                ClearPedEnvDirt(PlayerPedId())
                ResetPedVisibleDamage(PlayerPedId())
                ClearExtraTimecycleModifier()
                ClearTimecycleModifier()
                ClearOverrideWeather()
                ClearHdArea()
                DisableVehicleDistantlights(false)
                DisableScreenblurFade()
                SetRainLevel(0.0)
                SetWindSpeed(0.0)
                Citizen.Wait(300)
            elseif type == "medium" then
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
                ClearHdArea()
                SetWindSpeed(0.0)
                Citizen.Wait(1000)
            else
                Citizen.Wait(1500)
            end
        end
    end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

allPlayers = 0

function Rich()
    local name
    local ass
	local lastFrame = GetFrameCount()
    Citizen.Wait(1000)
    if ESX.GetPlayerData()['aduty'] then
        name = 'Staff'
        ass = "admin"
    else
        if PlayerData.job ~= nil then
            if PlayerData.job.name  == "police" then
                name = "Police"
                ass = "lspd"
            elseif PlayerData.job.name  == "taxi" then
                name = "TAXI"
                ass = "taxi"
            elseif PlayerData.job.name  == "ambulance" then
                name = "EMS"
                ass = "ems"
            elseif PlayerData.job.name == "mechanic" then
                name = "MECHANIC"
                ass = "mechanic"
            end
        end
    end
	SetDiscordAppId('1078018641200685158')
	SetDiscordRichPresenceAsset('big')
    SetDiscordRichPresenceAssetText('https://diamondrp.ir')
	SetDiscordRichPresenceAction(0, "Play", "fivem://connect/extra.diamondrp.ir")
	SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/ASNjvt6372")
    SetDiscordRichPresenceAssetSmall(ass)
    SetDiscordRichPresenceAssetSmallText(name)
	SetRichPresence("FPS: "..(GetFrameCount() - lastFrame).." | ID: " .. GetPlayerServerId(PlayerId()) .. " | Players: " .. allPlayers)
    SetTimeout(40000,Rich)
end

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	SetDiscordAppId('1078018641200685158')
	SetDiscordRichPresenceAsset('big')
    SetDiscordRichPresenceAssetText('https://diamondrp.ir')
	SetDiscordRichPresenceAction(0, "Play", "fivem://connect/extra.diamondrp.ir")
	SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/ASNjvt6372")
	SetRichPresence('(Loading)')
end)

RegisterNetEvent('iejgpwrgrwpj')
AddEventHandler('iejgpwrgrwpj',function(players)
	allPlayers = players
end)

function GetActivePlayers()
	return allPlayers
end

exports("GetActivePlayers", GetActivePlayers)

Citizen.CreateThread(function()
	Citizen.Wait(15000)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BZGAS"), 0.1)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SMOKEGRENADE"), 0.5)
	N_0x4757f00bc6323cfe(3204302209, 0)
	N_0x4757f00bc6323cfe(375527679, 0)
	N_0x4757f00bc6323cfe(324506233, 0)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.15)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"), 0.001)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"), 0.001)
	N_0x4757f00bc6323cfe(-1553120962, 0.0) 
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MUSKET"), 0.2)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PUMPSHOTGUN"), 0.4)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PUMPSHOTGUN_MK2"), 0.4)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTSHOTGUN"), 0.25)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BULLPUPSHOTGUN"), 0.7)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SAWNOFFSHOTGUN"), 0.2)
	N_0x4757f00bc6323cfe(GetHashKey("weapon_doubleaction"), 0.70)
	N_0x4757f00bc6323cfe(`weapon_flashlight`, 0.15)
	N_0x4757f00bc6323cfe(`weapon_poolcue`, 0.20)
	N_0x4757f00bc6323cfe(`weapon_knuckle`, 0.68)
	N_0x4757f00bc6323cfe(`weapon_revolver`, 0.35)
	N_0x4757f00bc6323cfe(`weapon_snowball`, 0)
	N_0x4757f00bc6323cfe(`WEAPON_pistolgold`, 0.88)
	N_0x4757f00bc6323cfe(`WEAPON_ADVANCEDRIFLE`, 0.94)
	N_0x4757f00bc6323cfe(`WEAPON_PISTOL_MK2`, 0.81)
	N_0x4757f00bc6323cfe(`WEAPON_DiamondChrome`, 1.06)
	N_0x4757f00bc6323cfe(`WEAPON_ASSAULTSMG`, 0.95)
	N_0x4757f00bc6323cfe(`WEAPON_MINISMG`, 0.9)
	N_0x4757f00bc6323cfe(`WEAPON_SPECIALCARBINE`, 0.93)
	N_0x4757f00bc6323cfe(`WEAPON_HEAVYPISTOL`, 0.8)
	N_0x4757f00bc6323cfe(`WEAPON_CARBINERIFLE`, 0.96)
	N_0x4757f00bc6323cfe(`WEAPON_AKVALO1`, 1.1)
	N_0x4757f00bc6323cfe(`WEAPON_ASSAULTRIFLE`, 1.06)
	N_0x4757f00bc6323cfe(`WEAPON_SMG`, 0.9)
	N_0x4757f00bc6323cfe(`WEAPON_SNSPISTOL_MK2`, 0.9)
	N_0x4757f00bc6323cfe(`WEAPON_BULLPUPRIFLE`, 0.96)
	N_0x4757f00bc6323cfe(`WEAPON_MILITARYRIFLE`, 0.93)
	N_0x4757f00bc6323cfe(`WEAPON_AKDIAMOND`, 1.06)
	N_0x4757f00bc6323cfe(`WEAPON_SNSPISTOL`, 0.85)
	N_0x4757f00bc6323cfe(`WEAPON_MACHINEPISTOL`, 0.74)
	N_0x4757f00bc6323cfe(`WEAPON_ASSAULTRIFLE_MK2`, 0.9)
	N_0x4757f00bc6323cfe(`WEAPON_PISTOL50`, 0.98)
	N_0x4757f00bc6323cfe(`WEAPON_rhrif`, 1.125)
	N_0x4757f00bc6323cfe(`WEAPON_APPISTOL`, 0.8)
	N_0x4757f00bc6323cfe(`WEAPON_HKG`, 1.156)
	N_0x4757f00bc6323cfe(`WEAPON_pistolluxe`, 1.69)
	N_0x4757f00bc6323cfe(`WEAPON_COMBATPISTOL`, 1.1)
	N_0x4757f00bc6323cfe(`WEAPON_COMPACTRIFLE`, 0.94)
	N_0x4757f00bc6323cfe(`WEAPON_SPECIALCARBINE_MK2`, 1.01)
	N_0x4757f00bc6323cfe(`WEAPON_MICROSMG`, 0.95)
	N_0x4757f00bc6323cfe(`WEAPON_VINTAGEPISTOL`, 0.7)
	N_0x4757f00bc6323cfe(`WEAPON_TACTICALRIFLE`, 0.92)
	N_0x4757f00bc6323cfe(`WEAPON_MG`, 0.75)
	N_0x4757f00bc6323cfe(`WEAPON_COMBATMG_MK2`, 0.72)
	N_0x4757f00bc6323cfe(`WEAPON_COMBATMG`, 0.66)
end)

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(7000)
    SetRadarBigmapEnabled(false, false)
    for i = 0, 100 do
        Wait(1)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

local holdingRight = false
AddEventHandler("onKeyDown", function(key)
	if key == "mouse_right" then
		holdingRight = true
	elseif key == "mouse_left" or key == "r" then
		if not holdingRight then
			DisableControlAction(2, 263, true) -- R attack
			DisableControlAction(2, 257, true) -- Left click mouse attack
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
		end
	end
end)

AddEventHandler("onKeyUP", function(key)
	if key == "mouse_right" then
		holdingRight = false
	end
end)

Citizen.CreateThread(function()
	meleeBlip = AddBlipForRadius(-34.99, -804.57, 27.8, 660.0)
	SetBlipHighDetail(meleeBlip, true)
	SetBlipColour(meleeBlip, 11)
	SetBlipAlpha(meleeBlip, 150)
	SetBlipAsShortRange(meleeBlip, true)
end)

--[[Citizen.CreateThread(function()
	meleeBlips = AddBlipForRadius(-283.5,-1786.0,3.44, 2900.0)
	SetBlipHighDetail(meleeBlips, true)
	SetBlipColour(meleeBlips, 11)
	SetBlipAlpha(meleeBlips, 150)
	SetBlipAsShortRange(meleeBlips, true)
end)]]

AddEventHandler("rebuildBlip", function()
	SetBlipAlpha(meleeBlip, 150)
end)

local crouched = false
local lastPress = 0
local isPressing = false

AddEventHandler("onKeyDown", function(key)
	if key == "lcontrol" and ESX.GetPlayerData()['IsDead'] ~= 1 then
        DisableControlAction(0,36,true)
        isPressing = true
        disableAction()

		local ped = PlayerPedId()
		if IsPedOnFoot(ped) and not IsPedJumping(ped) and not IsPedFalling(ped) and ESX.GetPlayerData()['IsDead'] ~= 1 then

            
            RequestAnimSet( "move_ped_crouched" )

            while not HasAnimSetLoaded("move_ped_crouched") do 
                Citizen.Wait(100)
            end 

            if crouched then 
                crouched = false 
                ResetPedMovementClipset(ped, 0)
            elseif crouched == false then
                crouched = true 
                SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
            end

		end
    end
end)

AddEventHandler("onKeyUP", function(key)
    if key == "lcontrol" and isPressing then
        isPressing = false
	end
end)

function disableAction()
    Citizen.CreateThread(function()
        while isPressing do
            Citizen.Wait(5)
            DisableControlAction(0,36,true)
        end
    end)
end

AddEventHandler('enterVehicle',function(veh,isDriver)
	if isDriver then
		SetPlayerCanDoDriveBy(PlayerId(), false)
	end
end)

AddEventHandler('exitVehicle',function(veh,isDriver)
	SetPlayerCanDoDriveBy(PlayerId(), true)
end)

--no r key
local isAiming = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5) -- A Short Daily of 5 MS
		if isAiming then
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
		else
			Citizen.Wait(500)
		end
	end
end)

function checkArmed()
	isAiming = IsPedArmed(PlayerPedId(), 4)
	SetTimeout(500, checkArmed)
end

checkArmed()

local PERPGamer_HoverOn = false

RegisterCommand('hover', function()
  local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped,true)
	if GetVehicleClass(vehicle) == 15 then
		PERPGamer_HoverOn = not PERPGamer_HoverOn
		if PERPGamer_HoverOn then
			Citizen.CreateThread(function()
				ESX.Alert("Hover Fa`al Shod", "check")
				while GetVehiclePedIsIn(ped) == vehicle and PERPGamer_HoverOn and GetHeliMainRotorHealth(vehicle) > 0 and GetHeliTailRotorHealth(vehicle) > 0 and GetVehicleEngineHealth(vehicle) > 300 do Citizen.Wait(0)
					local currentvelocity = GetEntityVelocity(vehicle)
					SetEntityVelocity(vehicle, currentvelocity.x, currentvelocity.y, 0.0)
				end
				ESX.Alert("Hover Gheyr Fa`al Shod", "info")
				PERPGamer_HoverOn = false
			end)
		else
			ESX.Alert("Hover Gheyr Fa`al Shod", "info")
		end
	end
end)


local pickupList = {
	"PICKUP_AMMO_BULLET_MP",
	"PICKUP_AMMO_FIREWORK",
	"PICKUP_AMMO_FLAREGUN",
	"PICKUP_AMMO_GRENADELAUNCHER",
	"PICKUP_AMMO_GRENADELAUNCHER_MP",
	"PICKUP_AMMO_HOMINGLAUNCHER",
	"PICKUP_AMMO_MG",
	"PICKUP_AMMO_MINIGUN",
	"PICKUP_AMMO_MISSILE_MP",
	"PICKUP_AMMO_PISTOL",
	"PICKUP_AMMO_RIFLE",
	"PICKUP_AMMO_RPG",
	"PICKUP_AMMO_SHOTGUN",
	"PICKUP_AMMO_SMG",
	"PICKUP_AMMO_SNIPER",
	"PICKUP_ARMOUR_STANDARD",
	"PICKUP_CAMERA",
	"PICKUP_CUSTOM_SCRIPT",
	"PICKUP_GANG_ATTACK_MONEY",
	"PICKUP_HEALTH_SNACK",
	"PICKUP_HEALTH_STANDARD",
	"PICKUP_MONEY_CASE",
	"PICKUP_MONEY_DEP_BAG",
	"PICKUP_MONEY_MED_BAG",
	"PICKUP_MONEY_PAPER_BAG",
	"PICKUP_MONEY_PURSE",
	"PICKUP_MONEY_SECURITY_CASE",
	"PICKUP_MONEY_VARIABLE",
	"PICKUP_MONEY_WALLET",
	"PICKUP_PARACHUTE",
	"PICKUP_PORTABLE_CRATE_FIXED_INCAR",
	"PICKUP_PORTABLE_CRATE_UNFIXED",
	"PICKUP_PORTABLE_CRATE_UNFIXED_INCAR",
	"PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL",
	"PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW",
	"PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE",
	"PICKUP_PORTABLE_PACKAGE",
	"PICKUP_SUBMARINE",
	"PICKUP_VEHICLE_ARMOUR_STANDARD",
	"PICKUP_VEHICLE_CUSTOM_SCRIPT",
	"PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW",
	"PICKUP_VEHICLE_HEALTH_STANDARD",
	"PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW",
	"PICKUP_VEHICLE_MONEY_VARIABLE",
	"PICKUP_VEHICLE_WEAPON_APPISTOL",
	"PICKUP_VEHICLE_WEAPON_ASSAULTSMG",
	"PICKUP_VEHICLE_WEAPON_COMBATPISTOL",
	"PICKUP_VEHICLE_WEAPON_GRENADE",
	"PICKUP_VEHICLE_WEAPON_MICROSMG",
	"PICKUP_VEHICLE_WEAPON_MOLOTOV",
	"PICKUP_VEHICLE_WEAPON_PISTOL",
	"PICKUP_VEHICLE_WEAPON_PISTOL50",
	"PICKUP_VEHICLE_WEAPON_SAWNOFF",
	"PICKUP_VEHICLE_WEAPON_SMG",
	"PICKUP_VEHICLE_WEAPON_SMOKEGRENADE",
	"PICKUP_VEHICLE_WEAPON_STICKYBOMB",
	"PICKUP_WEAPON_ADVANCEDRIFLE",
	"PICKUP_WEAPON_APPISTOL",
	"PICKUP_WEAPON_ASSAULTRIFLE",
	"PICKUP_WEAPON_ASSAULTSHOTGUN",
	"PICKUP_WEAPON_ASSAULTSMG",
	"PICKUP_WEAPON_AUTOSHOTGUN",
	"PICKUP_WEAPON_BAT",
	"PICKUP_WEAPON_BATTLEAXE",
	"PICKUP_WEAPON_BOTTLE",
	"PICKUP_WEAPON_BULLPUPRIFLE",
	"PICKUP_WEAPON_BULLPUPSHOTGUN",
	"PICKUP_WEAPON_CARBINERIFLE",
	"PICKUP_WEAPON_COMBATMG",
	"PICKUP_WEAPON_COMBATPDW",
	"PICKUP_WEAPON_COMBATPISTOL",
	"PICKUP_WEAPON_COMPACTLAUNCHER",
	"PICKUP_WEAPON_COMPACTRIFLE",
	"PICKUP_WEAPON_CROWBAR",
	"PICKUP_WEAPON_DAGGER",
	"PICKUP_WEAPON_DBSHOTGUN",
	"PICKUP_WEAPON_FIREWORK",
	"PICKUP_WEAPON_FLAREGUN",
	"PICKUP_WEAPON_FLASHLIGHT",
	"PICKUP_WEAPON_GRENADE",
	"PICKUP_WEAPON_GRENADELAUNCHER",
	"PICKUP_WEAPON_GUSENBERG",
	"PICKUP_WEAPON_GOLFCLUB",
	"PICKUP_WEAPON_HAMMER",
	"PICKUP_WEAPON_HATCHET",
	"PICKUP_WEAPON_HEAVYPISTOL",
	"PICKUP_WEAPON_HEAVYSHOTGUN",
	"PICKUP_WEAPON_HEAVYSNIPER",
	"PICKUP_WEAPON_HOMINGLAUNCHER",
	"PICKUP_WEAPON_KNIFE",
	"PICKUP_WEAPON_KNUCKLE",
	"PICKUP_WEAPON_MACHETE",
	"PICKUP_WEAPON_MACHINEPISTOL",
	"PICKUP_WEAPON_MARKSMANPISTOL",
	"PICKUP_WEAPON_MARKSMANRIFLE",
	"PICKUP_WEAPON_MG",
	"PICKUP_WEAPON_MICROSMG",
	"PICKUP_WEAPON_MINIGUN",
	"PICKUP_WEAPON_MINISMG",
	"PICKUP_WEAPON_MOLOTOV",
	"PICKUP_WEAPON_MUSKET",
	"PICKUP_WEAPON_NIGHTSTICK",
	"PICKUP_WEAPON_PETROLCAN",
	"PICKUP_WEAPON_PIPEBOMB",
	"PICKUP_WEAPON_PISTOL",
	"PICKUP_WEAPON_PISTOL50",
	"PICKUP_WEAPON_POOLCUE",
	"PICKUP_WEAPON_PROXMINE",
	"PICKUP_WEAPON_PUMPSHOTGUN",
	"PICKUP_WEAPON_RAILGUN",
	"PICKUP_WEAPON_REVOLVER",
	"PICKUP_WEAPON_RPG",
	"PICKUP_WEAPON_SAWNOFFSHOTGUN",
	"PICKUP_WEAPON_SMG",
	"PICKUP_WEAPON_SMOKEGRENADE",
	"PICKUP_WEAPON_SNIPERRIFLE",
	"PICKUP_WEAPON_SNSPISTOL",
	"PICKUP_WEAPON_SPECIALCARBINE",
	"PICKUP_WEAPON_STICKYBOMB",
	"PICKUP_WEAPON_STUNGUN",
	"PICKUP_WEAPON_SWITCHBLADE",
	"PICKUP_WEAPON_VINTAGEPISTOL",
	"PICKUP_WEAPON_WRENCH",
	"PICKUP_WEAPON_RAYCARBINE",
	"PICKUP_AMMO_FIREWORK_MP"
}

function RemoveWeaponDrops()
    local player = PlayerId()
	for _, pickup in pairs(pickupList) do
		N_0x616093ec6b139dd9(player, GetHashKey(pickup), false)
	end
end

Citizen.CreateThread(function()     
    RemoveWeaponDrops()
end)
--
local citydisable = false
local hasLicense = false

--[[Citizen.CreateThread(function()
	local whiteCoords = {
        vector4(1159.35,-319.83,69.95 , 30), --shop kenare casino
        vector4(1137.07,-981.79,46.41 , 20), --shop kenare mechanici
        vector4(-712.0,-917.96,19.21 , 25), --shope kenare weazel
        vector4(-53.3,-1757.12,29.44 , 25), -- shope grove
        vector4(32.25,-1349.79,29.33 , 25), -- shop 1
        vector4(198.26,173.83,105.36 , 180), -- bank markazi
        vector4(314.25,-279.1,54.17 , 20), -- mini 1
        vector4(-351.78,-51.8,49.04 , 20), -- mini 2
--        vector4(-1212.06,-332.68,37.78 , 15), -- mini 3
        vector4(-634.47,-239.71,38.05 , 25), -- javaheri
        vector4(-1090.48,-267.73,37.74 , 200), -- bime
        vector4(-1316.13,-843.33,16.8,100), -- maze
        vector4(-1485.2,-375.23,40.16 , 18), -- shop kenare bime
        vector4(378.08,329.81,103.57,15), -- shop bank markazi
        vector4(-1219.58,-909.94,12.33,15), -- mini shop 1
    }
	local wait = 2000
	local radius = 2200
	local whiteJob = {
		['police'] = true,
		['sheriff'] = true,
		['fbi'] = true,
	}
	local unarmed = `weapon_unarmed`
	local taze = `weapon_stungun`
	while true do         
		local distance = ESX.GetDistance(SUN.PlayerCoords,vector3(-206.87,-1248.82,37.18))
		if distance < radius and SUN.World == 0 then
			local notwhite = true
			local hassilencer = false
			if not whiteJob[ESX.PlayerData.job.name] then
				for k , v in pairs(whiteCoords) do
					local dist = ESX.GetDistance(SUN.PlayerCoords,v.xyz)
					if dist <= v.w then
						notwhite = false
					end
					local weapon = GetSelectedPedWeapon(PlayerPedId())
					local comp = ESX.GetWeaponComponent(ESX.GetWeaponName(weapon),'suppressor')
					if comp then
						if HasPedGotWeaponComponent(PlayerPedId(),weapon,comp.hash) then
							hassilencer = true
						end
					end					
					if notwhite and not (hasLicense and (IsPedInAnyVehicle(PlayerPedId()) or hassilencer)) then
						if not citydisable then
							citydisable = true
							Citizen.CreateThread(function()
								while citydisable and SUN.World == 0 do
									Citizen.Wait(0)
									if GetSelectedPedWeapon(PlayerPedId()) ~= unarmed then
										disableFiring()
									end
								end
								citydisable = false
							end)
						end
					else
						citydisable = false
					end
				end
			else
				citydisable = false
			end
		else
			citydisable = false
		end
		Citizen.Wait(wait)
	end
end)

AddEventHandler('onKeyDown',function(key)
    if key == "mouse_left" then
        if (citydisable or gangKey) and GetSelectedPedWeapon(PlayerPedId()) ~= `weapon_unarmed` then
            ESX.Alert('تیر اندازی در این منطقه ممنوع است', 'info')
        end
    end
end)]]

-- Disable stealth kills
RemoveStealthKill(`ACT_stealth_kill_a`)
RemoveStealthKill(`ACT_stealth_kill_b`)
RemoveStealthKill(`ACT_stealth_kill_c`)
RemoveStealthKill(`ACT_stealth_kill_d`)
RemoveStealthKill(`ACT_stealth_kill_a_gardener`)
RemoveStealthKill(`ACT_stealth_kill_weapon`)

local combatTime = 0
AddEventHandler('gameEventTriggered', function (name, data)
	if name == 'CEventNetworkEntityDamage' then
		local hash = data[7]
		local victim = data[1]
		local attacker = data[2]
		--[[if hash == -1569615261 and data[1] == PlayerPedId() then
			local hp = GetEntityHealth(PlayerPedId())
			if hp < 130 then
				SetPedToRagdoll(PlayerPedId(), 10000, 10000, 0, 0, 0, 0)
				ESX.SetEntityHealth(PlayerPedId(),120)
			else
				ESX.SetEntityHealth(PlayerPedId(),hp - 15)
			end
		end
		if (hash == `WEAPON_NIGHTSTICK` or hash == `WEAPON_BAT`) and data[1] == PlayerPedId() then
			local hp = GetEntityHealth(PlayerPedId())
			if hp < 125 then
				SetPedToRagdoll(PlayerPedId(), 10000, 10000, 0, 0, 0, 0)
				ESX.SetEntityHealth(PlayerPedId(),115)
			else
				ESX.SetEntityHealth(PlayerPedId(),hp - 20)
			end
		end]]
		if hash == -1553120962 then
			if attacker == PlayerPedId() and GetEntityType(attacker) == 1 and GetEntityType(victim) == 1 then
				local vehicle = GetVehiclePedIsIn(attacker)
				local plate = GetVehicleNumberPlateText(vehicle)
				if plate then
					local coords = ESX.GetCoordsString()
					local attackerid = NetworkGetPlayerIndexFromPed(attacker)
					local serverid = GetPlayerServerId(attackerid)
					local victimid = NetworkGetPlayerIndexFromPed(victim)
					local vehname = 'Not found'
					if DoesEntityExist(vehicle) then 
						vehname = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
					end
					TriggerServerEvent('DiscordBot:ToDiscord','vdm','VDM','```css\nTarget : '.. GetPlayerServerId(victimid) .. ' Target name : '..  GetPlayerName(victimid) ..'\nAttacker : '.. serverid .. ' Attacker name : '.. GetPlayerName(attackerid) .. '\nPlate : '.. plate ..'\nVehicle name : '.. vehname ..'\n'..coords..'\n```')
				end
			end
		end
		if data[2] == PlayerPedId() and GetEntityType(data[1]) == 2 and GetVehiclePedIsIn(PlayerPedId()) ~= data[1] then
			local vehicle = data[1]
			local vehname = 'Not found'
			local plate = GetVehicleNumberPlateText(vehicle)
			if DoesEntityExist(vehicle) then 
				vehname = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
			end
			--TriggerServerEvent('DiscordBot:ToDiscord','tirelog','Panchar kard','```css\nID : '.. GetPlayerServerId(PlayerId()) .. ' Name : '..  GetPlayerName(PlayerId()) ..'\nPlate : '.. plate ..'\nVehicle name : '.. vehname ..'\nVehicle : '.. GetEntityCoords(vehicle) ..'\nPlayer : '.. GetEntityCoords(PlayerPedId()) ..'\nType : '.. data[13] ..' \n```')
		end
		
		if GetEntityType(attacker) == 1 then
			local weapon = ESX.GetWeaponName(GetSelectedPedWeapon(attacker))
			if weapon ~= 'weapon_unarmed' and weapon ~= 'no_name' then
				local coords = GetEntityCoords(PlayerPedId())
				local attackerCoords = GetEntityCoords(attacker)
				local victimCoords = GetEntityCoords(victim)
				if world == 0 and (ESX.GetDistance(coords,attackerCoords) < 80 or ESX.GetDistance(coords,victimCoords) < 80) then
					TriggerEvent('sscombat:toggle',true,3 * 60 * 1000)
					if combatTime == 0 then
						combatTime = 3 * 60
						Citizen.CreateThread(function()
							ESX.SetPlayerState('combat',true)					
							while combatTime > 0 do
								--exports['TextUI']:Open('Combat time<br>'.. combatTime .. 's', 'lightred', 'left')
								combatTime = combatTime - 1
								Citizen.Wait(1000)
							end
							--exports['TextUI']:Close()
							ESX.SetPlayerState('combat',false)
						end)
					else
						combatTime = 3 * 60
					end
				end
			end
		end
	elseif name == 'CEventNetworkPlayerEnteredVehicle' then
		Wait(500)
		if data[1] == PlayerId() then
			local vehicle = data[2]
			local plate = GetVehicleNumberPlateText(vehicle)
			if plate and GetPedInVehicleSeat(vehicle,-1) == PlayerPedId() then
				local coords = ESX.GetCoordsString()
				local vehname = 'Not found'
				if DoesEntityExist(vehicle) then 
					vehname = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
				end
				TriggerServerEvent('DiscordBot:ToDiscord','entervehicle','ENTER','```css\nID : '.. GetPlayerServerId(PlayerId()) .. ' name : '..  GetPlayerName(PlayerId()) ..'\nPlate : '.. plate ..'\nVehicle name : '.. vehname ..'\n'..coords..'\n```')
			end
		end
	end
end)

Citizen.CreateThread(function()
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
    for i = 1, 15 do
        EnableDispatchService(i, false)
    end
end)

local bigmap = false

AddEventHandler('onKeyDown',function(key)
	if key ~= "z" then return end
    if bigmap then
        bigmap = false
        TriggerEvent("pNotify:SendNotification", {text = "!نقشه کوچک فعال شد", type = "success", timeout = 1400, layout = "centerLeft"})
    else
        bigmap = true
        TriggerEvent("pNotify:SendNotification", {text = "!نقشه بزرگ فعال شد", type = "success", timeout = 1400, layout = "centerLeft"})
    end
    if bigmap then
        -- Citizen.CreateThread(function()
        --     while bigmap do
        --         Citizen.Wait(0)
                SetBigmapActive(true,false)
        --     end
        -- end)
    else
        SetBigmapActive(false,false)
    end
end)

--[[local meleeBlip = AddBlipForRadius(-206.87,-1248.82,37.18,1000.0)         --(-75.5, -818.68, 38.17, 1750.0)   
SetBlipHighDetail(meleeBlip, true)
SetBlipColour(meleeBlip, 11)
SetBlipAlpha(meleeBlip, 60)
SetBlipAsShortRange(meleeBlip, true)

local meleeBlip = AddBlipForRadius(3559.76,3674.53,28.12,150.0) --Lablatori Teryak
SetBlipHighDetail(meleeBlip, true)
SetBlipColour(meleeBlip, 11)
SetBlipAlpha(meleeBlip, 60)
SetBlipAsShortRange(meleeBlip, true)
local meleeBlip = AddBlipForRadius(1851.71,4914.63,45.08,60.0) --Zamin Cocain
SetBlipHighDetail(meleeBlip, true)
SetBlipColour(meleeBlip, 11)
SetBlipAlpha(meleeBlip, 60)
SetBlipAsShortRange(meleeBlip, true)			
local meleeBlip = AddBlipForRadius(2224.2,5566.53,54.03,80.0) --Zamin Shahdane
SetBlipHighDetail(meleeBlip, true)
SetBlipColour(meleeBlip, 11)
SetBlipAlpha(meleeBlip, 60)
SetBlipAsShortRange(meleeBlip, true)
local meleeBlip = AddBlipForRadius(2333.42,2578.74,46.44,60.0) --marijuana
SetBlipHighDetail(meleeBlip, true)
SetBlipColour(meleeBlip, 11)
SetBlipAlpha(meleeBlip, 60)
SetBlipAsShortRange(meleeBlip, true)
local meleeBlip = AddBlipForRadius(30.96,4348.25,41.51,50.0) --Zamin MashRome
SetBlipHighDetail(meleeBlip, true)
SetBlipColour(meleeBlip, 11)
SetBlipAlpha(meleeBlip, 60)
SetBlipAsShortRange(meleeBlip, true)
local meleeBlip = AddBlipForRadius(-1800.82,1990.44,125.46,40.0) --Zamin KhashKhash
SetBlipHighDetail(meleeBlip, true)
SetBlipColour(meleeBlip, 11)
SetBlipAlpha(meleeBlip, 60)
SetBlipAsShortRange(meleeBlip, true)
local meleeBlip = AddBlipForRadius(1391.23,3609.29,35.17,30.0) --Lablatori SHISHE
SetBlipHighDetail(meleeBlip, true)
SetBlipColour(meleeBlip, 11)
SetBlipAlpha(meleeBlip, 60)
SetBlipAsShortRange(meleeBlip, true)

-- dayere sabze haye birone shahre 1
local meleeBlip = AddBlipForRadius(905.17,2696.91,40.85, 365.0)     
SetBlipHighDetail(meleeBlip, true)
SetBlipColour(meleeBlip, 11)
SetBlipAlpha(meleeBlip, 60)
SetBlipAsShortRange(meleeBlip, true)
-- dayere sabze haye birone shahre 2
local meleeBlip = AddBlipForRadius(-108.61,6407.37,31.49, 700.0)
SetBlipHighDetail(meleeBlip, true)
SetBlipColour(meleeBlip, 11)
SetBlipAlpha(meleeBlip, 60)
SetBlipAsShortRange(meleeBlip, true)
-- dayere sabze haye birone shahre 3
local meleeBlip = AddBlipForRadius(1805.83,3747.41,33.56, 300.0)
SetBlipHighDetail(meleeBlip, true)
SetBlipColour(meleeBlip, 11)
SetBlipAlpha(meleeBlip, 60)
SetBlipAsShortRange(meleeBlip, true)]]

local spammer = false

AddEventHandler('onKeyUP',function(key)
	if key == 'r' then
		if GetAmmoInPedWeapon(PlayerPedId(),GetSelectedPedWeapon(PlayerPedId())) <= 50 and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('WEAPON_UNARMED') and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('WEAPON_BAT') and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('WEAPON_FLASHLIGHT') then
			if spammer then return end
			spammer = true
			Citizen.SetTimeout(2200, function()
				spammer = false
			end)
			TriggerServerEvent('useclip')
		end
	end
end)