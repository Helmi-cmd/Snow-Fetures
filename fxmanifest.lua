fx_version 'cerulean'
game 'gta5'

author 'notHelmi'
name 'NH_Snowball'
description 'Snow features for when its snowing in qbx_core'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
}

client_scripts{
    'client.lua',
}

server_scripts{
    'server.lua',
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'