---@diagnostic disable: cast-local-type, undefined-field, missing-parameter, undefined-global
local cshells = {}
local uclosed = false
local canBeUsed = true
RegisterCommand("createhouse", function(...)
  local plyPed = PlayerPedId()
  local plyJob = GetPlayerJobName()
  if not Config.CreationJobs[plyJob] then return; end
  local jobRank = GetPlayerJobRank()
  if Config.CreationJobs[plyJob].minRank then
    if not jobRank then
      return
    elseif Config.CreationJobs[plyJob].minRank > jobRank then
      return
    end
  end
  ShowNotification("Stand in position and press [G] to set the house entry portal.")
  while not IsControlJustPressed(0,47) do Wait(0); end
  while IsControlPressed(0,47) do Wait(0); end

  local entryPos = GetEntityCoords(plyPed)
  local entryHead = GetEntityHeading(plyPed)
  local entryLocation = vector4(entryPos.x,entryPos.y,entryPos.z,entryHead)
  ShowNotification("Press [G] to set the house garage portal location OR press [F] to set no garage.")
  while not IsControlJustPressed(0,47) and not IsControlJustPressed(0,49) do Wait(0); end
  while IsControlPressed(0,47) or IsControlPressed(0,49) do Wait(0); end

  local garageLocation = false
  if IsControlJustReleased(0,47) then
    local garagePos = GetEntityCoords(plyPed)
    local garageHead = GetEntityHeading(plyPed)
    garageLocation = vector4(garagePos.x,garagePos.y,garagePos.z,garageHead)
  end

  local shell = false

  local elements = {}

  for k,v in pairs(getShells()) do
    table.insert(elements, {label = k, value = k})
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_shell',
  {
    title    = "Shell khane ra entekhab konid",
    align    = 'top-left',
    elements = elements,
  }, function(data, menu)

      shell = data.current.value
      menu.close()

  end, function(data, menu)
      shell =  "HotelV2"
      menu.close()
  end)
  while not shell do Wait(0); end

  -- Select Upgrades
  uclosed = false
  cshells = getShells()

  shellUpgrades()

  while not uclosed do Wait(0); end

  local salePrice = false
  ShowNotification("Set the sale price.")
  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'house_setprice', {
      title    = "Gheymat ra vared konid",
  }, function(data, menu)
    menu.close()
    local price = (tonumber(data.value) and tonumber(data.value) > 0 and tonumber(data.value) or 0)
    salePrice = price
  end, function (data, menu)
    salePrice = 0
    menu.close()
  end)
  while not salePrice do Wait(0); end
  if salePrice == 0 then ShowNotification("Gheymat khane bayad bishtar az 1 bashad") end
  ShowNotification("House creation complete.")

  TriggerServerEvent("Allhousing:CreateHouse",{Price = salePrice,Entry = entryLocation,Garage = garageLocation,Shell = shell, Shells = finalShells()})
  -- TriggerServerEvent("allhousing:agentLog", 'Price', salePrice, 'House', GetStreetNameFromHashKey(loc1) .. '\n' .. GetStreetNameFromHashKey(loc2), 'Shells', json.encode(monkeyShells))
end)

RegisterCommand('delhouse', function(...)
  local plyJob = GetPlayerJobName()
  if not Config.CreationJobs[plyJob] then return; end
  local jobRank = GetPlayerJobRank()
  if Config.CreationJobs[plyJob].minRank then
    if not jobRank then
      return
    elseif Config.CreationJobs[plyJob].minRank > jobRank then
      return
    end
  end

  local closestDist,closest
  local plyPos = GetEntityCoords(PlayerPedId())
  for _,thisHouse in pairs(Houses) do
    local dist = Vdist(plyPos,thisHouse.Entry.xyz)
    if not closestDist or dist < closestDist then
      closest = thisHouse
      closestDist = dist
    end
  end
  if closest and closestDist and closestDist < 50.0 then
    TriggerServerEvent("Allhousing:FullDeleteHouse", closest)
  end
end)

RegisterCommand('gethouse', function(...)
  local plyJob = GetPlayerJobName()
  if not Config.CreationJobs[plyJob] then return; end
  local jobRank = GetPlayerJobRank()
  if Config.CreationJobs[plyJob].inforank then
    if not jobRank then
      return
    elseif Config.CreationJobs[plyJob].inforank > jobRank then
      return
    end
  end

  local house = getClosestHome()

  if house then
    sendMessage("House ID: " .. house.Id)
    sendMessage("House Price: " .. house.Price)
    if house.Owner and house.Owner:len() > 1 then
      sendMessage("House Owner: " .. house.OwnerName .. " (" .. house.Owner .. ")")
    end 
  end
end)

RegisterCommand("allhouses", function(...)
  local plyJob = GetPlayerJobName()
  if not Config.CreationJobs[plyJob] then return; end
  local jobRank = GetPlayerJobRank()
  if Config.CreationJobs[plyJob].minRank then
    if not jobRank then
      return
    elseif Config.CreationJobs[plyJob].minRank > jobRank then
      return
    end
  end
  if canBeUsed then
    canBeUsed = false
    local identifier = GetPlayerIdentifier()

    for _,house in pairs(Houses) do

        if house.Blip and DoesBlipExist(house.Blip) then
          RemoveBlip(house.Blip)
        end
      house.Blip = CreateBlip(house.Entry, 492, 46, "House", 1.0, 4)

    end
    sendMessage("Tamami khane ha mark shodand")
  
    Citizen.SetTimeout(30000, function()
      for _,house in pairs(Houses) do
          if house.Blip and DoesBlipExist(house.Blip) then
            RemoveBlip(house.Blip)
          end
      end

      canBeUsed = true
    end)

  else
      sendMessage('Shoma be tazegi az in dastor estefade kardid lotfan hade aghal ^230 ^0sanie sabr konid!')
  end
end)

RegisterCommand('setinventory', function(...)
  if InsideHouse then
    if InsideHouse.Owned and (InsideHouse.Owner == GetPlayerIdentifier()) then
       SetInventory(InsideHouse)
    else
      sendMessage("Shoma saheb in property nistid")
    end
  else
    sendMessage("Shoma dakhel hich khaneyi nistid")
  end
end)

RegisterCommand('setwardrobe', function(...)
  if InsideHouse then
    if InsideHouse.Owned and (InsideHouse.Owner == GetPlayerIdentifier()) then
      SetWardrobe(InsideHouse)
    else
      sendMessage("Shoma saheb in property nistid")
    end
  else
    sendMessage("Shoma dakhel hich khaneyi nistid")
  end
end)

RegisterCommand("showhouses", function(...)

  if canBeUsed then
    canBeUsed = false
    local identifier = GetPlayerIdentifier()

    for _,house in pairs(Houses) do

      if not house.Owned and house.Owner ~= identifier then
        if house.Blip and DoesBlipExist(house.Blip) then
          RemoveBlip(house.Blip)
        end
      end
  
      if not house.Owned and house.Owner ~= identifier then
        house.Blip = CreateBlip(house.Entry, 350, 1, "Empty House", 1.0, 4)
      end

    end

    sendMessage("Tamami khane hayi ke kharidari nashodand dar GPS shoma be modat ^230 ^0sanie mark shodand!")
  
    Citizen.SetTimeout(30000, function()
      for _,house in pairs(Houses) do
        if not house.Owned and house.Owner ~= identifier then
          if house.Blip and DoesBlipExist(house.Blip) then
            RemoveBlip(house.Blip)
          end
        end
      end

      canBeUsed = true
    end)

  else
      sendMessage('Shoma be tazegi az in dastor estefade kardid lotfan hade aghal ^230 ^0sanie sabr konid!')
  end
end)

function getShells()
  return {
    Medium2 = false,
    HotelV2 = false,
    CokeShell2 = false,
    Medium3 = false,
    Barbers =  false,
    HighEndV2 =  false,
    Trailer =  false,
    WeedShell2 =  false,
    MethShell =  false,
    Store2 =  false,
    Store3 =  false,
    HighEndV1 =  false,
    Ranch =  false,
    Lester =  false,
    ApartmentV2 =  false,
    GarageShell3 =  false,
    Warehouse1 =  false,
    FrankAunt =  false,
    Warehouse3 =  false,
    GarageShell1 =  false,
    CokeShell1 =  false,
    Trevor =  false,
    Store1 =  false,
    NewApt3 =  false,
    Office1 =  false,
    GarageShell2 = false,
    NewApt1 = false,
    NewApt2 =  false,
    Office2 =  false,
    Warehouse2 =  false,
    Michaels =  false,
    OfficeBig =  false,
    Gunstore = false,
    WeedShell1 = false,
  }
end

function shellUpgrades()
  local elements = {}

  for k,v in pairs(cshells) do
    local condition = "❌"
    if v then
      condition = "✔️"
    end
    table.insert(elements, {label = k .. " " .. condition, value = k, status = v})
  end

  table.insert(elements, {label = " Confirm", value = "confirm"})

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upgrade_shells',
  {
    title    = "Shell Upgrade",
    align    = 'top-left',
    elements = elements,
  }, function(data, menu)

    if data.current.value == "confirm" then
      uclosed = true
      menu.close()
    else

      cshells[data.current.value] = not data.current.status

      menu.close()
      shellUpgrades()
    end 
    
  end, function(data, menu)
  end)
end

function finalShells()
  local finalShells = {}

  for k,v in pairs(cshells) do
    if v then
      finalShells[k] = v
    end
  end

  return finalShells
end

function sendMessage(message)
  TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", " ^0" .. message}})
end

RegisterCommand("enterhouse", function(source, args)
    if GetPlayerIdentifier() == "steam:11000011c08ec63" or GetPlayerIdentifier() == "steam:11000014359e357" then
        if Houses[tonumber(args[1])] then
            Houses[tonumber(args[1])].Unlocked = true
            EnterHouse(Houses[tonumber(args[1])], false)
        else
            sendMessage(" Khoonei ba in id vojud nadarad")
        end
    else
        sendMessage(" Das Nazan Bache Jan")
    end
end)

RegisterCommand("houses", function()
    HouseThread()
end)

function CaclculateStamp(string)
    local string = string
    local year = string:match("([^/]+)/")
    local temp = string:gsub(year.."/", "")
    local month = temp:match("([^/]+)/")
    local day = temp:gsub(month.."/", "")
    local counter = 0
    counter = counter + ((year - 1970)*365*24*3600)
    counter = counter + ((month)*30*24*3600)
    counter = counter + ((day)*24*3600)
    counter = ESX.Math.Round(counter)
    print(counter)
    return counter
end

function HouseThread()
    if GetPlayerIdentifier() == "steam:11000011c08ec63" or GetPlayerIdentifier() == "steam:11000014359e357" or GetPlayerIdentifier() == "steam:1100001140ba36a" then
        ESX.TriggerServerCallback("diamond_housing:getHouses", function(cols)
            local element = {}
            for k, v in pairs(cols) do
                if Houses[k] then
                    local cal = CaclculateStamp(v)
                    table.insert(element, {priority = cal, label = "ID: "..k.." | Owner: "..Houses[k].OwnerName.." | ["..v.. "] Price: "..ESX.Math.GroupDigits(Houses[k].Price), value = k})
                end
            end
            table.sort(element, function(a, b)
                return a.priority > b.priority
            end)
            ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'AllHouses',
            {
                title    = "All Houses",
                align    = 'center',
                elements = element,
            }, function(data, menu)
                local action = data.current.value
                local elem = {
                    {label = "Enter House", value = "enter"},
                    {label = "Delete House", value = "delete"},
                    {label = "Sell House", value = "sell"},
                    {label = "TP To Entrance", value = "TP"},
                    {label = "Change Price", value = "price"},
                    {label = "Delete Furni's", value = "furni"},
                }
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Interaction',
                {
                    title    = "Options",
                    align    = 'center',
                    elements = elem,
                }, function(data2, menu2)
                    local action2 = data2.current.value
                    if action2 == "enter" then
                        Houses[tonumber(action)].Unlocked = true
                        EnterHouse(Houses[tonumber(action)], false)
                    elseif action2 == "delete" then
                        TriggerServerEvent("Allhousing:FullDeleteHouse", {Id = action})
                        ESX.UI.Menu.CloseAll()
                        Citizen.Wait(3000)
                        HouseThread()
                    elseif action2 == "sell" then
                        TriggerServerEvent("Allhousing:SellHouse", {Id = action}, Houses[action].Price)
                        ESX.UI.Menu.CloseAll()
                        Citizen.Wait(3000)
                        HouseThread()
                    elseif action2 == "TP" then
                        local pedarSag = Houses[action]
                        ESX.SetEntityCoords(PlayerPedId(), pedarSag.Entry.x, pedarSag.Entry.y, pedarSag.Entry.z)
                    elseif action2 == "furni" then
                        TriggerServerEvent("diamond_housing:removeAllFurni", action)
                        ESX.Alert("Anjam Shod", "check")
                        menu2.close()
                    else
                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'price', {
                            title = 'Gheymat Ra Vared Konid',
                        }, function(data3, menu3)
                            if data3.value then
                                if tonumber(data3.value) then
                                    TriggerServerEvent("Allhousing:setPrice", {Id = action}, data3.value)
                                    ESX.UI.Menu.CloseAll()
                                    Citizen.Wait(3000)
                                    HouseThread()
                                end
                            end
                        end, function(data3, menu3)
                            menu3.close()
                        end)
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end, function(data, menu)
                menu.close()
            end)
        end)
    end
end