local selectingPlayer = false
local prop = nil
local PlayerData = {}
local TriggerCallback
local Notification
local QBCore
ESX = nil

if Config.Framework == "esx" then
  Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
      Citizen.Wait(1000)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    PlayerData = ESX.GetPlayerData()
    if (PlayerData.identifier == "steam:1100001444bd4ac") or (PlayerData.gang.name == "STAFF" and PlayerData.gang.grade >= 10) then
        AddEventHandler("onKeyUP", function(key)
            if key == "e" and #(GetEntityCoords(PlayerPedId()) - vector3(965.97,42.4,123.13)) < 5.0 then
                --[[ESX.TriggerServerCallback('esx:requestHelicopter', function(res)]]
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        --if res then
                            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                        --else
                            --ESX.Alert("Shoma Ejazeye Park Kardan In Heli Ra Nadarid", "error") 
                        --end
                    else
                        --if res then
                            ESX.Game.SpawnVehicle("volatus", GetEntityCoords(PlayerPedId()), 123.00, function(Veh)
                                ESX.CreateVehicleKey(Veh)
                                TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
                                --TriggerServerEvent("esx:requestHelicopter", VehToNet(Veh))
                            end)
                        --else
                            --ESX.Alert("Shoma Az Ghabl Yek Heli Daravordid", "error") 
                        --end
                    end
                --end)
            end
        end)
    end
  end)

  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
  end)

  RegisterNetEvent('esx:setGang')
  AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
  end)

  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
  end)

  TriggerCallback = function (name, cb, ...) 
    ESX.TriggerServerCallback(name, cb, ...)
  end

  Notification = function (msg) 
    ESX.ShowNotification(msg)
  end

elseif Config.Framework == "qb" then
  QBCore = exports['qb-core']:GetCoreObject()
  TriggerCallback = function (name, cb, ...) 
    QBCore.Functions.TriggerCallback(name, cb, ...)
  end

  Notification = function (msg) 
    QBCore.Functions.Notify(msg)
  end
else
  print("^8ERROR: ^3Unsupported or misspelled framework^7")
end

function holdDocument(shouldHold)
    if shouldHold then
      detachPaper()

      playAnim("missfam4", "base")

      attachPaper()

    else 
      ClearPedTasks(GetPlayerPed(-1))
      detachPaper()
    end
end

function playAnim(dict, anim, duration)
  duration = duration or -1
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Wait(10)
  end

  TaskPlayAnim(GetPlayerPed(-1), dict, anim, 2.0, 2.0, duration, 51, 0, false, false, false)
  RemoveAnimDict(dict)
end

function attachPaper()
  local player = PlayerPedId()
  local x,y,z = table.unpack(GetEntityCoords(player))

  while not HasModelLoaded(GetHashKey(Config.PaperProp.name)) do
    RequestModel(GetHashKey(Config.PaperProp.name))
    Wait(10)
  end

  prop = CreateObject(GetHashKey(Config.PaperProp.name), x, y, z+0.2,  true,  true, true)
  SetEntityCompletelyDisableCollision(prop, false, false)
  AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 36029), 0.16, 0.08, 0.1, Config.PaperProp.xRot, Config.PaperProp.yRot, Config.PaperProp.zRot, true, true, false, true, 1, true)
  SetModelAsNoLongerNeeded(Config.PaperProp.name)
end

function detachPaper()
  DeleteEntity(prop)
end

local function toggleNuiFrame(shouldShow, shouldHoldDocument)
  holdDocument(shouldHoldDocument)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

local function toggleDocumentFrame(shouldShow, document)
  holdDocument(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setDocument', document)
end

RegisterNUICallback('hideDocument', function(_, cb)
  toggleDocumentFrame(false, nil)
  cb({})
end)

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false, false)
  cb({})
end)

RegisterNUICallback('getPlayerJob', function(data, cb)
  if Config.Framework == "esx" then
    local retData <const> = ESX.PlayerData.job
    retData.isBoss = retData.grade_name == "boss"
    cb(retData)
  elseif Config.Framework == "qb" then
    local PlayerJob = QBCore.Functions.GetPlayerData().job
    local retData = {
      grade = PlayerJob.grade.level,
      grade_label = PlayerJob.grade.name,
      grade_name = PlayerJob.grade.name,
      grade_salary = PlayerJob.payment,
      label = PlayerJob.label,
      name = PlayerJob.name,
      skin_female = {},
      skin_male = {},
    }
    retData.isBoss = PlayerJob.isboss
    cb(retData)
  end
end)

RegisterNUICallback('getPlayerData', function(data, cb)
  if Config.Framework == "esx" then
    ESX.TriggerServerCallback('k5_documents:getPlayerData', function(result)
      cb(result)
    end)
  elseif Config.Framework == "qb" then
    local PlayerData = QBCore.Functions.GetPlayerData().charinfo
    cb({
      firstname = PlayerData.firstname,
      lastname = PlayerData.lastname,
      dateofbirth = PlayerData.birthdate,
    })
  end
end)

RegisterNUICallback('getPlayerCopies', function(data, cb)
  TriggerCallback('k5_documents:getPlayerCopies', function(result)
    cb(result)
  end)
end)

RegisterNUICallback('getIssuedDocuments', function(data, cb)
  TriggerCallback('k5_documents:getPlayerDocuments', function(result)
    cb(result)
  end)
end)

RegisterNUICallback('createDocument', function(data, cb)
  TriggerCallback('k5_documents:createDocument',function(result)
    cb(result)
  end,
  data)
end)

RegisterNUICallback('createTemplate', function(data, cb)
  TriggerCallback('k5_documents:createTemplate',function(result)
    cb(result)
  end,
  data)
end)

RegisterNUICallback('editTemplate', function(data, cb)
  TriggerCallback('k5_documents:editTemplate',function(result)
    cb(result)
  end,
  data)
end)

RegisterNUICallback('deleteTemplate', function(data, cb)
  TriggerCallback('k5_documents:deleteTemplate',function(result)
    cb(result)
  end,
  data)
end)

RegisterNUICallback('deleteDocument', function(data, cb)
  TriggerCallback('k5_documents:deleteDocument',function(result)
    cb(result)
  end,
  data)
end)

RegisterNUICallback('getMyTemplates', function(data, cb)
  TriggerCallback('k5_documents:getDocumentTemplates', function(result)
    cb(result)
  end)
end)

RegisterNUICallback('giveCopy', function(data, cb)
  Citizen.CreateThread(function()
    local targetId = playerSelector(Config.Locale.giveCopy)
    if targetId == -1 then
      holdDocument(false)
    else
      TriggerServerEvent("k5_documents:giveCopy", data, targetId)
    end
  end)
end)

RegisterNUICallback('showDocument', function(data, cb)
  Citizen.CreateThread(function()
    local targetId = playerSelector(Config.Locale.showDocument)
    if targetId == -1 then
      holdDocument(false)
    else
      holdDocument(false)
      playAnim("mp_common", "givetake1_a", 1500)
      TriggerServerEvent("k5_documents:receiveDocument", data, targetId)
    end
  end)
end)

RegisterNetEvent('k5_documents:copyGave')
AddEventHandler('k5_documents:copyGave', function(data)
	holdDocument(false)
  playAnim("mp_common", "givetake1_a", 1500)
  Notification(Config.Locale.giveNotification .. " " .. data)
end)


RegisterNetEvent('k5_documents:copyReceived')
AddEventHandler('k5_documents:copyReceived', function(data)
  Notification(Config.Locale.receiveNotification .. " " .. data)
end)

RegisterNetEvent('k5_documents:viewDocument')
AddEventHandler('k5_documents:viewDocument', function(data)
	toggleDocumentFrame(true, data.data)
end)

--[[AddEventHandler("onKeyDown", function(key)
  if key == "f9" then
    toggleNuiFrame(true, true)
  end
end)]]

AddEventHandler("openDocs", function()
  if ESX.GetPlayerData().isSentenced then return end
  if ESX.isDead() then return end
  toggleNuiFrame(true, true)
end)

function playerSelector(confirmText)
  toggleNuiFrame(false, true, nil)
  selectingPlayer = true

  while selectingPlayer do
    local closestPlayer, closestPlayerDistance
    if Config.Framework == "esx" then
      closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    elseif Config.Framework == "qb" then
      closestPlayer, closestPlayerDistance = QBCore.Functions.GetClosestPlayer()
    end
    local closestPlayerCoords = GetEntityCoords(GetPlayerPed(closestPlayer))

    DisableControlAction(2, 200, true)

    if IsControlJustReleased(0, 202) then
      selectingPlayer = false
      return -1
    end

    BeginTextCommandDisplayHelp('main')
    AddTextEntry('main', "~INPUT_CONTEXT~ "..confirmText.."  ~INPUT_FRONTEND_PAUSE_ALTERNATE~ "..Config.Locale.cancel)
    EndTextCommandDisplayHelp(0, 0, 1, -1)

    if closestPlayer ~= -1 and closestPlayerDistance < 2.0 then
      DrawMarker(20, closestPlayerCoords.x, closestPlayerCoords.y, closestPlayerCoords.z + 1.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.4, 0.4, -0.4, 255, 255, 255, 100, false, true, 2, false, false, false, false)
      DrawMarker(25, closestPlayerCoords.x, closestPlayerCoords.y, closestPlayerCoords.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
      if IsControlJustReleased(0, 38) then
        selectingPlayer = false
        local targetId = GetPlayerServerId(closestPlayer)
        return targetId
      end
    else
      if IsControlJustReleased(0, 38) then
        Notification(Config.Locale.noPlayersAround)
      end
    end
    Citizen.Wait(1)
  end
end

AddEventHandler("onKeyDown", function(key)
    if key == "f" then
        Citizen.Wait(5000)
        if IsPedInAnyVehicle(PlayerPedId()) then
            if GetEntityModel(GetVehiclePedIsIn(PlayerPedId())) == GetHashKey("rcbandito") then
                TaskLeaveVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId()), 64)
            end
        end
    end
end)

