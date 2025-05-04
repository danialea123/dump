local abcd = {
    ["notw:rec"] = true,
    ["notw:stop"] = true,
    ["notw:delete"] = true,
    ["notw:rock"] = true,
}

local open = false

---@diagnostic disable: missing-parameter
RegisterNUICallback("dataPost", function(data, cb)
    SetNuiFocus(false)
    if not abcd[data.event] then return end
    if not open then return end
    TriggerEvent(data.event, data.args, data.arg2, data.arg3)
    open = false
    cb('ok')
end)

RegisterNUICallback("cancel", function()
    SetNuiFocus(false)
end)

RegisterNetEvent('nh-context:sendMenu', function(data)
    if not data then return end
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "OPEN_MENU",
        data = data
    })
    open = true
end)
