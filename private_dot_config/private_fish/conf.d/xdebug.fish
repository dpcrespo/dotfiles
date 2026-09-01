# Xdebug for php running on the host (the dockerised php/artisan wrappers use
# xphp/xartisan instead). client_host is the docker bridge gateway seen from
# inside the container: check it with
#   docker network inspect adsmurai-network-dev -f '{{ (index .IPAM.Config 0).Gateway }}'
set -gx XDEBUG_CONFIG "client_host=172.18.0.1 client_port=9003 mode=debug start_with_request=yes"
