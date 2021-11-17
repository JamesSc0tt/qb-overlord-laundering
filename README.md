# qb-overlord-laundering
## What's This?
My players had loads of issues with the traphouse in QBCore, so I made this for my server (OverlordRP - https://discord.gg/overlordrp). It includes a lot of configuration and the config.lua is commented so you can change & configure it to suit your server.

This script is designed to work with gtaDPS's Abandoned Laundromat MLO, if you do not use this you will need to change the coordinates in config.lua
https://www.gta5-mods.com/maps/abandoned-laundromat-interior-singleplayer-fivem-gtadps

## How To?
1) Upload the contents of interact-sound/client/html/sounds to your interact-sound installation
2) Upload the directory 'qb-overlord-laundering' & add 'start qb-overlord-laundering' to your server.cfg
### If you want the phone notification
Add the following code to qb-phone/client/main.lua
```
RegisterNetEvent('qb-phone:client:LaunderNotify')
AddEventHandler('qb-phone:client:LaunderNotify', function(message)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Washing Machine",
            text = "Cycle Completed",
            icon = "fas fa-check",
            color = "#ebc934",
            timeout = 3500,
        },
    })
end)
```

## Requirements
 - qb-core (https://github.com/qbcore-framework/qb-core)
 - interact-sound (https://github.com/qbcore-framework/interact-sound)

## Support
I will not provide support for this resource. Do not join the community discord requesting support.
