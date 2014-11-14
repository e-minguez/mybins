HOST=
sshfs -o auto_cache,reconnect,no_readahead,Ciphers=arcfour,sshfs_debug pi@${HOST}:/var/www/htdocs/webcam/images/ /home/edu/pics/
