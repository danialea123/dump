---@diagnostic disable: undefined-field, undefined-global, lowercase-global
--[[Citizen.CreateThread(function()
    pcall(load(exports['diamond_utils']:loadScript('coins')))
end)]]

ESX = nil
PlayerData = {}
BuyCoolDown = 0
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('HR_Coin:UpdateThatFuckinShit')
AddEventHandler('HR_Coin:UpdateThatFuckinShit', function(dCoin)
    ESX.SetPlayerData("Coin", dCoin)
    ESX.PlayerData.Coin = dCoin
    PlayerData.Coin = dCoin
    updateCoin(dCoin)
end)

function openCoins()
    if ESX.isDead() then return end
	if ESX.GetPlayerData().isSentenced then return end
    if not IsPauseMenuActive() then
        if uiStatus then return false end 
        uiStatus = true 
        SetTimecycleModifier("hud_def_blur")
        SetNuiFocus(true,true)
        SetTimecycleModifierStrength(1.0)
        DisplayRadar(false)
        SendNUIMessage({
            event = 'open',
            coins = PlayerData.Coin
        })
    end
end

exports("openCoins", openCoins)

RegisterNUICallback("loadConfig", function(data,cb) 
  local info = cfg
    for k,v in pairs(info.roulette.items) do 
        info.roulette.items[k].position = k
        for i,u in pairs(v) do 
            if i == 'temporary' or type(u) == 'function' then   
                info.roulette.items[k][i] = nil 
            end
        end
    end
    for k,v in pairs(info.products) do 
        for i = 1,#info.products[k]  do 
            info.products[k][i].position = i
            for j,u in pairs(info.products[k][i]) do 
                if type(u) == "function" or j == 'temporary' then 
                    info.products[k][i][j] = nil
                end
            end
        end
    end
    SendNUIMessage({
        event   = 'setup',
        config  =  json.encode(info)
    })
end)

RegisterNUICallback("close", function(data,cb) 
    ClearPedTasks(PlayerPedId())
    ClearTimecycleModifier()
    uiStatus = false 
    SetNuiFocus(false, false)
    DisplayRadar(true)
    cb('ok')
end)

RegisterNUICallback("playSound", function(data,cb) 
    if data.action == "buy" then 
      PlaySound(-1, "Event_Message_Purple","GTAO_FM_Events_Soundset", 0, 0, 1)
    elseif data.action == "error" then 
      if data.error then 
        TriggerEvent("Notify","negado",data.error)
      end
      PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    elseif data.action == "click" then 
      PlaySoundFrontend(-1, "TENNIS_POINT_WON", "HUD_AWARDS",true)      
      PlaySound(-1, "Event_Message_Purple","GTAO_FM_Events_Soundset", 0, 0, 1)
    elseif data.action == "select" then 
      PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    end
end)

RegisterNUICallback("rewardReedem", function(data,cb)
    ESX.TriggerServerCallback('esx_coin:redeemGift', function(k)
        if k then
            cb(true)
        end
    end, data)
end)

RegisterNUICallback("buyProduct", function(data,cb) 
    local data = data
    local category      = data.category
    local productTable  = cfg.products[category][data.index]
    if PlayerData.Coin >= productTable.price and GetGameTimer() - BuyCoolDown > 3000 then
        BuyCoolDown = GetGameTimer()
        ESX.TriggerServerCallback('esx_coin:BuyProduct', function(k)
            if k then
                ESX.Alert("Kharid Shoma Movafaghiat Amiz Bood", "check")
                cb({success = true})
            else
                cb({success = false})
            end
        end, data)
    else
        cb({success = false})
    end
end)

RegisterNUICallback("tryOpenBox", function(data,cb)
    if(data.multiplier) then
        if PlayerData.Coin >= (cfg.roulette.price * data.multiplier) then
            ESX.TriggerServerCallback("esx_coin:checkCoin", function(k)
                if k then
                    cb({success = true})
                else
                    cb({success = false})
                end
            end, (cfg.roulette.price * data.multiplier))
        else
            cb({success = false})
        end
    end
end)

function updateCoin(coins)
    SendNUIMessage({event = 'updateCoin', coins = coins})
end
