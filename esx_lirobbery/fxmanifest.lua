lua54 'yes'
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

version '1.5.0'
description 'Life Insurance Robbery'


client_script "@sr_main/client/def.lua"

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/client.lua'
}

server_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/server.lua'
}
