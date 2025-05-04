lua54 'yes'


client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

server_scripts {
	'translations.lua',
	'shared/shared_utils.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
	'translations.lua',
	'shared/shared_utils.lua',
	'config.lua',
	'client.lua'
}