lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

client_scripts {
  '@essentialmode/locale.lua',
  'client/*.lua',
  'locales/en.lua'
}

server_scripts {
  '@essentialmode/locale.lua',
  "server/*.lua",
  'locales/en.lua'
}

ui_page {
  'html/index.html'
}

files {
  'html/index.html',
  'html/style.css',
  'html/main.js',
  'html/img/*.png'
}