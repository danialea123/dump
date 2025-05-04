---@diagnostic disable: undefined-field, lowercase-global, param-type-mismatch, missing-parameter
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

PLT = plt_plants
Plants = PLT.Plants
U = PLT.U
PlantList = 0
CloseWeeds = {}
NearPlants = {}
playerPedId = 0
playerCoord = vector3(0.0,0.0,0.0)
Now = 0
MyIdent = 0
DisableActions = false
activePlantID = false
NuiFocus = false
waitForNewFocus = false
inVehicle = true
ValidCoords = {
	[1] = {
		coord = vector3(1882.1,5068.19,50.62),
		radius = 50,
	},
	[2] = {
		coord = vector3(1797.68,4990.74,51.53),
		radius = 42,
	},
	[3] = {
		coord = vector3(2141.85,5173.17,54.95),
		radius = 47,
	},
	[4] = {
		coord = vector3(2312.63,5131.35,50.08),
		radius = 35,
	},
	[5] = {
		coord = vector3(4849.71,-4591.84,17.67),
		radius = 38,
	}
}

Citizen.CreateThread(function()
	while PlantList == 0 do Citizen.Wait(1000) end local dist = 0 local bekle = 0 local playerToPlant = 1000 local onPlant = false 
	while true do bekle = 1000
		playerCoord = GetEntityCoords(playerPedId)
		onPlant = false
		if inVehicle == false then
			for k,v in pairs(CloseWeeds) do 
				kapat = true
				playerToPlant = GetDistanceBetweenCoords(playerCoord, v.x, v.y, v.z, false)
				if playerToPlant < PLT.MarkerDistance then bekle = 0
					dist = Plants[v.type].width
					DrawMarker(6,v.x, v.y, v.z  ,0.0, 0.0, 0.0,-90,-90,-90, dist*2,dist*2,dist*2,PLT.MarkerColour.r,PLT.MarkerColour.g,PLT.MarkerColour.b,PLT.MarkerColour.alpha,false, true, 2, false, false, false, false) 
					if playerToPlant < dist  and math.max(v.z,playerCoord.z) - math.min(v.z,playerCoord.z) < 2  then
						if playerToPlant < dist and not DisableActions and not waitForNewFocus then
							onPlant = true
							if activePlantID ~= k then activePlantID = k RefreshNui() end
							SpammingNotify(U["press_action"]..k)
							if IsControlPressed(0,46)  and not v.onAction then
								NuiFocus = true
								RefreshNui()
								SetNuiFocus(true, true)
							end
						end
					end
				end
			end
		end
		if onPlant == false and activePlantID ~= false then  activePlantID = false  SendNUIMessage({show = false})  if NuiFocus then setNuiFocusFalse() end RefreshNui() end
		Citizen.Wait(bekle)
	end
end)  

local canEnter = true

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	if GetInvokingResource() then return end
    if Bucket == 0 then
        canEnter = true
    else
        canEnter = false
    end
end)

RegisterNetEvent('plt_plants:CanNewPlants')
AddEventHandler('plt_plants:CanNewPlants', function(plantName)
	playerCoord = GetEntityCoords(playerPedId)
	local groundZ = playerCoord.z-GetEntityHeightAboveGround(playerPedId)
	if not IsPedOnFoot(playerPedId) then singleNotify("error",U["cant_like_on_foot"]) return end
	if IsEntityInWater(playerPedId) then singleNotify("error",U["cant_inwater"]) return end
	if PLT.Plants[plantName].OnlyOutOfCity and closeToCity(playerCoord) then singleNotify("error", U["go_outof_city"]) return end
	if (math.max(playerCoord.z,groundZ) - math.min(playerCoord.z,groundZ)) > 2 then singleNotify("error", U["cant_here_z"]) return end
	if IsPointOnRoad(playerCoord.x, playerCoord.y, groundZ, false) then singleNotify("error",U["cant_on_way"]) return end
	if not NearValid() then return ESX.Alert("Shoma Bayad Dar Nazdiki Location Haye Plant Bashid", "info") end
	if not canEnter then return end
	if type(PLT.Plants[plantName].InsideTheAreas) == "table" then
		local plyrInsideArea = false
		local anycoord = false
		for k,v in pairs(PLT.Plants[plantName].InsideTheAreas) do
			if v.coord and v.distance then anycoord = true if GetDistanceBetweenCoords(playerCoord, v.coord, true) < v.distance then plyrInsideArea = true	end	end
		end
		if plyrInsideArea == false and anycoord == true then if PLT.Plants[plantName].InsideTheAreas.notify then singleNotify("error",PLT.Plants[plantName].InsideTheAreas.notify) end return end
	end
	if type(PLT.Plants[plantName].OutsideTheAreas) == "table" then
		local plyrOutsideArea = false
		for k,v in pairs(PLT.Plants[plantName].OutsideTheAreas) do
			if v.coord and v.distance then if GetDistanceBetweenCoords(playerCoord, v.coord, true) < v.distance then plyrOutsideArea = true	end	end
		end
		if plyrOutsideArea == true then if PLT.Plants[plantName].OutsideTheAreas.notify then singleNotify("error",PLT.Plants[plantName].OutsideTheAreas.notify) end return end
	end
	TriggerServerEvent("plt_plants:NewPlant",plantName,vector3(playerCoord.x,playerCoord.y,groundZ))
end)
RegisterNetEvent('plt_plants:DoAnim')
AddEventHandler('plt_plants:DoAnim', function(islem,info,id)
   	while DisableActions do Citizen.Wait(math.random(1000,1500)) end
	ESX.SetPlayerData('isSentenced', true)
	TriggerEvent("Emote:SetBan", true)
	TriggerEvent("dpclothingAbuse", true)
	exports.essentialmode:DisableControl(true)
	DisableActions = true
	playerCoord = GetEntityCoords(playerPedId)
	local actionCoords
	actionCoords =vector3(info.x ,info.y,info.z)
	if islem == "addPlant" or islem == "addFertilizer" then 
		actionCoords =vector3(info.x ,info.y+0.75,info.z)
	else
		SetEntityHeading(PlantList[id].objeId, GetHeadingFromVector_2d(playerCoord.x-info.x,playerCoord.y-info.y))
		actionCoords = vector3(GetEntityCoords(PlantList[id].objeId)["x"] +  GetEntityForwardVector(PlantList[id].objeId)["x"] * 0.8, GetEntityCoords(PlantList[id].objeId)["y"] +  GetEntityForwardVector(PlantList[id].objeId)["y"] * 0.8, info.z) 
	end 
	if #(vec2(actionCoords.x,actionCoords.y)-vec2(0.0,0.0)) < 3 then actionCoords =vector3(info.x ,info.y+0.75,info.z) end
	TaskGoStraightToCoord(playerPedId, actionCoords.x ,actionCoords.y,actionCoords.z, 0.5, 5000, 0.0, 0.5)
	playerCoord = GetEntityCoords(playerPedId)
	rNum = 0 while not (GetDistanceBetweenCoords(playerCoord, actionCoords.x ,actionCoords.y,actionCoords.z, false) < 0.2 ) do Citizen.Wait(10)  
	playerCoord = GetEntityCoords(playerPedId)  rNum = rNum + 1 if rNum > 300 then  SetEntityCoords(GetPlayerPed(-1), actionCoords.x ,actionCoords.y,actionCoords.z, 1,0,0,1) break end end Citizen.Wait(200)
	ClearPedTasks(playerPedId)
	local h = GetHeadingFromVector_2d(info.x-playerCoord.x,info.y-playerCoord.y)
	TaskAchieveHeading(playerPedId,h)
	Citizen.Wait(1250)
	SetEntityHeading(playerPedId, h)
	if islem == "addPlant" then
		animPlant(id)
	elseif islem == "addWater" then
		animWater(id,info)
	elseif islem == "addFertilizer" then
		animFertilizer(id,info,actionCoords)
	elseif islem == "fire" then	
		animFire(id,info)
	elseif islem == "harvest" then	
		animHarvest(id,info)
	end 
	DisableActions = false  
	ESX.SetPlayerData('isSentenced', false)
	TriggerEvent("Emote:SetBan", false)
	TriggerEvent("dpclothingAbuse", false)
	exports.essentialmode:DisableControl(false)
end)
function animPlant(id)
	TaskStartScenarioInPlace(playerPedId, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
	FreezeEntityPosition(playerPedId,true)
	local durum = true 
	Citizen.CreateThread(function()	Citizen.Wait(10000) durum = false end)
	while durum do Citizen.Wait(0) if CancelAnim() == true then durum = "cancel" break end  end
	if durum == "cancel" then TriggerServerEvent("plt_plants:SetAction",id,"delete") end
	ClearPedTasks(playerPedId)
	FreezeEntityPosition(playerPedId,false)
end
function animWater(id,info)
	playerPedId = PlayerPedId()
	playerCoord = GetEntityCoords(playerPedId)
	objeCoords  = vector3(GetEntityCoords(playerPedId)["x"] +  GetEntityForwardVector(playerPedId)["x"] * 0.5, GetEntityCoords(playerPedId)["y"] +  GetEntityForwardVector(playerPedId)["y"] * 0.5, info.z) 
	FreezeEntityPosition(playerPedId,true)
	local bottleObj = CreateObject(GetHashKey("prop_wateringcan"), objeCoords.x , objeCoords.y , objeCoords.z , true, true, true)
	loadAnimDict("random@domestic") 
	TaskPlayAnim(playerPedId, "random@domestic", "pickup_low", 1.0, 1.0, -1, 0, 0, false, false, false)
	Citizen.Wait(750)
	AttachEntityToEntity(bottleObj, playerPedId, GetPedBoneIndex(playerPedId, 28422), 0.07, 0.0, -0.22, 0.0, 30.0, -0.0, 1, 1, 0, 1, 0, 1)
	loadAnimDict("missarmenian3_gardener")
	TaskPlayAnim(playerPedId, "missarmenian3_gardener", "blower_idle_a", 1.0, 1.0, -1, 16, 0, false, false, false)
	local durum = true
	Citizen.CreateThread(function() Citizen.Wait(14000) durum = false end)
 	Citizen.CreateThread(function()
		local ccc RequestNamedPtfxAsset("scr_exile3")	while not HasNamedPtfxAssetLoaded("scr_exile3") do Citizen.Wait(0)end
		while durum == true do 
		 	if not IsEntityPlayingAnim(playerPedId, "missarmenian3_gardener", "blower_idle_a", 3) then 
				loadAnimDict("missarmenian3_gardener")
				TaskPlayAnim(playerPedId, "missarmenian3_gardener", "blower_idle_a", 1.0, 1.0, -1, 16, 0, false, false, false)
			end 
			ccc = GetOffsetFromEntityInWorldCoords(bottleObj, 0.35, 0.0, 0.20)
			UseParticleFxAssetNextCall("scr_exile3")
			StartParticleFxNonLoopedAtCoord("water_splash_ped", ccc.x , ccc.y , ccc.z, 0.0, 0.0, 0.0, 0.2, false, false, false)
			Citizen.Wait(50)
		end
	end) 
	while durum do Citizen.Wait(0)
		--if HasEntityBeenDamagedByAnyPed(bottleObj) then  durum = "cancel"  break end
		--if HasEntityBeenDamagedByAnyPed(playerPedId) then durum = "cancel"  break end
		if CancelAnim() == true then durum = "cancel"  break end
	end
	if durum == false then 	TriggerServerEvent("plt_plants:SetAction",id,"water") ClearPedTasks(playerPedId)
	else TriggerServerEvent("plt_plants:SetFalseOnAction",id) ClearPedTasksImmediately(playerPedId) end	
	DeleteEntity(bottleObj)
	FreezeEntityPosition(playerPedId,false)
end
function animFertilizer(id,info,actCoord)
	playerCoord = GetEntityCoords(playerPedId)
	local actPos = actCoord - vector3(-4.88,-1.95,-0.6)
	actPos =  vector3(actPos.x,actPos.y,playerCoord.z-0.4)
	local scissorsNetID
	local dictBase = "anim@amb@business@meth@meth_monitoring_cooking@cooking@"
	local scissorsModel = GetHashKey("bkr_prop_meth_sacid")
	RequestModel(scissorsModel) while not HasModelLoaded(scissorsModel) do Wait(0) end
	local fertilizerObj = CreateObject(scissorsModel, actCoord.x, actCoord.y, actCoord.z-2, true, true, false)
	DisableCamCollisionForEntity(fertilizerObj)
	SetEntityCollision(fertilizerObj, false, true)
	SetModelAsNoLongerNeeded(scissorsModel)
	scissorsNetID = ObjToNet(fertilizerObj)
	SetNetworkIdExistsOnAllMachines(scissorsNetID, true)
	RequestAnimDict(dictBase)
	while not HasAnimDictLoaded(dictBase) do Wait(0) end
	local netScene = NetworkCreateSynchronisedScene(actPos, 0.0, 0.0, 0.0, 2, 1, 0, 1.0, 0.0, 1.0)
	local netScene2 = NetworkAddPedToSynchronisedScene(PlayerPedId(), netScene, dictBase, "chemical_pour_short_cooker", 1.0, 1.0, 0, 0, 1.0, 0)
	local netScene3 = NetworkAddEntityToSynchronisedScene(NetToEnt(scissorsNetID), netScene, dictBase, "chemical_pour_short_sacid", 1.0, 1.0, 1)
	NetworkStartSynchronisedScene(netScene)
	local durum = true
	Citizen.CreateThread(function()	Citizen.Wait(39000)	durum = false end)
 	Citizen.CreateThread(function()
		local ccc RequestNamedPtfxAsset("des_bigjobdrill")	while not HasNamedPtfxAssetLoaded("des_bigjobdrill") do Citizen.Wait(0)end
		while DisableActions do ccc  = GetOffsetFromEntityInWorldCoords(fertilizerObj, -0.20, 0.0, 0.40)
			if math.abs(GetEntityRotation(fertilizerObj).x) > 80  or math.abs(GetEntityRotation(fertilizerObj).y) > 80 then 
				UseParticleFxAssetNextCall("des_bigjobdrill")
				StartParticleFxNonLoopedAtCoord("ent_ray_big_drill_trail", ccc.x , ccc.y , ccc.z, 0.0, 0.0, 0.0, 0.2, false, false, false)
			end Citizen.Wait(150)
		end
	end) 
	while durum do Citizen.Wait(0)
		--if HasEntityBeenDamagedByAnyPed(fertilizerObj) then  durum = "cancel"  break end
		--if HasEntityBeenDamagedByAnyPed(playerPedId) then durum = "cancel"  break end
		if CancelAnim() == true then durum = "cancel"  break end
	end
	NetworkStartSynchronisedScene(netScene)
	NetworkStartSynchronisedScene(netScene2)
	NetworkStartSynchronisedScene(netScene3)
	DeleteEntity(fertilizerObj)
	if durum == false then 	TriggerServerEvent("plt_plants:SetAction",id,"fertilizer")	ClearPedTasks(playerPedId)
	else TriggerServerEvent("plt_plants:SetFalseOnAction",id) ClearPedTasksImmediately(playerPedId) end	
end
function animFire(id,info)
	RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')  
	while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')do Citizen.Wait(0)	end
	TaskPlayAnim(playerPedId,"anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0, 1.0, -1, 8, -1, true, true, true)
	FreezeEntityPosition(playerPedId,true) 
	local h = GetEntityHeading(playerPedId)
	Citizen.Wait(3500) 
	FreezeEntityPosition(playerPedId,false)
	ClearPedTasks(playerPedId)
	TaskAchieveHeading(playerPedId,h-180)
	Citizen.Wait(1250)
	SetEntityHeading(playerPedId, h-180)
	local newCoord  = vector3(GetEntityCoords(playerPedId)["x"] +  GetEntityForwardVector(playerPedId)["x"] * 3, GetEntityCoords(playerPedId)["y"] +  GetEntityForwardVector(playerPedId)["y"] * 3, info.z) 
	TaskGoStraightToCoord(playerPedId, newCoord.x ,newCoord.y,newCoord.z, 0.5, 5000, 0.0, 0.5)
	Citizen.Wait(2500)
	TaskAchieveHeading(playerPedId, h, 1000)
end
function effectFire(weedCoord)
	local dist = Plants[weedCoord.type].width dist = dist > 1.5 and 1.5 or dist
    RequestNamedPtfxAsset("core")  while not HasNamedPtfxAssetLoaded("core") do Citizen.Wait(1) RequestNamedPtfxAsset("core") end SetPtfxAssetNextCall("core")
	local fire = StartParticleFxLoopedAtCoord("ent_ray_heli_aprtmnt_l_fire",weedCoord.x, weedCoord.y, weedCoord.z , 0.0, 0.0, 0.0, dist/5, false, false, false, false)
	Citizen.Wait(60000) StopParticleFxLooped(fire, 0)
end
function animHarvest(id,info)
	TaskStartScenarioInPlace(playerPedId, "PROP_HUMAN_BUM_BIN", 0, true)
	FreezeEntityPosition(playerPedId,true) 
	local durum = true Citizen.CreateThread(function() Citizen.Wait(15000) durum = false end)
	while durum do Citizen.Wait(0) if CancelAnim() == true then durum = "cancel"  break end end
	if durum == false then TriggerServerEvent("plt_plants:SetAction",id,"harvest") ClearPedTasks(playerPedId)
	else TriggerServerEvent("plt_plants:SetFalseOnAction",id) ClearPedTasksImmediately(playerPedId) end	
	FreezeEntityPosition(playerPedId,false)
end
function CanIFire(coord) return false end--If you want, you can check whether there is a police officer here and make sure that the police can burn the objects in every situation.
function closeToCity(coord)	return GetDistanceBetweenCoords(coord,vector3(-800.00,-900.00,0),false) < 2000 end
function loadAnimDict(dict)	while (not HasAnimDictLoaded(dict)) do RequestAnimDict(dict) Citizen.Wait(0) end end
function loadModel(model)
	if IsModelValid(GetHashKey(model)) then 
		 while not HasModelLoaded(GetHashKey(model)) do	Citizen.Wait(10) RequestModel(model) end 
	else
		singleNotify("error",model.."' prop is not upload on the server. please upload first",25000)
	end
end
function SpammingNotify(msg)SetTextComponentFormat("STRING")AddTextComponentString(msg)DisplayHelpTextFromStringLabel(0,0,1,-1)end
Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
		if DisableActions then 
			DisableControlAction(0, 30, true) -- disable left/right
			DisableControlAction(0, 31, true) -- disable forward/back
			DisableControlAction(0, 36, true) -- INPUT_DUCK
			DisableControlAction(0, 21, true) -- disable sprint
			DisableControlAction(0, 63, true) -- veh turn left
			DisableControlAction(0, 64, true) -- veh turn right
			DisableControlAction(0, 71, true) -- veh forward
			DisableControlAction(0, 72, true) -- veh backwards
			DisableControlAction(0, 75, true) -- disable exit vehicle
			DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
			DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(1, 37, true) -- disable weapon select
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 142, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
		else
			Citizen.Wait(1500)
		end
	end
end)
function CancelAnim() DrawTextCancel()
	if IsControlJustPressed(0, 73) then return true end
	return false
end
function DrawTextCancel()
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(U["press_x_cancel"])
	DrawText(0.4, 0.90)
end
RegisterNetEvent('plt_plants:SendNotify')
AddEventHandler('plt_plants:SendNotify', function(type, message, time)
	ESX.Alert(message, "info")
end)
RegisterCommand("closeplantui", function(source, args, rawCommand)
	setNuiFocusFalse(false)
end, false)
function singleNotify(type, message, time)
	ESX.Alert(message, "info")
end

function NearValid()
	local valid = false
	local Coord = GetEntityCoords(PlayerPedId())
	for k, v in pairs(ValidCoords) do
		if ESX.GetDistance(Coord, v.coord) <= v.radius+5.0 then
			valid = true
		end
	end
	return valid
end

Citizen.CreateThread(function()
	for k, v in pairs(ValidCoords) do
		local blip = AddBlipForRadius(v.coord.x, v.coord.y, v.coord.z, v.radius+20.0)
		local blip2 = AddBlipForCoord(v.coord.x, v.coord.y, v.coord.z)
		SetBlipSprite(blip2, 285)
		SetBlipAsShortRange(blip2, true)
		SetBlipColour(blip2, 2)
		SetBlipScale(blip2, 0.6)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString("Plant Place")
		EndTextCommandSetBlipName(blip2)
		SetBlipAlpha(blip, 80)
		SetBlipColour(blip, 73)
	end
end)

Citizen.CreateThread(function()
	local model = "g_m_y_salvagoon_01"
	
	RequestModel(model)
	
	while not HasModelLoaded(model) do
		Citizen.Wait(100)
	end

	math.randomseed(GetGameTimer())
	DealerPed = CreatePed(4, model, -1273.03,-1418.81,3.35, 217.23)
	SetEntityAsMissionEntity(DealerPed)
	SetBlockingOfNonTemporaryEvents(DealerPed, true)
	Wait(100)
	FreezeEntityPosition(DealerPed, true)
	SetEntityInvincible(DealerPed, true)
	ClearPedTasks(DealerPed)
	TaskStartScenarioInPlace(DealerPed, "WORLD_HUMAN_SMOKING", 0, true)
	SetModelAsNoLongerNeeded(model)
	local blip = AddBlipForCoord(-1273.03,-1418.81,3.35)
	SetBlipSprite(blip, 285)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 2)
	SetBlipScale(blip, 0.6)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString("Planting Shop")
	EndTextCommandSetBlipName(blip)
end)

local ItemMoney = { 
    ['weed_seed'] = 50,
    ['tobacco_seed'] = 50,
    ['strawberry_seed'] = 50,
    ['poppy_seed'] = 50,
    ['mushroom_seed'] = 50,
    ['dragonfruit_seed'] = 50,
    ["fertilizer"] = 200,
    ["water"] = 200,
	["burner"] = 50,
}

function OpenBuyMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_mechanic', {
		title    = 'Planting Buy',
		align    = 'top-left',
		elements = {
			{label = "Bazr Shahdane (50$)", value = "weed_seed"},
			{label = "Bazr Tanbacoo (50$)", value = "tobacco_seed"},
			{label = "Bazr TootFarangi (50$)", value = "strawberry_seed"},
			{label = "Bazr Teryak (50$)", value = "poppy_seed"},
			{label = "Bazr Ghaarch (50$)", value = "mushroom_seed"},
			{label = "Bazr DragonFruit (50$)", value = "dragonfruit_seed"},
			{label = "Kood Giahi (200$)", value = "fertilizer"},
			{label = "Atish Zane (50$)", value = "burner"},
			{label = "Ab (200$)", value = "water"},
		}
	}, function(data, menu)
		if ESX.GetPlayerData().money >= ItemMoney[data.current.value] then
			TriggerServerEvent("esx_planting:getMaterialItem", data.current.value)
			ESX.Alert("Shoma Yek "..data.current.value.." Kharidid", "check")
			menu.close()
			Citizen.Wait(500)
			OpenBuyMenu()
		else
			ESX.Alert("Shoma Pool Kafi Nadarid", "error")
		end
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		local coord = GetEntityCoords(PlayerPedId())
		if #(coord - vector3(-1273.03,-1418.81,3.35)) <= 2.5 then
			last = true
		else
			if last then
				ESX.UI.Menu.CloseAll()
			end
			last = false
			Citizen.Wait(750)
		end
	end
end)

AddEventHandler("onKeyDown", function(key)
	if key == "e" and last then
		OpenBuyMenu()
	end
end)