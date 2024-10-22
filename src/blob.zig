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


    pub fn raw_len(hdr: *AttrHdr) usize {
        return hdr.len + @sizeOf(AttrHdr);
    }

    pub fn pad_len(hdr: *AttrHdr) usize {
        return (((hdr.raw_len() - 1) / BLOB_ATTR_ALIGN) +% 1) * BLOB_ATTR_ALIGN;
    }
};

pub fn typeOf(comptime at: AttrType) type {
    const result = switch (at) {
        .INT8 => i8,
        .INT16 => i16,
        .INT32 => i32,
        .INT64 => i64,
        .DOUBLE => f64,
        else => void,
    };
    return result;
}

pub fn retTypeOf(comptime at: AttrType) type {
    const result = switch (at) {
        .INT8 => i8,
        .INT16 => i16,
        .INT32 => i32,
        .INT64 => i64,
        .DOUBLE => f64,
        else => *void,
    };
    return result;
}

pub fn lenOf(comptime at: AttrType) usize {
    if (@TypeOf(retTypeOf(at) == *void)) {
        return 0;
    }

    return @sizeOf(typeOf(at));
}

pub fn Attr(comptime at: AttrType) type {
    return packed struct {
        const Self = @This();

        hdr: AttrHdr = .{
            .len = lenOf(at),
            .id = at,
        },
        payload: typeOf(at) = undefined,

        pub fn get(self: *Self) retTypeOf(at) {
            if (retTypeOf(at) == *void) {
                return &self.payload;
            }
            return self.payload;
        }

        pub fn set(self: *Self, val: typeOf(at)) void {
            self.payload = val;
            return;
        }
    };
}

test "attr test" {
    const bin = Attr(.INT8);
    var b: bin = .{};
    b.set(13);
    var v13 = b.get();
    v13 = 14;
    return;
}


//  Example of the ptr casting
// pub fn data(atr: *Attr, comptime T: type) *T {
//     const u8ptr: *u8 = @ptrCast(@alignCast(atr));
//     const dptr: *u8 = @ptrFromInt(@intFromPtr(u8ptr) + @sizeOf(Attr));
//     const retptr: *T = @as(*T, @ptrCast(@alignCast(dptr)));
//     return retptr;
// }
