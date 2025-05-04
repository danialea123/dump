---@diagnostic disable: undefined-field, missing-parameter, undefined-global, param-type-mismatch
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Wait(0)
  end
end)

InSpectatorMode	= false
TargetSpectate	= nil
spec = {}
local LastPosition		= nil
local polarAngleDeg		= 0;
local azimuthAngleDeg	= 90;
local radius			    = -3.5;
local cam 				    = nil
local ShowInfos			  = false

local pressed = false
local star = false

function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
	local polarAngleRad   = polarAngleDeg   * math.pi / 180.0
	local azimuthAngleRad = azimuthAngleDeg * math.pi / 180.0

	local pos = {
		x = entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)),
		y = entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)),
		z = entityPosition.z - radius * math.cos(azimuthAngleRad)
	}

	return pos
end

function spectate(serverid)
	if GetPlayerServerId(PlayerId()) == serverid then
	  return
	end

  if not InSpectatorMode then
    LastPosition = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('SRAdmin:SpectStatus', true)
    Wait(250)
	else
    NetworkSetInSpectatorMode(false, 0)
    TargetSpectate = nil
	  local playerPed = PlayerPedId()
    DetachEntity(playerPed, true, true)
	  SetEntityCompletelyDisableCollision(playerPed, true, true)
  end

  ESX.TriggerServerCallback('SRAdmin:GetTargetPosition', function(coords)
    ESX.TriggerServerCallback('SRAdmin:SyncBucket', function()
      SetEntityVisible(PlayerPedId(), false)
      SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z-50.0)
      local Timer = GetGameTimer()
      while not ESX.Game.DoesPlayerExistInArea(serverid) or (GetGameTimer() - Timer > 10000)  do
        Wait(1)
      end
      if not ESX.Game.DoesPlayerExistInArea(serverid) then return end
      local pl  = GetPlayerFromServerId(serverid)
      local pl2 = GetPlayerPed(pl)

      local Timer = GetGameTimer()
      while not DoesEntityExist(pl2) or (GetGameTimer() - Timer > 5000) do 
        Wait(0)
        pl2 = GetPlayerPed(pl)
      end

      if DoesEntityExist(pl2) then
        NetworkSetInSpectatorMode(true, pl2)
        InSpectatorMode = true
        TargetSpectate = serverid
        star = true
        DoSpecThread()
      else
        resetNormalCamera()
      end
    end, serverid)
	end, serverid)
end

function resetNormalCamera()
    local playerPed = PlayerPedId()
    InSpectatorMode = false
    spec[lastspec] = false
        TargetSpectate  = nil
    lastspec = 0
    sp = 0

    NetworkSetInSpectatorMode(false, 0)
    DetachEntity(playerPed, true, true)
    SetEntityCoords(playerPed, LastPosition)

    TriggerServerEvent('SRAdmin:ResetBucket')


    if not invisibility then
        SetEntityVisible(playerPed, true)
    end
    SetEntityVisible(playerPed, true)
    SetEntityCompletelyDisableCollision(playerPed, true, true)

    SetTimeout(500, function()
        TriggerServerEvent('SRAdmin:SpectStatus', nil)
    end)
    
    pressed = false
    star = false
end

function OpenAdminActionMenu(player)
  WarMenu.Visible(false)
  ESX.TriggerServerCallback('esx_spectate:getOtherPlayerData', function(data)

    local jobLabel    = nil
    local gangLabel    = nil
    local idLabel     = nil
    local Money		= 0
    local Bank		= 0
    local Inventory	= nil

    if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
      jobLabel = 'Job : ' .. data.job.label .. ' - [' .. data.job.grade .. "] " .. data.job.grade_label
    else
      jobLabel = 'Job : ' .. data.job.label
    end

    if data.gang.grade_label ~= nil and  data.gang.grade_label ~= '' then
      gangLabel = 'Gang : ' .. data.gang.name .. ' - [' .. data.gang.grade .. '] ' .. data.gang.grade_label
    else
      gangLabel = 'Gang : ' .. data.gang.name
    end

    if data.money ~= nil then
      Money = data.money
    else
      Money = 'No Data'
    end

    if data.bank ~= nil then
      Bank = data.bank
    else
      Bank = 'No Data'
    end

    if data.name ~= nil then
      idLabel = 'Steam ID : ' .. data.identifier
    else
      idLabel = 'Steam ID : Unknown'
    end

    local elements = {
      {label = 'Name: ' .. string.gsub(data.name, "_", " "), value = nil},
      {label = 'Money: '.. data.money, value = nil},
      {label = 'Black Money: '.. data.black_money or "No Data", value = nil},
      {label = 'Bank: '.. data.bank, value = nil},
      {label = 'dCoin: '.. data.Coin, value = nil},
      {label = jobLabel,      value = nil},
      {label = gangLabel,     value = nil},
      {label = idLabel,       value = nil},
      {label = "House ID: "..exports.diamond_housing:GetHouseIdByIdentifier(data.identifier), value = nil},
      {label = 'Vehicles',    value = 'GetVehicles'},
      {label = 'Properties',  value = 'GetProperties'},
      {label = 'Weapons',     value = 'Weapons'},
      {label = 'Inventory',   value = 'Inventory'},
    }

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'citizen_interaction',
      {
        title    = 'Player Control',
        align    = 'top-left',
        elements = elements,
      },
      function(mData, menu)
        if mData.current.value == 'GetVehicles' then
          ESX.TriggerServerCallback('esx_advancedgarage:getOwnedCars', function(ownedCars, spawn)
            if ownedCars then
              GetVehicles(ownedCars, spawn, GetPlayerServerId(player))
            else
              ESX.Alert('Shoma be in bakhsh dastresi nadarid ya player morede nazar mashini nadarad')
            end
          end, GetPlayerServerId(player))
        elseif mData.current.value == 'GetProperties' then
          ExecuteCommand("openproperty "..data.identifier)
        elseif mData.current.value == 'Weapons' then
          local elements = {}
          for i=1, #data.loadout, 1 do
            table.insert(elements, {
              label          = ESX.GetWeaponLabel(data.loadout[i].name) .. ' : ' .. data.loadout[i].ammo,
              value          = data.loadout[i].name,
              -- itemType       = 'item_weapon',
              -- amount         = data.ammo,
            })
          end

          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_wep', {
            title    = 'Weapons',
            align    = 'top-left',
            elements = elements
          }, function(data2, menu2)
              TriggerServerEvent("esx_AdminMenu:RemoveWeapon", GetPlayerServerId(player), data2.current.value)
              ESX.Alert("~y~Shoma Yek Gun Az Player Bardashtid")
              menu2.close()
              Wait(5000)
              OpenAdminActionMenu(player)
          end, function(data2, menu2)
            menu2.close()
          end)
        elseif mData.current.value == 'Inventory' then
          local elements = {}
          for i=1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
              table.insert(elements, {
                label          = data.inventory[i].label .. ' x ' .. data.inventory[i].count,
                value          = data.inventory[i].name,
                itemType       = 'item_standard',
                amount         = data.inventory[i].count,
              })
            end
          end

          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_inv', {
            title    = 'Inventory',
            align    = 'top-left',
            elements = elements
          }, function(data2, menu2)
              TriggerServerEvent("esx_AdminMenu:RemoveItem", GetPlayerServerId(player), data2.current.value)
              ESX.Alert("~y~Shoma Yek Item Az Player Bardashtid")
              menu2.close()
              Wait(5000)
              OpenAdminActionMenu(player)
          end, function(data2, menu2)
            menu2.close()
          end)
        end
      end, function(data, menu)
        menu.close()
        WarMenu.Visible(true)
      end)
  end, GetPlayerServerId(player))
end

--[[RegisterNetEvent('SRAdmin:PlayerVehicleList')
AddEventHandler('SRAdmin:PlayerVehicleList', function(ownedCars)
  if GetInvokingResource() then return end
  GetVehicles(ownedCars, 10)
end)]]

function GetVehicles(ownedCars, spawn, player)
  local elements = {}
  if #ownedCars == 0 then
    ESX.Alert('Mashini dar garage nadarad')
    return
  else
    for _,v in pairs(ownedCars) do
      local hashVehicule = v.vehicle.model
      local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
      local vehicleName  = GetLabelText(aheadVehName)
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
      if spawn >= 5 then table.insert(elements, {label = 'Spawn Vehicle', value = 'spawn_car'}) end
      table.insert(elements, {label = 'Vehicle Inventory', value = 'car_inventory'})

      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_player_car_option', {
        title    = 'What do you want to do?',
        align    = 'top-left',
        elements = elements
      }, function(data3, menu3)
          menu3.close()
          if data3.current.value == 'spawn_car' then
            if InSpectatorMode then
              resetNormalCamera()
              Wait(1000)
            else
              if IsPedInAnyVehicle(PlayerPedId(), false) then
                ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
              end
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

RegisterNetEvent('es_admin:teleportUser')
AddEventHandler('es_admin:teleportUser', function(x, y, z)
  if InSpectatorMode then
	  InSpectatorMode = false
	  NetworkSetInSpectatorMode(false, 0)
	  spec[lastspec] = false
	  lastspec = 0
	  TargetSpectate  = nil
	  local playerPed = PlayerPedId()
	  DetachEntity(playerPed, true, true)
	  SetEntityCompletelyDisableCollision(playerPed, true, true)
	  if not invisibility then
      SetEntityVisible(playerPed, true)
    end
    TriggerServerEvent('SRAdmin:SpectStatus', nil)
  end
end)

function DoSpecThread()
  if InSpectatorMode and TargetSpectate then
    local targetPlayerId = GetPlayerFromServerId(TargetSpectate)
    -- local playerPed	  = PlayerPedId()
    local targetPed	= GetPlayerPed(targetPlayerId)
    if ESX.Game.DoesPlayerExistInArea(TargetSpectate) then
      SetEntityVisible(PlayerPedId(), false)
      AttachEntityToEntity(PlayerPedId(), targetPed, headBone, 0, 0, -3.0, 0, 0, 0, true, true, false, true, 0, false)
      SetEntityCompletelyDisableCollision(PlayerPedId(), false, true)
    else
      resetNormalCamera()
    end

    -- local coords	    = GetEntityCoords(targetPed)

    -- for i=0, 32, 1 do
    -- 	if i ~= PlayerId() then
    -- 		local otherPlayerPed = GetPlayerPed(i)
    -- 		SetEntityNoCollisionEntity(playerPed,  otherPlayerPed,  true)
    -- 		SetEntityVisible(playerPed, false)
    -- 	end
    -- end

    -- local xMagnitude = GetDisabledControlNormal(0, 1);
    -- local yMagnitude = GetDisabledControlNormal(0, 2);

    -- polarAngleDeg = polarAngleDeg + xMagnitude * 10;

    -- if polarAngleDeg >= 360 then
    --   polarAngleDeg = 0
    -- end

    -- azimuthAngleDeg = azimuthAngleDeg + yMagnitude * 10;

    -- if azimuthAngleDeg >= 360 then
    --   azimuthAngleDeg = 0;
    -- end

    -- local nextCamLocation = polar3DToWorld3D(coords, radius, polarAngleDeg, azimuthAngleDeg)

    -- SetCamCoord(cam,  nextCamLocation.x,  nextCamLocation.y,  nextCamLocation.z)
    -- PointCamAtEntity(cam,  targetPed)
    -- SetEntityCoords(playerPed,  coords.x, coords.y, coords.z + 3.0)

    local text = {}

    -- local targetGod = GetPlayerInvincible(targetPlayerId)
    -- if targetGod then
    --   table.insert(text,"Godmode: ~r~Found~w~")
    -- else
    --   table.insert(text,"Godmode: ~g~Not Found~w~")
    -- end
    -- if not CanPedRagdoll(targetPed) and not IsPedInAnyVehicle(targetPed, false) and (GetPedParachuteState(targetPed) == -1 or GetPedParachuteState(targetPed) == 0) and not IsPedInParachuteFreeFall(targetPed) then
    --   table.insert(text,"~r~Anti-Ragdoll~w~")
    -- end
    -- health info
    if TargetSpectate then
      table.insert(text,"ID: "..TargetSpectate)
      table.insert(text,"Steam Name: "..GetPlayerName(targetPlayerId))
      table.insert(text,"Health: ".. (GetEntityHealth(targetPed) - 100).."/".. (GetEntityMaxHealth(targetPed) - 100))
      table.insert(text,"Armor: "..GetPedArmour(targetPed))
      if IsPedInAnyVehicle(targetPed, false) then
        table.insert(text,"Vehicle Speed: "..math.floor(GetEntitySpeed(GetVehiclePedIsIn(targetPed, false))*3.6))
        table.insert(text,"Vehicle Health: "..GetEntityHealth(GetVehiclePedIsIn(targetPed)))
        table.insert(text,"Vehicle Engine Health: "..GetVehicleEngineHealth(GetVehiclePedIsIn(targetPed)))
      end
      if NetworkIsPlayerTalking(targetPlayerId) then
        table.insert(text,"Talking: ~g~True")
      else
        table.insert(text,"Talking: ~r~False")
      end
      local IsDead = DecorGetInt(GetPlayerPed(GetPlayerFromServerId(TargetSpectate)), 'IsDead')
      local Injured = DecorGetInt(GetPlayerPed(GetPlayerFromServerId(TargetSpectate)), 'Injured')
      local KilledBy = DecorGetInt(GetPlayerPed(GetPlayerFromServerId(TargetSpectate)), 'KilledBy')
      if IsDead ~= 0 then
        table.insert(text,"NewLifed: "..(lastStamp-IsDead).." sec Ago")
      end
      if Injured ~= 0 then
        table.insert(text,"Injured: "..(lastStamp-Injured).." sec Ago")
      end
      if KilledBy ~= 0 then
        table.insert(text,"Killed By Server ID: "..KilledBy)
      end
      for i, theText in pairs(text) do
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, 0.30)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(theText)
        EndTextCommandDisplayText(0.03, 0.4+(i/30))
      end
      if not NetworkIsPlayerActive(targetPlayerId) then
        spec[TargetSpectate] = false
        InSpectatorMode = false
        lastspec = 0
        TargetSpectate = nil
      end

      if IsControlJustReleased(0, 47) and ESX.GetPlayerData().permission_level > 1 then
        OpenAdminActionMenu(targetPlayerId)
      elseif IsControlJustReleased(0, 246) then
        TriggerServerEvent('sr:reportsystem:AcceptReport', TargetSpectate)
      elseif IsControlJustReleased(0, 73) then
        resetNormalCamera()
      end
    end
    SetTimeout(0, DoSpecThread)
  end
end

-- AddEventHandler("onKeyDown", function(key)
-- 	if key == "g" then
-- 		if star then
-- 			pressed = true
-- 		end
-- 	end
-- end)

-- TELEPORT TO PLAYER EVENT
function teleportToPlayer(serverId)
  local targetId = GetPlayerFromServerId(serverId)
  local playerPed = PlayerPedId()
  local targetPed = GetPlayerPed(targetId)

  NetworkSetInSpectatorMode(false, playerPed) -- turn off spectator mode just in case
  TriggerServerEvent('SRAdmin:SpectStatus', nil)
  DetachEntity(playerPed, true, true)
  SetEntityCompletelyDisableCollision(playerPed, true, true)
  if not invisibility then
    SetEntityVisible(playerPed, true)
  end
  if PlayerId() == targetId then
    drawNotification("~r~This player is you!")
  elseif not NetworkIsPlayerActive(targetId) then
    drawNotification("~r~This player is not in game.")
  else
    local targetCoords = GetEntityCoords(targetPed)
    local targetVeh = GetVehiclePedIsIn(targetPed, False)
    local seat = -1

    drawNotification("~g~Teleporting to " .. GetPlayerName(targetId) .. " (Player " .. serverId .. ").")

    if targetVeh then
      local numSeats = GetVehicleModelNumberOfSeats(GetEntityModel(targetVeh))
      if numSeats > 1 then
        for i=0, numSeats do
          if seat == -1 and IsVehicleSeatFree(targetveh, i) then seat = 1 end
        end
      end
    end
    if seat == -1 then
      SetEntityCoords(playerPed, targetCoords.x, targetCoords.y, targetCoords.z + 3.5)
    else
      SetPedIntoVehicle(playerPed, targetVeh, seat)
    end
  end
end

IsNoclipActive = false;
local MovingSpeed = 0;
local Scale = -1;
local FollowCamMode = false;
local speeds = {
    [0] = "Very Slow",
    [1] = "Slow",
    [2] = "Normal",
    [3] = "Fast",
    [4] = "Very Fast",
    [5] = "Extremely Fast",
    [6] = "Extremely Fast v2.0",
    [7] = "Max Speed"
}

function NoClipThread()
	local function NoClipFunc()
		if (IsNoclipActive) then
			Scale = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS");
			while (not HasScaleformMovieLoaded(Scale)) do
				Wait(0)
			end
		end

		while IsNoclipActive do
			local playerPed = PlayerPedId()
        	if (not IsHudHidden()) then
                BeginScaleformMovieMethod(Scale, "CLEAR_ALL")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(0)
                PushScaleformMovieMethodParameterString("~INPUT_SPRINT~")
                PushScaleformMovieMethodParameterString("Change Speed ("..speeds[MovingSpeed]..")")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(1)
                PushScaleformMovieMethodParameterString("~INPUT_MOVE_LR~")
                PushScaleformMovieMethodParameterString("Turn Left/Right")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(2)
                PushScaleformMovieMethodParameterString("~INPUT_MOVE_UD~")
                PushScaleformMovieMethodParameterString("Move")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(3)
                PushScaleformMovieMethodParameterString("~INPUT_MULTIPLAYER_INFO~")
                PushScaleformMovieMethodParameterString("Down")
                EndScaleformMovieMethod();

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(4)
                PushScaleformMovieMethodParameterString("~INPUT_COVER~")
                PushScaleformMovieMethodParameterString("Up")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(5)
                PushScaleformMovieMethodParameterString("~INPUT_VEH_HEADLIGHT~")
				local CamModeText
				if FollowCamMode then
					CamModeText = 'Active'
				else
					CamModeText = 'Deactive'
				end
                PushScaleformMovieMethodParameterString("Cam Mode: "..CamModeText)
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "DRAW_INSTRUCTIONAL_BUTTONS")
                ScaleformMovieMethodAddParamInt(0)
                EndScaleformMovieMethod()

                DrawScaleformMovieFullscreen(Scale, 255, 255, 255, 255, 0)
            end

			local noclipEntity
			if IsPedInAnyVehicle(playerPed, true) then
				noclipEntity = GetVehiclePedIsIn(playerPed, false)
			else
				noclipEntity = playerPed
			end

            FreezeEntityPosition(noclipEntity, true);
            SetEntityInvincible(noclipEntity, true);

            DisableControlAction(0, 32)
            DisableControlAction(0, 268)
            DisableControlAction(0, 31)
            DisableControlAction(0, 269)
            DisableControlAction(0, 33)
            DisableControlAction(0, 266)
            DisableControlAction(0, 34)
            DisableControlAction(0, 30)
            DisableControlAction(0, 267)
            DisableControlAction(0, 35)
            DisableControlAction(0, 44)
            DisableControlAction(0, 20)
            DisableControlAction(0, 74)
            if (IsPedInAnyVehicle(playerPed, true)) then
                DisableControlAction(0, 85)
			end

            local yoff = 0.0;
            local zoff = 0.0;

            if (UpdateOnscreenKeyboard() ~= 0 and not IsPauseMenuActive()) then
                if (IsControlJustPressed(0, 21)) then
                    MovingSpeed = MovingSpeed+1
                    if (MovingSpeed > #speeds) then
                        MovingSpeed = 0;
                    end
                end

                if (IsDisabledControlPressed(0, 32)) then
                    yoff = 0.5
                end
                if (IsDisabledControlPressed(0, 33)) then
                    yoff = -0.5
                end
                if (IsDisabledControlPressed(0, 34)) then
                    SetEntityHeading(playerPed, GetEntityHeading(playerPed)+3)
                end
                if (IsDisabledControlPressed(0, 35)) then
                    SetEntityHeading(playerPed, GetEntityHeading(playerPed)-3)
            	end
                if (IsDisabledControlPressed(0, 44)) then
                    zoff = 0.21
                end
                if (IsDisabledControlPressed(0, 20)) then
                    zoff = -0.21
                end
				if (IsDisabledControlJustPressed(0, 74)) then
					FollowCamMode = not FollowCamMode
				end
                moveSpeed = MovingSpeed
                if (MovingSpeed > #speeds/2) then
                    moveSpeed = moveSpeed*1.8;
                end

                newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0, yoff*(moveSpeed + 0.3), zoff*(moveSpeed + 0.3))

                local heading = GetEntityHeading(noclipEntity)
                SetEntityVelocity(noclipEntity, 0, 0, 0)
                SetEntityRotation(noclipEntity, 0, 0, 0, 0, false)
				if FollowCamMode then
					SetEntityHeading(noclipEntity, GetGameplayCamRelativeHeading())
				else
					SetEntityHeading(noclipEntity, heading)
				end

                SetEntityCollision(noclipEntity, false, false)
                SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

                SetLocalPlayerVisibleLocally(true)
                SetEntityAlpha(noclipEntity, 255*0.2, 0)

                SetEveryoneIgnorePlayer(PlayerId(), true)
                SetPoliceIgnorePlayer(PlayerId(), true)

                FreezeEntityPosition(noclipEntity, false)
                SetEntityInvincible(noclipEntity, false)
                SetEntityCollision(noclipEntity, true, true)

                SetLocalPlayerVisibleLocally(true)
                ResetEntityAlpha(noclipEntity)

                SetEveryoneIgnorePlayer(PlayerId(), false)
                SetPoliceIgnorePlayer(PlayerId(), false)
            end
            Wait(0)
		end
	end
	CreateThread(NoClipFunc)
end

RegisterNetEvent("SRAdmin:ToggleNoclip")
AddEventHandler("SRAdmin:ToggleNoclip", function()
	IsNoclipActive = not IsNoclipActive
	if IsNoclipActive then
		NoClipThread()
	end
end)

AddEventHandler("esx_aduty:OnOffDuty", function()
  IsNoclipActive = false
  WarMenu.CloseMenu()
  invisibility = false
  SetEntityVisible(PlayerPedId(), true, 0)
  if InSpectatorMode then
    resetNormalCamera()
  end
end)

local NeedUpdate = false

RegisterNetEvent("esx_admin:openPlayerInventory", function(result, owner)
    ESX.UI.Menu.CloseAll()
    local elem = {}
    local result = result
    local owner = owner
    if type(result["inventory"]) == "string" then
        result["inventory"] = json.decode(result["inventory"])
    end
    if type(result["loadout"]) == "string" then
        result["loadout"] = json.decode(result["loadout"])
    end
    for k, v in pairs(result["inventory"]) do
        if v.count > 0 then
            table.insert(elem, { label = v.item.." "..v.count.."x", name = v.item, type = "inventory", value = k })
        end
    end
    for k, v in pairs(result["loadout"]) do
        table.insert(elem, { label = ESX.GetWeaponLabel(v.name), name = v.name, type = "loadout", value = k })
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory_interaction',
    {
        title    = 'Player Control',
        align    = 'center',
        elements = elem,
    },function(data, menu)
        local action = data.current.value
        local label = data.current.label
        local ty = data.current.type
        local name = data.current.name
        menu.close()
        if ty == "loadout" then
            table.remove(result[ty], action)
            NeedUpdate = true
            TriggerServerEvent("esx_admin:getBackItem", name, ty, 1)
            TriggerEvent("esx_admin:openPlayerInventory", result, owner)
        else
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'car_plate', {
                title = label,
            }, function(data2, menu2)
                local count = tonumber(data2.value)
                if not count or type(count) ~= "number" then
                    return ESX.Alert("Meghdar Eshtebah", "info")
                end
                menu2.close()
                local c = count
                local p = result[ty][action].count
                result[ty][action].count = result[ty][action].count - count
                if result[ty][action].count <= 0 then
                    c = p
                    table.remove(result[ty], action)
                end
                NeedUpdate = true
                TriggerServerEvent("esx_admin:getBackItem", name, ty, c)
                TriggerEvent("esx_admin:openPlayerInventory", result, owner)
            end, function(data2, menu2)
            end)
        end
    end, function(data, menu)
        menu.close()
        if NeedUpdate then
            NeedUpdate = false
            TriggerServerEvent("esx_admin:updatePlayerData", owner, result)
        end
    end)
end)