---@diagnostic disable: param-type-mismatch, undefined-field, missing-parameter, undefined-global
local Thread = false
local InMenu = false
local CanPressKey = false

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)
	end
    while ESX.GetPlayerData().job == nil do 
        Citizen.Wait(100)
    end
    while not PlayerData do
        Citizen.Wait(2000)
    end
    if PlayerData.gang.name ~= "nogang" then
        local Shopper = AddBlipForCoord(905.74,3586.36,33.43-0.9)
        SetBlipSprite(Shopper, 480)
        SetBlipColour(Shopper,  66)
        SetBlipAlpha(Shopper, 250)
        SetBlipScale(Shopper, 0.6)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Gang Task')
        EndTextCommandSetBlipName(Shopper)
        ped_hash = GetHashKey("s_m_y_dealer_01")
        BossSpawn = vector3(905.74,3586.36,33.43-0.9)
        RequestModel(ped_hash)
        while not HasModelLoaded(ped_hash) do
            Citizen.Wait(1)
        end
        BossNPC = CreatePed(1, ped_hash,905.74,3586.36,33.43-0.9, 2.58, false, true)
        SetBlockingOfNonTemporaryEvents(BossNPC, true)
        SetPedDiesWhenInjured(BossNPC, false)
        SetPedCanPlayAmbientAnims(BossNPC, true)
        SetPedCanRagdollFromPlayerImpact(BossNPC, false)
        SetEntityInvincible(BossNPC, true)
        FreezeEntityPosition(BossNPC, true)
        --[[GiveWeaponToPed(BossNPC, GetHashKey("WEAPON_SMG"), 200, false, true)
        SetCurrentPedWeapon(BossNPC, GetHashKey("WEAPON_SMG"), true)]]
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(3)
                local Sleep = true
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(905.74,3586.36,33.43), true) <= 10.0 then
                    Sleep = false
                    DrawMarker(21, 905.74,3586.36,34.43, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.4,0.4,0.3, 255, 255, 255, 500, true, true, 2, false, false, false, false)
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(905.74,3586.36,33.43), true) <= 2.5 then
                        if not InMenu then 
                            ESX.ShowHelpNotification('~INPUT_CONTEXT~ Baz Kardan Menu Gang Task')
                            CanPressKey = true
                        else
                            CanPressKey = false
                        end
                    else
                        ESX.UI.Menu.CloseAll()
                        InMenu = false
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
    --table.insert(elements, {label = "𝘗𝘭𝘢𝘺𝘦𝘳 𝘘𝘶𝘦𝘴𝘵 [✔️]", value = 'qplayer'})
    table.insert(elements, {label = ("𝘎𝘢𝘯𝘨's Weekly 𝘘𝘶𝘦𝘴𝘵 [✔️]"), value = 'dontoch'})
    --table.insert(elements, {label = ("𝘑𝘰𝘣 𝘘𝘶𝘦𝘴𝘵 [❌]"), value ='dontchme'})
    --[[if PlayerData.job.name == 'police' or PlayerData.job.name == 'fbi' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'taxi' or PlayerData.job.name == 'mechanic' then
        table.insert(elements, {label = ("𝘑𝘰𝘣 𝘘𝘶𝘦𝘴𝘵 [✔️]"), value = 'qj'})
    else 
        table.insert(elements, {label = ("𝘑𝘰𝘣 𝘘𝘶𝘦𝘴𝘵 [❌]"), value ='dontchme'})
    end]]

    --[[if PlayerData.gang.name ~= 'nogang' then
        table.insert(elements, {label = ('𝘎𝘢𝘯𝘨 𝘘𝘶𝘦𝘴𝘵 [✔️]'), value = 'qg'})
    else 
        table.insert(elements, {label = ('𝘎𝘢𝘯𝘨 𝘘𝘶𝘦𝘴𝘵 [❌]'), value = 'dontoch'})
    end]]

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
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(905.74,3586.36,33.43), true) >= 7.0 then menu.close() return end
        PlayerQuest()
    end, function(data, menu)
        InMenu = false
        menu.close()
    end)
end

function PlayerQuest()
    ESX.TriggerServerCallback("esx_Quest:GetPlayerQuestStatus", function(Info, OnWork)
        local elements = {}

        table.insert(elements, {label = Info.essence.."/15 Essence", value = "essence"})

        table.insert(elements, {label = Info.packaged_plank.."/75 Choob BasteBandi", value = "packaged_plank"})

        table.insert(elements, {label = Info.copper.."/65 Mes", value = "copper"})

        table.insert(elements, {label = Info.gold_piece.."/45 Khorde Tala", value = "gold_piece"})

        table.insert(elements, {label = Info.gold.."/55 Gold", value = "gold"})

        table.insert(elements, {label = Info.diamond.."/15 Diamond", value = "diamond"})

        table.insert(elements, {label = Info.iron.."/55 Ahan", value = "iron"})

        table.insert(elements, {label = Info.iron_piece.."/45 Khorde Ahan", value = "iron_piece"})

        table.insert(elements, {label = Info.petrol_raffin.."/30 Rafin", value = "petrol_raffin"})

        table.insert(elements, {label = "----------------------------------", value = nil})

        table.insert(elements, {label = "Reward = 500 Gang XP", value = nil})

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
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(905.74,3586.36,33.43), true) >= 7.0 then menu.close() InMenu = false return end
                InMenu = false
                menu.close()
                ESX.TriggerServerCallback("esx_Quest:AddItem", function() 
                    PlayerQuest()
                end, action)
            elseif action then
                --if ESX.GetPlayerData().gang.grade == 12 or ESX.GetPlayerData().gang.grade == 13 then
                    if Info.gold >= 55 and Info.diamond >= 15 and Info.iron >= 55 and Info.essence >= 15 and Info.iron_piece >= 45 and Info.gold_piece >= 45 and Info.copper >= 65 and Info.packaged_plank >= 75 and Info.petrol_raffin >= 30 then
                        menu.close()
                        Citizen.Wait(math.random(100,1500))
                        ESX.TriggerServerCallback("esx_Quest:CheckQuest", function(pedaret) 
                            if pedaret then
                                InMenu = false
                                menu.close()
                                QuestMenu()
                                ESX.Alert("Quest Shoma Takmil Shod Va 1000 XP Be Gang Shoma Dade Shod", "check")
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