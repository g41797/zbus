// Copyright (c) 2024 g41797
// SPDX-License-Identifier: MIT

const std = @import("std");
const Allocator = std.mem.Allocator;

// const native_endian = @import("builtin").target.cpu.arch.endian();
// const big_endian = @import("builtin").target.cpu.arch.bigendian();

/// Modes of Buffer usage:
/// - receive: receive information from rpcd via socket, format - big endian
/// - send: send information to rpcd via socket, format - big endian
/// - write: save filelds and attributes before send, format - native
/// - read: use fields and attributes after receive or write, format - native
pub const Mode = enum {
    unspecified,
    receive,
    send,
    write,
    read,
};

/// Growable memory buffer.
/// All information are saved in the native endiannes.
/// For little endian processors convert to big endian
/// will be done by ubus before send and after receive
pub const Buffer = struct {
    mode: Mode = .unspecified,
    minlen: usize = undefined,
    maxlen: usize = undefined,
    allocator: Allocator = undefined,
    buffer: ?[]u8 = null,
    datalen: usize = undefined,
    getoffset: usize = undefined, // for send & read
    putoffset: usize = undefined, // for receive and write

    // endian: std.builtin.Endian = undefined,
    // wstrm: ?std.io.FixedBufferStream([]u8) = null,
    // rstrm: ?std.io.FixedBufferStream([]const u8) = null,

    pub fn init(bfr: *Buffer, allocator: Allocator, minlen: usize, maxlen: usize) !void {
        // bfr.endian = native_endian;
        bfr.maxlen = maxlen;
        bfr.minlen = minlen;
        bfr.allocator = allocator;
        try bfr.grow(null);
        return;
    }

    /// Extend buffer: newlen or currlen*2 but no more then maxlen.
    /// Content of former buffer copied to new one.
    /// Former buffer - freed.
    pub fn grow(bfr: *Buffer, newlen: ?usize) !void {
        var alloclen = bfr.minlen;

        for (0..1) |_| {
            if (bfr.buffer == null) {
                if (newlen) |bufflen| {
                    if (bufflen == 0) {
                        alloclen = bfr.minlen;
                    } else {
                        alloclen = @min(bufflen, bfr.maxlen);
                    }
                }

                bfr.buffer = try bfr.allocator.alloc(u8, alloclen);
                @memset(bfr.buffer.?, 0);

                bfr.datalen = 0;
                bfr.getoffset = 0;
                bfr.putoffset = 0;

                break;
            }

            alloclen = @min(bfr.buffer.?.len * 2, bfr.maxlen);

            if (newlen) |bufflen| {
                if (bufflen <= bfr.buffer.?.len) {
                    break;
                }
                alloclen = @min(bufflen, alloclen);
            }

            const buffer = bfr.buffer.?;
            defer bfr.allocator.free(buffer);
            bfr.buffer = null;

            bfr.buffer = try bfr.allocator.alloc(u8, alloclen);
            @memset(bfr.buffer.?, 0);
            std.mem.copyForwards(u8, bfr.buffer.?[0..bfr.datalen], buffer[0..bfr.datalen]);
        }

        return;
    }

    /// Prepare buffer for specific mode.
    pub fn set_mode(bfr: *Buffer, mode: Mode) !void {
        if (bfr.buffer == null) {
            return error.EmptyBuffer;
        }

        bfr.mode = mode;

        switch (bfr.mode) {
            .receive, .write => {
                bfr.datalen = 0;
                bfr.getoffset = 0;
                bfr.putoffset = 0;
                return;
            },
            .send, .read => {
                bfr.getoffset = 0;
                bfr.putoffset = 0;
                return;
            },
            else => {
                return error.WrongMode;
            },
        }
        return;
    }

    pub fn free(bfr: *Buffer) void {
        if (bfr.buffer != null) {
            bfr.allocator.free(bfr.buffer.?);
            bfr.buffer = null;
        }
        bfr.mode = .unspecified;
        bfr.datalen = 0;
        bfr.getoffset = 0;
        bfr.putoffset = 0;

        return;
    }

    /// Amount of data available for current mode
    /// e.g. for 'send' it's number of byte still not send to rpcd
    pub fn available(bfr: *Buffer) usize {
        if (bfr.buffer == null) {
            return 0;
        }

        const result = switch (bfr.mode) {
            .receive, .write => bfr.buffer.?.len - bfr.putoffset,
            .send, .read => bfr.datalen - bfr.getoffset,
            else => 0,
        };
        return result;
    }

    pub fn write_put(bfr: *Buffer, data: []u8) !void {
        if (bfr.mode != .write) {
            return error.WriteAlloweOnlyInWRiteMode;
        }

        if (data.len == 0) {
            return;
        }

        const avail = bfr.available();
        if (avail < data.len) {
            return error.NotEnoughSpace;
        }

        const dptr = try bfr.ptr();
        std.mem.copyForwards(u8, dptr[0..data.len], data);

        return bfr.forward(data.len);
    }

    pub fn write_append(bfr: *Buffer, data: *u8, len: usize) !void {
        return bfr.put(data[0..len]);
    }

    pub fn write_pad(bfr: *Buffer, len: usize, fill: ?u8) !void {
        if (bfr.mode != .write) {
            return error.WriteAlloweOnlyInWRiteMode;
        }

        if (len == 0) {
            return;
        }

        const avail = bfr.available();
        if (avail < len) {
            return error.NotEnoughSpace;
        }

        if (fill) |value| {
            const dptr = try bfr.ptr();
            @memset(dptr[0..len], value);
        }
        return bfr.forward(len);
    }

    /// Skip forward
    /// - receive, write till end of buffer
    /// - send,read till datalen
    pub fn forward(bfr: *Buffer, len: usize) !void {
        if (len == 0) {
            return;
        }

        const avail = bfr.available();
        if (avail < len) {
            return error.CannotForwardAfterEndOfTheBuffer;
        }

        switch (bfr.mode) {
            .receive => {
                bfr.putoffset += len;
            },
            .send => {
                bfr.getoffset += len;
            },
            .read => {
                bfr.getoffset += len;
            },
            .write => {
                bfr.putoffset += len;
            },
            else => {
                return error.EmptyBuffer;
            },
        }

        return;
    }

    pub fn ptr(bfr: *Buffer) !*u8 {
        if (bfr.buffer == null) {
            return error.EmptyBuffer;
        }

        const address = @intFromPtr(bfr.buffer.?.ptr);

        return switch (bfr.mode) {
            .receive, .write => bfr.putoffset + address,
            .send, .read => bfr.getoffset + address,
        };
    }

    pub fn slice(bfr: *Buffer) ![]u8 {
        const bptr = try bfr.ptr();
        return bptr[0..bfr.available()];
    }

    // pub fn toBE(bfr: *Buffer) !void {
    //     _ = bfr;
    //     return 0;
    // }
    //
    // pub fn fromBE(bfr: *Buffer) !void {
    //     _ = bfr;
    //     return 0;
    // }
};
