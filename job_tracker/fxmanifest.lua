lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

author 'Vojtíík#0016'

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}

exports {
    'goOnDuty',
    'goOffDuty'
}

ui_page "login/ui/index.html"

client_scripts {
	"login/uf_cl.lua"
}

files {
	"login/ui/*.html",
	"login/ui/*.js",
	"login/ui/*.css",
	"login/ui/*.png",
}   