lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'

game 'gta5'


ui_page {
	'web/UI.html'
}


files {
	'web/style.css',
    'web/UI.html',
    'web/main.js',
	'web/*.png',
}

client_script "@sr_main/client/def.lua"
shared_script 'config.lua'
server_scripts {
	'server.lua',
	
}
client_scripts {
	'client.lua',
	'computer.lua',
	'ghofl.lua'
}