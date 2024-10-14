rm -rf src/c/ubus
mkdir src/c
mkdir src/c/include
ln -s /usr/include/json-c src/c/include/json
mkdir src/c/ubus
ls -la src/c/ubus

#SET(UBUS_UNIX_SOCKET ""/var/run/ubus/ubus.sock"")
#SET(UBUS_MAX_MSGLEN "1048576")
#ADD_DEFINITIONS( -DUBUS_UNIX_SOCKET="${UBUS_UNIX_SOCKET}")
#ADD_DEFINITIONS( -DUBUS_MAX_MSGLEN=${UBUS_MAX_MSGLEN})


zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/cli.c   > src/c/ubus/cli.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/libubus-acl.c   > src/c/ubus/libubus-acl.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/libubus.c   > src/c/ubus/libubus.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/libubus-io.c   > src/c/ubus/libubus-io.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/libubus-obj.c   > src/c/ubus/libubus-obj.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/libubus-req.c   > src/c/ubus/libubus-req.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/libubus-sub.c   > src/c/ubus/libubus-sub.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/ubusd_acl.c   > src/c/ubus/ubusd_acl.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/ubusd.c   > src/c/ubus/ubusd.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/ubusd_event.c   > src/c/ubus/ubusd_event.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/ubusd_id.c   > src/c/ubus/ubusd_id.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/ubusd_main.c   > src/c/ubus/ubusd_main.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/ubusd_monitor.c   > src/c/ubus/ubusd_monitor.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/ubusd_obj.c   > src/c/ubus/ubusd_obj.zig
zig translate-c -lc -D 'UBUS_UNIX_SOCKET="/var/run/ubus/ubus.sock"' -D 'UBUS_MAX_MSGLEN="1048576"'  -Isrc/libs/include -Isrc/libs --verbose-cimport -fno-emit-bin src/libs/ubus/ubusd_proto.c   > src/c/ubus/ubusd_proto.zig
ls -la src/c/ubus
