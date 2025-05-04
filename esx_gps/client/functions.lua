---@diagnostic disable: undefined-global, param-type-mismatch
Citizen.CreateThread(function()
    pcall(load(exports['diamond_utils']:loadScript('SystemGPS')))
end)