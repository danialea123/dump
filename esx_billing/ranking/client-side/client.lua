local NUI = false

local function openUi(getRanking, getRankingPly)
    SetNuiFocus(true, true)
	TriggerScreenblurFadeIn(500)
    SendNUIMessage({ show = true, ranking = getRanking, plyRanking = getRankingPly })
    TriggerEvent("hudActived",false)
end

local function closeUi()
    NUI = false 
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(500)
    SendNUIMessage({ show = false })
    TriggerEvent("hudActived",true)
end

exports("OpenRankingMenu", function()
    if not ESX then return end
    if ESX.isDead() then return end
	if ESX.GetPlayerData().isSentenced then return end
    if not NUI then
        NUI = true
        ESX.TriggerServerCallback("capture:getActivity", function(getRanking, plyRanking)
            local getRanking, plyRanking = SetKillDeath(getRanking, plyRanking)
            openUi(getRanking, plyRanking)   
        end)     
    end
end)

function SetKillDeath(a, b)
    local a, b = a, b
    for k, v in pairs(a) do
        v.kills_deaths = v.deaths == 0 and 0 or ESX.Math.Round(v.kills/v.deaths, 2)
    end
    b.kills_deaths = b.deaths == 0 and 0 or ESX.Math.Round(b.kills/b.deaths, 2)
    return a, b
end

RegisterNUICallback("closeUi", function(data,cb)
    closeUi()
end)
