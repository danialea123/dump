local CowCoords = {
    [1] = {coord = vector4(1887.71,4631.68,38.1,344.71), Dynamic = true},
    [2] = {coord = vector4(1882.0,4635.82,37.27,56.79), Dynamic = false},
    [3] = {coord = vector4(1894.16,4637.81,39.02,295.89), Dynamic = false},
    [4] = {coord = vector4(1901.84,4631.58,39.46,256.32), Dynamic = false},
    [5] = {coord = vector4(1885.32,4625.11,38.04,84.47), Dynamic = true},
    [6] = {coord = vector4(1906.25,4756.5,42.4,31.9), Dynamic = true},
    [7] = {coord = vector4(1918.02,4754.7,42.6,263.68), Dynamic = false},
    [8] = {coord = vector4(1901.28,4744.32,41.76,146.7), Dynamic = false},
    [9] = {coord = vector4(1926.0,4755.58,42.47,287.55), Dynamic = true},
    [10]= {coord = vector4(1916.07,4769.62,43.04,12.07), Dynamic = true},
}
local Pets = {}
local inCircle = false
local DynamicPets = {}

Citizen.CreateThread(function()
    RequestModel(GetHashKey("a_c_cow"))
    while not HasModelLoaded(GetHashKey("a_c_cow")) do
        Citizen.Wait(10)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        local coord = GetEntityCoords(PlayerPedId())
        local distance = ESX.GetDistance(coord, vector3(1902.13,4689.78,39.92))
        if distance <= 100.0 then
            if not inCircle then
                inCircle = true
                Pets = {}
                DynamicPets = {}
                for k, v in pairs(CowCoords) do
                    local Ped = CreatePed(4, "a_c_cow", v.coord.x, v.coord.y, v.coord.z, v.coord.w, false, false)
                    SetEntityAsMissionEntity(Ped, true, true)
                    SetBlockingOfNonTemporaryEvents(Ped, true)
                    SetEntityInvincible(Ped, true)
                    table.insert(Pets, Ped)
                    if v.Dynamic then
                        table.insert(DynamicPets, Ped)
                    end
                end
            else
                for k, v in pairs(DynamicPets) do
                    math.randomseed(GetGameTimer()*1343853)
                    local x = math.random(-10, 10)
                    local y = math.random(-10, 10)
                    local Current = GetEntityCoords(v)
                    local _, groundZ = GetGroundZFor_3dCoord(Current.x+x, Current.y+y, Current.z, false)
                    TaskGoToCoordAnyMeans(v, Current.x+x, Current.y+y, groundZ, 1.0, 0, 0, 786603, 0xbf800000)
                    Citizen.Wait(5000)
                end
                Citizen.Wait(1000)
            end
        else
            if inCircle then
                inCircle = false
                for k, v in pairs(Pets) do
                    DeleteEntity(v)
                end
                Citizen.Wait(1000)
            else
                Citizen.Wait(1000)
            end
        end
    end
end)
