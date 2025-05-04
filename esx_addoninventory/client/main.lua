---@diagnostic disable: missing-parameter
ESX = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

local display = false

RegisterNetEvent('ador_streamergifts:showui', function ()
  SetDisplay(true)
end)

RegisterNUICallback("exit", function(data)
  SetDisplay(false)
end)

RegisterNUICallback("submit", function(data)
  if data.ok then
    TriggerServerEvent('useStreamerStarter')
    SetDisplay(false)
  end
end)

Citizen.CreateThread(function()
  while display do
      Citizen.Wait(0)
      DisableControlAction(0, 1, display)
      DisableControlAction(0, 2, display)
      DisableControlAction(0, 142, display)
      DisableControlAction(0, 18, display) 
      DisableControlAction(0, 322, display)
      DisableControlAction(0, 106, display)
  end
end)

function SetDisplay(bool)
  display = bool
  SetNuiFocus(bool, bool)
  SendNUIMessage({
      type = "ui",
      status = bool,
  })
end

RegisterNetEvent("esx_admin:OpenGarage")
AddEventHandler("esx_admin:OpenGarage", function(ownedCars)
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
            GetVehicles(ownedCars)
        end
    end)
end)

function GetVehicles(ownedCars)
    ESX.UI.Menu.CloseAll()
    local elements = {}
    if #ownedCars == 0 then
      ESX.Alert('Mashini dar garage nadarad')
      return
    else
      for _,v in pairs(ownedCars) do
        local hashVehicule = v.vehicle.model
        local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule)
        if vehicleName == "Unknown" then
            vehicleName = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(hashVehicule))
        end
        local plate        = v.plate
        local labelvehicle
        if IsModelValid(hashVehicule) then
          if v.stored then
            labelvehicle = '| '..plate..' | '..vehicleName..' | In Garage |'
          else
            labelvehicle = '| '..plate..' | '..vehicleName..' | Impound |'
          end
          
          table.insert(elements, {label = labelvehicle, value = v})
        end
      end
    end
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_player_car', {
      title    = 'Players Vehicles',
      align    = 'top-left',
      elements = elements
    }, function(data2, menu2)
        local plate = data2.current.value.plate
        local elements = {}
        table.insert(elements, {label = 'Spawn Vehicle', value = 'spawn_car'}) 
  
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_player_car_option', {
          title    = 'What do you want to do?',
          align    = 'top-left',
          elements = elements
        }, function(data3, menu3)
            menu3.close()
            if data3.current.value == 'spawn_car' then
  
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                  ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
              end
  
              --ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle, damages)
                local coords = GetEntityCoords(PlayerPedId())
                local heading = GetEntityHeading(PlayerPedId())
                local vehicle = data2.current.value.vehicle
                              local damages = data2.current.value.damages
                ESX.Game.SpawnVehicle(vehicle.model, coords, heading, function(callback_vehicle)
                  vehicle.plate = plate
                  ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
                  SetVehRadioStation(callback_vehicle, "OFF")
                  TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
                  ESX.CreateVehicleKey(callback_vehicle)
                end)
              --end, plate, player)
            else
              ESX.TriggerServerCallback("esx_trunk:getInventoryV", function(inventory)
                text = ('<h3>Vehicle trunk</h3><br><strong>Plate:</strong> %s<br><strong>Capacity:</strong> %s / %s'):format(plate, (inventory.weight / 1000), (500000 / 1000))
                data = {plate = plate, max = 500000, text = text}
                TriggerEvent("esx_inventoryhud:openTrunkInventory", data, inventory.items, inventory.weapons)
              end, plate)
            end
        end, function(data3, menu3)
          menu3.close()
        end)
    end, function(data2, menu2)
      menu2.close()
    end)
  end