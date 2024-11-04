// Copyright (c) 2024 g41797
// SPDX-License-Identifier: MIT

const std = @import("std");
pub const field = @import("field.zig");
pub const Field = field.Field;

pub const ATTR_UNSPEC: c_int = 0;
pub const ATTR_NESTED: c_int = 1;
pub const ATTR_BINARY: c_int = 2;
pub const ATTR_STRING: c_int = 3;
pub const ATTR_INT8: c_int = 4;
pub const ATTR_INT16: c_int = 5;
pub const ATTR_INT32: c_int = 6;
pub const ATTR_INT64: c_int = 7;
pub const ATTR_DOUBLE: c_int = 8;
pub const ATTR_LAST: c_int = 9;

pub const AttrType = enum(u7) {
    UNSPEC = ATTR_UNSPEC,
    NESTED = ATTR_NESTED,
    BINARY = ATTR_BINARY,
    STRING = ATTR_STRING,
    INT8 = ATTR_INT8,
    INT16 = ATTR_INT16,
    INT32 = ATTR_INT32,
    INT64 = ATTR_INT64,
    DOUBLE = ATTR_DOUBLE,
    LAST = ATTR_LAST,

    pub fn min_data_size(at: AttrType) usize {
        const result = switch (at) {
            .INT8 => @sizeOf(i8),
            .INT16 => @sizeOf(i16),
            .INT32 => @sizeOf(i32),
            .INT64 => @sizeOf(i64),
            .DOUBLE => @sizeOf(f64),
            else => 0,
        };
        return result;
    }
};

pub const ATTR_ALIGN = @as(c_int, 4);

pub const AttrHdr = packed struct {
    field: bool = false,
    id: u7 = @intFromEnum(AttrType.UNSPEC),
    plen: u24 = 0, // length of payload, 0 if wasn't set

    pub fn was_set(hdr: *AttrHdr) bool {
        return hdr.plen > 0;
    }

    pub fn raw_len(hdr: *AttrHdr) usize {
        return hdr.plen + @sizeOf(AttrHdr);
    }

    pub fn pad_len(hdr: *AttrHdr) usize {
        return (((hdr.raw_len() - 1) / ATTR_ALIGN) +% 1) * ATTR_ALIGN;
    }
};

pub const Attribute = packed struct {
    ahdr: AttrHdr,
    adata: void = undefined,

    pub fn data_ptr(attr: *Attribute) *void {
        return &attr.ahdr.adata;
    }

    pub fn field_ptr(attr: *Attribute) !*Field {
        if (attr.ahdr.field) {
            return @ptrCast(attr);
        }
        return error.IsNotField;
    }

    pub fn is_valid(attr: *Attribute) !bool {
        if (attr.ahdr.field) {
            const fld = try attr.field_ptr();
            return fld.is_valid();
        }
        if (!attr.ahdr.was_set()) {
            return error.WasNotSet;
        }
        if (!(attr.ahdr.id > ATTR_LAST) || (attr.ahdr.id < ATTR_UNSPEC)) {
            return error.WrongAttributeId;
        }

        const at: AttrType = @enumFromInt(attr.ahdr.id);
        const minLen = at.min_data_size();

        if (!((at >= .Int8) || (at <= .DOUBLE))) {
            if (minLen != attr.ahdr.plen) {
                return error.WrongPayloadlen;
            }
            return true;
        }

        if (at == .STRING) {
            const cstr: *u8 = @ptrCast(attr.data_ptr());
            if (cstr[attr.ahdr.plen] != 0) {
                return error.NoSentinel;
            }
            return true;
        }

        if (at.min_data_size() > attr.ahdr.plen) {
            return error.NotEnoughData;
        }

        return true;
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
            .plen = 0,
            .id = @intFromEnum(at),
        },
        payload: void = undefined,

        pub fn get(self: *Self) !retTypeOf(at) {
            if (self.hdr.plen == 0) {
                return error.WasNotSet;
            }
            if (retTypeOf(at) == *void) {
                return &self.payload;
            }
            const payload: *typeOf(at) = @ptrCast(&self.payload);
            return payload.*;
        }

        pub fn set(self: *Self, val: typeOf(at)) void {
            const payload: *typeOf(at) = @ptrCast(&self.payload);
            payload.* = val;
            return;
        }
    };
}

test "attr test" {
    const bin = Attr(.INT8);
    var buff: [128]u8 = undefined;
    const b: *bin = @ptrCast(@alignCast(&buff));
    b.set(13);
    var v13 = b.get();
    v13 = 14;
    return;
}
