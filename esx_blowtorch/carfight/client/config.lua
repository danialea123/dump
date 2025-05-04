ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Cfg = {}

Cfg.KeyListToInteract = {38}

Cfg.MarkerList = {
    ["derby"] = {
        text = "🚙  CarFight %i/6",

        pos = vector3(1416.15,6610.81,22.44),
        style = 1, -- appearance of the marker

        size = vector3(10.0, 10.0, 1.5),
        color = { r = 0, g = 0, b = 0, a = 125 },

        rotate = true,
        faceCamera = false,

        blip = {
            name = "Car Fight",
            blipId = 611,
            scale = 1.0,
            color = 0,
            shortRange = true,
        },
    },

    ["derby2"] = {
        text = "🚙  CarFight %i/4",

        pos = vector3(-267.6791, -2032.404, 29.23916),
        style = 1, -- appearance of the marker

        size = vector3(6.0, 6.0, 0.5),
        color = { r = 0, g = 255, b = 0, a = 125 },

        rotate = true,
        faceCamera = false,

        blip = {
            name = "Car Fight",
            blipId = 611,
            scale = 1.0,
            color = 0,
            shortRange = true,
        },
    },
}