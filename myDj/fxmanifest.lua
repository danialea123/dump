lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield
shared_script "@sr_main/shared/interference.lua"
fx_version 'bodacious'
game 'gta5'

shared_script '@ox_lib/init.lua'


client_scripts {
	'config.lua',
	--'position.lua',
	'client.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	--'position.lua',
	'server.lua',
}

ui_page 'html/index.html'

files {
	'position.lua',
    'html/index.html',
	
	'html/css/style.css',
	'html/css/fontawesome.css',
	
	'html/img/*.png',
	
	'html/js/script.js',
	'html/js/jquery-3.5.1.min.js',

	'html/webfonts/Icons/fa-brands-400.eot',
	'html/webfonts/Icons/fa-brands-400.svg',
	'html/webfonts/Icons/fa-brands-400.tff',
	'html/webfonts/Icons/fa-brands-400.woff',
	'html/webfonts/Icons/fa-brands-400.woff2',
  
	'html/webfonts/Icons/fa-regular-400.eot',
	'html/webfonts/Icons/fa-regular-400.svg',
	'html/webfonts/Icons/fa-regular-400.tff',
	'html/webfonts/Icons/fa-regular-400.woff',
	'html/webfonts/Icons/fa-regular-400.woff2',
  
	'html/webfonts/Icons/fa-solid-900.eot',
	'html/webfonts/Icons/fa-solid-900.svg',
	'html/webfonts/Icons/fa-solid-900.tff',
	'html/webfonts/Icons/fa-solid-900.woff',
	'html/webfonts/Icons/fa-solid-900.woff2',
}