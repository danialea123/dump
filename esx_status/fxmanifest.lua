lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/classes/status.lua',
	'client/main.lua'
}

client_scripts {
    'surfing/client/main.lua',
    'surfing/config.lua',
}

files {
    'vehicles.meta',
    'carvariations.meta',
    'carcols.meta',
    'handling.meta',   
	'dlctext.meta',
}

data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'
data_file 'DLC_TEXT_FILE' 'dlctext.meta'