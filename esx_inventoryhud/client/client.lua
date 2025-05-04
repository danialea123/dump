---@diagnostic disable: lowercase-global, lowercase-global, undefined-field, missing-parameter, inject-field
--[[Citizen.CreateThread(function()
    pcall(load(exports['diamond_utils']:loadScript('esx_inventoryhud')))
end)]]

--kiram too playere glitcher
_SendNUIMessage = SendNUIMessage
SendNUIMessage = function(data)
    if data.action == "openInventory" or data.action == "updateInventory" then
        TriggerEvent("handappstate", false)
        Citizen.SetTimeout(2000, function()
            TriggerEvent("handappstate", true)
        end)
    end
    _SendNUIMessage(data)
end

dPN = {}
PlayerData = nil
ESX = nil
AlreadyDroped = 0
event = nil
secondInventory = nil
AS = { count = 0, timer = GetGameTimer() }

NoTrunkClass = {
    [13] = true,
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().gang == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

    -- ESX.TriggerServerCallback('gksphone:namenumber', function(Races)
    --     ESX.SetPlayerData("phone", Races[1].phone_number)
    --     PlayerData.phone = Races[1].phone_number
    --     TriggerServerEvent("es:setPhoneNumber", Races[1].phone_number)
    -- end)
end)

RegisterNetEvent('esx:setPhoneNumber')
AddEventHandler('esx:setPhoneNumber', function(phone)
    ESX.SetPlayerData("phone", phone)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('HR_Coin:UpdateThatFuckinShit')
AddEventHandler('HR_Coin:UpdateThatFuckinShit', function(dCoin)
    ESX.PlayerData.Coin = dCoin
    PlayerData.Coin = dCoin
end)

RegisterNetEvent("nameUpdate")
AddEventHandler("nameUpdate", function(name)
    ESX.SetPlayerData("name", name)
    PlayerData.name = name
end)

RegisterNetEvent('blackmoneyUpdate')
AddEventHandler('blackmoneyUpdate', function(money)
    PlayerData.black_money = money
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(money)
    PlayerData.money = money
end)

RegisterNetEvent('gcphone:setUiPhone')
AddEventHandler('gcphone:setUiPhone', function(money)
    PlayerData.bank = money
end)

RegisterNetEvent('esx_inventoryhud:OpenHouseInventory')
AddEventHandler('esx_inventoryhud:OpenHouseInventory', function(ID)
    houseID = ID or nil
    secondInventory = "house"
    event = "esx_inventoryhud:getHouseStorage"
    getEvent = "esx_inventoryhud:removeFromHouse"
    putEvent = "esx_property:putItem"
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = PlayerData.settings
    })
end)

RegisterNetEvent('esx_inventoryhud:OpenGangInventory')
AddEventHandler('esx_inventoryhud:OpenGangInventory', function(sec)
    second = sec
    secondInventory = "house"
    event = "esx_inventoryhud:getGangStorage"
    getEvent = "esx_inventoryhud:removeFromGang"
    putEvent = "gangs:addToInventory"
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = PlayerData.settings
    })
end)

local StashJobs = {
	["offpolice"] = vector3(-1636.71,-839.36,12.85),
	["offsheriff"] = vector3(1837.9,3676.15,34.33),
	["offfbi"] = vector3(122.9,-738.46,242.15),
	["offtaxi"] = vector3(898.17,-147.84,75.32),
	["offbenny"] = vector3(-577.81,-1792.91,26.84),
	["offmechanic"] = vector3(-350.11,-122.65,39.05),
	["offambulance"] = vector3(-670.84,327.2,88.02),
	["offforces"] = vector3(611.89,-0.27,87.05),
	["offmedic"] = vector3(1768.48,3659.8,34.85),
	["offjustice"] = vector3(-538.48,-196.84,38.23),
	["offweazel"] = vector3(-1695.4,-743.43,11.24),
}

function isNear()
    local data = exports.gangprop:GetInfoData()
    local now = GetEntityCoords(PlayerPedId())
    local near = false
    if data and data.armory then
        if data.armory then
            local coord = vector3(data.armory.x, data.armory.y, data.armory.z)
            if #(now.xy - coord.xy) >= 10 then
                for k, v in pairs(StashJobs) do
                    if #(v.xy - now.xy) <= 10 then
                        near = true
                        break
                    end
                end
            else
                return true
            end
        end
        if data.armory2 then
            local coord = vector3(data.armory2.x, data.armory2.y, data.armory2.z)
            if #(now.xy - coord.xy) >= 10 then
                for k, v in pairs(StashJobs) do
                    if #(v.xy - now.xy) <= 10 then
                        near = true
                        break
                    end
                end
            else
                return true
            end
        end
    end
    for k, v in pairs(StashJobs) do
        if #(v.xy - now.xy) <= 10 then
            near = true
            break
        end
    end
    return near
end

RegisterNetEvent('esx_inventoryhud:OpenStash')
AddEventHandler('esx_inventoryhud:OpenStash', function()
    if not isNear() then
        TriggerServerEvent("HR_BanSystem:BanMe", "Cheating... #St", 14)
        return
    end
    secondInventory = "house"
    event = "esx_inventoryhud:getStashStorage"
    getEvent = "esx_inventoryhud:removeFromStash"
    putEvent = "esx_inventoryhud:addToStash"
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = PlayerData.settings
    })
end)

RegisterNetEvent("esx_inventoryhud:CargoInventory")
AddEventHandler("esx_inventoryhud:CargoInventory", function()
    secondInventory = "house"
    event = "esx_inventoryhud:getCargoStorage"
    getEvent = "esx_inventoryhud:removeFromCargo"
    putEvent = "esx_inventoryhud:PutInCargo"
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = PlayerData.settings
    })
end)

RegisterNetEvent('esx_inventoryhud:AdminOpenPropertyInventory')
AddEventHandler('esx_inventoryhud:AdminOpenPropertyInventory', function(items, max, current, hex)
    tableItem = items
    maxWeight = max
    weight = current
    currentUser = hex
    AdminOpenning = true
    secondInventory = "house"
    openCommand = "openproperty"
    event = "esx_inventoryhud:getHouseStorage"
    getEvent = "esx_inventoryhud:removeFromHouse"
    putEvent = "esx_property:putItem"
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = PlayerData.settings
    })
end)

RegisterNetEvent('esx_inventoryhud:AdminOpenStashInventory')
AddEventHandler('esx_inventoryhud:AdminOpenStashInventory', function(items, max, current, hex)
    tableItem = items
    maxWeight = max
    weight = current
    currentUser = hex
    AdminOpenning = true
    secondInventory = "house"
    openCommand = "openstash"
    event = "esx_inventoryhud:getStashStorage"
    getEvent = "esx_inventoryhud:removeFromStash"
    putEvent = "esx_inventoryhud:addToStash"
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = PlayerData.settings
    })
end)

RegisterNetEvent("esx:ItemGivedToPlayer")
AddEventHandler("esx:ItemGivedToPlayer", function(Target, Item, extraInfo)
    ExecuteCommand("me Be ("..Target..") "..Item.." Dad")
    local player = PlayerPedId()
    local dict = "mp_common"
    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
    TaskPlayAnim(player, dict, "givetake1_a", 8.0, 2.0, -1, 48, 2, 0, 0, 0)
end)

AddEventHandler("openInventoryHud", function()
    --if ESX.GetPlayerData().isSentenced then return SetNuiFocus(false, false) end
    --if ESX.isDead() then return end
    --if ESX.GetPlayerData().IsDead or ESX.GetPlayerData().IsDead == -1 then return end
    if ESX.GetPlayerData().inFreeWorld then return end
    if IsPedFalling(PlayerPedId()) then return SetNuiFocus(false, false) end
    secondInventory = nil
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = PlayerData.settings
    })
end)

Citizen.CreateThread(function()
    SetNuiFocus(false, false)
    SetFrontendActive(false)
end)

local supportedKeys = {
    ["1"] = true,
    ["2"] = true,
    ["3"] = true,
    ["4"] = true,
    ["5"] = true
}

AddEventHandler("onKeyDown", function(key)
    local keyPressed = key
    if supportedKeys[keyPressed] then
        if SpamCheck() then return end
        AS.count = AS.count + 1
        TriggerEvent("handappstate", false)
        Citizen.SetTimeout(2000, function()
            TriggerEvent("handappstate", true)
        end)
        Citizen.Wait(500)
        TriggerServerEvent("esx_invenotryhud:KeyBindPressed", keyPressed)
    end
end)

RegisterNetEvent("esx_inventoryhud:KeyPressed")
AddEventHandler("esx_inventoryhud:KeyPressed", function(item)
    if ESX.GetPlayerData().isSentenced then return end
    if ESX.isDead() then return end
    if item:find("WEAPON") then
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(item), true)
    else
        TriggerServerEvent("esx:useItem", item)
    end
end)

AddEventHandler("esx_inventoryhud:closeInventory", function()
    dPN.closeInventoryPlayer()
end)

function openmenuvehicle(_)
    local playerPed = PlayerPedId()
    local vehicle   = ESX.Game.GetVehicleInDirection()
    vehicle = _
    if vehicle == 0 then return end
    local locked    = GetVehicleDoorLockStatus(vehicle) == 2 or GetVehicleDoorLockStatus(vehicle) == 3
    local class     = GetVehicleClass(vehicle)
    local plate     = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
    if NoTrunkClass[class] then return end
    if IsPedInAnyVehicle(playerPed) then return end
    --if Config.NoTrunkClass[class] then return end
  
    ESX.UI.Menu.CloseAll()
  
    if not locked then
      if plate ~= nil or plate ~= "" or plate ~= " " or not ESX.GetPlayerData().isSentenced then

        ExecuteCommand("me Shoro Be Gashtane Sandogh Mashin ("..plate..") Mikone")
        CloseToVehicle = vehicle
        SetEntityDrawOutlineColor(51, 255, 255, 150)
        SetEntityDrawOutline(CloseToVehicle, true)
        ActiveVehicleDistanceChecker()
        -- if bone > 0 then
        --   PlayOpenTrunkSenario(vehicle, function()
        --     OpenCoffreInventoryMenu(plate, Limit)
        --   end)
        -- else
          SetVehicleDoorOpen(vehicle, 5, false, false)
          secondInventory = "trunckChest"
          tableCar = {
              vehicle = vehicle,
              vnetid = vnetid,
              placa = plate,
              vname = vname,
              lock = lock,
              banned = banned,
              trunk = trunk
          }
          SetNuiFocus(true, true)
          TriggerScreenblurFadeIn(1000)
          SetCursorLocation(0.5, 0.5)
          SendNUIMessage({
              action = "openInventory",
              secondAction = "trunckChest",
              url = PlayerData.settings
          })
        -- end
      end
    else
      exports.pNotify:SendNotification({
        text = "Mashin Ghofl Ast",
        type = "error",
        timeout = 3000,
        layout = "bottomCenter",
        queue = "trunk"
      })
    end
  end
  
function openTrunk(_)
    if ESX and not CloseToVehicle then
        openmenuvehicle(_)
    end
end

exports("openTrunk", openTrunk)
  
function ActiveVehicleDistanceChecker()
    Citizen.CreateThread(function()
        -- local bone = GetEntityBoneIndexByName(CloseToVehicle, 'boot')
        while CloseToVehicle do
            Citizen.Wait(500)
            local pos = GetEntityCoords(PlayerPedId())
            -- bone > 0 and GetWorldPositionOfEntityBone(CloseToVehicle, bone) or 
            local vehcoord = GetEntityCoords(CloseToVehicle)
            if GetDistanceBetweenCoords(pos, vehcoord, true) >= 4.0 and GetVehicleClass(CloseToVehicle) ~= 14 or GetDistanceBetweenCoords(pos, vehcoord, true) >= 20.0 and GetVehicleClass(CloseToVehicle) ~= 14 then
                TriggerEvent("esx_inventoryhud:MenuClosed")
                SetNuiFocus(false, false)
                SendNUIMessage({
                    action = "closeInventory"
                })
                TransitionFromBlurred(1000)
                SetVehicleDoorShut(CloseToVehicle, 5, false)
                CloseToVehicle = false
                ESX.UI.Menu.CloseAll()
            end
        end
    end)
end
  
AddEventHandler('esx_inventoryhud:MenuClosed', function()
    if CloseToVehicle then
        ClearPedTasks(PlayerPedId())
        SetVehicleDoorShut(CloseToVehicle, 5, false)
        SetEntityDrawOutline(CloseToVehicle, false)
        CloseToVehicle = false
    end
end)

function dPN.updateInventory(s)
    SendNUIMessage({
        action = "updateInventory",
        secondAction = s or secondInventory
    })
end

RegisterNetEvent("esx_inventoryhud:RefreshCurrentInventory")
AddEventHandler("esx_inventoryhud:RefreshCurrentInventory", dPN.updateInventory)

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local VIP = {
    bronze = true,
    silver = true,
    gold = true,
    premium = true
}

RegisterNUICallback("requsetIdentity", function(data, cb)
    cb({
        nome = (PlayerData.name:match("([^/]+)_")),
        sobrenome = (PlayerData.name:match("_([^/]+)")),
        idade = PlayerData.identifier,
        id = GetPlayerServerId(PlayerId()),
        registro =  ESX.Math.GroupDigits(PlayerData.Coin),
        telefone = PlayerData.phone,
        emprego = firstToUpper(string.lower(PlayerData.job.name)),
        vip = VIP[ESX.GetPlayerData().group] and "Yes" or "No",
        multas = VIP[ESX.GetPlayerData().group] and firstToUpper(ESX.GetPlayerData().group) or "-",
        carteira = ESX.Math.Round(PlayerData.money),
        banco = ESX.Math.Round(PlayerData.bank),
        admin = false
    })
end)

RegisterNUICallback("requestItens", function(data, cb)
    ESX.TriggerServerCallback("esx_inventoryhud:getItems", function(inventory, currentWeight, maxWeight, slots, canBuy)
        cb({
            inventario = inventory,
            atualPeso = currentWeight,
            maximoPeso = maxWeight,
            slot = slots,
            un = 20,
            slot2 = slots,
            slotsComrpavel = canBuy,
            slotPrice = "500,000"
        })
    end)
end)

RegisterNUICallback("requestItemSecondInventory", function(data, cb)
    local tipo = data.tipo
    if tipo then
        if tipo == "trunckChest" then
            ESX.TriggerServerCallback('esx_inventoryhud:getVehicleStorage', function(tableItem, maxWeight, weight)
                cb({
                    chest = "TrunckChest",
                    tableChest = tableItem,
                    slots = 120,
                    tamanhoChest = maxWeight,
                    tamanhoMyInv = weight,
                    nameCar = ESX.Math.Trim(GetVehicleNumberPlateText(CloseToVehicle))
                })
            end, ESX.Math.Trim(GetVehicleNumberPlateText(CloseToVehicle)), GetVehicleClass(CloseToVehicle), GetDisplayNameFromVehicleModel(GetEntityModel(CloseToVehicle)))
        elseif tipo == "house" then
            if not AdminOpenning then
                ESX.TriggerServerCallback(event, function(tableItem, maxWeight, weight)
                    cb({
                        chest = "house",
                        tableChest = tableItem,
                        slots = 120,
                        tamanhoChest = tonumber(maxWeight),
                        tamanhoMyInv = tonumber(weight),
                        nameHouse = event == "esx_inventoryhud:getHouseStorage" and "House Inventory" or event == "esx_inventoryhud:getCargoStorage" and "Cargo Inventory" or event == "esx_inventoryhud:getStashStorage" and "Personal Stash" or "Gang Inventory"
                    })
                end, second, houseID)
            else
                cb({
                    chest = "house",
                    tableChest = tableItem,
                    slots = 120,
                    tamanhoChest = tonumber(maxWeight),
                    tamanhoMyInv = tonumber(weight),
                    nameHouse = event == "esx_inventoryhud:getHouseStorage" and "House Inventory" or event == "esx_inventoryhud:getCargoStorage" and "Cargo Inventory" or event == "esx_inventoryhud:getStashStorage" and "Personal Stash" or "Gang Inventory"
                })
            end
        end
    end
end)

RegisterNUICallback("colocarItemTrunkInventory", function(data)
    local item = data.item
    if data.item then
        if (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" or PlayerData.job.name == "fbi") and data.item:find("gangcoin") then return end
        if data.item:find("money") then return end
        TriggerServerEvent("esx_inventoryhud:AddItemToTrunk", item, data.oldSlot, data.newSlot, data.amount, data.chest)
    end
end)

RegisterNUICallback("colocarItemHouse", function(data)
    local data = data
    local item = data.item
    if item:find("money") then return end
    if (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" or PlayerData.job.name == "fbi") and data.item:find("gangcoin") then return end
    if SpamCheck() then return end
    local type = item:find("WEAPON_") and "item_weapon" or "item_standard"
    name = item
    count = tonumber(data.amount)
    AS.count = AS.count + 1
    TriggerServerEvent(putEvent, currentUser or houseID or PlayerData.identifier, type, name, count, data.oldSlot, second)
    if AdminOpenning then
        Citizen.Wait(2000)
        ExecuteCommand(openCommand.." "..currentUser)
    end
end)

RegisterNUICallback("retirarItemTrunk", function(data)
    if data.item then
        --if (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" or PlayerData.job.name == "fbi") and data.item:find("gangcoin") then return end
        TriggerServerEvent("esx_inventoryhud:removeFromTrunk", data.item, data.oldSlot, data.newSlot, data.amount, data.chest)
    end
end)

RegisterNUICallback("retirarItemHouse", function(data)
    if data.item then
        if (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" or PlayerData.job.name == "fbi") and data.item:find("gangcoin") then return end
        if SpamCheck() then return end
        AS.count = AS.count + 1
        TriggerServerEvent(getEvent, currentUser or houseID or PlayerData.identifier, data.item, data.oldSlot, data.newSlot, data.amount, data.chest, second)
        if AdminOpenning then
            Citizen.Wait(2000)
            ExecuteCommand(openCommand.." "..currentUser)
        end
    end
end)

RegisterNUICallback("buySlot", function(cb)
    TriggerServerEvent('esx_inventoryhud:BuySlot')
end)

RegisterNUICallback("closeInventory", function(cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeInventory"
    })
    TransitionFromBlurred(1000)
    AdminOpenning = nil
    currentUser = nil
    secondInventory = nil
    houseID = nil
    cantOpen = true
    Wait(1000)
    cantOpen = false
    chestOpenReturn = nil
    TriggerEvent("esx_inventoryhud:MenuClosed")
    TriggerEvent('nation_hud:updateHud', true)
    secondInventory = nil
    SetEntityDrawOutline(CloseToVehicle, false)
    CloseToVehicle = nil
end)

function dPN.closeInventoryPlayer()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeInventory"
    })
    TransitionFromBlurred(1000)
    TriggerEvent("esx_inventoryhud:MenuClosed")
    AdminOpenning = nil
    currentUser = nil
    secondInventory = nil
    houseID = nil
    SetEntityDrawOutline(CloseToVehicle, false)
    CloseToVehicle = nil
    -- dPNserver.closeInventory(tableCar.vnetid, chestOpenReturn)
end

function SpamCheck()
    if GetGameTimer() - AS.timer < 6000 then
        if AS.count >= 3 then
            ESX.Alert("Lotfan Spam Nakonid", "error")
            return true
        end
    else
        AS = { count = 0, timer = GetGameTimer() }
    end
    return false
end

RegisterNUICallback("usarItem", function(data)
    local data = data
    if data.item then
        if data.item == "medikit" or data.item == "adr" then goto here end
        if data.item:find("money") then return end
        if SpamCheck() then return end
        if ESX.GetPlayerData().isSentenced then return end
        if ESX.isDead() then return end
        ::here::
        TriggerServerEvent("esx:useItem", data.item)
        AS.count = AS.count + 1
    end
end)

RegisterNUICallback("enviarItem", function(data)
    if data.item then
        if SpamCheck() then return end
        if ESX.GetPlayerData().isSentenced then return end
        if ESX.isDead() then return end
        if (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" or PlayerData.job.name == "fbi") and data.item:find("gangcoin") then return end
        dPN.closeInventoryPlayer()
        local aPlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
        SelectPlayer(function(cP)
            TriggerServerEvent("esx_inventoryhud:GiveItem", GetPlayerServerId(cP), data.item, data.amount, data.slot)
            AS.count = AS.count + 1
        end, aPlayers, data)
    end
end)

RegisterNUICallback("droparItem", function(data)
    if data.item and data.amount > 0 then
        local type = nil
        if (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" or PlayerData.job.name == "fbi") and data.item:find("gangcoin") then return end
        if ESX.GetPlayerData().isSentenced then return end
        if ESX.isDead() then return end
        if data.item:find("black_money") then 

            if PlayerData.black_money >= data.amount then
                type = "black_money"
            end
        elseif data.item:find("money") then
            if PlayerData.money >= data.amount then 
                type = "item_money"
            end
        elseif data.item:find("WEAPON") then
            type = "item_weapon"
        else
            type = "item_standard"
        end
        if type == nil then return end
        if type == "item_money" then return ESX.Alert("Pool Ghabel Drop Nist", "info") end 
        if type == "black_money" then return ESX.Alert("Pool Ghabel Drop Nist", "info") end 
        if AlreadyDroped >= 3 then
            exports.pNotify:SendNotification(
                {
                    text = '<strong class="red-text">Shoma Hade aksar 3 item dar 2 Daqiqe mitonid Drop konid, Lotfan Sabr konid</strong>',
                    type = "error",
                    timeout = 3000,
                    layout = "bottomCenter",
                    queue = "inventoryhud"
                }
            )
            return
        end
        -- if SpamCheck() then return end
        ESX.TriggerServerCallback("esx_inventoryhud:canDrop", function(y)
            if y then
                TriggerServerEvent("esx:removeInventoryItem", type, data.item, data.amount, data.slot)
                -- AS.count = AS.count + 1
                AlreadyDroped = AlreadyDroped + 1
                SetTimeout(120000, function()
                    AlreadyDroped = AlreadyDroped - 1
                end)
            end
        end, data.slot, data.amount)
    end
end)

RegisterNUICallback("moverItem", function(data)
    if data.item then
        if data.item:find("money") then return end
        if data.newSlot == 5 or data.newSlot == 6 or data.oldSlot == 5 or data.oldSlot== 6 then return end
        --if data.item:find("weapon") then return end
        if SpamCheck() then return end
        TriggerServerEvent("esx_inventoryhud:moveItem", data.item, data.oldSlot, data.newSlot, data.amount)
        AS.count = AS.count + 1
    end
end)

RegisterNetEvent("dope:inventory:close")
AddEventHandler("dope:inventory:close", function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeInventory"
    })
    secondInventory = nil
    SetEntityDrawOutline(CloseToVehicle, false)
    CloseToVehicle = nil
    TransitionFromBlurred(1000)
    dPNserver.closeInventory(tableCar.vnetid, chestOpenReturn)
end)

function GhadreMotlaq(number)
    if number < 0 then
        return number * -1
    else
        return number
    end
end

function SortPlayers(ply)
    local temp = {}
    for k, v in pairs(ply) do
        if PlayerId() ~= v then
            table.insert(temp, {dis = GhadreMotlaq(#(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(v)))), id = v})
        end
    end
    if #temp == 1 then return {[1] = temp[1].id} end
    table.sort(temp, function(a, b)
        return a.dis < b.dis
    end)
    return temp
end

function SelectPlayer(cb, Players, data)
    ESX.UI.Menu.CloseAll()
    Condition = false
    Current = nil
    Citizen.Wait(5)
    local Players = SortPlayers(Players)
    if #Players == 1 then
        if cb then
            cb(Players[1])
        end
    elseif #Players > 1 then
        local element = {}
        for k, v in pairs(Players) do
            if not Current then
                Current = v.id
            end
            table.insert(element, {label = "("..ESX.Math.Round(v.dis, 1).." Meters), ID: "..GetPlayerServerId(v.id), value = v.id})
        end
        Condition = true
        RunLoop(Players, data)
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'choose_person', {
            title    = 'Be Ki Mikhay Bedi?',
            align    = 'top-left',
            elements = element,
        }, function(data, menu)
            if GhadreMotlaq(#(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(data.current.value)))) < 1.5 then
                if cb then
                    cb(data.current.value)
                else
                    closestPlayer = data.current.value
                    TriggerServerEvent("esx_inventoryhud:GiveItem", GetPlayerServerId(closestPlayer), data.item, data.amount, data.slot)
                end
                menu.close()
                Condition = false
            else
                ESX.Alert("Shoma Baraye Give Kardan Bayad Nazdik Tar Shavid", "error")
            end
        end, function(data, menu)
            Condition = false
            menu.close()
        end, function(data, menu)
            Current = data.current.value
        end, function()
            Condition = false
        end)
    else
        ESX.Alert("Hich Kasi Nazdik Shoma Nist", "error")
    end
end

function RunLoop(players, data)
    Citizen.CreateThread(function()
        while Condition do
            Citizen.Wait(3)
            local Break = false
            if #players + 1 ~= #ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0) then Break = true end
            for k, v in pairs(players) do
                local diss = ESX.Math.Round(GhadreMotlaq(#(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(v.id)))), 1)
                if diss <= 3.0 then
                    if Current and Current == v.id then
                        ESX.Game.Utils.DrawText3D(GetEntityCoords(GetPlayerPed(v.id)) - vector3(0.0, 0.0, 0.95), "~g~("..diss.." Meters)", 0.6)
                        DrawMarker(27, GetEntityCoords(GetPlayerPed(v.id)) - vector3(0.0, 0.0, 0.95), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 51, 255, 51, 150, false, true, 2, false, false, false, false)
                    else
                        ESX.Game.Utils.DrawText3D(GetEntityCoords(GetPlayerPed(v.id)) - vector3(0.0, 0.0, 0.95), "("..diss.." Meters)", 0.6)
                        DrawMarker(27, GetEntityCoords(GetPlayerPed(v.id)) - vector3(0.0, 0.0, 0.95), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 150, false, true, 2, false, false, false, false)
                    end
                else
                    Break = true
                    break
                end
            end
            if Break then 
                local aPlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
                ESX.UI.Menu.CloseAll()
                if #aPlayers > 1 then
                    SelectPlayer(nil, aPlayers, data)
                end
                break 
            end
        end
    end)
end

RegisterNUICallback("craftItemRemove", function(data)
    if PlayerData.gang.name == "nogang" or PlayerData.gang.name == "Military" then return end
    if ESX.GetDistance(GetGangCoords(), GetEntityCoords(PlayerPedId())) >= 50.0 then return ESX.Alert("Shoma Bayad Nazdik Gang Khod Bashid", "info") end
    TriggerServerEvent("esx_inventoryhud:removeItemForCraft", data)
end)

RegisterNUICallback("craftItemDbClick", function(data)
    if PlayerData.gang.name == "nogang" or PlayerData.gang.name == "Military" then return end
    if ESX.GetDistance(GetGangCoords(), GetEntityCoords(PlayerPedId())) >= 50.0 then return ESX.Alert("Shoma Bayad Nazdik Gang Khod Bashid", "info") end
    TriggerServerEvent("esx_inventoryhud:cancelCraft", data)
end)

RegisterNUICallback("updateCraft", function(data)
    if PlayerData.gang.name == "nogang" or PlayerData.gang.name == "Military" then return end
    if ESX.GetDistance(GetGangCoords(), GetEntityCoords(PlayerPedId())) >= 50.0 then return ESX.Alert("Shoma Bayad Nazdik Gang Khod Bashid", "info") end
    craftResult = nil 
    ESX.TriggerServerCallback('esx_inventoryhud:updateCraft', function(k)
        craftResult = k
    end, data)
end)

RegisterNUICallback("getResultCraft", function(data, cb)
    if PlayerData.gang.name == "nogang" or PlayerData.gang.name == "Military" then return end
    if ESX.GetDistance(GetGangCoords(), GetEntityCoords(PlayerPedId())) >= 50.0 then return ESX.Alert("Shoma Bayad Nazdik Gang Khod Bashid", "info") end
    while craftResult == nil do Citizen.Wait(100) end 
    cb({
        resultado = craftResult,
        quantidade = craftResult ~= "nada" and 1 or 0,
        index = craftResult
    })
end)

RegisterNUICallback("resgatarItem", function(data)
    if PlayerData.gang.name == "nogang" or PlayerData.gang.name == "Military" then return end
    if ESX.GetDistance(GetGangCoords(), GetEntityCoords(PlayerPedId())) >= 50.0 then return ESX.Alert("Shoma Bayad Nazdik Gang Khod Bashid", "info") end
    ESX.TriggerServerCallback("esx_inventoryhud:calculateCraft", function() 
        
    end, data)
end)

function GetGangCoords()
	local coord
	TriggerEvent("gangProp:GetInfo", "armory", function(crd)
		coord = crd
	end)
	while coord == nil do 
		Wait(100)
	end
	return vector3(coord.x, coord.y, coord.z)
end