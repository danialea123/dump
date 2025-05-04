---@diagnostic disable: undefined-field, param-type-mismatch, missing-parameter, undefined-global, lowercase-global, redundant-parameter, need-check-nil
local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
  
local set                       = false
local cufftime                  = false
local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsHandcuffed              = false
local IsDragged                 = false
local IsBusy, isBusy            = false, false
local CopPed                    = 0
local allBlip                   = {}
local gangProp                  = nil
local Data                      = {}
local PointKey                  = nil
local InteractKey               = nil
local cuffTimer                 = 0
local HeliCodes                 = {}
ESX                             = nil
Condition                       = false
GUI.Time                        = 0
local Base2Blip                 = nil
local CustomBproof = {
    ["KingOfKing"] = {
        [1] = 79,
        [2] = 0,
    },
	["Horizon"] = {
        [1] = 79,
        [2] = 1,
    },
    ["DARK"] = {
        [1] = 79,
        [2] = 2,
    },
    ["Vendetta"] = {
        [1] = 79,
        [2] = 3,
    },
    ["Liquid"] = {
        [1] = 79,
        [2] = 4,
    },
    ["Spirit"] = {
        [1] = 79,
        [2] = 5,
    },
    ["GHATELIN"] = {
        [1] = 79,
        [2] = 6,
    },
    ["Avengers"] = {
        [1] = 79,
        [2] = 7,
    },
    ["Sopranos"] = {
        [1] = 79,
        [2] = 8,
    },
    ["RedFM"] = {
        [1] = 79,
        [2] = 9,
    },
    ["HellsAngels"] = {
        [1] = 79,
        [2] = 10,
    },
    ["PERSIAN"] = {
        [1] = 79,
        [2] = 11,
    },
    ["DELTA"] = {
        [1] = 79,
        [2] = 12,
    },
    ["Vision"] = {
        [1] = 79,
        [2] = 13,
    },
    ["ZERO"] = {
        [1] = 79,
        [2] = 14,
    },
    ["KBM"] = {
        [1] = 79,
        [2] = 15,
    },
    ["SNO"] = {
        [1] = 79,
        [2] = 16,
    },
    ["PeakyBlinders"] = {
        [1] = 122,
        [2] = 0,
    },
    ["Rebel"] = {
        [1] = 79,
        [2] = 17,
    },
    ["OWL"] = {
        [1] = 79,
        [2] = 18,
    },
    ["CRIMSON"] = {
        [1] = 79,
        [2] = 19,
    },
    ["Valton"] = {
        [1] = 79,
        [2] = 20,
    },
    ["Brotherhood"] = {
        [1] = 79,
        [2] = 21,
    },
    ["Kraken"] = {
        [1] = 79,
        [2] = 22,
    },
    ["Godal"] = {
        [1] = 79,
        [2] = 23,
    },
    ["Aedans"] = {
        [1] = 79,
        [2] = 24,
    },
    ["SaWaK"] = {
        [1] = 79,
        [2] = 25,
    },
}

local CustomBproofFemale = {
    ["KingOfKing"] = {
        [1] = 94,
        [2] = 0,
    },
	["Horizon"] = {
        [1] = 94,
        [2] = 1,
    },
    ["DARK"] = {
        [1] = 94,
        [2] = 2,
    },
    ["Vendetta"] = {
        [1] = 94,
        [2] = 3,
    },
    ["Liquid"] = {
        [1] = 94,
        [2] = 4,
    },
    ["Spirit"] = {
        [1] = 94,
        [2] = 5,
    },
    ["GHATELIN"] = {
        [1] = 94,
        [2] = 6,
    },
    ["Avengers"] = {
        [1] = 94,
        [2] = 7,
    },
    ["Sopranos"] = {
        [1] = 94,
        [2] = 8,
    },
    ["RedFM"] = {
        [1] = 94,
        [2] = 9,
    },
    ["HellsAngels"] = {
        [1] = 94,
        [2] = 10,
    },
    ["PERSIAN"] = {
        [1] = 94,
        [2] = 11,
    },
    ["DELTA"] = {
        [1] = 94,
        [2] = 12,
    },
    ["Vision"] = {
        [1] = 94,
        [2] = 13,
    },
    ["ZERO"] = {
        [1] = 94,
        [2] = 14,
    },
    ["KBM"] = {
        [1] = 94,
        [2] = 15,
    },
    ["SNO"] = {
        [1] = 94,
        [2] = 16,
    },
    ["GoldenFamily"] = {
        [1] = 131,
        [2] = 0,
    },
    ["Rebel"] = {
        [1] = 94,
        [2] = 17,
    },
    ["OWL"] = {
        [1] = 94,
        [2] = 18,
    },
    ["CRIMSON"] = {
        [1] = 94,
        [2] = 19,
    },
    ["Valton"] = {
        [1] = 94,
        [2] = 20,
    },
    ["Brotherhood"] = {
        [1] = 94,
        [2] = 21,
    },
    ["Kraken"] = {
        [1] = 94,
        [2] = 22,
    },
    ["Godal"] = {
        [1] = 94,
        [2] = 23,
    },
    ["Aedans"] = {
        [1] = 94,
        [2] = 24,
    },
    ["SaWaK"] = {
        [1] = 94,
        [2] = 25,
    },
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().gang == nil do 
    Citizen.Wait(500)
    end
    PlayerData = ESX.GetPlayerData()
    AboGhaza()
    while gangProp == nil do
        Citizen.Wait(500)
    end
    if PlayerData.gang.name == "KingOfKing" then
        gangProp.AddBase("Veh", vector3(2055.91,3175.2,45.17), vector4(2055.76,3180.63,45.17,60.72))
        gangProp.AddBase("VehDel", vector3(2055.76,3180.63,45.17))
        gangProp.AddBase("Armory", vector3(2060.78,3174.02,45.17))
    end
    --[[if PlayerData.gang.name == "Blackmarket" then
        gangProp.AddBase("Locker", vector3(145.6879, -2199.547, 4.679077))
        gangProp.AddBase("Veh"   , vector3(126.6857, -2204.585, 7.172852), vector4(126.2242, -2199.073, 6.0271, 358.62))
        gangProp.AddBase("VehDel", vector3(126.2242, -2199.073, 6.0271))
    end]]
    if PlayerData.gang.name ~= "nogang" then
        InteractKey = RegisterKey("F5", false, function()
            if ESX.GetPlayerData().isSentenced then return end
            if ESX.isDead() then return end
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                OpenGangActionsMenu()
            else
                OpenEkhtarMenu()
            end
        end)
        PointKey = RegisterKey("E", false, function()
            RequestPointCheck()
        end)
    end
    --[[if PlayerData.gang.name == "WyverN" then
        gangProp.AddBase("VehDel", vector3(-773.9473, -232.8396, 37.06445))
    end]]
end)

function AboGhaza()
	exports.sr_main:RemoveByTag("aboghazagang")
	Citizen.Wait(500)
	local coords = {
        ["STAFF"] = vector3(-1347.34,75.5,60.54),
	}
	for k, v in pairs(coords) do
        if k == PlayerData.gang.name then
            local IPoint
            local Key
            local Point = RegisterPoint(vector3(v.x, v.y, v.z), 5, true)
            Point.set("Tag", "aboghazagang")
            Point.set("InArea", function()
                ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Gereftan Ab o Ghaza", vector3(v.x, v.y, v.z))
                DrawMarker(0, vector3(v.x, v.y, v.z), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 500, 150, 200, 255, 0, 0, 0, 0)
            end)
            Point.set("InAreaOnce", function()
                IPoint = RegisterPoint(vector3(v.x, v.y, v.z), 1.5, true)
                IPoint.set("Tag", "aboghazagang")
                IPoint.set('InAreaOnce', function ()
                    Hint:Delete()
                    Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Gereftan Ab o Ghaza')
                    Key = RegisterKey('E', false, function()
                        Key = UnregisterKey(Key)
                        TriggerEvent('esx_status:setirs', 'hunger', 1000000)
                        TriggerEvent('esx_status:setirs', 'thirst', 1000000)
                        TriggerEvent('esx_status:setirs', 'mental', 1000000)
                        ESX.Alert("Ab o Ghaza o Maghz Shoma Full Shod", "check")
                    end)
                end, function()
                    Hint:Delete()
                    Key = UnregisterKey(Key)
                end)
            end, function()
                if IPoint then
                    IPoint = IPoint.remove()
                end
            end)
        end
    end
end

function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function CreateSecondBase()
    local self = {}
    self.AddBase = function(Index, Point, SPoint)
        if Index and Point then
            if Index == "Armory" then
                local Locker       = RegisterPoint(Point, 12, true)
                local LockerPoint  = nil
                local LockerThread = nil
                local LockerKey    = nil
                local LockerMsg    = nil
                Locker.set("Tag", "SecondLocker")
                Locker.set("InAreaOnce", function()
                    LockerPoint  = RegisterPoint(Point, 10, true)
                    LockerThread = RegisterPoint(Point, 1, true)
                    LockerPoint.set("InArea", function()
                        DrawMarker(42, Point.x, Point.y, Point.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 135, 31, 100, false, true, 2, false, false, false, false)
                    end)
                    LockerThread.set("InAreaOnce", function()
                        LockerKey = UnregisterKey(LockerKey)
                        LockerMsg = Hint:Create("~INPUT_CONTEXT~ Baraye Baz Kardan Armory")
                        LockerKey = RegisterKey("E", false, function()
                            if PlayerData.gang.grade >= Data.armory_access then
                                OpenArmoryMenu(PlayerData.gang.name)
                            else
                                ESX.Alert("Shoma Be Armory Dastresi Nadarid", "info")
                            end
                        end)
                    end, function()
                        CurrentAction = nil
                        ESX.UI.Menu.CloseAll()
                        LockerKey = UnregisterKey(LockerKey)
                        LockerMsg = Hint:Delete()
                    end)
                end, function()
                    CurrentAction = nil
                    ESX.UI.Menu.CloseAll()
                    LockerKey = UnregisterKey(LockerKey)
                    LockerMsg = Hint:Delete()
                    LockerPoint = LockerPoint.remove()
                    LockerThread = LockerThread.remove()
                end)
            elseif Index == "Veh" then
                local Veh       = RegisterPoint(Point, 12, true)
                local VehPoint  = nil
                local VehThread = nil
                local VehKey    = nil
                local VehMsg    = nil
                Veh.set("Tag", "SecondVeh")
                Veh.set("InAreaOnce", function()
                    VehPoint  = RegisterPoint(Point, 10, true)
                    VehThread = RegisterPoint(Point, 1, true)
                    VehPoint.set("InArea", function()
                        DrawMarker(36, Point.x, Point.y, Point.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                    end)
                    VehThread.set("InAreaOnce", function()
                        VehKey = UnregisterKey(VehKey)
                        VehMsg = Hint:Create("~INPUT_CONTEXT~ Baraye Baz Kardan Garage Gang")
                        VehKey = RegisterKey("E", false, function()
                            --if PlayerData.gang.grade >= Data.garage_access then
                                OwnedCarsMenu(SPoint)
                            --else
                                --ESX.Alert(" Shoma Be Garage Dastresi Nadarid")
                            --end
                        end)
                    end, function()
                        VehKey = UnregisterKey(VehKey)
                        VehMsg = Hint:Delete()
                    end)
                end, function()
                    VehKey = UnregisterKey(VehKey)
                    VehMsg = Hint:Delete()
                    VehPoint = VehPoint.remove()
                    VehThread = VehThread.remove()
                end)
            elseif Index == "VehDel" then
                local VehDel       = RegisterPoint(Point, 12, true)
                local VehPointDel  = nil
                local VehThreadDel = nil
                local VehKeyDel    = nil
                local VehMsgDel    = nil
                VehDel.set("Tag", "SecondVehDel")
                VehDel.set("InAreaOnce", function()
                    VehPointDel  = RegisterPoint(Point, 10, true)
                    VehThreadDel = RegisterPoint(Point, 1, true)
                    VehPointDel.set("InArea", function()
                        local playerPed  = PlayerPedId()
                        if IsPedInAnyVehicle(playerPed,  false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                            DrawMarker(24, Point.x, Point.y, Point.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, 200, Config.MarkerColor.g, 100, 100, false, true, 2, true, false, false, false)
                        end
                    end)
                    VehThreadDel.set("InAreaOnce", function()
                        VehKeyDel = UnregisterKey(VehKeyDel)
                        local playerPed  = PlayerPedId()
                        if IsPedInAnyVehicle(playerPed,  false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                            VehMsgDel = Hint:Create("~INPUT_CONTEXT~ Baraye Park Kardan Mashin")
                            VehKeyDel = RegisterKey("E", false, function()
                                StoreOwnedCarsMenu()
                            end)
                        end
                    end, function()
                        VehKeyDel = UnregisterKey(VehKeyDel)
                        VehMsgDel = Hint:Delete()
                    end)
                end, function()
                    VehKeyDel = UnregisterKey(VehKeyDel)
                    VehMsgDel = Hint:Delete()
                    VehPointDel = VehPointDel.remove()
                    VehThreadDel = VehThreadDel.remove()
                end)
            elseif Index == "Locker" then
                local Armory       = RegisterPoint(Point, 12, true)
                local ArmoryPoint  = nil
                local ArmoryThread = nil
                local ArmoryKey    = nil
                local ArmoryMsg    = nil
                Armory.set("Tag", "SecondArmory")
                Armory.set("InAreaOnce", function()
                    ArmoryPoint  = RegisterPoint(Point, 10, true)
                    ArmoryThread = RegisterPoint(Point, 1, true)
                    ArmoryPoint.set("InArea", function()
                        DrawMarker(31, Point.x, Point.y, Point.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
                    end)
                    ArmoryThread.set("InAreaOnce", function()
                        ArmoryKey = UnregisterKey(LockerKey)
                        ArmoryMsg = Hint:Create("~INPUT_CONTEXT~ Baraye Baz Kardan Locker")
                        ArmoryKey = RegisterKey("E", false, function()
                            OpenCloakroomMenu()
                        end)
                    end, function()
                        ArmoryKey = UnregisterKey(ArmoryKey)
                        ArmoryMsg = Hint:Delete()
                    end)
                end, function()
                    ArmoryKey = UnregisterKey(ArmoryKey)
                    ArmoryMsg = Hint:Delete()
                    ArmoryPoint = ArmoryPoint.remove()
                    ArmoryThread = ArmoryThread.remove()
                end)
            elseif Index == "Boss" then
                local Boss       = RegisterPoint(Point, 12, true)
                local BossPoint  = nil
                local BossThread = nil
                local BossKey    = nil
                local BossMsg    = nil
                Boss.set("Tag", "SecondBoss")
                Boss.set("InAreaOnce", function()
                    BossPoint  = RegisterPoint(Point, 10, true)
                    BossThread = RegisterPoint(Point, 1.5, true)
                    BossPoint.set("InArea", function()
                        DrawMarker(23, Point.x, Point.y, Point.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                    end)
                    BossThread.set("InAreaOnce", function()
                        BossKey = UnregisterKey(LockerKey)
                        BossMsg = Hint:Create("~INPUT_CONTEXT~ Baraye Baz Kardan Bossaction")
                        BossKey = RegisterKey("E", false, function()
                            ESX.UI.Menu.CloseAll()
                            TriggerEvent('gangs:openBossMenu', PlayerData.gang.name, function(data, menu)
                                --ESX.UI.Menu.CloseAll()
                            end)
                        end)
                    end, function()
                        BossKey = UnregisterKey(BossKey)
                        BossMsg = Hint:Delete()
                    end)
                end, function()
                    BossKey = UnregisterKey(BossKey)
                    BossMsg = Hint:Delete()
                    BossPoint = BossPoint.remove()
                    BossThread = BossThread.remove()
                end)
            end
        end
    end
    return self
end

gangProp = CreateSecondBase()

AddEventHandler("gangProp:GetInfo", function(value, cb)
    while Data[value] == nil do
        Wait(100)
    end
    cb(Data[value])
end)

exports("GetInfoData", function()
    return Data
end)

function OpenCloakroomMenu()
    local elements = {
        {label = _U('citizen_wear'), value = 'citizen_wear'},
        {label = 'Lebas Gang 1', value = 1},
        {label = 'Lebas Gang 2', value = 2},
        {label = 'Lebas Gang 3', value = 3},
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
        title    = _U('cloakroom'),
        align    = 'top-right',
        elements = elements,
    }, function(data, menu)
        menu.close()
        if GetHashKey('mp_m_freemode_01') ~= GetEntityModel(PlayerPedId()) and GetHashKey('mp_f_freemode_01') ~= GetEntityModel(PlayerPedId()) then return end
        ESX.TriggerServerCallback('esx_skin:getGangSkin', function(skin, gangSkin)
            skin['bproof_1'] = nil
            skin['bproof_2'] = nil
            gangSkin['bproof_1'] = nil
            gangSkin['bproof_2'] = nil
            if data.current.value == 'citizen_wear' then
                TriggerEvent('skinchanger:loadSkin', skin)
                TriggerEvent('esx:restoreLoadout')
                ESX.SetPedArmour(PlayerPedId(), 0)
                Citizen.Wait(1000)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin.sex == 0 then
                        local clothesSkin = {
                            ['bproof_1'] = 0,  ['bproof_2'] = 0,
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                    elseif skin.sex == 1 then
                        local clothesSkin = {
                            ['bproof_1'] = 0,  ['bproof_2'] = 0,
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                    end
                end)
            else
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, gangSkin["skin_male"..data.current.value])
                else
                    TriggerEvent('skinchanger:loadClothes', skin, gangSkin["skin_female"..data.current.value])
                end
                Citizen.Wait(1000)
                if GetPedArmour(PlayerPedId()) > 0 then
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            local code1 = 23
                            local code2 = 9
                            if CustomBproof[PlayerData.gang.name] then
                                code1 = CustomBproof[PlayerData.gang.name][1]
                                code2 = CustomBproof[PlayerData.gang.name][2]
                            end
                            local clothesSkin = {
                                ['bproof_1'] = code1,  ['bproof_2'] = code2,
                            }
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        elseif skin.sex == 1 then
                            local c1 = 20
                            local c2 = 9
                            if CustomBproofFemale[PlayerData.gang.name] then
                                c1 = CustomBproofFemale[PlayerData.gang.name][1]
                                c2 = CustomBproofFemale[PlayerData.gang.name][2]
                            end
                            local clothesSkin = {
                                ['bproof_1'] = c1,  ['bproof_2'] = c2,
                            }
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end
                    end)
                end
            end
        end)
    end, function(data, menu)
        menu.close()
    end)
end

function OpenArmoryMenu(station)
    local station = station
    local elements = {
        {label = 'Inventory Gang', value = 'property_inventory'},
        {label = 'Personal Stash', value = 'stash'},
        {label = 'Gereftan Armor Be Gheymat '..Data.vest_price.. '$',  value = 'get_armor'},
        {label = 'Gereftan Armor Makhfi Be Gheymat '.."15000".. '$',  value = 'get_armor_makhfi'}
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
        title    = _U('armory'),
        align    = 'top-right',
        elements = elements,
    }, function(data, menu)
        if data.current.value == "stash" then
            ESX.UI.Menu.CloseAll()
            TriggerEvent("esx_inventoryhud:OpenStash", PlayerData.gang.name)
            return 
        end
        if data.current.value == "property_inventory" then
            --if PlayerData.gang.grade >= Data.armory_access then
                --menu.close()
                OpenGangInventoryMenu(station)
            --else
                --ESX.Alert("~h~Shoma Ejaze Dastresi Be Armory Nadarid")
            --end
        elseif data.current.value == 'get_armor' then
            if PlayerData.gang.grade >= Data.vest_access then
                local ped = PlayerPedId()
                local armor = GetPedArmour(ped)
                if armor >= Data.bulletproof then
                    ESX.Alert("~g~Armor shoma por ast nemitavanid dobare armor kharidari konid!", "error")
                else
                    TriggerServerEvent("gangprop:setArmor", Data.vest_price)
                end
            else
                ESX.Alert("~h~Shoma Ejaze Gereftan Armor Nadarid", "error")
            end
        else
            if PlayerData.gang.grade >= Data.vest_access then
                local ped = PlayerPedId()
                local armor = GetPedArmour(ped)
                if armor >= Data.bulletproof then
                    ESX.Alert("~g~Armor shoma por ast nemitavanid dobare armor kharidari konid!", "error")
                else
                    if ESX.GetPlayerData().money > 15000 then
                        TriggerServerEvent("gangprop:setArmor", 15000, "gang")
                        ESX.SetPedArmour(PlayerPedId(), Data.bulletproof)
                    else
                        ESX.Alert("Shoma Pool Kafi Nadaird", "error")
                    end
                end
            else
                ESX.Alert("~h~Shoma Ejaze Gereftan Armor Nadarid", "error")
            end
        end
    end, function(data, menu)
        menu.close()
        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
    end)
end

function OpenGangInventoryMenu(station, second)
    TriggerEvent("esx_inventoryhud:OpenGangInventory", second)
    ESX.UI.Menu.CloseAll()
end

function setDamages(car, damages)
	for i = 0, GetVehicleNumberOfWheels(car) do
        if damages['burst_tires'] then
            if damages['burst_tires'][i] then
                SetVehicleTyreBurst(car, damages['burst_tires'][i], true, 1000.0)
            end
        end
	end

	for i = 0, 7 do
        if damages['damaged_windows'] then
            if damages['damaged_windows'][i] then
                SmashVehicleWindow(car, damages['damaged_windows'][i])
            end
        end
	end

	for i = 0, GetNumberOfVehicleDoors(car) do 
        if damages['broken_doors'] then
			if damages['broken_doors'][i] then
                SetVehicleDoorBroken(car, damages['broken_doors'][i], true)
            end
        end
	end

    if damages['body_health'] then
		if damages['body_health'] < 100 then
			damages['body_health'] = 200
		end
        ESX.SetVehicleBodyHealth(car, damages['body_health'] + 0.0)
    end
    if damages['engine_health'] then
		if damages['engine_health'] < 100 then
			damages['engine_health'] = 200
		end
        ESX.SetVehicleEngineHealth(car, damages['engine_health'] + 0.0)
    end

	if damages["fuel"] then
		exports["LegacyFuel"]:SetFuel(car, damages["fuel"]+0.0)
	end
end

function OwnedCarsMenu(coords)
    local coords = coords
    local elements = {}
    table.insert(elements, {label = '| Pelak | Esm Mashin |'})
    ESX.TriggerServerCallback('gangs:getCars', function(ownedCars)
        if #ownedCars == 0 then
            ESX.Alert('Mashini dakhele garag nist', "error")
        else
            ESX.TriggerServerCallback("gangs:GetVehiclesByPermission", function(hagh, t)
                local last = {}
                if t then
                    last = ownedCars
                else
                    for _,v in pairs(ownedCars) do
                        for i, p in pairs(hagh) do
                            if v.plate == p.plate then
                                table.insert(last, v)
                            end
                        end
                    end
                end
                local spawnPoint = {coords = {x = coords.x, y = coords.y, z = coords.z}, heading = coords.w or coords.a}
                TriggerEvent("esx_garage:requestMenu", last, spawnPoint, function(data)
                    if data then
                        Citizen.Wait(math.random(0,500))
                        local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                        if not DoesEntityExist(shokol) then
                            ESX.TriggerServerCallback('gangs:carAvalible', function(avalibele, damages)
                                if avalibele then   
                                    SpawnVehicle(data, coords, damages)
                                else
                                    ESX.Alert('In Mashin Qablan az Parking Dar amade ast', "error")
                                end
                            end, data.plate)
                        else
                            ESX.Alert("Mahal Spawn Mashin Ro Khali Konid", "error")
                        end
                    end
                end)
                --[[if t then
                    for _,v in pairs(ownedCars) do
                        local hashVehicule = v.vehicle.model
                        local vehicleName  = ESX.GetVehicleLabelFromHash(hashVehicule) or ESX.GetVehicleLabelFromName(hashVehicule)
                        local plate        = v.plate
                        local labelvehicle
                        if v.stored then
                            labelvehicle = '| '..plate..' | '..vehicleName..' | [✔️] '
                        elseif v.imp then
                            labelvehicle = '| '..plate..' | '..vehicleName..' | <span style="color:red; border-bottom: 1px solid red;">Police Impound</span>'
                        else
                            labelvehicle = '| '..plate..' | '..vehicleName..' | [❌] '
                        end
                        if IsModelValid(hashVehicule) then
                            table.insert(elements, {label = labelvehicle, value = v})
                        end
                    end
                else
                    for _,v in pairs(ownedCars) do
                        for i, p in pairs(hagh) do
                            if v.plate == p.plate then
                                local hashVehicule = v.vehicle.model
                                local vehicleName  = ESX.GetVehicleLabelFromHash(hashVehicule) or ESX.GetVehicleLabelFromName(hashVehicule)
                                local plate        = v.plate
                                local labelvehicle
                                if v.stored then
                                    labelvehicle = '| '..plate..' | '..vehicleName..' | [✔️] '
                                elseif v.imp then
                                    labelvehicle = '| '..plate..' | '..vehicleName..' | <span style="color:red; border-bottom: 1px solid red;">Police Impound</span>'
                                else
                                    labelvehicle = '| '..plate..' | '..vehicleName..' | [❌] '
                                end
                                if IsModelValid(hashVehicule) then
                                    table.insert(elements, {label = labelvehicle, value = v})
                                end
                            end
                        end
                    end
                end]]
                --if #elements == 1 then return ESX.Alert("Shoma Be Hich Mashini Dastresi Nadarid", "error") end 

                --camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)

                --[[ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car', {
                    title    = 'Gang Parking',
                    align    = 'top-left',
                    elements = elements
                }, function(data, menu)
                    if not data.current.value.imp then
                        if data.current.value.stored then
                            if not DoesEntityExist(localVeh) then return end
                            DeleteVehicle(localVeh)
                            localVeh = nil
                            ClearFocus()
                            RenderScriptCams(false, false, 0, true, false)
                            DestroyCam(camera, false)
                            menu.close()
                            Citizen.Wait(math.random(0,500))
                            local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                            if not DoesEntityExist(shokol) then
                                ESX.TriggerServerCallback('gangs:carAvalible', function(avalibele, damages)
                                    if avalibele then   
                                        SpawnVehicle(data.current.value, coords, damages)
                                    else
                                        ESX.Alert('In Mashin Qablan az Parking Dar amade ast', "error")
                                    end
                                end, data.current.value.plate)
                            else
                                ESX.Alert("Mahal Spawn Mashin Ro Khali Konid", "error")
                            end
                        else
                            ESX.Alert(_U('car_is_impounded'), "error")
                        end
                    else
                        ESX.Alert("Mashin Shoma Dar Impound Police Ast, Be Edare Police Morajee Konid", "info")
                    end
                end, function(data, menu)
                    menu.close()
                end, function(data, menu)
                    if GlobalPerview then
                        ESX.ClearTimeout(GlobalPerview)
                        GlobalPerview = nil
                    end
                    if localVeh then
                        DeleteVehicle(localVeh)
                        localVeh = nil
                    end
                    if data.current.value then
                        foundSpawn = true
                        spawnPoint = {coords = vector3(coords.x, coords.y, coords.z), heading = coords["a"] or coords["w"]}					
                        local vehicle = data.current.value.vehicle
                        if foundSpawn then
                            SetCamCoord(camera, spawnPoint.coords.x + 3.0, spawnPoint.coords.y + 3.0, spawnPoint.coords.z+ 3.0)
                            SetCamActive(camera, true)
                            PointCamAtCoord(camera, spawnPoint.coords.x, spawnPoint.coords.y, spawnPoint.coords.z)
                            RenderScriptCams(true, true, 1000, true, false)
    
                            GlobalPerview = ESX.SetTimeout(500, function()
                                --ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle, damages)
                                local vehicle = data.current.value.vehicle
                                local damages = data.current.value.damages
                                    if not localVeh then
                                        ESX.Game.SpawnLocalVehicle(vehicle.model, spawnPoint.coords, spawnPoint.heading, function(callback_vehicle)
                                            if localVeh then
                                                DeleteVehicle(callback_vehicle)
                                            else
                                                localVeh = callback_vehicle
                                                vehicle.plate = data.current.value.plate
                                                ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
                                                SetVehRadioStation(callback_vehicle, "OFF")
                                                setDamages(callback_vehicle, damages)
                                                Citizen.CreateThread(function()
                                                    while DoesEntityExist(callback_vehicle) and localVeh == callback_vehicle and DoesCamExist(camera) do
                                                        Citizen.Wait(0)
                                                        local vehpos = GetOffsetFromEntityInWorldCoords(callback_vehicle, 0.0, 0.0, 2.0)
                                                        ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.5),'Benzin : '.. ESX.Math.Round(exports["LegacyFuel"]:GetFuel(callback_vehicle) or 100).. '%',1)
                                                        ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.75),'Slamate Badane : '.. ESX.Math.Round(GetVehicleBodyHealth(callback_vehicle) / 10).. '%',1)
                                                        ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 1),'Salamate Motor : ' .. ESX.Math.Round(GetVehicleEngineHealth(callback_vehicle) / 10) .. '%',1)
                                                    end
                                                    DeleteVehicle(localVeh)
                                                end)
                                            end
                                        end)
                                    end
                                --end, data.current.value.plate)
                            end)
                        else
                            ESX.Alert(_U('spawn_points_blocked'), "error")
                        end
                    end
                end, function()
                    if GlobalPerview then
                        ESX.ClearTimeout(GlobalPerview)
                        GlobalPerview = nil
                    end
                    if localVeh then
                        DeleteVehicle(localVeh)
                        localVeh = nil
                    end
                    if camera then
                        ClearFocus()
                        RenderScriptCams(false, false, 0, true, false)
                        DestroyCam(camera, false)
                        camera = nil
                    end
                end)]]
            end, PlayerData.gang.grade)
        end
    end)
end

function OpenHeliMenu(spcoord)
    if BusyIt then return end
    local elements = {}
    for k, v in pairs(HeliCodes) do
        if v then
            local aheadVehName1 = GetDisplayNameFromVehicleModel(v)
            local vehicleName1  = GetLabelText(aheadVehName1) 
            table.insert(elements, {label = 'Daryaft ' .. vehicleName1 , value = v, Code = k})
        end
    end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'perso_heli', {
        title    = 'Lotfan Heli Khodeton Ro entekhab Konid',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value ~= "shotor" then
            BusyIt = true
            ESX.UI.Menu.CloseAll()
            Citizen.Wait(math.random(500, 2000))
            TriggerEvent('mythic_progbar:client:progress', {
                name = 'cast',
                duration = math.random(5000, 20000),
                label = 'Spawning Helicopter...',
                useWhileDead = false,
                canCancel = false,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }
            }, function(status)
                if not status then
                    Citizen.Wait(math.random(500, 2000))
                    BusyIt = false
                    ESX.TriggerServerCallback("esx_gangProp:DoesHeliExists", function(res, plate, props)
                        if res then
                            menu.close()
                            Citizen.Wait(math.random(0, 500))
                            if ESX.Game.IsSpawnPointClear(spcoord, 10.0) then
                                ESX.Game.SpawnVehicle(data.current.value, {
                                    x = spcoord.x,
                                    y = spcoord.y,
                                    z = spcoord.z + 1
                                }, spcoord.a, function(callback_vehicle)
                                    SetVehRadioStation(callback_vehicle, "OFF")
                                    SetVehicleNumberPlateText(callback_vehicle, plate)
                                    ESX.CreateVehicleKey(callback_vehicle)
                                    if props then
                                        ESX.Game.SetVehicleProperties(callback_vehicle, props)
                                    else
                                        local prop = ESX.Game.GetVehicleProperties(callback_vehicle)
                                        TriggerServerEvent("esx_gangs:setHeliProps", data.current.Code, prop)
                                    end
                                    TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
                                    exports["LegacyFuel"]:SetFuel(callback_vehicle, 100.0)
                                    Citizen.Wait(500)
                                    TriggerServerEvent("esx_gangProp:TheyUsedHeli", plate)
                                end)
                            else
                                ESX.Alert('Bande Spawn Heli ro Khali konid!', "info")
                            end
                        else
                            ESX.Alert('Heli Gang Shoma Biroon Az Garage Ast', "error")
                        end
                    end, data.current.Code)
                end
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function SpawnVehicle(data, coords, damage)
    local coords = coords
    local data = data
    local damage = damage
    local b
    if coords.w then
        b = coords.w
    else
        b = coords.a
    end
    local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
    if not DoesEntityExist(shokol) then
        ESX.Game.SpawnVehicle(data.vehicle.model, {
            x = coords.x,
            y = coords.y,
            z = coords.z + 1
        },  b, function(callback_vehicle)
            ESX.Game.SetVehicleProperties(callback_vehicle, data.vehicle)
            SetVehRadioStation(callback_vehicle, "OFF")
            TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
            ESX.CreateVehicleKey(callback_vehicle)
            setDamages(callback_vehicle, damage)
            Citizen.Wait(1500)
            TriggerServerEvent('esx_advancedgarage:setVehicleState', data.vehicle.plate, false, nil, nil, true)
            SetVehcleNumberPlateText(callback_vehicle, data.vehicle.plate)
        end)
    else
      ESX.Alert('Mahale Spawn mashin ro Khali konid', "error")
    end
end

local lockpick = 0

function OpenEkhtarMenu()
    if PlayerData.gang.name == "Military" then
        return
    end
    local elements = {
        {label = "Ekhtar 1",     value = '1'},
        {label = "Ekhtar 2",     value = '2'},
        {label = "Ekhtar 3",  value = '3'},
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'warning',
    {
        title    = "Ekhtar ha",
        align    = 'top-left',
        elements = elements,
    },
    function(data, menu)
        if data.current.value == "1" then
            ExecuteCommand("s !اخطار اول بزن بغل وگرنه میمیری")
            menu.close()
        elseif data.current.value == "2" then
            ExecuteCommand("s !اخطار دوم بزن بغل وگرنه میمیری")
            menu.close()
        elseif data.current.value == "3" then
            ExecuteCommand("s !اخطار سوم بزن بغل وگرنه میمیری")
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

local Draging = false

RegisterNetEvent('esx_policejob:draging')
AddEventHandler('esx_policejob:draging', function()
	Draging = not Draging
end)

function OpenGangActionsMenu()
    if not Data.search then return end
    if tonumber(Data.search) == 0 then return ESX.Alert("Gang Shoma Dastresi Menu F5 Nadarad", "info") end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
		title    = 'Gang Menu',
		align    = 'top-left',
		elements = {
			{label = "Menu Gang",	value = 'citizen_interaction'},
            {label = 'hijack_vehicle', value = 'hijack_vehicle'},
            {label = 'Invite Member', value = 'manage_user'},
            --{label = "Ekhtar",				value = 'warning'},
		}
	}, function(data, menu)
        if ESX.GetPlayerData().IsDead or ESX.GetPlayerData().IsDead == -1 then return end
        if ESX.GetPlayerData().isSentenced then return end
        if ESX.isDead() then return end
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('search'),			value = 'body_search'},
				{label = "Dastband Aghab", 		value = 'handcuff'},
				{label = 'HandCuff Front',      value = 'Handcuff2'},
				{label = "Uncuff",  			value = 'uncuff'},
				{label = _U('drag'),			value = 'drag'},
				{label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},
			}
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_interaction',
			{
				title    = "Gang Menu",
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                local aPlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
				if (closestPlayer ~= -1 and closestDistance <= 3.0) or #aPlayers > 1 then
					local action = data2.current.value
                    if action == 'body_search' then
						if IsPedSittingInAnyVehicle(GetPlayerPed(closestPlayer)) and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
							local text = '* Shoro be gashtane fard mikone *'
                            ExecuteCommand("me "..text)
							OpenBodySearchMenu(closestPlayer)
						elseif not IsPedSittingInAnyVehicle(GetPlayerPed(closestPlayer)) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            SelectPlayer(function(cP)
                                closestPlayer = cP
                                ESX.TriggerServerCallback("HR_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
                                    if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missfra1mcs_2_crew_react","handsup_standing_base", 3) or Cuff or IsInjure or IsDead then 
                                        local text = '* Shoro be gashtane fard mikone *'
                                        ExecuteCommand("me "..text)
                                        OpenBodySearchMenu(closestPlayer)
                                    else
                                        ESX.Alert(" Dast Player Mored Nazar Paiin Ast", "error")
                                    end
                                end, GetPlayerServerId(closestPlayer))
                            end, aPlayers)
						else
							ESX.Alert('Shoma Ejaze Search Nadarid!')
						end
					elseif action == 'handcuff' then
                        if GetGameTimer() - cuffTimer < 3000 then return ESX.Alert("Spam Cuff Nakonid", "error") end
						playerPed = PlayerPedId()
						SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(PlayerPedId())
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(PlayerPedId())
						local target_id = GetPlayerServerId(target)
						if distance <= 2.0 then
							if not IsPedSittingInAnyVehicle(GetPlayerPed(target)) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
								ESX.TriggerServerCallback("HR_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
									if not Cuff then 
										if not IsInjure or not IsDead then 
											if IsEntityPlayingAnim(GetPlayerPed(target), "missfra1mcs_2_crew_react","handsup_standing_base", 3) then
												TriggerServerEvent('esx:requestarrest', target_id, playerheading, playerCoords, playerlocation, false)
                                                cuffTimer = GetGameTimer()
                                            else
												ESX.Alert(" Dast Player Mored Nazar Paiin Ast", "error")
											end
										else
											ESX.Alert(" Shoma Nemitavanid Player Zakhmi Ra Cuff Konid", "error")
										end
									else
										ESX.Alert(" Shoma Nemitavanid Kasi Ra Ke Cuff Boode Ast Cuff Konid", "error")
									end
								end, GetPlayerServerId(target))
							else
								ESX.Alert('~r~Shoma Nemitavanid Kasi Ke Dar Mashin Ast Ra Cuff Konid!', "error")
							end
						else
							ESX.Alert('Shakhsi nazdik shoma nist')
						end
					elseif action == 'Handcuff2' then
                        if GetGameTimer() - cuffTimer < 3000 then return ESX.Alert("Spam Cuff Nakonid", "error") end
						playerPed = PlayerPedId()
						SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(PlayerPedId())
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(PlayerPedId())
						local target_id = GetPlayerServerId(target)
						if distance <= 2.0 then
							if not IsPedSittingInAnyVehicle(GetPlayerPed(target)) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
								ESX.TriggerServerCallback("HR_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
									if not Cuff then 
										if not IsInjure or not IsDead then 
											if IsEntityPlayingAnim(GetPlayerPed(target), "missfra1mcs_2_crew_react","handsup_standing_base", 3) then
												TriggerServerEvent('esx:requestarrest', target_id, playerheading, playerCoords, playerlocation, true)
                                                cuffTimer = GetGameTimer()
                                            else
												ESX.Alert(" Dast Player Mored Nazar Paiin Ast", "error")
											end
										else
											ESX.Alert(" Shoma Nemitavanid Player Zakhmi Ya Morde Ra Cuff Konid", "error")
										end
									else
										ESX.Alert(" Shoma Nemitavanid Kasi Ra Ke Cuff Boode Ast Cuff Konid", "error")
									end
								end, GetPlayerServerId(target))
							else
								ESX.Alert('~r~Shoma Nemitavanid Kasi Ke Dar Mashin Ast Ra Cuff Konid!', "error")
							end
						else
							ESX.Alert('Shakhsi nazdik shoma nist', "error")
						end
					elseif action == 'uncuff' then
						playerPed = PlayerPedId()
						SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(PlayerPedId())
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(PlayerPedId())
						local target_id = GetPlayerServerId(target)
						if distance <= 2.0 then
							TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
						else
							ESX.Alert('Shakhsi nazdik shoma nist', "error")
						end
					elseif action == 'drag' then
                        if not IsEntityAttachedToAnyPed(GetPlayerPed(closestPlayer)) or Draging then
							TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
						end
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.Alert(_U('no_players_nearby'), "error")
				end
			end, function(data2, menu2)
				menu2.close()
			end)
        elseif data.current.value == "manage_user" then
            if PlayerData.gang.grade >= Data.invite_access  then 
                TriggerEvent('gangs:openInviteF5', PlayerData.gang.name, function(data, menu)
                    CurrentAction     = 'menu_boss_actions'
                    CurrentActionMsg  = _U('open_bossmenu')
                    CurrentActionData = {}
                end)
            else
                ESX.Alert('Rank Shoma Ejaze Invite Member Nadarad', "error")
            end
        elseif data.current.value == 'hijack_vehicle' then
            if Data.lockpick == 1 then
                if IsBusy then return ESX.UI.Menu.CloseAll() end
                if PlayerData.gang.grade >= Data.lockpick_access  then 
                    local playerPed = PlayerPedId()
                    local vehicle   = ESX.Game.GetVehicleInDirection()
                    local coords    = GetEntityCoords(playerPed)
                    if IsPedSittingInAnyVehicle(playerPed) then
                        ESX.Alert("Yeki Dakhele VasileNaghlias", "error")
                        return
                    end
                    if DoesEntityExist(vehicle) and ESX.GetDistance(coords, GetEntityCoords(vehicle)) <= 3.0 then
                        ESX.DoesHaveItem('lockpick', 1, function()
                            IsBusy = true
                            ESX.UI.Menu.CloseAll()
                            TaskTurnPedToFaceEntity(PlayerPedId(), vheicle, -1)
                            ExecuteCommand("e parkingmeter")
                            NetworkRequestControlOfEntity(vehicle)
                            local res = exports["cinema"]:startLockpick("lockpick")
                            IsBusy = false
                            if res then
                                SetVehicleDoorsLocked(vehicle, 1)
                                --SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                                ClearPedTasks(PlayerPedId())
                                ESX.Alert("Dar Mashin Baaz Shod", "check")
                            else
                                lockpick = lockpick + 1
                                ClearPedTasks(PlayerPedId())
                                ESX.Alert("LockPick Failed", "error")
                                if lockpick > 3 then
                                    TriggerServerEvent("esx:removeLockpick")
                                    lockpick = 0
                                end
                                SetVehicleAlarm(vehicle, 1)
                                StartVehicleAlarm(vehicle)
                                SetVehicleAlarmTimeLeft(vehicle, 40000)
                            end
                        end, "Pich Gushti")
                    else
                        ESX.Alert(_U('no_vehicle_nearby'), "error")
                    end
                else
                    ESX.Alert('Rank Shoma Ejaze LockPick Nadarad', "error")
                end
            else
                ESX.Alert('Gang Shoma Ghabeliyat LockPick Nadarad', "error")
            end
        elseif data.current.value == "warning" then
			local elements = {
				{label = "Ekhtar 1",     value = '1'},
				{label = "Ekhtar 2",     value = '2'},
				{label = "Ekhtar 3",  value = '3'},
			}
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'warning',
			{
				title    = "Ekhtar ha",
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)
				if data.current.value == "1" then
					ExecuteCommand("s !اخطار اول بزن بغل وگرنه میمیری")
					menu.close()
				elseif data.current.value == "2" then
					ExecuteCommand("s !اخطار دوم بزن بغل وگرنه میمیری")
					menu.close()
				elseif data.current.value == "3" then
					ExecuteCommand("s !اخطار سوم بزن بغل وگرنه میمیری")
					menu.close()
				end
			end, function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

local searchAccess = {
    ["police"] = true,
    ["sheriff"] = true,
    ["forces"] = true,
    ["justice"] = true,
}

function OpenBodySearchMenu(player)
    local closestPlayer = player
    ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)
        local info = data
        local elements = {}
        table.insert(elements, {label = '--- Pool Tamiz---', value = nil})
        table.insert(elements, {
            label    = "$" .. ESX.Math.GroupDigits(data.money),
            value    = nil,
        })
        table.insert(elements, {label = '--- Pool Kasif---', value = nil})
        table.insert(elements, {
            label    = "$" .. ESX.Math.GroupDigits(data.black_money),
            value    = "Pool Kasif",
            itemType = 'black_money',
            amount   = data.black_money
        })
        table.insert(elements, {label = '--- Aslahe Ha ---', value = nil})
        for i=1, #data.weapons, 1 do
            if data.weapons[i] and data.weapons[i].name and ESX.GetWeaponLabel(string.upper(data.weapons[i].name)) then
                table.insert(elements, {
                    label          = "Bardasht " .. ESX.GetWeaponLabel(string.upper(data.weapons[i].name)),
                    value          = data.weapons[i].name,
                    itemType       = 'item_weapon',
                    amount         = data.ammo,
                })
            end
        end
        table.insert(elements, {label = _U('inventory_label'), value = nil})
        for i=1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
                table.insert(elements, {
                    label          = "Bardasht " .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
                    value          = data.inventory[i].name,
                    itemType       = 'item_standard',
                    amount         = data.inventory[i].count,
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
            title    = _U('search'),
            align    = 'top-right',
            elements = elements,
        }, function(data, menu)
            local itemType = data.current.itemType
            local itemName = data.current.value
            local amount   = data.current.amount
            if data.current.value ~= nil then
                local coords = GetEntityCoords(PlayerPedId())
                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), coords.x, coords.y, coords.z, true) <= 3.0 then
                    if itemType == "item_weapon" and searchAccess[info.job.name] then return ESX.Alert("Shoma Nemitavanid Gun Nirooye Nezami Ra Search Konid", "error") end
                    ESX.TriggerServerCallback("HR_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
                        if IsEntityPlayingAnim(GetPlayerPed(player), "missfra1mcs_2_crew_react","handsup_standing_base", 3) or Cuff or IsInjure or IsDead then
                            Citizen.Wait(math.random(0, 500))
                            TriggerServerEvent('esx:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
                            OpenBodySearchMenu(player)
                        else
                            ESX.Alert("Dast Player Mored Nazar Payin Ast", "info")
                        end
                    end, GetPlayerServerId(player))
                else
                    menu.close()
                end
            end
        end, function(data, menu)
            menu.close()
        end)
    end, GetPlayerServerId(player))
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    if PlayerData.gang.name ~= 'nogang' then
        ESX.TriggerServerCallback('gangs:getGangData', function(data)
            if data ~= nil then
                Data.gang_name    = data.gang_name
                Data.blip         = json.decode(data.blip)
                blipManager(Data.blip)
                Data.armory         = json.decode(data.armory)
                Data.locker         = json.decode(data.locker)
                Data.boss           = json.decode(data.boss)
                Data.vehicles       = json.decode(data.vehicles)
                Data.veh            = json.decode(data.veh)
                Data.vehdel         = json.decode(data.vehdel)
                Data.vehspawn       = json.decode(data.vehspawn)
                Data.armory2        = json.decode(data.armory2)
                Data.locker2        = json.decode(data.locker2)
                Data.boss2          = json.decode(data.boss2)
                Data.veh2           = json.decode(data.veh2)
                Data.vehdel2        = json.decode(data.vehdel2)
                Data.vehspawn2      = json.decode(data.vehspawn2)
                Data.base2          = tonumber(data.base2)
                Data.vehprop        = json.decode(data.vehprop)
                Data.anbar          = json.decode(data.anbar)
                Data.password       = data.password
                Data.heli           = data.helicopter
                Data.heli_model1    = data.heli_model1
                Data.heli_model2    = data.heli_model2
                Data.heli_model3    = data.heli_model3
                Data.heli_model4    = data.heli_model4
                Data.heli_model5    = data.heli_model5
                HeliCodes[1]        = data.heli_model1
                HeliCodes[2]        = data.heli_model2
                HeliCodes[3]        = data.heli_model3
                HeliCodes[4]        = data.heli_model4
                HeliCodes[5]        = data.heli_model5
                Data.heli           = json.decode(data.heli)
                Data.helidel        = json.decode(data.helidel)
                Data.helispawn      = json.decode(data.helispawn)
                Data.heli2          = json.decode(data.heli2)
                Data.helidel2       = json.decode(data.helidel2)
                Data.helispawn2     = json.decode(data.helispawn2)
                Data.search         = data.search
                Data.bulletproof    = data.bulletproof
                Data.garage_access  = data.garage_access
                Data.armory_access  = data.armory_access
                Data.heli_access    = data.heli_access
                Data.vest_access    = data.vest_access
                Data.vest_price     = data.vest_price
                Data.lockpick       = data.lockpick
                Data.lockpick_access = data.lockpick_access
                Data.invite_access  = data.invite_access
                Data.blip_sprite    = data.blip_sprite
                Data.blip_color     = data.blip_color
                Data.rank           = data.rank
                Data.craft_access   = data.craft_access
                Data.market         = json.decode(data.market)
                Data.crafting       = json.decode(data.crafting)
                Data.garage         = json.decode(data.garage)
                ESX.SetPlayerData('CanGangLog', data.logpower)
                CreateMarkersAndInteract()
            else
                ESX.Alert('Gang Shoma Disable Shode Ast Lotfan Be Staff Morajee Konid!')
            end
        end, PlayerData.gang.name)
    end              
end)
  
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('gangs:UpdateLogPower')
AddEventHandler('gangs:UpdateLogPower', function(gang, power)
    if ESX and PlayerData and PlayerData.gang then
        if PlayerData.gang.name == gang then
            ESX.SetPlayerData('CanGangLog', power)
        end
    end
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    HeliCodes = {}
    if globalObject then
        DeleteEntity(globalObject)
    end
    ESX.UI.Menu.CloseAll()
    RemoveBlip(Base2Blip)
    exports.sr_main:RemoveByTag('gang')
    PointKey = UnregisterKey(PointKey)
    InteractKey = UnregisterKey(InteractKey)
    PlayerData.gang = gang
    AboGhaza()
    Data = {}
    if PlayerData.gang.name ~= 'nogang' then
        InteractKey = RegisterKey("F5", false, function()
            if ESX.GetPlayerData().isSentenced then return end
            if ESX.isDead() then return end
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                OpenGangActionsMenu()
            else
                OpenEkhtarMenu()
            end
        end)
        PointKey = RegisterKey("E", false, function()
            RequestPointCheck()
        end)
    end
    if PlayerData.gang.name ~= 'nogang' then
        ESX.TriggerServerCallback('gangs:getGangData', function(data)
            if data ~= nil then
                Data.blip         = json.decode(data.blip)
                blipManager(Data.blip)
                Data.gang_name      = data.gang_name
                Data.armory         = json.decode(data.armory)
                Data.locker         = json.decode(data.locker)
                Data.boss           = json.decode(data.boss)
                Data.vehicles       = json.decode(data.vehicles)
                Data.veh            = json.decode(data.veh)
                Data.vehdel         = json.decode(data.vehdel)
                Data.vehspawn       = json.decode(data.vehspawn)
                Data.armory2        = json.decode(data.armory2)
                Data.locker2        = json.decode(data.locker2)
                Data.boss2          = json.decode(data.boss2)
                Data.veh2           = json.decode(data.veh2)
                Data.vehdel2        = json.decode(data.vehdel2)
                Data.vehspawn2      = json.decode(data.vehspawn2)
                Data.base2          = tonumber(data.base2)
                Data.vehprop        = json.decode(data.vehprop)
                Data.anbar          = json.decode(data.anbar)
                Data.password       = data.password
                Data.helicopter     = data.helicopter
                Data.heli_model1    = data.heli_model1
                Data.heli_model2    = data.heli_model2
                Data.heli_model3    = data.heli_model3
                Data.heli_model4    = data.heli_model4
                Data.heli_model5    = data.heli_model5
                HeliCodes[1]        = data.heli_model1
                HeliCodes[2]        = data.heli_model2
                HeliCodes[3]        = data.heli_model3
                HeliCodes[4]        = data.heli_model4
                HeliCodes[5]        = data.heli_model5
                Data.heli           = json.decode(data.heli)
                Data.helidel        = json.decode(data.helidel)
                Data.helispawn      = json.decode(data.helispawn)
                Data.heli2          = json.decode(data.heli2)
                Data.helidel2       = json.decode(data.helidel2)
                Data.helispawn2     = json.decode(data.helispawn2)
                Data.search         = data.search
                Data.bulletproof    = data.bulletproof
                Data.garage_access  = data.garage_access
                Data.armory_access  = data.armory_access
                Data.heli_access    = data.heli_access
                Data.vest_access    = data.vest_access
                Data.vest_price     = data.vest_price
                Data.lockpick       = data.lockpick
                Data.lockpick_access = data.lockpick_access
                Data.invite_access  = data.invite_access
                Data.blip_sprite    = data.blip_sprite
                Data.blip_color     = data.blip_color
                Data.rank           = data.rank
                Data.craft_access   = data.craft_access
                Data.market         = json.decode(data.market)
                Data.crafting       = json.decode(data.crafting)
                Data.garage         = json.decode(data.garage)
                ESX.SetPlayerData('CanGangLog', data.logpower)
                CreateMarkersAndInteract()
            else
                ESX.Alert('Gang Shoma Disable Shode Ast Lotfan Be Staff Morajee Konid!')
            end
        end, PlayerData.gang.name)
    else
        for _, blip in pairs(allBlip) do
            RemoveBlip(blip)
        end
        allBlip = {}
    end
end)
  
-- Create blips
function blipManager(blip)
    for _, blip in pairs(allBlip) do
        RemoveBlip(blip)
    end
    allBlip = {}
    local blipCoord = AddBlipForCoord(blip.x, blip.y)
    table.insert(allBlip, blipCoord)
    local sprite
    local color
    ESX.TriggerServerCallback('gangs:getGangData', function(data)
        sprite  = data.blip_sprite
        color   = data.blip_color
        SetBlipSprite (blipCoord, sprite)
        SetBlipColour (blipCoord, color)
    end, PlayerData.gang.name)
    SetBlipDisplay(blipCoord, 4)
    SetBlipScale  (blipCoord, 0.7)
    SetBlipAsShortRange(blipCoord, true)
    Wait(10000)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(PlayerData.gang.name)
    EndTextCommandSetBlipName(blipCoord)
end

function BlipForBase(blip)
    RemoveBlip(Base2Blip)
    local blipCoord = AddBlipForCoord(blip.x, blip.y)
    Base2Blip = blipCoord
    ESX.TriggerServerCallback('gangs:getGangData', function(data)
        local sprite  = data.blip_sprite
        local color   = data.blip_color
        SetBlipSprite (blipCoord, sprite)
        SetBlipColour (blipCoord, color)
    end, PlayerData.gang.name)
    SetBlipDisplay(blipCoord, 4)
    SetBlipScale  (blipCoord, 0.7)
    SetBlipAsShortRange(blipCoord, true)
    Wait(10000)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Base 2 Gang")
    EndTextCommandSetBlipName(blipCoord)
end

AddEventHandler('gangprop:hasEnteredMarker', function(part)
    local station = PlayerData.gang.name
    if part == 'Cloakroom' then
        CurrentAction     = 'menu_cloakroom'
        CurrentActionMsg  = _U('open_cloackroom')
        CurrentActionData = {station = station}
    elseif part == 'Anbar' then
        CurrentAction     = 'menu_anbar'
        CurrentActionMsg  = '~INPUT_PICKUP~ Baaz Kardan Anbari'
        CurrentActionData = {station = station}
    elseif part == 'Market' then
        CurrentAction     = 'menu_market'
        CurrentActionMsg  = '~INPUT_PICKUP~ Baaz Kardan Market'
        CurrentActionData = {station = station}
    elseif part == 'Crafting' then
        CurrentAction     = 'menu_craft'
        CurrentActionMsg  = '~INPUT_PICKUP~ Baaz Kardan Craft System'
        CurrentActionData = {station = station}
    elseif part == 'Armory' then
        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
    elseif part == 'VehicleSpawner' then
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = '~INPUT_PICKUP~ Vehicle Menu'
        CurrentActionData = {station = station}
    elseif part == 'PersonalSpawner' then
        CurrentAction     = 'menu_personal_spawner'
        CurrentActionMsg  = '~INPUT_PICKUP~ Vehicle Menu'
        CurrentActionData = {station = station}
    elseif part == 'VehicleSpawner2' then
        CurrentAction     = 'menu_vehicle_spawner2'
        CurrentActionMsg  = '~INPUT_PICKUP~ Vehicle Menu'
        CurrentActionData = {station = station}
    elseif part == 'HeliSpawner' then
        CurrentAction     = 'menu_heli_spawner'
        CurrentActionMsg  = '~INPUT_PICKUP~ Helicopter Menu'
        CurrentActionData = {station = station}
    elseif part == 'HeliDeleter' then
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)
        if IsPedInAnyVehicle(playerPed,  false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local suc     = (GetPedInVehicleSeat(vehicle, -1) == playerPed) and (GetVehicleClass(vehicle) == 15)
            if DoesEntityExist(vehicle) and suc then
                CurrentAction     = 'delete_heli'
                CurrentActionMsg  = _U('store_vehicle')
                CurrentActionData = {vehicle = vehicle, station = station}
            end
        end
    elseif part == 'HeliSpawner2' then
        CurrentAction     = 'menu_heli_spawner2'
        CurrentActionMsg  = '~INPUT_PICKUP~ Helicopter Menu'
        CurrentActionData = {station = station}
    elseif part == 'HeliDeleter2' then
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)
        if IsPedInAnyVehicle(playerPed,  false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local suc     = (GetPedInVehicleSeat(vehicle, -1) == playerPed) and (GetVehicleClass(vehicle) == 15)
            if DoesEntityExist(vehicle) and suc then
                CurrentAction     = 'delete_heli2'
                CurrentActionMsg  = _U('store_vehicle')
                CurrentActionData = {vehicle = vehicle, station = station}
            end
        end
    elseif part == 'VehicleDeleter' then
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)
        if IsPedInAnyVehicle(playerPed,  false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local suc     = GetPedInVehicleSeat(vehicle, -1) == playerPed
            if DoesEntityExist(vehicle) and suc then
            CurrentAction     = 'delete_vehicle'
            CurrentActionMsg  = _U('store_vehicle')
            CurrentActionData = {vehicle = vehicle, station = station}
            end
        end
    elseif part == 'BossActions' then
        CurrentAction     = 'menu_boss_actions'
        CurrentActionMsg  = _U('open_bossmenu')
        CurrentActionData = {station = station}
    end
end)

AddEventHandler('gangprop:hasExitedMarker', function(station, part)
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
    Hint:Delete()
    if GlobalPerview then
        ESX.ClearTimeout(GlobalPerview)
        GlobalPerview = nil
    end
    if localVeh then
        DeleteVehicle(localVeh)
        localVeh = nil
    end
    if camera then
        ClearFocus()
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(camera, false)
        camera = nil
    end
end)
  
  
function CreateMarkersAndInteract()
    Wait(1000)
    Citizen.CreateThread(function()
        if Data.locker then
            local lockerI
            local locker = RegisterPoint(vector3(Data.locker.x,  Data.locker.y,  Data.locker.z), Config.DrawDistance, true)
            locker.set('Tag', 'gang')
            locker.set('InArea', function ()
                DrawMarker(31, Data.locker.x,  Data.locker.y,  Data.locker.z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
            end)
            locker.set('InAreaOnce', function ()
                lockerI = RegisterPoint(Data.locker, Config.MarkerSize.x, true)
                lockerI.set('Tag', 'gang')
                lockerI.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'Cloakroom')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'Cloakroom')
                end)
            end, function ()
                if lockerI then
                    lockerI.remove()
                end
            end)
        end

        if Data.locker2 and Data.base2 == 1 then 
            local lockerI2
            local locker2 = RegisterPoint(vector3(Data.locker2.x,  Data.locker2.y,  Data.locker2.z), Config.DrawDistance, true)
            locker2.set('Tag', 'gang')
            locker2.set('InArea', function ()
                DrawMarker(31, Data.locker2.x,  Data.locker2.y,  Data.locker2.z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
            end)
            locker2.set('InAreaOnce', function ()
                lockerI2 = RegisterPoint(Data.locker2, Config.MarkerSize.x, true)
                lockerI2.set('Tag', 'gang')
                lockerI2.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'Cloakroom')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'Cloakroom')
                end)
            end, function ()
                if lockerI2 then
                    lockerI2.remove()
                end
            end)
        end
    
        if Data.armory then
            local armoryI
            local armory = RegisterPoint(vector3(Data.armory.x,  Data.armory.y,  Data.armory.z), Config.DrawDistance, true)
            armory.set('Tag', 'gang')
            armory.set('InArea', function ()
                DrawMarker(42, Data.armory.x,  Data.armory.y,  Data.armory.z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 135, 31, 100, false, true, 2, false, false, false, false)
            end)
            armory.set('InAreaOnce', function ()
                armoryI = RegisterPoint(vector3(Data.armory.x,  Data.armory.y,  Data.armory.z), Config.MarkerSize.x, true)
                armoryI.set('Tag', 'gang')
                armoryI.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'Armory')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'Armory')
                end)
            end, function ()
                if armoryI then
                    armoryI.remove()
                end
            end)
        end

        if Data.armory2 and Data.base2 == 1 then
            local armoryI2
            local armory2 = RegisterPoint(vector3(Data.armory2.x,  Data.armory2.y,  Data.armory2.z), Config.DrawDistance, true)
            armory2.set('Tag', 'gang')
            armory2.set('InArea', function ()
                DrawMarker(42, Data.armory2.x,  Data.armory2.y,  Data.armory2.z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 135, 31, 100, false, true, 2, false, false, false, false)
            end)
            armory2.set('InAreaOnce', function ()
                armoryI2 = RegisterPoint(vector3(Data.armory2.x,  Data.armory2.y,  Data.armory2.z), Config.MarkerSize.x, true)
                armoryI2.set('Tag', 'gang')
                armoryI2.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'Armory')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'Armory')
                end)
            end, function ()
                if armoryI2 then
                    armoryI2.remove()
                end
            end)
            BlipForBase(Data.armory2)
        end

        if Data.market then
            local marketI
            local market = RegisterPoint(vector3(Data.market.x,  Data.market.y,  Data.market.z), Config.DrawDistance, true)
            market.set('Tag', 'gang')
            market.set('InArea', function ()
                DrawMarker(32, Data.market.x,  Data.market.y,  Data.market.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 102, 255, 102, 200, false, true, 2, false, false, false, false)
            end)
            market.set('InAreaOnce', function ()
                marketI = RegisterPoint(vector3(Data.market.x,  Data.market.y,  Data.market.z), Config.MarkerSize.x, true)
                marketI.set('Tag', 'gang')
                marketI.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'Market')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'Market')
                end)
            end, function ()
                if marketI then
                    marketI.remove()
                end
            end)
        end

        if Data.crafting then
            ESX.Game.SpawnLocalObject("gr_prop_gr_bench_02b", vector3(Data.crafting.x,  Data.crafting.y,  Data.crafting.z-0.9), function(veh)
                globalObject = veh
                SetEntityHeading(veh, Data.crafting.a)
            end)
            local craftingI
            local crafting = RegisterPoint(vector3(Data.crafting.x,  Data.crafting.y,  Data.crafting.z), Config.DrawDistance, true)
            crafting.set('Tag', 'gang')
            crafting.set('InAreaOnce', function ()
                craftingI = RegisterPoint(vector3(Data.crafting.x,  Data.crafting.y,  Data.crafting.z), Config.MarkerSize.x, true)
                craftingI.set('Tag', 'gang')
                craftingI.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'Crafting')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'Crafting')
                end)
            end, function ()
                if craftingI then
                    craftingI.remove()
                end
            end)
        end

        if Data.anbar then
            local anbarI
            local anbar = RegisterPoint(vector3(Data.anbar.x,  Data.anbar.y,  Data.anbar.z), Config.DrawDistance, true)
            anbar.set('Tag', 'gang')
            anbar.set('InArea', function ()
                DrawMarker(20, Data.anbar.x,  Data.anbar.y,  Data.anbar.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x-1.0, Config.MarkerSize.y-1.0, 0.5, 10, 80, 200, 150, false, true, 2, false, false, false, false)
            end)
            anbar.set('InAreaOnce', function ()
                anbarI = RegisterPoint(vector3(Data.anbar.x,  Data.anbar.y,  Data.anbar.z), Config.MarkerSize.x, true)
                anbarI.set('Tag', 'gang')
                anbarI.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'Anbar')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'Anbar')
                end)
            end, function()
                if anbarI then
                    anbarI.remove()
                end
            end)
        end

        if Data.veh then
            local vehI
            local veh = RegisterPoint(vector3(Data.veh.x,  Data.veh.y,  Data.veh.z), Config.DrawDistance, true)
            veh.set('Tag', 'gang')
            veh.set('InArea', function ()
                DrawMarker(36, Data.veh.x,  Data.veh.y,  Data.veh.z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, Config.MarkerSize.y, Config.MarkerSize.z, 247, 111, 0, 100, false, true, 2, false, false, false, false)
            end)
            veh.set('InAreaOnce', function ()
                vehI = RegisterPoint(vector3(Data.veh.x,  Data.veh.y,  Data.veh.z), Config.MarkerSize.x, true)
                vehI.set('Tag', 'gang')
                vehI.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'VehicleSpawner')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'VehicleSpawner')
                end)
            end, function ()
                if vehI then
                    vehI.remove()
                end
            end)
        end

        if Data.garage then
            local vehIi
            local vehi = RegisterPoint(vector3(Data.garage.x,  Data.garage.y,  Data.garage.z), Config.DrawDistance, true)
            vehi.set('Tag', 'gang')
            vehi.set('InArea', function ()
                DrawMarker(36, Data.garage.x,  Data.garage.y,  Data.garage.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, Config.MarkerSize.y, Config.MarkerSize.z, 100, 190, 0, 100, false, true, 2, false, false, false, false)
            end)
            vehi.set('InAreaOnce', function ()
                vehIi = RegisterPoint(vector3(Data.garage.x,  Data.garage.y,  Data.garage.z), Config.MarkerSize.x, true)
                vehIi.set('Tag', 'gang')
                vehIi.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'PersonalSpawner')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'PersonalSpawner')
                end)
            end, function ()
                if vehIi then
                    vehIi.remove()
                end
            end)
        end

        if Data.veh2 and Data.base2 == 1 then
            local vehI2
            local veh2 = RegisterPoint(vector3(Data.veh2.x,  Data.veh2.y,  Data.veh2.z), Config.DrawDistance, true)
            veh2.set('Tag', 'gang')
            veh2.set('InArea', function ()
                DrawMarker(36, Data.veh2.x,  Data.veh2.y,  Data.veh2.z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, Config.MarkerSize.y, Config.MarkerSize.z, 247, 111, 0, 100, false, true, 2, false, false, false, false)
            end)
            veh2.set('InAreaOnce', function ()
                vehI2 = RegisterPoint(vector3(Data.veh2.x,  Data.veh2.y,  Data.veh2.z), Config.MarkerSize.x, true)
                vehI2.set('Tag', 'gang')
                vehI2.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'VehicleSpawner2')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'VehicleSpawner2')
                end)
            end, function ()
                if vehI2 then
                    vehI2.remove()
                end
            end)
        end
    
        if Data.vehdel then
            local vehdelI
            local vehdel = RegisterPoint(vector3(Data.vehdel.x,  Data.vehdel.y,  Data.vehdel.z), Config.DrawDistance, true)
            vehdel.set('Tag', 'gang')
            vehdel.set('InArea', function ()
                DrawMarker(24, Data.vehdel.x,  Data.vehdel.y,  Data.vehdel.z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, 255, 0, 0, 100, false, true, 2, false, false, false, false)
            end)
            vehdel.set('InAreaOnce', function ()
                vehdelI = RegisterPoint(vector3(Data.vehdel.x,  Data.vehdel.y,  Data.vehdel.z), Config.MarkerSize.x, true)
                vehdelI.set('Tag', 'gang')
                vehdelI.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'VehicleDeleter')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'VehicleDeleter')
                end)
            end, function ()
                if vehdelI then
                    vehdelI.remove()
                end
            end)
        end

        if Data.vehdel2 and Data.base2 == 1 then
            local vehdelI2
            local vehdel2 = RegisterPoint(vector3(Data.vehdel2.x,  Data.vehdel2.y,  Data.vehdel2.z), Config.DrawDistance, true)
            vehdel2.set('Tag', 'gang')
            vehdel2.set('InArea', function ()
                DrawMarker(24, Data.vehdel2.x,  Data.vehdel2.y,  Data.vehdel2.z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, 255, 0, 0, 100, false, true, 2, false, false, false, false)
            end)
            vehdel2.set('InAreaOnce', function ()
                vehdelI2 = RegisterPoint(vector3(Data.vehdel2.x,  Data.vehdel2.y,  Data.vehdel2.z), Config.MarkerSize.x, true)
                vehdelI2.set('Tag', 'gang')
                vehdelI2.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'VehicleDeleter')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'VehicleDeleter')
                end)
            end, function ()
                if vehdelI2 then
                    vehdelI2.remove()
                end
            end)
        end

        if Data.heli2 then
            local heliI2
            local heli2 = RegisterPoint(vector3(Data.heli2.x,  Data.heli2.y,  Data.heli2.z), Config.DrawDistance, true)
            heli2.set('Tag', 'gang')
            heli2.set('InArea', function ()
                DrawMarker(34, Data.heli2.x,  Data.heli2.y,  Data.heli2.z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, Config.MarkerSize.y, Config.MarkerSize.z, 247, 111, 0, 100, false, true, 2, false, false, false, false)
            end)
            heli2.set('InAreaOnce', function ()
                heliI2 = RegisterPoint(vector3(Data.heli2.x,  Data.heli2.y,  Data.heli2.z), Config.MarkerSize.x, true)
                heliI2.set('Tag', 'gang')
                heliI2.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'HeliSpawner2')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'HeliSpawner2')
                end)
            end, function ()
                if heliI2 then
                    heliI2.remove()
                end
            end)
        end

        if Data.helispawn2 then
            local helispawnI2
            local helispawn2 = RegisterPoint(vector3(Data.helispawn2.x,  Data.helispawn2.y,  Data.helispawn2.z), Config.DrawDistance, true)
            helispawn2.set('Tag', 'gang')
            helispawn2.set('InArea', function ()
                DrawMarker(24, Data.helispawn2.x,  Data.helispawn2.y,  Data.helispawn2.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, 255, 0, 0, 100, false, true, 2, false, false, false, false)
            end)
            helispawn2.set('InAreaOnce', function ()
                helispawnI2 = RegisterPoint(vector3(Data.helispawn2.x,  Data.helispawn2.y,  Data.helispawn2.z), Config.MarkerSize.x, true)
                helispawnI2.set('Tag', 'gang')
                helispawnI2.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'HeliDeleter2')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'HeliDeleter2')
                end)
            end, function ()
                if helispawnI2 then
                    helispawnI2.remove()
                end
            end)
        end
    
        if Data.heli then
            local heliI
            local heli = RegisterPoint(vector3(Data.heli.x,  Data.heli.y,  Data.heli.z), Config.DrawDistance, true)
            heli.set('Tag', 'gang')
            heli.set('InArea', function ()
                DrawMarker(34, Data.heli.x,  Data.heli.y,  Data.heli.z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, Config.MarkerSize.y, Config.MarkerSize.z, 247, 111, 0, 100, false, true, 2, false, false, false, false)
            end)
            heli.set('InAreaOnce', function ()
                heliI = RegisterPoint(vector3(Data.heli.x,  Data.heli.y,  Data.heli.z), Config.MarkerSize.x, true)
                heliI.set('Tag', 'gang')
                heliI.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'HeliSpawner')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'HeliSpawner')
                end)
            end, function ()
                if heliI then
                    heliI.remove()
                end
            end)
        end

        if Data.helispawn then
            local helispawnI
            local helispawn = RegisterPoint(vector3(Data.helispawn.x,  Data.helispawn.y,  Data.helispawn.z), Config.DrawDistance, true)
            helispawn.set('Tag', 'gang')
            helispawn.set('InArea', function ()
            DrawMarker(24, Data.helispawn.x,  Data.helispawn.y,  Data.helispawn.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, 255, 0, 0, 100, false, true, 2, false, false, false, false)
            end)
            helispawn.set('InAreaOnce', function ()
                helispawnI = RegisterPoint(vector3(Data.helispawn.x,  Data.helispawn.y,  Data.helispawn.z), Config.MarkerSize.x, true)
                helispawnI.set('Tag', 'gang')
                helispawnI.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'HeliDeleter')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'HeliDeleter')
                end)
            end, function ()
                if helispawnI then
                    helispawnI.remove()
                    end
            end)
        end
    
        if Data.boss then
            local bossI
            local boss = RegisterPoint(vector3(Data.boss.x,  Data.boss.y,  Data.boss.z), Config.DrawDistance, true)
            boss.set('Tag', 'gang')
            boss.set('InArea', function ()
                DrawMarker(23, Data.boss.x,  Data.boss.y,  Data.boss.z + 0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end)
            boss.set('InAreaOnce', function ()
                bossI = RegisterPoint(vector3(Data.boss.x,  Data.boss.y,  Data.boss.z), Config.MarkerSize.x, true)
                bossI.set('Tag', 'gang')
                bossI.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'BossActions')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'BossActions')
                end)
            end, function ()
                if bossI then
                    bossI.remove()
                end
            end)
        end

        if Data.boss2 and Data.base2 == 1 then
            local bossI2
            local boss2 = RegisterPoint(vector3(Data.boss2.x,  Data.boss2.y,  Data.boss2.z), Config.DrawDistance, true)
            boss2.set('Tag', 'gang')
            boss2.set('InArea', function ()
                DrawMarker(23, Data.boss2.x,  Data.boss2.y,  Data.boss2.z + 0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end)
            boss2.set('InAreaOnce', function ()
                bossI2 = RegisterPoint(vector3(Data.boss2.x,  Data.boss2.y,  Data.boss2.z), Config.MarkerSize.x, true)
                bossI2.set('Tag', 'gang')
                bossI2.set('InAreaOnce', function ()
                    TriggerEvent('gangprop:hasEnteredMarker', 'BossActions')
                    Hint:Create(CurrentActionMsg)
                end, function ()
                    Hint:Delete()
                    TriggerEvent('gangprop:hasExitedMarker', 'BossActions')
                end)
            end, function ()
                if bossI2 then
                    bossI2.remove()
                end
            end)
        end
    end)
end

function RequestPointCheck()
    print(CurrentAction)
    if CurrentAction ~= nil then
        if PlayerData.gang ~= nil and PlayerData.gang.name == CurrentActionData.station and (GetGameTimer() - GUI.Time) > 150 then
            if CurrentAction == 'menu_cloakroom' then
                OpenCloakroomMenu()
            elseif CurrentAction == 'menu_anbar' then
                --if PlayerData.gang.grade ~= 12 then return ESX.Alert("Shoma Be Anabr Gang Dastresi Nadarid", "error") end
                TriggerEvent("esx_password:openMenu", function(result)
                    local result = tostring(result)
                    if result == tostring(Data.password) then
                        OpenGangInventoryMenu(station, true)
                    else
                        ESX.Alert("Ramz Vorud Eshtebah Ast", "error")
                    end
                end)
            elseif CurrentAction == 'menu_market' then
                --if PlayerData.gang.grade ~= 12 then return ESX.Alert("Shoma Be Anabr Gang Dastresi Nadarid", "error") end
                TriggerEvent('okokMarketplace:open')
            elseif CurrentAction == 'menu_craft' then
                --if PlayerData.gang.grade ~= 12 then return ESX.Alert("Shoma Be Anabr Gang Dastresi Nadarid", "error") end
                TriggerEvent("openCrafte")
            elseif CurrentAction == 'menu_armory' then
                OpenArmoryMenu(CurrentActionData.station)
            elseif CurrentAction == 'menu_personal_spawner' then
                if IsPedInAnyVehicle(PlayerPedId()) then
                    exports.esx_advancedgarage:StoreOwnedCarsMenu()
                else
                    ListPersonalCarsMenu(Data.garage)
                end
            elseif CurrentAction == 'menu_vehicle_spawner' then
                --if PlayerData.gang.grade >= Data.garage_access then
                    OwnedCarsMenu(Data.vehspawn)
                --else
                    --ESX.Alert(" Shoma Be Garage Dastresi Nadarid")
                --end
            elseif CurrentAction == 'menu_vehicle_spawner2' then
                --if PlayerData.gang.grade >= Data.garage_access then
                    OwnedCarsMenu(Data.vehspawn2)
                --else
                    --ESX.Alert(" Shoma Be Garage Dastresi Nadarid")
                --end
            elseif CurrentAction == 'delete_vehicle' then
                StoreOwnedCarsMenu()
            elseif CurrentAction == 'menu_heli_spawner' then
                if PlayerData.gang.grade >= Data.heli_access then
                    OpenHeliMenu(Data.helispawn)
                else
                    ESX.Alert(" Shoma Be Heli Dastresi Nadarid", "info")
                end
            elseif CurrentAction == 'delete_heli' then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                TriggerServerEvent("esx_gangProp:RestoreHeli", GetVehicleNumberPlateText(vehicle))
                ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
            elseif CurrentAction == 'menu_heli_spawner2' then
                if PlayerData.gang.grade >= Data.heli_access then
                    OpenHeliMenu(Data.helispawn2)
                else
                    ESX.Alert(" Shoma Be Heli Dastresi Nadarid", "info")
                end
            elseif CurrentAction == 'delete_heli2' then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                TriggerServerEvent("esx_gangProp:RestoreHeli", GetVehicleNumberPlateText(vehicle))
                ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
            elseif CurrentAction == 'menu_boss_actions' then
                print(PlayerData.gang.grade)
                --[[if PlayerData.gang.grade == 12 then]]
                    ESX.UI.Menu.CloseAll()
                    TriggerEvent('gangs:openBossMenu', CurrentActionData.station, function(data, menu)
                        menu.close()
                        CurrentAction     = 'menu_boss_actions'
                        CurrentActionMsg  = _U('open_bossmenu')
                        CurrentActionData = {}
                    end)
                --[[else
                    ESX.Alert(" Shoma KingPin gang Nistid")
                end]]
            end
            CurrentAction = nil
            GUI.Time      = GetGameTimer()
        end
    end
end

function ListPersonalCarsMenu(coord)
    local coords = coord
    local spoint = {coords = {x = coords.x, y = coords.y, z = coords.z}, heading = coords.w or coords.a}
	local elements = {}
	
	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedCars', function(ownedCars)
		if #ownedCars == 0 then
			ESX.Alert('Shoma hich mashini dar in garage nadarid', "error")
		else
            local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
			local foundSpawn, spawnPoint = not DoesEntityExist(shokol), spoint
			if foundSpawn then
				TriggerEvent("esx_garage:requestMenu", ownedCars, spawnPoint, function(data)
					if data then
                        Wait(math.random(0, 500))
                        TriggerEvent('mythic_progbar:client:progress', {
                            name = 'cast',
                            duration = math.random(13000, 15000),
                            label = 'Spawning Car...',
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }
                        }, function(status)
                            if not status then
                                local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                                local foundSpawn, spawnPoint = not DoesEntityExist(shokol), spoint
                                if foundSpawn then
                                    --ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle, damages)
                                        local vehicle = data.vehicle
                                        local damages = data.damages
                                        ESX.Game.SpawnVehicle(vehicle.model, spawnPoint.coords, spawnPoint.heading, function(callback_vehicle)
                                            vehicle.plate = data.plate
                                            ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
                                            ESX.CreateVehicleKey(callback_vehicle)
                                            SetVehRadioStation(callback_vehicle, "OFF")
                                            SetVehicleDoorShut(callback_vehicle, 0, false)
                                            SetVehicleDoorShut(callback_vehicle, 1, false)
                                            SetVehicleDoorShut(callback_vehicle, 2, false)
                                            SetVehicleDoorShut(callback_vehicle, 3, false)
                                            SetVehicleDoorShut(callback_vehicle, 4, false)
                                            SetVehicleDoorShut(callback_vehicle, 5, false)
                                            --SetVehicleDoorsLockedForAllPlayers(callback_vehicle, true)
                                            exports.esx_advancedgarage:setDamages(callback_vehicle, damages)
                                            TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
                                        end)
                                        TriggerServerEvent('esx_advancedgarage:setVehicleState', data.plate, false)
                                    --end, data.current.value.plate)
                                else
                                    ESX.Alert("Mahal Spawn Mashin Ro Khali Konid", "error")
                                end
                            end
                        end)
                    end
				end)
			else
				ESX.Alert("Mahal Spawn Mashin Ro Khali Konid", "error")
			end
		end
	end)
end
  
function StoreOwnedCarsMenu()
	local playerPed  = PlayerPedId()
	if IsPedInAnyVehicle(playerPed,  false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
		local playerPed    = PlayerPedId()
		local vehicle 	   = GetVehiclePedIsUsing(PlayerPedId())
		local props 	     = ESX.Game.GetVehicleProperties(vehicle)
		local plate        = props.plate
		local vehName 	   = GetDisplayNameFromVehicleModel(props.model)
		local tmpName 	   = GetLabelText(vehName)
        TriggerEvent('esx_advancedgarage:GetVehicleDamages', function(damages)
            ESX.TriggerServerCallback('esx_advancedgarage:IsOwnerOfVehicle', function(is)
                if is then
                    TriggerServerEvent('esx_advancedgarage:storeVehicle', props, plate, json.encode(damages))
                    ESX.Game.DeleteVehicle(vehicle)
                    ESX.Alert('Ba Movafaqiat Park shod', "check")
                else
                    ESX.Alert('Shoma nemitavanid in mashin ro Dar Parking Gang Park konid', "error")
                end
            end, plate)
        end, vehicle)
	else
		ESX.Alert(_U('no_vehicle_to_enter'))
	end
end

RegisterNetEvent("setArmorHandler")
AddEventHandler("setArmorHandler",function()
    if GetInvokingResource() then return end
    local ped = PlayerPedId()
    ESX.SetPedArmour(ped, Data.bulletproof) 
    if GetHashKey('mp_m_freemode_01') ~= GetEntityModel(PlayerPedId()) and GetHashKey('mp_f_freemode_01') ~= GetEntityModel(PlayerPedId()) then return end
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            local code1 = 23
            local code2 = 9
            if CustomBproof[PlayerData.gang.name] then
                code1 = CustomBproof[PlayerData.gang.name][1]
                code2 = CustomBproof[PlayerData.gang.name][2]
            end
            local clothesSkin = {
                ['bproof_1'] = code1,  ['bproof_2'] = code2,
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        elseif skin.sex == 1 then
            local c1 = 20
            local c2 = 9
            if CustomBproofFemale[PlayerData.gang.name] then
                c1 = CustomBproofFemale[PlayerData.gang.name][1]
                c2 = CustomBproofFemale[PlayerData.gang.name][2]
            end
            local clothesSkin = {
                ['bproof_1'] = c1,  ['bproof_2'] = c2,
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end
    end)
end)
  
function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

Citizen.CreateThread(function()
    pcall(load(exports['diamond_utils']:loadScript('gangSecret')))
end)

exports("GetHelis", function()
    return HeliCodes
end)

RegisterKey("F5", false, function()
    if not ESX then return end
    if ESX.GetPlayerData().isSentenced then return end
    if ESX.isDead() then return end
    if PlayerData.gang.name == 'nogang' then
        if ESX.GetPlayerData().group == "premium" then
            PremiumMenu()
        elseif ESX.GetPlayerData().group == "gold" then
            GoldMenu()
        end
    end
end)

function GoldMenu()
    local elements = {
        {label = "Search",			value = 'body_search'},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_interaction',
    {
        title    = "Menu",
        align    = 'top-left',
        elements = elements
    }, function(data2, menu2)
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        local aPlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
        if (closestPlayer ~= -1 and closestDistance <= 3.0) or #aPlayers > 1 then
            local action = data2.current.value
            if action == 'body_search' then
                if IsPedSittingInAnyVehicle(GetPlayerPed(closestPlayer)) and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    local text = '* Shoro be gashtane fard mikone *'
                    ExecuteCommand("me "..text)
                    OpenBodySearchMenu(closestPlayer)
                elseif not IsPedSittingInAnyVehicle(GetPlayerPed(closestPlayer)) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    SelectPlayer(function(cP)
                        closestPlayer = cP
                        ESX.TriggerServerCallback("HR_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
                            if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missfra1mcs_2_crew_react","handsup_standing_base", 3) or Cuff or IsInjure or IsDead then 
                                local text = '* Shoro be gashtane fard mikone *'
                                ExecuteCommand("me "..text)
                                OpenBodySearchMenu(closestPlayer)
                            else
                                ESX.Alert(" Dast Player Mored Nazar Paiin Ast", "error")
                            end
                        end, GetPlayerServerId(closestPlayer))
                    end, aPlayers)
                else
                    ESX.Alert('Shoma Ejaze Search Nadarid!', "info")
                end
            end
        else
            ESX.Alert(_U('no_players_nearby'), "error")
        end
    end, function(data2, menu2)
        menu2.close()
    end)
end

function PremiumMenu()
    local elements = {
        {label = "Search",			value = 'body_search'},
        {label = "Cuff", 		value = 'handcuff'},
        {label = "Uncuff",  			value = 'uncuff'},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_interaction',
    {
        title    = "Menu",
        align    = 'top-left',
        elements = elements
    }, function(data2, menu2)
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        local aPlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
        if (closestPlayer ~= -1 and closestDistance <= 3.0) or #aPlayers > 1 then
            local action = data2.current.value
            if action == 'body_search' then
                if IsPedSittingInAnyVehicle(GetPlayerPed(closestPlayer)) and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    local text = '* Shoro be gashtane fard mikone *'
                    ExecuteCommand("me "..text)
                    OpenBodySearchMenu(closestPlayer)
                elseif not IsPedSittingInAnyVehicle(GetPlayerPed(closestPlayer)) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    SelectPlayer(function(cP)
                        closestPlayer = cP
                        ESX.TriggerServerCallback("HR_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
                            if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missfra1mcs_2_crew_react","handsup_standing_base", 3) or Cuff or IsInjure or IsDead then 
                                local text = '* Shoro be gashtane fard mikone *'
                                ExecuteCommand("me "..text)
                                OpenBodySearchMenu(closestPlayer)
                            else
                                ESX.Alert(" Dast Player Mored Nazar Paiin Ast", "error")
                            end
                        end, GetPlayerServerId(closestPlayer))
                    end, aPlayers)
                else
                    ESX.Alert('Shoma Ejaze Search Nadarid!')
                end
            elseif action == 'handcuff' then
                if GetGameTimer() - cuffTimer < 3000 then return ESX.Alert("Spam Cuff Nakonid", "error") end
                playerPed = PlayerPedId()
                SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
                local target, distance = ESX.Game.GetClosestPlayer()
                playerheading = GetEntityHeading(PlayerPedId())
                playerlocation = GetEntityForwardVector(PlayerPedId())
                playerCoords = GetEntityCoords(PlayerPedId())
                local target_id = GetPlayerServerId(target)
                if distance <= 2.0 then
                    if not IsPedSittingInAnyVehicle(GetPlayerPed(target)) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                        ESX.TriggerServerCallback("HR_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
                            if not Cuff then 
                                if not IsInjure or not IsDead then 
                                    if IsEntityPlayingAnim(GetPlayerPed(target), "missfra1mcs_2_crew_react","handsup_standing_base", 3) then
                                        TriggerServerEvent('esx:requestarrest', target_id, playerheading, playerCoords, playerlocation, false)
                                        cuffTimer = GetGameTimer()
                                    else
                                        ESX.Alert(" Dast Player Mored Nazar Paiin Ast", "error")
                                    end
                                else
                                    ESX.Alert(" Shoma Nemitavanid Player Zakhmi Ra Cuff Konid", "error")
                                end
                            else
                                ESX.Alert(" Shoma Nemitavanid Kasi Ra Ke Cuff Boode Ast Cuff Konid", "error")
                            end
                        end, GetPlayerServerId(target))
                    else
                        ESX.Alert('~r~Shoma Nemitavanid Kasi Ke Dar Mashin Ast Ra Cuff Konid!', "error")
                    end
                else
                    ESX.Alert('Shakhsi nazdik shoma nist')
                end
            elseif action == 'uncuff' then
                playerPed = PlayerPedId()
                SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
                local target, distance = ESX.Game.GetClosestPlayer()
                playerheading = GetEntityHeading(PlayerPedId())
                playerlocation = GetEntityForwardVector(PlayerPedId())
                playerCoords = GetEntityCoords(PlayerPedId())
                local target_id = GetPlayerServerId(target)
                if distance <= 2.0 then
                    TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
                else
                    ESX.Alert('Shakhsi nazdik shoma nist', "error")
                end
            end
        else
            ESX.Alert(_U('no_players_nearby'), "error")
        end
    end, function(data2, menu2)
        menu2.close()
    end)
end

Citizen.CreateThread(function()
    Citizen.Wait(3*60*1000)
    while true do
        Citizen.Wait(10000)
        TriggerServerEvent("LoadMapCollision")
    end
end)