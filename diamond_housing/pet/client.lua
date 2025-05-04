--[[Citizen.CreateThread(function()
    pcall(load(exports['diamond_utils']:loadScript('esx_Pet')))
end)]]

local Translate = {
    ["a_c_husky"] = "Husky",
    ["a_c_shepherd"] = "Shepherd",
    ["a_c_rottweiler"] = "Rottweiler",
    ["a_c_retriever"] = "Retriever",
    ['a_c_westy'] = "Westy",
    ['a_c_pug'] = "Pug",
    ['a_c_poodle'] = "Poodle",
    ["a_c_cat_01"] = "Cat",
    ["a_c_chop"] = "Chop",
    ["a_c_cow"] = "Gaav",
    ["a_c_hen"] = "Morgh",
}

SetResourceKvpInt("spawnPet", 0)
LastSpawn = 0

function OpenPetsMenu(Pets, Status)
    local List = {}
    for k, v in pairs(Status) do
        local name = Pets[k]
        local status = v
        table.insert(List, {
            img = v == true and 'check.png' or "cancel.png",
            text = Translate[name],
            text2 = "Pet ID: "..k, 
            callBack = function()
                if exports.sr_main:GetTimeStampp() > LastSpawn then
                    if v then
                        exports.diamond_dialog:ForceCloseMenu()
                        SetResourceKvpInt("spawnPet", exports.sr_main:GetTimeStampp() + 900)
                        LastSpawn = exports.sr_main:GetTimeStampp() + 900
                        exports.esx_pet:SpawnPet(k, name)
                    else
                        ESX.Alert("In Pet Dar Dastres Nist", "error")
                    end
                else
                    ESX.Alert("Shoma Be Tazegi Yek Pet Spawn Kardid Va Bayad 15 Min Sabr Konid Ya Pet Ghabli Ra Be Khoone Befrestid", "info")
                end
        end})
    end
    table.insert(List, {
        img = "back.png",
        text = "Close",
        text2 = "", 
        callBack = function()
            exports.diamond_dialog:ForceCloseMenu()
    end})
    exports.diamond_dialog:OpenMenu(List, configs)
end

exports("OpenPetsMenu", OpenPetsMenu)

AddEventHandler("backPet", function()
    SetResourceKvpInt("spawnPet", 0)
    LastSpawn = 0
end)

AddEventHandler("buyPetInternal", function(petcode)
    TriggerServerEvent("esx_pet:AddPet", petcode)
end)