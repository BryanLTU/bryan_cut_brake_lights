fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'BryaN'
version '0.0.0'
description 'Usable item to disable vehicle\'s brake lights so the vehicle is less more seen'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}
client_script 'client/main.lua'
server_script 'server/main.lua'

files {
    'locales/*.json'
}

requirement 'ox_lib'