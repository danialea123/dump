lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'gta5' }

this_is_a_map "yes"


client_script "@sr_main/client/def.lua"

client_scripts {
    'config.lua',
    'client.lua',
}

server_scripts {
    'config.lua',
    'server.lua'
}

client_debug_mode 'false'
server_debug_mode 'false'

-- Leave this set to '0' to prevent compatibility issues 
-- and to keep the save files your users.
experimental_features_enabled '0'

client_scripts {
	'neons/config.lua',
	'neons/client/main.lua'
}

files {
	'neons/html/ui.html',
	'neons/html/styles.css',
	'neons/html/scripts.js',
	'neons/html/debounce.min.js',
	'neons/html/BebasNeue.ttf',
	'neons/html/images/*.png'
}

ui_page 'neons/html/ui.html'     