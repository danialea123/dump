lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'gta5' }



client_script "@sr_main/client/def.lua"

ui_page 'client/html/ui.html'

files {
	'client/html/ui.html',
	'client/html/ui.js',
	'client/html/audio/*.mp3',
	'client/html/gif/*.gif'
}

client_script 'client/config.lua'
client_script 'client/client.lua'

server_scripts {
	'delivery/server.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'delivery/locales/en.lua',
	'delivery/config.lua',
	'delivery/main.lua'
}


