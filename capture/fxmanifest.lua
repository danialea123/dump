lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield



fx_version 'cerulean'
game 'gta5'

description 'Capture Script © AJ'

version '1.0.0'


client_script "@sr_main/client/def.lua"

client_scripts{
    'config.lua',
    'client/main.lua'
}

server_scripts {
    'server/client_source.lua',
    'config.lua',
    'server/classes/capture.lua',
    'server/main.lua',
}

ui_page {
    'html/ui.html'
}

files {
    "html/ui.html",
    'html/assets/script.js',
    'html/assets/imgs/benzin.jpg',
    'html/assets/imgs/drug.jpg',
    'html/assets/imgs/weapon.jpg',
    'html/assets/imgs/proccess.png',
    'html/assets/imgs/black_market.jpg'
}