lua54 'yes'
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'gta5' }


client_script "@sr_main/client/def.lua"

client_scripts {
    'shared/config.lua',
    'client/client.lua',
}

server_scripts {
    'shared/config.lua',
    'server/server.lua',
}

client_scripts {
	'deathcam/client/cl_*.lua',
}

files {
    "deathcam/html/index.html",
    "deathcam/html/*.png",
    "deathcam/html/*.svg",
    "deathcam/html/*.css",
}

ui_page "deathcam/html/index.html"