// Copyright (c) 2024 g41797
// SPDX-License-Identifier: MIT

const std = @import("std");

pub const attribute = @import("attribute.zig");
pub const AttrHdr = attribute.AttrHdr;

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

    pub fn min_data_size(ft: FieldType) usize {
        const result = switch (ft) {
            .BOOL => @sizeOf(u8),
            .INT8 => @sizeOf(i8),
            .INT16 => @sizeOf(i16),
            .INT32 => @sizeOf(i32),
            .INT64 => @sizeOf(i64),
            .DOUBLE => @sizeOf(f64),
            .CAST_INT64 => @sizeOf(i64),
            else => 0,
        };
        return result;
    }
};

pub const FieldName = packed struct {
    namelen: u16 = 0, // length of name without sentinel termination \0
    cstr: void,
    padding: void,

    const FNAME_ALIGN = 2;

    pub inline fn FHDR_PADDING(len: i32) i32 {
        return (len + 1 << FNAME_ALIGN - 1) & ~(1 << FNAME_ALIGN - 1);
    }

    pub fn name_len(namelen: u16) i32 {
        return FHDR_PADDING(@sizeOf(FieldName) + namelen + 1);
    }
};

pub const Field = packed struct {
    ahdr: AttrHdr = .{
        .field = true,
    },
    name: FieldName = undefined,
    fdata: void = undefined,

    pub fn is_field(fld: *Field) bool {
        return fld.ahdr.field;
    }

    pub fn reset_name(fld: *Field) void {
        const charPtr: *u8 = @ptrCast(&fld.name.cstr);
        charPtr.* = 0;
    }

    pub fn name_cstr(fld: *Field) [*c]u8 {
        return @ptrCast(&fld.name.cstr);
    }

    pub fn ftype(fld: *Field) FieldType {
        return @enumFromInt(fld.ahdr.id);
    }

    pub fn data_ptr(fld: *Field) !*void {
        if (!fld.isField()) {
            return error.IsNotField;
        }

        var fdptr: *u8 = @ptrCast(fld); //

        fdptr += @sizeOf(AttrHdr) + FieldName.fnameLen(fld.name.namelen);

        return @ptrCast(fdptr);
    }

    pub fn data_len(fld: *Field) !usize {
        const start = try fld.data_ptr();

        const fdl = fld.ahdr.plen - (@intFromPtr(start) - @intFromPtr(fld));
        return fdl;
    }

    pub fn is_valid(fld: *Field) !bool {
        if (!fld.is_field()) {
            return error.IsNotField;
        }
        if (!fld.ahdr.was_set()) {
            return error.WasNotSet;
        }
        if (!(fld.ahdr.id > __FIELD_LAST) || (fld.ahdr.id < FIELD_UNSPEC)) {
            return error.WrongFieldId;
        }

        return true;
    }
};
