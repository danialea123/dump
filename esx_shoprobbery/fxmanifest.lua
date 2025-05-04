lua54 'yes'
client_script 'validation.lua'

fx_version 'adamant'

game 'gta5'

server_scripts {
	'config.lua',
	'server/server.lua',
	'@oxmysql/lib/MySQL.lua',
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/de.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/client.lua'
}

files {
    'html/index.html'
}

export 'SettingClipboard'

export 'SetClipboard'

ui_page('html/index.html')