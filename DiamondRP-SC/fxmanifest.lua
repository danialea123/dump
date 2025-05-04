lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield
shared_script "@sr_main/shared/interference.lua"
fx_version 'adamant'
game 'gta5'
author 'AlaviOne#0327'

client_script "@sr_main/client/def.lua"
server_scripts {
    'server/main.lua',
    
}

client_scripts {
    'client/main.lua',
}
ui_page {
	'web/ui.html'
}
files {
	'web/css/style.css',
    'web/ui.html',
    'web/js/script.js',
	'web/img/*.png',
}