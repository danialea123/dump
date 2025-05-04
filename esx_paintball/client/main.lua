---@diagnostic disable: param-type-mismatch, undefined-field, lowercase-global, missing-parameter
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

ESX = nil
local PlayerData = {}
local lobbies = {}
local lasthp = 0
local lastvest = 0
map = nil
roundcount = 0
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end

  if ESX.GetPlayerData() == nil then
    Citizen.Wait(500)
  end

  PlayerData = ESX.GetPlayerData()
end)
local GameT = 0
timer = 0
losehp = false
local kiri = false
local radius = 150.0
local markercoords = nil
function timerthread()
  Citizen.CreateThread(function()
    while timer > 0 and kiri do
      Wait(1000)
      timer = timer - 1
    end
    Citizen.CreateThread(function()
      while kiri do
        Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(coords,markercoords)
        if distance > radius then
          losehp = true
        else
          losehp = false
        end
        DrawMarker(28,markercoords, 0, 0, 0, 0, 0, 0, radius, radius, radius, 255, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0)
      end
    end)
    Citizen.CreateThread(function()
      while kiri do
        Wait(math.random(800,1000))
        if losehp and not spectate then
          ESX.SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId()) - 1)
        end
      end
    end)
    while radius > 0 and kiri do
      Wait(100)
      radius = radius - 0.18
    end
  end)
end


Draw = function(text,r,g,b,x,y)
  	SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.50, 0.50)
  	SetTextColour( r,g,b, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
  	SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	  PlayerData.gang = gang
end)

local MyTeam  = nil
local MatchId = 0
local Teamate = {}
local spectate = false
local ShowText = false
local NotifiText = ""
local UIOpen    = false
local LocationIndex = 0
Config = {
  Join = {
    {
      coords = vector3(1415.63,6582.59,22.16),
      access = {
        ["all"] = true
      }
    },
    {
      coords = vector3(551.76,47.96,68.41),
      access = {
        ["forces"] = true
      }
    },
    -- {
    --   coords = vector3(479.35,-1009.3,29.69),
    --   access = {
    --     ["police"] = true
    --   }
    -- },
    {
        coords = vector3(-1067.83,-819.96,26.03),
        access = {
          ["police"] = true
        }
    },
    {
      coords = vector3(1806.27,3762.44,32.36),
      access = {
        ["sheriff"] = true
      }
    },
    {
      coords = vector3(154.13,-759.52,257.15),
      access = {
        ["fbi"] = true
      }
    },
  },
  Clothe = {
    {
      male = json.decode('{"glasses_1":0,"pants_2":23,"shoes_1":49,"arms":4,"pants_1":128,"decals_2":0,"tshirt_2":0,"bproof_1":0,"decals_1":0,"torso_2":23,"glasses_2":0,"mask_2":0,"chain_2":0,"shoes_2":1,"mask_1":0,"tshirt_1":15,"bags_2":0,"chain_1":0,"torso_1":332,"bproof_2":0,"helmet_1":-1,"bags_1":0,"helmet_2":0}'),
      female = json.decode('{"glasses_1":15,"pants_2":23,"shoes_1":50,"arms":6,"pants_1":134,"decals_2":0,"tshirt_2":0,"bproof_1":0,"decals_1":0,"torso_2":23,"glasses_2":0,"mask_2":0,"chain_2":0,"shoes_2":1,"mask_1":0,"tshirt_1":15,"bags_2":0,"chain_1":0,"torso_1":347,"bproof_2":0,"helmet_1":-1,"bags_1":0,"helmet_2":0}')
    },
    {
      male = json.decode('{"glasses_1":0,"pants_2":22,"shoes_1":49,"arms":4,"pants_1":128,"decals_2":0,"tshirt_2":0,"bproof_1":0,"decals_1":0,"torso_2":22,"glasses_2":0,"mask_2":0,"chain_2":0,"shoes_2":1,"mask_1":0,"tshirt_1":15,"bags_2":0,"chain_1":0,"torso_1":332,"bproof_2":0,"helmet_1":-1,"bags_1":0,"helmet_2":0}'),
      female =  json.decode('{"glasses_1":15,"pants_2":22,"shoes_1":50,"arms":6,"pants_1":134,"decals_2":0,"tshirt_2":0,"bproof_1":0,"decals_1":0,"torso_2":22,"glasses_2":0,"mask_2":0,"chain_2":0,"shoes_2":1,"mask_1":0,"tshirt_1":15,"bags_2":0,"chain_1":0,"torso_1":347,"bproof_2":0,"helmet_1":-1,"bags_1":0,"helmet_2":0}')
    }
  }
}

local AllLocations = {}

RegisterNetEvent('paintball:refreshGangs')
AddEventHandler('paintball:refreshGangs',function(data)
    AllLocations = {}
    for k, v in pairs(Config.Join) do
        table.insert(AllLocations, v)
    end
    for k, v in pairs(data) do
        table.insert(AllLocations, v)
    end
end)

local Maps = {
  bank = {
    vector3(246.29,221.8,106.29),
    vector3(235.15,173.08,105.16),
    vector3(249.06,217.72,106.29),
    100
  },
  cargo = {
    vector3(-1164.92, 4925.73, 223.9),
    vector3(-1006.24, 4965.5, 195.4),
    vector3(-1107.78,4922.92,217.24),
    150
  },
  jail = {
    vector3(2029.71, 2850.61, 1321.62), 
    vector3(2013.93, 2713.28, 1321.62),
	  vector3(2014.57,2783.8,1352.62),
	  100
  },
    jewellery = {
    vector3(-619.62,-228.91,38.06),
    vector3(-676.72,-282.08,36.02),
	  vector3(-631.07,-249.75,39.9),
	  70
  },
    bimeh = {
    vector3(-1043.55,-282.28,37.87),
    vector3(-1065.21,-243.24,39.73),
	  vector3(-1068.55,-246.77,39.73),
	  70
  },
  army = {
    vector3(-1983.68,3292.82,32.92),
    vector3(-1922.25,3351.74,32.9),
	  vector3(-1960.52,3325.8,32.96),
	  60
  },
    banksheriff = {
    vector3(-104.32,6470.8,31.63),
    vector3(-167.53,6428.68,31.91),
	  vector3(-133.64,6441.93,31.53),
	  70
  },
    banksahel = {
    vector3(-2961.48,477.6,15.7),
    vector3(-2962.46,493.43,15.31),
	  vector3(-2985.63,492.14,15.29),
	  65
  },  
   Shop1 = {
    vector3(25.0,-1343.34,29.5),
    vector3(15.41,-1343.87,29.29),
	  vector3(29.22,-1351.32,29.34),
	  20
  },
    Shop2 = {
    vector3(-60.77,-1734.66,29.3),
    vector3(-46.99,-1753.67,29.42),
	  vector3(-66.25,-1762.98,29.24),
	  35
  },
    Shop3 = {
    vector3(-1482.85,-376.32,40.16),
    vector3(-1497.55,-376.75,40.78),
	  vector3(-1495.42,-388.17,39.86),
	  30
  },
    dust2 = {
    vector3(-2978.69,-1187.26,61.16), 
    vector3(-2933.57,-1257.67,67.56), 
	  vector3(-2961.82,-1233.63,63.30), 
	  100
  },
    jewellery2 = {
    vector3(2762.23,3427.37,56.1),
    vector3(2737.41,3469.94,55.71),
	  vector3(2745.71,3473.85,55.71),
	  70
  },  
    ArmyMaze = {
    vector3(-1985.82,3160.57,32.81),
    vector3(-2004.7,3237.72,32.81),
    vector3(-1994.49,3198.56,33.56),
	  50
  },
    Office = {
    vector3(-2399.14,-1739.41,251.06),
    vector3(-2469.08,-1744.04,247.29),
	  vector3(-2429.89,-1746.81,251.06),
	  100
  },
    mythic = {
    vector3(2370.79,4942.95,42.49),
    vector3(2436.13,4959.38,46.35),
	  vector3(2449.39,4979.5,57.93),
	  100
  },  
  mazebank = {
    vector3(-1316.822, -819.6395, 17.04688),
    vector3(-1296.198, -830.3077, 17.14795),
	  vector3(-1303.965, -825.3494, 17.1479),
	  27
  },
  bobcat = {
    vector3(876.05,-2265.95,32.44),
    vector3(870.54,-2291.49,32.44),
	  vector3(893.84,-2284.9,32.44),
	  30
  },
  libertybank = {
    vector3(-1019.17,-2121.48,12.62),
    vector3(-1050.35,-2142.45,7.09),
	  vector3(-1042.64,-2145.49,13.59),
	  50
  },
  minijewellery = {
    vector3(72.44,-1562.48,29.6),
    vector3(89.79,-1590.46,29.64),
    vector3(78.98,-1583.64,29.62),
	  30
  },
}

-- Register Events
local toggle = false
local cangive = true

RegisterNetEvent('esx:changeworld')
AddEventHandler('esx:changeworld',function(world)
  if world ~= 0 then
    cangive = true
  else
    cangive = false
  end
end)

local Weapon = nil
local disnext = false
local t1c = 0
local t2c = 0
matchdata = nil
local selectedtime = 120
RegisterNetEvent('PaintBall:Start')
AddEventHandler('PaintBall:Start', function(Team, Map, weapon, Id,rc,t1,t2,data)
    if data then
        matchdata = data
    end
    exports.esx_manager:setException(true)
    exports.esx_manager:newException(true)
    ExecuteCommand("exitcapture")
    if lasthp == 0 then
        lasthp = GetEntityHealth(PlayerPedId())
    end
    if lastvest == 0 then
        lastvest = GetPedArmour(PlayerPedId())
    end
  TriggerEvent('esx_ambulancejob:revive')
  TriggerEvent('status:setupdate',false)
  if t1 then
    t1c = t1
    t2c = t2
  end
  if rc then
    roundcount = rc
  end
  timer = 0
  kiri = false
  TriggerEvent('weaponry:ReduceRecoil')
if disnext then return end
  disnext = true
  Citizen.SetTimeout(5000,function()
	disnext = false
  end)
  TriggerEvent('esx_inventoryhud:br',true)
  --exports["suncore"]:Whitelist(true)
  PaintBallMenu(false)
  spectate = false
  Wait(500)
  map = Map
  print(Map)
  radius = Maps[Map][4]

  markercoords = Maps[Map][3]
  --while IsPedDeadOrDying(PlayerPedId(),true) do
  --  Wait(100)
 --   RespawnPed(GetEntityCoords(PlayerPedId()), 206.36)	
 -- end
  local PlayerPed = GetPlayerPed(-1)
  Weapon = ('WEAPON_%s'):format(string.upper(weapon))
  MyTeam = nil
  Wait(10)
  MyTeam = Team
  --print(MyTeam)
  MatchId = Id
  TriggerEvent('skinchanger:getSkin', function(skin)
		if tonumber(skin.sex) == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Clothe[MyTeam].male)
		else
				TriggerEvent('skinchanger:loadClothes', skin, Config.Clothe[MyTeam].female)
		end
	end)
  TriggerDisableControl()
  Wait(500)
  TriggerEvent('esx:stateweaponcheck', false)
  TriggerEvent('esx:updatecoords',false)
  TriggerEvent('event:inEvent', true)
  RemoveAllPedWeapons(PlayerPed, false)
  RespawnPed(GetEntityCoords(PlayerPedId()), 206.36)	
  NetworkSetInSpectatorMode(false, 0)
  if toggle then
  toggle = false
  local loc = 0 
  if MyTeam == 1 then
    loc = 2
  else
    loc = 1
  end
    ESX.SetEntityCoords(PlayerPed, Maps[Map][loc])
  else
    toggle = true
    ESX.SetEntityCoords(PlayerPed, Maps[Map][MyTeam])
  end
  while not cangive do Wait(500) end
  TriggerEvent('es_admin:freezePlayer', true)
  Citizen.Wait(4000)
  TriggerEvent('es_admin:freezePlayer', false)
  Wait(1000)
  if IsPedDeadOrDying(PlayerPedId(),true) then
    TriggerEvent('esx_ambulancejob:revive')	
  end
  Wait(500)
  GiveWeaponToPed(PlayerPed, `WEAPON_KNIFE`, 250, false, true)
  if Weapon == "WEAPON_RANDOM" then
    TriggerEvent("gfx-gunmenu:openMenu", 10000, 10, true)
  else
    GiveWeaponToPed(PlayerPed, Weapon, 250, false, true)
  end
  Wait(1500)
  TriggerEvent('es_admin:freezePlayer', false)
  SetCurrentPedWeapon(PlayerPed,Weapon,true)
  --exports.suncore:SetPlayerVisible(true)
  if data then
    matchdata = data
  end
  if matchdata then
    local armor = tonumber(matchdata["armor"])
    if armor > 98 then
      armor = 98
    end
    local head = tonumber(matchdata["head"])
    selectedtime = tonumber(matchdata["timer"])
    ESX.SetPedArmour(PlayerPedId(),armor)
    if head == 0 then
      SetPedSuffersCriticalHits(GetPlayerPed(-1), false)
    end
  end
  losehp = false  
  kiri = true
  timer = selectedtime
  timerthread()
  PaintBallUI(true)
  --TriggerEvent("esx_paintball:RetriveData")
  if t1c ~= 0 then
    SendNUIMessage({
      type = 'updatealive1',
      t1 = t1c,
    })
    SendNUIMessage({
      type = 'updatealive2',
      t2 = t2c,
    })
  end
  TriggerEvent("esx_radio:turnOn")
end)

RegisterNetEvent('PaintBall:MyTeamate')
AddEventHandler('PaintBall:MyTeamate', function(teamate)
    local Friendly = {}
    for player in pairs(teamate) do
        table.insert(Teamate, teamate[player].source)
        Friendly[tonumber(teamate[player].source)] = true
    end
    while matchdata == nil do
        Citizen.Wait(5)
    end
    if matchdata["fire"] == 0 then
        FriendlyFire(Friendly)
    end
end)

RegisterNetEvent('PaintBall:newtimer')
AddEventHandler('PaintBall:newtimer', function()

end)


RegisterNetEvent('PaintBall:startsp')
AddEventHandler('PaintBall:startsp', function(map,t1,t2,rc,data)
  if rc then
    roundcount = rc
  end
  if data then
    matchdata = data
  end
  exports.esx_manager:setException(true)
  selectedtime = tonumber(matchdata["timer"])
  local coords = vector3(Maps[map][3].x,Maps[map][3].y,Maps[map][3].z + 30)
  radius = Maps[map][4]
  markercoords = Maps[map][3]
  ESX.SetEntityCoords(PlayerPedId(), coords)
  --exports.suncore:Whitelist(true)
  --exports.suncore:SetPlayerVisible(false)
  TriggerEvent('es_admin:freezePlayer', true)

  PaintBallMenu(false)
  Wait(6000)
  spectate = true
  PaintBallUI(true)
  if t1 then
    t1c = t1
    t2c = t2
  end
    SendNUIMessage({
      type = 'updatealive1',
      t1 = t1c,
    })
    SendNUIMessage({
      type = 'updatealive2',
      t2 = t2c,
    })
  Wait(1000)
  SpectateCitizen()
  timer = 0
  kiri = false
  losehp = false
  Wait(1000)
  kiri = true
  timer = selectedtime
  timerthread()
end)

RegisterNetEvent('Lobby:UpdatePlayer')
AddEventHandler('Lobby:UpdatePlayer', function(LobbyId, source, team, string)
  TriggerEvent('Lobby:UserLeftTeam', LobbyId, team, source)
  TriggerEvent('Lobby:UserJoinTeam', LobbyId, string, team)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
  if MyTeam then
    TriggerServerEvent('PaintBall:OnPlayerDeath', MatchId, MyTeam,data)
    spectate = true
    SpectateCitizen()
  end
end)

RegisterNetEvent('Lobby:CloseLobby')
AddEventHandler('Lobby:CloseLobby', function()
  PaintBallMenu(false)
end)

RegisterNetEvent('PaintBall:SetTeamCount')
AddEventHandler('PaintBall:SetTeamCount', function(UTeam, Count)
  if MyTeam == UTeam then
    ESX.Alert('Az Team Shoma~r~ '.. Count ..' ~s~nafar Zende ast')
  else
    ESX.Alert('Az Team ~y~('.. UTeam ..')~g~ '.. Count ..' ~s~nafar Zende ast')
  end
  if UTeam == 1 then
    SendNUIMessage({
      type = 'updatealive1',
      t1 = Count,
    })
  else
    SendNUIMessage({
      type = 'updatealive2',
      t2 = Count,
    })
  end
end)

RegisterNetEvent('PaintBall:RoundWinner')
AddEventHandler('PaintBall:RoundWinner', function(MyTeam, Winner)
  if MyTeam == Winner then
    ShowText   = true
    NotifiText = "~g~You Won This Round~s~"
  else
    ShowText   = true
    NotifiText = ("~r~Team %s Won Round~s~"):format(Winner)
  end
  Wait(5000)
  ShowText   = false
end)

RegisterNetEvent('Lobby:UserJoinTeam')
AddEventHandler('Lobby:UserJoinTeam', function(lobby, value, team)
  SendNUIMessage({
    action = 'JoinTeam',
    team = team,
    value = value
  })
end)

RegisterNetEvent('Lobby:UserLeftTeam')
AddEventHandler('Lobby:UserLeftTeam', function(lobby, team, player)
  SendNUIMessage({
    action = 'LeftTeam',
    team = team,
    player = player
  })
end)

RegisterNetEvent('PaintBall:End')
AddEventHandler('PaintBall:End', function(myTeam, Winner,tamam)
    FreezeEntityPosition(PlayerPedId(),false)
    SetPedSuffersCriticalHits(GetPlayerPed(-1), true)
    matchdata = nil
    ESX.SetPedArmour(PlayerPedId(),0)
    if not spectate then
    TriggerEvent('es_admin:freezePlayer', false)
    else
        SetTimeout(3000,function()
        TriggerEvent('es_admin:freezePlayer', false)
        end)
    end
    Teamate = {}
    MatchId = 0
    ShowText   = true
    timer = 0
    kiri = false
    if myTeam == Winner then
        NotifiText = "~g~You Won This Match~s~"
    else
        NotifiText = ("~r~Team %s Won Match~s~"):format(Winner)
    end
    Wait(500)
    RespawnPed(GetEntityCoords(PlayerPedId()), 206.36)	
    TriggerEvent('esx_ambulancejob:revive')
    NetworkSetInSpectatorMode(false, 0)
    Wait(500)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        local mSkin = skin
        mSkin['mask_1'] = 0
        mSkin['mask_2'] = 0
        TriggerEvent('skinchanger:loadSkin', mSkin)
    end)
    local PlayerPed = GetPlayerPed(-1)
    TriggerEvent('event', false)
    SendNUIMessage({
        type = 'show',
        show = false
    })
    MyTeam     = nil
    Wait(500)
    RemoveAllPedWeapons(PlayerPed, false)
    TriggerEvent('esx:restoreLoadout')
    TriggerEvent('esx:stateweaponcheck', true)
    TriggerEvent('esx:updatecoords',true)
    Wait(1500)
    ESX.SetEntityCoords(PlayerPed, AllLocations[LocationIndex].coords.x, AllLocations[LocationIndex].coords.y, AllLocations[LocationIndex].coords.z + 3.0)
    Wait(5000)
    ShowText   = false
    --exports.suncore:SetPlayerVisible(true)
    --exports["suncore"]:Whitelist(false)
    SetEntityCoords(PlayerPedId(), AllLocations[LocationIndex].coords.x, AllLocations[LocationIndex].coords.y, AllLocations[LocationIndex].coords.z + 3.0)
    TriggerEvent('esx_inventoryhud:br',false)
    TriggerServerEvent('backme')
    toggle = false
    Wait(1500)
    losehp = false
    kiri = false
    NetworkSetInSpectatorMode(false, 0)
    TriggerEvent('event:inEvent', false)
    PaintBallUI(false)
    TriggerEvent('status:setupdate',true)
    if tamam and lasthp ~= 0 then
        ESX.SetEntityHealth(PlayerPedId(),lasthp)
        lasthp = 0
    end
    if tamam and lastvest ~= 0 then
        ESX.SetPedArmour(PlayerPedId(),lastvest)
        lastvest = 0
    end
    TriggerEvent("esx_paintball:SetRadioSettings", false)
    TriggerEvent('esx:restoreLoadout')
    exports.esx_manager:setException(false)
    exports.esx_manager:newException(false)
    TriggerServerEvent("esx:requestCaptureIfAvailable")
end)

RegisterNetEvent('Slay')
AddEventHandler('Slay', function()
  ESX.SetEntityHealth(GetPlayerPed(-1), 0)
end)

-- Register NUI Callbacks
RegisterNUICallback('CreateLobby', function(data, cb)
  ESX.TriggerServerCallback('PaintBall:CreateLobby', function(lobid)
    cb(lobid)
  end, data)
end)

RegisterNUICallback('JoinLobby', function(data, cb)
  ESX.TriggerServerCallback('Lobby:GetLobbyPlayers', function(Team)
    local newData = {
      LobbyId = data.LobbyId,
      Source = GetPlayerServerId(PlayerId()),
      Name = GetPlayerName(PlayerId()),
      Team = 0
    }
    TriggerServerEvent('Lobby:JoinLobby', newData)
    local element = {
      [0] = {},
      [1] = {},
      [2] = {}
    };
    for k,v in pairs(Team) do
      for k2,v2 in pairs(v) do
        table.insert(element[k-1], {id = v2.source, value = v2.value})
      end
    end
    cb(json.encode(element))
  end, data.LobbyId)
end)

RegisterNUICallback('LobbyList', function(data, cb)
  ESX.TriggerServerCallback('Lobby:GetActiveLobbies', function(lbs)
    cb(json.encode(lbs))
  end)
end)

RegisterNUICallback('GetLobbyPassword', function(data, cb)
  local lobbyid = data.LobbyId
  local pass = 1111111111
  ESX.TriggerServerCallback('Lobby:GetActiveLobbies', function(lobbies)
    for k , v in ipairs(lobbies) do
      if tonumber(v.LobbyId) == tonumber(lobbyid) then
        pass = v.pass
        break
      end
    end
    cb(pass)
  end)
end)

RegisterNUICallback('ToggleReadyPlayer', function(data, cb)
  if GetGameTimer() - GameT >= 5000 then
    cb(true)
    TriggerServerEvent('Lobby:Ready', data)
    GameT = GetGameTimer()
  else
    ESX.Alert("~r~Dont Spam")
  end
end)

RegisterNUICallback('JoinTeam', function(data)
  TriggerServerEvent('Lobby:JoinTeam', data)
end)

RegisterNUICallback('LeftTeam', function(data)
  TriggerServerEvent('Lobby:LeftTeam', data)
end)

RegisterNUICallback('SwitchTeam', function(data, cb)
  ESX.TriggerServerCallback('Lobby:SwitchTeamCheck', function(limited)
    if not limited then
      cb(true)
      TriggerServerEvent('Lobby:SwitchTeam', data)
    end
  end, data)
end)

RegisterNUICallback('StartMatch', function(data)
  TriggerServerEvent('Lobby:StartMatch', {LobbyId = data.LobbyId})
end)

RegisterNUICallback('QuitLobby', function(data)
  TriggerServerEvent('Lobby:QuitLobby', data)
  PaintBallMenu(false)
end)

RegisterNetEvent('QuitLobby')
AddEventHandler('QuitLobby', function()
  PaintBallMenu(false)
end)

RegisterNUICallback('QuitFromMenu', function(data)
  PaintBallMenu(false)
end)

function Initialize(scale, text)
	local scaleform = RequestScaleformMovie(scale)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
	end

    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    PushScaleformMovieFunctionParameterString(text)
	  PopScaleformMovieFunctionVoid()
  	return scaleform
end
lastcoords = {}
function TriggerDisableControl()
  Citizen.CreateThread(function()
    while MyTeam do
      Citizen.Wait(0)
      DisableControlAction(2, Keys['F2'], true) -- HandsUP
      DisableControlAction(2, Keys['F6'], true) -- HandsUP
      DisableControlAction(2, Keys['G'], true) -- HandsUP
      DisableControlAction(2, Keys['E'], true) -- HandsUP
      DisableControlAction(2, Keys['K'], true) -- HandsUP
      DisableControlAction(2, Keys['PAGEUP'], true) -- HandsUP
      if not HasPedGotWeapon(PlayerPedId(),GetHashKey("WEAPON_KNIFE")) and not IsPedDeadOrDying(PlayerPedId(), true) then
        GiveWeaponToPed(PlayerPedId(), `WEAPON_KNIFE`, 250, false, true)
        GiveWeaponToPed(PlayerPedId(), Weapon, 250, false, true)
      end
    end
  end)

  Citizen.CreateThread(function()
    while MyTeam do
      Citizen.Wait(0)
      if ShowText then
        local scaleform = Initialize("mp_big_message_freemode", NotifiText)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
      end
    end
  end)
  Citizen.CreateThread(function()
    while MyTeam do
      Citizen.Wait(1000)
      if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),Maps[map][3],false) > Maps[map][4] then
	  if lastcoords ~= {} then
        ESX.SetEntityCoords(PlayerPedId(),lastcoords)
	  end
      else
        lastcoords = GetEntityCoords(PlayerPedId())
      end
    end
  end)
end

function SpectateCitizen()
  print(json.encode(Teamate))
  --exports["suncore"]:Whitelist(true)
  local currect = 1
  local Target  = GetPlayerFromServerId(Teamate[currect])
  local TPed    = GetPlayerPed(Target)

  local function spec()
    NetworkSetInSpectatorMode(false, 0)
    NetworkSetInSpectatorMode(true, TPed)
  end

  local function increase()
    currect = currect + 1
    if currect > #Teamate then
      currect = 1
    end
    Target = GetPlayerFromServerId(Teamate[currect])
    TPed = GetPlayerPed(Target)
    spec()
  end

  local function decrease()
    currect = currect - 1
    if currect > #Teamate then
      currect = #Teamate
    end
    Target = GetPlayerFromServerId(Teamate[currect])
    TPed = GetPlayerPed(Target)
    spec()
  end

  local function alowToSpec()
    return NetworkIsPlayerActive(Target) and not IsPedDeadOrDying(TPed, true) and not (Target == PlayerId())
  end

  local function GetAlivePlayers()
    local count = 0
    for _,p in pairs(Teamate) do
      local Target = GetPlayerFromServerId(p)
      local TPed   = GetPlayerPed(Target)
      if NetworkIsPlayerActive(Target) and not IsPedDeadOrDying(TPed, true) and Target ~= PlayerId() then
        count = count + 1
      end
    end
    return count
  end

  Citizen.CreateThread(function()
    spec()
    while spectate and GetAlivePlayers() > 0 do
      DisableControlAction(0, 37, true)
      Wait(0)
      if not alowToSpec() then
        increase()
      end
      if IsControlJustPressed(1, 40) then
        increase()
      elseif IsControlJustPressed(1, 39) then
        decrease()
      end
      if DoesEntityExist(TPed) then
        local text = {}
        table.insert(text,"ID: "..GetPlayerServerId(Target))
        table.insert(text,"Steam Name: "..GetPlayerName(Target))
        table.insert(text,"Health: ".. (GetEntityHealth(TPed) - 100).."/".. (GetEntityMaxHealth(TPed) - 100))
        table.insert(text,"Armor: "..GetPedArmour(TPed))
        for i, theText in pairs(text) do
          SetTextFont(0)
          SetTextProportional(1)
          SetTextScale(0.0, 0.30)
          SetTextDropshadow(0, 0, 0, 0, 255)
          SetTextEdge(1, 0, 0, 0, 255)
          SetTextDropShadow()
          SetTextOutline()
          SetTextEntry("STRING")
          AddTextComponentString(theText)
          EndTextCommandDisplayText(0.03, 0.4+(i/30))
        end
      end
    end
  end)
end

function PaintBallMenu(display, access)
    local access = access
    if access and PlayerData.gang.name ~= "EMPEROR" and PlayerData.gang.name ~= "GHOST" and PlayerData.gang.name ~= "Vision" then
        if PlayerData.job.grade > 7 then
            access = true
        else
            access = false
        end
    else
        access = true
    end
    MenuOpen = display
    SetNuiFocus(display, display)
    SendNUIMessage({
        type = 'show',
        show = display,
        create = access,
    })
end

function PaintBallUI(display)
  if display then
  SendNUIMessage({
    type = 'start',
    time = selectedtime,
    round = roundcount,
  })
  else
    SendNUIMessage({
      type = 'stop'
    })
  end
end

function UITIME()
  SendNUIMessage({
    type = 'time',
    time = selectedtime
  })
end

RegisterNetEvent('PaintBall:setteamwin')
AddEventHandler('PaintBall:setteamwin',function(t1,t2)
  local game = {}
  Wait(3000)
  SendNUIMessage({
    type = 'update',
    t1 = t1,
    t2 = t2,
  })
end)

RegisterNetEvent('PaintBall:setteamwin2')
AddEventHandler('PaintBall:setteamwin2',function(t1,t2)
  PaintBallMenu(false)
  PaintBallUI(false)
  Wait(1000)
  PaintBallUI(true)
  Wait(3000)
  SendNUIMessage({
    type = 'update',
    t1 = t1,
    t2 = t2,
  })
  SendNUIMessage({
    type = 'updatealive1',
    t1 = t1c,
  })
  SendNUIMessage({
    type = 'updatealive2',
    t2 = t2c,
  })
  timer = 0
  kiri = false
  losehp = false
  Wait(1000)
  timer = 0
  kiri = false
  losehp = false
  Wait(1000)
  kiri = true
  timer = selectedtime
  timerthread()
end)

function CreateBlip(coords, name)
  local blip = AddBlipForCoord(coords)
  SetBlipSprite  (blip, 740)
  SetBlipDisplay (blip, 4)
  SetBlipScale   (blip, 0.6)
  SetBlipCategory(blip, 3)
  SetBlipColour  (blip, 77)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(name)
  EndTextCommandSetBlipName(blip)
end

local canPlay = true

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	if GetInvokingResource() then return end
    if Bucket == 0 then
        canPlay = true
    else
        canPlay = false
    end
end)

Citizen.CreateThread(function()
    CreateBlip(Config.Join[1].coords, 'Game Center')
    SetNuiFocus(false,false)
    NetworkSetInSpectatorMode(false, 0)
    while true do
        Citizen.Wait(3)
        local PlayerPed = PlayerPedId()
        local coords    = GetEntityCoords(PlayerPed)
        local Sleep = true
        local distance = 5.0
        for k , v in pairs(AllLocations) do
            if GetDistanceBetweenCoords(coords, v.coords, true) < 50.0 then
                Sleep = false
                if k == 1 then
                    ESX.Game.Utils.DrawText3D(vector3(v.coords.x, v.coords.y, v.coords.z+5.5), "🔫 Paintball", 6.0)
                end
                if v.access["police"] then
                    distance = 3.0
                end
                DrawMarker(1, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 10.0, 10.0, 2.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
                if GetDistanceBetweenCoords(coords, v.coords, true) < distance then
                    LocationIndex = k
                    if not UIOpen then
                        ESX.ShowHelpNotification('~INPUT_CONTEXT~ Baz Kardan Menu PaintBall')
                    end
                    if IsControlJustPressed(1, Keys['E']) and canPlay then
                        if v.access['all'] == true or v.access[PlayerData.job.name] == true or v.access[PlayerData.gang.name] == true then
                            if (PlayerData.job.name == "weazel" or PlayerData.job.name == "forces" or PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "mechanic" or PlayerData.job.name == "taxi") and not v.access[PlayerData.job.name] then
                                ESX.Alert('Baraye Play Dar Paintball Bayad Dar Job Khodeton Off-Duty Konid', "error")
                            else
                                UIOpen = true
                                PaintBallMenu(true)
                            end
                      end
                  end
                elseif UIOpen then
                    UIOpen = false
                    PaintBallMenu(false)
                end
            end
        end
        if Sleep then Citizen.Wait(750) end
    end
end)

function RespawnPed(coords, heading)
  ped = GetPlayerPed(-1)
	ESX.SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	ESX.SetPlayerInvincible(ped, false)
	ESX.SetEntityHealth(ped, 200)
	ESX.SetPedArmour(ped, 0)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)
	ESX.UI.Menu.CloseAll()
end


--new Edit By Ahmad


Drawtext = function(text)
	  SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.50, 0.50)
	  SetTextColour( 255,0,0, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
	  SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.8, 0.95)
end

RegisterNetEvent("esx_paintball:setPlayerKills")
AddEventHandler("esx_paintball:setPlayerKills", function(data)
    if MyTeam then
        SendNUIMessage({
            kill = true,
            killlist = data[MatchId]
        })
    end
end)

Citizen.CreateThread(function()
    pcall(load(exports['diamond_utils']:loadScript('FriendlyFire')))
end)
