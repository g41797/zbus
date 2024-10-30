// Copyright (c) 2024 g41797
// SPDX-License-Identifier: MIT

const std = @import("std");
const Allocator = std.mem.Allocator;
const native_endian = @import("builtin").target.cpu.arch.endian();
const big_endian = @import("builtin").target.cpu.arch.bigendian();

/// Modes of Buffer usage:
/// - receive: receive information from rpcd via socket, format - big endian
/// - send: send information to rpcd via socket, format - big endian
/// - write: save filelds and attributes before send, format - native
/// - read: use fields and attributes after receive or write, format - native
const Mode = enum {
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
/// within the same buffer.
pub const Buffer = struct {
    mode: Mode = .unspecified,
    endian: std.builtin.Endian = undefined,
    minlen: usize = undefined,
    maxlen: usize = undefined,
    allocator: Allocator = undefined,
    buffer: ?[]u8 = null,
    datalen: usize = undefined,
    getpos: usize = undefined,
    putpos: usize = undefined,
    wstrm: ?std.io.FixedBufferStream([]u8) = null,
    rstrm: ?std.io.FixedBufferStream([]const u8) = null,

    pub fn init(bfr: *Buffer, allocator: Allocator, minlen: usize, maxlen: usize) !void {
        bfr.endian = native_endian;
        bfr.maxlen = maxlen;
        bfr.minlen = minlen;
        bfr.allocator = allocator;
        // ...................
        return;
    }

    /// Extend buffer: currlen*2 but no more then maxlen.
    /// Content of former buffer copied to new one.
    /// Former buffer - freed.
    /// Write stream position (if stream was created) - set to value before grow.
    pub fn grow(bfr: *Buffer) !void {
        _ = bfr;
        return;
    }
    /// Prepare buffer for specific mode.
    pub fn set_mode(bfr: *Buffer, mode: Mode) !void {
        _ = bfr;
        _ = mode;
        return;
    }

    pub fn free(bfr: *Buffer) void {
        _ = bfr;
        return;
    }

    /// Amount of data available for current mode
    /// e.g. for 'send' it's number of byte still not send to rpcd
    pub fn available(bfr: *Buffer) usize {
        _ = bfr;
        return 0;
    }

    pub fn put(bfr: *Buffer, data: []u8) !void {
        _ = bfr;
        _ = data;
        return 0;
    }

    pub fn pad(bfr: *Buffer, len: usize, fill: ?u8) !void {
        _ = bfr;
        _ = len;
        _ = fill;
        return 0;
    }

    pub fn toBE(bfr: *Buffer) !void {
        _ = bfr;
        return 0;
    }

    pub fn fromBE(bfr: *Buffer) !void {
        _ = bfr;
        return 0;
    }
};
