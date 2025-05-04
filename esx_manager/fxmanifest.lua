lua54 'yes'
---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-global
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'

games {'gta5'}

-- ui_page 'html/index.html'

-- files {
-- 	'html/index.html'
-- }

client_script 'client.lua'

server_script 'server.lua'

exports {
    'SetPlayerVisible',
    'Whitelist',
    'WhitelistTask',
}

server_export 'adminmsg'
