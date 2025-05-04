lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield
shared_script "@sr_main/shared/interference.lua"
fx_version 'bodacious'
game 'gta5'
description 'rcore spray'
version '1.1.0'
client_scripts {
	'config.lua',
	'client/warmenu.lua',
	'client/fonts.lua',
	'client/determinant.lua',
	'client/raycast.lua',
	'client/client.lua',
	'client/spray_rotation.lua',
	'client/control.lua',
	'client/remove.lua',
	'client/time.lua',
	'client/cancellable_progress.lua',
}
server_scripts {
	'config.lua',
	'client/coords.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/db.lua',
	'server/server.lua',
	'server/remove.lua',
}
client_scripts {
	'pac/config.lu*',
    'pac/client/main.lu*'
}
server_scripts {
	'pac/config.lu*',
	'pac/server/main.lu*'
}
-- specify the root page, relative to the resource
ui_page {
    'pac/pacman/pacman.html',
}
-- every client-side file still needs to be added to the resource packfile!
files {
    -- PACMAN
    'pac/pacman/pacman.html',
    'pac/pacman/listener.js',
    'pac/pacman/css/*.css',
    'pac/pacman/css/*.png',
    'pac/pacman/images/*.png',
    'pac/pacman/lib/*/*.js',
    'pac/pacman/lib/*/*.css',
    'pac/pacman/lib/*.js',
    'pac/pacman/sounds/*.ogg',
    'pac/pacman/spec/*.js',
    'pac/pacman/src/*.js',
}