lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'common'
use_experimental_fxv2_oal 'yes'


name 'oxmysql'
author 'Overextended'
version '2.9.1'
license 'LGPL-3.0-or-later'
repository 'https://github.com/overextended/oxmysql.git'
description 'FXServer to MySQL communication via node-mysql2'

dependencies {
    '/server:7290',
}

client_script 'ui.lua'
server_script 'dist/build.js'

files {
	'web/build/index.html',
	'web/build/**/*'
}

ui_page 'web/build/index.html'

provide 'mysql-async'
provide 'ghmattimysql'

convar_category 'OxMySQL' {
	'Configuration',
	{
		{ 'Connection string', 'mysql_connection_string', 'CV_STRING', 'mysql://user:password@localhost/database' },
		{ 'Debug', 'mysql_debug', 'CV_BOOL', 'false' }
	}
}
