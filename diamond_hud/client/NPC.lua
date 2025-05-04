DensityMultiplier = 0.1
Citizen.CreateThread(function()
    SetMaxWantedLevel(0)
    SetCreateRandomCops(0)
    SetCreateRandomCopsNotOnScenarios(0)
    SetCreateRandomCopsOnScenarios(0)

    --[[while true do
        Citizen.Wait(0)
        SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
        SetPedDensityMultiplierThisFrame(DensityMultiplier)
        SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
		ClearAreaOfCops(playerCoords.x, playerCoords.y, playerCoords.z, 400.0)
		for i = 1, 12 do
			EnableDispatchService(i, false)
		end
        local playerId = PlayerId()
		SetPlayerWantedLevel(playerId, 0, false)
		SetPlayerWantedLevelNow(playerId, false)
		SetPlayerWantedLevelNoDrop(playerId, 0, false)
    end]]
end)