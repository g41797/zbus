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


// pub fn typeOf(comptime at: AttrType) type {
//     const result = switch (at) {
//         .INT8 => i8,
//         .INT16 => i16,
//         .INT32 => i32,
//         .INT64 => i64,
//         .DOUBLE => f64,
//         else => void,
//     };
//     return result;
// }
//
// pub fn retTypeOf(comptime at: AttrType) type {
//     const result = switch (at) {
//         .INT8 => i8,
//         .INT16 => i16,
//         .INT32 => i32,
//         .INT64 => i64,
//         .DOUBLE => f64,
//         else => *void,
//     };
//     return result;
// }
//
// pub fn lenOf(comptime at: AttrType) usize {
//     if (@TypeOf(retTypeOf(at) == *void)) {
//         return 0;
//     }
//
//     return @sizeOf(typeOf(at));
// }
//
// pub fn Attr(comptime at: AttrType) type {
//     return packed struct {
//         const Self = @This();
//
//         hdr: AttrHdr = .{
//             .plen = 0,
//             .id = @intFromEnum(at),
//         },
//         payload: void = undefined,
//
//         pub fn get(self: *Self) !retTypeOf(at) {
//             if (self.hdr.plen == 0) {
//                 return error.WasNotSet;
//             }
//             if (retTypeOf(at) == *void) {
//                 return &self.payload;
//             }
//             const payload: *typeOf(at) = @ptrCast(&self.payload);
//             return payload.*;
//         }
//
//         pub fn set(self: *Self, val: typeOf(at)) void {
//             const payload: *typeOf(at) = @ptrCast(&self.payload);
//             payload.* = val;
//             return;
//         }
//     };
// }
//
// test "attr test" {
//     const bin = Attr(.INT8);
//     var buff: [128]u8 = undefined;
//     const b: *bin = @ptrCast(@alignCast(&buff));
//     b.set(13);
//     var v13 = b.get();
//     v13 = 14;
//     return;
// }

// pub const struct_blob_attr = extern struct {
//     id_len: u32 align(1) = @import("std").mem.zeroes(u32),
//     pub fn data(self: anytype) @import("std").zig.c_translation.FlexibleArrayType(@TypeOf(self), u8) {
//         const Intermediate = @import("std").zig.c_translation.FlexibleArrayType(@TypeOf(self), u8);
//         const ReturnType = @import("std").zig.c_translation.FlexibleArrayType(@TypeOf(self), u8);
//         return @as(ReturnType, @ptrCast(@alignCast(@as(Intermediate, @ptrCast(self)) + 4)));
//     }
// };

// pub const PS = packed struct {
//     field: bool = false,
//     id: u7 = 0,
//     plen: u24 = 0,
// };
//
// pub const PSV = packed struct {
//     ps: PS,
//     val: void,
// };
//
// pub const ESV =  extern struct {
//     ps: PS,
//     val: void,
// };
//
// pub const PSI = packed struct {
//     ps: PS,
//     val: i8,
// };
//
// pub const ESI =  extern struct {
//     ps: PS align(1),
//     val: i8 align(1),
// };
//
//
// pub fn main() !void {
//     std.debug.print("@sizeOf(PS):{d} @bitSizeOf(PS):{d}\n", .{@sizeOf(PS), @bitSizeOf(PS)});
//     std.debug.print("@sizeOf(PSV):{d} @bitSizeOf(PSV):{d}\n", .{@sizeOf(PSV), @bitSizeOf(PSV)});
//     std.debug.print("@sizeOf(ESV):{d} @bitSizeOf(ESV):{d}\n", .{@sizeOf(ESV), @bitSizeOf(ESV)});
//     std.debug.print("@sizeOf(PSI):{d} @bitSizeOf(PSI):{d}\n", .{@sizeOf(PSI), @bitSizeOf(PSI)});
//     std.debug.print("@sizeOf(ESI):{d} @bitSizeOf(ESI):{d}\n", .{@sizeOf(ESI), @bitSizeOf(ESI)});
// }

// @sizeOf(PS):4 @bitSizeOf(PS):32
// @sizeOf(PSV):4 @bitSizeOf(PSV):32
// @sizeOf(ESV):4 @bitSizeOf(ESV):32
// @sizeOf(PSI):8 @bitSizeOf(PSI):40
// @sizeOf(ESI):5 @bitSizeOf(ESI):40
