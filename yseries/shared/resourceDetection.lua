-- ========================= --
--- Framework Normalization ---
-- ========================= --
if (Config.Framework == 'auto' and GetResourceState('qbx_core') == 'started') or Config.Framework == 'qbox' then
    Config.Framework = 'qbox'
elseif (Config.Framework == 'auto' and GetResourceState('qb-core') == 'started') or Config.Framework == 'qb' then
    Config.Framework = 'qb'
elseif (Config.Framework == 'auto' and GetResourceState('es_extended') == 'started') or Config.Framework == 'esx' then
    Config.Framework = 'esx'
elseif Config.Framework == 'standalone' then
    print(
        "^6[YSERIES] ^1[INFO]^7: shared:resourceDetection.lua: You are using the standalone framework. Make sure to implement the functions in `(client/server)/custom/frameworks/standalone.lua`.")
else
    print(
        "^6[YSERIES] ^1[ERROR]^7: shared:resourceDetection.lua: No framework resource found. Make sure to install one of the supported frameworks or set the Config.Framework to \'standalone\'.")
end
-- ========================= --
--- Framework Normalization ---
-- ========================= --

-- ========================= --
--- Inventory Detection ---
-- ========================= --
if Config.Companies.Banking == 'auto' then
    debugPrint('Auto-detecting banking option...')

    --- A list of supported bankings by default. Do not change this list unless you know what you are doing.
    local bankings = {
        'tgg-banking',
        'okokBanking',
        'Renewed-Banking',
        'qb-banking',
        'esx_addonaccount',
        'qb-management',
    }

    for i = 1, #bankings do
        if GetResourceState(bankings[i]):find('start') then
            Config.Companies.Banking = bankings[i]
            break
        end
    end

    if Config.Companies.Banking == 'auto' then
        print("^6[YSERIES] ^1[ERROR]^7: shared:resourceDetection.lua: No banking resource found. Make sure to install one of the supported bankings.")
        return
    end

    debugPrint('Auto-detected banking option: ' .. Config.Companies.Banking)
end
-- =================== --
--- Banking Detection ---
-- =================== --

-- ========================= --
--- Inventory Detection ---
-- ========================= --
if Config.Item.Inventory == 'auto' then
    debugPrint('Auto-detecting inventory option...')

    --- A list of supported inventories by default. Do not change this list unless you know what you are doing.
    local inventories = {
        'ox_inventory',
        'qb-inventory',
        'lj-inventory',
        'ps-inventory',
        'codem-inventory',
        'core_inventory',
        'tgiann-inventory',
        'qs-inventory',
    }

    for i = 1, #inventories do
        if GetResourceState(inventories[i]):find('start') then
            Config.Item.Inventory = inventories[i]
            break
        end
    end

    if Config.Item.Inventory == 'auto' then
        print("^6[YSERIES] ^1[ERROR]^7: shared:resourceDetection.lua: No inventory resource found. Make sure to install one of the supported inventories.")
        return
    end


    debugPrint('Auto-detected inventory option: ' .. Config.Item.Inventory)
end
-- ===================== --
--- Inventory Detection ---
-- ===================== --

-- ================== --
--- Garage Detection ---
-- ================== --
if Config.Garages == 'auto' then
    debugPrint('Auto-detecting garage option...')

    --- A list of supported garages by default. Do not change this list unless you know what you are doing.
    local garages = {
        'qb-garages',
        'qbx_garages',
        'esx_garage',
        'jg-advancedgarages',
        'vms_garagesv2',
    }

    for i = 1, #garages do
        if GetResourceState(garages[i]):find('start') then
            Config.Garages = garages[i]
            break
        end
    end

    if Config.Garages == 'auto' then
        print("^6[YSERIES] ^1[ERROR]^7: shared:resourceDetection.lua: No garage resource found. Make sure to install one of the supported garages.")
        return
    end


    debugPrint('Auto-detected garage option: ' .. Config.Garages)
end
-- ================== --
--- Garage Detection ---
-- ================== --

-- =================== --
--- Housing Detection ---
-- =================== --
if Config.Housing == 'auto' then
    debugPrint('Auto-detecting housing option...')

    --- A list of supported housings by default. Do not change this list unless you know what you are doing.
    local housings = {
        'qb-houses',
        'ps-housing',
        'flight-housing',
        'bcs_housing',
        'nolag_properties',
    }

    for i = 1, #housings do
        if GetResourceState(housings[i]):find('start') then
            Config.Housing = housings[i]
            break
        end
    end

    if Config.Housing == 'auto' then
        print("^6[YSERIES] ^1[ERROR]^7: shared:resourceDetection.lua: No housing resource found. Make sure to install one of the supported housings.")
        return
    end


    debugPrint('Auto-detected housing option: ' .. Config.Housing)
end
-- =================== --
--- Housing Detection ---
-- =================== --
