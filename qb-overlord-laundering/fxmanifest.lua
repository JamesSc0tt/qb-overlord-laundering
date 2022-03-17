fx_version 'cerulean'
game 'gta5'

description 'QB-Overlord-Laundering'
version '1.0.0'

shared_scripts { 
	'@qb-core/shared/gangs.lua',
	'@qb-core/shared/items.lua',
	'@qb-core/shared/jobs.lua',
	'@qb-core/shared/locale.lua',
	'@qb-core/shared/main.lua',
	'@qb-core/shared/vehicles.lua',
	'@qb-core/shared/weapons.lua',
	'config.lua'
}

client_scripts {
	'@menuv/menuv.lua',
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}
