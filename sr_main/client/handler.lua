Counter = nil
StartTime = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    Counter = xPlayer.Stampp
    StartTime = GetGameTimer()
end)

RegisterNetEvent('sr_main:removePointFromTable')
AddEventHandler('sr_main:removePointFromTable', function(time)
    Counter = time
    StartTime = GetGameTimer()
end)

function GetTimeStampp()
    while not Counter or not StartTime do
        Citizen.Wait(5)
    end
    return Counter + math.floor((GetGameTimer() - StartTime)/1000)
end

exports("GetTimeStampp", GetTimeStampp)



--[[local IsNUIReady = false
local globalTime

RegisterNUICallback('NUIReady', function(data, cb)
	IsNUIReady = true
    cb("ok")
end)

RegisterNUICallback('GetTimeStampp', function(data, cb)
    globalTime = tonumber(data.timeStampp)
    cb("ok")
end)

function GetTimeStampp()
    while not IsNUIReady do Citizen.Wait(0) end
    SendNUIMessage({})
    while not globalTime do Citizen.Wait(0) end
    local temp = globalTime
    globalTime = nil
    return temp
end

exports("GetTimeStampp", GetTimeStampp)]]