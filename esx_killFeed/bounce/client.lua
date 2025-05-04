local list = {}
local cache = {}
local is_bounce_mode_active = false
local bounce_height = 0.0
local original_height = {}
local bounce_time = 0
local radius = 50.0
local affect_vehicles_in_range = true
local allowed_vehicle_types = { 0, 1, 2, 3, 4, 5, 6, 7 }
local enable_headlights = true 

function RunThread(vehicle)
    Citizen.CreateThread(function()
        while DoesEntityExist(vehicle) and list[vehicle] do
            Citizen.Wait(5)
            local current_time = GetGameTimer()
            local time_since_start = (current_time - bounce_time) / 1000.0
            local new_bounce_height = 0.05 * math.sin(2 * math.pi * 1.5 * time_since_start)
            SetVehicleSuspensionHeight(vehicle, (list[vehicle] or cache[vehicle]) + new_bounce_height)
        end
        cache[vehicle] = nil
        list[vehicle] = nil
    end)
end

RegisterNetEvent('vehicle_bouncemode:cl:start_bounce', function(netid, toggle)
    local vehicle = NetworkGetEntityFromNetworkId(netid)
    if DoesEntityExist(vehicle) then
        if not toggle then
            SetVehicleSuspensionHeight(vehicle, list[vehicle] or 0)
            SetVehicleLights(vehicle, 0)
            SetVehicleFullbeam(vehicle, false)
            list[vehicle] = nil
        else
            list[vehicle] = GetVehicleSuspensionHeight(vehicle)
            cache[vehicle] = GetVehicleSuspensionHeight(vehicle)
            RunThread(vehicle)
        end
    end
end)