lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Police Job'

version '1.2.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'essentialmode',
	'esx_billing'
}

client_script "uix/client.lua"

ui_page 'uix/ui/index.html'
files {
	'uix/ui/index.html',
	'uix/ui/*',
	'uix/ui/fonts/*'
}