local ind = {l = false, r = false}
local ped = PlayerPedId()
local vehData = {handler = false}
local fuel
local showhud = false
local position = GetEntityCoords(PlayerPedId())
local carSpeed = 0
local lastSpeed = 0
local savare = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		ped = PlayerPedId()
		local Heli = IsPedInAnyHeli(ped)
		local Plane = IsPedInAnyPlane(ped)
		local vehicle = GetVehiclePedIsIn(ped)
		if Plane or Heli then
			if not savare then 
				HeliHUD()
				savare = true
				--TriggerEvent("pedaretSekteKard", true)
			end
		end
		if vehicle > 0 and GetPedInVehicleSeat(vehicle, -1) == ped and not Heli and not Plane then
			vehData.handler = vehicle
			vehData.pause = IsPauseMenuActive()

			if vehData.fuel ~= math.floor(exports.LegacyFuel:GetFuel(vehicle)) then
				vehData.fuel = math.floor(exports.LegacyFuel:GetFuel(vehicle))
                --[[SendNUIMessage({
                    action = 'showCarhud';
                    vel = carSpeed; 
                    gasolina = vehData.fuel;
                    street = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z));
                    cinturon = true;
                    bateria = GetIsVehicleEngineRunning(GetVehiclePedIsIn(PlayerPedId(), false));
                    vidav  = GetVehicleBodyHealth(GetVehiclePedIsUsing(PlayerPedId()))/10;
                })]]
			end
		else
			vehData = {handler = false}
            SendNUIMessage({
                action = 'hideCarhud';
            })
		end

		if not (vehData.handler and not vehData.pause) and showhud then
			showhud = false
			HeliHUD()
            SendNUIMessage({
                action = 'hideCarhud';
            })
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		if vehData.handler and not vehData.pause then
			Citizen.Wait(250)
			carSpeed = math.ceil(GetEntitySpeed(vehData.handler) * 3.6)
			if carSpeed ~= lastSpeed then
				lastSpeed = carSpeed
				showhud = true
                position = GetEntityCoords(PlayerPedId())
                --[[SendNUIMessage({
                    action = 'showCarhud';
                    vel = carSpeed; 
                    gasolina = vehData.fuel;
                    street = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z));
                    cinturon = true;
                    bateria = GetIsVehicleEngineRunning(GetVehiclePedIsIn(PlayerPedId(), false));
                    vidav  = GetVehicleBodyHealth(GetVehiclePedIsUsing(PlayerPedId()))/10;
                })]]
			end
		else
			Citizen.Wait(1500)
		end
	end
end)

-- Config here
local UI = { 
	x = 0.3735,
	y = 0.3,
}

function Text(text, x, y, scale)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextOutline()
	SetTextJustification(0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function HeliHUD()
	Citizen.CreateThread(function()
		while IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) do
			Citizen.Wait(1)
	
			local Ped = GetPlayerPed(-1)
			local Heli = IsPedInAnyHeli(Ped)
			local Plane = IsPedInAnyPlane(Ped)
			local PedVehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)
			local HeliSpeed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 2.24
			local PlaneSpeed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 1.944
			local Engine = GetIsVehicleEngineRunning(PedVehicle)
			local Height = GetEntityHeightAboveGround(PedVehicle)* 3.2808399
			local Motor = GetVehicleEngineHealth(PedVehicle)
			local MainRotorHealth = GetHeliMainRotorHealth(PedVehicle)
			local TailRotorHealth = GetHeliTailRotorHealth(PedVehicle)		
			local Fl = GetEntityCoords(PlayerPedId()).z * 10
			local InDriverSeat = GetPedInVehicleSeat( PedVehicle, -1 ) == Ped
			local InPassengerSeat = GetPedInVehicleSeat( PedVehicle, 0 ) == Ped
			local LGear = GetLandingGearState(PedVehicle)
			local HeliGear = DoesVehicleHaveLandingGear == true
			
	
		-------------------------HELI--------------------
			if Heli and (InDriverSeat or InPassengerSeat) then
				-- engine display			
				if Motor > 900 and Engine then
					Text("~g~ENGINE", UI.x + 0.4016, UI.y + 0.473, 0.30)
				elseif Motor > 600 and Motor < 900 and Engine then
					Text("~y~ENGINE", UI.x + 0.4016, UI.y + 0.473, 0.30)
					Text("~y~⚠️", UI.x + 0.415, UI.y + 0.475, 0.15)
				elseif Motor > 400 and Motor < 600 and Engine then
					Text("~o~ENGINE", UI.x + 0.4016, UI.y + 0.473, 0.30)
					Text("~o~⚠️", UI.x + 0.415, UI.y + 0.475, 0.15)	
				elseif Motor > 200 and Motor < 400 and Engine then
					Text("~r~ENGINE", UI.x + 0.4016, UI.y + 0.473, 0.30)
					Text("~r~⚠️", UI.x + 0.415, UI.y + 0.475, 0.15)				
				elseif Motor < 200 and Engine then
					Text("~r~ENGINE", UI.x + 0.4016, UI.y + 0.473, 0.30)
					Text("~r~❌", UI.x + 0.415, UI.y + 0.475, 0.15)	
				elseif Motor < 800 and Engine == false then
					Text("~r~ENGINE", UI.x + 0.4016, UI.y + 0.473, 0.30)
					Text("~r~❌", UI.x + 0.415, UI.y + 0.475, 0.15)
					Text("~r~ROTOR", UI.x + 0.4016, UI.y + 0.488, 0.30)
					Text("~r~❌", UI.x + 0.415, UI.y + 0.490, 0.15)
					Text("~r~TAIL", UI.x + 0.4018, UI.y + 0.502, 0.30)	
					Text("~r~❌", UI.x + 0.415, UI.y + 0.505, 0.15)	
					
				elseif Engine == false then
					Text("~w~ENGINE", UI.x + 0.4016, UI.y + 0.473, 0.30)
				end
				-- Main rotor display
				if MainRotorHealth > 800 and Engine then
					Text("~g~ROTOR", UI.x + 0.4016, UI.y + 0.488, 0.30)	
				elseif MainRotorHealth > 600 and MainRotorHealth < 800 and Engine then
					Text("~y~ROTOR", UI.x + 0.4016, UI.y + 0.488, 0.30)
					Text("~y~⚠️", UI.x + 0.415, UI.y + 0.490, 0.15)
				elseif MainRotorHealth > 400 and MainRotorHealth < 600 and Engine then
					Text("~o~ROTOR", UI.x + 0.4016, UI.y + 0.488, 0.30)
					Text("~o~⚠️", UI.x + 0.415, UI.y + 0.490, 0.15)	
				elseif MainRotorHealth > 200 and MainRotorHealth < 400 and Engine then
					Text("~r~ROTOR", UI.x + 0.4016, UI.y + 0.488, 0.30)
					Text("~r~⚠️", UI.x + 0.415, UI.y + 0.490, 0.15)					
				elseif MainRotorHealth < 200 and Engine then
					Text("~r~ROTOR", UI.x + 0.4016, UI.y + 0.488, 0.30)
					Text("~r~❌", UI.x + 0.415, UI.y + 0.490, 0.15)			
				elseif MainRotorHealth > 200 and Engine == false then
					Text("~w~ROTOR", UI.x + 0.4016, UI.y + 0.488, 0.30)
				end			
				-- Tail rotor display
				if TailRotorHealth > 800 and Engine then
					Text("~g~TAIL", UI.x + 0.4018, UI.y + 0.503, 0.30)	
				elseif TailRotorHealth > 600 and TailRotorHealth < 800 and Engine then
					Text("~y~TAIL", UI.x + 0.4018, UI.y + 0.502, 0.30)
					Text("~y~⚠️", UI.x + 0.415, UI.y + 0.505, 0.15)
				elseif TailRotorHealth > 400 and TailRotorHealth < 600 and Engine then
					Text("~o~TAIL", UI.x + 0.4018, UI.y + 0.502, 0.30)
					Text("~o~⚠️", UI.x + 0.415, UI.y + 0.505, 0.15)
				elseif TailRotorHealth > 200 and TailRotorHealth < 400 and Engine then
					Text("~r~TAIL", UI.x + 0.4018, UI.y + 0.502, 0.30)
					Text("~r~⚠️", UI.x + 0.415, UI.y + 0.505, 0.15)					
				elseif TailRotorHealth < 200 and Engine then
					   Text("~r~TAIL", UI.x + 0.4018, UI.y + 0.502, 0.30)	
					Text("~r~❌", UI.x + 0.415, UI.y + 0.505, 0.15)	
				elseif Engine == false then
					Text("~w~TAIL", UI.x + 0.4018, UI.y + 0.502, 0.30)
				end
				----------------height-------------			
				if Height > 5 and Height < 20000.0 then
					Text(math.ceil(Height), UI.x + 0.5, UI.y + 0.476, 0.45)
					Text("~w~ft", UI.x + 0.515, UI.y + 0.486, 0.30)	
				elseif Height < 5.0 and Height > 0.01 then
					Text("~g~__", UI.x + 0.500, UI.y + 0.445, 0.80)
				end
				Text(math.ceil(HeliSpeed), UI.x + 0.549, UI.y + 0.476, 0.45)
				if HeliSpeed > 130.0 and Height > 30.0 then
					Text("~b~⚠️", UI.x + 0.5635, UI.y + 0.476, 0.25)
				elseif HeliSpeed == 0.0 then
					Text("~g~__", UI.x + 0.549, UI.y + 0.445, 0.80)
				end						
				----LANDING----
				if HeliSpeed < 1.0 and Height < 5.0 and (LGear == 0)then
					Text("~b~LANDED", UI.x + 0.598, UI.y + 0.50, 0.40)
					Text("~m~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)
				elseif HeliSpeed < 30.0 and Height < 150.0  and (LGear == 0)then
					Text("~y~LANDING MODE", UI.x + 0.598, UI.y + 0.504, 0.30)
					Text("~m~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)
				elseif  Height < 300.0  and((LGear == 1)or(LGear == 3)or(LGear == 4))then
				Text("~r~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)			
				elseif HeliSpeed > 30.0 and Height > 15.0  and (LGear == 0)then
				Text("~r~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)
				end			
				-----warnings----
				if HeliSpeed > 130.0 and Height > 10.0 then
					Text("~o~OVERSPEED", UI.x + 0.598, UI.y + 0.504, 0.30)	
					Text("~m~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)				
				elseif HeliSpeed > 5.0 and ((Height > 0.1 and Height < 300.0)and (not LGear == 0))then
					Text("~m~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)									
				end			
				if Height > 300.0 then
				Text("~m~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)
				elseif Height > 150.0 and (LGear == 0)then
				Text("~r~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)
				elseif (Height > 10.0 and HeliSpeed > 30.0)and (LGear == 0)then
				Text("~r~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)
				end			
				if Motor < 650.001  then
				Text("~r~MASTER", UI.x + 0.595, UI.y + 0.39, 0.45)
				Text("~r~CAUTION", UI.x + 0.595, UI.y + 0.42, 0.45)
				elseif Motor > 650.0 then
				Text("~m~MASTER", UI.x + 0.595, UI.y + 0.39, 0.45)
				Text("~m~CAUTION", UI.x + 0.595, UI.y + 0.42, 0.45)
				end				
			end
		-------------------------PLANE-------------------
		  if Plane and (InDriverSeat or InPassengerSeat) then	    
				  -- engine display	
			if Motor > 850 and Engine then
					Text("~g~ENGINE", UI.x + 0.4016, UI.y + 0.504, 0.29)
					Text("~g~POWER OFF", UI.x + 0.4016, UI.y + 0.48, 0.25)
				elseif Motor > 600 and Motor < 900 and Engine then
					Text("~y~ENGINE", UI.x + 0.4016, UI.y + 0.504, 0.30)
					Text("~y~⚠️", UI.x + 0.415, UI.y + 0.507, 0.15)
					Text("~g~POWER OFF", UI.x + 0.4016, UI.y + 0.48, 0.25)
				elseif Motor > 400 and Motor < 600 and Engine then
					Text("~o~ENGINE", UI.x + 0.4016, UI.y + 0.504, 0.30)
					Text("~o~⚠️", UI.x + 0.415, UI.y + 0.507, 0.15)	
					Text("~g~POWER OFF", UI.x + 0.4016, UI.y + 0.48, 0.25)
				elseif Motor > 200 and Motor < 400 and Engine then
					Text("~r~ENGINE", UI.x + 0.4016, UI.y + 0.504, 0.30)
					Text("~r~⚠️", UI.x + 0.415, UI.y + 0.507, 0.15)
					Text("~g~POWER OFF", UI.x + 0.4016, UI.y + 0.48, 0.25)				
				elseif Motor < 200 and Engine then
					Text("~r~ENGINE", UI.x + 0.4016, UI.y + 0.504, 0.30)
					Text("~r~❌", UI.x + 0.415, UI.y + 0.507, 0.15)	
					Text("~g~POWER OFF", UI.x + 0.4016, UI.y + 0.48, 0.25)				
				elseif Engine == false then
					Text("~w~ENGINE", UI.x + 0.4016, UI.y + 0.504, 0.30)
					Text("~r~POWER OFF", UI.x + 0.4016, UI.y + 0.48, 0.40)
				end			
				----------------height--------------			
				if Height < 50000.000001 and Height > 7.4000001 then
					Text(math.ceil(Height), UI.x + 0.5, UI.y + 0.476, 0.45)
					Text("~w~ft", UI.x + 0.515, UI.y + 0.486, 0.30)				
				elseif Height < 1000.000001 and Height > 7.4000001 then
					Text("~r~🔺", UI.x + 0.482, UI.y + 0.473, 0.10)
				elseif Height < 7.4 and Height > 0.01 then
					Text("~g~__", UI.x + 0.500, UI.y + 0.445, 0.80)
				
				end			
				Text(math.ceil(PlaneSpeed), UI.x + 0.549, UI.y + 0.476, 0.45)
				if PlaneSpeed > 140.0 and Height > 300.0 and ((LGear == 1)or(LGear == 3)or(LGear == 4))then
					Text("~b~⚠️", UI.x + 0.5635, UI.y + 0.476, 0.25)
				elseif PlaneSpeed > 140.0 and Height > 1000.0 and (LGear == 0) then
					Text("~b~⚠️", UI.x + 0.5635, UI.y + 0.476, 0.25)
				elseif PlaneSpeed == 0.0 then
					Text("~g~__", UI.x + 0.549, UI.y + 0.445, 0.80)
				end	
				-----warnings----
				if Motor < 750.0  then
				   Text("~r~MASTER", UI.x + 0.595, UI.y + 0.39, 0.45)
				   Text("~r~CAUTION", UI.x + 0.595, UI.y + 0.42, 0.45)
				elseif Motor > 750.0  then
				   Text("~m~MASTER", UI.x + 0.595, UI.y + 0.39, 0.45)
				   Text("~m~CAUTION", UI.x + 0.595, UI.y + 0.42, 0.45)
				end		
				if PlaneSpeed > 140.0 and Height > 300.0 and ((LGear == 1)or(LGear == 3)or(LGear == 4))then
					Text("~o~OVERSPEED", UI.x + 0.598, UI.y + 0.504, 0.30)	
				elseif PlaneSpeed > 140.0 and Height > 1000.0 and (LGear == 0) then
				Text("~o~OVERSPEED", UI.x + 0.598, UI.y + 0.504, 0.30)	
				end
				----LANDING----
				if PlaneSpeed < 15.0 and Height < 6.0 and (LGear == 0)then 
					Text("~b~LANDED", UI.x + 0.598, UI.y + 0.50, 0.40)
					Text("~m~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)
				elseif (LGear == 0) and Height < 1000.0 then
					Text("~y~LANDING MODE", UI.x + 0.598, UI.y + 0.504, 0.30)
					Text("~m~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)
				elseif ((LGear == 1)or(LGear == 3)or(LGear == 4)) and Height < 1000.0 then
				Text("~r~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)
				end 			
				if Height > 1000.0 then
				Text("~m~TOO LOW", UI.x + 0.598, UI.y + 0.474, 0.40)
				end	
		  end	  
		  ----------Plane&Heli------------------------
		  if (Plane or Heli) and (InDriverSeat or InPassengerSeat) then
			local Fuel = exports["LegacyFuel"]:GetFuel(PedVehicle)
			local Hora = GetClockHours()			
				if Fl < 100.0 and Fl > 0.01 then
				Text("~r~__", UI.x + 0.455, UI.y + 0.480, 0.60)
				elseif Fl < 200.0 and Fl > 100.01 then
				Text("~r~1", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 300.0 and Fl > 200.01 then
				Text("~r~2", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 400.0 and Fl > 300.01 then
				Text("~r~3", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 500.0 and Fl > 400.01 then
				Text("~r~4", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 600.0 and Fl > 500.01 then
				Text("~r~5", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 700.0 and Fl > 600.01 then
				Text("~r~6", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 800.0 and Fl > 700.01 then
				Text("~r~7", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 900.0 and Fl > 800.01 then
				Text("~r~8", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 1000.0 and Fl > 900.01 then
				Text("~r~9", UI.x + 0.455, UI.y + 0.500, 0.35)		
				elseif Fl < 2000.0 and Fl > 1000.01 then
				Text("~o~10", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 3000.0 and Fl > 2000.01 then
				Text("~y~20", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 4000.0 and Fl > 3000.01 then
				Text("~y~30", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 5000.0 and Fl > 4000.01 then
				Text("~g~40", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 6000.0 and Fl > 5000.01 then
				Text("~g~50", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 7000.0 and Fl > 6000.01 then
				Text("~b~60", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 8000.0 and Fl > 7000.01 then
				Text("~b~70", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 9000.0 and Fl > 8000.01 then
				Text("~p~80", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 10000.0 and Fl > 9000.01 then
				Text("~p~90", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 11000.0 and Fl > 10000.01 then
				Text("~p~100", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 12000.0 and Fl > 11000.01 then
				Text("~p~110", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 13000.0 and Fl > 12000.01 then
				Text("~p~120", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 14000.0 and Fl > 13000.01 then
				Text("~p~130", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 15000.0 and Fl > 14000.01 then
				Text("~p~140", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 16000.0 and Fl > 15000.01 then
				Text("~p~150", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 17000.0 and Fl > 16000.01 then
				Text("~p~160", UI.x + 0.455, UI.y + 0.500, 0.35)	
				elseif Fl < 18000.0 and Fl > 17000.01 then
				Text("~p~170", UI.x + 0.455, UI.y + 0.500, 0.35)	
				elseif Fl < 19000.0 and Fl > 18000.01 then
				Text("~p~180", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 20000.0 and Fl > 19000.01 then
				Text("~p~190", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 21000.0 and Fl > 20000.01 then
				Text("~p~200", UI.x + 0.455, UI.y + 0.500, 0.35)            
				elseif Fl < 22000.0 and Fl > 21000.01 then
				Text("~p~210", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 23000.0 and Fl > 22000.01 then
				Text("~o~220", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 24000.0 and Fl > 23000.01 then
				Text("~o~230", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 25000.0 and Fl > 24000.01 then
				Text("~r~240", UI.x + 0.455, UI.y + 0.500, 0.35)
				elseif Fl < 26000.0 and Fl > 25000.01 then
				Text("~r~250", UI.x + 0.455, UI.y + 0.500, 0.35)		
				end
		  Text(math.ceil(Fuel), UI.x + 0.453, UI.y + 0.475, 0.35)  
				if Fuel < 25.0 and Fuel > 2.1 then
				Text("~r~⚠️", UI.x + 0.465, UI.y + 0.477, 0.21)
				elseif Fuel < 2.0 then
				Text("~r~0", UI.x + 0.452, UI.y + 0.476, 0.35)
				Text("~r~⚠️", UI.x + 0.465, UI.y + 0.477, 0.21)
				end	  
	
				if (LGear == 0) then
					LGear = "DEPLOYED"
					Text("~g~DEPLOYED", UI.x + 0.530, UI.y + 0.389, 0.50)		
					Text("~m~RETRACTED", UI.x + 0.530, UI.y + 0.419, 0.50)					
				elseif (LGear == 1) then
					LGear = "RETRACTING"
					Text("~o~RETRACTED", UI.x + 0.530, UI.y + 0.419, 0.50)
					Text("~m~DEPLOYED", UI.x + 0.530, UI.y + 0.389, 0.50)	
				elseif (LGear == 3) then
					LGear = "DEPLOYING"
					Text("~y~DEPLOYED", UI.x + 0.530, UI.y + 0.389, 0.50)
					Text("~m~RETRACTED", UI.x + 0.530, UI.y + 0.419, 0.50)
				elseif (LGear == 4) then
					LGear = "RETRACTED"
					Text("~r~RETRACTED", UI.x + 0.530, UI.y + 0.419, 0.50)
					Text("~m~DEPLOYED", UI.x + 0.530, UI.y + 0.389, 0.50)	
				elseif (LGear == 5) then
					LGear = "MALFUNCTION"
					Text("~r~MALFUNCTION", UI.x + 0.530, UI.y + 0.419, 0.40)
				end
			   if Hora < 6.0 or Hora > 19.0 then 
				Text("~o~AIR SPEED", UI.x + 0.55, UI.y + 0.508, 0.29)
				Text("~o~ALTITUDE", UI.x + 0.5, UI.y + 0.508, 0.29)
				Text("~o~FUEL", UI.x + 0.437, UI.y + 0.475, 0.35)
				Text("~o~FL", UI.x + 0.440, UI.y + 0.500, 0.35)
	
				DrawRect(UI.x + 0.5, UI.y + 0.5, 0.255, 0.085, 234, 143, 27, 255) 
				DrawRect(UI.x + 0.595, UI.y + 0.42, 0.2, 0.095, 234, 143, 27, 255) 					
		
				DrawRect(UI.x + 0.5, UI.y + 0.5, 0.25, 0.075, 0, 0, 0, 255)
				DrawRect(UI.x + 0.595, UI.y + 0.42, 0.06, 0.085, 0, 0, 0, 255)
				DrawRect(UI.x + 0.5335, UI.y + 0.42, 0.07, 0.085, 0, 0, 0, 255)
		
				DrawRect(UI.x + 0.402, UI.y + 0.5, 0.040, 0.050, 51, 62, 52, 255)
				DrawRect(UI.x + 0.4585, UI.y + 0.5, 0.025, 0.050, 51, 62, 52, 255)				
				DrawRect(UI.x + 0.5, UI.y + 0.49, 0.040, 0.032, 51, 62, 52, 255)			
				DrawRect(UI.x + 0.549, UI.y + 0.49, 0.040, 0.032, 51, 62, 52, 255) 		
				DrawRect(UI.x + 0.598, UI.y + 0.5, 0.040, 0.050, 51, 62, 52, 255)			
				DrawRect(UI.x + 0.595, UI.y + 0.42, 0.050, 0.060, 98, 27, 23, 255) 					
				DrawRect(UI.x + 0.530, UI.y + 0.405, 0.050, 0.030, 74, 145, 100, 255) 
				DrawRect(UI.x + 0.530, UI.y + 0.435, 0.050, 0.030, 134, 98, 98, 255)	
				elseif Hora > 6.0 or Hora < 19.0 then
				Text("~w~AIR SPEED", UI.x + 0.55, UI.y + 0.508, 0.29)
				Text("~w~ALTITUDE", UI.x + 0.5, UI.y + 0.508, 0.29)
				Text("~w~FUEL", UI.x + 0.437, UI.y + 0.475, 0.35)
				Text("~w~FL", UI.x + 0.440, UI.y + 0.500, 0.35)
				DrawRect(UI.x + 0.5, UI.y + 0.5, 0.255, 0.085, 110, 110, 110, 255)
				DrawRect(UI.x + 0.595, UI.y + 0.42, 0.2, 0.095, 110, 110, 110, 255)
				DrawRect(UI.x + 0.5, UI.y + 0.5, 0.25, 0.075, 40, 40, 40, 255)
				DrawRect(UI.x + 0.595, UI.y + 0.42, 0.06, 0.085, 40, 40, 40, 255)
				DrawRect(UI.x + 0.5335, UI.y + 0.42, 0.07, 0.085, 40, 40, 40, 255)
				DrawRect(UI.x + 0.402, UI.y + 0.5, 0.040, 0.050, 51, 62, 52, 255)
				DrawRect(UI.x + 0.4585, UI.y + 0.5, 0.025, 0.050, 51, 62, 52, 255)		
				DrawRect(UI.x + 0.5, UI.y + 0.49, 0.040, 0.032, 51, 62, 52, 255)			
				DrawRect(UI.x + 0.549, UI.y + 0.49, 0.040, 0.032, 51, 62, 52, 255) 			
				DrawRect(UI.x + 0.598, UI.y + 0.5, 0.040, 0.050, 51, 62, 52, 255)			
				DrawRect(UI.x + 0.595, UI.y + 0.42, 0.050, 0.060, 98, 27, 23, 255) 					
				DrawRect(UI.x + 0.530, UI.y + 0.405, 0.050, 0.030, 74, 145, 100, 255) 
				DrawRect(UI.x + 0.530, UI.y + 0.435, 0.050, 0.030, 134, 98, 98, 255)
				end
			end
		end
		--TriggerEvent("pedaretSekteKard", false)
		savare = false
	end)
end