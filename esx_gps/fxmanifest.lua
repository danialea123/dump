lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version "cerulean"
game "gta5"


author "aliko. <Discord: aliko.>"
description "Fivem GPS Script, QB Framework, OneSync:Infinity"
version "1.0.0"

client_scripts {
	"client/variables.lua",
	"client/classes.lua",
	"client/utils.lua",
	"client/functions.lua",
	"client/nui.lua",
	"client/threads.lua",
	"client/events.lua",
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"server/variables.lua",
	"server/classes.lua",
	"server/functions.lua",
	"server/threads.lua",
	"server/events.lua",
}

shared_script "shared/**/*"

ui_page "web/build/index.html"

files {
	"locales/**/*",
	"web/build/index.html",
	"web/build/**/*",
}

escrow_ignore {
	"locales/**/*",
	"shared/**/*",
	"web/**/*",
	"client/**/*",
	"server/**/*"
}

dependency '/assetpacks'