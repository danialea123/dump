---@diagnostic disable: undefined-global
ESX = nil

Citizen.CreateThread(function()
  while not ESX do
    TriggerEvent("esx:getSharedObject", function(obj)
      ESX = obj
    end)
    Citizen.Wait(0)
  end
end)

Init = function()
  local start = GetGameTimer()
  while (GetGameTimer() - start < 2000) do Wait(0); end

  TriggerServerEvent("Allhousing:GetHouseData")
end

RegisterNetEvent("Allhousing:GetHousesData")
AddEventHandler("Allhousing:GetHousesData", function(StartData)
    Houses          = StartData.Houses
    KashIdentifier  = StartData.Identifier
    print(KashIdentifier)
    RefreshBlips  ()
    Update        ()
end)

Update = function()
  while true do
    local wait_time = 0
    local do_render = false

    if not InsideHouse then
      do_render = RenderExterior()
    else
      do_render = RenderInterior()
    end

    if not do_render and Config.WaitToRender then
      wait_time = Config.WaitToRenderTime
    end

    Wait(wait_time)
  end
end

RenderInterior = function()
  local ped = PlayerPedId()
  local pos = GetEntityCoords(ped)
  local now = GetGameTimer()

  if (not lastIntCheck or not lastIntPos) or (now - lastIntCheck >= 500) or #(lastIntPos - pos) >= 2.0 then
    local _closest,_closestDist

    lastIntCheck  = now
    lastIntPos    = pos

    if InsideHouse.Interior then
      if GetInteriorAtCoords(pos.x,pos.y,pos.z) == InsideHouse.Interior then
        if InsideHouse.Owned then
          local wardrobeDist  = (                             InsideHouse.Wardrobe           and #(InsideHouse.Entry.xyz-InsideHouse.Wardrobe+Config.SpawnOffset+vector3(0.0, 0.0, InsideHouse.Offset) - pos)            or false)
          local garageDist    = (                             InsideHouse.Garage             and #(InsideHouse.Garage.xyz - pos)                                                   or false)
          local inventoryDist = (not InsideHouse.Visiting and InsideHouse.InventoryLocation  and #(InsideHouse.Entry.xyz-InsideHouse.InventoryLocation+Config.SpawnOffset+vector3(0.0, 0.0, InsideHouse.Offset) - pos)   or false)

          if wardrobeDist then
            if not _closestDist or wardrobeDist < _closestDist then
              _closest      = "Wardrobe"
              _closestDist  = wardrobeDist
            end
          end

          if inventoryDist then
            if not _closestDist or inventoryDist < _closestDist then
              _closest      = "InventoryLocation"
              _closestDist  = inventoryDist
            end
          end

          if garageDist then
            if not _closestDist or garageDist < _closestDist then
              _closest      = "Garage"
              _closestDist  = garageDist
            end
          end
        else
          local entryDist = #(InsideHouse.Entry.xyz - pos)
          if entryDist then
            if not _closestDist or entryDist < _closestDist then
              _closest      = "Entry"
              _closestDist  = entryDist
            end
          end
        end
      else
        UnloadInterior()
        return true
      end
    else
      local wardrobeDist  = (InsideHouse.Wardrobe     and #(InsideHouse.Entry.xyz-InsideHouse.Wardrobe+Config.SpawnOffset+vector3(0.0, 0.0, InsideHouse.Offset) - pos)            or false)
      local inventoryDist = (not InsideHouse.Visiting and InsideHouse.InventoryLocation  and #(InsideHouse.Entry.xyz-InsideHouse.InventoryLocation+Config.SpawnOffset+vector3(0.0, 0.0, InsideHouse.Offset) - pos)   or false)
      local exitDist      = (#(InsideHouse.Entry.xyz - ShellOffsets[InsideHouse.Shell].exit.xyz+Config.SpawnOffset+vector3(0, 0, InsideHouse.Offset)-pos))

      if wardrobeDist then
        if not _closestDist or wardrobeDist < _closestDist then
          _closest      = "Wardrobe"
          _closestDist  = wardrobeDist
        end
      end

      if inventoryDist then
        if not _closestDist or inventoryDist < _closestDist then
          _closest      = "InventoryLocation"
          _closestDist  = inventoryDist
        end
      end

      if exitDist then
        if not _closestDist or exitDist < _closestDist then
          _closest      = "Exit"
          _closestDist  = exitDist
        end
      end
    end

    if _closest then
      closestInt      = _closest
      closestIntDist  = _closestDist
    end
  end

  if closestInt then
    local _pos = ((closestInt == "Garage" and InsideHouse[closestInt]) or (closestInt == "Exit" and InsideHouse.Entry.xyz-ShellOffsets[InsideHouse.Shell].exit.xyz+Config.SpawnOffset+vector3(0.0, 0.0, InsideHouse.Offset)) or (InsideHouse.Entry.xyz-InsideHouse[closestInt].xyz+Config.SpawnOffset+vector3(0.0, 0.0, InsideHouse.Offset)))
    if Config.UseMarkers then
      if closestIntDist < Config.MarkerDistance and closestInt ~= "InventoryLocation" then
        DrawMarker(1,_pos.x,_pos.y,_pos.z-1.6, 0.0,0.0,0.0, 0.0,0.0,0.0, 1.0,1.0,1.0, Config.MarkerColors[Config.MarkerSelection].r,Config.MarkerColors[Config.MarkerSelection].g,Config.MarkerColors[Config.MarkerSelection].b,Config.MarkerColors[Config.MarkerSelection].a, false,true,2)
      end
    end

    if Config.Use3DText then
      if closestIntDist < Config.TextDistance3D then
        if closestInt ~= "InventoryLocation" then
          if closestIntDist < Config.InteractDistance then
            DrawText3D(_pos.x,_pos.y,_pos.z, Labels["InteractDrawText"]..Labels[closestInt])
          else
            DrawText3D(_pos.x,_pos.y,_pos.z, Labels[closestInt])
          end
        end
      end
    end

    if Config.UseHelpText then
      if closestIntDist < Config.HelpTextDistance then
        ShowHelpNotification(Labels["InteractHelpText"]..Labels[closestInt])
      end
    end

    if closestIntDist < Config.InteractDistance then
      if IsControlJustReleased(0,Config.Controls.Interact) then
        if InsideHouse.Owned and (InsideHouse.Owner == GetPlayerIdentifier()) then
          OpenMenu(InsideHouse,closestInt,"Owner")
        elseif InsideHouse.Owned then
          OpenMenu(InsideHouse,closestInt,"Owned")
        else
          OpenMenu(InsideHouse,closestInt,"Empty")
        end
      end
    elseif InsideHouse.Interior then
      if IsControlJustReleased(0,Config.Controls.Interact) then
        if InsideHouse.Owned and (InsideHouse.Owner == GetPlayerIdentifier()) then
          OpenMenu(InsideHouse,"Exit","Owner")
        elseif InsideHouse.Owned then
          OpenMenu(InsideHouse,"Exit","Owned")
        else
          OpenMenu(InsideHouse,"Exit","Empty")
        end
      end
    end
    return true
  else
    return false
  end
end

RenderExterior = function()
  local ped = PlayerPedId()
  local pos = GetEntityCoords(ped)
  local sleep = false
  local sleep2 = false
  local now = GetGameTimer()
  if (not lastExtCheck or not lastExtPos) or (now - lastExtCheck > 5000) or (#(lastExtPos - pos) >= 2.0) then
    sleep = true
    lastExtCheck = now
    lastExtPos   = pos

    closestExt,closestExtDist,closestExtHouse = false,false,false
    local _closest,_closestDist
    for index,house in pairs(Houses) do
      local entryDist   = #(pos - house.Entry.xyz)
      local garageDist  = (type(house.Garage) == "vector4" and type(pos) == "vector3" and #(house.Garage.xyz - pos) or false)

      if not garageDist or entryDist < garageDist then
        sleep = true
        _closest      = "Entry"
        _closestDist  = entryDist
      else
        sleep = true
        _closest      = "Garage"
        _closestDist  = garageDist
      end

      if not closestExtDist or _closestDist < closestExtDist then
        sleep = true
        closestExt       = _closest
        closestExtDist   = _closestDist
        closestExtHouse  = index
      end
    end
    if not sleep then Citizen.Wait(765) end
  end
  if closestExt and closestExtDist and closestExtDist < 100.0 then
    sleep2 = true
    local house = Houses[closestExtHouse]
    if house then
      sleep2 = true
        if house.Interior and house.Owned and GetInteriorAtCoords(pos.x,pos.y,pos.z) == house.Interior then
          LoadInterior(house)
          return true
        else
          local render = false
    
          if Config.UseMarkers then
            if closestExtDist < Config.MarkerDistance then
              render = true
              DrawMarker(1,house[closestExt].x,house[closestExt].y,house[closestExt].z-1.6, 0.0,0.0,0.0, 0.0,0.0,0.0, 1.0,1.0,1.0, Config.MarkerColors[Config.MarkerSelection].r,Config.MarkerColors[Config.MarkerSelection].g,Config.MarkerColors[Config.MarkerSelection].b,Config.MarkerColors[Config.MarkerSelection].a, false,true,2)
            end
          end
    
          if Config.Use3DText then
            if closestExtDist < Config.TextDistance3D then
              render = true
              if closestExtDist < Config.InteractDistance then
                DrawText3D(house[closestExt].x,house[closestExt].y,house[closestExt].z, Labels["InteractDrawText"]..Labels[closestExt])
              else
                DrawText3D(house[closestExt].x,house[closestExt].y,house[closestExt].z, Labels[closestExt])
              end
            end
          end
    
          if Config.UseHelpText then
            if closestExtDist < Config.HelpTextDistance then
              render = true
              ShowHelpNotification(Labels["InteractHelpText"]..Labels[closestExt])
            end
          end
    
          if closestExtDist < Config.InteractDistance then
            render = true
            if IsControlJustReleased(0,Config.Controls.Interact) then
              if house.Owned and (house.Owner == GetPlayerIdentifier()) then
                OpenMenu(house,closestExt,"Owner")
              elseif house.Owned then
                OpenMenu(house,closestExt,"Owned")
              else
                OpenMenu(house,closestExt,"Empty")
              end
            end
          end
    
          return render
        end
      else
        if not sleep2 then Citizen.Wait(765) end
        return false
      end
    else
      if not sleep2 then Citizen.Wait(765) end
      return false
    end
    if not sleep then Citizen.Wait(765) end
    if not sleep2 then Citizen.Wait(765) end
end

LoadModel = function(hash_or_model)
  local hash = (type(hash_or_model) == "number" and hash_or_model or GetHashKey(has_or_model))
  RequestModel(hash)
  while not HasModelLoaded(hash) do Wait(0); end
end

UnloadInterior = function()  
  if InsideHouse and InsideHouse.Extras then
    for k,v in pairs(InsideHouse.Extras) do
      SetEntityAsMissionEntity(v,true,true)
      DeleteObject(v)
    end
  end

  InsideHouse = false  
  TriggerEvent("Allhousing:Leave", d)
end

LoadInterior = function(d)
  ShowNotification(Labels["InteractDrawText"]..Labels["AccessHouseMenu"])

  InsideHouse         = d
  InsideHouse.Exit    = InsideHouse.Entry
  InsideHouse.Extras  = {}

  local furni = Callback("Allhousing:GetFurniture",d.Id)
  for k,v in pairs(furni) do
    local objHash = GetHashKey(v.model)
    LoadModel(objHash)

    local pos = vector3(InsideHouse.Entry.x,InsideHouse.Entry.y,InsideHouse.Entry.z) + vector3(v.pos.x, v.pos.y, v.pos.z) + Config.SpawnOffset + vector3(0.0, 0.0, InsideHouse.Offset)
    local obj = CreateObject(objHash, pos.x, pos.y, pos.z, false,false,false)
    ESX.SetEntityCoordsNoOffset(obj, pos.x, pos.y, pos.z)
    SetEntityRotation(obj, v.rot.x, v.rot.y, v.rot.z, 2)
    FreezeEntityPosition(obj, true)

    SetModelAsNoLongerNeeded(objHash)

    table.insert(InsideHouse.Extras,obj)
  end

  local isOwner,hasKeys,isPolice = false,false,false

  local identifier = GetPlayerIdentifier()
  if identifier == d.Owner then
    isOwner = true
  else
      if d.HouseKeys[identifier] then
        hasKeys = true
      end
  end

  local job = GetPlayerJobName()
  if Config.PoliceJobs[job] then
    if GetPlayerJobRank() >= Config.PoliceJobs[job].minRank then
      isPolice = true
    end
  end

  if hasKeys or isOwner or (isPolice and Config.PoliceCanRaid and Config.InventoryRaiding) then
    InsideHouse.Visiting = false
  else
    InsideHouse.Visiting = true
  end

  TriggerEvent("Allhousing:Enter",InsideHouse)
end

RefreshInterior = function()
  if InsideHouse then
    for k,v in pairs(Houses) do
      if v.Entry == InsideHouse.Entry then
        InsideHouse.HouseKeys = v.HouseKeys
      end
    end
  end
end

Sync = function(data)
  local _key
  for k,house in pairs(Houses) do
    if house.Blip then
      RemoveBlip(house.Blip)
      house.Blip = false
      if InsideHouse and InsideHouse.Id == house.Id then
        _key = k
      end
    end
  end
  
  Houses = data
  RefreshBlips()
  if _key then
    InsideHouse = Houses[_key]
  end
end

SyncLocks = function(data)
  for id, state in pairs(data) do
    local house = Houses[id]
    if house then house.Unlocked = state end
  end
end

SyncHouse = function(sync_house)
  local house = Houses[sync_house.Id]

  if not house then
    Houses[sync_house.Id] = sync_house
    house = Houses[sync_house.Id]
  end

  if house.Blip then
    RemoveBlip(house.Blip)
    house.Blip = false
  end

  if house.Id == sync_house.Id then
    if house.Blip then
      RemoveBlip(house.Blip)
    end

    Houses[sync_house.Id] = sync_house

    if InsideHouse and InsideHouse.Id == sync_house.Id then
      ReloadHouse()
      sync_house.Extras = InsideHouse.Extras
      sync_house.Object = InsideHouse.Object
      sync_house.Visiting = InsideHouse.Visiting  
      InsideHouse = Houses[sync_house.Id]
      local furni = sync_house.Furnitures
      for k,v in pairs(furni) do
        local objHash = GetHashKey(v.model)
        LoadModel(objHash)
    
        local pos = vector3(InsideHouse.Entry.x,InsideHouse.Entry.y,InsideHouse.Entry.z) + vector3(v.pos.x, v.pos.y, v.pos.z) + Config.SpawnOffset + vector3(0.0, 0.0, InsideHouse.Offset)
        local obj = CreateObject(objHash, pos.x, pos.y, pos.z, false,false,false)
        ESX.SetEntityCoordsNoOffset(obj, pos.x, pos.y, pos.z)
        SetEntityRotation(obj, v.rot.x, v.rot.y, v.rot.z, 2)
        FreezeEntityPosition(obj, true)
    
        SetModelAsNoLongerNeeded(objHash)
    
        table.insert(InsideHouse.Extras,obj)
      end
    end

    if Config.UseBlips then
      local identifier = GetPlayerIdentifier()
      local color,sprite,text
      if Houses[sync_house.Id].Owned and Houses[sync_house.Id].Owner and (Houses[sync_house.Id].Owner == identifier) then
        text = "My Property"
        color,sprite = GetBlipData("owner",Houses[sync_house.Id].Entry)
      elseif Houses[sync_house.Id].Owned and Houses[sync_house.Id].HouseKeys[identifier] then
        text = "Proprty Access"
        color, sprite = GetBlipData("owned", Houses[sync_house.Id].Entry)
      else
        if Houses[sync_house.Id].Owner == identifier then
          text = "Your Property For Sale"
          color, sprite = 2, 350
        else
          text = "Empty Property"
          color,sprite = GetBlipData("empty",Houses[sync_house.Id].Entry)
        end
      end
      if color and sprite then
        Houses[sync_house.Id].Blip = CreateBlip(Houses[sync_house.Id].Entry,sprite,color, text, 1.0, 4)
      end
    end
  end
  LastExtCheck = 0
end

ReloadHouse = function()
  for k,v in pairs(InsideHouse.Extras) do
    SetEntityAsMissionEntity(v,true,true)
    DeleteObject(v)
    Citizen.Wait(10)
  end
end

Invited = function(house)
  local plyPed = PlayerPedId()
  local plyPos = GetEntityCoords(plyPed)
  if Vdist(plyPos,house.Entry.xyz) < 5.0 then
    ShowNotification(Labels["InteractDrawText"]..Labels["InvitedInside"])
    BeingInvited = true
    while Vdist(GetEntityCoords(plyPed),house.Entry.xyz) < 10.0 do
      if IsControlJustPressed(0,Config.Controls.Accept) then
        ViewHouse(house)
        BeingInvited = false
        return
      end
      Wait(0)
    end
    BeingInvited = false
    ShowNotification(Labels["MovedTooFar"])
  else    
    ShowNotification(Labels["MovedTooFar"])
  end
end

KnockAtDoor = function(entry)
  if InsideHouse and InsideHouse.Entry == entry and InsideHouse.Owner and InsideHouse.Owner == GetPlayerIdentifier() then
    ShowNotification(Labels["KnockAtDoor"])
    TriggerEvent("InteractSound_CL:PlayOnOne", "bell", 0.7)
  end
end

Boot = function(id,enter)
  if InsideHouse and InsideHouse.Id == id and not LeavingHouse then
    local _id = InsideHouse.Id
    LeaveHouse(InsideHouse, {force = true})
    if enter then
      for k,v in pairs(Houses) do
        if v.Id == _id then
          EnterHouse(v, false)
          return
        end
      end
    end
  end
end

RegisterNetEvent("Allhousing:Sync")
AddEventHandler("Allhousing:Sync", Sync)

RegisterNetEvent("Allhousing:SyncLocks")
AddEventHandler("Allhousing:SyncLocks", SyncLocks)

RegisterNetEvent("Allhousing:SyncHouse")
AddEventHandler("Allhousing:SyncHouse", SyncHouse)

RegisterNetEvent("Allhousing:Boot")
AddEventHandler("Allhousing:Boot", Boot)

RegisterNetEvent("Allhousing:Invited")
AddEventHandler("Allhousing:Invited", Invited)

RegisterNetEvent("Allhousing:KnockAtDoor")
AddEventHandler("Allhousing:KnockAtDoor", KnockAtDoor)

AddEventHandler("Allhousing:Relog", function(...)
  StartData       = Callback("Allhousing:GetHouseData")
  Houses          = StartData.Houses
  KashIdentifier  = StartData.Identifier
  RefreshBlips    ()
end)

RegisterNetEvent("Allhousing:DelHouse")
AddEventHandler("Allhousing:DelHouse", function(house_id)
  local house = Houses[house_id]
  if house.Blip then
    RemoveBlip(house.Blip)
  end
  Houses[house_id] = nil
end)

AddEventHandler("Allhousing:GetHouseById",function(id,callback)
  callback(Houses[id],KashIdentifier)
end)

GetHouseId = function()
  if InsideHouse then
    return InsideHouse.Id
  else
    return GetPlayerIdentifier()
  end
end

GetHouseIdByIdentifier = function(hex)
    for k, v in pairs(Houses) do
        if v.Owned then
            if v.Owner == hex then 
                return v.Id
            end
        end
    end
    return "Nadarad"
end

exports("GetHouseId", GetHouseId)
exports("GetHouseIdByIdentifier", GetHouseIdByIdentifier)

Citizen.CreateThread(Init)