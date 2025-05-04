lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'


client_scripts{
    'client/main.lua'
}

server_script 'server/main.lua'

ui_page('client/html/index.html')

files {
    'client/html/index.html',
    'client/html/sounds/*.ogg'
}