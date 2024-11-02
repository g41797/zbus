// Copyright (c) 2024 g41797
// SPDX-License-Identifier: MIT

const std = @import("std");
const Allocator = std.mem.Allocator;
const blob = @import("blob.zig");
const Attribute = blob.Attribute;
const Field = blob.Field;
const Buffer = @import("buffer.zig").Buffer;
const Mode = @import("buffer.zig").Mode;

const MinBuffSize = 0x200;
const MaxBuffSize = 0x10000;

pub const Msg = struct {
    allocator: Allocator = undefined,
    bfr: Buffer = .{},
    // field: ?*Field = null,
    // attr: ?*Attribute = null,

    pub fn init(msg: *Msg, allocator: Allocator) !void {
        msg.allocator = allocator;
        _ = try msg.bfr.init(msg.allocator, MinBuffSize, MaxBuffSize);
        _ = try msg.bfr.set_mode(.write);

        // According to source, first field of message is empty table
        // But actually it's BINARY attribute with zero length
        const ahdr = blob.AttrHdr{ .field = false, .id = .BINARY, .plen = 0 };
        _ = try msg.bfr.append(@ptrCast(&ahdr), ahdr.raw_len());
        _ = try msg.bfr.pad(ahdr.pad_len(), 0xff);
        return;
    }

    pub fn free(msg: *Msg) void {
        msg.bfr.free();
        return;
    }
};
