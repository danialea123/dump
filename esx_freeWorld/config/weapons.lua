Weapons = {
    
}

if not IsDuplicityVersion() then
    local Allow = {
        ['advancedrifle'] = "", 
        ['appistol'] = "", 
        ['assaultrifle'] = "", 
        ['assaultrifle_mk2'] = "", 
        ['assaultshotgun'] = "",
        ['assaultsmg'] = "",
        ['autoshotgun'] = "", 
        ['bullpuprifle'] = "",
        ['bullpuprifle_mk2'] = "", 
        ['bullpupshotgun'] = "",
        ['carbinerifle'] = "", 
        ['carbinerifle_mk2'] = "", 
        ['combatmg'] = "", 
        ['combatmg_mk2'] = "", 
        ['combatpdw'] = "", 
        ['combatpistol'] = "", 
        ['compactrifle'] = "", 
        ['dbshotgun'] = "", 
        ['doubleaction'] = "", 
        ['gusenberg'] = "", 
        ['heavypistol'] = "",  
        ['heavyshotgun'] = "", 
        ['heavysniper'] = "",  
        ['heavysniper_mk2'] = "", 
        ['machinepistol'] = "", 
        ['marksmanpistol'] = "", 
        ['marksmanrifle'] = "", 
        ['marksmanrifle_mk2'] = "", 
        ['mg'] = "", 
        ['microsmg'] = "", 
        ['minigun'] = "", 
        ['minismg'] = "", 
        ['musket'] = "", 
        ['pistol'] = "", 
        ['pistol50'] = "", 
        ['pistol_mk2'] = "", 
        ['pumpshotgun'] = "",  
        ['pumpshotgun_mk2'] = "", 
        ['revolver'] = "", 
        ['revolver_mk2'] = "", 
        ['sawnoffshotgun'] = "", 
        ['smg'] = "", 
        ['smg_mk2'] = "", 
        ['snspistol'] = "", 
        ['snspistol_mk2'] = "",  
        ['specialcarbine'] = "", 
        ['specialcarbine_mk2'] = "",  
        ['vintagepistol'] = "", 
    }

    for k, v in pairs(Allow) do
        Allow["WEAPON_"..string.upper(k)] = "WEAPON_"..string.upper(k)
    end
    
    local list = exports.essentialmode:getWeaponList()

    for k, v in pairs(list) do
        if Allow[v.name] then
            Weapons[v.name] = { label = v.label }
        end
    end
end