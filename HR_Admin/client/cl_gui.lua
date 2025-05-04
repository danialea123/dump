---@diagnostic disable: lowercase-global
local aduty = false
local godmode = false
local infinite_stamina = false
local invisibility = false
local noRagDoll = false
local noclip = false

PlayersCache = {}
lastspec = 0

RegisterNetEvent('esx:adminAduty')
AddEventHandler('esx:adminAduty', function(bool)
  aduty = bool
end)

RegisterNetEvent('esx:adminLoaded')
AddEventHandler('esx:adminLoaded', function()
    ESX.TriggerServerCallback('SRAdmin:GetActivePlayers', function(players)
        PlayersCache = players
        Admini()
        AddEventHandler("onKeyUP", function(key)
            if key == "f4" then
                if aduty and not WarMenu.IsAnyMenuOpened() then
                    WarMenu.OpenMenu('main')
                    AdminMenu()
                else
                    WarMenu.CloseMenu()
                end
            end
        end)
    end)
end)

function Admini()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            lastStamp = exports.sr_main:GetTimeStampp()
        end
    end)
    Citizen.CreateThread(function()
        while true do
            ESX.TriggerServerCallback('SRAdmin:GetNewPlayers', function(players)
                newCache = players
            end)
            Citizen.Wait(20000)
        end
    end)
end

RegisterNetEvent('SRAdmin:PlayerJoined')
AddEventHandler('SRAdmin:PlayerJoined', function(source, name)
  PlayersCache[source] = name
end)

RegisterNetEvent('SRAdmin:PlayerLeft')
AddEventHandler('SRAdmin:PlayerLeft', function(source)
  PlayersCache[source] = nil
end)

function GetLast(table)
  local last = 0
  for c in pairs(table) do
    if c > last then
      last = c
    end
  end
  return last
end

Citizen.CreateThread(function ()
  WarMenu.CreateMenu('main', 'Diamond Admin')
  WarMenu.CreateSubMenu('spectate', 'main', 'Spectate Players')
  WarMenu.CreateSubMenu('teleport_player', 'main', 'Teleport to Players')
  WarMenu.CreateSubMenu('player_menu', 'main', 'Admin Menu')
  WarMenu.CreateSubMenu('newplayer', 'main', 'NewPlayers')
end)

function AdminMenu()
  local mOpen = false
  -- ---------------------------------------------------------------------
  -- MAIN MENU
  -- ---------------------------------------------------------------------
  if WarMenu.IsMenuOpened('main') then
    mOpen = true
    WarMenu.MenuButton('Spectate Menu', 'spectate')
    WarMenu.MenuButton('Teleport to player', 'teleport_player')
    WarMenu.MenuButton('Player Menu', 'player_menu')
    WarMenu.MenuButton('NewPlayers', 'newplayer')

    WarMenu.Display()
  -- ---------------------------------------------------------------------
  -- PLAYER MENU
  -- ---------------------------------------------------------------------
  elseif WarMenu.IsMenuOpened('player_menu') then
    mOpen = true
    if WarMenu.CheckBox("Infinite Stamina", infinite_stamina, function(checked) infinite_stamina = checked end) then
      TriggerServerEvent("skadmin:svtoggleInfStamina")
    elseif WarMenu.CheckBox("Invisibility", invisibility, function(checked) invisibility = checked end) then
      TriggerServerEvent("skadmin:svtoggleInvisibility", invisibility, aduty)
    elseif WarMenu.CheckBox("No Rag Doll", noRagDoll, function(checked) noRagDoll = checked end) then
      TriggerServerEvent("skadmin:svtoggleNoRagDoll")
    elseif WarMenu.CheckBox("Noclip", noclip, function(checked) noclip = checked end) then
      TriggerEvent("SRAdmin:ToggleNoclip")
    end
    WarMenu.Display()
  -- ---------------------------------------------------------------------
  -- SPECTATE PLAYER
  -- ---------------------------------------------------------------------
  elseif WarMenu.IsMenuOpened('spectate') then
    mOpen = true
    for i=1, GetLast(PlayersCache) do
      if PlayersCache[i] then
        if WarMenu.CheckBox("["..i.."] "..PlayersCache[i], spec[i], function(checked) spec[i] = checked end) then
          if spec[i] then
            spec[lastspec] = false
            lastspec = i
            spectate(lastspec)
          else
            lastspec = 0
            resetNormalCamera()
          end
        end
      end
    end
    WarMenu.Display()
    elseif WarMenu.IsMenuOpened('newplayer') then
        mOpen = true
        for i=1, GetLast(newCache) do
        if newCache[i] then
            if WarMenu.CheckBox("["..i.."] "..newCache[i], spec[i], function(checked) spec[i] = checked end) then
            if spec[i] then
                spec[lastspec] = false
                lastspec = i
                spectate(lastspec)
            else
                lastspec = 0
                resetNormalCamera()
            end
            end
        end
    end
    WarMenu.Display()
  -- ---------------------------------------------------------------------
  -- TELEPORT PLAYER
  -- ---------------------------------------------------------------------
  elseif WarMenu.IsMenuOpened('teleport_player') then
    mOpen = true
    if TargetSpectate then
      WarMenu.CloseMenu()
      teleportToPlayer(TargetSpectate)
      spec[TargetSpectate] = false
      InSpectatorMode = false
      lastspec = 0
      TargetSpectate = nil
    else
      WarMenu.OpenMenu('main')
    end
    WarMenu.Display()
  end
  if mOpen then
    SetTimeout(0, AdminMenu)
  end
end

sp = 0
RegisterNetEvent('SRAdmin:spec')
AddEventHandler('SRAdmin:spec', function(id)
  if id and sp ~= id then
    sp = id
    spectate(id)
  else
    sp = 0
    resetNormalCamera()
  end
end)