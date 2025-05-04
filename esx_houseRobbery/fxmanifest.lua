lua54 'yes'
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

---@diagnostic disable: undefined-global
fx_version 'cerulean'

game 'gta5'

author 'DRC Scripts'
description 'DRC HOUSE ROBBERY'

version '1.0.2'



shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}

client_scripts {
    '@esx_laser/client/client.lua',
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

files {
    'locales/*.json'
}