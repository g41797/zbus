// Copyright (c) 2024 g41797
// SPDX-License-Identifier: MIT

const std = @import("std");
const blob = @import("attribute.zig");
const Buffer = @import("buffer.zig").Buffer;

pub const MSG_ALIGN = 2;

pub inline fn MSG_PADDING(len: i32) i32 {
    return (len + 1 << MSG_ALIGN - 1) & ~(1 << MSG_ALIGN - 1);
}

pub const FIELD_UNSPEC: c_int = 0;
pub const FIELD_ARRAY: c_int = 1;
pub const FIELD_TABLE: c_int = 2;
pub const FIELD_STRING: c_int = 3;
pub const FIELD_INT64: c_int = 4;
pub const FIELD_INT32: c_int = 5;
pub const FIELD_INT16: c_int = 6;
pub const FIELD_INT8: c_int = 7;
pub const FIELD_BOOL: c_int = 7;
pub const FIELD_DOUBLE: c_int = 8;
pub const CAST_INT64: c_int = 9;
pub const __FIELD_LAST: c_int = 9;

pub const FieldType = enum(u8) {
    UNSPEC = FIELD_UNSPEC,
    ARRAY = FIELD_ARRAY,
    TABLE = FIELD_TABLE,
    STRING = FIELD_STRING,
    INT64 = FIELD_INT64,
    INT32 = FIELD_INT32,
    INT16 = FIELD_INT16,
    INT8 = FIELD_INT8,
    BOOL = FIELD_BOOL,
    DOUBLE = FIELD_DOUBLE,
    CAST_INT64 = CAST_INT64,
    LAST = __FIELD_LAST,
};

pub const FieldName = packed struct {
    namelen: u16 = 0, // length of name without sentinel terminatot \0
    cstr: void,
    padding: void,
};
