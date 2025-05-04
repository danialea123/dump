---@diagnostic disable: undefined-global, trailing-space, undefined-field, missing-parameter, lowercase-global
local ESX = nil
local job = ""
local grade = 0
local lastjob = nil 
local lastgang = false
savedQuests = {}
onTheQuest = false
QuestNames = nil
dailyTaskIndex = {}
taxes = math.random(20000, 30000)
PlayerData = {}

local VIPRewards =
{
    bronze = 4,
    silver = 4,
    gold = 4,
    premium = 5
}

function GetPlayerMaxQuests(group)
    local xPlayer = ESX.GetPlayerData()
    local MaxQuests = 3
    if xPlayer.Level >= 11 then 
        MaxQuests = 5
    elseif VIPRewards[group] then
        MaxQuests = VIPRewards[group]
    elseif xPlayer.Level >= 7 then
        MaxQuests = 4
    end
    return MaxQuests
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil and ESX.GetPlayerData().gang == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

    job = ESX.GetPlayerData().job.name

    grade = ESX.GetPlayerData().job.grade

    ESX.TriggerServerCallback("checkQuests", function(pedaret) 
        savedQuests = pedaret
    end)
end)

RegisterNetEvent('esx_credits:checklimit')
AddEventHandler('esx_credits:checklimit', function(pedaret)
    savedQuests = pedaret
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(j)
    job = j.name
    grade = j.grade
    PlayerData.job = j
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('HR_Coin:UpdateThatFuckinShit')
AddEventHandler('HR_Coin:UpdateThatFuckinShit', function(dCoin)
    ESX.PlayerData.Coin = dCoin
    PlayerData.Coin = dCoin
end)

RegisterNUICallback("removeCredits", function(data)
    TriggerServerEvent("core_credits:removeCredits", data["credits"])
end)

RegisterNUICallback("buyItem", function(data)
    TriggerServerEvent("core_credits:buyItem", data["item"])
end)

RegisterNUICallback("sendMessage", function(data)
    SendTextMessage(Config.Text[data["message"]])
end)

RegisterNUICallback("close", function(data)
    TriggerScreenblurFadeOut(1000)
    SetNuiFocus(false, false)
end)

RegisterNUICallback("addWinning",function(data)
    TriggerServerEvent("core_credits:addWinning", data["item"])
end)

RegisterNetEvent("core_credits:updateCredits")
AddEventHandler("core_credits:updateCredits",function()
    ESX.TriggerServerCallback("core_credits:getInfo", function(info)
        SendNUIMessage({
            type = "credits",
            credits = info.credits,
            task_progress = info.tasks,
            winnings = info.winnings
        })
    end)
end)

RegisterNetEvent("core_credits:sendMessage")
AddEventHandler("core_credits:sendMessage",function(msg)
    SendTextMessage(msg)
end)

function openCredits()
    SendNUIMessage({
        type = "credits",
        credits = PlayerData.Coin,
        task_progress = {},
        winnings = {}
    })
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SendNUIMessage({
        type = "open",
        name = string.upper(GetPlayerName(PlayerId())),
        shop_categories = Config.ShopCategories,
        lowest_bet = Config.LowestBet,
        header = string.upper(Config.BuyCreditsLink),
        description = Config.BuyCreditsDescription,
        shop_items = Config.Shop,
        shop_def = Config.DefaultCategory,
        tasks = insetrQuestList(),
        caseopening_items = Config.CaseOpeningItems
    })
end

--[[RegisterKey("J", false, function()
    if not IsPauseMenuActive() then
        openCredits()
    end
end)]]

--[[RegisterNetEvent("esx_dCoin:InitiateCar")
AddEventHandler("esx_dCoin:InitiateCar", function(name)
    CarSpawnThread(name)
end)

function CarSpawnThread(name)
    ESX.Game.SpawnVehicle(name, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), function(Veh)
        TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
        SetEntityAsMissionEntity(Veh, true, true)
        local newPlate
        newPlate = exports.esx_vehicleshop:GeneratePlate()
        local vehicleProps = ESX.Game.GetVehicleProperties(Veh)
        vehicleProps.plate = newPlate
        SetVehicleNumberPlateText(Veh, newPlate)
        ESX.TriggerServerCallback('esx_dCoin:InitiateCarOwners', function(cb)
            if cb then
                SetVehicleNumberPlateText(Veh, newPlate)
                ESX.CreateVehicleKey(Veh)
            end
        end, vehicleProps)
    end)
end]]

function StartYourQuest(Quest)
    ESX.TriggerServerCallback("esx_QuestSystem:HandleTasks", function(Exist, OnWork , Max)
        local Max = Max
        if OnWork then exports['esx_dNotify']:Alert("Warning", "<span style='color:#c7c7c7'> Shoma Dar Hale Hazer Yek Task Ra Accept Kardid <span style='color:#ff0000'></span>", 5000, 'error') return end
        if Max > GetPlayerMaxQuests(PlayerData.group) then exports['esx_dNotify']:Alert("Warning", "<span style='color:#c7c7c7'> Shoma Task Haye Rozane Khod Ra Anjam Dadeid <span style='color:#ff0000'></span>", 5000, 'error') return end
        if Exist then
            StartQuest(Quest)
            ESX.UI.Menu.CloseAll()
            for k, v in pairs(Config) do
                if type(v) == "table" then
                    for _, i in pairs(v) do 
                        if string.find(string.lower(k), "task") then
                            if i.type == Quest then
                                QuestNames = i.description
                                onTheQuest = true
                                break
                            end
                        end
                    end
                end
            end
        else
            ESX.Alert("In Task Hanooz Takmil Nashode Ya Dar Dastres Nist Ya An Ra Ghablan Anjam Dade id", "info")
        end
    end, Quest)
end

RegisterNetEvent("esx_QuestSystem:ReprogressQuest")
AddEventHandler("esx_QuestSystem:ReprogressQuest", function(data)
    CreateThread(function()
        Wait(30000)
        StartQuest(data)
        for k, v in pairs(Config) do
            if type(v) == "table" then
                for _, i in pairs(v) do 
                    if string.find(string.lower(k), "task") then
                        if i.type == data then
                            QuestNames = i.description
                            onTheQuest = true
                            break
                        end
                    end
                end
            end
        end
        ESX.Alert("zamani ke az server dc dadid va Task khod ra takmil nakarde boodid, be hamin dalil Task ghabli baraye shoma faal khahad shod", "check")
    end)
end)

RegisterNetEvent("esx_credits:setupGeneralList")
AddEventHandler("esx_credits:setupGeneralList", function(data)
    dailyTaskIndex = data
end)

function insetrQuestList(action)
    local qub = {}
    if action == 'Job' then 
        if job == 'police' or job == 'sheriff' or job == 'fbi' or job == "forces" or job == "justice" then 
            for k,v in pairs(Config[job.."Tasks"]) do 
                table.insert(qub, v)
            end 
        elseif job == 'ambulance' or job == 'medic' then 
            for k,v in pairs(Config.medictasks) do 
                table.insert(qub, v)
            end  
        elseif job == 'taxi' then 
            for k,v in pairs(Config.taxitasks) do 
                table.insert(qub, v)
            end  
        elseif job == 'mechanic' or job == 'benny' then
            for k,v in pairs(Config.mechanotasks) do 
                table.insert(qub, v)
            end
        elseif job == 'weazel' then
            for k,v in pairs(Config.weazelTask) do 
                table.insert(qub, v)
            end
        end
    elseif action == 'General' then
        for k, v in pairs(Config.Tasks) do
            for a, b in pairs(dailyTaskIndex) do
                if k == a then 
                    table.insert(qub, v)
                end
            end
        end
    elseif action == 'NewPlayers' then
        for k,v in pairs(Config.NewTasks) do 
            table.insert(qub, v)
        end  
    elseif action == 'Admin' then  
        if ESX.GetPlayerData().aduty then 
            for k,v in pairs(Config.adminTask) do 
                table.insert(qub, v)
            end  
        end 
    elseif action =='Gang' then 
        if PlayerData.gang.name ~= 'nogang' and PlayerData.gang.name ~= 'Military' then
            for k,v in pairs(Config.GangTasks) do 
                table.insert(qub, v)
            end  
        end 
    end  
    for k, v in pairs(qub) do
        if savedQuests[v.type] then
            table.remove(qub, k)
        end
    end
    return qub
end

AddEventHandler("taskOpen", function()
    QuestMenu()
end)

-----Quest Menu  
function QuestMenu(bool)
    local elements = {}
    koonimooni = false
    if ESX.GetPlayerData().Level >= 1 then
        table.insert(elements, {label = ("DailyTasks [✔️]"), value = "General"})
    else
        table.insert(elements, {label = ("NewPlayer Tasks[✔️]"), value = 'NewPlayers'})
        table.insert(elements, {label = ("DailyTasks [❌]"), value = nil})
    end
    if ESX.GetPlayerData().Level >= 1 and (PlayerData.job.name == 'police' or PlayerData.job.name == 'fbi' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'taxi' or PlayerData.job.name == 'mechanic' or PlayerData.job.name == 'benny' or PlayerData.job.name == 'forces' or PlayerData.job.name == 'weazel' or PlayerData.job.name == 'justice' or PlayerData.job.name == 'medic') then
        table.insert(elements, {label = ("Job Tasks [✔️]"), value = 'Job'})
        koonimooni = true
    else 
        table.insert(elements, {label = ("Job Tasks [❌]"), value = nil})
    end
    if ESX.GetPlayerData().Level >= 1 and PlayerData.gang.name ~= 'nogang' and PlayerData.gang.name ~= 'Military' and not koonimooni then
        table.insert(elements, {label = ("Gang Tasks [✔️]"), value = 'Gang'})
    else 
        table.insert(elements, {label = ("Gang Tasks [❌]"), value = nil })
    end 
    --[[if ESX.GetPlayerData().aduty then  
        table.insert(elements, {label = ("Admin Quest [✔️]"), value = 'Admin'})
    end]]
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weaponcraft_menu',{
        title    = "Tasks",
        align    = 'center',
        elements = elements
    }, function(data, menu)
        local action = data.current.value
        if action ~= nil then 
            ShowQuest(action) 
        end 
    end, function(data, menu)
        menu.close()
    end)
end

function ShowQuest(act)
    local act = act 
    local Quests = {}
    Quests = insetrQuestList(act)
    addeds = false
    added = false
    local elements = {}
    for k,v in pairs(Quests) do 
        table.insert(elements, {label = v.description, value =v.type })
    end 
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weaponcraft_menu',{
        title    = "Available Tasks",
        align    = 'center',
        elements = elements
    }, function(data, menu)
        local action = data.current.value
        if action ~= nil then 
            ShowInfoQuest(action ,Quests , act) 
        end 
    end, function(data, menu)
        QuestMenu()
    end)
end

function ShowInfoQuest(action , Quests , act)
    local action = action
    local act = act 
    local Quest = {}
    Quest = Quests 
    local Elements = {}
    local globald
    table.insert(Elements,{label = "------ Task Info ------", value = nil})
    table.insert(Elements, {label = "Task Type : ".. act, value = nil})
    for k,v in pairs(Quest) do 
        if v.type == action then
            globald = v.description
            table.insert(Elements, {label = "Task : ".. v.description, value = nil})
            table.insert(Elements, {label = "Reward : ".. v.reward.. " DCoin", value = nil})
            table.insert(Elements, {label = "Reward : ".."1".. " XP", value = nil})
            table.insert(Elements, {label = "Reward : "..ESX.Math.GroupDigits(taxes).. "$", value = nil})
            if onTheQuest and QuestNames == globald then
                table.insert(Elements, {label = "-----------------------------------", value = "2323"})
                table.insert(Elements, {label = taskLabel, value =  nil })
            end
        end
    end
    table.insert(Elements, {label = "-----------------------------------", value = "2323"})
    if not onTheQuest then
        table.insert(Elements, {label = "[✔️] Accept Task [✔️]", value =  action })
    elseif QuestNames == globald then
        table.insert(Elements, {label = "[❌] Cancel Task [❌]", value = "false"})
    else
        table.insert(Elements, {label = "[❌] Shoma Dar Hale Hazer Yek Task Accept Kardid [❌]", value = nil})
    end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'quest_ask_which',{
        title    = "Info",
        align    = 'center',
        elements = Elements
    }, function(data, menu)
        local actio = data.current.value
        if actio == action then 
            StartYourQuest(action)
        elseif actio == "false" then 
            ExecuteCommand("cancelquest")
            menu.close()
        end 
    end, function(data, menu)
        ShowQuest(act)
    end)
end

---Bot / Blip / Key 
local AllBotPos = {
    {Coord = vector3(-250.9582, -967.8329, 30.21753) , Heading = 257.0 , PedType = "csb_reporter"},
    {Coord = vector3(263.4, -770.46, 29.75) , Heading = 135.91 , PedType = "a_f_y_femaleagent"},
    {Coord = vector3(-1042.364868, -2735.195557, 19.164063) , Heading = 236.12, PedType = "a_f_y_femaleagent"},
    {Coord = vector3(1729.2, 3707.14, 33.15) , Heading = 22.56 , PedType = "csb_reporter"},
}

--[[CreateThread(function()
    for k,v in pairs(AllBotPos) do 
        local Shopper = AddBlipForCoord(v.Coord)
        SetBlipSprite(Shopper, 679)
        SetBlipColour(Shopper,  68)
        SetBlipAlpha(Shopper, 250)
        SetBlipScale(Shopper, 0.7)
        SetBlipAsShortRange(Shopper, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Task')
        EndTextCommandSetBlipName(Shopper)
        ped_hash = GetHashKey(v.PedType)
        RequestModel(ped_hash)
        while not HasModelLoaded(ped_hash) do
            Citizen.Wait(1)
        end
        BossNPC = CreatePed(1, ped_hash,v.Coord,v.Heading, false, true)
        SetBlockingOfNonTemporaryEvents(BossNPC, true)
        SetPedDiesWhenInjured(BossNPC, false)
        SetPedCanPlayAmbientAnims(BossNPC, true)
        SetPedCanRagdollFromPlayerImpact(BossNPC, false)
        SetEntityInvincible(BossNPC, true)
        FreezeEntityPosition(BossNPC, true)
        SetEntityLodDist(BossNPC, 50)
    end
    local Key
    for k,v in pairs(AllBotPos) do
        local Point = RegisterPoint(v.Coord, 5, false)
        local Interact = RegisterPoint(v.Coord, 2, false)
        Point.set("Tag", "Quest_Tag")
        Point.set("InArea", function()
            DrawMarker(32, vector3(v.Coord.x,v.Coord.y,v.Coord.z+2.4),0.50, 0.50, 0.50, 0.0, 360, 0.0, 0.50, 0.50, 0.50, 51, 255, 255, 100, true, true, 2, nil, nil, false)
        end)
        Interact.set("Tag", "QuestMenu")
        Interact.set("InAreaOnce", function()

        end, function()
            ESX.UI.Menu.CloseAll()
            Key = UnregisterKey(Key)
            Key = nil
        end)
    end 
end)]]

local Posi = {
    {-1033.46,-2740.15,19.17,"Drogendealer",57.47,0xB7C61032,"a_f_y_business_04"} 
}

function HelpBot()
	for _,v in pairs(Posi) do
		RequestModel(GetHashKey(v[7]))
		while not HasModelLoaded(GetHashKey(v[7])) do 
			Wait(1)
		end
		RequestAnimDict("mini@strip_club@idles@stripper")
		while not HasAnimDictLoaded("mini@strip_club@idles@stripper") do
			Wait(1)
		end
		ped = CreatePed(4,v[6],v[1],v[2],v[3],3374176,false,true)
		SetEntityHeading(ped,v[5])
		FreezeEntityPosition(ped,true)
		SetEntityInvincible(ped,true)
		SetBlockingOfNonTemporaryEvents(ped, true)
     	TaskPlayAnim(ped,"mini@strip_club@idles@stripper","stripper_idle_01",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
    end
end	

Citizen.CreateThread(HelpBot)

Citizen.CreateThread(function( )
    while true do
        Citizen.Wait(4)
        local distance = #(GetEntityCoords(PlayerPedId()) - vector3(-1033.46,-2740.15,19.17))
        if distance <= 5.0 then
            DrawText3D(-1033.46,-2740.15,19.17, "~w~ Salam ~n~ ~y~ Be Server ~b~ Diamond ~y~ Khosh Amadid ~n~ ~g~ /Help ~s~ Didan Amozesh Server")
        else
            Citizen.Wait(900)
        end
    end
end)

function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterCommand("help", function()
    local List = {}
    TriggerEvent("InteractSound_CL:PlayOnOne", "1", 1.0) 
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051615371934842910/R.png',
        text = "Ghavanin Server", 
        text2 = '', 
        callBack = function()
            TriggerEvent("InteractSound_CL:PlayOnOne", "2", 1.0) 
    end}) 
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051616134534803496/R_2.png',
        text = 'Ertegha Level Fardi',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "3", 1.0) 
    end})
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051616732936151120/job-clipart-job-seeker.png',
        text = 'Shoghl Haye Azad',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "4", 1.0)
            SetNewWaypoint(-269.090118, -956.373596)
    end})
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051617714722050068/3114033.png',
        text = 'Shoghl Haye Dolati',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "5", 1.0) 
    end})
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051621936070926476/25.png',
        text = 'Farm Ya Mazrae Dari',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "6", 1.0) 
    end})
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051618678778638356/2013-6-19-getting-a-new-drivers-license-after-youve-moved-3c18c8ec1d9c445d2ce05affb62213a6.png',
        text = 'Bardasht Mavad Mokhader',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "7", 1.0)
            SetNewWaypoint(238.971436, -1381.134033)
    end})
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051619711420469299/clipart-gun-cute-14.png',
        text = 'Govahiname',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "8", 1.0) 
    end})
        table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051620071807656047/R.png',
        text = 'Mojavez Aslahe',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "9", 1.0) 
    end})
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051620257925709935/35350-3-students-learning-clipart.png',
        text = 'Kharid Ya Peyvastan Be Gang',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "10", 1.0) 
    end})
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051620675170861076/3_3.png',
        text = 'DCoin',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "11", 1.0)
            SetNewWaypoint(-761.380188, -634.443970)
    end})
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051623585585844294/528-5280107_ecommerce-store-logo-png-clipart.png',
        text = 'PlayTime Reward',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "12", 1.0) 
    end})
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051623585585844294/528-5280107_ecommerce-store-logo-png-clipart.png',
        text = 'MarketPlace',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "13", 1.0) 
    end})
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051623585585844294/528-5280107_ecommerce-store-logo-png-clipart.png',
        text = 'Amoozesh Haye Server',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "14", 1.0) 
    end})
    table.insert(List, {
        img = 'https://cdn.discordapp.com/attachments/1003011594327957575/1051623585585844294/528-5280107_ecommerce-store-logo-png-clipart.png',
        text = 'Shop Diamond',
        text2 = "",
        callBack = function() 
            TriggerEvent("InteractSound_CL:PlayOnOne", "15", 1.0) 
    end})
    exports.diamond_dialog:OpenMenu(List, configs)
end)

isNewPlayer = false

RegisterNetEvent("esx:newPlayerConfirmed")
AddEventHandler("esx:newPlayerConfirmed", function()
    isNewPlayer = true
    TriggerServerEvent("esx:NewPlayerInServer")
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            if not exports["xsound"]:isPlayerInStreamerMode() then
                ESX.ShowMissionText("~y~/help ~w~-~g~ Menu Amoozeshi Server")
            end
        end
    end)
end)

exports("isNewPlayer", function()
    return isNewPlayer
end)
