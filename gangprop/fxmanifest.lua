lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'



client_script "@sr_main/client/def.lua"

server_scripts {
    '@essentialmode/locale.lua',
    'locales/br.lua',
    'locales/en.lua',
    'locales/fr.lua',
    'locales/es.lua',
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/main.lua'
}

client_scripts {
    '@essentialmode/locale.lua',
    'locales/br.lua',
    'locales/en.lua',
    'locales/fr.lua',
    'locales/es.lua',
    'config.lua',
    'client/main.lua'
}

ui_page "hub/web/build/index.html"
client_script "hub/client/**/*"
server_script {
	'hub/Server/Server.lua',
}

shared_script {
	'@ox_lib/init.lua',
}

files {
    "hub/web/build/index.html",
    "hub/web/build/**/*"
}