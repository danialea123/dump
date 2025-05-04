lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

description 'ESX Data Store'

version '1.0.2'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/classes/datastore.lua',
	'server/main.lua'
}
client_scripts {
    'pool/config.lua',
    'pool/client/*.lua',
}

server_scripts { 
    'pool/config.lua',
    'pool/server/code.lua',
    'pool/server/run.lua',
}

ui_page('pool/client/html/sound.html')

files {
    'pool/client/html/sound.html',
    'pool/client/html/*.ogg',
}







