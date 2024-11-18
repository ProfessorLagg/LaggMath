const std = @import("std");

pub const Vectors = struct {
    usingnamespace @import("vectors/2D.zig");
};

pub const seeding = @import("random/seeding.zig");

test "Vectors" {
    const x: f32 = @bitCast(seeding.seed_32());
    const y: f32 = @bitCast(seeding.seed_32());
    const v0: @Vector(2, f32) = @Vector(2, f32){ x, y };
    const v1: Vectors.Vec2 = Vectors.Vec2{ x, y };

    try std.testing.expectEqual(v0[0], v1[0]);
    try std.testing.expectEqual(v0[1], v1[1]);
}
