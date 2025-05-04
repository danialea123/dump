lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

----------------------------------------------------------------
-- Copyright © 2019 by Guy Shefer
-- Made By: Guy293
-- GitHub: https://github.com/Guy293
-- Fivem Forum: https://forum.fivem.net/u/guy293/
----------------------------------------------------------------

client_script {
	"config.lua",
	"client.lua"
}

client_scripts {
	'pasuemenu/Client/*.lua',
}

server_scripts {
	'pasuemenu/Server/*.lua',
}

ui_page {
	'pasuemenu/html/index.html', 
}

files {
	'pasuemenu/html/index.html',
	'pasuemenu/html/app.js', 
	'pasuemenu/html/style.css',
	'pasuemenu/html/assets/*.*'
}               
