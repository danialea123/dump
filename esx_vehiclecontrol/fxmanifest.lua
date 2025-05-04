lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'server.lua'
} 

ui_page 'index.html'

files {
  "index.html",
  "scripts.js",
  "css/style.css"
}
client_script {
  "client.lua",
  "hotwire.lua"
}

export "taskBar"
export "closeGuiFail"
