function WalkMenuStart(name,save)
  if not active then return end
  if name:lower() ~= 'move_m@drunk@verydrunk' and (save == nil or save) then
    SetResourceKvp('walk', name)
  end
  RequestWalking(name)
  SetPedMovementClipset(PlayerPedId(), name, 0.2)
  RemoveAnimSet(name)
end

function RequestWalking(set)
  RequestAnimSet(set)
  while not HasAnimSetLoaded(set) do
    Citizen.Wait(1)
  end 
end

function WalksOnCommand(source, args, raw)
  local WalksCommand = ""
  for a in pairsByKeys(DP.Walks) do
    WalksCommand = WalksCommand .. ""..string.lower(a)..", "
  end
  EmoteChatMessage(WalksCommand)
  EmoteChatMessage("To reset do /walk reset")
end

function WalkCommandStart(source, args, raw)
  local name = firstToUpper(args[1])
  if not active or IsPedInAnyVehicle(GetPlayerPed(-1),true) then 
    name = firstToUpper("Drunk3")
  end

  local name2 = table.unpack(DP.Walks[name])
  if name2 ~= nil then
    WalkMenuStart(name2)
  else
    EmoteChatMessage("'"..name.."' is not a valid walk")
  end
end

exports("Walk", function(name,save)
  if save == nil then
    save = false
  end
  WalkMenuStart(table.unpack(DP.Walks[firstToUpper(name)]),save)
end)
