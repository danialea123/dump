---@diagnostic disable: undefined-global, missing-parameter, lowercase-global, undefined-field
ESX                           = nil
Ban = false
disableCancelEmote = false
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    -- Wait(5000)
    -- ESX.TriggerServerCallback('dpemote:CheckBan', function(ban)
    --     Ban = ban
    -- end)
end)

Allow = exports.diamond_utils:GetWeapons()

AddEventHandler('sun:clotheLoaded', function()
    if GetResourceKvpString('walk') and GetResourceKvpString('walk') ~= '' and GetResourceKvpString('walk') ~= 'move_m@drunk@verydrunk' then
        WalkMenuStart(GetResourceKvpString('walk'))
    end
    if GetResourceKvpString('mood') and GetResourceKvpString('mood') ~= '' then
        OnEmotePlay(DP.Expressions[GetResourceKvpString('mood')])
    end
end)

-- You probably shouldnt touch these.
local AnimationDuration = -1
local ChosenAnimation = ""
local ChosenDict = ""
local IsInAnimation = false
local MostRecentChosenAnimation = ""
local MostRecentChosenDict = ""
local MovementType = 0
local PlayerGender = "male"
local PlayerHasProp = false
local PlayerProps = {}
local PlayerParticles = {}
local SecondPropEmote = false
local lang = Config.MenuLanguage
local PtfxNotif = false
local PtfxPrompt = false
local PtfxWait = 500
local PtfxNoProp = false
active = true


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    Wait(5000)
    ESX.TriggerServerCallback('dpemote:CheckBan', function(ban)
        Ban = ban
    end)
end)

RegisterNetEvent('Emote:SetBan')
AddEventHandler('Emote:SetBan', function(state)
    Ban = state
end)

function __()
  Citizen.CreateThread(function()
    while IsInAnimation do
      Citizen.Wait(500)
      local hash = GetSelectedPedWeapon(PlayerPedId())
      if IsPedShooting(PlayerPedId()) or (GetSelectedPedWeapon(PlayerPedId()) ~= `WEAPON_UNARMED` and hash ~= 966099553) then
        EmoteCancel()
      end
    end
  end)
end

AddEventHandler("onKeyDown", function(key)
    if key == "f3" then
        if not active then return end
        if Ban then return ESX.Alert('Shoma mahrum az kar ba emote shodid','error') end
        exports.demote:OpenEmoteMenu()
    elseif key == "x" then
        EmoteCancel()
    elseif key == "f" then
        deleteNearObject()
    end
end)

-----------------------------------------------------------------------------------------------------
-- Commands / Events --------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
RegisterNetEvent('dpemote:enable')
AddEventHandler('dpemote:enable', function(state)
    active = state
    mainMenu:Visible(false)
end)


Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/e', 'Play an emote', {{ name="emotename", help="dance, camera, sit or any valid emote."}})
    TriggerEvent('chat:addSuggestion', '/e', 'Play an emote', {{ name="emotename", help="dance, camera, sit or any valid emote."}})
    TriggerEvent('chat:addSuggestion', '/emote', 'Play an emote', {{ name="emotename", help="dance, camera, sit or any valid emote."}})
    if Config.SqlKeybinding then
      TriggerEvent('chat:addSuggestion', '/emotebind', 'Bind an emote', {{ name="key", help="num4, num5, num6, num7. num8, num9. Numpad 4-9!"}, { name="emotename", help="dance, camera, sit or any valid emote."}})
      TriggerEvent('chat:addSuggestion', '/emotebinds', 'Check your currently bound emotes.')
    end
    TriggerEvent('chat:addSuggestion', '/emotemenu', 'Open dpemotes menu (F3) by default.')
    TriggerEvent('chat:addSuggestion', '/emotes', 'List available emotes.')
    TriggerEvent('chat:addSuggestion', '/walk', 'Set your walkingstyle.', {{ name="style", help="/walks for a list of valid styles"}})
    TriggerEvent('chat:addSuggestion', '/walks', 'List available walking styles.')
end)

RegisterCommand('e', function(source, args, raw) if not active then return end EmoteCommandStart(source, args, raw) end)
RegisterCommand('emote', function(source, args, raw) if not active then return end EmoteCommandStart(source, args, raw) end)
if Config.SqlKeybinding then
  RegisterCommand('emotebind', function(source, args, raw) if not active then return end EmoteBindStart(source, args, raw) end)
  RegisterCommand('emotebinds', function(source, args, raw) if not active then return end moteBindsStart(source, args, raw) end)
end
RegisterCommand('emotemenu', function(source, args, raw) if not active then return end exports.demote:OpenEmoteMenu() end)
RegisterCommand('emotes', function(source, args, raw) if not active then return end EmotesOnCommand() end)
RegisterCommand('walk', function(source, args, raw) if not active then return end WalkCommandStart(source, args, raw) end)
RegisterCommand('walks', function(source, args, raw) if not active then return end WalksOnCommand() end)

AddEventHandler('onResourceStop', function(resource)
  if resource == GetCurrentResourceName() then
    DestroyAllProps()
    ClearPedTasksImmediately(GetPlayerPed(-1))
    ResetPedMovementClipset(PlayerPedId())
  end
end)

-----------------------------------------------------------------------------------------------------
------ Functions and stuff --------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

function EmoteCancel()
  if not disableCancelEmote then
    if ChosenDict == "MaleScenario" and IsInAnimation then
      ClearPedTasksImmediately(PlayerPedId())
      IsInAnimation = false
      DebugPrint("Forced scenario exit")
    elseif ChosenDict == "Scenario" and IsInAnimation then
        ClearPedTasksImmediately(PlayerPedId())
        IsInAnimation = false
        DebugPrint("Forced scenario exit")
    end

    PtfxNotif = false
    PtfxPrompt = false

    if IsInAnimation then
        PtfxStop()
        ClearPedTasks(GetPlayerPed(-1))
        DestroyAllProps()
        IsInAnimation = false
    end
    ----
    deleteNearObject()
  end
end

function deleteNearObject()
    local objects,distance = ESX.Game.GetClosestObject()
    if distance < 1 then
        if not Allow[GetEntityModel(objects)] and IsEntityAttachedToAnyPed(objects) and IsEntityAttachedToEntity(objects,PlayerPedId()) and not Entity(objects).state.antiDelete then
            ESX.Game.DeleteObject(objects)
        end
    end
end

function deleteNearObject2()
  local objects,distance = ESX.Game.GetClosestObject()
  if distance < 1 then
      if not Allow[GetEntityModel(objects)] and IsEntityAttachedToAnyPed(objects) and IsEntityAttachedToEntity(objects,PlayerPedId()) and Entity(objects).state.emote then
          ESX.Game.DeleteObject(objects)
      end
  end
end

function EmoteChatMessage(args)
  if args == display then
    TriggerEvent("chatMessage", "^5Help^0", {0,0,0}, string.format(""))
  else
    TriggerEvent("chatMessage", "^5Help^0", {0,0,0}, string.format(""..args..""))
  end
end

function DebugPrint(args)
  if Config.DebugDisplay then
    print(args)
  end
end

function PtfxStart()
    if PtfxNoProp then
      PtfxAt = PlayerPedId()
    else
      PtfxAt = prop
    end
    UseParticleFxAssetNextCall(PtfxAsset)
    Ptfx = StartNetworkedParticleFxLoopedOnEntityBone(PtfxName, PtfxAt, Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, GetEntityBoneIndexByName(PtfxName, "VFX"), 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)
    SetParticleFxLoopedColour(Ptfx, 1.0, 1.0, 1.0)
    table.insert(PlayerParticles, Ptfx)
end

function PtfxStop()
  for a,b in pairs(PlayerParticles) do
    DebugPrint("Stopped PTFX: "..b)
    StopParticleFxLooped(b, false)
    table.remove(PlayerParticles, a)
  end
end

function EmotesOnCommand(source, args, raw)
  local EmotesCommand = ""
  for a in pairsByKeys(DP.Emotes) do
    EmotesCommand = EmotesCommand .. ""..a..", "
  end
  EmoteChatMessage(EmotesCommand)
  EmoteChatMessage(Config.Languages[lang]['emotemenucmd'])
end

function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

function EmoteMenuStart(args, hard)
    local name = args
    local etype = hard

    if etype == "dances" then
        if DP.Dances[name] ~= nil then
          if OnEmotePlay(DP.Dances[name]) then end
        end
    elseif etype == "props" then
        if DP.PropEmotes[name] ~= nil then
          if OnEmotePlay(DP.PropEmotes[name]) then end
        end
    elseif etype == "emotes" then
        if DP.Emotes[name] ~= nil then
          if OnEmotePlay(DP.Emotes[name]) then end
        else
          if name ~= "🕺 Dance Emotes" then end
        end
    elseif etype == "expression" then
        if DP.Expressions[name] ~= nil then
          if OnEmotePlay(DP.Expressions[name]) then end
          SetResourceKvp('mood',name)
        end
    end
end
local cancommand = true
function EmoteCommandStart(source, args, raw)
    if not active or IsPedInAnyVehicle(GetPlayerPed(-1),true) then return end
    if Ban then return ESX.Alert('Shoma mahrum az kar ba emote shodid','error') end
    if not cancommand then 
      TriggerEvent('esx:showNotification', '~r~Lotfan spam emote nakonid!~s~')  
    else
      cancommand = false
      Citizen.SetTimeout(1500,function()
        cancommand = true
      end)
      if #args > 0 then
        local name = string.lower(args[1])
        if name == "c" then
            if IsInAnimation then
                EmoteCancel()
            else
                EmoteChatMessage(Config.Languages[lang]['nocancel'])
            end
          return
        elseif name == "help" then
          EmotesOnCommand()
        return end
    
        if DP.Emotes[name] ~= nil then
          if OnEmotePlay(DP.Emotes[name]) then end return
        elseif DP.Dances[name] ~= nil then
          if OnEmotePlay(DP.Dances[name]) then end return
        elseif DP.PropEmotes[name] ~= nil then
          if OnEmotePlay(DP.PropEmotes[name]) then end return
        elseif DP.Expressions[name] ~= nil then
          if OnEmotePlay(DP.Expressions[name]) then end return
        else
          EmoteChatMessage("'"..name.."' "..Config.Languages[lang]['notvalidemote'].."")
        end
      end
    end
end

function LoadAnim(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Wait(10)
  end
end

function LoadPropDict(model)
  while not HasModelLoaded(GetHashKey(model)) do
    RequestModel(GetHashKey(model))
    Wait(10)
  end
end

function PtfxThis(asset)
  while not HasNamedPtfxAssetLoaded(asset) do
    RequestNamedPtfxAsset(asset)
    Wait(10)
  end
  UseParticleFxAssetNextCall(asset)
end

function DestroyAllProps()
  for _,v in pairs(PlayerProps) do
    if not Allow[GetEntityModel(v)] then
      ESX.Game.DeleteObject(v)
      table.remove(PlayerProps,_)
    end
  end
  PlayerHasProp = false
end

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
  local Player = PlayerPedId()
  local x,y,z = table.unpack(GetEntityCoords(Player))
  PlayerHasProp = true
  if not HasModelLoaded(prop1) then
    LoadPropDict(prop1)
  end
	ESX.Game.SpawnObject(prop1, {
		 x, y, z+0.2
		}, function(obj)
			prop = obj
			AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, prop1 == 'w_am_digiscanner' and 2 or 1, true)
			table.insert(PlayerProps, prop)
			SetModelAsNoLongerNeeded(prop1)
      Entity(prop).state:set('emote',true)
      Citizen.Wait(500)
      NetworkRegisterEntityAsNetworked(obj)
	end)
end

-----------------------------------------------------------------------------------------------------
-- V -- This could be a whole lot better, i tried messing around with "IsPedMale(ped)"
-- V -- But i never really figured it out, if anyone has a better way of gender checking let me know.
-- V -- Since this way doesnt work for ped models.
-- V -- in most cases its better to replace the scenario with an animation bundled with prop instead.
-----------------------------------------------------------------------------------------------------

function CheckGender()
  local hashSkinMale = GetHashKey("mp_m_freemode_01")
  local hashSkinFemale = GetHashKey("mp_f_freemode_01")

  if GetEntityModel(PlayerPedId()) == hashSkinMale then
    PlayerGender = "male"
  elseif GetEntityModel(PlayerPedId()) == hashSkinFemale then
    PlayerGender = "female"
  end
  DebugPrint("Set gender as = ("..PlayerGender..")")
end

-----------------------------------------------------------------------------------------------------
------ This is the major function for playing emotes! -----------------------------------------------
-----------------------------------------------------------------------------------------------------
local ScSpam = false
local tid = 0
function OnEmotePlay(EmoteName,force,xop)
  --exports['essentialmode']:DisableControl(true)
  disableCancelEmote = true
  ESX.ClearTimeout(tid)
  if not xop then
    tid = ESX.SetTimeout(5000,function()
      --exports['essentialmode']:DisableControl(false)
      disableCancelEmote = false
    end)
  end
  if not active then return end
  if IsPedArmed(GetPlayerPed(-1), 7) and not force then
    TriggerEvent('esx:showNotification', '~r~shoma nemitavanid ba aslahe emote bezanid!~s~')  
   return
  end
  InVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
  if not Config.AllowedInCars and InVehicle == 1 then
    return
  end

  if not DoesEntityExist(GetPlayerPed(-1)) then
    return false
  end

  if Config.DisarmPlayer then
    if IsPedArmed(GetPlayerPed(-1), 7) then
      SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
    end
  end
  ChosenDict,ChosenAnimation,ename = table.unpack(EmoteName)
  AnimationDuration = -1
  --cad event
  if ename and string.lower(ename) == 'tablet 2' then
    TriggerEvent('cad:open')
  end
  if ename and string.lower(ename) then
    TriggerEvent('PlayEmote',string.lower(ename))
    TriggerEvent('onPlayEmote',string.lower(ename))
  end
  --
  if PlayerHasProp then
    DestroyAllProps()
  end
  deleteNearObject2()
  if ChosenDict == "Expression" then
    SetFacialIdleAnimOverride(PlayerPedId(), ChosenAnimation, 0)
    return
  end

  if ChosenDict == "MaleScenario" or "Scenario" then 
    CheckGender()
    if ChosenDict == "MaleScenario" then 
      if InVehicle then return end
      if ScSpam then return ESX.Alert('Spam nakonid!') end
      ScSpam = true
      Citizen.SetTimeout(5000,function()
        ScSpam = false
      end)
      if PlayerGender == "male" then
        ClearPedTasks(GetPlayerPed(-1))
        TaskStartScenarioInPlace(GetPlayerPed(-1), ChosenAnimation, 0, true)
        DebugPrint("Playing scenario = ("..ChosenAnimation..")")
        IsInAnimation = true
        __()
      else
        EmoteChatMessage(Config.Languages[lang]['maleonly'])
      end return
    elseif ChosenDict == "ScenarioObject" then 
      if InVehicle then return end
      if ScSpam then return ESX.Alert('Spam nakonid!') end
      ScSpam = true
      Citizen.SetTimeout(5000,function()
        ScSpam = false
      end)
      BehindPlayer = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5);
      ClearPedTasks(GetPlayerPed(-1))
      TaskStartScenarioAtPosition(GetPlayerPed(-1), ChosenAnimation, BehindPlayer['x'], BehindPlayer['y'], BehindPlayer['z'], GetEntityHeading(PlayerPedId()), 0, 1, false)
      DebugPrint("Playing scenario = ("..ChosenAnimation..")")
      IsInAnimation = true
      __()
      return
    elseif ChosenDict == "Scenario" then 
      if InVehicle then return end
      ClearPedTasks(GetPlayerPed(-1))
      TaskStartScenarioInPlace(GetPlayerPed(-1), ChosenAnimation, 0, true)
      DebugPrint("Playing scenario = ("..ChosenAnimation..")")
      IsInAnimation = true
      __()
    return end 
  end

  LoadAnim(ChosenDict)

  if EmoteName.AnimationOptions then
    if EmoteName.AnimationOptions.EmoteLoop then
      MovementType = 1
    if EmoteName.AnimationOptions.EmoteMoving then
      MovementType = 51
  end

  elseif EmoteName.AnimationOptions.EmoteMoving then
    MovementType = 51
  elseif EmoteName.AnimationOptions.EmoteMoving == false then
    MovementType = 0
  elseif EmoteName.AnimationOptions.EmoteStuck then
    MovementType = 50
  end

  else
    MovementType = 0
  end

  if InVehicle == 1 then
    MovementType = 51
  end

  if EmoteName.AnimationOptions then
    if EmoteName.AnimationOptions.EmoteDuration == nil then 
      EmoteName.AnimationOptions.EmoteDuration = -1
      AttachWait = 0
    else
      AnimationDuration = EmoteName.AnimationOptions.EmoteDuration
      AttachWait = EmoteName.AnimationOptions.EmoteDuration
    end

    if EmoteName.AnimationOptions.PtfxAsset then
      PtfxAsset = EmoteName.AnimationOptions.PtfxAsset
      PtfxName = EmoteName.AnimationOptions.PtfxName
      if EmoteName.AnimationOptions.PtfxNoProp then
        PtfxNoProp = EmoteName.AnimationOptions.PtfxNoProp
      else
        PtfxNoProp = false
      end
      Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, PtfxScale = table.unpack(EmoteName.AnimationOptions.PtfxPlacement)
      PtfxInfo = EmoteName.AnimationOptions.PtfxInfo
      PtfxWait = EmoteName.AnimationOptions.PtfxWait
      PtfxNotif = false
      PtfxPrompt = true
      Citizen.CreateThread(function()
        while PtfxPrompt do
          if not PtfxNotif then
              SimpleNotify(PtfxInfo)
              PtfxNotif = true
          end
          if IsControlPressed(0, 47) then
            PtfxStart()
            Wait(PtfxWait)
            PtfxStop()
          end
          Citizen.Wait(10)
        end
      end)
      PtfxThis(PtfxAsset)
    else
      DebugPrint("Ptfx = none")
      PtfxPrompt = false
    end
  end
  TaskPlayAnim(GetPlayerPed(-1), ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
  RemoveAnimDict(ChosenDict)
  IsInAnimation = true
  __()
  MostRecentDict = ChosenDict
  MostRecentAnimation = ChosenAnimation

  if EmoteName.AnimationOptions then
    if EmoteName.AnimationOptions.Prop then
        PropName = EmoteName.AnimationOptions.Prop
        PropBone = EmoteName.AnimationOptions.PropBone
        PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(EmoteName.AnimationOptions.PropPlacement)
        if EmoteName.AnimationOptions.SecondProp then
          SecondPropName = EmoteName.AnimationOptions.SecondProp
          SecondPropBone = EmoteName.AnimationOptions.SecondPropBone
          SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6 = table.unpack(EmoteName.AnimationOptions.SecondPropPlacement)
          SecondPropEmote = true
        else
          SecondPropEmote = false
        end
        Wait(AttachWait)
        AddPropToPlayer(PropName, PropBone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6)
        if SecondPropEmote then
          AddPropToPlayer(SecondPropName, SecondPropBone, SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6)
        end
    end
  end
  return true
end

function PlayEmote(emote,force,xop)
  if force == nil then
    force = false
  end
  OnEmotePlay(DP.Emotes[emote] or DP.PropEmotes[emote],force,xop)
end
exports("PlayEmote", PlayEmote)
exports('cancelEmote',EmoteCancel)