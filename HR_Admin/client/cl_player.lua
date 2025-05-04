local godmode = false
local infStamina = false
invisibility = false
local noRagDoll = false

-- GODMODE
RegisterNetEvent("skadmin:toggleGodmode")
AddEventHandler("skadmin:toggleGodmode", function()
  godmode = not godmode
  SetEntityInvincible(PlayerPedId(), godmode)
  if godmode then
    drawNotification("~b~God mode activated")
  else
    drawNotification("~r~God mode deactivated")
  end
end)

-- INFINITE STAMINA
RegisterNetEvent("skadmin:toggleInfStamina")
AddEventHandler("skadmin:toggleInfStamina", function()
  infStamina = not infStamina
  if infStamina then
    drawNotification("~b~Infinite Stamina activated")
  else
    drawNotification("~r~Infinite Stamina deactivated")
  end
end)

-- INVISIBILITY
RegisterNetEvent("skadmin:toggleInvisibility")
AddEventHandler("skadmin:toggleInvisibility", function()
  invisibility = not invisibility
  SetEntityVisible(PlayerPedId(), not invisibility, 0)
  SetForcePedFootstepsTracks(invisibility) -- TODO: all players ?!
  if invisibility then
    drawNotification("~b~Invisibility activated")
  else
    drawNotification("~r~Invisibility deactivated")
  end
end)

-- NO RAG DOLL
RegisterNetEvent("skadmin:toggleNoRagDoll")
AddEventHandler("skadmin:toggleNoRagDoll", function()
  noRagDoll = not noRagDoll
  SetPedCanRagdoll( PlayerPedId(), not noRagDoll )
  if noRagDoll then
    drawNotification("~b~No Rag Doll activated")
  else
    drawNotification("~r~No Rag Doll deactivated")
  end
end)