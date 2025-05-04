Config = {}

Config.ESXFramework = {
	newversion = false, -- use this if you using new esx version (if you get error with old esxsharedobjectmethod in console)
	getsharedobject = "esx:getSharedObject",
	resourcename = "essentialmode",
}

Config.Language = "English"

Config.InterfaceColor = "#ff66ff" -- change interface color, color must be in hex

Config.HotTubSitDistance = 1.0

Config.HotTubCoverManagmentDistance = 1.0

Config.HotTubManagmentDistance = 1.0

Config.CoverManagmentCooldown = 60000

Config.TvCooldown = 5000

Config.ClothesWetting = true

Config.DefaultKeyBindCoverManagment = "E"

Config.DefaultKeyBindHotTubManagment = "G"

Config.DefaultKeyBindSit = "E"

Config.RemoveHottubCommand = "removehottub" -- command for remove hottub

Config.SitNotify = true

Config.HotTubSpawnDuration = 10 -- in seconds

Config.HotTubRemoveDuration = 10 -- in seconds

Config.DisableNozzlesSound = false -- it will disable sound but also particle!

Config.Target = false -- enable this if you want use target and 3d texts

Config.Targettype = "qtarget" -- types - qtarget, qbtarget

Config.TargetIcons = { -- icons must be from fontawesome.com/icons
	["covermanagmenticon"] = "fas fa-box-circle-check", -- Cover Managment Icon 
	["hottubmanagmenticon"] = "fas fa-box-circle-check", -- Hottub Managment Icon
	["siticon"] = "fas fa-box-circle-check", -- Sit Icon
}

Config.LightSpeed = { --in miliseconds
    {lightspeed = 500},
	{lightspeed = 1500},
	{lightspeed = 4500},
}

Config.CustomPedsOffsets = { -- offsets for custom ped models
    {
        pedmodel = "player_one", -- ped model name
		offset = vector3(0.0, 0.0, 0.05),  -- z offset
	},
}

Config.HotTubs = {}

function Notify(text)
	--exports["rtx_notify"]:Notify("HotTub", text, 5000, "info") -- if you get error in this line its because you dont use our notify system buy it here https://rtx.tebex.io/package/5402098 or you can use some other notify system just replace this notify line with your notify system
	--exports["mythic_notify"]:SendAlert("inform", text, 5000)
	TriggerEvent("esx:showNotification", text, "info")
end

function DrawText3D(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords()) 
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 240
		DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 255, 102, 255, 150)
	end
end