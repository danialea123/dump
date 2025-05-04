lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Society'

version '1.0.4'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'essentialmode',
}

shared_script {
    'pass/config.js'
}
client_scripts {
    'pass/client/client.lua',
    'pass/client/client.js'
}
server_scripts {
    'pass/server/server.lua',
    'pass/server/helpers.js',
    'pass/server/server.js'
}
ui_page ('pass/html/index.html')
files {
    'pass/html/index.html',
    'pass/html/css/main.css',
    'pass/html/js/app.js',
    'pass/html/background/bg.png',
    'pass/html/assets/*.png'
}


