lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

description 'ESX RP Chat'

version '1.0.0'


client_script "@sr_main/client/def.lua"

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/script.js',
    'html/style.css',
    'html/img/*.png',
}

client_scripts{
  'client/main.lua',
  'client/badge.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/main.lua'
}