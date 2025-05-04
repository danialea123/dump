---@diagnostic disable: undefined-field, undefined-global, missing-parameter, lowercase-global
ESX = nil
Weapons = {}
Loaded = false
PlayerData = {}
Toggle = true
response = true
local OnlyOne = {}

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
	ESX.SetPlayerData("gang", gang)
end)

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	PlayerData.World = Bucket
	ESX.SetPlayerData("World", Bucket)
	if Bucket == 0 then
		response = true
		RemoveGears()
	else
		response = false
		RemoveGears()
	end
end)

RegisterNetEvent('capture:CaptureEnded')
AddEventHandler('capture:CaptureEnded', function()
    if GetInvokingResource() then return end
	Toggle = ConfigWeaponBack.Bags[GetEntityModel(PlayerPedId())][GetPedDrawableVariation(PlayerPedId(), 5)]
	if not Toggle then
		SetGears()
	end
end)

RegisterNetEvent('capture:CaptureStarted')
AddEventHandler('capture:CaptureStarted', function()
	if GetInvokingResource() then return end
	RemoveGears()
	Toggle = true
end)

RegisterCommand("weapback", function()
	if ConfigWeaponBack.Bags[GetEntityModel(PlayerPedId())] and ConfigWeaponBack.Bags[GetEntityModel(PlayerPedId())][GetPedDrawableVariation(PlayerPedId(), 5)] then
		RemoveGears()
		Toggle = not Toggle
		ESX.Alert("Weapon Back Toggle Shod", "check")
	else
		ESX.Alert("Shoma Kif Makhsos Nadarid", "info")
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().gang == nil do 
		Citizen.Wait(500)
	end

	ESX.RegisterClientCallback("esx:RemoveAttachedWeapons", function(cb)
		response = false
		RemoveGears()
		cb()
	end)

	PlayerData = ESX.GetPlayerData()

	while not Loaded do
		Citizen.Wait(500)
	end

	while true do

		Citizen.Wait(750)
		local playerPed = PlayerPedId()

		if not Toggle and not IsPedInAnyVehicle(PlayerPedId()) and response then
			for i=1, #ConfigWeaponBack.RealWeapons, 1 do

				local weaponHash = GetHashKey(ConfigWeaponBack.RealWeapons[i].name)
				if HasPedGotWeapon(playerPed, weaponHash, false) then
					local onPlayer = false

					for weaponName, entity in pairs(Weapons) do
						if weaponName == ConfigWeaponBack.RealWeapons[i].name then
							onPlayer = true
							break
						end
					end

					if not onPlayer and weaponHash ~= GetSelectedPedWeapon(playerPed) then
						SetGear(ConfigWeaponBack.RealWeapons[i].name)
					elseif onPlayer and weaponHash == GetSelectedPedWeapon(playerPed) then
						RemoveGear(ConfigWeaponBack.RealWeapons[i].name)
					end
				elseif Weapons[ConfigWeaponBack.RealWeapons[i].name] then
					RemoveGear(ConfigWeaponBack.RealWeapons[i].name)
				end
			end
		else
			RemoveGears()
			Citizen.Wait(750)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7 * 60 * 1000)
		if Loaded and not Toggle then
			deleteNearObject()
			RemoveGears()
			AddGears()
		end
	end
end)	

function AddGears()
	if not Toggle and not IsPedInAnyVehicle(PlayerPedId()) and response then
		for i=1, #ConfigWeaponBack.RealWeapons, 1 do
			local weaponHash = GetHashKey(ConfigWeaponBack.RealWeapons[i].name)
			if HasPedGotWeapon(playerPed, weaponHash, false) then
				local onPlayer = false
				for weaponName, entity in pairs(Weapons) do
					if weaponName == ConfigWeaponBack.RealWeapons[i].name then
						onPlayer = true
						break
					end
				end
				if not onPlayer and weaponHash ~= GetSelectedPedWeapon(playerPed) then
					SetGear(ConfigWeaponBack.RealWeapons[i].name)
				elseif onPlayer and weaponHash == GetSelectedPedWeapon(playerPed) then
					RemoveGear(ConfigWeaponBack.RealWeapons[i].name)
				end
			elseif Weapons[ConfigWeaponBack.RealWeapons[i].name] then
				RemoveGear(ConfigWeaponBack.RealWeapons[i].name)
			end
		end
	else
		RemoveGears()
	end
end

function deleteNearObject()
    local object = GetGamePool("CObject")
	local coords = GetEntityCoords(PlayerPedId())
	for k, v in pairs(object) do
		local distance = #(coords - GetEntityCoords(v))
		local objects = v
		if distance < 1 then
			if IsEntityAttachedToAnyPed(objects) and IsEntityAttachedToEntity(objects,PlayerPedId()) and not Entity(objects).state.antiDelete then
				ESX.Game.DeleteObject(objects)
			end
		end
	end
end

AddEventHandler('PlayerLoadedToGround', function()
--Citizen.CreateThread(function()
	Citizen.Wait(10000)
	Toggle = ConfigWeaponBack.Bags[GetEntityModel(PlayerPedId())][GetPedDrawableVariation(PlayerPedId(), 5)]
	if not Toggle then
		SetGears()
	end
	Loaded = true
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName)
	RemoveGear(weaponName)
end)

-- Remove only one weapon that's on the ped
function RemoveGear(weapon)
	local _Weapons = {}

	for weaponName, entity in pairs(Weapons) do
		if weaponName ~= weapon then
			_Weapons[weaponName] = entity
		else
			ESX.Game.DeleteObject(entity)
		end
	end
	if (OnlyOne['assault'] and OnlyOne['assault'] == weapon) then
		OnlyOne['assault'] = nil
	end
	if (OnlyOne['handguns'] and OnlyOne['handguns'] == weapon) then
		OnlyOne['handguns'] = nil
	end
	Weapons = _Weapons
end

-- Remove all weapons that are on the ped
function RemoveGears()
	for weaponName, entity in pairs(Weapons) do
		ESX.Game.DeleteObject(entity)
	end
	Weapons = {}
	OnlyOne = {}
end

-- Add one weapon on the ped
function SetGear(weapon)
	local bone       = nil
	local boneX      = 0.0
	local boneY      = 0.0
	local boneZ      = 0.0
	local boneXRot   = 0.0
	local boneYRot   = 0.0
	local boneZRot   = 0.0
	local playerPed  = PlayerPedId()
	local model      = nil
	local playerData = ESX.GetPlayerData()
	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))

	for i=1, #ConfigWeaponBack.RealWeapons, 1 do
		if ConfigWeaponBack.RealWeapons[i].name == weapon then
			bone     = ConfigWeaponBack.RealWeapons[i].bone
			boneX    = ConfigWeaponBack.RealWeapons[i].x
			boneY    = ConfigWeaponBack.RealWeapons[i].y
			boneZ    = ConfigWeaponBack.RealWeapons[i].z
			boneXRot = ConfigWeaponBack.RealWeapons[i].xRot
			boneYRot = ConfigWeaponBack.RealWeapons[i].yRot
			boneZRot = ConfigWeaponBack.RealWeapons[i].zRot
			model    = ConfigWeaponBack.RealWeapons[i].model
			if not OnlyOne['assault'] and ConfigWeaponBack.RealWeapons[i].category == "assault" then
				OnlyOne[ConfigWeaponBack.RealWeapons[i].category] = weapon
			end
			if not OnlyOne['handguns'] and ConfigWeaponBack.RealWeapons[i].category == "handguns" then
				OnlyOne[ConfigWeaponBack.RealWeapons[i].category] = weapon
			end
			break
		end
	end
	if (OnlyOne['assault'] and OnlyOne['assault'] == weapon) or (OnlyOne['handguns'] and OnlyOne['handguns'] == weapon) then
		print(OnlyOne['assault'])
		local weaponHash = GetHashKey(weapon)
		ESX.Streaming.RequestWeaponAsset(weaponHash)
		RequestModel(model)
		local object =  CreateObject(model, x, y, z, true, true, true)
		-- local components, tintIndex = GetAttachments(weapon)
		-- SetWeaponObjectTintIndex(object, tintIndex)
		-- for k,v in ipairs(components) do
		-- 	local component = ESX.GetWeaponComponent(weapon, v)
		-- 	GiveWeaponComponentToWeaponObject(object, component.hash)
		-- end
		local boneIndex = GetPedBoneIndex(playerPed, bone)
		local bonePos 	= GetWorldPositionOfEntityBone(playerPed, boneIndex)
		AttachEntityToEntity(object, playerPed, boneIndex, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot, false, false, false, false, 2, true)
		Weapons[weapon] = object
		--NetworkRegisterEntityAsNetworked(object)
	end
end

function GetAttachments(name)
	local comp = {}
	local tint = 0
	for k, v in ipairs(ESX.GetPlayerData().loadout) do
		if v.name == name then
			tint = v.tintIndex
			comp = v.components
			break
		end
	end
	return comp, tint
end

-- Add all the weapons in the xPlayer's loadout
-- on the ped
function SetGears()
	local bone       = nil
	local boneX      = 0.0
	local boneY      = 0.0
	local boneZ      = 0.0
	local boneXRot   = 0.0
	local boneYRot   = 0.0
	local boneZRot   = 0.0
	local playerPed  = PlayerPedId()
	local model      = nil
	local playerData = ESX.GetPlayerData()
	local weapon 	 = nil
	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
	for i=1, #playerData.loadout, 1 do
		
		for j=1, #ConfigWeaponBack.RealWeapons, 1 do
			if ConfigWeaponBack.RealWeapons[j].name == playerData.loadout[i].name then
			
				bone     = ConfigWeaponBack.RealWeapons[j].bone
				boneX    = ConfigWeaponBack.RealWeapons[j].x
				boneY    = ConfigWeaponBack.RealWeapons[j].y
				boneZ    = ConfigWeaponBack.RealWeapons[j].z
				boneXRot = ConfigWeaponBack.RealWeapons[j].xRot
				boneYRot = ConfigWeaponBack.RealWeapons[j].yRot
				boneZRot = ConfigWeaponBack.RealWeapons[j].zRot
				model    = ConfigWeaponBack.RealWeapons[j].model
				weapon   = ConfigWeaponBack.RealWeapons[j].name 
				if not OnlyOne['assault'] and ConfigWeaponBack.RealWeapons[j].category == "assault" then
					OnlyOne[ConfigWeaponBack.RealWeapons[j].category] = weapon
				end
				if not OnlyOne['handguns'] and ConfigWeaponBack.RealWeapons[j].category == "handguns" then
					OnlyOne[ConfigWeaponBack.RealWeapons[j].category] = weapon
				end
				break

			end
		end
		if (OnlyOne['assault'] and OnlyOne['assault'] == weapon) or (OnlyOne['handguns'] and OnlyOne['handguns'] == weapon) then
			local weaponHash = GetHashKey(weapon)
			ESX.Streaming.RequestWeaponAsset(weaponHash)
			RequestModel(model)
			local object =  CreateObject(model, x, y, z, true, true, true)
			-- local components, tintIndex = GetAttachments(weapon)
			-- SetWeaponObjectTintIndex(object, tintIndex)
			-- for k,v in ipairs(components) do
			-- 	local component = ESX.GetWeaponComponent(weapon, v)
			-- 	GiveWeaponComponentToWeaponObject(object, component.hash)
			-- end
			local boneIndex = GetPedBoneIndex(playerPed, bone)
			local bonePos 	= GetWorldPositionOfEntityBone(playerPed, boneIndex)
			AttachEntityToEntity(object, playerPed, boneIndex, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot, false, false, false, false, 2, true)
			Weapons[weapon] = object
			--NetworkRegisterEntityAsNetworked(object)
		end
	end

end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		RemoveGears()
	end
end)