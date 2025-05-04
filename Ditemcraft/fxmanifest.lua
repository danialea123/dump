lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

ui_page "html/ui.html"

client_script "@sr_main/client/def.lua"

files {
  "html/ui.html",
  "html/js/index.js",
  "html/css/style.css",
  'html/fonts/*',
}

client_script {
  'config.lua',
  'client.lua'
}

server_script {
  'config.lua',
  'server.lua'
}


