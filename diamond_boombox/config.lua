Framework = nil

if GetResourceState('es_extended') == 'started' or GetResourceState('es_extended') == 'starting' then
    Framework = 'ESX'
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif GetResourceState('qb-core') == 'started' or GetResourceState('qb-core') == 'starting' then
    Framework = 'qb'
    QBCore = exports['qb-core']:GetCoreObject()
else
    print("^0[^1ERROR^0] The framework could not be initialised!^0")
end

Config = {}

Config.checkForUpdates = false -- Check for Updates?

Config.BoomboxItem = 'boombox'

Config.InstructionNotification = true -- If you want a notification explaining to press E to drop boombox