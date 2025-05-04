lua54 'yes'
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

client_script 'validation.lua'

-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.

version '1.0.0'
author 'Cfx.re <root@cfx.re>'
description 'Example spawn points for FiveM with a "hipster" model.'
repository 'https://github.com/citizenfx/cfx-server-data'

resource_type 'map' { gameTypes = { ['basic-gamemode'] = true } }

map 'map.lua'

fx_version 'adamant'
game 'gta5'
