Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		DisablePlayerVehicleRewards(PlayerId())
		DisableControlAction(0, 44)
		DisableControlAction(2, 44)
		DisableControlAction(1, 44)
		--[[
		DisplayCash(false)
		DisplayAreaName(false)
		HideHudComponentThisFrame(9) -- Street Name
		HideHudComponentThisFrame(7) -- Street Name
		HideHudComponentThisFrame(4) -- Street Name
		HideHudComponentThisFrame(2) -- Street Name
		HideHudComponentThisFrame(3) -- Street Name
		HideHudComponentThisFrame(6) -- Street Name
		HideHudComponentThisFrame(8) -- Street Name]]
	end
end)