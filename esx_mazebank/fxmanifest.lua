lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

dependency 'essentialmode'
dependency 'esx_blowtorch'


shared_script '@ox_lib/init.lua'


client_script "@sr_main/client/def.lua"

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/es.lua',
	'config.lua',
	'client/client.lua'
}

server_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/es.lua',
	'config.lua',
	'server/server.lua'
}

ui_page 'redeem/html/ui.html'

client_scripts {
	'redeem/client.lua',
}

server_scripts {
	'redeem/server.lua',
}

files {
	'redeem/event.json',
	'redeem/html/ui.html',
	'redeem/html/*.css',
	'redeem/html/*.js',
	'redeem/html/img/*.png',
	'redeem/html/img/*.jpg',
	'redeem/html/img/*.svg',
}
