---@diagnostic disable: undefined-global, inject-field
local Charset = {}

for i = 48,  57 do table.insert(Charset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

local VehicleNames = json.decode(LoadResourceFile(GetCurrentResourceName(), 'shared/data/vehicle_names.json'))

ESX.GetRandomString = function(length)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return ESX.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

ESX.GetConfig = function()
	return Config
end

ESX.FirstToUpper = function(str)
    return (str:gsub("^%l", string.upper))
end

ESX.GetWeaponList = function()
	return Config.Weapons
end

ESX.CopyTable = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

ESX.GetVehicleLabelFromName = function(data)
	local name = data:lower()
	if name then
		return VehicleNames["names"][name] or VehicleNames["names"][data] or "Unknown"
	end
end

ESX.GetVehicleLabelFromHash = function(data)
	local hash = tostring(data)
	local result = "Unknown"

	if data and VehicleNames["hashes"][hash] then
		return VehicleNames["hashes"][hash]
	end

	for k, v in pairs(VehicleNames["names"]) do
		if tostring(GetHashKey(k)) == hash or tostring(GetHashKey(k:lower())) == hash then
			result = v
			break
		end
	end

	return result
end

ESX.GetRandomSerial = function(pas)
	local serial = (pas or 'UK') .. '-' .. math.random(1,99) .. math.random(10000,999999) .. math.random(1000,9999)
	return serial
end

ESX.GetWeaponLabel = function(weaponName)
	weaponName = string.upper(weaponName)

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			return v.label
		end
	end

	return nil
end

ESX.GetWeaponName = function(hash)
	local weapons = ESX.GetWeaponList()

	for i=1, #weapons, 1 do
		if weapons[i].hash == hash then
			return weapons[i].name, weapons[i].label, weapons[i].components or {}
		end
	end

	return "no_name", "no name"
end

ESX.GetWeaponComponent = function(weaponName, weaponComponent)
	weaponName = string.upper(weaponName)
	local weapons = Config.Weapons

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			for k2,v2 in ipairs(v.components) do
				if v2.name == weaponComponent then
					return v2
				end
			end
		end
	end
end

ESX.GetWeapon = function(weaponName)
	weaponName = string.upper(weaponName)

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			return k, v
		end
	end
end

ESX.GetWeaponFromHash = function(weaponHash)
	for k,v in ipairs(Config.Weapons) do
		if GetHashKey(v.name) == weaponHash then
			return v
		end
	end
end

ESX.TableContainsValue = function(table, value)
	for k, v in pairs(table) do
		if v == value then
			return true
		end
	end

	return false
end

ESX.TableConcat = function(t1,t2)
    for i=1, #t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

ESX.TableClone = function(table)
	local tempTable = {}
	for k,v in pairs(table) do
	 	tempTable[k] = v
	end
	return tempTable
end

ESX.dump = function(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. ESX.dump(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

ESX.Round = function(value, numDecimalPlaces)
	return ESX.Math.Round(value, numDecimalPlaces)
end

ESX.GetDistance = function(vec1,vec2)
	if vec1 and vec2 then
		return #(vec1 - vec2)
	end
end

ESX.IsPlateValid = function(str)
	if not str then return false end
	if type(str) ~= "string" then return false end
	if string.len(str) == 0 then return false end
	local isEng = true
	for c in str:gmatch"." do
		if c ~= " " and not c:match("^[a-zA-Z0-9]+$") then
			isEng = false
			break
		end
	end
	if isEng then
		isEng = false
		for c in str:gmatch"." do
			if c:match("^[a-zA-Z0-9]+$") then
				isEng = true
				break
			end
		end
	end
	return isEng  
end

ESX.RepeatCode = function(cb, count, timeout)
	CreateThread(function()
		local i = 1
		repeat
			Wait(timeout)
			cb()
			i += 1
		until i > count
	end)
end