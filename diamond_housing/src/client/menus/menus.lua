---@diagnostic disable: lowercase-global
inProgressAction = false

OpenMenu = function(...)
  if Config.UsingESX then
    if Config.UsingESXMenu then
      menuType = "ESX"
    elseif Config.UsingNativeUI then
      menuType = "NativeUI"
    end
  elseif Config.UsingNativeUI then
    menuType = "NativeUI"
  end

  if menuType == "NativeUI" then
    NativeUIHandler(...)
  elseif menuType == "ESX" then
    ESXMenuHandler(...)
  end
end

UnlockHouse = function(house)

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

    inProgressAction = true
    ExecuteCommand("me Shoro mikone be baz kardan ghofl dare khane")
    TriggerEvent("mythic_progbar:client:progress", {
      name = "unlock_house",
      duration = 3000,
      label = "Dar hale baz kardan ghofl khane",
      useWhileDead = false,
      canCancel = false,
      controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
      }
    }, function(status)
      if not status then

        inProgressAction = false
        if InsideHouse then
          InsideHouse.Unlocked = true 
        else
          house.Unlocked = true
        end
        TriggerServerEvent("Allhousing:UnlockDoor",house)
        -- ShowNotification(Labels["Unlocked"])

      else
        inProgressAction = false
      end
    end)
  
end

LockHouse = function(house)

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  inProgressAction = true
  ExecuteCommand("me Shoro mikone be ghofl kardan dare khane")
  TriggerEvent("mythic_progbar:client:progress", {
    name = "lock_house",
    duration = 3000,
    label = "Dar hale ghofl kardan dare khane",
    useWhileDead = false,
    canCancel = false,
    controlDisables = {
      disableMovement = true,
      disableCarMovement = true,
      disableMouse = false,
      disableCombat = true,
    }
  }, function(status)
    if not status then
      inProgressAction = false
      if InsideHouse then
        InsideHouse.Unlocked = false 
      else
        house.Unlocked = false
      end
      TriggerServerEvent("Allhousing:LockDoor",house)
      -- ShowNotification(Labels["Locked"])
    else
      inProgressAction = false
    end
  end)
end

GetVehiclesAtHouse = function(house)
  local data = Callback("Allhousing:GetVehicles",house)
  return data
end

GetVehicleLabel = function(model)
  return (GetLabelText(GetDisplayNameFromVehicleModel(model)))
end

SpawnVehicle = function(pos,model,props,hid)  
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  Citizen.CreateThread(function()
		if not IsModelValid(model) then return print("Model is not valid", model) end
		if not IsModelAVehicle(model) then return print("Model is not vehicle", model) end
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(50)
		end
		TriggerServerEvent('Allhousing:VehicleSpawned', {plate = props.plate, house = hid})
	end)
  
end

OpenInventory = function()
    if Houses[InsideHouse.Id].Owner == GetPlayerIdentifier() or Houses[InsideHouse.Id].HouseKeys[GetPlayerIdentifier()] then
      TriggerEvent("esx_inventoryhud:OpenHouseInventory", InsideHouse.Id)
    end
end

SetWardrobe = function(d)  
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  ShowNotification(Labels["AcceptDrawText"]..Labels["SetWardrobe"])
  while true do
    if IsControlJustPressed(0,Config.Controls.Accept) then
      local pos = d.Entry.xyz - GetEntityCoords(PlayerPedId())
      InsideHouse.Wardrobe = pos + Config.SpawnOffset + vector3(0.0, 0.0, InsideHouse.Offset)
      TriggerServerEvent("Allhousing:SetWardrobe",d,InsideHouse.Wardrobe)
      ShowNotification(Labels['WardrobeSet'])
      return
    end
    Wait(0)
  end
end

SetInventory = function(d)  
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  ShowNotification(Labels["AcceptDrawText"]..Labels["SetInventory"])
  while true do
    if IsControlJustPressed(0,Config.Controls.Accept) then
      local pos = d.Entry.xyz - GetEntityCoords(PlayerPedId())
      InsideHouse.InventoryLocation = pos + Config.SpawnOffset + vector3(0.0, 0.0, InsideHouse.Offset)
      TriggerServerEvent("Allhousing:SetInventory",d,InsideHouse.InventoryLocation)
      ShowNotification(Labels['InventorySet'])
      return
    end
    Wait(0)
  end
end

SetOutfit = function(index,label)  
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  if Config.UsingESX then
    local clothes = Callback("Allhousing:GetOutfit",index)
    TriggerEvent('skinchanger:getSkin', function(skin)
      TriggerEvent('skinchanger:loadClothes', skin, clothes)
      TriggerEvent('esx_skin:setLastSkin', skin)

      TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
      end)
    end)
  else
    -- NON-ESX USERS FILL IN HERE.
  end
end

OpenFurniture = function(d)
  ShowNotification(Labels["FurniDrawText"]..Labels["ToggleFurni"])
  TriggerEvent("Allhousing:OpenFurni")    

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end
end

GiveKeys = function(d,serverId)
  TriggerServerEvent("Allhousing:GiveKeys",d,serverId)
  ShowNotification(Labels["GivingKeys"])
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end
end

TakeKeys = function(d,data)
  TriggerServerEvent("Allhousing:TakeKeys",d,data)
  ShowNotification(Labels["TakingKeys"])

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end
end

MoveGarage = function(d)
  local last_dist = Vdist(d.Garage.xyz,d.Entry.xyz)
  local ped = PlayerPedId()
  FreezeEntityPosition(ped,false)

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  ShowNotification(Labels["AcceptDrawText"]..Labels["SetGarage"])
  while true do
    if IsControlJustPressed(0,Config.Controls.Accept) then
      ped = PlayerPedId()
      local pos = GetEntityCoords(ped)
      if Vdist(pos,d.Entry.xyz) <= last_dist+5.0 then
        local head = GetEntityHeading(ped)
        d.Garage = vector4(pos.x,pos.y,pos.z,head)
        TriggerServerEvent("Allhousing:SetGarageLocation",d.Id,d.Garage)
        ShowNotification(Labels["GarageSet"])
        return
      else
        ShowNotification(Labels["GarageTooFar"])
      end
    end
    Wait(0)
  end
end

-- InviteInside = function(d,serverId)
--   TriggerServerEvent("Allhousing:InviteInside",d,serverId)
-- end

BuyHouse = function(d)
  local price = d.Price  

    if Config.UsingNativeUI and _Pool then
      _Pool:CloseAllMenus()
    elseif Config.UsingESX and Config.UsingESXMenu then      
      ESX.UI.Menu.CloseAll()
    end


    ESX.TriggerServerCallback('mf_housing:canAfford', function(canAfford)
      if canAfford then

        ESX.TriggerServerCallback('mf_housing:CanPurchaseHouse', function(canBuy)
          if canBuy then
            ShowNotification(string.format(Labels["PurchasedHouse"],price))
            d.Owner = GetPlayerIdentifier()
            d.Owned = true
            TriggerServerEvent("Allhousing:PurchaseHouse",d)
          end
        end)

      else
          ESX.ShowNotification("Shoma pole kafi baraye kharid in khane nadarid!")
      end
    end, price)
    
end

MortgageHouse = function(d)
  local price = math.floor((d.Price / 100) * Config.MortgagePercent)

  ESX.TriggerServerCallback('mf_housing:canAfford', function(canAfford)
    if canAfford then

        ShowNotification(string.format(Labels["MortgagedHouse"],price))
        d.Owner = GetPlayerIdentifier()
        d.Owned = true

        if Config.UsingNativeUI and _Pool then
          _Pool:CloseAllMenus()
        elseif Config.UsingESX and Config.UsingESXMenu then      
          ESX.UI.Menu.CloseAll()
        end

        TriggerServerEvent("Allhousing:MortgageHouse",d)
    else
        ESX.ShowNotification("Shoma pole kafi baraye rahn in khane nadarid!")
    end
  end, price)
  
end

RaidHouse = function(d)
  EnterHouse(d,not Config.InventoryRaiding)
end

KnockOnDoor = function(d)  
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  GoToDoor(d.Entry)
  FaceCoordinate(d.Entry)
  TriggerServerEvent("Allhousing:KnockOnDoor",d.Entry)
  local plyPed = PlayerPedId()
  while not HasAnimDictLoaded("timetable@jimmy@doorknock@") do RequestAnimDict("timetable@jimmy@doorknock@"); Wait(0); end
  TaskPlayAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, 8.0, -1, 4, 0, 0, 0, 0 )     
  Wait(0)

  while IsEntityPlayingAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 3) do Citizen.Wait(0); end 

  RemoveAnimDict("timetable@jimmy@door@knock@")
end

BreakInHouse = function(d)  
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  GoToDoor(d.Entry)
  FaceCoordinate(d.Entry)

  if Config.LockpickRequired then
    local hasItem = CheckForLockpick()
    if not hasItem then
      ShowNotification(Labels["NoLockpick"])
      return
    end
  end

  local plyPed = PlayerPedId()
  local plyPos = GetEntityCoords(PlayerPedId())
  local zoneName = GetNameOfZone(plyPos.x,plyPos.y,plyPos.z)
  while not HasAnimDictLoaded("mini@safe_cracking") do RequestAnimDict("mini@safe_cracking"); Citizen.Wait(0); end
  TaskPlayAnim(plyPed, "mini@safe_cracking", "idle_base", 1.0, 1.0, -1, 1, 0, 0, 0, 0 ) 
  Wait(2000)
  if Config.UsingLockpickV1 then
    TriggerEvent("lockpicking:StartMinigame",4,function(didWin)
      if didWin then
        EnterHouse(d,true)
      else
        ClearPedTasksImmediately(plyPed)
        if Config.LockpickBreakOnFail then
          TriggerServerEvent("Allhousing:BreakLockpick")
        end
        ShowNotification(Labels["LockpickFailed"])
        FreezeEntityPosition(plyPed,false)
        for k,v in pairs(Config.PoliceJobs) do
          TriggerServerEvent("Allhousing:NotifyJobs",k,string.format(Labels["NotifyRobbery"],zoneName),d.Entry)
          if Config.UsingInteractSound then
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 20.0, 'security-alarm', 1.0)
          end
        end
      end
    end)
  elseif Config.UsingLockpickV2 then
    exports["lockpick"]:Lockpick(function(didWin)
      if didWin then
        EnterHouse(d,true)
        ShowNotification(Labels["LockpickSuccess"])
      else
        ClearPedTasksImmediately(plyPed)
        if Config.LockpickBreakOnFail then
          TriggerServerEvent("Allhousing:BreakLockpick")
        end
        ShowNotification(Labels["LockpickFailed"])
        FreezeEntityPosition(plyPed,false)
        for k,v in pairs(Config.PoliceJobs) do
          TriggerServerEvent("Allhousing:NotifyJobs",k,string.format(Labels["NotifyRobbery"],zoneName),d.Entry)
          if Config.UsingInteractSound then
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 20.0, 'security-alarm', 1.0)
          end
        end
      end
    end)
  else
    if Config.UsingProgressBars then
      exports["esx_basicneeds"]:startUI(Config.LockpickTime * 1000,Labels["ProgressLockpicking"])
    end
    Wait(Config.LockpickTime * 1000)
    if math.random(100) < Config.LockpickFailChance then
      if Config.LockpickBreakOnFail then
        TriggerServerEvent("Allhousing:BreakLockpick")
      end
      for k,v in pairs(Config.PoliceJobs) do
        TriggerServerEvent("Allhousing:NotifyJobs",k,string.format(Labels["NotifyRobbery"],zoneName),d.Entry)
        if Config.UsingInteractSound then
          TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 20.0, 'security-alarm', 1.0)
        end
      end
      ClearPedTasksImmediately(plyPed)
      ShowNotification(Labels["LockpickFailed"])
      FreezeEntityPosition(plyPed,false)
    else
      EnterHouse(d,true)
    end
  end
  RemoveAnimDict("mini@safe_cracking")
end

LeaveHouse = function(d, data)
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end
  ESX.UI.Menu.CloseAll()
  SetResourceKvpInt("insideHouse", 0)
  SetResourceKvpInt("houseVisiting", 0)
  if data and data.force then
    if not data or not data.teleport then
      DoScreenFadeOut(500)
      TriggerEvent("Allhousing:Leave", d)
      Wait(1000)

      local plyPed = PlayerPedId()

      ESX.SetEntityCoordsNoOffset(plyPed, InsideHouse.Entry.x,InsideHouse.Entry.y,InsideHouse.Entry.z)
      SetEntityHeading(plyPed, InsideHouse.Entry.w - 180.0)

      Wait(500)
      DoScreenFadeIn(500)
    end
    
    SetEntityAsMissionEntity(InsideHouse.Object,true,true)
    DeleteObject(InsideHouse.Object)
    DeleteEntity(InsideHouse.Object)

    if InsideHouse and InsideHouse.Extras then
      for k,v in pairs(InsideHouse.Extras) do
        SetEntityAsMissionEntity(v,true,true)
        DeleteObject(v)
      end
    end

    InsideHouse = false
    SetWeatherAndTime(true)
    LeavingHouse = false
    return
  end

      inProgressAction = true
      ExecuteCommand("me Shoro mikone be baz kardan dar va sai mikone az khane kharej she")
      TriggerEvent("mythic_progbar:client:progress", {
        name = "leave_house",
        duration = 3000,
        label = "Dar hale kharej shodan az khane",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
        }
      }, function(status)
        if not status then

          inProgressAction = false

          LeavingHouse = true

          if not data or not data.teleport then
            DoScreenFadeOut(500)
            TriggerEvent("Allhousing:Leave", d)
            Wait(1000)
      
            local plyPed = PlayerPedId()
      
            ESX.SetEntityCoordsNoOffset(plyPed, InsideHouse.Entry.x,InsideHouse.Entry.y,InsideHouse.Entry.z)
            SetEntityHeading(plyPed, InsideHouse.Entry.w - 180.0)
      
            Wait(500)
            DoScreenFadeIn(500)
          end
          
          SetEntityAsMissionEntity(InsideHouse.Object,true,true)
          DeleteObject(InsideHouse.Object)
          DeleteEntity(InsideHouse.Object)
      
          if InsideHouse and InsideHouse.Extras then
            for k,v in pairs(InsideHouse.Extras) do
              SetEntityAsMissionEntity(v,true,true)
              DeleteObject(v)
            end
          end
      
          InsideHouse = false
          SetWeatherAndTime(true)
          LeavingHouse = false

        else
          inProgressAction = false
        end
      end)
 
end

SpawnHouse = function(d)
  local model = ShellModels[d.Shell]
  local hash  = GetHashKey(model)

  local start = GetGameTimer()
  RequestModel(hash)
  while not HasModelLoaded(hash) and GetGameTimer() - start < 30000 do Wait(0); end
  if not HasModelLoaded(hash) then
    ShowNotification(string.format(Labels["InvalidShell"],model))
    return false,false
  end

  local shell = CreateObject(hash, d.Entry.x + Config.SpawnOffset.x,d.Entry.y + Config.SpawnOffset.y,d.Entry.z + Config.SpawnOffset.z + d.Offset - 60.0,false,false)
  FreezeEntityPosition(shell,true)

  start = GetGameTimer()
  while not DoesEntityExist(shell) and GetGameTimer() - start < 30000 do Wait(0); end
  if not DoesEntityExist(shell) then
    ShowNotification(string.format(Labels["ShellNotLoaded"],model))
    return false,false
  end

  SetEntityAsMissionEntity(shell,true,true)
  SetModelAsNoLongerNeeded(hash)

  local extras = {}
  if ShellExtras[d.Shell] then
    for objHash,data in pairs(ShellExtras[d.Shell]) do
      RequestModel(objHash)
      start = GetGameTimer()
      while not HasModelLoaded(objHash) and GetGameTimer() - start < 10000 do Wait(0); end
      if HasModelLoaded(objHash) then
        local pos = d.Entry.xyz + data.offset + Config.SpawnOffset
        local rot = data.rotation
        local obj = CreateObject(objHash, pos.x,pos.y,pos.z - 60.0, false,false)
        FreezeEntityPosition(obj,true)
        if rot then SetEntityRotation(obj,rot.x,rot.y,rot.z,2) end
        SetEntityAsMissionEntity(obj,true,true)
        SetModelAsNoLongerNeeded(objHash)
        table.insert(extras,obj)
      end
    end
  end
  local furni = Callback("Allhousing:GetFurniture",d.Id)
  for k,v in pairs(furni) do
    local objHash = GetHashKey(v.model)
    RequestModel(objHash)
    start = GetGameTimer()
    while not HasModelLoaded(objHash) and GetGameTimer() - start < 10000 do Wait(0); end
    if HasModelLoaded(objHash) then
      local pos = vector3(d.Entry.x,d.Entry.y,d.Entry.z) + vector3(v.pos.x, v.pos.y, v.pos.z) + Config.SpawnOffset + vector3(0.0, 0.0, d.Offset)
      local obj = CreateObject(objHash, pos.x, pos.y, pos.z, false,false,false)
      FreezeEntityPosition(obj, true)
      ESX.SetEntityCoordsNoOffset(obj, pos.x, pos.y, pos.z)
      SetEntityRotation(obj, v.rot.x, v.rot.y, v.rot.z, 2)

      SetModelAsNoLongerNeeded(objHash)

      table.insert(extras,obj)
    end
  end

  return shell,extras
end

TeleportInside = function(d,v)  
  local exitOffset = vector4(ShellOffsets[d.Shell]["exit"].x - Config.SpawnOffset.x,ShellOffsets[d.Shell]["exit"].y - Config.SpawnOffset.y,ShellOffsets[d.Shell]["exit"].z - Config.SpawnOffset.z - d.Offset,ShellOffsets[d.Shell]["exit"].w)
  if type(exitOffset) ~= "vector4" or exitOffset.w == nil then
    ShowNotification(string.format(Labels["BrokenOffset"],d.Id))
    return
  end

  local plyPed = PlayerPedId()
  FreezeEntityPosition(plyPed,true)

  DoScreenFadeOut(1000)
  Wait(1500)

  ClearPedTasksImmediately(plyPed)

  local shell,extras = SpawnHouse(d)
  if shell and extras then
    ESX.SetEntityCoordsNoOffset(plyPed, d.Entry.x - exitOffset.x,d.Entry.y - exitOffset.y,d.Entry.z - exitOffset.z)
    SetEntityHeading(plyPed, exitOffset.w)

    local start_time = GetGameTimer()
    while (not HasCollisionLoadedAroundEntity(plyPed) and GetGameTimer() - start_time < 5000) do Wait(0); end
    FreezeEntityPosition(plyPed,false)

    DoScreenFadeIn(500)
    InsideHouse = d
    InsideHouse.Extras    = extras
    InsideHouse.Object    = shell
    InsideHouse.Visiting  = v  
    RunDistanceThread()
  else
    FreezeEntityPosition(plyPed,false)
    DoScreenFadeIn(500)
  end
end

function GhadreMotlagh(d)
    return math.sqrt(d^2)
end

RunDistanceThread = function()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            if InsideHouse then
                if InsideHouse.Object then
                    if GetEntityCoords(InsideHouse.Object) ~= vector3(0, 0, 0) then
                        if GhadreMotlagh(#(GetEntityCoords(PlayerPedId()).xy - GetEntityCoords(InsideHouse.Object).xy)) > 200.0 then
                            LeaveHouse(InsideHouse, {data = {force = true}})
                            break
                        end
                    else
                        break
                    end
                else
                    break
                end
            else
                break
            end
        end
    end)
end

ViewHouse = function(d)
  EnterHouse(d,true)
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end
end

lastHouse = function()
    local h = GetResourceKvpInt("insideHouse")
    local b = GetResourceKvpInt("houseVisiting") 
    if h ~= 0 then
        if b == 1 then
            if Houses[h] then
                EnterHouse(Houses[h], true)
            end
        elseif b == 0 then
            if Houses[h] then
                EnterHouse(Houses[h], false)
            end
        end
    end
end

AddEventHandler("PlayerLoadedToGround", lastHouse)

GetHouseKvp = function()
    return GetResourceKvpInt("insideHouse")
end

exports("GetHouseKvp", GetHouseKvp)

EnterHouse = function(d,visiting)

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then    
    ESX.UI.Menu.CloseAll()
  end
  
  if d.Unlocked or not d.Owned then

    inProgressAction = true
    ExecuteCommand("me Shoro mikone be baz kardan dar va sai mikone vared khane she")
    TriggerEvent("mythic_progbar:client:progress", {
      name = "enter_house",
      duration = 3000,
      label = "Dar hale vared shodan be khane",
      useWhileDead = false,
      canCancel = false,
      controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
      }
    }, function(status)
      if not status then

        inProgressAction = false
        if d.Unlocked or not d.Owned then
          TriggerEvent("Allhousing:Enter",d)
          TeleportInside(d,visiting)
          SetWeatherAndTime(false)
          SetResourceKvpInt("insideHouse", tonumber(d.Id))
          if visiting then
            SetResourceKvpInt("houseVisiting", 1)
          else
            SetResourceKvpInt("houseVisiting", 0)
          end
        else
          ESX.ShowNotification("~h~Dare khane ghofl ast nemitavanid vared shavid!")
        end

      else
        inProgressAction = false
      end
    end)

  else
    ExecuteCommand("me Sai mikone vared khane beshe vali dar baz nemishe")
    ESX.ShowNotification("~h~Dare khane ghofl ast nemitavanid vared shavid!")
  end
end

UpgradeHouse = function(d,data)
    TriggerServerEvent("Allhousing:UpgradeHouse",d,data.shell)
    ShowNotification(string.format(Labels["UpgradeHouse"],tostring(data.shell)))
    d.Shell = data.shell
    if InsideHouse then
      local _visiting = InsideHouse.Visiting
      LeaveHouse(d)
      EnterHouse(d,_visiting)
    end

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end
end

SellHouse = function(d)
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  if not d.MortgageOwed or d.MortgageOwed <= 0 then
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'house_putsale', {
        title    = "Gheymat ra vared konid",
    }, function(data, menu)
      menu.close()
      local price = (tonumber(data.value) and tonumber(data.value) > 0 and tonumber(data.value) or 0)
      local salePrice = math.max(1,math.floor(tonumber(price)))
 
      if salePrice < Config.minimumPrice then
        return ShowNotification("Hade aghal gheymat forosh khane ~g~" .. Config.minimumPrice .. "~w~ ast.")
      elseif salePrice > Houses[d.Id].Price then 
        return ShowNotification("Hade aksar gheymat forosh khane ~g~" .. Houses[d.Id].Price .. "~w~ ast.")
      end

      ESXConfirmSaleMenu(d,salePrice)
    end, function (data, menu)
      menu.close()
    end)
  else
    ShowNotification(Labels["InvalidSale"])
  end
end

RepayMortgage = function(d)
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  local min_repayment = math.floor((d.MortgageOwed / 100) * Config.MortgageMinRepayment)
  if GetPlayerCash() > min_repayment or GetPlayerBank() > min_repayment then
    exports["mf_input"]:Open(string.format("Min: $%i",min_repayment),(Config.UsingESX and Config.UsingESXMenu and "ESX" or "Native"),function(res)
      local repay = tonumber(res)
      if repay == nil or not repay then
        ShowNotification(Labels["InvalidAmount"])
      else
        repay = math.floor(repay)
        if repay < min_repayment then
          ShowNotification(Labels["InvalidAmount"])
        else
          if GetPlayerCash() > repay or GetPlayerBank() > repay then
            TriggerServerEvent("Allhousing:RepayMortgage",d.Id,repay)
          else
            ShowNotification(Labels["InvalidMoney"])
          end
        end
      end
    end)
  else
  end
end

RevokeTenancy = function(d)
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  ESX.UI.Menu.CloseAll()
  ShowNotification(Labels["EvictingTenants"])
  TriggerServerEvent("Allhousing:RevokeTenancy",d)
end

MenuThread = function()
  while true do      
    if _Pool and _Pool:IsAnyMenuOpen() then
      _Pool:ControlDisablingEnabled(false)
      _Pool:MouseControlsEnabled(false)
      _Pool:ProcessMenus()
    end
    Wait(0)
  end
end

Citizen.CreateThread(MenuThread)

AddEventHandler('esx:onPlayerNLR', function()
    if InsideHouse then
      LeaveHouse(InsideHouse, {teleport = true, force = true})
    end
end)

RegisterNetEvent("mf_housing:ResetPropertyDimension")
AddEventHandler("mf_housing:ResetPropertyDimension", function()
  if InsideHouse then
    LeaveHouse(InsideHouse, {force = true})
  end
end)

RegisterNetEvent("mf_housing:reviveFromMedic")
AddEventHandler("mf_housing:reviveFromMedic", function()
  if InsideHouse then
    LeaveHouse(InsideHouse, {teleport = true, force = true})
  end
end)