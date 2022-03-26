fx_version 'cerulean'
game 'gta5'

description 'QB-Overlord-Laundering'
version '1.0.0'

shared_scripts { 
	'config.lua'
}

client_scripts {
	'@menuv/menuv.lua',
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}
