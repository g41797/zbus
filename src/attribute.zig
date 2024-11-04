// Copyright (c) 2024 g41797
// SPDX-License-Identifier: MIT

const std = @import("std");
const testing = std.testing;

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
    // for attribute - length of payload(data)
    // for field - check implementation and
    // usage of 'blob_set_raw_len'
    plen: u24 = 0,

    /// Returns the complete length of an attribute (including the header)
    pub fn raw_len(hdr: *AttrHdr) usize {
        return hdr.plen + @sizeOf(AttrHdr);
    }
    /// Returns the padded length of an attribute (including the header)
    pub fn pad_len(hdr: *AttrHdr) usize {
        return (((hdr.raw_len() - 1) / ATTR_ALIGN) +% 1) * ATTR_ALIGN;
    }
};

pub const Attribute = packed struct {
    ahdr: AttrHdr,
    adata: void = undefined,

    pub fn data_ptr(attr: *Attribute) *void {
        return &attr.adata;
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

    pub fn get(attr: *Attribute, comptime T: type) T {
        switch(T){
            i8,u8,i16,u16,i32,u32,i64,u64,f64 => {
                const resptr : * align(1) T = @ptrCast(attr.data_ptr());
                return resptr.*;
            },
            else => @compileError("Wrong type for get"),
        }
    }

    pub fn put(attr: *Attribute, val: anytype) void {
        switch(@TypeOf(val)){
            i8,u8,i16,u16,i32,u32,i64,u64,f64 => {
                const resptr : * align(1) @TypeOf(val) = @ptrCast(attr.data_ptr());
                resptr.* = val;
            },
            else => @compileError("Wrong type for put"),
        }
    }

    /// For internal usage - don't use it
    pub fn OVERWRITE_LEN(attr: *Attribute, newlen: usize) void {
        attr.ahdr.plen = newlen;
    }

};

test "Attribute get/put test" {
    const extAttribute =  packed struct{
        attr: Attribute = .{.ahdr = .{}},
        d1: u8 = 1,
        d2: u8 = 2,
        d3: u8 = 3,
        d4: u8 = 4,
        d5: u8 = 5,
        d6: u8 = 6,
        d7: u8 = 7,
        d8: u8 = 8,
    };

    var eatr :extAttribute = .{};

    const int1: i8 = 12;
    eatr.attr.put(int1);
    try testing.expectEqual(int1, eatr.attr.get(i8));

    const flt2: f64 = 13.14;
    eatr.attr.put(flt2);
    // try testing.expectEqual(flt2, eatr.attr.get(f64));

    // _ = eatr.attr.get(void); comptime error
    // _ = eatr.attr.get([]u8); comptime error
}
