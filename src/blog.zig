// Copyright (c) 2024 g41797
// SPDX-License-Identifier: MIT

const std = @import("std");

pub const BLOB_ATTR_UNSPEC: c_int = 0;
pub const BLOB_ATTR_NESTED: c_int = 1;
pub const BLOB_ATTR_BINARY: c_int = 2;
pub const BLOB_ATTR_STRING: c_int = 3;
pub const BLOB_ATTR_INT8: c_int = 4;
pub const BLOB_ATTR_INT16: c_int = 5;
pub const BLOB_ATTR_INT32: c_int = 6;
pub const BLOB_ATTR_INT64: c_int = 7;
pub const BLOB_ATTR_DOUBLE: c_int = 8;
pub const BLOB_ATTR_LAST: c_int = 9;

pub const AttrType = enum(u7) {
    UNSPEC = BLOB_ATTR_UNSPEC,
    NESTED = BLOB_ATTR_NESTED,
    BINARY = BLOB_ATTR_BINARY,
    STRING = BLOB_ATTR_STRING,
    INT8 = BLOB_ATTR_INT8,
    INT16 = BLOB_ATTR_INT16,
    INT32 = BLOB_ATTR_INT32,
    INT64 = BLOB_ATTR_INT64,
    DOUBLE = BLOB_ATTR_DOUBLE,
    LAST = BLOB_ATTR_LAST,
};

pub const BLOB_ATTR_ALIGN = @as(c_int, 4);

pub const AttrHdr = packed struct {
    extended: bool = false,
    id: AttrType = .UNSPEC,
    len: u24 = 0,

    // pub fn data(atr: *Attr, comptime T: type) *T {
    //     const u8ptr: *u8 = @ptrCast(@alignCast(atr));
    //     const dptr: *u8 = @ptrFromInt(@intFromPtr(u8ptr) + @sizeOf(Attr));
    //     const retptr: *T = @as(*T, @ptrCast(@alignCast(dptr)));
    //     return retptr;
    // }
    //
    // pub fn getU8(atr: *Attr) u8 {
    //     return atr.data(u8).*;
    // }
    //
    // pub fn setU8(atr: *Attr, val: u8) void {
    //     atr.data(u8).* = val;
    //     return;
    // }

    pub fn raw_len(hdr: *AttrHdr) usize {
        return hdr.len + @sizeOf(AttrHdr);
    }

    pub fn pad_len(hdr: *AttrHdr) usize {
        return (((hdr.raw_len() - 1) / BLOB_ATTR_ALIGN) +% 1) * BLOB_ATTR_ALIGN;
    }
};

pub fn BlobAttr(comptime Data: type) type {
    return packed struct {
        const Self = @This();

        // TODO set header values according to Data type !!!
        hdr: AttrHdr = .{},
        payload: Data = undefined,

        pub fn get(self: *Self) Data {
            return self.payload;
        }

        pub fn set(self: *Self, val: Data) void {
            self.payload = val;
            return;
        }
    };
}

const U8 = BlobAttr(u8);

test "simple test" {
    var bu8: U8 = .{};
    bu8.set(13);
    var v13 = bu8.get();
    v13 = 14;
    return;
}
