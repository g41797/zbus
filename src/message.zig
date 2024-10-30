// Copyright (c) 2024 g41797
// SPDX-License-Identifier: MIT

const std = @import("std");
const blob = @import("blob.zig");
const Buffer = @import("buffer.zig").Buffer;

pub const MSG_ALIGN = 2;

pub inline fn MSG_PADDING(len: i32) i32 {
    return (len + 1 << MSG_ALIGN - 1) & ~(1 << MSG_ALIGN - 1);
}
