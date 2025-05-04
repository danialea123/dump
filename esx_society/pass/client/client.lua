PlayerData = {}

RegisterNetEvent("esx_battlePass:Info")
AddEventHandler("esx_battlePass:Info", function(info)
    PlayerData = ESX.GetPlayerData()
    for key, value in pairs(info) do
        PlayerData[key] = value
    end
end)

RegisterNetEvent("esx_battlePass:firstTime")
AddEventHandler("esx_battlePass:firstTime", function()
    PlayerData.lastGetReward = exports.sr_main:GetTimeStampp()
    TriggerEvent("fullycustom-bp:LevelIncreased", 2)
end)

local VIPRewards =
{
    gold = true,
    premium = true
}

AddEventHandler("openRewardMenu", function()
    if ESX.isDead() then return end
	if ESX.GetPlayerData().isSentenced then return end
    if not VIPRewards[string.lower(ESX.GetPlayerData().group)] then return ESX.Alert("Shoma Gold VIP ya Premium VIP Nistid", "info") end
    TriggerEvent("js:OpenMenu")
end)

AddEventHandler("PlayerLoadedToGround", function()
    if not VIPRewards[ESX.GetPlayerData().group] then return end
    Citizen.Wait(10000)
    while exports.sr_main:GetTimeStampp() - PlayerData.lastGetReward <= 86400 do
        Citizen.Wait(20000)
    end
    PlayerData.lastGetReward = exports.sr_main:GetTimeStampp()
    PlayerData.level = PlayerData.level + 1
    TriggerEvent("fullycustom-bp:LevelIncreased", PlayerData.level)
    TriggerServerEvent("esx_battlePass:GetReward")
end)

AddEventHandler("openBattlePass",function()
    SendNUIMessage({
        type ='SET_TIME',
        date =  math.floor((PlayerData.Days - exports.sr_main:GetTimeStampp())/86400)
    })
    SendNUIMessage({
        type = 'SET_CURRENT_LEVEL',
        level = PlayerData.level
    })
    SendNUIMessage({
        type = 'SET_TAKEN_REWARDS',
        amount = PlayerData.level - 1
    })
    SendNUIMessage({
        type = 'SET_CURRENT_XP',
        xp = exports.sr_main:GetTimeStampp(),
        last = ESX.Math.Round(((86400 - ((PlayerData.lastGetReward + 86400) - (exports.sr_main:GetTimeStampp()))) / 86400), 3)*100.00 --yani maghzam gayide shod ta fahmidam ino bayad intori mikardam :-|
    })
    print(ESX.Math.Round(((86400 - ((PlayerData.lastGetReward + 86400) - (exports.sr_main:GetTimeStampp()))) / 86400), 3)*100.00)
end)