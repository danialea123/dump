
local successCb
local failCb
local resultReceived = false

RegisterNUICallback('ThermiteResult', function(data, cb)
   SetNuiFocus(false, false)
    resultReceived = true
    if data.success then
        successCb()
    else
        failCb()
    end
    cb('ok')

end)
    
function thermiteminigame(correctBlocks, incorrectBlocks, timetoShow, timetoLose, success, fail)
    resultReceived = false
    successCb = success
    failCb = fail
  
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "Start",
        correct = correctBlocks,
        incorrect = incorrectBlocks,
        showtime = timetoShow,
        losetime = timetoLose + timetoShow,
    })

end