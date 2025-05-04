lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'



client_script "@sr_main/client/def.lua"

client_scripts {
    'client/main.lua',
    'client/shop.lua',
}

server_scripts {
    'server/main.lua',
}

shared_script 'config.lua'

server_script "streetlabel/server.lua"

client_scripts {
	'streetlabel/config.lua',
	'streetlabel/client.lua'
}

ui_page('streetlabel/html/index.html')

files({
	'streetlabel/html/index.html',
	'streetlabel/html/listener.js',
	'streetlabel/html/style.css'
})