lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

shared_scripts {
    'config/*.lua'
}

client_scripts {
    'client/warmenu.lua',
    'client/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua'
}



shared_scripts {
    'job/config.lua'
}

client_scripts {
    'job/client.lua'
}

server_scripts {
    'job/server.lua'
}

ui_page 'job/ui/index.html'

files {
    'job/ui/index.html',
    'job/ui/style.css',
    'job/ui/script.js',
    'job/ui/fonts/Poppins-Regular.ttf'
}