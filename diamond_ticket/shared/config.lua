Config = {
    Debugging = false,

    Locations = {
        ["Loc1"] = {
            Coords = vector4(-554.73,-192.33,38.22,213.31),
            pedModel = 'csb_reporter',
            Manager = {['justice'] = 4},
            Blip = {
                enabled = false,
                Sprite = 270,
                Color = 3,
                Name = "Mission Row PD"
            }
        },
    },
}

DebugPrint = function(...)
    if not Config.Debugging then
        return
    end

    local args<const> = {...}

    local appendStr = ''
    for _, v in ipairs(args) do
        appendStr = appendStr .. ' ' .. tostring(v)
    end

    print(appendStr)
end