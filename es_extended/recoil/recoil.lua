local nWeapons = {
    ["WEAPON_STUNGUN"] = 0.01,
    ["WEAPON_FLAREGUN"] = 0.01,
    ["WEAPON_SNSPISTOL"] = 0.035,
    ["WEAPON_SNSPISTOL_MK2"] = 0.025,
    ["WEAPON_PISTOL"] = 0.035,
    ["WEAPON_PISTOL_MK2"] =  0.03,
    ["WEAPON_APPISTOL"] = 0.06,
    ["WEAPON_COMBATPISTOL"] = 0.04,
    ["WEAPON_PISTOL50"] = 0.055,
    ["WEAPON_PISTOLXM3"] = 0.05,
    ["WEAPON_HEAVYPISTOL"] = 0.04,
    ["WEAPON_VINTAGEPISTOL"] = 0.035,
    ["WEAPON_MARKSMANPISTOL"] = 0.04,
    ["WEAPON_REVOLVER"] = 0.045,
    ["WEAPON_REVOLVER_MK2"] = 0.055,
    ["WEAPON_DOUBLEACTION"] = 0.035,
    ["WEAPON_MICROSMG"] = 0.045,
    ["WEAPON_COMBATPDW"] = 0.045,
    ["WEAPON_SMG"] = 0.05,
    ["WEAPON_SMG_MK2"] = 0.045,
    ["WEAPON_ASSAULTSMG"] = 0.055,
    ["WEAPON_MACHINEPISTOL"] = 0.04,
    ["WEAPON_MINISMG"] = 0.055,
    ["WEAPON_MG"] = 0.07,
    ["WEAPON_COMBATMG"] = 0.08,
    ["WEAPON_COMBATMG_MK2"] = 0.085,
    ["WEAPON_ASSAULTRIFLE"] = 0.08,
    ["WEAPON_ASSAULTRIFLE_MK2"] = 0.075,
    ["WEAPON_CARBINERIFLE"] = 0.07,
    ["WEAPON_CARBINERIFLE_MK2"] = 0.065,
    ["WEAPON_ADVANCEDRIFLE"] = 0.065,
    ["WEAPON_GUSENBERG"] = 0.065,
    ["WEAPON_SPECIALCARBINE"] = 0.075,
    ["WEAPON_SPECIALCARBINE_MK2"] = 0.065,
    ["WEAPON_BULLPUPRIFLE"] = 0.065,
    ["WEAPON_BULLPUPRIFLE_MK2"] = 0.06,
    ["WEAPON_TACTICALRIFLE"] = 0.065,
    ["WEAPON_COMPACTRIFLE"] = 0.06,
    ["WEAPON_PUMPSHOTGUN"] = 0.085,
    ["WEAPON_PUMPSHOTGUN_MK2"] = 0.08,
    ["WEAPON_SAWNOFFSHOTGUN"] = 0.07,
    ["WEAPON_ASSAULTSHOTGUN"] = 0.12,
    ["WEAPON_BULLPUPSHOTGUN"] = 0.08,
    ["WEAPON_DBSHOTGUN"] = 0.065,
    ["WEAPON_AUTOSHOTGUN"] = 0.08,
    ["WEAPON_MUSKET"] = 0.045,
    ["WEAPON_HEAVYSHOTGUN"] = 0.13,
    ["WEAPON_SNIPERRIFLE"] = 0.4,
    ["WEAPON_HEAVYSNIPER"] = 0.3,
    ["WEAPON_HEAVYSNIPER_MK2"] = 0.35,
    ["WEAPON_MARKSMANRIFLE_MK2"] = 0.1,
    ["WEAPON_GRENADELAUNCHER"] = 0.08,
    ["WEAPON_RPG"] = 0.9,
    ["WEAPON_HOMINGLAUNCHER"] = 0.9,
    ["WEAPON_MINIGUN"] = 0.20,
    ["WEAPON_RAILGUN"] = 1.0,
    ["WEAPON_COMPACTLAUNCHER"] = 0.08,
    ["WEAPON_FIREWORK"] = 0.5,
    ["WEAPON_MILITARYRIFLE"] = 0.035,
    ["WEAPON_AKVALO1"] = 0.05,
    ["WEAPON_pistolluxe"] = 0.04,
    ["WEAPON_rhrif"] = 0.04,
    ["WEAPON_pistolgold"] = 0.04,
    ["WEAPON_HKG"] = 0.035,
    ["WEAPON_M16G"] = 0.05,
    ["WEAPON_AKDIAMOND"] = 0.055,
    ["WEAPON_DiamondChrome"] = 0.05,
}

local recoils = {
	[453432689] = 0.5, -- PISTOL
	[3219281620] = 0.5, -- PISTOL MK2
	[1593441988] = 0.4, -- COMBAT PISTOL
	[584646201] = 0.6, -- AP PISTOL
	[2578377531] = 0.8, -- PISTOL .50
	[324215364] = 0.4, -- MICRO SMG
	[736523883] = 0.3, -- SMG
	[2024373456] = 0.3, -- SMG MK2
	[4024951519] = 0.3, -- ASSAULT SMG
	[3220176749] = 0.5, -- ASSAULT RIFLE
	[961495388] = 0.4, -- ASSAULT RIFLE MK2
	[2210333304] = 0.3, -- CARBINE RIFLE
	[4208062921] = 0.3, -- CARBINE RIFLE MK2
	[2937143193] = 0.3, -- ADVANCED RIFLE
	[487013001] = 0.6, -- PUMP SHOTGUN
	[1432025498] = 0.6, -- PUMP SHOTGUN MK2
	[2017895192] = 0.9, -- SAWNOFF SHOTGUN
	[3800352039] = 0.6, -- ASSAULT SHOTGUN
	[2640438543] = 0.5, -- BULLPUP SHOTGUN
	[911657153] = 0.3, -- STUN GUN
	[100416529] = 0.7, -- SNIPER RIFLE
	[205991906] = 0.9, -- HEAVY SNIPER
	[177293209] = 0.9, -- HEAVY SNIPER MK2
	[856002082] = 1.2, -- REMOTE SNIPER
	[2726580491] = 1.0, -- GRENADE LAUNCHER
	[1305664598] = 1.0, -- GRENADE LAUNCHER SMOKE
	[2982836145] = 0.0, -- RPG
	[1752584910] = 0.0, -- STINGER
	[1119849093] = 0.01, -- MINIGUN
	[3218215474] = 0.4, -- SNS PISTOL
	[2009644972] = 0.55, -- SNS PISTOL MK2
	[1627465347] = 0.3, -- GUSENBERG
	[3231910285] = 0.4, -- SPECIAL CARBINE
	[-1768145561] = 0.55, -- SPECIAL CARBINE MK2
	[3523564046] = 0.7, -- HEAVY PISTOL
	[2132975508] = 0.3, -- BULLPUP RIFLE
	[-2066285827] = 0.55, -- BULLPUP RIFLE MK2
	[137902532] = 0.6, -- VINTAGE PISTOL
	[-1746263880] = 0.6, -- DOUBLE ACTION REVOLVER
	[2828843422] = 0.9, -- MUSKET
	[984333226] = 0.4, -- HEAVY SHOTGUN
	[3342088282] = 0.5, -- MARKSMAN RIFLE
	[1785463520] = 0.55, -- MARKSMAN RIFLE MK2
	[1672152130] = 0, -- HOMING LAUNCHER
	[1198879012] = 0.9, -- FLARE GUN
	[171789620] = 0.4, -- COMBAT PDW
	[3696079510] = 0.9, -- MARKSMAN PISTOL
  	[1834241177] = 2.4, -- RAILGUN
	[3675956304] = 0.3, -- MACHINE PISTOL
	[3249783761] = 0.8, -- REVOLVER
	[-879347409] = 0.85, -- REVOLVER MK2
	[4019527611] = 0.9, -- DOUBLE BARREL SHOTGUN
	[1649403952] = 0.5, -- COMPACT RIFLE
	[317205821] = 0.4, -- AUTO SHOTGUN
	[125959754] = 0.7, -- COMPACT LAUNCHER

	[tonumber(GetHashKey("WEAPON_PISTOLXM3"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_TACTICALRIFLE"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_MILITARYRIFLE"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_AK1"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_AKVALO1"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_pistolluxe"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_rhrif"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_pistolgold"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_HKG"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_M16G"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_AKDIAMOND"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_DiamondChrome"))] = 0.4, 

	[tonumber(GetHashKey("WEAPON_MG"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_COMBATMG_MK2"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_COMBATMG"))] = 0.4, 
	[tonumber(GetHashKey("WEAPON_MINISMG"))] = 0.5, 
}

local hWeapon = {}

for k,v in pairs(nWeapons) do
	local hash = GetHashKey(k)
	local recoil = v
	hWeapon[hash] = recoil
end

function ManageReticle()
    local ped = GetPlayerPed( -1 )
    local _, hash = GetCurrentPedWeapon( ped, true )
    if not recoils[hash] then 
        ShowHudComponentThisFrame( 0 )
	end 
end

local ReduceRecoil = false

RegisterNetEvent('weaponry:ReduceRecoil')
AddEventHandler('weaponry:ReduceRecoil', function()
	ReduceRecoil = true
	SetTimeout(1000 * 60 * 30, function()
		ReduceRecoil = false
	end)
end)

local PlayerData = {}
local runThread = false

--ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		--TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
	while ESX.GetPlayerData().job == nil do 
		Citizen.Wait(500)
	end
	PlayerData = ESX.GetPlayerData()
	Thread()

	if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "fbi" or PlayerData.Level >= 12 then
		ReduceRecoil = true
		return
	end
	ReduceRecoil = false
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "fbi" then
		ReduceRecoil = true
		return 
	end
	ReduceRecoil = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "fbi" then
		ReduceRecoil = true
		return 
	end
	ReduceRecoil = false
end)

function Thread()
	Citizen.CreateThread(function()
		tv = 0
		while true do
			Citizen.Wait(0)
			local ped = GetPlayerPed( -1 )
			local weapon = GetSelectedPedWeapon(ped)
			if weapon ~= -1569615261 then
				ManageReticle()
				
				if IsPedArmed(ped, 6) then
					DisableControlAction(1, 140, true)
					DisableControlAction(1, 141, true)
					DisableControlAction(1, 142, true)
				end
				
				DisplayAmmoThisFrame(true)
				
				if hWeapon[weapon] then	
					if IsPedShooting(ped) then
						if ReduceRecoil then
							ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', (hWeapon[weapon]/3)*2)
						else
							ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', hWeapon[weapon])
						end
					end
				end

				if recoils[weapon] and recoils[weapon] ~= 0 then
					if IsPedShooting(ped) then
						local hold = ReduceRecoil and ((recoils[weapon]*2)/3) or recoils[weapon]
						if not (tv >= hold) then
							p = GetGameplayCamRelativePitch()
							if GetFollowPedCamViewMode() ~= 4 then
								SetGameplayCamRelativePitch(p+0.1, 0.2)
							end
							tv = tv+0.1
						end
					else
						tv = 0
					end
				end
				
				if weapon == GetHashKey("WEAPON_FIREEXTINGUISHER") then		
					if IsPedShooting(ped) then
						SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_FIREEXTINGUISHER"))
					end
				end

				if weapon == GetHashKey("WEAPON_MINIGUN") then		
					if IsPedShooting(ped) then
						SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_MINIGUN"))
					end
				end
			else
				Citizen.Wait(750)
			end
		end
	end)
end