lua54 'yes'


client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

client_scripts {
    'client/utils.lua',
    'client/presets.lua',
    'client/client.lua',
    'client/bigScreen.lua',
    'client/screens/*.lua'
}

server_scripts {
    'server/server.lua'
}