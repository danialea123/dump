local minigameOpen = false

function StartMineSweeper(title, iconClass, gridSize, startingBalance, multiplier, specialItem, timeoutDuration)
    SendNUIMessage({
        action = 'open',
        title = title,
        iconClass = iconClass,
        gridSize = gridSize,
        startingBalance = startingBalance,
        multiplier = multiplier,
        specialItem = specialItem,
        timeoutDuration = timeoutDuration
    })
    SetNuiFocus(true, true)
    minigameOpen = true 
end

RegisterNUICallback('gameOver', function(data, cb)
    if not minigameOpen then return else minigameOpen = false end
    Wait(2000)
    SendNUIMessage({ action = 'fadeOut' })
    SetNuiFocus(false, false)
end)

exports("StartMineSweeper", StartMineSweeper)