lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield


fx_version 'cerulean'

game 'gta5'

files {
	'modules/**/file/sv/**/*.*',
}

server_scripts {
	'@chat/async.lua',
	'@essentialmode/locale.lua',
	'include_server.lu*',
	'config.lu*',
	'config_server.lu*',

	--'common/main.lu*',
	'common/functions.lu*',
	
	'server/main.lu*',
	'server/functions.lu*',
	'server/load.lu*',
	'modules/**/config.lu*',
	'modules/**/config_server.lu*',
	'modules/**/common/**/*.lua',
	'modules/**/server/**/*.lua',
}

client_scripts {
	'config.lu*',
	'include.lu*',
	'@essentialmode/locale.lua',
	'common/main.lu*',
	'common/functions.lu*',
	'common/config.lua',
	'common/RealisticVehicleFailure_client.lua',
	'client/load.lu*',
	'client/main.lu*',
	'client/events.lu*',
	'client/functions.lu*',
	'modules/*/config.lu*',
	'modules/**/client/**/config.lua',
	'modules/**/common/**/*.lua',
	'modules/**/client/**/*.lua',
	"common/module.lua",
}

client_script 'client/main.lua'
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

files {
	'vehicles.meta',
	'carvariations.meta',
	'carcols.meta',
	'handling.meta',
}
  
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'
data_file 'HANDLING_FILE' 'handling.meta'
