lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

server_exports {
    'BlockAccount',
    'ReleaseAccount'
}

ui_page('client/html/UI.html') 

files {
    'client/html/UI.html',
    'client/html/style.css',
    'client/html/media/font/Bariol_Regular.otf',
    'client/html/media/font/Vision-Black.otf',
    'client/html/media/font/Vision-Bold.otf',
    'client/html/media/font/Vision-Heavy.otf',
    'client/html/media/img/*.*'
}