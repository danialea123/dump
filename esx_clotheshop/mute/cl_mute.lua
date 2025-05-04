RegisterNetEvent("esx_muteBan:setBan")
AddEventHandler("esx_muteBan:setBan", function(time)
    TalkThread(time)
    TriggerEvent("pma-voice:setVoiceBan")
    TriggerEvent("pma-voice:drawThread")
end)

function TalkThread(time)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            if NetworkIsPlayerTalking(PlayerId()) then 
                ESX.Alert("Shoma Be Moddat "..math.floor((time/86400)).." Rooz Nemitavanid Dar Server Sohbat Konid!", "info")
                TriggerEvent("pma-voice:setVoiceBan")
                Citizen.Wait(8000)
            end
        end
    end)
end