
Config = {}

Config.Framework = "esx" 

Config.Mysql = "oxmysql" 

Config.Command = "trade"

Config.MoneyItems = false

Config.MoneyName = 'Cash'

Config.AcceptedKey = 246 -- Y 

Config.RejectedKey = 249 -- N

Config.defaultImage = "https://cdn.discordapp.com/attachments/1170720945921609809/1214484249038561310/693.png?ex=65f94798&is=65e6d298&hm=cde750c24982a5eb39ecb45e1606e2be64dadb5a6eeaaec9c79f3239b9aa3915&"


Config.Locale = {
    ['trade'] = 'TRADE',
    ['myoffer'] = 'ALL',
    ['accepted'] = 'ACCEPTED',
    ['accept'] = 'ACCEPT',
    ['decline'] = 'DECLINE',
    ['esc'] = 'ESC',
    ['close'] = 'CLOSE',
    ['offernotaccepted'] = 'OFFER NOT ACCEPTED YET.',
    ['offeraccepted'] = 'OFFER ACCEPTED.',

}

Config.Notification = function(message, type, isServer, src)-- You can change here events for notifications
    if isServer then
        TriggerClientEvent("esx:showNotification", src, message, "info")
    else
        TriggerEvent("esx:showNotification", message, "info")
    end
end

Config.Notifications = { -- Notifications
    ["failed"] = {
        message = 'Trade failed to complete: invalid tradeId',
        type = "success",
    },
    ["yourself"] = {
        message = 'You cannot trade with yourself!',
        type = "success",
    },
    ["activetrade"] = {
        message = 'You already have an active trade request!',
        type = "success",
    },
    ["invalidid"] = {
        message = '  Invalid player ID!',
        type = "success",
    },
    
    ["reqex"] = {
        message = 'Usage: /trade [player ID]',
        type = "success",
    },
    ["nearby"] = {
        message = 'No players specified nearby',
        type = "success",
    },
    ["request"] = {
        message = '',
        type = "success",
    },
    ["rejected"] = {
        message = 'Player Mored Nazar Trade Ra Ghabool Nakard',
        type = "success",
    },
    
    

}
function GetName(source)
    return GetPlayerName(source)
end



