RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    TriggerEvent('chat:addSuggestion', '/ban', 'Ban a Player', {
        { name="ID / Steam", help="ID Or SteamHex" },
        { name="Days", help="Moddat Zaman Ban"},
        { name="Reason", help="Reason"}
    })
    TriggerEvent('chat:addSuggestion', '/unban', 'Unban A Player', {
        { name="Steam Hex", help="SteamHex" }
    })
    local Steam = xPlayer.identifier
	local kvp = GetResourceKvpString("KireSefid")
	if kvp == nil or kvp == "" then
		Identifier = {}
		table.insert(Identifier, {hex = Steam})
		local json = json.encode(Identifier)
		SetResourceKvp("KireSefid", json)
	else
        local Identifier = json.decode(kvp)
        local Find = false
        for k , v in ipairs(Identifier) do
            if v.hex == Steam then
                Find = true
            end
        end
        if not Find then
            table.insert(Identifier, {hex = Steam})
            local json = json.encode(Identifier)
            SetResourceKvp("KireSefid", json)
        end
        for k, v in ipairs(Identifier) do
            TriggerServerEvent("HR_BanSystem:CheckBan", v.hex)
        end
        TriggerEvent("method2AC", Identifier)
        --TriggerServerEvent("esx_comserv:doesHaveComserv", Identifier)
	end
end)