lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

description 'Gang Account'

version '1.0.1'


client_script "@sr_main/client/def.lua"

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/classes/addonaccount.lua',
	'server/main.lua'
}

server_scripts {
    'wash/config.lua',
	'wash/server/main.lua'
}

client_scripts {
    'wash/config.lua',
	'wash/client/main.lua'
}

ui_page "wash/html/index.html"
files({
    'wash/html/index.html',
    'wash/html/index.js',
    'wash/html/main.css'
})

dependency 'essentialmode'






