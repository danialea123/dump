---@diagnostic disable: missing-parameter, undefined-field
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(9)
    end
end)

local inRadialMenu = false

function setupSubItems()
    local new = ESX.CopyTable(Config.MenuItems)
    if IsNextWeatherType('XMAS') then 
        table.insert(new, 
            {
                id = 'pussy',
                title = 'Snow & Snowman',
                icon = 'snowman',
                items = {
                    {
                        id = 'snowman',
                        title = 'Create SnowMan',
                        icon = 'snowman',
                        type = 'client',
                        event = 'snowman:create',
                        shouldClose = true,
                    },
                    {
                        id = 'snow',
                        title = 'Pickup Snow',
                        icon = 'snowflake',
                        type = 'client',
                        event = 'snow:pickup',
                        shouldClose = true,
                    } 
                }
            }
        )
    end
    return new
end

function openRadial(bool)    
    local config = setupSubItems()

    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        radial = bool,
        items = config
    })
    inRadialMenu = bool
end

function closeRadial(bool)    
    SetNuiFocus(false, false)
    inRadialMenu = bool
end

function getNearestVeh()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

local delay = 0

--[[RegisterKey("END", function()
    if GetGameTimer() - delay > 2500 then
        if not inRadialMenu then
            openRadial(true)
            SetCursorLocation(0.5, 0.5)
            delay = GetGameTimer()
        end
    end
end, false)]]

AddEventHandler("fastMenu", function()
    openRadial(true)
    SetCursorLocation(0.5, 0.5)
end)

RegisterNUICallback('closeRadial', function()
    closeRadial(false)
end)

local de = {
    ["snow:pickup"] = true,
    ["snowman:create"] = true,
    ["esx_phone:CopyNumber"] = true,
    ["copynearplate"] = true,
    ["copyhex"] = true,
    ["togglehouseblip"] = true,
    ["CopyCurrentWeaponSerial"] = true,
    ["openStyle"] = true,
    ["esx_creport:OpenUI"] = true,
    ["radio:sendAlert"] = true,
    ["radio:ShowGPS"] = true,
}

RegisterNUICallback('selectItem', function(data)
    local itemData = data.itemData
    if not de[itemData.event] then return end
    if itemData.type == 'client' then
        TriggerEvent(itemData.event, itemData)
    end
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

AddEventHandler('copynearplate',function()
    local veh , distance = ESX.Game.GetClosestVehicle()
    if veh ~= -1 and distance <= 10 then
        exports['esx_shoprobbery']:SetClipboard(GetVehicleNumberPlateText(veh))
        ESX.Alert('Copy shod!', 'check')
    else
        ESX.Alert('Mashini dar kenar shoma nist!', 'error')
    end
end)

AddEventHandler('esx_phone:CopyNumber',function()
    ESX.TriggerServerCallback('gksphone:namenumber', function(Races)
        exports['esx_shoprobbery']:SetClipboard(Races[1].phone_number)
        ESX.Alert('Copy shod!', 'check')
    end)
end)

AddEventHandler("CopyCurrentWeaponSerial", function()
    ESX.TriggerServerCallback("esx:getWeaponSerial", function(exist, serial, info)
        if exist then 
            exports['esx_shoprobbery']:SetClipboard(serial)
        end
        ESX.Alert(info, "info")
    end)
end)

AddEventHandler('copyhex',function()
    exports['esx_shoprobbery']:SetClipboard(ESX.GetPlayerData().identifier)
    ESX.Alert('Copy shod!', 'check')
end)

AddEventHandler('togglehouseblip',function()
    ExecuteCommand('showhouses')
end)

AddEventHandler("snow:pickup", function()
    TriggerEvent("onKeyUP", "q")
end)

local Pos = {
    [1] = {
        coord = vector3(213.982422, -902.307678, 30.678345),
        radius = 30.0,
    },
    [2] = {
        coord = vector3(187.859344, -958.760437, 30.038086),
        radius = 30.0,
    }
}

AddEventHandler("snowman:create", function()
    if GetAmmoInPedWeapon(PlayerPedId(), GetHashKey("WEAPON_SNOWBALL")) > 9 then
        local Coord = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Pos) do
            if #(Coord - v.coord) <= v.radius or ESX.GetPlayerData().aduty then
                SetPedAmmo(PlayerPedId(), GetHashKey("WEAPON_SNOWBALL"), 0)
                SpawnSnowMan()
                return
            end
        end
        ESX.Alert("Shoma Faghat Dar Markaz Shahr Mitavanid Adam Barfi Dorost Konid", "error")
    else
        ESX.Alert("Baraye Saakht Adam Barfi Bayad 10 Ta Barf Dashte Bashid", "error")
    end
end)

local function ReqModel(model)
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(1)
        end
    end
end

local function ReqAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function SpawnSnowMan()
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_SNOWBALL"), true)
    exports.essentialmode:DisableControl(true)
	TriggerEvent("dpemote:enable", false)
	TriggerEvent("dpclothingAbuse", true)
	ESX.SetPlayerData("isSentenced", true)
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    ReqAnim("amb@prop_human_bum_bin@idle_b")
    TaskPlayAnim(myPed, "amb@prop_human_bum_bin@idle_b", "idle_d", 3.0, 3.0, -1, 50, 0, false, false, false)
    ReqModel(GetHashKey('prop_prlg_snowpile'))
    Citizen.Wait(2000)
    local myOffset = GetOffsetFromEntityInWorldCoords(myPed, 0, 1.0, -1.2)
    local myHeading = GetEntityHeading(myPed)
    local createdSnowman = CreateObject(GetHashKey('prop_prlg_snowpile'), myOffset.x, myOffset.y, myOffset.z, true, true)
    FreezeEntityPosition(createdSnowman, true)
    Citizen.Wait(100)
    ClearPedTasks(PlayerPedId())
    exports.essentialmode:DisableControl(false)
	TriggerEvent("dpemote:enable", true)
	TriggerEvent("dpclothingAbuse", false)
	ESX.SetPlayerData("isSentenced", false)
end

local SUN = {}
local curGun = `weapon_unarmed`
local changeCool = false
local waitForSwitch = 15

Citizen.CreateThreadNow(function()
    while true do
		SUN.PlayerPedId = PlayerPedId()
		SUN.CurrentWeaponModel = GetSelectedPedWeapon(SUN.PlayerPedId)
       --[[if curGun ~= SUN.CurrentWeaponModel then
            changeCool = true
            Citizen.SetTimeout(2000, function()
                changeCool = false
            end)
            while changeCool == true do
                Citizen.Wait(2)
                disableFiring()
            end
        end]]
        curGun = SUN.CurrentWeaponModel
		Citizen.Wait(waitForSwitch)
    end
end)

function disableFiring()
	DisablePlayerFiring(SUN.PlayerId,true)
	DisableControlAction(0,24,true) -- disable attack
	--DisableControlAction(0,47,true) -- disable weapon
	DisableControlAction(0,58,true) -- disable weapon
	DisableControlAction(0,263,true) -- disable melee
	DisableControlAction(0,264,true) -- disable melee
	DisableControlAction(0,257,true) -- disable melee
	DisableControlAction(0,140,true) -- disable melee
	DisableControlAction(0,141,true) -- disable melee
	DisableControlAction(0,142,true) -- disable melee
	DisableControlAction(0,143,true) -- disable melee
	DisableControlAction(0, 45, true)
	DisableControlAction(0, 69, true) -- Melee Attack 1
	DisableControlAction(0, 70, true)
	DisableControlAction(0, 92, true)
end

local PB = false 

RegisterNetEvent('PaintBall:Start')
AddEventHandler('PaintBall:Start', function()
    if GetInvokingResource() then return end
    PB = true
end)

RegisterNetEvent('PaintBall:End')
AddEventHandler('PaintBall:End', function()
    if GetInvokingResource() then return end
    PB = false
end)

RegisterNetEvent('esx:LeaveGangWar')
AddEventHandler('esx:LeaveGangWar', function()
    if GetInvokingResource() then return end
    PB = false
end)

RegisterNetEvent("esx:joinGangWar")
AddEventHandler("esx:joinGangWar", function()
    if GetInvokingResource() then return end
    PB = true
end)

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	if GetInvokingResource() then return end
    if Bucket == 0 then
        PB = false
    else
        PB = true
    end
end)

local citydisable = false
local citydisable2 = false

local list = {
    [`weapon_unarmed`] = true,
    [`weapon_stungun`] = true,
    [`weapon_snowball`] = true,
    [`weapon_bat`] = true,
    [`weapon_nightstick`] = true,
    [`weapon_knife`] = true,
    [`weapon_hatchet`] = true,
    [`weapon_switchblade`] = true,
    [`weapon_flashlight`] = true,
    [`weapon_knuckle`] = true,
    [`weapon_dagger`] = true,
    [`weapon_hazardcan`] = true,
    [`weapon_fireextinguisher`] = true,
    [`weapon_petrolcan`] = true,
    [`weapon_battleaxe`] = true,
    [`weapon_wrench`] = true,
    [`weapon_machete`] = true,
    [`weapon_golfclub`] = true,
    [`weapon_hammer`] = true,
    [`weapon_bottle`] = true,
    [`weapon_crowbar`] = true,
}

Citizen.CreateThread(function()
	while not ESX do Citizen.Wait(1000) end
	local whiteCoords = {
        vector3(313.77,-278.99, 54.0), 
        vector3(29.55,-1343.7,29.5),
    }
    local whiteCoords2 = {
        vector4(-52.54,-1756.18,29.42, 20),
        vector4(-1225.84,-903.71,12.34, 20),
        vector4(-1489.49,-382.1,40.16, 20),
        vector4(1137.34,-981.64,46.42, 20),
        vector4(377.5,325.57,103.57, 20),
        vector4(1159.32,-324.82,69.21, 20),
        vector4(-1068.74,-247.1,39.73, 50),
        vector4(249.46,217.75,106.29, 50),
        vector4(-1213.87,-329.32,37.79, 20),
        vector4(-350.31,-47.65,49.05, 20),
        vector4(74.66,-1579.59,29.62, 35),
        vector4(836.82,-1976.69,29.34, 35),
        vector4(-632.52,-238.39,38.07, 35),
        vector4(-769.1,250.31,75.64, 35),
        vector4(-1303.96,-823.7,17.15, 35),
        vector4(-712.56,-914.99,19.22, 20),
        vector4(882.22,-2276.79,32.44, 30),
        vector4(831.71,-2027.42,29.33, 50),
        vector4(-1041.57,-2146.67,13.59, 50),
        vector4(570.43,-3126.36,6.07, 100),
    }
	local wait = 250
	local unarmed = `weapon_unarmed`
	local taze = `weapon_stungun`
    local knife = `weapon_knife`
	local loc1 = vector3(-34.99, -804.57, 27.8)
	local loc2 = vector3(-283.5,-1786.0,3.44)
    local cache = false
	local run = false
	while true do         
		local coord = GetEntityCoords(PlayerPedId())
		local distance = #(coord - loc1)
		local distance2 = #(coord - loc2)
		if distance < 660.0 then
			citydisable = true
			citydisable2 = false
			for k, v in pairs(whiteCoords) do
				if #(coord - v) <= 10.0 then
					citydisable = false
					break
				end
			end
            if PB then
                citydisable = false
                citydisable2 = false
            end
		elseif distance2 < 2900.0 then
			local weapon = SUN.CurrentWeaponModel
            if PB then
                citydisable = false
                citydisable2 = false
            elseif IsPedInAnyVehicle(PlayerPedId()) then
                citydisable2 = true
                citydisable = false
            else
                local check = false
                for k, v in pairs(whiteCoords2) do
                    if #(coord - vector3(v.x, v.y, v.z)) <= v.w then
                        check = true
                        break
                    end
                end

                if check then
                    citydisable = false
                    citydisable2 = false
                else
                    local comp = IsPedCurrentWeaponSilenced(PlayerPedId())
                    if comp then
                        citydisable = false
                        citydisable2 = false
                    else
                        citydisable2 = true
                        citydisable = false
                    end
                end
			end		
		else
			citydisable = false
			citydisable2 = false
		end
        if SUN.CurrentWeaponModel == taze or SUN.CurrentWeaponModel == unarmed or SUN.CurrentWeaponModel == knife then
			citydisable = false
			citydisable2 = false
        end
		if citydisable2 or citydisable then
			if not run then
				run = true
                TriggerServerEvent("esx:polyZone:BoxChecks", true)
				Citizen.CreateThread(function()
					while citydisable2 or citydisable do
						Citizen.Wait(0)
						if not list[SUN.CurrentWeaponModel] or citydisable then
							disableFiring()
						end
					end
					run = false
                    TriggerServerEvent("esx:polyZone:BoxChecks", false)
				end)
			end
		end
		Citizen.Wait(wait)
	end
end)

local holdingRight = false
AddEventHandler("onKeyDown", function(key)
	if key == "mouse_right" then
		holdingRight = true
	end
end)

AddEventHandler("onKeyUP", function(key)
	if key == "mouse_right" then
		holdingRight = false
	end
end)

AddEventHandler('onKeyDown',function(key)
    if key == "mouse_left" then
        if (citydisable) and not list[SUN.CurrentWeaponModel] then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then return end
            if IsPedInAnyVehicle(PlayerPedId()) then
                if holdingRight then
                    ESX.ShowNotification('تیراندازی از داخل ماشین در این منطقه ممنوع است')
                end
            else
                ESX.ShowNotification('تیر اندازی در این منطقه ممنوع است')
            end
        end
		if (citydisable2) and not list[SUN.CurrentWeaponModel] then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then return end
            if IsPedInAnyVehicle(PlayerPedId()) then
                if holdingRight then
                    ESX.ShowNotification('تیراندازی از داخل ماشین در این منطقه ممنوع است')
                end
            else
                ESX.ShowNotification('تیراندازی فقط با سایلنسر امکان پذیر است')
            end
        end
    end
end)