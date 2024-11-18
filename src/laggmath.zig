const std = @import("std");
pub const Vectors = struct {
    usingnamespace @import("vectors/Vec2.zig");
};

pub const seeding = @import("random/seeding.zig");

// test "Optimized Divide by Zero" {
//     @setFloatMode(.optimized);
//     @setRuntimeSafety(false);
//     // Arrange
//     const k0: f32 = 0;
//     const k1: f32 = 123;
//     const k2: f32 = -123;

//     // Act
//     const kd0: f32 = k0 / 0;
//     const kd1: f32 = k1 / 0;
//     const kd2: f32 = k2 / 0;

//     // Assert
//     std.debug.print("{d} / 0 = {d} (0x{x})\n", .{ k0, kd0, @as(u32, @bitCast(kd0)) });
//     std.debug.print("{d} / 0 = {d} (0x{x})\n", .{ k1, kd1, @as(u32, @bitCast(kd1)) });
//     std.debug.print("{d} / 0 = {d} (0x{x})\n", .{ k2, kd2, @as(u32, @bitCast(kd2)) });
// }
