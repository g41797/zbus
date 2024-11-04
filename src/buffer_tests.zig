// Copyright (c) 2024 g41797
// SPDX-License-Identifier: MIT

const std = @import("std");
const testing = std.testing;

const buffer = @import("buffer.zig");
const Buffer = buffer.Buffer;
const Mode = buffer.Mode;

test "buffer_tests nop" {
    try std.testing.expectEqual(true, true);
}

test "buffer_tests init for write" {
    const min_len = 0x100;
    const max_len = 0x1000;
    var buf = Buffer{};
    try testing.expectError(error.EmptyBuffer, buf.set_mode(.write));
    _ = try buf.init(std.testing.allocator, min_len, max_len);
    defer buf.free();
    try buf.set_mode(.write);

    try testing.expectEqual(min_len, buf.available());

    try buf.forward(min_len);

    try testing.expectEqual(0, buf.available());
    try testing.expectError(error.CannotForwardAfterEndOfTheBuffer, buf.forward(min_len));
    try buf.realloc(min_len * 2);
    try testing.expectEqual(min_len, buf.available());
    try buf.forward(min_len - 1);
    try testing.expectEqual(1, buf.available());
}
