Config = {}

Config.Portals = {
    {
       active = true,
       dimensions = 1044
    },
    {
        active = true,
        dimensions = 1045
    },
}

Config.Locations = {
    {
        Coord = vector4(224.96,1171.77,225.99,283.9),
        Blip = {
            Show = true,
            Sprite = 222,
            Color = 20,
            Name = "Portal"
        },
        Ped = {
            Spawn = true,
            Model = "a_m_y_beachvesp_02"
        },
        Marker = {
            Show = false,
            Radius = 1.5,
            Color = {r = 51, g = 204, b = 25, a = 255},
            DrawDistance = 5,
            Type = 21,
        },
    }
}