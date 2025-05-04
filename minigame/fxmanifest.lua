lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'

game 'gta5'

description 'Minigame For FiveM'

client_scripts {
    'client/main.lua'
}

ui_page "nui/minigame.html"
ui_page_preload 'yes'

files {
    "nui/*.html",
    "nui/*.js",
    "nui/*.css",
    "nui/img/*.png",
    "nui/img/*.svg"
}


-- exports documentation: 

--[[ 

exports.minigame:MiniGame(50, function(success)
    if success then
        print('success')
    else                                             -- START MINIGAME (50 is the time to complete the game, function(success) will return you the result of the minigame)
        print('fail')
    end
end)


if exports.minigame:status() then
    print('the player is running the minigame')
else
    print('the player is not playing the minigame')
end

--]]
dependency '/assetpacks'