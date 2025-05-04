lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'


client_script "@sr_main/client/def.lua"

server_scripts {
    'server/main.lua', 
}

this_is_a_map 'yes'

client_scripts {
    'client/main.lua',
    'client/pc.lua',
    "stream/main.lua"
}

client_scripts {
  'game/main.lua',
}

ui_page {
  'html/index.html'
}

files {
  'html/index.html',
  'html/style.css',
  'html/app.js'
}

