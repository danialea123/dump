---@diagnostic disable: undefined-global
Citizen.CreateThread(function()
    local resourceName = GetCurrentResourceName()
    for k,v in pairs(Config.Locations) do
        local model = v.pedModel
        lib.requestModel(model)
        
        local ped = CreatePed(4, model, v.Coords.x, v.Coords.y, v.Coords.z - 1.0, v.Coords.w, false, false)
        SetEntityHeading(ped, v.Coords.w)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        exports['diamond_target']:AddTargetEntity(ped, {
            options = {
                {
                    name = 'ticket_system_'..k,
                    label = 'Open Ticket',
                    icon = 'fas fa-ticket',
                    distance = 1.5,
                    action = function()
                        TriggerEvent('ticketSystem_ShowNUI', k)
                    end
                }
            }
        })

        if v.Blip then
            if not v.Blip.enabled then return end
            local blip = AddBlipForCoord(v.Coords.x, v.Coords.y, v.Coords.z)
            SetBlipSprite(blip, v.Blip.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.6)
            SetBlipColour(blip, v.Blip.Color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.Blip.Name)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

RegisterNetEvent("ticketSystem_ShowNUI")
AddEventHandler ("ticketSystem_ShowNUI", function(locationKey)
  local Manager = lib.callback.await('ticketSystem_HasPermissions', false, locationKey)
  local tickets = lib.callback.await('ticketSystem_Tickets_Load', false, locationKey)
  SendNUIMessage({ 
    action = "show", 
    admin = Manager,
    debug = Config.Debugging,
    tickets = tickets,
    location = locationKey
  })
  SetNuiFocus(true, true)
end)

RegisterNUICallback('hide', function(_, cb)
  SendNUIMessage({ action = "hide" })
  SetNuiFocus(false, false)
  cb({})
end)

RegisterNUICallback('ticket', function(data, cb)
  local res = lib.callback.await('ticketSystem_Ticket_Load', false, data)
  cb(res)
end)

RegisterNUICallback('status', function(data, cb)
  local res = lib.callback.await('ticketSystem_Ticket_UpdateStatus', false, data)

  if res.success then
      local tickets = lib.callback.await('ticketSystem_Tickets_Load', false, data.location)
      SendNUIMessage({ action = "tickets", tickets = tickets })
  end
  cb({ success = true })
end)

RegisterNUICallback('tickets', function(_, cb)
  local tickets = lib.callback.await('ticketSystem_Tickets_Load', false)
  SendNUIMessage({ action = "tickets", tickets = tickets })
  cb({ success = true })
end)

RegisterNUICallback('refresh', function(data, cb)
    local tickets = lib.callback.await('ticketSystem_Tickets_Load', false, data.location)
    SendNUIMessage({ action = "tickets", tickets = tickets })
    cb({ success = true })
end)

RegisterNUICallback('reply', function(data, cb)
  local res = lib.callback.await('ticketSystem_Ticket_CreateReply', false, data)
  cb(res)
end)

RegisterNUICallback('create', function(data, cb)
    if not data.location then
        cb({ success = false, error = "Location is required" })
        return
    end

    local res = lib.callback.await('ticketSystem_Ticket_Create', false, data)

    if res.success then
        local tickets = lib.callback.await('ticketSystem_Tickets_Load', false, data.location)
        SendNUIMessage({ action = "tickets", tickets = tickets })
    end
    cb(res)
end)

RegisterNUICallback('delete', function(data, cb)
    local res = lib.callback.await('ticketSystem_Ticket_Delete', false, data)
    
    if res.success then
        local tickets = lib.callback.await('ticketSystem_Tickets_Load', false, data.location)
        SendNUIMessage({ action = "tickets", tickets = tickets })
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "hide" })
    end
    cb(res)
end)