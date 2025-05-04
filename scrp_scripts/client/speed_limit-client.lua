local LimitActivated = false

function Break()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() and IsControlPressed(0, 22) and not LimitActivated then
		local Speed = GetEntitySpeed(vehicle)
		SetVehicleMaxSpeed(vehicle, Speed - (Speed * 0.01))
		SetTimeout(0, Break)
	else
		EnableLimit = false
		SetVehicleMaxSpeed(vehicle, 0.0)
	end
end

RegisterKey('SPACE', function ()
	if not LimitActivated then		
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
				Break()
			end
		end
	end
end)

local EnableLimit = false
RegisterKey('B', false, function ()
	if not LimitActivated and IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
			if EnableLimit then
				ESX.ShowHelpNotification(_U('speedlimiter_disabled'))
				SetVehicleMaxSpeed(vehicle, 0.0)
				EnableLimit = false
			else
				local cruise = GetEntitySpeed(vehicle)
				SetVehicleMaxSpeed(vehicle, cruise)
				cruise = math.floor(cruise * 3.6 + 0.5)
				ESX.ShowHelpNotification(_U('speedlimiter_set', cruise))
				EnableLimit = true
			end
		end
	end
end)

local SpeedLimitZone = {
	{ active = false, coords = vector3(-356.51, -123.3, 38.69), radius = 55 }, -- 
	{ active = false, coords = vector3(1181.41, 2657.27, 37.87), radius = 70 }, -- 
	{ active = false, coords = vector3(437.09,-992.76,43.69), radius = 40 }, -- 
	{ active = false, coords = vector3(-668.99,273.2,81.32), radius = 50 }, -- 
	{ active = false, coords = vector3(1334.74,-734.99,69.48), radius = 40 }, -- 
}

local function SpeedLimit(area)
	if SpeedLimitZone[area].active then
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
				if not LimitActivated then
					SetVehicleMaxSpeed(vehicle, 10.5)
					LimitActivated = true
				end
			end
		end
		SetTimeout(100, function()
			SpeedLimit(area)
		end)
	end
end

Citizen.CreateThread(function ()
    while true do
        local pCoord = GetEntityCoords(PlayerPedId())
        for k,v in pairs(SpeedLimitZone) do
            if #(v.coords - pCoord) < v.radius then
                if not v.active then
                    SpeedLimitZone[k].active = true
                    SpeedLimit(k)
                end
            elseif SpeedLimitZone[k].active then
				SpeedLimitZone[k].active = false
				LimitActivated = nil
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
					SetVehicleMaxSpeed(vehicle, 0.0)
				end
            end
        end
        Citizen.Wait(750)
    end
end)


local driftmode = false
local drift_speed_limit = 100.0

function Drift()
	if IsPedInAnyVehicle(PlayerPedId(), false) and driftmode then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
			if GetEntitySpeed(vehicle) * 3.6 <= drift_speed_limit then
				if IsControlPressed(1, 21) then
					SetVehicleReduceGrip(vehicle, true)
				else
					SetVehicleReduceGrip(vehicle, false)
				end
			end
			SetTimeout(0, Drift)
		else
			driftmode = false
		end
	else
		driftmode = false
	end
end

AddEventHandler("onKeyDown", function(key)
	if key == "numpad9" then
		driftmode = not driftmode
		if driftmode then
			TriggerEvent('chat:addMessage', _U('drift'), {167,101,181}, _U('drift_enabled'))
			Drift()
		else
			TriggerEvent('chat:addMessage', _U('drift'), {167,101,181}, _U('drift_disabled'))
		end
	end
end)

local cruise = {limit = 75.0}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, -1)
		local class =  GetVehicleClass(vehicle)

		if vehicle then
			if GetPedInVehicleSeat(vehicle, -1) == ped then
				if class ~= 15 and class ~= 16 then
					SetEntityMaxSpeed(vehicle, cruise.limit)
				end
			end
		end

	end
end)