fx_version 'cerulean'
lua54 'yes'
games { 'rdr3', 'gta5' }


client_scripts {
    'client.lua',
    'config.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_script 'server.lua'
