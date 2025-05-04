lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
 
game 'gta5' 

version '1.0'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client.lua',
}

server_scripts {
   '@oxmysql/lib/MySQL.lua',
   'server.lua',
}

ui_page 'web/index.html'

files {
    'web/*.html',
    'web/css/*.css',
    'web/js/*.js',
    'web/fonts/*.otf',
    'web/img/*.png',
}
