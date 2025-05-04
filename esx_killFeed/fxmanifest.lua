lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'rdr3', 'gta5' }


client_script "@sr_main/client/def.lua"

client_scripts {
    'client/client.lua',
	"client/quest.lua",
	"CatCafe/catcafe.lua",
    "bounce/client.lua",
}

server_scripts {
	'server/server.lua',
	"CatCafe/catcafe_sv.lua",
    "bounce/server.lua",
}

ui_page {
	'html/index.html'
}

files {
	'html/index.html',
	'html/css/main.css',
	'html/js/functions.js',
}

shared_scripts {
    '@ox_lib/init.lua',
    'sky/config.lua',
}

client_scripts {
    'sky/cl_skydiving.lua',
    'sky/bridge/client/**.lua',
}

server_scripts {
    'sky/bridge/server/**.lua',
    'sky/sv_config.lua',
    'sky/sv_skydiving.lua'
}



client_scripts{
    'mic/client/*.lua',
} 

server_scripts{
    'mic/server/*.lua',
} 