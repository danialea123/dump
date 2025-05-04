---@diagnostic disable: lowercase-global, undefined-field, undefined-global, missing-parameter, param-type-mismatch
ESX = nil
local PlayerData = {}
local labels = {}
local craftingQueue = {}
local Point
local Interact
local BPoint
local Key
local Msg
local job = ""
local grade = 0
local gangs = {
    --["Sicilian"] = vector3(952.88,78.63,111.25),
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
    if PlayerData.gang.name ~= "nogang" then
        GangCarft()
        CraftThread()
    end
    if gangs[PlayerData.gang.name] then
        SpecialCraft(PlayerData.gang.name)
    end
    job = ESX.GetPlayerData().job.name
    grade = ESX.GetPlayerData().job.grade
    ESX.TriggerServerCallback("core_crafting:getItemNames", function(info)
        labels = info
    end)
    if PlayerData.gang.name == "HellsAngels" then
        WashMoney()
        ThreadGo()
    end
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(j)
    job = j.name
    grade = j.grade
end)

RegisterNetEvent('blackmoneyUpdate')
AddEventHandler('blackmoneyUpdate', function(money)
    PlayerData.black_money = money
end)

RegisterNetEvent("esx:setGang")
AddEventHandler("esx:setGang",function(i)
    exports.sr_main:RemoveByTag("specialCraft")
    Wait(1500)
    PlayerData.gang = i
    Wait(3000)
    if PlayerData.gang.name == "HellsAngels" then
        WashMoney()
        ThreadGo()
    end
    if gangs[PlayerData.gang.name] then
        SpecialCraft(PlayerData.gang.name)
    end
end)

function isNearWorkbench()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local near = false
    for _, v in ipairs(Config.Workbenches) do
        local dst = #(coords - v.coords)
        if dst < v.radius then
            near = true
        end
    end
    if near then
        return true
    else
        return false
    end
end

function CraftThread()
    Citizen.CreateThread(function()
        while PlayerData.gang.name ~= "nogang" do
            Citizen.Wait(1000)
            if craftingQueue[1] ~= nil then
                craftingQueue[1].time = craftingQueue[1].time - 1
                SendNUIMessage({
                    type = "addqueue",
                    item = craftingQueue[1].item,
                    time = craftingQueue[1].time,
                    id = craftingQueue[1].id
                })
                if craftingQueue[1].time == 0 then
                    TriggerServerEvent("core_crafting:itemCrafted", craftingQueue[1].item, craftingQueue[1].count)
                    table.remove(craftingQueue, 1)
                end
            end
        end
    end)
end

function SpecialCraft(gang)
    Citizen.CreateThread(function()
        for k, v in pairs(gangs) do
            if gang == k then
                local YaKuZaInteract = nil
                local YaKuZaPoint = nil
                local YaKuZaMsg = nil
                local YaKuZaKey = nil
                local YaKuZaPosition = v
                local YaKuZa = RegisterPoint(YaKuZaPosition, 10, true)
                YaKuZa.set("InAreaOnce", function()
                    YaKuZa.set("Tag", "specialCraft")
                    YaKuZaPoint = RegisterPoint(YaKuZaPosition, 5, true)
                    YaKuZaInteract = RegisterPoint(YaKuZaPosition, 1.5, true)
                    YaKuZaPoint.set("InArea", function()
                        DrawText3D(YaKuZaPosition.x, YaKuZaPosition.y, YaKuZaPosition.z - 0.8, Config.Text["workbench_hologram"])
                    end)
                    YaKuZaInteract.set("InAreaOnce", function()
                        YaKuZaKey = UnregisterKey(YaKuZaKey)
                        YaKuZaMsg = Hint:Create("~INPUT_CONTEXT~ To Open Menu")
                        YaKuZaKey = RegisterKey("E", false, function()
                            TriggerEvent("gangProp:GetInfo", "craft_access", function(lav)
                                if PlayerData.gang.grade >= tonumber(lav) then
                                    openWorkbench({}, true)
                                else
                                    ESX.Alert("Rank Shoma Be Craft Gun Dastresi Nadarad, Az Kingpin Gang Khod Soal Konid", "error")
                                end
                            end)
                        end)
                    end, function()
                        YaKuZaMsg = Hint:Delete()
                        YaKuZaKey = UnregisterKey(YaKuZaKey)
                    end)
                end, function()
                    if YaKuZaPoint then
                        YaKuZaPoint = YaKuZaPoint.remove()
                    end
                    if YaKuZaInteract then 
                        YaKuZaInteract = YaKuZaInteract.remove()
                    end
                    YaKuZaMsg = Hint:Delete()
                    YaKuZaKey = UnregisterKey(YaKuZaKey)
                end)
            end
        end
    end)
end

allitem = {
    'iron',
    'wood',
    'copper',
    'iron',
    'diamond',
    'gold',
}

function openWorkbench(val, lav)
    TriggerEvent("gangProp:GetInfo", "rank", function(rank)
        SetNuiFocus(true, true)
        TriggerScreenblurFadeIn(1000)
        local invItems = {}
        for k,v in pairs(allitem) do 
            ESX.TriggerServerCallback("PlayerInvetoryForGetItemCraft", function(item)
                local key = item.name
                local value = {key = item.count}
                table.insert(invItems,value)
            end, v)
        end
        local inv = {}
        for _, v in ipairs(invItems) do
            inv[v.name] = v.count
        end
        local recipes = {}
        if lav then
            recipes = SpecialGuns[PlayerData.gang.name]
        else
            recipes = Config.Recipes
        end
        SendNUIMessage({
            type = "open",
            recipes = recipes,
            names = labels,
            level = tonumber(rank),
            inventory = inv,
            job = job,
            grade = grade,
            hidecraft = Config.HideWhenCantCraft,
            categories = Config.Categories
        })
    end)
end

function GangCarft()
    local ca = vector4(2359.04,3119.45,48.21,170.83)
    ESX.Game.SpawnLocalObject("gr_prop_gr_bench_02b", vector3(ca.x, ca.y, ca.z-0.9), function(veh)
        SetEntityHeading(veh, ca.w or ca.h)
        local blipCoord = AddBlipForCoord(ca.x, ca.y, ca.z)
        SetBlipSprite (blipCoord, 150)
        SetBlipColour (blipCoord, 24)
        SetBlipScale  (blipCoord, 0.6)
        SetBlipAsShortRange(blipCoord, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Gang Public Craft")
        EndTextCommandSetBlipName(blipCoord)
    end)
    Point = nil
    Interact = nil
    Key = nil
    BPoint = RegisterPoint(vector3(2359.11,3120.06,48.21), 10, true)
    BPoint.set("InAreaOnce", function()
        Point = RegisterPoint(vector3(2359.11,3120.06,48.21), 5, true)
        Interact = RegisterPoint(vector3(2359.11,3120.06,48.21), 1, true)
        Point.set("InArea", function()
            DrawText3D(2359.042, 3119.446, 48.20215 - 0.8, Config.Text["workbench_hologram"])
        end)
        Interact.set("InAreaOnce", function()
            Key = UnregisterKey(Key)
            Msg = Hint:Create("~INPUT_CONTEXT~ To Open Menu")
            Key = RegisterKey("E", false, function()
                TriggerEvent("gangProp:GetInfo", "rank", function(val)
                    if tonumber(val) >= 0 then
                        TriggerEvent("gangProp:GetInfo", "craft_access", function(lav)
                            if PlayerData.gang.grade >= tonumber(lav) then
                                for _, v in ipairs(Config.Workbenches) do
                                    openWorkbench(v, false)
                                end
                            else
                                ESX.Alert("~y~Rank Shoma Be Craft Gun Dastresi Nadarad, Az Kingpin Gang Khod Soal Konid", "error")
                            end
                        end)
                    else
                        ESX.Alert("~y~Gang Shoma Be Level 5 Nareside Ast", "error")
                    end
                end)
            end)
        end, function()
            Hint:Delete()
            Key = UnregisterKey(Key)
        end)
    end, function()
        if Point then
            Point = Point.remove()
        end
        if Interact then 
            Interact = Interact.remove()
        end
        Msg = Hint:Delete()
        Key = UnregisterKey(Key)
    end)
end

AddEventHandler("openCrafte", function()
    TriggerEvent("gangProp:GetInfo", "rank", function(val)
        if tonumber(val) >= 0 then
            TriggerEvent("gangProp:GetInfo", "craft_access", function(lav)
                if PlayerData.gang.grade >= tonumber(lav) then
                    for _, v in ipairs(Config.Workbenches) do
                        openWorkbench(v, false)
                    end
                else
                    ESX.Alert("~y~Rank Shoma Be Craft Gun Dastresi Nadarad, Az Kingpin Gang Khod Soal Konid", "error")
                end
            end)
        else
            ESX.Alert("~y~Gang Shoma Be Level 5 Nareside Ast", "error")
        end
    end)
end)

RegisterNetEvent("core_crafting:craftStart")
AddEventHandler("core_crafting:craftStart", function(item, count)
    if PlayerData.black_money >= Config.Recipes[item].Pool then
        local id = math.random(000, 999)
        table.insert(craftingQueue, {time = 1, item = item, count = 1, id = id})

        SendNUIMessage(
            {
                type = "crafting",
                item = item
            }
        )

        SendNUIMessage(
            {
                type = "addqueue",
                item = item,
                time = 1,
                id = id
            }
        )
    else
        ESX.Alert("Shoma Be Hadeaghal "..ESX.Math.GroupDigits(Config.Recipes[item].Pool).."$ Pool Kasif Niaz Darid", "info")
    end
    end
)

RegisterNetEvent("core_crafting:sendMessage")
AddEventHandler(
    "core_crafting:sendMessage",
    function(msg)
        SendTextMessage(msg)
    end
)

RegisterNUICallback(
    "close",
    function(data)
        TriggerScreenblurFadeOut(1000)
        SetNuiFocus(false, false)
    end
)

RegisterNUICallback(
    "craft",
    function(data)
        local item = data["item"]
        if PlayerData.black_money >= Config.Recipes[item].Pool then
            TriggerServerEvent("core_crafting:craft", item, false)
        else
            ESX.Alert("Shoma Be Hadeaghal "..ESX.Math.GroupDigits(Config.Recipes[item].Pool).."$ Pool Kasif Niaz Darid", "info")
        end
    end
)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)

        SetTextDropshadow(1, 1, 1, 1, 255)

        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55 * scale, 4)
        local width = EndTextCommandGetWidth(4)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

function WashMoney()
	exports.sr_main:RemoveByTag("washmoney_s")
	Citizen.Wait(500)
	local coords = {
		vector3(1470.22,-2636.93,48.99),
	}
	for k, v in pairs(coords) do
		local IPoint
		local Key
		local Point = RegisterPoint(vector3(v.x, v.y, v.z), 5, true)
		Point.set("Tag", "washmoney_s")
		Point.set("InArea", function()
			ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Baz Kardan Menu Wash Money", vector3(v.x, v.y, v.z))
        	DrawMarker(42, vector3(v.x, v.y, v.z), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 500, 100, 30, 255, 0, 0, 0, 0)
		end)
		Point.set("InAreaOnce", function()
			IPoint = RegisterPoint(vector3(v.x, v.y, v.z), 1.5, true)
			IPoint.set("Tag", "washmoney_s")
			IPoint.set('InAreaOnce', function ()
				Hint:Delete()
				Hint:Create('Dokme ~INPUT_CONTEXT~Baraye Baz Kardan Menu Wash Money')
				Key = RegisterKey('E', false, function()
					Key = UnregisterKey(Key)
                    OpenWashMoney()
				end)
			end, function()
				Hint:Delete()
				Key = UnregisterKey(Key)
                ESX.UI.Menu.CloseAll()
			end)
		end, function()
			if IPoint then
				IPoint = IPoint.remove()
			end
		end)
    end
end

function OpenWashMoney()
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback("esx_craft:getPlayerBlackMoney", function(money)
        local value = money
        if value > 5000000 then
            value = 5000000
        end
        local elem = {
            {label = 'Pool Haye Kasif Shoma: <span style="color:green;">$'.. ESX.Math.GroupDigits(value) .. '</span>', value = nil},
            {label = 'Wash Rate: 90%', value = nil},
            {label = 'Pool Tamiz Ghabel Daryaft: <span style="color:green;">$'.. ESX.Math.GroupDigits(ESX.Math.Round(value*0.90)) .. '</span>', value = nil},
            {label = '✔️ Confirm ✔️', value = true},
        }
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'WashMoney', {
            title    = 'WashMoney',
            align    = 'center',
            elements = elem
        }, function(data, menu)
            if not data.current.value then return end
            if PlayerData.gang.grade < 5 then return ESX.Alert("Shoma Dastresi Be WashMoney Nadarid", "info") end
            if value > 0 then
                exports.essentialmode:DisableControl(true)
                TriggerEvent("dpemote:enable", false)
                TriggerEvent("dpclothingAbuse", true)
                TriggerEvent("mythic_progbar:client:progress",{
                    name = "unloc",
                    duration = 60000,
                    label =  "Washing...",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(status)
                    if not status then
                        exports.essentialmode:DisableControl(false)
                        TriggerEvent("dpemote:enable", true)
                        TriggerEvent("dpclothingAbuse", false)
                        TriggerServerEvent("esx_craft:washCurrentMoney")
                    end
                end)
                menu.close()
            else
                ESX.Alert("Pool Haye Kasif Shoma Baraye Wash Kafi Nist", "info")
            end
        end, function(data, menu)
			menu.close()
		end)
    end)
end

function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

local open = false
local busy = false

function OpenBuyMenu()
    if busy then return end
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Cake", value = "hcake"},
        {label = "Marijuana", value = "hmari"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
		title    = 'Buy Item',
		align    = 'center',
		elements = elem
	}, function(data, menu)
        busy = true
        ExecuteCommand("e mechanic4")
        exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
        TriggerEvent("mythic_progbar:client:progress",{
            name = "unloc",
            duration = 7000,
            label =  data.current.label.."...",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
        }, function(status)
            if not status then
                exports.essentialmode:DisableControl(false)
                TriggerEvent("dpemote:enable", true)
                TriggerEvent("dpclothingAbuse", false)
                TriggerServerEvent("esx_customCraft:AddItem", data.current.value)
                ClearPedTasks(PlayerPedId())
                busy = false
            end
        end)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function ThreadGo()
    Citizen.CreateThread(function()
        while PlayerData.gang.name == "HellsAngels" do
            Citizen.Wait(3)
            local coord = GetEntityCoords(PlayerPedId())
            local v = vector4(1458.48,-2620.86,48.99,168.52)
            if GetDistanceBetweenCoords(coord, v, true) <= 6.0 then
                DrawMarker(21, v, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 100, 150, 200, 255, false, true, 2, false, false, false, false)
                if GetDistanceBetweenCoords(coord, v, true) <= 1.0 then
                    if IsControlJustReleased(0, 38) then
                        OpenBuyMenu()
                        open = true
                    end
                else
                    if open then
                        open = false
                        ESX.UI.Menu.CloseAll()
                    end
                end
            else
                Citizen.Wait(750)
            end
        end
    end)
end

RegisterNetEvent("esx_customCrafte:smoke")
AddEventHandler("esx_customCrafte:smoke", function()
    ExecuteCommand("e smoke")
end)