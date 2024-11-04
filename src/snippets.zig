// Copyright (c) 2024 g41797
// SPDX-License-Identifier: MIT

//  Example of the ptr casting
//
// pub fn data(atr: *Attr, comptime T: type) *T {
//     const u8ptr: *u8 = @ptrCast(@alignCast(atr));
//     const dptr: *u8 = @ptrFromInt(@intFromPtr(u8ptr) + @sizeOf(Attr));
//     const retptr: *T = @as(*T, @ptrCast(@alignCast(dptr)));
//     return retptr;
// }

// Tagged union Attribute|Field
//
// const ItemTag = enum {
//     unknown,
//     attribute,
//     field,
// };
//
// const ItemPtr = union(ItemTag) {
//     unknown: *void,
//     attribute: *Attribute,
//     field: *Field,
// };

// const native_endian = @import("builtin").target.cpu.arch.endian();
// const big_endian = @import("builtin").target.cpu.arch.bigendian();
