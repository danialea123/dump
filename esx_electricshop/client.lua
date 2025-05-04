ESX = nil
MenuOpen = false
ShopNPC = -1
started = false
pack = -1
PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		
		Citizen.Wait(0)
	end
    ESX.TriggerServerCallback('sr_electricshop:GetShopStatus', function(robbed)
        CreateBuyItems(robbed)
    end)
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
	PlayerData = newData
end)

function CreateBlip(coords, text, sprite, color, scale)
	local blip = AddBlipForCoord(table.unpack(coords))
	
	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
end

function DrawText3D(x, y, z, text)
    local onScreen,x,y = World3dToScreen2d(x, y, z)
    local factor = #text / 370

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x,y)
        DrawRect(x,y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 120)
    end
end

function Marker(pos, r, g, b)
    DrawMarker(25, pos["x"], pos["y"], pos["z"] - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75, 0.75, 0.75, r or 200, g or 200, b or 200, 60, false, false, 2, false, nil, nil, false)
    DrawMarker(25, pos["x"], pos["y"], pos["z"] - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, r or 200, g or 200, b or 200, 60, false, false, 2, false, nil, nil, false)
end

function startAnim(ped, dictionary, anim)
	Citizen.CreateThread(function()
	  RequestAnimDict(dictionary)
	  while not HasAnimDictLoaded(dictionary) do
		Citizen.Wait(0)
	  end
		TaskPlayAnim(ped, dictionary, anim ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end

function OpenMenu(name, price, label)
    MenuOpen = ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'buy_'..name,
    {
        title 	 = 'Pardakht Hazine',
        align    = 'center',
        question = 'Hazine Yek ' .. label .. ' Be Mablaqe $' .. ESX.Math.GroupDigits(price) .. ' Mibashad, Pardakht Be raveshe:',
        elements = {
            {label = 'Naghd', value = 'cash'},
            {label = 'Cart', value = 'bank'},
            {label = 'Enseraf', value = 'cancel'}
        }
    }, function(data, menu)
        local choosen = data.current.value
        if choosen == 'cancel' then
            menu.close()
            MenuOpen = false
        elseif choosen == 'bank' then
            if ESX.GetPlayerData().bank >= price then
                menu.close()
                TriggerServerEvent('sr_electricshop:Pay', 'bank', name)
                MenuOpen = false
            else
                ESX.ShowNotification('~r~Shoma Dar Hesabe Banki Khob Be andaze Kafi Pool nadarid')
            end
        elseif choosen == 'cash' then
            if ESX.GetPlayerData().money >= price then
                menu.close()
                TriggerServerEvent('sr_electricshop:Pay', 'money', name)
                MenuOpen = false
            else
                ESX.ShowNotification('~r~Shoma Be andaze Kafi Pool Hamrahe Khodeton nadarid')
            end
        end
    end)
end

CreateBlip(Config.blip, 'Electric Shop', 521, 22, 0.8)

function CreateBuyItems(robbed)
    if robbed then
        local Point = RegisterPoint(Config.blip, 12, true)
        Point.set('Tag', 'electricshop_robbed')
        Point.set('InAreaOnce', function()
            ESX.ShowNotification('Az in Maghaze Serghat Shode, Lotfan In Makan ro Tark konid')
        end)
    else
        for k,v in ipairs(Config.Items) do
            local Key
            local Interact
            local Point = RegisterPoint(v.c, Config.DrawDistance, true)
            Point.set('Tag', 'electricshop_items')
            Point.set('InArea', function ()
                Marker(v.c, 247, 198, 91)
            end)
            Point.set('InAreaOnce', function ()
                Interact = RegisterPoint(v.c, 0.4, true)
                Interact.set('Tag', 'electricshop_items')
                Interact.set('InArea', function()
                    DrawText3D(v.c.x, v.c.y, v.c.z, '[E] Kharid ' .. v.label)
                end)
                Interact.set('InAreaOnce', function ()
                    Key = RegisterKey('E', false, function ()
                        if not MenuOpen then
                            OpenMenu(v.name, Config.Prices[v.name], v.label)
                        end
                    end)
                end, function ()
                    if MenuOpen then
                        MenuOpen.close()
                        MenuOpen = false
                    end
                    Key = UnregisterKey(Key)
                end)
                Interact.set('OnRemove', function()
                    Key = UnregisterKey(Key)
                end)
            end, function ()
                if Interact then
                    Interact = Interact.remove()
                end
            end)
        end
    end
end

RegisterNetEvent('sr_electricshop:ToggleShop')
AddEventHandler('sr_electricshop:ToggleShop', function(disable)
    if disable then
        exports.sr_main:RemoveByTag('electricshop_items')
        CreateBuyItems(true)
        ended = true
        SetTimeout(1000, function()
            ended = false
        end)
        if DoesEntityExist(ShopNPC) then
            FreezeEntityPosition(ShopNPC, false)
            SetBlockingOfNonTemporaryEvents(ShopNPC, true)
            startAnim(ShopNPC, 'anim@mp_player_intuppersurrender', 'enter')
            TaskGoStraightToCoord(ShopNPC, Config.SafeBox.c, 1.5, 5000, Config.SafeBox.h, 1.0)
        end
    else
        exports.sr_main:RemoveByTag('electricshop_robbed')
        CreateBuyItems(false)
    end
end)

RegisterNetEvent('sr_electricshop:ShopNPCGiveupMoney')
AddEventHandler('sr_electricshop:ShopNPCGiveupMoney', function()
    if DoesEntityExist(ShopNPC) then
        ClearPedTasks(ShopNPC)
        local coordsPed = GetEntityCoords(ShopNPC)
        startAnim(ShopNPC, 'anim@heists@box_carry@', 'idle')
        pack = CreateObject(GetHashKey('prop_cash_case_02'), coordsPed,  false,  true, true)
        AttachEntityToEntity(pack, ShopNPC, GetPedBoneIndex(ShopNPC, 57005), 0.20, 0.05, -0.25, 260.0, 60.0, 0, true, true, false, true, 1, true)
    end
end)

RegisterNetEvent('sr_electricshop:ShopNPCDone')
AddEventHandler('sr_electricshop:ShopNPCDone', function()
    if DoesEntityExist(ShopNPC) then
        DeleteEntity(pack)
        Citizen.Wait(5000)
        DeletePed(ShopNPC)
        ShopNPC, pack = -1, -1
    end
end)

function StealItems()
    local total = #Config.Items
    local last = {}
    for i=1, Config.AddtionalRewardCount do
        local id
        repeat
            id = math.random(1, total)
        until not last[id] and not (Config.Items[id].name == 'radiocar')
        last[id] = true
        local v = Config.Items[id]
        local Key
        local Interact
        local Point = RegisterPoint(v.c, Config.DrawDistance, true)
        Point.set('Tag', 'electricshop_steal_items')
        Point.set('InArea', function ()
            Marker(v.c, 247, 198, 91)
        end)
        Point.set('InAreaOnce', function ()
            Interact = RegisterPoint(v.c, 0.4, true)
            Interact.set('Tag', 'electricshop_steal_items')
            Interact.set('InArea', function()
                DrawText3D(v.c.x, v.c.y, v.c.z, '[E] Dozdidan ' .. v.label)
            end)
            Interact.set('InAreaOnce', function ()
                Key = RegisterKey('E', false, function ()
                    Key = UnregisterKey(Key)
                    Interact.remove()
                    Point.remove()
                    TaskAchieveHeading(PlayerPedId(), v.h, 1000)
                    startAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search")
                    exports.rprogress:Custom({
                        Duration = 6500,
                        Label = "Dozdidan " .. v.label .. ' ...',
                        Animation = {
                            scenario = "",
                            animationDictionary = "",
                        },
                        DisableControls = {
                            Mouse = false,
                            Player = true,
                            Vehicle = true
                        }
                    })
                    Wait(6500)
                    TriggerServerEvent('sr_electricshop:StealItems', v.name)
                end)
            end, function ()
                Key = UnregisterKey(Key)
            end)
            Interact.set('OnRemove', function()
                Key = UnregisterKey(Key)
            end)
        end, function ()
            if Interact then
                Interact = Interact.remove()
            end
        end)
    end

    local InPositionPoint = RegisterPoint(Config.blip, 25, true)
    InPositionPoint.set('OutAreaOnce', function ()
        exports.sr_main:RemoveByTag('electricshop_steal_items')
        InPositionPoint.remove()
    end)
end

Citizen.CreateThread(function()
    local MainPoint = RegisterPoint(Config.blip, 25, false)
    MainPoint.set('InAreaOnce', function ()
        ESX.TriggerServerCallback('sr_electricshop:GetRobStatus', function (robbed, copOnline)
            if not robbed and copOnline then
                while not HasModelLoaded(1567728751) do Wait(0) RequestModel(1567728751) end
                ShopNPC = CreatePed(4, 1567728751, Config.Cashier.c, Config.Cashier.h, false, true)
                SetPedDiesWhenInjured(ShopNPC, false)
                SetPedCanPlayAmbientAnims(ShopNPC, true)
                SetPedCanRagdollFromPlayerImpact(ShopNPC, false)
                SetEntityInvincible(ShopNPC, true)
                FreezeEntityPosition(ShopNPC, true)
                CreateIntraction()
            end
        end)
    end, function()
        if DoesEntityExist(ShopNPC) then
            DeleteEntity(ShopNPC)
        end
        if DoesEntityExist(pack) then
            DeleteEntity(pack)
        end
    end)
end)

function CreateIntraction()
    --[[while DoesEntityExist(ShopNPC) and not ended do
        if IsPlayerFreeAiming(PlayerId()) then
            local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if IsPedFleeing(targetPed) and targetPed == ShopNPC then
                --TriggerEvent("gangProp:GetInfo", "rank", function(rank)
                    --if tonumber(rank) >= 0 then 
                        StealItems()
                        MakeAliveBot()
                        return
                    --[[else
                        ESX.Alert("Gang Shoma Be Level 4 Nareside Ast", "error")
                        return 
                    end]]
                --end)
            --[[end
        end
        Citizen.Wait(1500)
    end]]
end

function MakeAliveBot()
    TriggerEvent('sr_electricshop:RobItems')
    local playercoord = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('sr_electricshop:ProcessStart', GetStreetNameFromHashKey(GetStreetNameAtCoord(playercoord.x, playercoord.y, playercoord.z)))
    started = true

    local InPositionPoint = RegisterPoint(Config.blip, 25, true)
    InPositionPoint.set('OutAreaOnce', function ()
        if started then
            exports.pNotify:SendNotification({text = "<b>Electric Robbery</b></br>You've run too far", timeout = 4500})
            started = false
            restart = true
            Citizen.Wait(5000)
            restart = false
            exports.sr_main:RemoveByTag('electric_rob')
        end
        InPositionPoint.remove()
    end)

    local displaying = true
    SetTimeout(3000, function()
        displaying = false
    end)

    local function DisplayFear()
        local coordsPed = GetEntityCoords(ShopNPC, false)             
        DrawText3D(coordsPed.x, coordsPed.y, coordsPed.z + 1.2, "I'm already opening")
        if not restart and displaying then
            SetTimeout(0, DisplayFear)
        end
    end
    DisplayFear()

    local function CheckDistanceToSafeBox(cb)
        local coordsPed = GetEntityCoords(ShopNPC)
        if (Vdist(coordsPed, Config.SafeBox.c) < 1.5) then
            ESX.SetEntityCoords(ShopNPC, Config.SafeBox.c.x, Config.SafeBox.c.y, Config.SafeBox.c.z-1)
            SetEntityHeading(ShopNPC, Config.SafeBox.h)
            FreezeEntityPosition(ShopNPC, true)
            cb()
        else
            SetTimeout(0, function ()
                CheckDistanceToSafeBox(cb)
            end)
        end	
    end

    local function GiveUpMoney()
        local Key
        local Point = RegisterPoint(Config.SafeBox.c, 1.5, true)
        Point.set('Tag', 'electric_rob')
        Point.set('InArea', function ()
            DrawText3D(Config.SafeBox.c.x, Config.SafeBox.c.y, Config.SafeBox.c.z + 1, "To take the money, press [~r~E~w~]")
        end)
        Point.set('InAreaOnce', function ()
            Key = RegisterKey('E', false, function ()
                if not IsPedInAnyVehicle(PlayerPedId(), false) then
                    Key = UnregisterKey(Key)
                    FreezeEntityPosition(ShopNPC, false)
                    TaskTurnPedToFaceEntity(ShopNPC, PlayerPedId(), 0.2)
                    startAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search")
                    exports.rprogress:Custom({
                        Duration = 6500,
                        Label = "Taking money...",
                        Animation = {
                            scenario = "",
                            animationDictionary = "",
                        },
                        DisableControls = {
                            Mouse = false,
                            Player = true,
                            Vehicle = true
                        }
                    })
                    Citizen.Wait(6500)
                    Point.remove()
                    ClearPedTasks(ShopNPC)
                    TriggerServerEvent('sr_electricshop:ShopNPCDone')
                    TaskPlayAnim(ShopNPC, 'anim@heists@box_carry@', "exit", 3.0, 1.0, -1, 49, 0, 0, 0, 0)
                    exports.sr_main:RemoveByTag('electric_rob')
                    ESX.TriggerServerCallback('sr_electricshop:payout', function(money)
                        exports.pNotify:SendNotification({text = "<b>Shop Robbery</b></br>You took "..money.."$", timeout = 4500})
                    end)
                    started = false
                end
            end)
        end, function ()
            Key = UnregisterKey(Key)
        end)
    end

    local Timer = Config.SecToRob + 1

    local function CountReadyUpTimer()
        local Point = RegisterPoint(Config.SafeBox.c, 3.5, true)
        Point.set('Tag', 'electric_rob')
        Point.set('InArea', function ()
            if Timer > 0 then
                DrawText3D(Config.SafeBox.c.x, Config.SafeBox.c.y, Config.SafeBox.c.z + 1.0, 'Time: '..Timer)
            end
        end)

        local function TimeCounter()
            Timer = Timer - 1
            if Timer <= 0 then
                if Point then
                    Point.remove()
                end
                exports.pNotify:SendNotification({text = "<b>Shop Robbery</b></br>Cash ready to be picked up", timeout = 4500})
                TriggerServerEvent('sr_electricshop:ShopNPCGiveupMoney')
                GiveUpMoney()
            else
                SetTimeout(1000, TimeCounter)
            end
        end

        TimeCounter()
    end

    CheckDistanceToSafeBox(function ()
        ClearPedTasks(ShopNPC)
        FreezeEntityPosition(ShopNPC, true)
        startAnim(ShopNPC, 'amb@prop_human_bum_bin@idle_a', 'idle_a')
        CountReadyUpTimer()
    end)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        DeleteEntity(ShopNPC)
        DeleteEntity(pack)
	end
end)