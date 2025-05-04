---@diagnostic disable: lowercase-global
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local Blacklisted = {
    [GetHashKey("mp_m_freemode_01")] = {
        torso_1  = {535, 558, 645},
        tshirt_1 = {292, 242},
        pants_1  = {},
        helmet_1 = {},
        bags_1   = {119, 120 },
        bproof_1 = {79, 105, },
        chain_1  = {178, 206, 211, 221},
        decals_1 = {},
        mask_1   = {261}
    },
    [GetHashKey("mp_f_freemode_01")] = {
        torso_1  = {680, 688},
        tshirt_1 = {321, 344, 311},
        pants_1  = {291},
        helmet_1 = {},
        bags_1   = {148, },
        bproof_1 = {94, 69, 129,},
        chain_1  = {208, 205},
        mask_1   = {246, 208, 192}
    },
}

function isBlackListed(componenet, code)
    print(componenet, code)
    local is = false
    if Blacklisted[GetEntityModel(PlayerPedId())] and Blacklisted[GetEntityModel(PlayerPedId())][componenet] then
        for k, v in pairs(Blacklisted[GetEntityModel(PlayerPedId())][componenet]) do
            if v == code then
                is = true
                break
            end
        end
    end
    return is
end

RegisterNetEvent("stg_gamepad:use")
AddEventHandler("stg_gamepad:use", function()
    TriggerEvent("esx_inventoryhud:closeInventory")
end)

exports("getSharedObject", function()
    while not ESX do
        Citizen.Wait(2000)
    end
    return ESX
end)

local FirstSpawn     = true
local LastSkin       = nil
local cam            = nil
local isCameraActive = false
local zoomOffset     = 0.0
local camOffset      = 0.0
local heading        = 90.0

function OpenMenu(submitCb, cancelCb, restrict, changeCb)

  local playerPed = PlayerPedId()

  TriggerEvent('skinchanger:getSkin', function(skin)
    LastSkin = skin
  end)

  TriggerEvent('skinchanger:getData', function(components, maxVals)
    print(json.encode(components))
    local elements    = {}
    local _components = {}

    -- Restrict menu
    if not restrict then
      for i=1, #components, 1 do
        _components[i] = components[i]
      end
    else
      for i=1, #components, 1 do

        local found = false

        for j=1, #restrict, 1 do
          if components[i].name == restrict[j] then
            found = true
          end
        end

        if found then
          table.insert(_components, components[i])
        end

      end
    end

    -- Insert elements
    for i=1, #_components, 1 do

      local value       = _components[i].value
      local componentId = _components[i].componentId

      if componentId == 0 then
        value = GetPedPropIndex(playerPed,  _components[i].componentId)
      end

      local data = {
        label     = _components[i].name,
        name      = _components[i].name,
        value     = value,
        min       = _components[i].min,
        textureof = _components[i].textureof,
        zoomOffset= _components[i].zoomOffset,
        camOffset = _components[i].camOffset,
        type      = 'slider'
      }

      for k,v in pairs(maxVals) do
        if k == _components[i].name then
          data.max = v
        end
      end

      table.insert(elements, data)

    end

    CreateSkinCam()
    zoomOffset = _components[1].zoomOffset
    camOffset = _components[1].camOffset

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'skin',
      {
        title = _U('skin_menu'),
        align = 'top-left',
        elements = elements
      },
      function(data, menu)

        TriggerEvent('skinchanger:getSkin', function(skin)
          LastSkin = skin
        end)

        submitCb(data, menu)
        DeleteSkinCam()
      end,
      function(data, menu)

        menu.close()

        DeleteSkinCam()

        TriggerEvent('skinchanger:loadSkin', LastSkin)

        if cancelCb ~= nil then
          cancelCb(data, menu)
        end

      end,
      function(data, menu)

        TriggerEvent('skinchanger:getSkin', function(skin)

          zoomOffset = data.current.zoomOffset
          camOffset = data.current.camOffset

          if skin[data.current.name] ~= data.current.value and not isBlackListed(data.current.name, data.current.value) then

            if changeCb then
              changeCb(data.current.name, data.current.value)
            end
            -- Change skin element
            TriggerEvent('skinchanger:change', data.current.name, data.current.value)

            -- Update max values
            TriggerEvent('skinchanger:getData', function(components, maxVals)

              for i=1, #elements, 1 do

                local newData = {}

                newData.max = maxVals[elements[i].name]

                if elements[i].textureof ~= nil and data.current.name == elements[i].textureof then
                  newData.value = 0
                end

                menu.update({name = elements[i].name}, newData)

              end

              menu.refresh()

            end)

          end

        end)

      end,
      function()
        DeleteSkinCam()
      end
    )

  end)

end

function CreateSkinCam()
  if not DoesCamExist(cam) then
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
  end
  SetCamActive(cam, true)
  RenderScriptCams(true, true, 500, true, true)
  isCameraActive = true
  SetCamRot(cam, 0.0, 0.0, 270.0, true)
  SetEntityHeading(playerPed, 90.0)
end

function DeleteSkinCam()
  isCameraActive = false
  SetCamActive(cam, false)
  RenderScriptCams(false, true, 500, true, true)
  cam = nil
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    if isCameraActive then
      DisableControlAction(2, 30, true)
      DisableControlAction(2, 31, true)
      DisableControlAction(2, 32, true)
      DisableControlAction(2, 33, true)
      DisableControlAction(2, 34, true)
      DisableControlAction(2, 35, true)

      DisableControlAction(0, 25,   true) -- Input Aim
        DisableControlAction(0, 24,   true) -- Input Attack

      local playerPed = PlayerPedId()
      local coords    = GetEntityCoords(playerPed)

      local angle = heading * math.pi / 180.0
      local theta = {
        x = math.cos(angle),
        y = math.sin(angle)
      }
      local pos = {
        x = coords.x + (zoomOffset * theta.x),
        y = coords.y + (zoomOffset * theta.y),
      }

      local angleToLook = heading - 140.0
      if angleToLook > 360 then
        angleToLook = angleToLook - 360
      elseif angleToLook < 0 then
        angleToLook = angleToLook + 360
      end
      angleToLook = angleToLook * math.pi / 180.0
      local thetaToLook = {
        x = math.cos(angleToLook),
        y = math.sin(angleToLook)
      }
      local posToLook = {
        x = coords.x + (zoomOffset * thetaToLook.x),
        y = coords.y + (zoomOffset * thetaToLook.y),
      }

      SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
      PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)

    else
      Citizen.Wait(500)
    end
  end
end)

Citizen.CreateThread(function()
  local angle = 90
  while true do
    Citizen.Wait(5)
    if isCameraActive then
      if IsControlPressed(0, 108) then
        angle = angle - 1
      elseif IsControlPressed(0, 109) then
        angle = angle + 1
      end
      if angle > 360 then
        angle = angle - 360
      elseif angle < 0 then
        angle = angle + 360
      end
      heading = angle + 0.0
    else
      Citizen.Wait(500)
    end
  end
end)

function OpenSaveableMenu(submitCb, cancelCb, restrict)

  TriggerEvent('skinchanger:getSkin', function(skin)
    LastSkin = skin
  end)

  OpenMenu(function(data, menu)

    menu.close()

    DeleteSkinCam()

    TriggerEvent('skinchanger:getSkin', function(skin)

      TriggerServerEvent('esx_skin:save', skin)

      if submitCb ~= nil then
        submitCb(data, menu)
      end

    end)

  end, cancelCb, restrict)

end

RegisterNetEvent('esx_skin:reloadMe')
AddEventHandler('esx_skin:reloadMe', function()
  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

    if skin == nil then
      TriggerEvent('skinchanger:loadSkin', {sex = 0})
    else
      TriggerEvent('skinchanger:loadSkin', skin)
    end

  end)
end)

AddEventHandler('esx_skin:getLastSkin', function(cb)
  cb(LastSkin)
end)

AddEventHandler('esx_skin:setLastSkin', function(skin)
  LastSkin = skin
end)

RegisterNetEvent('esx_skin:openMenu')
AddEventHandler('esx_skin:openMenu', function(submitCb, cancelCb)
  OpenMenu(submitCb, cancelCb, false)
end)

RegisterNetEvent('esx_skin:openRestrictedMenu')
AddEventHandler('esx_skin:openRestrictedMenu', function(submitCb, cancelCb, restrict, changeCb)
  OpenMenu(submitCb, cancelCb, restrict, changeCb)
end)

RegisterNetEvent('esx_skin:openSaveableRestrictedMenu')
AddEventHandler('esx_skin:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict)
  OpenSaveableMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:requestSaveSkin')
AddEventHandler('esx_skin:requestSaveSkin', function()
  TriggerEvent('skinchanger:getSkin', function(skin)
    TriggerServerEvent('esx_skin:responseSaveSkin', skin)
  end)
end)