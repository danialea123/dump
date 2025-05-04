lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'rdr3', 'gta5' }



shared_scripts {
    'config.lua'
}

server_scripts {
	'server.lua'
}

client_scripts {
	'client.lua',
    'editable_functions.lua'
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/css/*.css',
    'nui/js/*.js',
    'nui/fonts/*.woff',
    'nui/fonts/*.woff2',
}

escrow_ignore {
    'config.lua',
    'editable_functions.lua',
    'server.lua',
    '[important]/QBCore[latest-version]/player.lua',
    '[important]/QBCore[old-version]/player.lua',
}

data_file 'DLC_ITYP_REQUEST' 'stream/pets.ytyp'

files {
    'stream/pets.ytyp'
}