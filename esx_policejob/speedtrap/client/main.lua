---@diagnostic disable: undefined-global, undefined-field
local ESX = nil

local speed = 0

local Jobs = {
    ["police"] = true,
    ["sheriff"] = true,
    ["forces"] = true,
    ["fbi"] = true,
    ["medic"] = true,
    ["ambulance"] = true,
}

local function createBlipForTrap(trap)
    if not trap.Blip or not trap.Blip.Enabled then return end

    local blip = AddBlipForCoord(trap.Coords.x, trap.Coords.y, trap.Coords.z)
    SetBlipSprite(blip, trap.Blip.Sprite or 744)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.2)
    SetBlipColour(blip, trap.Blip.Color or 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(trap.Blip.Text or "Speed Trap")
    EndTextCommandSetBlipName(blip)
end

local function playSound(sound)
    if not sound or not sound.Name or not sound.Set then
        if ConfigSpeed.Global.Debug then
            print("Error: Invalid sound ConfigSpeeduration. Skipping playback.")
        end
        return
    end
    if ConfigSpeed.Global.Debug then
        print(string.format("Playing sound: %s from set: %s with volume: %.1f", sound.Name, sound.Set, sound.Volume or 1.0))
    end
    PlaySoundFrontend(-1, sound.Name, sound.Set, true)
end

local function playFlashEffect()
    StartScreenEffect("SuccessNeutral", 0, false)
    Citizen.Wait(300)
    StopScreenEffect("SuccessNeutral")
end

local function monitorSpeedTrap(trap)
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if GetPedInVehicleSeat(vehicle, -1) ~= playerPed then return end
        
        if ConfigSpeed.Global.MetricSystem == 'mph' then
            speed = GetEntitySpeed(vehicle) * 2.236936
        else
            speed = GetEntitySpeed(vehicle) * 3.6
        end

        local selectedThreshold = nil
        for _, threshold in ipairs(trap.SpeedThresholds) do
            if speed >= threshold.Speed then
                selectedThreshold = threshold
            end
        end

        if selectedThreshold then
            if ConfigSpeed.Global.Debug then
                print("Selected Threshold Sound ConfigSpeed:", selectedThreshold.Sound)
            end
            playFlashEffect()
            playSound(selectedThreshold.Sound)

            TriggerServerEvent('esx_speedtraps:server:trigger', trap.ZoneName, math.floor(speed))
            if ConfigSpeed.Global.Debug then
                print(string.format("Speed Trap Triggered: Zone: %s | Speed: %d mph | Threshold: %d mph", trap.ZoneName, math.floor(speed), selectedThreshold.Speed))
            end
        else
            if ConfigSpeed.Global.Debug then
                print("No threshold selected for speed:", math.floor(speed))
            end
        end
    end
end

local function setupZones()
    for _, trap in ipairs(ConfigSpeed.SpeedTraps) do
        if trap.Enabled then
            lib.zones.sphere({
                coords = trap.Coords,
                radius = trap.Radius,
                debug = ConfigSpeed.Global.DebugZones,
                onEnter = function()
                    if not Jobs[PlayerData.job.name] then
                        monitorSpeedTrap(trap)
                    end
                end
            })
            createBlipForTrap(trap)
        end
    end
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
		Wait(50)
	end
	PlayerData = ESX.GetPlayerData()
    setupZones()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)
