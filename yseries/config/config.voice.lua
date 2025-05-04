Config = Config or {}

Config.Voice = {}
Config.Voice.System = "pma"
--[[
    Supported voice systems:
        * pma: pma-voice - RECOMMENDED
        * mumble: mumble-voip - Not recommended, use pma-voice
        * salty: saltychat - Not recommended, use pma-voice
        * toko: tokovoip - Not recommended, use pma-voice
]]

Config.Voice.HearNearby = true
Config.Voice.CallEffects = false

Config.Radio = {}

Config.Radio.MaxFrequency = 500

Config.Radio.RestrictedChannels = {
    [1] = { -- [ channel ] = { Allowed jobs }
        police = true,
        ambulance = true
    },
}
