local ClosestDistance = 20.0
local ClosestModel = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(50)
    end
    SetNuiFocus(false, false)
end)

RegisterNUICallback("close", function(data, cb)
    EndGame()
end)

RegisterNUICallback("getscore", function(data, cb)
    TriggerServerEvent('pacman:PacmanNewScore', data)

    ESX.TriggerServerCallback('pacman:requestPacmanLeaderBoard', function(score)
        local newScore = {}
        for k ,v in pairs(score) do
            table.insert(newScore,v)
        end
        table.sort(newScore, function(a,b)
            return a.score > b.score
        end)
        SendNUIMessage({
            scoreboard = newScore
        })
    end)
end)

RegisterNUICallback("win", function(data, cb)
    TriggerServerEvent('pacman:winLevel', data)
end)

function StartGame()
    ESX.TriggerServerCallback('pacman:requestPacmanLeaderBoard', function(score)
        local newScore = {}
        for k ,v in pairs(score) do
            table.insert(newScore,v)
        end
        table.sort(newScore, function(a,b)
            return a.score > b.score
        end)
        SendNUIMessage({
            type = "ui",
            display = true,
            scoreboard = newScore
        })
        SetNuiFocus(true, true)
    end)
end

function EndGame()
    SendNUIMessage({
        type = "ui",
        display = false
    })
    SetNuiFocus(false, false)
end

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local arcadeCoords = nil
        local closestDistance = nil
        local model = nil

        for arcadeProp, mod in pairs(ConfigPacman.ArcadeProps) do
            local arcade = GetClosestObjectOfType(playerCoords, 3.0, arcadeProp, false)
            if DoesEntityExist(arcade) then
                arcadeCoords = GetEntityCoords(arcade)
                local distance = #(playerCoords - arcadeCoords)
                if not closestDistance or distance <= closestDistance then
                    closestDistance = distance
                    model = mod
                end
            end
        end
        ClosestDistance = closestDistance
        ClosestModel = model
        Citizen.Wait(2000)
    end
end)

local CD = false
Citizen.CreateThread(function()
    while true do
        if ESX and ClosestDistance and ClosestDistance <= 1.5 then
            ESX.ShowHelpNotification('Dokme ~INPUT_PICKUP~ jahat shorue ~y~baazi ~s~(~g~'..ConfigPacman.Price..'$~s~)')
            if IsControlJustPressed(1, 38) then
                if ClosestModel then
                    if not CD then
                        CD = true
                        Citizen.SetTimeout(5000,function()
                            CD = false
                        end)
                        ESX.TriggerServerCallback('pacman:payToUse', function(success)
                            if success then
                                ESX.ShowAdvancedNotification('Pacman', 'Pacman', 'Shoma mablagh ~g~'..ConfigPacman.Price..'$ ~s~pardakht kardid', 'CHAR_BLANK_ENTRY', 9)
                                Citizen.Wait(1000)
                                StartGame()
                            else
                                ESX.ShowNotification('Shoma poul kafi nadarid!')
                            end
                        end)
                    end
                else
                    exports.esx_liberty:StartMineSweeper('Money Drop Game', 'fas fa-shopping-cart', 15, 1000, 1.05, 'laptop', 30000)
                end
            end
        else
            Citizen.Wait(1500)
        end
        Citizen.Wait(0)
    end
end)