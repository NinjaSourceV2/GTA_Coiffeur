fx_version 'bodacious'
game 'gta5'

resource_version '1.1'

files {
    'json/**/*'
}

dependencies {'ghmattimysql'}
server_scripts {
    'server/server.lua'
}
client_scripts {
    'config/config.lua',
    'client/client.lua',
    'client/menu.lua'
}