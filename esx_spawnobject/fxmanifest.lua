lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

version '1.5.0'

description 'SPAWN OBJECT'


client_script "@sr_main/client/def.lua"

server_script "server/sv_main.lua"
client_scripts {
    '@essentialmode/locale.lua',
    'NativeUI.lua',
    'locales/en.lua',
    'config.lua',
    'client/main.lua'
}



shared_script 'alert/config.lua'
client_script 'alert/client.lua'

ui_page 'alert/nui/index.html'
files {
    'alert/nui/*'
}
