lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

description 'esx_ktackle - enables tackling for cops'

version '1.0.0'

server_scripts {
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua',
	'casino/client.lua'
}



client_scripts {
    'autopilot/client/client.lua',
    'autopilot/config.lua'
}

ui_page 'autopilot/nui/index.html'

files {
    'autopilot/nui/index.html',
    'autopilot/nui/script.js',
    'autopilot/nui/style.css',
    'autopilot/nui/assets/**/*',
    'autopilot/nui/mapStyles/**/*'
}