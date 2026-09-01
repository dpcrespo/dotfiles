function xphp --description "Run docker/dev/php with Xdebug enabled on the compose network"
    env XDEBUG=1 CUSTOM_NETWORK=adsmurai-network-dev docker/dev/php $argv
end
