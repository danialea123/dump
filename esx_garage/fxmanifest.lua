lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version "cerulean"

description "EyesStore"
author "ESCKaybeden#0488"
version '1.0.0'
repository 'https://discord.com/invite/EkwWvFS'



game "gta5"

shared_script 'Customize.lua'

ui_page 'resources/build/index.html'

client_script "client.lua"
server_scripts {
  "@oxmysql/lib/MySQL.lua",
  "@mysql-async/lib/MySQL.lua",
  "server.lua"
}

files {
  'resources/build/index.html',
  'resources/build/**/*',
  'resources/images/*.png',
}

escrow_ignore { 'Customize.lua' }