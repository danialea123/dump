---@diagnostic disable: param-type-mismatch, undefined-field, missing-parameter, undefined-global
local InMenu = false
local CanPressKey = false

local AllBotPos = {
    vector4(-186.29,-1701.82,31.82,318.0),
    vector4(1403.87,-1496.31,58.96,291.79),
    vector4(-385.11,270.44,85.37,310.86),
    vector4(379.72,2629.5,43.67,44.1),
}

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(100)
	end
    while ESX.GetPlayerData().job == nil do 
        Citizen.Wait(100)
    end
    PlayerData = ESX.GetPlayerData()
    if PlayerData.gang.name ~= "nogang" then
        for k,v in pairs(AllBotPos) do 
            local Shopper = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(Shopper, 679)
            SetBlipColour(Shopper,  68)
            SetBlipAlpha(Shopper, 250)
            SetBlipScale(Shopper, 0.6)
            SetBlipAsShortRange(Shopper, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Drug Task')
            EndTextCommandSetBlipName(Shopper)
            local ped_hash = GetHashKey("s_m_y_dealer_01")
            RequestModel(ped_hash)
            while not HasModelLoaded(ped_hash) do
                Citizen.Wait(1)
            end
            local BossNPC = CreatePed(1, ped_hash,v.x, v.y, v.z,v.w, false, true)
            SetBlockingOfNonTemporaryEvents(BossNPC, true)
            SetPedDiesWhenInjured(BossNPC, false)
            SetPedCanPlayAmbientAnims(BossNPC, true)
            SetPedCanRagdollFromPlayerImpact(BossNPC, false)
            SetEntityInvincible(BossNPC, true)
            FreezeEntityPosition(BossNPC, true)
            SetEntityLodDist(BossNPC, 50)
        end
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(3)
                local Sleep = true
                for k, v in pairs(AllBotPos) do
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(v.x, v.y, v.z), true) <= 10.0 then
                        Sleep = false
                        --DrawMarker(21, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.4,0.4,0.3, 255, 255, 255, 500, true, true, 2, false, false, false, false)
                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(v.x, v.y, v.z), true) <= 2.5 then
                            if not InMenu then 
                                ESX.ShowHelpNotification('~INPUT_CONTEXT~ Baz Kardan Menu Gang Task')
                                CanPressKey = true
                            else
                                CanPressKey = false
                            end
                        else
                            if InMenu then
                                ESX.UI.Menu.CloseAll()
                            end
                            InMenu = false
                        end
                    end
                end
                if Sleep then CanPressKey = false Citizen.Wait(710) end
            end
        end)
    end
end)

AddEventHandler("onKeyUP", function(key)
    if key == "e" then
        if CanPressKey then
            QuestMenu()
        end
    end
end)

function QuestMenu()
    local elements = {}
    table.insert(elements, {label = ("Drug Task [✔️]"), value = 'dontoch'})
    InMenu = true
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'weaponcraft_menu',
    {
        title    = "🔴 𝘘𝘶𝘦𝘴𝘵 🔴",
        align    = 'center',
        elements = elements
    }, function(data, menu)
        local action = data.current.value
        PlayerQuest()
    end, function(data, menu)
        InMenu = false
        menu.close()
    end)
end

function PlayerQuest()
    ESX.TriggerServerCallback("esx_DrugTask:GetQuestStatus", function(Info, OnWork)
        local elements = {}

        table.insert(elements, {label = Info.marijuana.."/12 Marijuana", value = "marijuana"})

        table.insert(elements, {label = Info.mushroom.."/10 Mushroom", value = "mushroom"})

        table.insert(elements, {label = Info.meth.."/14 Shishe", value = "meth"})

        table.insert(elements, {label = Info.cocaine.."/12 Cocaine", value = "cocaine"})

        table.insert(elements, {label = Info.crack.."/6 Crack", value = "crack"})

        table.insert(elements, {label = "----------------------------------", value = nil})

        table.insert(elements, {label = "Reward = 70 Gang XP", value = nil})

        table.insert(elements, {label = "[✔️] Confirm [✔️]", value = "getReward"})

        InMenu = true
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'quest_ask_which',
        {
            title    = "🔴 Available 𝘘𝘶𝘦𝘴𝘵s 🔴",
            align    = 'center',
            elements = elements
        }, function(data, menu)
            local action = data.current.value
            if action and action ~= "getReward" then
                InMenu = false
                menu.close()
                ESX.TriggerServerCallback("esx_DrugTask:AddItem", function() 
                    PlayerQuest()
                end, action)
            elseif action then
                --if ESX.GetPlayerData().gang.grade == 12 or ESX.GetPlayerData().gang.grade == 13 then
                    if Info.marijuana >= 12 and Info.mushroom >= 10 and Info.meth >= 14 and Info.cocaine >= 12 and Info.crack >= 6 then
                        menu.close()
                        Citizen.Wait(math.random(100,1500))
                        ESX.TriggerServerCallback("esx_DrugTask:CheckQuest", function(pedaret) 
                            if pedaret then
                                InMenu = false
                                menu.close()
                                QuestMenu()
                                ESX.Alert("Quest Shoma Takmil Shod Va 70 XP Gereftid", "check")
                            else
                                InMenu = false
                                menu.close()
                                QuestMenu()
                                ESX.Alert("Quest Shoma Hanooz Takmil Nashode Ast", "error")
                            end
                        end)
                    else   
                        ESX.Alert("Quest Shoma Hanooz Takmil Nashode Ast", "error")
                    end
                --[[else
                    ESX.Alert("Shoma Kingpin Gang Nistid", "error")
                end]]
            end
        end, function(data, menu)
            InMenu = false
            menu.close()
            QuestMenu()
        end)
    end)
end