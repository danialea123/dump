lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

server_scripts {
  'config.lua',
  'server/main.lua',
}



client_scripts {
  'config.lua',
  'client/main.lua',
}

ui_page 'menu/ui/ui.html'

client_scripts {
	"menu/client/cl_main.lua"
}

shared_scripts {
	"menu/shared/config.lua"
}

files {
	'menu/ui/css/fonts/*.ttf',
	'menu/ui/ui.html',
	'menu/ui/css/*.css',
	'menu/ui/listener.js',
	'menu/ui/progressbar.js',
	'menu/ui/images/*.png',
	'menu/ui/images/*.gif',
}