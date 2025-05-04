CreateThread(function()
    if Config.Garages ~= 'vms_garagesv2' then return end

    debugPrint("Using vms_garagesv2")

    function GetVehicleLabel(model)
        local vehicleLabel = GetDisplayNameFromVehicleModel(model):lower()

        if not vehicleLabel or vehicleLabel == 'null' or vehicleLabel == 'carnotfound' then
            vehicleLabel = 'Unknown'
        else
            local text = GetLabelText(vehicleLabel)
            if text and text:lower() ~= 'null' then
                vehicleLabel = text
            end
        end

        return vehicleLabel
    end

    function FindVehicleByPlate(plate)
        return lib.callback.await('yseries:server:garage:find-vehicle-by-plate', false, plate)
    end

    function MapVehiclesData(vehicles)
        -- * Implement your garage logic here.
        if vehicles then
            for i = 1, #vehicles do
                vehicles[i].vehicle = GetDisplayNameFromVehicleModel(vehicles[i].model):lower()

                vehicles[i].model = GetVehicleLabel(vehicles[i].model)
            end
        end

        return vehicles
    end
end)
