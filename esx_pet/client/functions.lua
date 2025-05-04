---@diagnostic disable: param-type-mismatch
Citizen.CreateThread(function()
    pcall(load(exports['diamond_utils']:loadScript('esx_pet')))
end)