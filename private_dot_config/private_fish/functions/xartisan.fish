function xartisan --description "Run docker/dev/artisan with Xdebug enabled"
    env XDEBUG=1 docker/dev/artisan $argv
end
