lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

description 'ESX Addon Account'

version '1.0.1'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/classes/addonaccount.lua',
	'server/main.lua'
}

ui_page 'contract/web/ui.html'

files {
	'contract/web/*.*'
}

shared_script 'contract/config.lua'

client_scripts {
	'contract/client.lua',
}

server_scripts {
	'contract/server.lua'
}



dependency 'essentialmode'






