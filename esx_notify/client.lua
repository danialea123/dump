RegisterNetEvent("esx_notify:sendNotify")
AddEventHandler("esx_notify:sendNotify", function(options)
    Notification(options)
end)

function Notification(options)
    SendNUIMessage({
        name = 'addNotification',
        title = options.title,
        message = options.message,
        image = options.image,
        timeout = options.timeout,
        color = options.bgColor
    })
end

RegisterCommand("notify", function()
    exports['esx_notify']:Notification({
        title = 'Example Notify',
        message = 'In the latest update we have removed notification spamming',
        image = 'https://media.discordapp.net/attachments/611882911817400332/912008748288053278/unknown.png',
        timeout = 6000
    })
end)

RegisterCommand("allnotify", function()
    exports['esx_notify']:Notification({
        title = 'EXAMPLE',
        message = 'This is a example notification',
        image = 'https://media.discordapp.net/attachments/611882911817400332/912008748288053278/unknown.png',
        timeout = 6000,
        bgColor = 'rgba(208, 255, 0, 0.4)'
    })

    exports['esx_notify']:Notification({
        title = 'SUCCESS',
        message = 'This is a example success notification',
        image = 'https://media.discordapp.net/attachments/766026362594656286/912334243802251304/ic_fluent_checkmark_24_filled.png',
        timeout = 6000,
        bgColor = 'rgba(208, 255, 0, 0.4)'
    })


    exports['esx_notify']:Notification({
        title = 'ERROR',
        message = 'This is a example error notification',
        image = 'https://media.discordapp.net/attachments/766026362594656286/912334392880422912/ic_fluent_clipboard_error_24_filled.png',
        timeout = 6000,
        bgColor = 'rgba(255, 33, 33, 0.4)'
    })


    exports['esx_notify']:Notification({
        title = 'INFO',
        message = 'This is a example info notification',
        image = 'https://media.discordapp.net/attachments/766026362594656286/912334083193962526/ic_fluent_info_24_filled.png',
        timeout = 6000,
        bgColor = 'rgba(0, 17, 255, 0.4)'
    })


    exports['esx_notify']:Notification({
        title = 'WARN',
        message = 'This is a example warn notification',
        image = 'https://media.discordapp.net/attachments/766026362594656286/912334486300143616/ic_fluent_warning_24_filled.png',
        timeout = 6000,
        bgColor = 'rgba(255, 81, 0, 0.4)'
    })


    exports['esx_notify']:Notification({
        title = 'ANNOUNCE',
        message = 'This is a example announce notification',
        image = 'https://media.discordapp.net/attachments/766026362594656286/912334690248187984/ic_fluent_clipboard_24_filled.png',
        timeout = 6000,
        bgColor = 'rgba(0, 225, 255, 0.4)'
    })

    exports['esx_notify']:Notification({
        title = 'Long Notify',
        message = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas euismod consectetur mi sit amet aliquet. Integer ut leo interdum, consectetur nulla nec, dignissim erat',
        image = 'https://media.discordapp.net/attachments/766026362594656286/912334855503753246/ic_fluent_alert_24_filled.png',
        timeout = 6000
    })
end)



