---@diagnostic disable: undefined-field, lowercase-global, param-type-mismatch, missing-parameter
ESX = nil

CreateThread(function()
	while ESX == nil do 
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

local cam = nil
local continuousFadeOutNetwork = false
local needAskQuestions, needRegister = nil, nil
local disableAttack = true
local InRegisterMenu = false
local PlayerLoadCoords = vector3(-1037.93, -2738, 19.25)
local loadedwith = false
local response = nil

function f(n)
	n = n + 0.00000
	return n
end

function setCamHeight(height)
	local pos = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam,vector3(pos.x,pos.y,f(height)))
end

local function StartFade()
	DoScreenFadeOut(500)
	while IsScreenFadingOut() do
		Citizen.Wait(1)
	end
end

local function EndFade()
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()
	DoScreenFadeIn(500)
	while IsScreenFadingIn() do
		Citizen.Wait(1)
	end
end

function DisalbeAttack()
	DisableControlAction(0, 19, true) -- INPUT_CHARACTER_WHEEL 
	DisableControlAction(0, 45, true)
	DisableControlAction(0, 24, true) -- Attack
	DisableControlAction(0, 257, true) -- Attack 2
	DisableControlAction(0, 25, true) -- Right click
	DisableControlAction(0, 68, true) -- Vehicle Attack
	DisableControlAction(0, 69, true) -- Vehicle Attack
	DisableControlAction(0, 70, true) -- Vehicle Attack
	DisableControlAction(0, 92, true) -- Vehicle Passengers Attack
	DisableControlAction(0, 346, true) -- Vehicle Melee
	DisableControlAction(0, 347, true) -- Vehicle Melee
	DisableControlAction(0, 264, true) -- Disable melee
	DisableControlAction(0, 257, true) -- Disable melee
	DisableControlAction(0, 140, true) -- Disable melee
	DisableControlAction(0, 141, true) -- Disable melee
	DisableControlAction(0, 142, true) -- Disable melee
	DisableControlAction(0, 143, true) -- Disable melee
	DisableControlAction(0, 263, true) -- Melee Attack 1
	if disableAttack then
		SetTimeout(0, function ()
			DisalbeAttack()
		end)
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	if xPlayer.lastPosition ~= nil or xPlayer.lastPosition ~= "null" then 
		PlayerLoadCoords = xPlayer.lastPosition
	end
end)

function showLoadingPromt(label, time)
    Citizen.CreateThread(function()
        BeginTextCommandBusyString(tostring(label))
        EndTextCommandBusyString(3)
        Citizen.Wait(time)
        RemoveLoadingPrompt()
    end)
end

function ReadToPlay()
	ESX.SetEntityCoords(PlayerPedId(), PlayerLoadCoords.x+0.0, PlayerLoadCoords.y+0.0, PlayerLoadCoords.z -1+0.0)
	Citizen.Wait(1000)
	ESX.SetEntityCoords(PlayerPedId(), PlayerLoadCoords.x+0.0, PlayerLoadCoords.y+0.0, PlayerLoadCoords.z -1+0.0)
	Citizen.Wait(1000)
	ESX.SetEntityCoords(PlayerPedId(), PlayerLoadCoords.x+0.0, PlayerLoadCoords.y+0.0, PlayerLoadCoords.z -1+0.0)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if skin == nil then
			local Time = 10
			Citizen.CreateThread(function()
				while Time > 0 do
					Citizen.Wait(250)
					Time = Time - 1
					TriggerEvent('skinchanger:loadSkin', {sex = 0})
				end
			end)
			TriggerEvent('esx_skin:openSaveableMenu')
		else
			local Time = 10
			Citizen.CreateThread(function()
				while Time > 0 do
					Citizen.Wait(250)
					Time = Time - 1
					TriggerEvent('skinchanger:loadSkin', skin)
				end
			end)
		end
		if json.encode(skin) == "[]" then
			Citizen.Wait(2000)
			TriggerEvent('esx_skin:openSaveableMenu')
		end
	end)
	disableAttack = false
	CameraLoadToGround()
	SetEntityInvincible(PlayerPedId(),false)
	SetEntityVisible(PlayerPedId(),true)
	FreezeEntityPosition(PlayerPedId(),false)
	SetPedDiesInWater(PlayerPedId(),true)
	DisplayRadar(true)
	KillCamera()
	TriggerEvent('es_admin:freezePlayer', false)
	TriggerEvent('esx:restoreLoadout')
	TriggerEvent('streetlabel:changeLoadStatus', true)
	TriggerEvent('esx_voice:changeLoadStatus', true)
	TriggerEvent('esx_status:setLastStats')
	TriggerEvent('esx_status:setLastStatsirs')
	TriggerServerEvent('esx_rack:loaded')
	TriggerEvent('esx_jail:CheckForJail')
	TriggerEvent('showStatus')
	TriggerEvent('InteractSound_CL:changestatus')
	ESX.SetPlayerData('IsPlayerLoaded', 1)
	exports.esx_manager:setException(false)
	ESX.SetPlayerInvincible(PlayerId(), false)
	TriggerEvent("esx:checkDeathFromDisconnect")
	SetTimeout(5000, function()
		TriggerEvent("PlayerLoadedToGround")
		TriggerEvent("sr:changeHUDState", true)
	end)
end

AddEventHandler("login:SetupNewStuff", function(pos)
	if pos then
		PlayerLoadCoords = pos
	end
	response = false
end)

RegisterNetEvent("login:InitiateResponse")
AddEventHandler("login:InitiateResponse", function(res)
	response = res
end)

RegisterNetEvent("login:ForceLoad")
AddEventHandler("login:ForceLoad", function()
	response = false
	loadedwith = true
	needRegister = false
end)

AddEventHandler("loading:IsNewPlayer", function(cb)
	while needRegister == nil do
		Citizen.Wait(5000)
	end
	cb(needRegister)
end)

AddEventHandler("skinchanger:modelLoaded", function()
	loadedwith = true
end)

function StartUpLoading()
	Citizen.CreateThread(function()
		DisalbeAttack()
		CreateCameraOnTop()
		SetEntityInvincible(PlayerPedId(),true)
		SetEntityVisible(PlayerPedId(),true)
		FreezeEntityPosition(PlayerPedId(),true)
		SetPedDiesInWater(PlayerPedId(),false)
		DisplayRadar(false)
		EndFade()
		showLoadingPromt("PCARD_JOIN_GAME", 500000)
		TriggerEvent('es_admin:freezePlayer', true)
		while needRegister == nil do
			Citizen.Wait(5000)
		end
		while response == nil do
			Citizen.Wait(1000)
		end
		if needRegister then
			Wait(10000)
			showLoadingPromt("PCARD_JOIN_GAME", 0)
			SetTimeout(1000,function()
				TriggerCreateCharacter()
			end)
		elseif needAskQuestions then
			Wait(10000)
			showLoadingPromt("PCARD_JOIN_GAME", 0)
			TriggerEvent("antirpquestion:notMade")
		else
			Wait(10000)
			showLoadingPromt("PCARD_JOIN_GAME", 0)
			CreateCameraOnTop()
			EndFade()
			while not loadedwith do
				Citizen.Wait(2000)
			end
			while response do 
				Citizen.Wait(3000)
			end
			ReadToPlay()
		end
	end)
end

function LowEndSystems()
	Citizen.CreateThread(function()
		TriggerEvent('es_admin:freezePlayer', false)
		ESX.SetEntityCoords(PlayerPedId(), 402.55,-996.37,-100.01)
		while InRegisterMenu do
			Citizen.Wait(0)
			FreezeEntityPosition(PlayerPedId(), false)
			SetEntityCoords(PlayerPedId(), 402.55,-996.37,-100.01)
			FreezeEntityPosition(PlayerPedId(), true)
		end
	end)
	Citizen.CreateThread(function()
		while KosKesh do
			Citizen.Wait(2000)
			if ESX.GetPlayerData()['IsDead'] then
				Citizen.Wait(3000)
				TriggerEvent("esx_ambulancejob:revive")
			end
		end
	end)
end

function CreateCameraOnTop()
	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
	end

	local pos = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam,vector3(pos.x,pos.y,f(1000)))
	SetCamRot(cam,-f(90),f(0),f(0),2)
	SetCamActive(cam,true)
	StopCamPointing(cam)
	RenderScriptCams(true,true,0,0,0,0)
end

AddEventHandler("loading:nameRegistered", function()
	InRegisterMenu = false
	KosKesh = false
	TriggerEvent('es_admin:freezePlayer', false)
	FreezeEntityPosition(PlayerPedId(), false)
	Citizen.Wait(1000)
	SetEntityHeading(PlayerPedId(),f(180))
	KillCamera()
end)

function CameraLoadToGround()
	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
	end

	local altura = 1000
	local pos = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam,vector3(pos.x,pos.y,f(1000)))
	while altura > (pos.z - 5.0) do
		if altura <= 300 then
			altura = altura - 6
		elseif altura >= 301 and altura <= 700 then
			altura = altura - 4
		else
			altura = altura - 2
		end
		setCamHeight(altura)
		Citizen.Wait(10)
	end
end

function KillCamera()
	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
	end

	SetCamActive(cam,false)
	StopCamPointing(cam)
	RenderScriptCams(0,0,0,0,0,0)
	SetFocusEntity(PlayerPedId())
end

function CreateCharacterCamera()
	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
	end

	SetCamCoord(cam,vector3(402.6,-997.2,-98.3))
	SetCamRot(cam,f(0),f(0),f(358),15)
	SetCamActive(cam,true)
	RenderScriptCams(true,true,20000000000000000000000000,0,0,0)
end

RegisterNetEvent('registerForm')
AddEventHandler('registerForm', function(bool)
	needRegister = bool
end)

RegisterNetEvent('askQuestions')
AddEventHandler('askQuestions', function(bool)
	needAskQuestions = bool
end)

RegisterNetEvent("sr_loadingsystem:AskQuestions")
AddEventHandler("sr_loadingsystem:AskQuestions", function()
	needAskQuestions = true
	StartUpLoading()
end)

RegisterNetEvent("sr_loadingsystem:AskQuestionsSuccess")
AddEventHandler("sr_loadingsystem:AskQuestionsSuccess", function()
	needAskQuestions = false
	ReadToPlay()
end)

local isInCharacterMode = false
local currentCharacterMode = { sex = 0, dad = 0, mom = 0, skin_md_weight = 0, face_md_weight = 0.0, eye_color = 0, eyebrows_5 = 0, eyebrows_6 = 0, nose_1 = 0, nose_2 = 0, nose_3 = 0, nose_4 = 0, nose_5 = 0, nose_6 = 0, cheeks_1 = 0, cheeks_2 = 0, cheeks_3 = 0, lip_thickness = 0, jaw_1 = 0, jaw_2 = 0, chin_1 = 0, chin_2 = 0, chin_3 = 0, chin_4 = 0, neck_thickness = 0, hair_1 = 4, hair_2 = 0, hair_color_1 = 0, hair_color_2 = 0, eyebrows_1 = 0, eyebrows_1 = 10, eyebrows_3 = 0, eyebrows_4 = 0, beard_1 = -1, beard_2 = 10, beard_3 = 0, beard_4 = 0, chest_1 = -1, chest_1 = 10, chest_3 = 0, blush_1 = -1, blush_2 = 10, blush_3 = 0, lipstick_1 = -1, lipstick_2 = 10, lipstick_3 = 0, lipstick_4 = 0, blemishes_1 = -1, blemishes_2 = 10, age_1 = -1, age_2 = 10, complexion_1 = -1, complexion_2 = 10, sun_1 = -1, sun_2 = 10, moles_1 = -1, moles_2 = 10, makeup_1 = -1 , makeup_2 = 10, makeup_3 = 0 , makeup_4 = 0 }
local characterNome = ""
local characterSobrenome = ""

RegisterNetEvent('showRegisterForm')
AddEventHandler('showRegisterForm', function()
	lastcoord = GetEntityCoords(PlayerPedId())
	needRegister = true
	StartUpLoading()
end)

function TriggerCreateCharacter()
	KosKesh = true
	TriggerEvent("pma-voice:mutePlayer", true)
	--TriggerEvent('pma-voice:mutePlayer', true)
	TriggerEvent("skinchanger:ImInMenu", true)
	TriggerEvent("skinchanger:Handlers")
	InRegisterMenu = true
	local Timer = 2000
	RequestCollisionAtCoord(402.55,-996.37,-100.01)
	CreateCameraOnTop()
	isInCharacterMode = true
	StartFade()
	continuousFadeOutNetwork = true
	FadeOutNet()
	changeGender("mp_m_freemode_01")
	refreshDefaultCharacter()
	TaskUpdateSkinOptions()
	TaskUpdateFaceOptions()
	TaskUpdateHeadOptions()
	FreezeEntityPosition(PlayerPedId(), false)
	LoadInterior(94722)
	SetEntityCollision(PlayerPedId(), true, true)
	while IsInteriorReady(94722) ~= 1 or HasModelLoaded(model) do
		Wait(700)
	end
	ESX.SetEntityCoords(PlayerPedId(), 402.55, -996.37, -100.01)
	SetEntityHeading(PlayerPedId(),f(10))
	ESX.SetEntityCoords(PlayerPedId(), 402.55, -996.37, -100.01)
	--CreateCharacterCamera()
	FreezeEntityPosition(PlayerPedId(), true)
	Citizen.Wait(1000)
	ESX.SetEntityCoords(PlayerPedId(), 402.55, -996.37, -100.01)
	while not HasCollisionLoadedAroundEntity(PlayerPedId()) or Timer > 0 do
		FreezeEntityPosition(PlayerPedId(), false)
		ESX.SetEntityCoords(PlayerPedId(), 402.55,-996.37,-100.01)
		Wait(350)
		Timer = Timer - 500
	end
	ESX.SetEntityCoords(PlayerPedId(), 402.55,-996.37,-100.01)
	SetEntityHeading(PlayerPedId(),f(10))
	FreezeEntityPosition(PlayerPedId(), true)
	-- SetNuiFocus(isInCharacterMode,isInCharacterMode)
	-- SendNUIMessage({ CharacterMode = isInCharacterMode, CharacterMode2 = not isInCharacterMode, CharacterMode3 = not isInCharacterMode })
	TriggerEvent("esx_identity:showRegisterIdentity")
	EndFade()
	LowEndSystems()
	TriggerServerEvent('HR_Character:CharacterCreationStarted')
	ESX.SetPlayerData("isSentenced", true)
	ESX.SetEntityHealth(PlayerPedId(), 200)
	TriggerEvent('esx_status:setirs', 'hunger', 1000000)
	TriggerEvent('esx_status:setirs', 'thirst', 1000000)
	TriggerEvent('esx_status:setirs', 'mental', 1000000)
	exports.esx_manager:setException(true)
	ESX.SetPlayerInvincible(PlayerId(), true)
end

function refreshDefaultCharacter()
	SetPedDefaultComponentVariation(PlayerPedId())
	ClearAllPedProps(PlayerPedId())
    ClearPedDecorations(PlayerPedId())
	if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(PlayerPedId(),1,-1,0,2) -- mask
		SetPedComponentVariation(PlayerPedId(),3,15,0,2) -- torso
		SetPedComponentVariation(PlayerPedId(),4,61,0,2) -- leg
		SetPedComponentVariation(PlayerPedId(),5,-1,0,2) -- bag 
		SetPedComponentVariation(PlayerPedId(),6,16,0,2) -- shoes
		SetPedComponentVariation(PlayerPedId(),7,-1,0,2) -- neck
		SetPedComponentVariation(PlayerPedId(),8,15,0,2) -- undershirt
		SetPedComponentVariation(PlayerPedId(),9,-1,0,2) -- vest
		SetPedComponentVariation(PlayerPedId(),10,-1,0,2) -- badge
		SetPedComponentVariation(PlayerPedId(),11,15,0,2) -- jacket
		SetPedPropIndex(PlayerPedId(),2,-1,0,2) -- ear
		SetPedPropIndex(PlayerPedId(),6,-1,0,2) -- watch
		SetPedPropIndex(PlayerPedId(),7,-1,0,2) -- bracelet
	else
		SetPedComponentVariation(PlayerPedId(),1,-1,0,2) -- mask
		SetPedComponentVariation(PlayerPedId(),3,15,0,2) -- torso
		SetPedComponentVariation(PlayerPedId(),4,15,0,2) -- leg
		SetPedComponentVariation(PlayerPedId(),5,-1,0,2) -- parachute 
		SetPedComponentVariation(PlayerPedId(),6,5,0,2) -- shoes
		SetPedComponentVariation(PlayerPedId(),7,-1,0,2) -- accesory
		SetPedComponentVariation(PlayerPedId(),8,7,0,2) -- undershirt
		SetPedComponentVariation(PlayerPedId(),9,-1,0,2) -- kevlar
		SetPedComponentVariation(PlayerPedId(),10,-1,0,2) -- badge
		SetPedComponentVariation(PlayerPedId(),11,5,0,2) -- torso 2
		SetPedPropIndex(PlayerPedId(),2,-1,0,2) -- ear
		SetPedPropIndex(PlayerPedId(),6,-1,0,2) -- watch
		SetPedPropIndex(PlayerPedId(),7,-1,0,2) -- bracelet
	end
end

function changeGender(model)
	local mhash = GetHashKey(model)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		SetPlayerModel(PlayerId(),mhash)
		SetPedMaxHealth(PlayerPedId(),200)
		ESX.SetEntityHealth(PlayerPedId(),200)
		SetModelAsNoLongerNeeded(mhash)
	end
	exports.esx_manager:ModelUpdated()
end

function FadeOutNet()
	if continuousFadeOutNetwork then 
		for _, id in ipairs(GetActivePlayers()) do
			if id ~= PlayerId() then
				NetworkFadeOutEntity(GetPlayerPed(id),false)
			end
		end
		SetTimeout(0, FadeOutNet)
	end
end

function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

-- RegisterNUICallback('cDoneSave',function(data,cb)
-- 	ESX.SetPlayerData("isSentenced", false)
-- 	TriggerEvent("pma-voice:mutePlayer")
-- 	InRegisterMenu = false
-- 	StartFade()
-- 	isInCharacterMode = false
-- 	SetNuiFocus(isInCharacterMode,isInCharacterMode)
-- 	SendNUIMessage({ CharacterMode = isInCharacterMode, CharacterMode2 = isInCharacterMode, CharacterMode3 = isInCharacterMode })

-- 	local coord = lastcoord or vector3(-1037.93, -2738.0, 19.25)

-- 	SetEntityHeading(PlayerPedId(),f(328.62))
-- 	continuousFadeOutNetwork = false

-- 	for _, id in ipairs(GetActivePlayers()) do
-- 		if id ~= PlayerId() and NetworkIsPlayerActive(id) then
-- 			NetworkFadeInEntity(GetPlayerPed(id),true)
-- 		end
-- 	end

-- 	TriggerEvent('skinchanger:loadSkin', currentCharacterMode)
	
-- 	local relatedTable = Config.DefaultClothes[GetEntityModel(PlayerPedId())]
-- 	local choosenClothe = math.random(1, #relatedTable)
-- 	local cArray = json.decode(relatedTable[choosenClothe])
-- 	for k,v in pairs(cArray) do
-- 		if k ~= 'sex' and k ~= 'mom' and k ~= 'dad' and k ~= 'skin_color' and k ~= 'skin_opacity' and k ~= 'face_md_weight' and k ~= 'skin_md_weight' and k ~=
-- 			'nose_1' and k ~= 'nose_2' and k ~= 'nose_3' and k ~= 'nose_4' and k ~= 'nose_5' and k ~= 'nose_6' and k ~=
-- 			'cheeks_1' and k ~= 'cheeks_2' and k ~= 'cheeks_3' and k ~= 'lip_thickness' and k ~= 'jaw_1' and k ~=
-- 			'jaw_2' and k ~= 'chin_1' and k ~= 'chin_2' and k ~= 'chin_3' and k ~= 'chin_4' and k ~=
-- 			'neck_thickness' and k ~= 'age_1' and k ~= 'age_2' and k ~= 'eye_color' and k ~= 'eye_squint' and k ~=
-- 			'beard_1' and k ~= 'beard_2' and k ~= 'beard_3' and k ~= 'beard_4' and k ~= 'hair_1' and k ~= 'hair_2' and
-- 			k ~= 'hair_color_1' and k ~= 'hair_color_2' and k ~= 'eyebrows_1' and k ~= 'eyebrows_2' and k ~=
-- 			'eyebrows_3' and k ~= 'eyebrows_4' and k ~= 'eyebrows_5' and k ~= 'eyebrows_6' and k ~= 'makeup_1' and k ~=
-- 			'makeup_2' and k ~= 'makeup_3' and k ~= 'makeup_4' and k ~= 'lipstick_1' and k ~= 'lipstick_2' and k ~=
-- 			'lipstick_3' and k ~= 'lipstick_4' and k ~= 'blemishes_1' and k ~= 'blemishes_2' and k ~= 'blemishes_3' and
-- 			k ~= 'blush_1' and k ~= 'blush_2' and k ~= 'blush_3' and k ~= 'complexion_1' and k ~= 'complexion_2' and
-- 			k ~= 'sun_1' and k ~= 'sun_2' and k ~= 'moles_1' and k ~= 'moles_2' and k ~= 'chest_1' and k ~=
-- 			'chest_2' and k ~= 'chest_3' and k ~= 'bodyb_1' and k ~= 'bodyb_2' and k ~= 'bodyb_3' and k ~= 'bodyb_4' then
-- 			currentCharacterMode[k] = v
-- 			TriggerEvent('skinchanger:change', k, v)
-- 		end
-- 	end

-- 	local sosShirs = {['mask_1'] = -1,['mask_2'] = 0,['bproof_1'] = -1,	['bproof_2'] = 0,	['chain_1'] = -1,['chain_2'] = 0,['bags_1'] = -1,['bags_2'] = 0,['helmet_1'] = -1,	['helmet_2'] = 0,	['glasses_1'] = -1,	['glasses_2'] = 0,	['watches_1'] = -1,	['watches_2'] = 0,	['bracelets_1'] = -1,	['bracelets_2'] = 0} 

-- 	for k,v in pairs(sosShirs) do
-- 		currentCharacterMode[k] = v
-- 		TriggerEvent('skinchanger:change', k, v)
-- 	end

-- 	TriggerEvent('skinchanger:loadClothes', currentCharacterMode, currentCharacterMode)

-- 	TriggerServerEvent('esx_skin:save', currentCharacterMode)

-- 	local playerNames = firstToUpper(characterNome) ..'_'.. firstToUpper(characterSobrenome)
-- 	TriggerServerEvent('db:updateUser', { playerName = playerNames })
-- 	TriggerServerEvent('es:newName', playerNames)
-- 	CreateCameraOnTop()
-- 	EndFade()
-- 	TriggerEvent('skinchanger:getSkin', function(skin)
-- 		if tonumber(skin.sex) == 0 then
-- 			TriggerEvent("HR_Character:StartScenario", { sex = "male"})
-- 		else
-- 			TriggerEvent("HR_Character:StartScenario", { sex = "female"})
-- 		end
-- 	end)
-- 	ReadToPlay()
-- end)

AddEventHandler("loading:setupEveything", function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		if tonumber(skin.sex) == 0 then
			TriggerEvent("HR_Character:StartScenario", { sex = "male"})
		else
			TriggerEvent("HR_Character:StartScenario", { sex = "female"})
		end
	end)
	ReadToPlay()
end)

RegisterNUICallback('cChangeHeading',function(data,cb)
	FreezeEntityPosition(PlayerPedId(), false)
	ESX.SetEntityCoords(PlayerPedId(), 402.55,-996.37,-100.01)
	FreezeEntityPosition(PlayerPedId(), true)
	SetEntityHeading(PlayerPedId(),f(data.camRotation)+180)
	cb('ok')
end)

RegisterNUICallback('ChangeGender',function(data,cb)
	currentCharacterMode.sex = tonumber(data.gender)
	if tonumber(data.gender) == 1 then
		changeGender("mp_f_freemode_01")
	else
		changeGender("mp_m_freemode_01")
	end
	refreshDefaultCharacter()
	TaskUpdateSkinOptions()
	TaskUpdateFaceOptions()
	TaskUpdateHeadOptions()
	cb('ok')
end)

RegisterNUICallback('UpdateSkinOptions',function(data,cb)
	currentCharacterMode.dad = data.dad
	currentCharacterMode.mom = data.mom
	currentCharacterMode.skin_md_weight = data.skin_md_weight -- skinColor
	currentCharacterMode.face_md_weight = data.face_md_weight * 100 -- shapeMix
	characterNome = data.characterNome
	characterSobrenome = data.characterSobrenome
	TaskUpdateSkinOptions()
	cb('ok')
end)

function TaskUpdateSkinOptions()
	local data = currentCharacterMode
	local face_weight = 		(data['face_md_weight'] / 100) + 0.0
	SetPedHeadBlendData(PlayerPedId(), data['dad'], data['mom'], 0, data['skin_md_weight'], 0, 0, face_weight, 0, 0, false)
end

RegisterNUICallback('UpdateFaceOptions',function(data,cb)
	currentCharacterMode.eye_color = data.eye_color
	currentCharacterMode.eyebrows_5 = data.eyebrows_5 * 10
	currentCharacterMode.eyebrows_6 = data.eyebrows_6 * 10
	currentCharacterMode.nose_1 = data.nose_1 * 10
	currentCharacterMode.nose_2 = data.nose_2 * 10
	currentCharacterMode.nose_3 = data.nose_3 * 10
	currentCharacterMode.nose_4 = data.nose_4 * 10
	currentCharacterMode.nose_5 = data.nose_5 * 10
	currentCharacterMode.nose_6 = data.nose_6 * 10
	currentCharacterMode.cheeks_1 = data.cheeks_1 * 10
	currentCharacterMode.cheeks_2 = data.cheeks_2 * 10
	currentCharacterMode.cheeks_3 = data.cheeks_3 * 10
	currentCharacterMode.lip_thickness = data.lip_thickness * 10
	currentCharacterMode.jaw_1 = data.jaw_1 * 10
	currentCharacterMode.jaw_2 = data.jaw_2 * 10
	currentCharacterMode.chin_1 = data.chin_1 * 10
	currentCharacterMode.chin_2 = data.chin_2 * 10
	currentCharacterMode.chin_3 = data.chin_3 * 10
	currentCharacterMode.chin_4 = data.chin_4 * 10
	currentCharacterMode.neck_thickness = data.neck_thickness * 10
	TaskUpdateFaceOptions()
	cb('ok')
end)

function TaskUpdateFaceOptions()
	-- local ped = PlayerPedId()
	-- local data = currentCharacterMode

	-- -- Olhos
	-- SetPedEyeColor(ped,data.eye_color)
	-- -- Sobrancelha
	-- SetPedFaceFeature(ped,6,data.eyebrows_5/10)
	-- SetPedFaceFeature(ped,7,data.eyebrows_6/10)
	-- -- Nariz
	-- SetPedFaceFeature(ped,0,data.nose_1/10)
	-- SetPedFaceFeature(ped,1,data.nose_2/10)
	-- SetPedFaceFeature(ped,2,data.nose_3/10)
	-- SetPedFaceFeature(ped,3,data.nose_4/10)
	-- SetPedFaceFeature(ped,4,data.nose_5/10)
	-- SetPedFaceFeature(ped,5,data.nose_6/10)
	-- -- Bochechas
	-- SetPedFaceFeature(ped,8,data.cheeks_1/10)
	-- SetPedFaceFeature(ped,9,data.cheeks_2/10)
	-- SetPedFaceFeature(ped,10,data.cheeks_3/10)
	-- -- Boca/Mandibula
	-- SetPedFaceFeature(ped,12,data.lip_thickness/10)
	-- SetPedFaceFeature(ped,13,data.jaw_1/10)
	-- SetPedFaceFeature(ped,14,data.jaw_2/10)
	-- -- Queixo
	-- SetPedFaceFeature(ped,15,data.chin_1/10)
	-- SetPedFaceFeature(ped,16,data.chin_2/10)
	-- SetPedFaceFeature(ped,17,data.chin_3/10)
	-- SetPedFaceFeature(ped,18,data.chin_4/10)
	-- -- Pescoço
	-- SetPedFaceFeature(ped,19,data.neck_thickness/10)
end

RegisterNUICallback('UpdateHeadOptions',function(data,cb)
	currentCharacterMode.hair_1 = data.hair_1
	currentCharacterMode.hair_2 = 0
	currentCharacterMode.hair_color_1 = data.hair_color_1
	currentCharacterMode.hair_color_2 = data.hair_color_2
	currentCharacterMode.eyebrows_1 = data.eyebrows_1
	currentCharacterMode.eyebrows_2 = 9.9
	currentCharacterMode.eyebrows_3 = data.eyebrows_3
	currentCharacterMode.eyebrows_4 = data.eyebrows_3
	currentCharacterMode.beard_1 = data.beard_1
	currentCharacterMode.beard_2 = 9.9
	currentCharacterMode.beard_3 = data.beard_3
	currentCharacterMode.beard_4 = data.beard_3
	currentCharacterMode.chest_1 = data.chest_1
	currentCharacterMode.chest_2 = 9.9
	currentCharacterMode.chest_3 = data.chest_3
	currentCharacterMode.blush_1 = data.blush_1
	currentCharacterMode.blush_2 = 10
	currentCharacterMode.blush_3 = data.blush_3
	currentCharacterMode.lipstick_1 = data.lipstick_1
	currentCharacterMode.lipstick_2 = 9.9
	currentCharacterMode.lipstick_3 = data.lipstick_3
	currentCharacterMode.lipstick_4 = data.lipstick_3
	currentCharacterMode.blemishes_1 = data.blemishes_1
	currentCharacterMode.blemishes_2 = 9.9
	currentCharacterMode.age_1 = data.age_1
	currentCharacterMode.age_2 = 9.9
	currentCharacterMode.complexion_1 = data.complexion_1
	currentCharacterMode.complexion_2 = 9.9
	currentCharacterMode.sun_1 = data.sun_1
	currentCharacterMode.sun_2 = 9.9
	currentCharacterMode.moles_1 = data.moles_1
	currentCharacterMode.moles_2 = 9.9
	currentCharacterMode.makeup_1 = data.makeup_1
	currentCharacterMode.makeup_2 = 9.9
	currentCharacterMode.makeup_3 = 0
	currentCharacterMode.makeup_4 = 0
	TaskUpdateHeadOptions()
	cb('ok')
end)

function TaskUpdateHeadOptions()
	local ped = PlayerPedId()
	local data = currentCharacterMode

	-- Cabelo
	SetPedComponentVariation(ped,2,data.hair_1,0,0)
	SetPedHairColor(ped,data.hair_color_1,data.hair_color_2)
	-- Sobracelha 
	-- SetPedHeadOverlay(ped,2,data.eyebrows_1,0.99)
	-- SetPedHeadOverlayColor(ped,2,1,data.eyebrows_3,data.eyebrows_3)
	-- -- Barba
	-- SetPedHeadOverlay(ped,1,data.beard_1,0.99)
	-- SetPedHeadOverlayColor(ped,1,1,data.beard_3,data.beard_3)
	-- -- Pelo Corporal
	-- SetPedHeadOverlay(ped,10,data.chest_1,0.99)
	-- SetPedHeadOverlayColor(ped,10,1,data.chest_3,data.chest_3)
	-- -- Blush
	-- -- SetPedHeadOverlay(ped,5,data.blush_1,0.99)
	-- -- SetPedHeadOverlayColor(ped,5,2,data.blush_3,data.blush_3)
	-- -- Battom
	-- SetPedHeadOverlay(ped,8,data.lipstick_1,0.99)
	-- SetPedHeadOverlayColor(ped,8,2,data.lipstick_3,data.lipstick_3)
	-- Manchas
	-- SetPedHeadOverlay(ped,0,data.blemishes_1,0.99)
	-- Envelhecimento
	-- SetPedHeadOverlay(ped,3,data.age_1,0.99)
	-- -- Aspecto
	-- SetPedHeadOverlay(ped,6,data.complexion_1,0.99)
	-- -- Pele
	-- SetPedHeadOverlay(ped,7,data.sun_1,0.99)
	-- -- Sardas
	-- SetPedHeadOverlay(ped,9,data.moles_1,0.99)
	-- Maquiagem
	-- SetPedHeadOverlay(ped,4,data.makeup_1,0.99)
	-- SetPedHeadOverlayColor(ped,4,0,0,0)
end

local sub_b0b5 = { 
    [0] = "MP_Plane_Passenger_1",
    [1] = "MP_Plane_Passenger_2",
    [2] = "MP_Plane_Passenger_3",
    [3] = "MP_Plane_Passenger_4",
    [4] = "MP_Plane_Passenger_5",
    [5] = "MP_Plane_Passenger_6",
    [6] = "MP_Plane_Passenger_7"
}

function sub_b747(ped, a_1)
    if a_1 == 0 then
        SetPedComponentVariation(ped, 0, 21, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 9, 0, 0)
        SetPedComponentVariation(ped, 3, 1, 0, 0)
        SetPedComponentVariation(ped, 4, 9, 0, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 4, 8, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 15, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 10, 0, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 1 then
        SetPedComponentVariation(ped, 0, 13, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 5, 4, 0)
        SetPedComponentVariation(ped, 3, 1, 0, 0)
        SetPedComponentVariation(ped, 4, 10, 0, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 10, 0, 0)
        SetPedComponentVariation(ped, 7, 11, 2, 0)
        SetPedComponentVariation(ped, 8, 13, 6, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 10, 0, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 2 then
        SetPedComponentVariation(ped, 0, 15, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 1, 4, 0)
        SetPedComponentVariation(ped, 3, 1, 0, 0)
        SetPedComponentVariation(ped, 4, 0, 1, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 7, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 9, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 6, 0, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 3 then
        SetPedComponentVariation(ped, 0, 14, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 5, 3, 0)
        SetPedComponentVariation(ped, 3, 3, 0, 0)
        SetPedComponentVariation(ped, 4, 1, 6, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 11, 5, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 3, 12, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 4 then
        SetPedComponentVariation(ped, 0, 18, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 15, 3, 0)
        SetPedComponentVariation(ped, 3, 15, 0, 0)
        SetPedComponentVariation(ped, 4, 2, 5, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 4, 6, 0)
        SetPedComponentVariation(ped, 7, 4, 0, 0)
        SetPedComponentVariation(ped, 8, 3, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 4, 0, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 5 then
        SetPedComponentVariation(ped, 0, 27, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 7, 3, 0)
        SetPedComponentVariation(ped, 3, 11, 0, 0)
        SetPedComponentVariation(ped, 4, 4, 8, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 13, 14, 0)
        SetPedComponentVariation(ped, 7, 5, 3, 0)
        SetPedComponentVariation(ped, 8, 3, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 2, 7, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 6 then
        SetPedComponentVariation(ped, 0, 16, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 15, 1, 0)
        SetPedComponentVariation(ped, 3, 3, 0, 0)
        SetPedComponentVariation(ped, 4, 5, 6, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 2, 8, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 3, 7, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    end
end

RegisterNetEvent('HR_Character:StartScenario')
AddEventHandler('HR_Character:StartScenario', function(veri)
    CreateThread(function()
		exports['esx_manager']:whiteStuffCoords(60000)
		exports.esx_manager:newException(true)
        PrepareMusicEvent("FM_INTRO_START")
        TriggerMusicEvent("FM_INTRO_START")
        local plyrId = PlayerPedId()
        if veri.sex == 'male' then
            RequestCutsceneWithPlaybackList("MP_INTRO_CONCAT", 31, 8)
        else	
            RequestCutsceneWithPlaybackList("MP_INTRO_CONCAT", 103, 8)
        end
        while not HasCutsceneLoaded() do Wait(10) end
        if veri.sex == 'male' then
            RegisterEntityForCutscene(0, 'MP_Male_Character', 3, GetEntityModel(PlayerPedId()), 0)
            RegisterEntityForCutscene(PlayerPedId(), 'MP_Male_Character', 0, 0, 0)
            SetCutsceneEntityStreamingFlags('MP_Male_Character', 0, 1) 
            local female = RegisterEntityForCutscene(0,"MP_Female_Character",3,0,64) 
            NetworkSetEntityInvisibleToNetwork(female, true)
        else
            RegisterEntityForCutscene(0, 'MP_Female_Character', 3, GetEntityModel(PlayerPedId()), 0)
            RegisterEntityForCutscene(PlayerPedId(), 'MP_Female_Character', 0, 0, 0)
            SetCutsceneEntityStreamingFlags('MP_Female_Character', 0, 1) 
            local male = RegisterEntityForCutscene(0,"MP_Male_Character",3,0,64) 
            NetworkSetEntityInvisibleToNetwork(male, true)
        end
        local ped = {}
        for v_3=0, 6, 1 do
            if v_3 == 1 or v_3 == 2 or v_3 == 4 or v_3 == 6 then
                ped[v_3] = CreatePed(26, "mp_f_freemode_01", -1117.77783203125, -1557.6248779296875, 3.3819, 0.0, 0, 0)
            else
                ped[v_3] = CreatePed(26, "mp_m_freemode_01", -1117.77783203125, -1557.6248779296875, 3.3819, 0.0, 0, 0)
            end
            if not IsEntityDead(ped[v_3]) then
                sub_b747(ped[v_3], v_3)
                FinalizeHeadBlend(ped[v_3])
                RegisterEntityForCutscene(ped[v_3], sub_b0b5[v_3], 0, 0, 64)
            end
        end
        NewLoadSceneStartSphere(-1212.79, -1673.52, 7, 1000, 0)
        SetWeatherTypeNow("EXTRASUNNY")
        StartCutscene(4)
        Wait(31520)
        for v_3=0, 6, 1 do
            DeleteEntity(ped[v_3])
        end
        PrepareMusicEvent("AC_STOP")
        TriggerMusicEvent("AC_STOP")
        if veri.sex == 'male' then 
            Wait(49700)
            UpLoading()
        else
            Wait(51000)
            UpLoading()
        end
    end)
end)

local InCar = false
local Lamar = nil
local Vehicle = nil

function UpLoading()
	Citizen.CreateThread(function()
        InCar = true
        ClearKeyboardKeys()
		if not IsPlayerSwitchInProgress() then
			SwitchOutPlayer(PlayerPedId(), 32, 1)	
		end	
		while GetPlayerSwitchState() ~= 5 do
			Citizen.Wait(0)
		end
        ESX.SetEntityCoords(PlayerPedId(), -1039.23, -2730.47, 19.9, 160.13)
		ESX.ShowLoadingPromt("PCARD_JOIN_GAME", 5000)
        LamarThread()
        Citizen.Wait(5000)
		SwitchInPlayer(PlayerPedId())
		local timer = GetGameTimer()
		while GetPlayerSwitchState() ~= 12 and GetGameTimer() - timer < 1000 * 10 * 3 do
			Wait(500)
		end
        Citizen.Wait(1000)
        LamarCarThread()
	end)
end

function LamarThread()
    RequestModel(GetHashKey("ig_lamardavis"))
    while not HasModelLoaded(GetHashKey("ig_lamardavis")) do
        Citizen.Wait(10)
    end
    RequestCollisionAtCoord(-1034.23, -2730.47, 19.56)
    Lamar = CreatePed(4, "ig_lamardavis", -1039.23, -2730.47, 19.9, false, false)
    ESX.Game.SpawnLocalVehicle("emperor", vector3(-1034.23, -2730.47, 19.86), 240.22, function(veh)
        TaskWarpPedIntoVehicle(Lamar, veh, -1)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, 0)
		ESX.CreateVehicleKey(veh)
        SetVehicleColours(veh, 0 ,0)
        Vehicle = veh
		while true do
			Citizen.Wait(500)
			local current = GetEntityCoords(Vehicle)
			if #(current - vector3(-1034.23, -2730.47, 19.86)) >= 30.0 then
				NetworkRegisterEntityAsNetworked(Vehicle)
				break
			end
		end
    end)
end

function LamarCarThread()
    TaskLeaveVehicle(Lamar, Vehicle, 64)
    Wait(1400)
    TaskGoToCoordAnyMeans(Lamar, vector3(-1033.65, -2734.14, 20.17), 1.0, 0, 0, 786603, 0xbf800000)
    Wait(5000)
    SetEntityAsMissionEntity(Lamar, true, true)
    SetEntityHeading(Lamar, 359.29)
    SetBlockingOfNonTemporaryEvents(Lamar, true)
    Wait(100)
    FreezeEntityPosition(Lamar, true)
    SetEntityInvincible(Lamar, true)
    ClearPedTasks(Lamar)
    TaskStartScenarioInPlace(Lamar, "WORLD_HUMAN_SMOKING", 0, true)
    TriggerServerEvent('HR_Character:CharacterCreationEnded')
	TriggerEvent("pma-voice:mutePlayer", false)
    InCar = false
	KosKesh = false
	exports.esx_manager:newException(false)
end

function ClearKeyboardKeys()
    Citizen.CreateThread(function()
        while InCar do
            Citizen.Wait(2)
            DisableAllControlActions(0)
        end
    end)
end

Citizen.CreateThread(StartUpLoading)