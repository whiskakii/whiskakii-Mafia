fx_version 'bodacious'
game 'gta5'

author 'Whiskakii | ORION - SERVICES'

client_scripts {
    'client/*.lua',
    'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua',
    'config.lua'
}

ui_page 'assets/ui.html'

files {
    'assets/ui.html',
    'assets/style.css',
    'assets/animate.css',
    'assets/script.js',
    'assets/fonts/*.ttf',
    'assets/images/*.png',
}
