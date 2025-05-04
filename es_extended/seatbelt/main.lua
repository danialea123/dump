local isUiOpen = false 
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false
local vehData =  {active = false}

--[[ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)]]

RegisterNetEvent('seatbelt:chageStatus')
AddEventHandler('seatbelt:changeStatus', function(status)

  if type(status) ~= "boolean" then
    print("seatbelt: non boolean value")
  end

  beltOn = status
  isUiOpen = status

  if status == true then
    SendNUIMessage({
      displayW = 'false'
    })
  end
  
end)

IsCar = function(veh)
        local vc = GetVehicleClass(veh)
        return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 15 and vc <= 20)
        end 

Fwv = function (entity)
        local hr = GetEntityHeading(entity) + 90.0
        if hr < 0.0 then hr = 360.0 + hr end
        hr = hr * 0.0174533
        return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end
 
Citizen.CreateThread(function()
    while true do
    Citizen.Wait(10)

      if vehData.active then
        wasInCar = true
        if isUiOpen == false and not IsPlayerDead(PlayerId()) then
            SendNUIMessage({
            displayW = 'true'
            })
            isUiOpen = true
        end

        if not beltOn then
          speedBuffer[2] = speedBuffer[1]
          speedBuffer[1] = GetEntitySpeed(vehData.vehicle)
          if speedBuffer[2] ~= nil 
              and GetEntitySpeedVector(vehData.vehicle, true).y > 1.0  
              and speedBuffer[1] > 19.25 
              and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
              
              local co = GetEntityCoords(vehData.ped)
              local fw = Fwv(vehData.ped)
              ESX.SetEntityCoords(vehData.ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
              SetEntityVelocity(vehData.ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
              Citizen.Wait(1)
              SetPedToRagdoll(vehData.ped, 1000, 1000, 0, 0, 0, 0)
          end
          
          velBuffer[2] = velBuffer[1]
          velBuffer[1] = GetEntityVelocity(vehData.vehicle)
        else
          Citizen.Wait(500)
        end
      
    elseif wasInCar then
      wasInCar = false
      beltOn = false
      speedBuffer[1], speedBuffer[2] = 0.0, 0.0
        if isUiOpen then
          SendNUIMessage({
            displayW = 'false'
          })
          isUiOpen = false 
        end
    else 
      Citizen.Wait(500)
    end
    
  end
end)

AddEventHandler("onKeyDown", function(key)
  if key == "l" then
    if not vehData.active or ESX.GetPlayerData().isSentenced then
      return
    end
    beltOn = not beltOn
    TriggerEvent("seatbelt:hudState", beltOn)
    if beltOn then 
      TriggerEvent("pNotify:SendNotification", {text = "!کمربند بسته شد", type = "success", timeout = 1400, layout = "centerLeft"})
      TriggerEvent('InteractSound_CL:PlayOnOne', 'buckle', 0.9)
      SendNUIMessage({
        displayW = 'false'
        })
      isUiOpen = true 
    else
      speedBuffer  = {}
      velBuffer    = {}
      TriggerEvent("pNotify:SendNotification", {text = "!کمربند را ببندید", type = "warning", timeout = 1400, layout = "centerLeft"})
      TriggerEvent('InteractSound_CL:PlayOnOne', 'unbuckle', 0.9)
      SendNUIMessage({
        displayW = 'true'
      })
      isUiOpen = true
    end
  end
end)

AddEventHandler("onKeyDown", function(key)
  if key == "f" then
    if vehData.active and beltOn then
      DisableControlAction(0, 75, true)
      DisableControlAction(2, 75, true)
      DisableControlAction(1, 75, true)
    end
  end
end)

local blackList = {
    [GetHashKey("RIOT")] = {smaller = -145, bigger = 100, passengerRestrict = true},
    [GetHashKey("INSURGENT2")] = {smaller = -150, bigger = 100, passengerRestrict = false},
    [GetHashKey("ZENTORNO")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("VAGNER")] = {smaller = -140, bigger = 170, passengerRestrict = false },
    [GetHashKey("VISIONE")] = {smaller = -165, bigger = 120, passengerRestrict = false },
    [GetHashKey("TYRUS")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("TYRANT")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("TIGON")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("TAIPAN")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("T20")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("SC1")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("REAPER")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("PROTOTIPO")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("PFISTER811")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("LE7B")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("KRIEGER")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("INFERNUS")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("ENTITYXF")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("ENTITY2")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("BULLET")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("AUTARCH")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("RMODLP750")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("RMODLP770")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("CHIRON17")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("RMODLP750")] = {smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("SHEAVA")] = {smaller = -150, bigger = 100, passengerRestrict = false},
    [GetHashKey("hellion")] = {smaller = -150, bigger = 100, passengerRestrict = false}
}

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(500)
      local ped = PlayerPedId()
      local car = GetVehiclePedIsIn(ped)
      local isBlackList = blackList[GetEntityModel(car)]
      
      if car ~= 0 and IsCar(car) then
        vehData.ped = ped
        vehData.vehicle = car
        vehData.blacklist = isBlackList
        
        if vehData.blacklist then

          if vehData.blacklist.passengerRestrict and GetPedInVehicleSeat(car, 0) == ped then
            local camHeading = GetGameplayCamRelativeHeading()
            if camHeading < vehData.blacklist.smaller or camHeading > vehData.blacklist.bigger then
              vehData.lookingBack = true
            else
              vehData.lookingBack = false
            end
          elseif not vehData.blacklist.passengerRestrict then
            local camHeading = GetGameplayCamRelativeHeading()
            if camHeading < vehData.blacklist.smaller or camHeading > vehData.blacklist.bigger then
              vehData.lookingBack = true
            else
              vehData.lookingBack = false
            end
          end
        
        end

        vehData.active = true

      else
        vehData = {active = false}
      end

  end
end)

Citizen.CreateThread(function()
  while true do
    if vehData.active and (vehData.blacklist and vehData.lookingBack) then
      Citizen.Wait(10)
      DisableControlAction(2, 25, true) -- Aim
      DisableControlAction(2,24, true) -- INPUT_ATTACK
      DisableControlAction(0,69, true) -- INPUT_VEH_ATTACK
      DisableControlAction(0,70, true) -- INPUT_VEH_ATTACK2
      DisableControlAction(0,68, true) -- Attack in car 3
			DisableControlAction(0,66, true) -- Attack in car 4
      DisableControlAction(0,67, true) -- Attack in car 5
      DisableControlAction(2,257, true) -- Attack 2
      DisableControlAction(0,92, true) -- INPUT_VEH_PASSENGER_ATTACK
      DisableControlAction(0,114, true) -- INPUT_VEH_FLY_ATTACK
      DisableControlAction(0,142, true)
      DisableControlAction(0,257, true) -- INPUT_ATTACK2
      DisableControlAction(0,331, true) -- INPUT_VEH_FLY_ATTACK2
    else
      Citizen.Wait(500)
    end
  end
end)

RegisterNetEvent('autobelt')
AddEventHandler('autobelt', function()
  TriggerEvent('InteractSound_CL:PlayOnOne', 'buckle', 0.9)
	SendNUIMessage({
		displayW = 'false'
	})
	isUiOpen = true
	beltOn = true
end)

exports("FastenSeatBelt", function()
    return beltOn
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2500)
        TriggerEvent("seatbelt:hudState", beltOn)
    end
end)