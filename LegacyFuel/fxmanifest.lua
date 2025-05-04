lua54 'yes'
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-global
fx_version 'bodacious'

game 'gta5'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'source/fuel_server.lua'
}

client_scripts {
	'utils.lua',
	'config.lua',
	'functions/functions_client.lua',
	'source/fuel_client.lua'
}

ui_page 'index.html'

files {
    'css/style.css',
    'pic/*.png',

    'resource/app.js',
	'index.html'
}

exports {
	'GetFuel',
	'SetFuel',
	'fixVehicle',
	'GetStallStats'
}


