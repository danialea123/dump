---@diagnostic disable: undefined-global, undefined-field
local lastOpen = 0

ESXMenuHandler = function(d,t,st)
  if inProgressAction then
    return
  end

  if GetGameTimer() - lastOpen <= 3000 then
    ESX.ShowNotification("~h~Lotfan spam nakonid beyn har action hade aghal ~g~3 ~w~sanie sabr konid!")
    return
  end

  lastOpen = GetGameTimer()

  if t == "Entry" then

  if st == "Owner" then
      MenuOpen = vector3(d.Entry.x, d.Entry.y, d.Entry.z)
      FreezeEntityPosition(PlayerPedId(),true)
      ESXEntryOwnerMenu(d)
  elseif st == "Owned" then
      MenuOpen = vector3(d.Entry.x, d.Entry.y, d.Entry.z)
      FreezeEntityPosition(PlayerPedId(),true)
      ESXEntryOwnedMenu(d)
  elseif st == "Empty" then
    MenuOpen = vector3(d.Entry.x, d.Entry.y, d.Entry.z)
    FreezeEntityPosition(PlayerPedId(),true)
    ESXEntryEmptyMenu(d)
  end

  elseif t == "Garage" then
    if st == "Owner" or Houses[d.Id].HouseKeys[GetPlayerIdentifier()] then
      MenuOpen = vector3(d.Garage.x, d.Garage.y, d.Garage.z)
      FreezeEntityPosition(PlayerPedId(),true)
      ESXGarageOwnerMenu(d)
    elseif st == "Owned" then
      local thisHouse = Houses[d.Id]
      if thisHouse and thisHouse.HouseKeys[GetPlayerIdentifier()] then
        --MenuOpen = vector3(d.Garage.x, d.Garage.y, d.Garage.z)
        --FreezeEntityPosition(PlayerPedId(),true)
        --ESXGarageOwnedMenu(d)
      end
    end
  elseif t == "Exit" then
    if st == "Owner" then
      ESXExitOwnerMenu(d)
    elseif st == "Owned" then
      ESXExitOwnedMenu(d)
    elseif st == "Empty" then
      ESXExitEmptyMenu(d)
    end
  elseif t == "Wardrobe" then
    if st == "Owner" or st == "Owned" then
      TriggerEvent("codem-apperance:OpenWardrobe")
      --ESXWardrobeMenu(d)
    end
  elseif t == "InventoryLocation" then
    OpenInventory(d)
  end
end

ESXWardrobeMenu = function(d)
	local elements = {}
	table.insert(elements, {label = "Lebas Haye Dakhel Khoone", value = 'player_dressing'})
  if Houses[d.Id].Owner == GetPlayerIdentifier() or Houses[d.Id].HouseKeys[GetPlayerIdentifier()] then
	  table.insert(elements, {label = "Hazf Lebas Haye Dakhel Khoone", value = 'remove_cloth'})
  end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room', {
		title    = "Lebas Khoone",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
        if data.current.value == 'player_dressing' then

			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = "Lebas Haye Khoone",
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value, d.Id)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end, d.Id)

		elseif data.current.value == 'remove_cloth' then

			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
					title    = "Hazf Khoone",
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('esx_property:removeOutfit', d.Id, data2.current.value)
					ESX.Alert( ('removed_cloth'))
				end, function(data2, menu2)
					menu2.close()
				end)
			end, d.Id)
        end
    end, function(data, menu)
        menu.close()
    end)
end

ESXOpenInviteMenu = function(d)
  local elements = {}
  local players = GetNearbyPlayers(d.Entry,10.0)
  local c = 0
  for _,player in pairs(players) do
    if player ~= PlayerId() then
      table.insert(elements,{label = GetPlayerName(player).." [ID:"..GetPlayerServerId(player).."]",value = GetPlayerServerId(player),name = GetPlayerName(player)})
    end
  end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_invite_menu",{
      title    = Labels['InviteInside'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      submitMenu.close()
      InviteInside(d,submitData.current.value)
      ShowNotification("You invited "..submitData.current.name.." inside.")
    end
  )
end

ESXOpenKeysMenu = function(d)
  local elements = {
    [1] = {label = Labels['GiveKeys'],value = "Give"},
    [2] = {label = Labels['TakeKeys'],value = "Take"}
  }
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_keys_menu",{
      title    = Labels['HouseKeys'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      if submitData.current.value == "Give" then
        ESXGiveKeysMenu(d)
      elseif submitData.current.value == "Take" then
        ESXTakeKeysMenu(d)
      end
    end,
    function(data,menu)
      menu.close()
    end
  )
end

ESXGiveKeysMenu = function(d)
  local elements = {}
  local players = GetNearbyPlayers(GetEntityCoords(PlayerPedId()),100.0)
  local c = 0
  for _,player in pairs(players) do
    if player ~= PlayerId() then
      table.insert(elements,{label = GetPlayerName(player).." [ID:"..player.."]",value = GetPlayerServerId(player)})
    end
  end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_givekeys_menu",{
      title    = Labels['GiveKeys'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      GiveKeys(d,submitData.current.value)
    end,
    function(data,menu)
      menu.close()
    end
  )
end

ESXTakeKeysMenu = function(d)
  local elements = {}
  local players = GetNearbyPlayers(d.Entry,10.0)
  local c = 0

  for identifier, playerName in pairs(d.HouseKeys) do
    table.insert(elements, {label = playerName, value = identifier})
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_takekeys_menu",{
      title    = Labels['TakeKeys'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      TakeKeys(d,submitData.current.value)
    end,
    function(data,menu)
      menu.close()
    end
  )
end

ESXExitOwnerMenu = function(d)
  local elements = {}
  if Config.UseHouseInventory then
    if Config.AllowHouseSales then
      if d.Shell then
        elements = {
          -- {label = Labels["InviteInside"],value = "Invite"},
          {label = Labels["HouseKeys"],value = "Keys"},
          -- {label = Labels["UpgradeShell"],value = "Upgrade"},
          {label = Labels["SellHouse"],value = "Sell"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["SetWardrobe"],value = "Wardrobe"},
          {label = Labels["SetInventory"],value = "Inventory"},
          {label = (d.Unlocked and Labels["LockDoor"] or Labels["UnlockDoor"]),value = (d.Unlocked and "Lock" or "Unlock")},
          {label = Labels["LeaveHouse"],value = "Leave"},
        }
      else
        elements = {
          {label = Labels["HouseKeys"],value = "Keys"},
          {label = Labels["SellHouse"],value = "Sell"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["SetWardrobe"],value = "Wardrobe"},
          {label = Labels["SetInventory"],value = "Inventory"},
        }
      end
      if (d.MortgageOwed and d.MortgageOwed >= 1) then
        table.insert(elements,#elements,{label = "Mortgage", value = "Mortgage"})
      end
    else
      if d.Shell then
        elements = {
          -- {label = Labels["InviteInside"],value = "Invite"},
          {label = Labels["HouseKeys"],value = "Keys"},
          -- {label = Labels["UpgradeShell"],value = "Upgrade"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["SetWardrobe"],value = "Wardrobe"},
          {label = Labels["SetInventory"],value = "Inventory"},
          {label = (d.Unlocked and Labels["LockDoor"] or Labels["UnlockDoor"]),value = (d.Unlocked and "Lock" or "Unlock")},
          {label = Labels["LeaveHouse"],value = "Leave"},
        }
      else
        elements = {
          {label = Labels["HouseKeys"],value = "Keys"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["SetWardrobe"],value = "Wardrobe"},
          {label = Labels["SetInventory"],value = "Inventory"},
        }
      end
      if (d.MortgageOwed and d.MortgageOwed >= 1) then
        table.insert(elements,#elements,{label = "Mortgage", value = "Mortgage"})
      end
    end
  else
    if Config.AllowHouseSales then    
      if d.Shell then
        elements = {
          -- {label = Labels["InviteInside"],value = "Invite"},
          {label = Labels["HouseKeys"],value = "Keys"},
          -- {label = Labels["UpgradeShell"],value = "Upgrade"},
          {label = Labels["SellHouse"],value = "Sell"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["Wardrobe"],value = "Wardrobe"},
          {label = (d.Unlocked and Labels["LockDoor"] or Labels["UnlockDoor"]),value = (d.Unlocked and "Lock" or "Unlock")},
          {label = Labels["LeaveHouse"],value = "Leave"},
        }
      else
        elements = {
          {label = Labels["HouseKeys"],value = "Keys"},
          {label = Labels["SellHouse"],value = "Sell"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["SetWardrobe"],value = "Wardrobe"},
        }
      end
      if (d.MortgageOwed and d.MortgageOwed >= 1) then
        table.insert(elements,#elements,{label = "Mortgage", value = "Mortgage"})
      end
    else
      if d.Shell then
        elements = {
          -- {label = Labels["InviteInside"],value = "Invite"},
          {label = Labels["HouseKeys"],value = "Keys"},
          -- {label = Labels["UpgradeShell"],value = "Upgrade"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["Wardrobe"],value = "Wardrobe"},
          {label = (d.Unlocked and Labels["LockDoor"] or Labels["UnlockDoor"]),value = (d.Unlocked and "Lock" or "Unlock")},
          {label = Labels["LeaveHouse"],value = "Leave"},
        }
      else
        elements = {
          {label = Labels["HouseKeys"],value = "Keys"},
          {label = Labels["SellHouse"],value = "Sell"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["SetWardrobe"],value = "Wardrobe"},
        }
      end
      -- if (d.MortgageOwed and d.MortgageOwed >= 1) then
      --   table.insert(elements,#elements,{label = Labels["Mortgage"], value = "Mortgage"})
      -- end
    end
  end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_owner_menu",{
      title    = Labels['MyHouse'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      if      (submitData.current.value == "Invite")    then
        ESXOpenInviteMenu(d)
      elseif  (submitData.current.value == "Keys")      then
        ESXOpenKeysMenu(d)
      elseif  (submitData.current.value == "Upgrade")   then        
        ESXUpgradeMenu(d,true)
      elseif  (submitData.current.value == "Sell")      then
        SellHouse(d)
      elseif  (submitData.current.value == "Furni")     then
        OpenFurniture(d)
      elseif  (submitData.current.value == "Wardrobe")  then
        SetWardrobe(d)
      elseif  (submitData.current.value == "Inventory") then
        SetInventory(d)
      elseif  (submitData.current.value == "Leave")     then
        LeaveHouse(d)
      elseif  (submitData.current.value == "Unlock")    then
        UnlockHouse(d)
      elseif  (submitData.current.value == "Lock")      then
        LockHouse(d)
      elseif  (submitData.current.value == "Mortgage")  then
        ESXPayMortgageMenu(d)
      end
    end,
    function(data,menu)
      menu.close()
    end
  )
end

ESXExitOwnedMenu = function(d)
  local elements = {}
  local identifier = GetPlayerIdentifier()
  
  if d.HouseKeys[identifier] then
    -- if d.Shell then
    --   table.insert(elements,{label = Labels['InviteInside'],value = "Invite"})
    -- end
    table.insert(elements, {label = Labels['FurniUI'],value = "Furni"})
    -- table.insert(elements, {label = Labels['Mortgage'],value = "Mortgage"})
    table.insert(elements, {label = (d.Unlocked and Labels["LockDoor"] or Labels["UnlockDoor"]),value = (d.Unlocked and "Lock" or "Unlock")})
  end

  if d.Shell then
    table.insert(elements,{label = Labels['LeaveHouse'],value = "Leave"})
  -- elseif d.MortgageOwed and d.MortgageOwed > 0 then
  --   local job = GetPlayerJobName()
  --   if Config.CreationJobs[job] then
  --     if GetPlayerJobRank() >= Config.CreationJobs[job].minRank then
  --       table.insert(elements,{label = Labels['Mortgage'],value = "CheckMortgage"})
  --     end
  --   end
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_owned_menu",{
      title    = Labels['PlayerHouse'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      if      (submitData.current.value == "Invite")        then
        ESXOpenInviteMenu(d)
      elseif  (submitData.current.value == "Furni")         then
        OpenFurniture(d)
      elseif  (submitData.current.value == "Lock")          then
        LockHouse(d)
      elseif  (submitData.current.value == "Unlock")        then
        UnlockHouse(d)
      elseif  (submitData.current.value == "Leave")         then
        LeaveHouse(d)
      elseif  (submitData.current.value == "Mortgage")      then
        ESXPayMortgageMenu(d)
      elseif  (submitData.current.value == "CheckMortgage") then
        ESXMortgageInfoMenu(d)
      end
    end,
    function(data,menu)
      menu.close()
    end
  )
end

ESXExitEmptyMenu = function(d)
  local elements = (d.Shell and {[1] = {label = Labels['LeaveHouse'],value = "Leave"}} or {})

  if d.Owned and d.Shell then
    local certifiedPolice = false
    local job = GetPlayerJobName()
    if Config.PoliceJobs[job] then
      if GetPlayerJobRank() >= Config.PoliceJobs[job].minRank then
        certifiedPolice = true
      end
    end

    if Config.PoliceCanRaid and certifiedPolice then
      if d.Unlocked then
        table.insert(elements,{label = Labels['LockHouse'],value = "Lock"})
      else
        table.insert(elements,{label = Labels['UnlockHouse'],value = "Unlock"})
      end
    end
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_empty_menu",{
      title    = Labels['EmptyHouse'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      if submitData.current.value == "Leave" then
        LeaveHouse(d)
      elseif submitData.current.value == "Lock" then
        LockHouse(d)
      elseif submitData.current.value == "Unlock" then
        UnlockHouse(d)
      end
    end,
    function(data,menu)
      menu.close()
    end
  )
end

ESXUpgradeMenu = function(d,owner)
  local elements = {}
  local c = 0
  local dataTable = {}
  local sortedTable = {}
  for k,v in pairs(d.Shells) do
    local price = ShellPrices[k]
    if price then
      dataTable[price.."_"..k] = {
        available = v,
        price = price,
        shell = k,
      }
      table.insert(sortedTable,price.."_"..k)
    end
  end
  table.sort(sortedTable)

  for key,price in pairs(sortedTable) do
    local data = dataTable[price]
    if data.available and d.Shell ~= data.shell then
      elements[#elements+1] = {label = data.shell.." [$"..data.price.."]", data = data}
      c = c + 1
    end    
  end

  if c == 0 then
    ShowNotification(Labels['NoUpgrades'])
    return
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "owner_upgrade_menu",{
      title    = Labels['UpgradeHouse2'],
      align    = 'left',
      elements = elements,
    },function(data,menu) 
      if owner then
        UpgradeHouse(d,data.current.data)
      end
    end,
    function(data,menu)
      menu.close()
    end
  )
end

DoOpenESXGarage = function(d)
  local vehicles = GetVehiclesAtHouse(d)

  local elements = {}
  if (#vehicles > 0) then
    for _,vehData in pairs(vehicles) do
      table.insert(elements,{label = "["..vehData.vehicle.plate.."] "..GetVehicleLabel(vehData.vehicle.model), value = vehData})
    end
  else
    table.insert(elements,{label = Labels['NoVehicles']})
  end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "entry_owner_menu",{
      title    = "Player Garage",
      align    = 'left',
      elements = elements,
    }, 
    (#vehicles > 0 and function(submitData,submitMenu)
      SpawnVehicle(d.Garage,submitData.current.value.vehicle.model,submitData.current.value.vehicle, d.Id)
    end or false),
    function(data,menu)
      menu.close()
    end,
    function(...)
    end,
    function(...)
      MenuOpen = false
      FreezeEntityPosition(PlayerPedId(),false)
    end
  )
end

ESXGarageOwnerMenu = function(d)
  local ped = PlayerPedId()
  if IsPedInAnyVehicle(ped,false) then
      exports.esx_advancedgarage:StoreOwnedCarsMenu()
      MenuOpen = false
      FreezeEntityPosition(PlayerPedId(),false)
  else
      GetPlayerVehicle(d)
  end
end

function GetPlayerVehicle(d)
  local elements = {}

    ESX.TriggerServerCallback('esx_advancedgarage:getOwnedCars', function(ownedCars)
        if #ownedCars == 0 then
            ESX.Alert('Shoma hich mashini dar garage nadarid', "info")
        else
            for _,v in pairs(ownedCars) do
                local hashVehicule = v.vehicle.model
                if hashVehicule and IsModelInCdimage(hashVehicule) then
                    local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule)
                    if vehicleName == "Unknown" then
                        vehicleName = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(hashVehicule))
                    end
                    if vehicleName == "Unknown" then
                        vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
                    end
                    local plate        = v.plate
                    local labelvehicle

                    if v.stored then
                        labelvehicle = '| '..plate..' | '..vehicleName..' | [✔️] '
                    elseif v.imp then
                        labelvehicle = '| '..plate..' | '..vehicleName..' | <span style="color:red; border-bottom: 1px solid red;">Police Impound</span>'
                    else
                        labelvehicle = '| '..plate..' | '..vehicleName..' | [❌] '
                    end
                
                    table.insert(elements, {label = labelvehicle, value = v})
                end
            end
        
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car', {
                title    = "Garage Cars",
                align    = 'top-left',
                elements = elements
            }, function(data, menu)
                if not data.current.value.imp then
                    if data.current.value.stored then
                        MenuOpen = false
                        FreezeEntityPosition(PlayerPedId(),false)
                        menu.close()
                        Wait(math.random(0, 500))
                        local foundSpawn, spawnPoint = true, {coords = vector3(d.Garage.x, d.Garage.y, d.Garage.z), heading = d.Garage.w}
                        if foundSpawn then
                        --ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle, damages)
                        local damages = data.current.value.damages
                        local vehicle = data.current.value.vehicle
                        ESX.Game.SpawnVehicle(vehicle.model, spawnPoint.coords, spawnPoint.heading, function(callback_vehicle)
                            vehicle.plate = data.current.value.plate
                            ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
                            ESX.CreateVehicleKey(callback_vehicle)
                            SetVehRadioStation(callback_vehicle, "OFF")
                            SetVehicleDoorShut(callback_vehicle, 0, false)
                            SetVehicleDoorShut(callback_vehicle, 1, false)
                            SetVehicleDoorShut(callback_vehicle, 2, false)
                            SetVehicleDoorShut(callback_vehicle, 3, false)
                            SetVehicleDoorShut(callback_vehicle, 4, false)
                            SetVehicleDoorShut(callback_vehicle, 5, false)
                            TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
                            exports.esx_advancedgarage:setDamages(callback_vehicle, damages)
                        end)
                        TriggerEvent("diamond_housing:garage", data.current.value.plate, false)
                --end, data.current.value.plate)
                        else
                            ESX.Alert("mahal spawn mashin ra khali konid")
                        end
                    else
                        ESX.Alert("In Mashin Dar Impound Ast", "error")
                    end
                else
                    ESX.Alert("Mashin Dar Impound Police Ast, Be Edare Police Morajee Konid", "info")
                end
            end, function(data, menu)
                menu.close()
            end, function(data, menu)
            
            end, function()
                MenuOpen = false
                FreezeEntityPosition(PlayerPedId(),false)
            end)
        end
    end)
end

ESXGarageOwnedMenu = function(d)
  local plyPed = PlayerPedId()  
  if IsPedInAnyVehicle(plyPed,false) then
    local veh = GetVehiclePedIsUsing(plyPed)
    local props = GetVehicleProperties(veh)
    local ownerInfo = Callback("Allhousing:GetVehicleOwner",props.plate)
    local canStore = false
    if ownerInfo.owned and ownerInfo.owner then
      canStore = true
    elseif ownerInfo.owned and Config.StoreStolenPlayerVehicles then
      canStore = true
    else
      canStore = false
    end

    if canStore then
      ESX.TriggerServerCallback('mf_housing:canStore', function(canStore2)
        if canStore2 == 0 then
          local netid = VehToNet(veh)
          -- local engineHealth = GetVehicleEngineHealth(veh)
          
          local data = {house = d.Id, plate = props.plate, dynamics = ESX.Game.GetVehicleDynamicVariables(veh), netid = netid}
          -- if engineHealth < 990 then
					-- 	calculateCost(engineHealth, veh, data)
					-- else
						storeVehicle(veh, data)
          -- end
          
        else
          ESX.ShowNotification("Garage in khane jaye khali narad, maximum: ~o~" .. canStore2)
        end
      end, d.Id)
    else
      ShowNotification(Labels["CantStoreVehicle"])
    end
    FreezeEntityPosition(PlayerPedId(),false)
  else
    local myId = GetPlayerIdentifier()
    if d.HouseKeys[myId] then
        --DoOpenESXGarage(d)
        return
    end

    if not Config.GarageTheft then 
      FreezeEntityPosition(PlayerPedId(),false)
      return
    end

    if Config.LockpickRequired then
      local hasItem = CheckForLockpick()
      if not hasItem then
        ShowNotification(Labels['NoLockpick'])
        FreezeEntityPosition(PlayerPedId(),false)
        return
      end
    end

    while not HasAnimDictLoaded("mini@safe_cracking") do RequestAnimDict("mini@safe_cracking"); Citizen.Wait(0); end
    TaskPlayAnim(plyPed, "mini@safe_cracking", "idle_base", 1.0, 1.0, -1, 1, 0, 0, 0, 0 ) 
    Wait(2000)

    if Config.UsingLockpickV1 then
      TriggerEvent("lockpicking:StartMinigame",4,function(didWin)
        if didWin then
          ClearPedTasksImmediately(plyPed)
          DoOpenESXGarage(d)
        else
          ClearPedTasksImmediately(plyPed)
          TriggerServerEvent("Allhousing:BreakLockpick")
        end
        FreezeEntityPosition(PlayerPedId(),false)
      end)
    elseif Config.UsingLockpickV2 then
      exports["lockpick"]:Lockpick(function(didWin)
        if didWin then
          ClearPedTasksImmediately(plyPed)
          DoOpenESXGarage(d)
          ShowNotification(Labels["LockpickSuccess"])
        else
          ClearPedTasksImmediately(plyPed)
          TriggerServerEvent("Allhousing:BreakLockpick")
          ShowNotification(Labels["LockpickFailed"])
        end
        FreezeEntityPosition(PlayerPedId(),false)
      end)
    else
      if Config.UsingProgressBars then
        exports["esx_basicneeds"]:startUI(Config.LockpickTime * 1000,Labels["ProgressLockpicking"])
      end
      Wait(Config.LockpickTime * 1000)
      if math.random(100) < Config.LockpickFailChance then
        local plyPos = GetEntityCoords(PlayerPedId())
        local zoneName = GetNameOfZone(plyPos.x,plyPos.y,plyPos.z)
        if Config.LockpickBreakOnFail then
          TriggerServerEvent("Allhousing:BreakLockpick")
        end
        ShowNotification(Labels["LockpickFailed"])
        for k,v in pairs(Config.PoliceJobs) do
          TriggerServerEvent("Allhousing:NotifyJobs",k,"Someone is attempting to break into a garage at "..zoneName)
        end
        ClearPedTasksImmediately(plyPed)
      else
        ShowNotification(Labels["LockpickSuccess"])
        ClearPedTasksImmediately(plyPed)
        DoOpenESXGarage(d)
      end
      FreezeEntityPosition(PlayerPedId(),false)
    end
  end
end

ESXEntryOwnerMenu = function(d)
  local elements
  if Config.AllowHouseSales then
    if d.Garage and Config.AllowGarageMovement then
      if d.Shell then
        elements = {
          [1] = {label = Labels['EnterHouse']},
          -- [2] = {label = Labels['UpgradeHouse2']},
          [2] = {label = (d.Unlocked and Labels['LockDoor'] or Labels['UnlockDoor'])},
          [3] = {label = Labels['MoveGarage']},
          [4] = {label = Labels['SellHouse']},
        }
      else
        elements = {
          [1] = {label = Labels['MoveGarage']},
          [2] = {label = Labels['SellHouse']},
        }
      end
    else
      if d.Shell then
        elements = {
          [1] = {label = Labels['EnterHouse']},
          -- [2] = {label = Labels['UpgradeHouse2']}
          [2] = {label = (d.Unlocked and Labels['LockDoor'] or Labels['UnlockDoor'])},
          [3] = {label = Labels['SellHouse']},
          [4] = {label = "Pets"},
          [5] = {label = "Delete Kardan Tamam Vasayel"},
        }
      else
        elements = {
          [1] = {label = Labels["SellHouse"]},
        }
      end
    end
  else
    if d.Garage and Config.AllowGarageMovement then
      if d.Shell then
        elements = {
          [1] = {label = Labels['EnterHouse']},
          -- [1] = {label = Labels['UpgradeHouse2']},
          [2] = {label = (d.Unlocked and Labels['LockDoor'] or Labels['UnlockDoor'])},
          [3] = {label = Labels['MoveGarage']},
        }
      else
      end
    else
      if d.Shell then
        elements = {
          [1] = {label = Labels['EnterHouse']},
          -- [2] = {label = Labels['UpgradeHouse2']},
          [2] = {label = (d.Unlocked and Labels['LockDoor'] or Labels['UnlockDoor'])},
        }
      else
        elements = {
          [1] = {label = Labels["NothingToDisplay"]}
        }
      end
    end
  end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), "entry_owner_menu",{
        title    = Labels['MyHouse'],
        align    = 'left',
        elements = elements,
    },function(submitData,submitMenu)
        if (submitData.current.label == Labels["NothingToDisplay"]) then
            menu.close()
        elseif (submitData.current.label == Labels["EnterHouse"]) then
            EnterHouse(d, false)
        elseif (submitData.current.label == Labels["UpgradeHouse2"]) then
            ESXUpgradeMenu(d,true)
        elseif (submitData.current.label == Labels["SellHouse"]) then  
            SellHouse(d)   
        elseif (submitData.current.label == Labels["LockDoor"]) then
            LockHouse(d)
        elseif (submitData.current.label == Labels["UnlockDoor"]) then
            UnlockHouse(d)
        elseif (submitData.current.label == Labels["MoveGarage"]) then
            MoveGarage(d)
        elseif (submitData.current.label == "Pets") then
            ESX.TriggerServerCallback("diamond_housing:DoesHaveApartment", function(y, p, s, z, h)
                if #z > 0 then
                    OpenPetsMenu(z, h)
                    ESX.UI.Menu.CloseAll()
                else
                    ESX.Alert("Shoma Hich Heyvan Khanegi Nadarid", "error")
                end
            end, 1)
        elseif (submitData.current.label == "Delete Kardan Tamam Vasayel") then
            ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'remove_furni',
            {
                title 	 = 'Hazf Vasayel Khane',
                align    = 'center',
                question = "Aya Mikhahid Tamami Vasayel Khane Ra Pak Konid?",
                elements = {
                    {label = 'Kheyr', value = 'no'},
                    {label = 'Bale', value = 'yes'},
                }
            }, function(data2, menu2)
                if data2.current.value == "yes" then
                    TriggerServerEvent("diamond_housing:removeAllFurni", tonumber(d.Id))
                end
                ESX.UI.Menu.CloseAll()
            end)
        end
    end,function(data,menu)
        menu.close()
    end,function(...)

    end,function(...)
        MenuOpen = false
        FreezeEntityPosition(PlayerPedId(),false)
    end)
end

ESXConfirmSaleMenu = function(d,floored)
  local elements = {
    [1] = {label = Labels['ConfirmSale'], value = "yes"},
    [2] = {label = Labels['CancelSale'], value = "no"}
  }
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_verify_sell",{
      title    = string.format(Labels["SellingHouse"],floored),
      align    = 'left',
      elements = elements,
    }, 
    function(data,menu)
      if (data.current.value == "yes") then
        ShowNotification(string.format(Labels["SellingHouse"],floored))
        d.Owner = ""
        d.Owned = false

        if InsideHouse then LeaveHouse(d); end
        TriggerServerEvent("Allhousing:SellHouse",d,floored)
      end
      ESX.UI.Menu.CloseAll()
    end
  )
end

ESXEntryOwnedMenu = function(d)
  local hasKeys = false
  local identifier = GetPlayerIdentifier()
  if d.HouseKeys[identifier] then
      hasKeys = true
  end

  local certifiedPolice = false
  local job = GetPlayerJobName()
  if Config.PoliceJobs[job] then
    if GetPlayerJobRank() >= Config.PoliceJobs[job].minRank then
      certifiedPolice = true
    end
  end

  local certifiedRealestate = false
  if Config.CreationJobs[job] then
    if GetPlayerJobRank() >= Config.CreationJobs[job].minRank then
      certifiedRealestate = true
    end
  end

  local elements = {}

  if d.Shell then
    if hasKeys or d.Unlocked then
      table.insert(elements,{label = Labels['EnterHouse'],value = "Enter"})
      if hasKeys then
        table.insert(elements,{label = (d.Unlocked and Labels["LockDoor"] or Labels["UnlockDoor"]), value = (d.Unlocked and "Lock" or "Unlock")})
      end
    elseif certifiedPolice then
      table.insert(elements,{label = Labels['KnockHouse'],value = "Knock"})
      if Config.PoliceCanRaid then
        table.insert(elements,{label = Labels['RaidHouse'],value = "Raid"})
      end
    else
      table.insert(elements,{label = Labels['KnockHouse'],value = "Knock"})
      if Config.HouseTheft then
        table.insert(elements,{label = Labels['BreakIn'],value = "Break In"})
      end
    end
  end

  -- if certifiedRealestate and d.MortgageOwed and d.MortgageOwed > 0 then
  --   table.insert(elements,{label = Labels['Mortgage'],value = "Mortgage"})
  -- end

  if #elements <= 0 then
    FreezeEntityPosition(PlayerPedId(),false)
    return
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "entry_owner_menu",{
      title    = Labels['PlayerHouse'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      if (submitData.current.value == "Enter") then
        -- EnterHouse(d,(not hasKeys and true or false))
        EnterHouse(d, false)
      elseif (submitData.current.value == "Knock") then
        KnockOnDoor(d)
      elseif (submitData.current.value == "Raid") then  
        RaidHouse(d)      
      elseif (submitData.current.value == "Break In") then
        BreakInHouse(d)
      elseif (submitData.current.value == "Mortgage") then        
        ESXMortgageInfoMenu(d)
      elseif  (submitData.current.value == "Unlock") then
        UnlockHouse(d)
      elseif  (submitData.current.value == "Lock") then
        LockHouse(d)
      end
    end,
    function(data,menu)
      menu.close()
    end,
    function(...)
    end,
    function(...)
      MenuOpen = false
      FreezeEntityPosition(PlayerPedId(),false)
    end
  )
end

ESXMortgageInfoMenu = function(d)
  local mortgage_info = Callback("Allhousing:GetMortgageInfo",d)
  local elements = {
    {label = string.format(Labels["MoneyOwed"],tostring(mortgage_info.MortgageOwed))},
    {label = string.format(Labels['LastRepayment'],tostring(mortgage_info.LastRepayment))},
    {label = "Revoke Tenancy", value = "Revoke"}
  }

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "mortgage_menu",{
      title    = Labels['MortgageInfo'],
      align    = 'left',
      elements = elements,
    }, 
    function(data,menu)
      if (data.current.value and data.current.value == "Revoke") then
        RevokeTenancy(d)
      end
    end,
    function(data,menu)
      menu.close()
    end,
    function(...)
    end,
    function(...)
    end
  )
end

ESXPayMortgageMenu = function(d)
  local mortgage_info = Callback("Allhousing:GetMortgageInfo",d)
  local elements = {
    {label = string.format(Labels["MoneyOwed"],tostring(mortgage_info.MortgageOwed))},
    {label = string.format(Labels['LastRepayment'],tostring(mortgage_info.LastRepayment))},
    {label = Labels['PayMortgage'], value = "Pay"}
  }

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "mortgage_menu",{
      title    = Labels['MortgageInfo'],
      align    = 'left',
      elements = elements,
    }, 
    function(data,menu)
      if data.current.value and data.current.value == "Pay" then
        menu.close()
        RepayMortgage(d)
      end
    end,
    function(data,menu)
      menu.close()
    end,
    function(...)
    end,
    function(...)
    end
  )
end

ESXEntryEmptyMenu = function(d)
  local elements = {}
  if d.ResaleJob and d.ResaleJob:len() > 0 and Config.AllowMortgage then
    if d.Shell then
      elements = {
        [1] = {label = Labels['Buy'].." [$"..d.Price.."]", value = "Buy"},
        [2] = {label = Labels['Mortgage'].." [$"..math.floor((d.Price / 100)*Config.MortgagePercent).."]", value='Mortgage'},
        [3] = {label = Labels['View'], value = "View"},
        -- [4] = {label = Labels['Upgrades'], value = "Upgrades"},
      }
    else
      elements = {
        [1] = {label = Labels['Buy'].." [$"..d.Price.."]", value = "Buy"},
        [2] = {label = Labels['Mortgage'].." [$"..math.floor((d.Price / 100)*Config.MortgagePercent).."]", value='Mortgage'}
      }
    end
  else
    if d.Shell then
      elements = {
        [1] = {label = Labels['Buy'].." [$"..d.Price.."]", value = "Buy"},
        [2] = {label = Labels['View'], value = "View"},
        -- [3] = {label = Labels['Upgrades'], value = "Upgrades"},
      }
    else
      elements = {
        [1] = {label = Labels['Buy'].." [$"..d.Price.."]", value = "Buy"}
      }
    end
  end

  if d.Owner and d.Owner:len() > 1 and d.Owner == GetPlayerIdentifier()  then
    table.insert(elements, {label = "Cancel Sell", value = "cancelsell"})
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "entry_empty_menu",{
      title    = Labels['EmptyHouse'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      submitMenu.close()
      if (submitData.current.value == "Buy") then
        BuyHouse(d)
      elseif (submitData.current.value == "View") then
        ViewHouse(d)
      elseif (submitData.current.value == "Upgrades") then  
        ESXUpgradeMenu(d,false)      
      elseif (submitData.current.value == "Mortgage") then
        MortgageHouse(d)
      elseif (submitData.current.value == "cancelsell") then
        TriggerServerEvent("Allhousing:CancelSell", d)
      end
    end,
    function(data,menu)
      menu.close()
    end,
    function()
    end,
    function()
      MenuOpen = false
      FreezeEntityPosition(PlayerPedId(),false)
    end
  )
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        if MenuOpen then
            local selfCoord = GetEntityCoords(PlayerPedId())
            if Vdist(selfCoord, MenuOpen) >= 1 then
                MenuOpen = false
                ESX.UI.Menu.CloseAll()
            end
        else
          Citizen.Wait(750)
        end
    end
end)