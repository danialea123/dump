lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
games {'gta5'}

description 'WeazelNews Job'
version '2.0.0'


client_script "@sr_main/client/def.lua"

client_scripts{
    '@essentialmode/locale.lua',
	'config.lua',
    'client/main.lua'
}

server_scripts {
    '@essentialmode/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

files {
	'data/vehicles.meta',
	'data/carvariations.meta',
}

data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'

client_script {
    "weapon/config.lua",
	'weapon/client/*.lua',
}

ui_page "weapon/nui/index.html"

files {
	'weapon/nui/**/*'
}

