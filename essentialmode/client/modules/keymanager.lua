local registeredKeys = {}
local keysHolding = {}
local KeysWhiteList = {["g"] = true, ["t"] = true}
local currentKeysHolding = {}
local isControlsDisabled = false
local blockedkey = {}

RegisterNetEvent("onKeyDown")
RegisterNetEvent("onKeyUP")
RegisterNetEvent("onMultiplePress")

function registerKey(key, type)
	local command = key .. "donttouch"

	if not registeredKeys[key] then
		registeredKeys[key] = true
		RegisterKeyMapping('+' .. command, "Dast nazan", type, key)
	end

	RegisterCommand('+' .. command, function()
		if not IsPauseMenuActive() and (not isControlsDisabled or key == "t") then
			if shouldSendTheKey(key) then
				if not blockedkey[key] then
					TriggerEvent("onKeyDown", key)
					TriggerEvent("KeyDown:"..key)
				end
			end
			table.insert(keysHolding, key)
			currentKeysHolding[key] = true
			if #keysHolding > 1 then
				TriggerEvent("onMultiplePress", currentKeysHolding)
			end
		else
			if shouldSendTheKey(key) then
				if not blockedkey[key] then
					TriggerEvent("onKeyDown2", key)
					TriggerEvent("KeyDown2:"..key)
				end
			end
			table.insert(keysHolding, key)
			currentKeysHolding[key] = true
			if #keysHolding > 1 then
				TriggerEvent("onMultiplePress2", currentKeysHolding)
			end
		end
	end)

	RegisterCommand('-' .. command, function()
		if not IsPauseMenuActive() then
			if not blockedkey[key] then
				TriggerEvent("onKeyUP", key)
				TriggerEvent("KeyUP:"..key)
			end
		else
			if not blockedkey[key] then
				TriggerEvent("onKeyUP2", key)
				TriggerEvent("KeyUP2:"..key)
			end
		end
		if currentKeysHolding[key] then
			removeKey(key)
			currentKeysHolding[key] = nil
		end
	end)
end

function removeKey(key)
	for index, currentKey in ipairs(keysHolding) do
		if currentKey == key then
			table.remove(keysHolding, index)
		end
	end
end

function shouldSendTheKey(key)
	if not ESX then return false end
	if KeysWhiteList[key] then
		return true
	else
		local data = ESX.GetPlayerData()
		if data.HandCuffed ~= 1 then
			return true
		else
			return false
		end
	end
end

local haveToRegister = {
	["e"] = "keyboard",
	["k"] = "keyboard",
	["a"] = "keyboard",
	["d"] = "keyboard",
	["numpad4"] = "keyboard",
	["numpad5"] = "keyboard",
	["numpad6"] = "keyboard",
	["numpad7"] = "keyboard",
	["numpad8"] = "keyboard",
	["numpad9"] = "keyboard",
	["u"] = "keyboard",
	["x"] = "keyboard",
	["l"] = "keyboard",
	["f"] = "keyboard",
	["r"] = "keyboard",
	["lmenu"] = "keyboard",
	["f1"] = "keyboard",
	["f2"] = "keyboard",
	["f3"] = "keyboard",
	["f4"] = "keyboard",
	["f5"] = "keyboard",
	["f6"] = "keyboard",
	["f7"] = "keyboard",
	["f9"] = "keyboard",
	["f10"] = "keyboard",
	["f11"] = "keyboard",
	["escape"] = "keyboard",
	["y"] = "keyboard",
	["g"] = "keyboard",
	["j"] = "keyboard",
	["q"] = "keyboard",
	["comma"] = "keyboard",
	["period"] = "keyboard",
	["minus"] = "keyboard",
	["plus"] = "keyboard",
	["9"] = "keyboard",
	["b"] = "keyboard",
	["t"] = "keyboard",
	['oem_3'] = "keyboard",
	["lcontrol"] = "keyboard",
	["lshift"] = "keyboard",
	["space"] = "keyboard",
	["1"] = "keyboard",
	["2"] = "keyboard",
	["3"] = "keyboard",
	["4"] = "keyboard",
	["5"] = "keyboard",
	["insert"] = "keyboard",
	["delete"] = "keyboard",
	["return"] = "keyboard",
	["back"] = "keyboard",
	["up" ] = "keyboard",
	["right"] = "keyboard",
	["left" ] = "keyboard",
	["down"] = "keyboard",
	["m"] = "keyboard",
	["n"] = "keyboard",
	["mouse_left"] = "mouse_button",
	["mouse_right"] = "mouse_button",
	["iom_wheel_down"] = "mouse_wheel",
	["pagedown"] = "keyboard",
	["end"] = "keyboard",
	["capital"] = "keyboard",
}

for key, type in pairs(haveToRegister) do
	registerKey(key, type)
end

exports("disableallControl", function(status)
	isControlsDisabled = status
	exports.yseries:ToggleDisabled(status)
end)

exports("disablecontrol", function(key,status)
	blockedkey[key]  = status
	if key == "f1" then
		exports.yseries:ToggleDisabled(status)
	end
end)

exports("DisableControl", function(status)
	isControlsDisabled = status
	exports.yseries:ToggleDisabled(status)
end)