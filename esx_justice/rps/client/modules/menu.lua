lib.registerContext({
	id = "acceptmenu",
	title = Localess[Configs.Locale]["menu"]["title"],
	canClose = false,
	options = {
		{
			title = Localess[Configs.Locale]["menu"]["menuYes"],
			icon = "fa-solid fa-check",
			event = "vrs-rps:client:RequestAccept",
		},
		{
			title = Localess[Configs.Locale]["menu"]["menuNo"],
			icon = "fa-solid fa-xmark",
			onSelect = function()
			end,
		},
	},
})

RegisterNetEvent("vrs-rps:client:RequestAccept", function()
	TriggerServerEvent("vrs-rps:server:RequestAccept", Requester)
end)
