local Framework = {}

local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

---Checks if the user has the adequate group
---@param restrictions table
---@return boolean HasGroup
function Framework:HasGroup(restrictions)
    local PlayerData = ESX.GetPlayerData()
    local playerJob, playerRank = PlayerData.job.name, PlayerData.job.grade

    for key, value in pairs(restrictions) do
        if type(key) == "string" and key == playerJob and value <= playerRank then
            return true
        elseif type(key) == "number" and value == playerJob then

            return true
        end
    end
    return false
end

return Framework