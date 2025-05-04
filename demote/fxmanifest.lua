lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

client_script "@sr_main/client/def.lua"

client_scripts {
    "animations/*.lua",
    "animations/merge/*.lua",
    "client/*.lua",
    --"cardealer/client.lua",
    --"fightclub/fightclub_cl.lua",
}

server_scripts {
    "animations/*.lua",
    "server/main.lua",
    --"cardealer/server.lua",
    --"fightclub/fightclub.lua",
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/css/*.css",
    "html/img/*.png",
    "html/js/*.js",
    "html/fonts/*.otf",
    "html/fonts/*.ttf",
}


escrow_ignore {
    "cylexac.lua",
    "animations/*.lua",
    "animations/merge/*.lua",
}

server_script{ 
	'@oxmysql/lib/MySQL.lua',
	--'cardealer/server.lua'
}

client_scripts {
	--'cardealer/client.lua'
}

client_scripts {
    'siren/lux.lua'
} 

server_script 'siren/server.lua'

-- data_file "DLC_ITYP_REQUEST" "badge1.ytyp"
-- data_file "DLC_ITYP_REQUEST" "copbadge.ytyp"
-- data_file "DLC_ITYP_REQUEST" "prideprops_ytyp"
-- data_file "DLC_ITYP_REQUEST" "lilflags_ytyp"
-- data_file 'DLC_ITYP_REQUEST' 'bzzz_foodpack'
-- data_file 'DLC_ITYP_REQUEST' 'natty_props_lollipops.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'bebekbus.ytyp'