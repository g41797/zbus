    mkdir src/c
    mkdir src/c/libubox
    ls -la src/c/libubox
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/avl.c > src/c/libubox/avl.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/avl-cmp.c > src/c/libubox/avl-cmp.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/base64.c > src/c/libubox/base64.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/blob.c > src/c/libubox/blob.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/blobmsg.c > src/c/libubox/blobmsg.zig
    zig translate-c -lc --verbose-cimport -I/usr/include/json-c  -fno-emit-bin src/libs/libubox/blobmsg_json.c > src/c/libubox/blobmsg_json.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/jshn.c > src/c/libubox/jshn.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/json_script.c > src/c/libubox/json_script.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/kvlist.c > src/c/libubox/kvlist.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/md5.c > src/c/libubox/md5.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/runqueue.c > src/c/libubox/runqueue.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/safe_list.c > src/c/libubox/safe_list.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/udebug.c > src/c/libubox/udebug.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/udebug-remote.c > src/c/libubox/udebug-remote.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/ulog.c > src/c/libubox/ulog.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/uloop.c > src/c/libubox/uloop.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/uloop-epoll.c > src/c/libubox/uloop-epoll.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/uloop-kqueue.c > src/c/libubox/uloop-kqueue.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/usock.c > src/c/libubox/usock.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/ustream.c > src/c/libubox/ustream.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/ustream-fd.c > src/c/libubox/ustream-fd.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/utils.c > src/c/libubox/utils.zig
    zig translate-c -lc --verbose-cimport -fno-emit-bin src/libs/libubox/vlist.c > src/c/libubox/vlist.zig
    ls -la src/c/libubox
