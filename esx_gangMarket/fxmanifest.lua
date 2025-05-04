lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'


version '1.7.11'

shared_scripts { 'shared/*' }

client_scripts { 'client/handlers/*', 'client/modules/*', 'client/*' }

server_scripts { 'server/*.lua' }

ui_page 'html/index.html'

files { 'html/*', 'html/img/*', 'html/assets/*' }

escrow_ignore {
    '**/**.lua',
    '**.lua'
}

dependency '/assetpacks'