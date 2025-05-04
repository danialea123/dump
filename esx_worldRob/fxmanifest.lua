lua54 'yes'
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

---@diagnostic disable: undefined-global
fx_version 'cerulean'
games { 'gta5' }



shared_script 'config.lua'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}