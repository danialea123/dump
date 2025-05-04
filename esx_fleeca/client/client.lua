---@diagnostic disable: undefined-field, undefined-global, lowercase-global, param-type-mismatch
ESX = nil
local PlayerData = {}
local objects = {}
local RobStarted = false
ShopNPC = -1
currentRob = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function() while true do local enabled = false Citizen.Wait(1) if disableinput then enabled = true DisableControl() end if not enabled then Citizen.Wait(500) end end end)
function DrawText3D(x, y, z, text) local onScreen,x,y = World3dToScreen2d(x, y, z) local factor = #text / 370 if onScreen then SetTextScale(0.35, 0.35) SetTextFont(4) SetTextProportional(1) SetTextColour(255, 255, 255, 215) SetTextEntry("STRING") SetTextCentre(1) AddTextComponentString(text) DrawText(x,y) DrawRect(x,y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 120) end end
function DisableControl() DisableControlAction(0, 73, false) DisableControlAction(0, 24, true) DisableControlAction(0, 257, true) DisableControlAction(0, 25, true) DisableControlAction(0, 263, true) DisableControlAction(0, 32, true) DisableControlAction(0, 34, true) DisableControlAction(0, 31, true) DisableControlAction(0, 30, true) DisableControlAction(0, 45, true) DisableControlAction(0, 22, true) DisableControlAction(0, 44, true) DisableControlAction(0, 37, true) DisableControlAction(0, 23, true) DisableControlAction(0, 288, true) DisableControlAction(0, 289, true) DisableControlAction(0, 170, true) DisableControlAction(0, 167, true) DisableControlAction(0, 73, true) DisableControlAction(2, 199, true) DisableControlAction(0, 47, true) DisableControlAction(0, 264, true) DisableControlAction(0, 257, true) DisableControlAction(0, 140, true) DisableControlAction(0, 141, true) DisableControlAction(0, 142, true) DisableControlAction(0, 143, true) end
function ShowTimer() SetTextFont(0) SetTextProportional(0) SetTextScale(0.42, 0.42) SetTextDropShadow(0, 0, 0, 0,255) SetTextEdge(1, 0, 0, 0, 255) SetTextEntry("STRING") AddTextComponentString("~r~"..UTK.timer.."~w~") DrawText(0.682, 0.96) end

function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function CreatePoint(coord, InArea, InInteract, KeyPress, Tag, override)
	override = override or {}
	local Key = {}
	local Interact
	local Point = RegisterPoint(coord, override.Point or 15, true)
	Point.set('Tag', Tag)
	if InArea then
		Point.set('InArea', InArea)
	end
	Point.set('InAreaOnce', function ()
		Interact = RegisterPoint(coord, override.Interact or 0.4, true)
		Interact.set('Tag', Tag)
		if InInteract then
			Interact.set('InArea', InInteract)
		end
		Interact.set('InAreaOnce', function ()
			local function KeyRelase()
				Key = UnregisterKey(Key)
				KeyPress(function ()
					if Point then Point.remove() end
					if Interact then Interact.remove() end
					Key = UnregisterKey(Key)
				end, function(toggle)
					Key = RegisterKey('E', false, KeyRelase)
				end)
			end
			Key = RegisterKey('E', false, KeyRelase)
		end, function ()
			Key = UnregisterKey(Key)
		end)
		Interact.set('OnRemove', function ()
			Key = UnregisterKey(Key)
		end)
	end, function ()
		if Interact then
			Interact.remove()
			Key = UnregisterKey(Key)
		end
	end)
end

function StartPickingMoney()
    disableinput = true
    local ped = PlayerPedId()
    local model = "hei_prop_heist_cash_pile"

    local Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)
    local CashAppear = function()
		exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
		ESX.SetPlayerData("isSentenced", true)
	    local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Citizen.Wait(100)
        end
	    local grabobj = CreateObject(grabmodel, pedCoords, true)

	    FreezeEntityPosition(grabobj, true)
	    SetEntityInvincible(grabobj, true)
	    SetEntityNoCollisionEntity(grabobj, ped)
	    SetEntityVisible(grabobj, false, false)
	    AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	    local startedGrabbing = GetGameTimer()
	    Citizen.CreateThread(function()
			ESX.TriggerServerCallback("sr_fleeca:rewardCash", function()end, currentRob)
		    while GetGameTimer() - startedGrabbing < 37000 do
			    Citizen.Wait(1)
			    DisableControlAction(0, 73, true)
			    if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
				    if not IsEntityVisible(grabobj) then
					    SetEntityVisible(grabobj, true, false)
				    end
			    end
			    if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
				    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
				    end
			    end
		    end
			exports.essentialmode:DisableControl(false)
			TriggerEvent("dpemote:enable", true)
			TriggerEvent("dpclothingAbuse", false)
			ESX.SetPlayerData("isSentenced", false)
		    DeleteObject(grabobj)
	    end)
    end
	local trollyobj = Trolley
    local emptyobj = GetHashKey("hei_prop_hei_cash_trolly_03")

	if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return
    end

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)

    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
        Citizen.Wait(100)
    end

	while not NetworkHasControlOfEntity(trollyobj) do
		Citizen.Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end

	local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
	local comp, texture = GetPedDrawableVariation(ped, 5), GetPedTextureVariation(ped, 5)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(scene1)
	Citizen.Wait(1500)
	CashAppear()
	local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene2)
	Citizen.Wait(37000)
	local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene3)
    local NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, - 0.985), true)
	table.insert(objects, NewTrolley)
    SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))
	while not NetworkHasControlOfEntity(trollyobj) do
		Citizen.Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	DeleteObject(trollyobj)
    PlaceObjectOnGroundProperly(NewTrolley)
	Citizen.Wait(1800)
	DeleteObject(bag)
    SetPedComponentVariation(ped, 5, comp, texture, 2)
	RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
	SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
    disableinput = false
end

function PutCartIn(coord, heading, cb)
	disableinput = true
    RequestModel("p_ld_id_card_01")
    while not HasModelLoaded("p_ld_id_card_01") do
        Citizen.Wait(1)
    end
    local ped = PlayerPedId()

    ESX.SetEntityCoords(ped, coord.x, coord.y, coord.z -1 )
    SetEntityHeading(ped, heading)
    local IdProp = CreateObject(GetHashKey("p_ld_id_card_01"), GetEntityCoords(PlayerPedId()), true, 1, 0)
    local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)

    AttachEntityToEntity(IdProp, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, true)
	exports.rprogress:Custom({
		Duration = 2000,
		Label = "Using Malicious Cart ...",
		Animation = {
			scenario = "", -- https://pastebin.com/6mrYTdQv
			animationDictionary = "", -- https://alexguirre.github.io/animations-list/
		},
		DisableControls = {
			Mouse = false,
			Player = true,
			Vehicle = true
		}
	})
    Citizen.Wait(1500)
    DetachEntity(IdProp, false, false)
	DeleteEntity(IdProp)
    Citizen.Wait(500)
    ClearPedTasksImmediately(ped)
    disableinput = false
	cb()
end

function StartHack(count, cb)
	TriggerEvent("utk_fingerprint:Start", count, 2, 2, function(outcome)
		if outcome then
			ESX.Alert('~g~Well Done, You Hacked System')
		end
		cb(outcome)
		-- cb(true)
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		local Object, Distance = ESX.Game.GetClosestObject("v_ilev_gb_teldr", GetEntityCoords(PlayerPedId()))
		local PObject, Dis = ESX.Game.GetClosestObject("hei_prop_heist_sec_door", GetEntityCoords(PlayerPedId()))
		local DObject, Diz = ESX.Game.GetClosestObject("v_ilev_gb_vauldr", GetEntityCoords(PlayerPedId()))
		if Object then
			if Distance < 50 then
				ESX.Game.DeleteObject(Object)
			end
		end
		if PObject then
			if Dis < 50 then
				ESX.Game.DeleteObject(PObject)
			end
		end
		if DObject then
			if Diz < 50 then
				ESX.Game.DeleteObject(DObject)
			end
		end
	end
end)

blipRobbery = {}

RegisterNetEvent('esx_fleeca:setblip')
AddEventHandler('esx_fleeca:setblip', function(k)
	local k = k
    blipRobbery[k] = AddBlipForCoord(Config.Banks[k].coord)
    SetBlipSprite(blipRobbery[k] , 161)
    SetBlipScale(blipRobbery[k] , 2.0)
    SetBlipColour(blipRobbery[k], 3)
    PulseBlip(blipRobbery[k])
	SetTimeout(10*60*1000, function()
		RemoveBlip(blipRobbery[k])
	end)
end)

RegisterNetEvent('esx_fleeca:killblip')
AddEventHandler('esx_fleeca:killblip', function(data)
	if blipRobbery[data] then
    	RemoveBlip(blipRobbery[data])
	end
end)

function SpawnTrolleys(data, cb)
    RequestModel("hei_prop_hei_cash_trolly_01")
    while not HasModelLoaded("hei_prop_hei_cash_trolly_01") do
        Citizen.Wait(1)
    end
	local Polets = {}
	for k,v in pairs(data) do
		local obj = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), v.c.x, v.c.y, v.c.z - 1, 1, 1, 1)
		table.insert(Polets, ObjToNet(obj))
		SetEntityHeading(obj, GetEntityHeading(obj) + v.h)
	end
	TriggerServerEvent('sr_fleeca:GivePoletsObject', Polets)
	cb()
end

function UnlockDoor(fleeca, heading, cb)
	for k, v in ipairs(Config.Banks) do
		if #(GetEntityCoords(PlayerPedId()) - v.OfficeDoor.c) < 2.0 then
			SetEntityHeading(PlayerPedId(), heading)
			TriggerEvent('ultra-keypadhack', 6, 40, function(outcome, reason)
				if outcome == 0 then
					ESX.Alert('Hack failed '..reason, "error")
				elseif outcome == 1 then
					TriggerServerEvent('sr_fleeca:UnlockDoor')
					cb(true)
				elseif outcome == 2 then
					ESX.Alert('Timed out', "error")
				elseif outcome == -1 then
					print('Error occured',reason)
				end
			end)
			break
		end
	end
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

function PickCouterCash(coord, heading)
	ESX.SetPlayerData("isSentenced", true)
	exports.essentialmode:DisableControl(true)
	TriggerEvent("dpemote:enable", false)
	TriggerEvent("dpclothingAbuse", true)
	local ped = PlayerPedId()
	ESX.SetEntityCoords(ped, vector3(coord.x, coord.y, coord.z - 1))
	SetEntityHeading(ped, heading)
	startAnim(ped, "anim@gangops@facility@servers@bodysearch@", "player_search")
	exports.rprogress:Custom({
		Duration = 6500,
		Label = "Taking money...",
		Animation = {
			scenario = "", -- https://pastebin.com/6mrYTdQv
			animationDictionary = "", -- https://alexguirre.github.io/animations-list/
		},
		DisableControls = {
			Mouse = false,
			Player = true,
			Vehicle = true
		}
	})
	Wait(6500)
	ESX.TriggerServerCallback("sr_fleeca:TakeCouterCash", function()end)
	exports.essentialmode:DisableControl(false)
	TriggerEvent("dpemote:enable", true)
	TriggerEvent("dpclothingAbuse", false)
	ESX.SetPlayerData("isSentenced", false)
end

local WhiteBags = {
	[`mp_m_freemode_01`] = {
		[30] = true,
		[31] = true,
		[11] = true,
		[13] = true,
	},
	[`mp_f_freemode_01`] = {
		[25] = true,
		[26] = true,
	},
}

function CreateBotInteraction(fleeca)
	BotDialog("Please Dont Touch me")
	local bCoord = GetEntityCoords(ShopNPC)
	CreatePoint(bCoord, false, function ()
		DrawText3D(bCoord.x, bCoord.y, bCoord.z + 0.9, "[~r~E~w~] Search")
	end, function (unregister, DisableRKey)
		ESX.SetPlayerData("isSentenced", true)
		exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
		startAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search")
		exports.rprogress:Custom({
			Duration = 2000,
			Label = "Searching ...",
			Animation = {
				scenario = "", -- https://pastebin.com/6mrYTdQv
				animationDictionary = "", -- https://alexguirre.github.io/animations-list/
			},
			DisableControls = {
				Mouse = false,
				Player = true,
				Vehicle = true
			}
		})
		Citizen.Wait(2000)
		TriggerServerEvent('sr_fleeca:GrabKey')
		ESX.Alert('~g~You found the Keypad cart', "check")
		unregister()
		ESX.SetPlayerData("isSentenced", false)
		exports.essentialmode:DisableControl(false)
		TriggerEvent("dpemote:enable", true)
		TriggerEvent("dpclothingAbuse", false)
	end, fleeca, {Interact = 1.5})
end

function BotDialog(msg)
	Citizen.CreateThread(function()
		local timer = true
		SetTimeout(5000, function()
			timer = false
		end)
		while timer do
			local coord = GetEntityCoords(ShopNPC)
			DrawText3D(coord.x, coord.y, coord.z + 0.9, msg)
			Wait(5)
		end
	end)
end

RegisterNetEvent('sr_fleeca:ResetYou')
AddEventHandler('sr_fleeca:ResetYou', function(id)
	if CurrentFleeca == id then
		local fleeca = 'fleeca_rob_'..id
		if RobStarted then
			RobStarted = false
			ESX.Alert('~r~You Faild The Mission')
		end
		for k,v in pairs(objects) do
			DeleteEntity(v)
		end
		objects = {}
		DeleteEntity(ShopNPC)
		ShopNPC = -1
		exports.sr_main:RemoveByTag(fleeca)
	end
end)

RegisterNetEvent('sr_fleeca:RobberyStart')
AddEventHandler('sr_fleeca:RobberyStart', function(id)
	local botMove = Config.Banks[id].botMove
	local coords = vector3(botMove.c.x, botMove.c.y, botMove.c.z)
	if DoesEntityExist(ShopNPC) and CurrentFleeca == id then
		ended = true
		SetTimeout(1000, function()
			ended = false
		end)
		FreezeEntityPosition(ShopNPC, false)
		SetBlockingOfNonTemporaryEvents(ShopNPC, true)
		startAnim(ShopNPC, 'anim@mp_player_intuppersurrender', 'enter')
		BotDialog("Dont shoot")
		TaskGoStraightToCoord(ShopNPC, coords, 1.5, 4000, botMove.h, 1.0)
		Wait(6000)
		FreezeEntityPosition(ShopNPC, true)
	end
end)

function CreateAimCheckThread(coords, cb)
    while DoesEntityExist(ShopNPC) and not ended do
        if IsPlayerFreeAiming(PlayerId()) then
            local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if IsPedFleeing(ShopNPC) or targetPed == ShopNPC then
				Citizen.Wait(math.random(200, 2000))
				cb()
                break
            end
        end
        Wait(5)
    end
end

function SpawnShopPed(data, cb)
	while not HasModelLoaded(1567728751) do Wait(0) RequestModel(1567728751) end
	ShopNPC = CreatePed(4, 1567728751, data.botPos.c.x, data.botPos.c.y, data.botPos.c.z - 1, data.botPos.h, false, true)
	SetPedDiesWhenInjured(ShopNPC, false)
	SetPedCanPlayAmbientAnims(ShopNPC, true)
	SetPedCanRagdollFromPlayerImpact(ShopNPC, false)
	SetEntityInvincible(ShopNPC, true)
	FreezeEntityPosition(ShopNPC, true)
	CreateAimCheckThread(data.botMove, cb)
end

function loadModel(model)
	if type(model) == 'number' then
		model = model
	else
		model = GetHashKey(model)
	end
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(0)
	end
end

Citizen.CreateThread(function()
	local v = { coords = vector3(-1305.66,-442.73,33.78), heading = 122.83, model = 's_m_y_robber_01'}
	loadModel(v['model'])
	Ped = CreatePed(26, GetHashKey(v['model']), v['coords'], v['heading'], false, true)
	SetPedDefaultComponentVariation(Ped)
	SetPedRandomProps(Ped)
	SetPedRandomComponentVariation(Ped, true)
	FreezeEntityPosition(Ped, true)
	SetEntityInvincible(Ped, true)
	SetBlockingOfNonTemporaryEvents(Ped, true)
	local pedCoords = GetEntityCoords(Ped)
	FleecaHeistStartBlip = AddBlipForCoord(pedCoords.x, pedCoords.y, pedCoords.z)
	SetBlipSprite(FleecaHeistStartBlip, 433)
	SetBlipColour(FleecaHeistStartBlip, 1)
	SetBlipScale(FleecaHeistStartBlip, 0.6)
	SetBlipAsShortRange(FleecaHeistStartBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Fleeca Heist')
	EndTextCommandSetBlipName(FleecaHeistStartBlip)
	while true do
		Citizen.Wait(3)
		local pedCoords = GetEntityCoords(Ped)
		local crd = GetEntityCoords(PlayerPedId())
		local dist = #(pedCoords - crd)
		Pause = true
		if dist < 1.5 then
			Pause = Block
		  	DrawText3Ds(pedCoords.x, pedCoords.y, pedCoords.z, 'Press [E] to start Fleeca Heist')
		else
			Citizen.Wait(700)
		end
	end
end)

PublicArray = {}
for k, v in pairs(Config.Banks) do
    table.insert(PublicArray, v.name)
end

function CutSceneThread(cut)
	local lastCoord = GetEntityCoords(PlayerPedId())
	DoScreenFadeOut(400)
	Citizen.Wait(500)
	ESX.SetEntityCoords(PlayerPedId(), lastCoord)
	Citizen.Wait(700)
	local ped = PlayerPedId()
	local wait = false
	TriggerEvent('skinchanger:getSkin', function(skin)
		lastKos = skin
		wait = true
	end)
	while not wait do
		Citizen.Wait(100)
	end
	while not HasThisCutsceneLoaded(cut) do
		RequestCutscene(cut, 8)
		Wait(0)
	end

	SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
	RegisterEntityForCutscene(ped, 'MP_1', 0, GetEntityModel(ped), 64)

	SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
	RegisterEntityForCutscene(ped, 'MP_2', 0, GetEntityModel(ped), 64)

    StartCutscene(0)

	while not (DoesCutsceneEntityExist('MP_1', 0)) do
        Wait(0)
	end

	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerEvent("skinchanger:loadClothes", skin, lastKos)
	end)

	DoScreenFadeIn(500)

	sxcr = true

	while (not IsCutscenePlaying()) do
		Citizen.Wait(100)
	end
    while (IsCutscenePlaying()) do
        Citizen.Wait(100)
    end
	local coords = lastCoord
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	local timeout = 0
	DoScreenFadeOut(500)
	Citizen.Wait(600)
	while not IsScreenFadedOut() do
		Citizen.Wait(100)
	end
	ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
	while not HasCollisionLoadedAroundEntity(PlayerPedId()) and timeout < 3000 do
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
		Citizen.Wait(500)
		timeout = timeout + 500
	end
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
	Citizen.Wait(600)
	DoScreenFadeIn(500)
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerEvent("skinchanger:loadClothes", skin, lastKos)
	end)
	sxcr = false
end

AddEventHandler("onKeyUP", function(key)
	if key == "e" then
		if not Pause then
			Block = true
			Citizen.SetTimeout(2000, function()
				Block = false
			end)
			ESX.TriggerServerCallback("esx_fleeca:checkForRobbery", function(status)
				if status then
					CutSceneThread("mph_tut_fin_int")
					globalRobbery = status
					local coord
					for k, v in ipairs(Config.Banks) do
						if v.name == globalRobbery then
							coord = v.coord
							break
						end
					end
					SetNewWaypoint(coord.x, coord.y)
					local Blip = AddBlipForCoord(coord)	
					SetBlipSprite (Blip, 150)
					SetBlipDisplay(Blip, 4)
					SetBlipScale  (Blip, 1.5)
					SetBlipColour (Blip, 0)
					SetBlipAsShortRange(Blip, true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString('Fleeca Robbery')
					EndTextCommandSetBlipName(Blip)
					Citizen.SetTimeout(5 * 60 * 1000, function()
						RemoveBlip(Blip)
						if not isRobStarted() then
							TriggerServerEvent("sr_fleeca:returnRob")
						end
					end)
				elseif status == nil then
					ESX.Alert("Shoma Az Ghabl Yek Darkhast Baraye Robbery Dadid", "info")
				else
					ESX.Alert("Police Kafi Dar Shahr Nist Ya Tamami Fleeca Ha Dar CoolDown Hastand", "info")
				end
			end)
		end
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

Citizen.CreateThread(function()
	while not ESX do Citizen.Wait(1000) end
	for k, v in ipairs(Config.Banks) do
		local fleeca = 'fleeca_rob_'..k
		local Point = RegisterPoint(v.coord, 5, true)
		Point.set('InAreaOnce', function ()
			CurrentFleeca = k
			ESX.TriggerServerCallback('sr_fleeca:GetFleecaStatus', function (avaliable, copEnough, force, timer)
				if not avaliable and timer then
					ESX.Alert("In Fleeca Be Moddat "..timer.." Saniye CoolDown Ast", "info")
				end
				if (avaliable and copEnough) and (force or v.name == globalRobbery) then
					SpawnShopPed(v, function ()
						local MissionFaild = RegisterPoint(v.coord, 25, false)
						MissionFaild.set('Tag', fleeca)
						MissionFaild.set('OutAreaOnce', function ()
							if RobStarted then
								RobStarted = false
								ESX.Alert('~r~You Faild The Mission', "error")
								TriggerServerEvent('sr_fleeca:EndOfRobbery', k)
							end
							-- TriggerServerEvent('sr_fleeca:EndOfRobbery', k)
							for k,v in pairs(objects) do
								DeleteEntity(v)
							end
							objects = {}
							exports.sr_main:RemoveByTag(fleeca)
						end)
						RobStarted = true
						local playercoord = GetEntityCoords(PlayerPedId())
						TriggerServerEvent('sr_fleeca:RobberyStart', k, GetStreetNameFromHashKey(GetStreetNameAtCoord(playercoord.x, playercoord.y, playercoord.z)))
						currentRob = k
						local function PoletAlive()
							for id, polet in ipairs(v.Polet) do
								local coord = polet.c
								local heading = polet.h
								CreatePoint(polet.c, false, function ()
									ShowFloatingHelpNotification('~INPUT_PICKUP~ Loot Cash', coord)
								end, function (unregister, Activate)
									if true then
										StartPickingMoney()
										unregister()
									else
										Activate()
										TriggerEvent('esx:showNotification', 'Shoma be Kif Ehtiaj Darid, Agar Kif Darid Zip Kif ro Baz Konid!')
									end
								end, fleeca, {Interact = 1.5})
							end
						end
						
						for id, door in ipairs(v.doors) do
							local coord = door.c
							local heading = door.h
							CreatePoint(coord, function ()
								DrawMarker(25, coord.x, coord.y, coord.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
							end, function ()
								ShowFloatingHelpNotification('~INPUT_PICKUP~ Start Hack', coord)
							end, function (unregister, Activate)
								ESX.TriggerServerCallback('sr_fleeca:CheckHackStuff', function(cart, rasperry)
									if cart then
										if rasperry then
											PutCartIn(coord, heading, function ()
												StartHack(v.hack, function (success)
													if success then
														unregister()
														if id == 1 then
															SpawnTrolleys(v.Polet, function ()
																PoletAlive()
															end)
														else
															RobStarted = false
														end
														Wait(1000)
														TriggerServerEvent('sr_fleeca:HackedDoor', k, id)
													else
														Activate()
													end
												end)
											end)
										else
											ESX.Alert('Shoma Laptop Nadarid, Baraye Hack niyaz be Laptop darid!') 
											Activate()
										end
									else
										ESX.Alert('Shoma Cart Nadarid, Ebteda Cart Bankdar Ro Begirid!') 
										Activate()
									end
								end)
							end, fleeca)
						end
						
						local function CouterAlive()
							local Picked = 0
							for id, couter in ipairs(v.Couter) do
								local coord = couter.c
								local heading = couter.h
								CreatePoint(couter.c, function ()
									DrawMarker(25, coord.x, coord.y, coord.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
								end, function ()
									ShowFloatingHelpNotification('~INPUT_PICKUP~ Grab Money', coord)
								end, function (unregister)
									PickCouterCash(coord, heading)
									Picked = Picked + 1
									if Picked == 4 then
										CreateBotInteraction(fleeca)
									end
									unregister()
								end, fleeca)
							end
						end
						
						local coord = v.OfficeDoor.c
						local heading = v.OfficeDoor.h
						
						CreatePoint(coord, function ()
							DrawMarker(25, coord.x, coord.y, coord.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
						end, function ()
							ShowFloatingHelpNotification('~INPUT_PICKUP~ Unlock Door', coord)
						end, function (unregister, Activate)
							ESX.TriggerServerCallback('sr_fleeca:LockpickCheck', function(exist)
								if exist then
									UnlockDoor(k, heading, function (success)
										if success then
											unregister()
											CouterAlive()
										else
											Activate()
										end
									end)
								else
									Activate()
									ESX.Alert('~r~You dont have lockpick')
								end
							end)
						end, fleeca)
					end)
				end
			end, k)
		end, function()
			CurrentFleeca = nil
			if DoesEntityExist(ShopNPC) then
				DeleteEntity(ShopNPC)
			end
		end)
	end
end)

function isRobStarted()
	return RobStarted
end

exports("isRobStarted", isRobStarted)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        DeleteEntity(ShopNPC)
	end
end)

AddEventHandler("onKeyDown", function(key)
	if key == "return" then
		if IsCutscenePlaying() then
			if sxcr then
				StopCutsceneImmediately()
			end
		end
	end
end)