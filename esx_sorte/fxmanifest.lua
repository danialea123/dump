lua54 'yes'


client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game "gta5"

client_scripts {
	'client/client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}