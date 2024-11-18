const std = @import("std");
pub const Vec2 = @Vector(2, f32);
/// returns the sign of each float in the vector
pub inline fn sign(v: Vec2) Vec2 {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    const v_gt0: @Vector(2, i32) = @intFromBool(v > (comptime Vec2{ 0, 0 }));
    const v_lt0: @Vector(2, i32) = @intFromBool(v < (comptime Vec2{ 0, 0 }));
    const vd: @Vector(2, i32) = v_gt0 - v_lt0;
    return @floatFromInt(vd);
}
/// Maps a vector from 1 number range to another
pub inline fn map(x: Vec2, input_start: Vec2, input_end: Vec2, output_start: Vec2, output_end: Vec2) Vec2 {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    return (x - input_start) / (input_end - input_start) * (output_end - output_start) + output_start;
}
/// Clamps the vector to a certain range
pub inline fn clamp(v: Vec2, min: Vec2, max: Vec2) Vec2 {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    return @max(min, @min(max, v));
}
/// returns the magnitude (also known as length) of this 2D vector
pub inline fn magnitude(v: Vec2) f32 {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    const x2 = v[0] * v[0];
    const y2 = v[1] * v[1];
    return @sqrt(x2 + y2);
}
/// Scales the vector down to have a length of 1
pub inline fn normalize(v: Vec2) Vec2 {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    const m: f32 = magnitude(v);
    const vm: Vec2 = @splat(m);
    const result: Vec2 = v / vm;
    const isNormal: bool = std.math.isNormal(m);
    const pred: @Vector(2, bool) = @splat(isNormal);
    return @select(f32, pred, result, (comptime Vec2{ 0, 0 }));
}

/// Linear Interpolates between v0 and v1. t should be in the range [0 - 1]
pub inline fn lerp(x: Vec2, y: Vec2, t: Vec2) Vec2 {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    const d: Vec2 = (y - x);
    return @mulAdd(Vec2, d, t, x);
    //return a + t * (b - a);
}
/// Returns the square of the euclidian distance between 2 points
pub inline fn distanceSquared(a: Vec2, b: Vec2) f32 {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    const d: Vec2 = a - b;
    const d2: Vec2 = d * d;
    return @reduce(.Add, d2);
}
/// Returns the euclidian distance between 2 points
pub inline fn distance(a: Vec2, b: Vec2) f32 {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    return @sqrt(distanceSquared(a, b));
}
/// Returns a direction vector going from a to b with a length of 1
pub inline fn direction(from: Vec2, to: Vec2) Vec2 {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    const v_diff: Vec2 = to - from;
    const v_diff_normalized: Vec2 = normalize(v_diff);
    // return v_diff_normalized * (comptime Vec2{ 2, 2 });
    return v_diff_normalized;
}

// ===== TESTS =====
test "sign" {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    // Arrange
    const v0: Vec2 = Vec2{ 0, 0 };
    const v1: Vec2 = Vec2{ 0, 123 };
    const v2: Vec2 = Vec2{ 0, -123 };
    const v3: Vec2 = Vec2{ 123, 0 };
    const v4: Vec2 = Vec2{ 123, 123 };
    const v5: Vec2 = Vec2{ 123, -123 };
    const v6: Vec2 = Vec2{ -123, 0 };
    const v7: Vec2 = Vec2{ -123, 123 };
    const v8: Vec2 = Vec2{ -123, -123 };

    // Act
    const sv0: Vec2 = sign(v0);
    const sv1: Vec2 = sign(v1);
    const sv2: Vec2 = sign(v2);
    const sv3: Vec2 = sign(v3);
    const sv4: Vec2 = sign(v4);
    const sv5: Vec2 = sign(v5);
    const sv6: Vec2 = sign(v6);
    const sv7: Vec2 = sign(v7);
    const sv8: Vec2 = sign(v8);

    // Assert
    try std.testing.expectEqual(sv0, (comptime Vec2{ 0, 0 }));
    try std.testing.expectEqual(sv1, (comptime Vec2{ 0, 1 }));
    try std.testing.expectEqual(sv2, (comptime Vec2{ 0, -1 }));
    try std.testing.expectEqual(sv3, (comptime Vec2{ 1, 0 }));
    try std.testing.expectEqual(sv4, (comptime Vec2{ 1, 1 }));
    try std.testing.expectEqual(sv5, (comptime Vec2{ 1, -1 }));
    try std.testing.expectEqual(sv6, (comptime Vec2{ -1, 0 }));
    try std.testing.expectEqual(sv7, (comptime Vec2{ -1, 1 }));
    try std.testing.expectEqual(sv8, (comptime Vec2{ -1, -1 }));
}
test "map" {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    // Arrange
    const v0: Vec2 = Vec2{ 0, 0 };
    const v1: Vec2 = Vec2{ 0, 123 };
    const v2: Vec2 = Vec2{ 0, -123 };
    const v3: Vec2 = Vec2{ 123, 0 };
    const v4: Vec2 = Vec2{ 123, 123 };
    const v5: Vec2 = Vec2{ 123, -123 };
    const v6: Vec2 = Vec2{ -123, 0 };
    const v7: Vec2 = Vec2{ -123, 123 };
    const v8: Vec2 = Vec2{ -123, -123 };

    const rn1: Vec2 = Vec2{ -1.0, -1.0 };
    const rp1: Vec2 = Vec2{ 1.0, 1.0 };
    const rn2: Vec2 = Vec2{ -123.0, -123.0 };
    const rp2: Vec2 = Vec2{ 123.0, 123.0 };

    // Act
    const m0: Vec2 = map(v0, rn2, rp2, rn1, rp1);
    const m1: Vec2 = map(v1, rn2, rp2, rn1, rp1);
    const m2: Vec2 = map(v2, rn2, rp2, rn1, rp1);
    const m3: Vec2 = map(v3, rn2, rp2, rn1, rp1);
    const m4: Vec2 = map(v4, rn2, rp2, rn1, rp1);
    const m5: Vec2 = map(v5, rn2, rp2, rn1, rp1);
    const m6: Vec2 = map(v6, rn2, rp2, rn1, rp1);
    const m7: Vec2 = map(v7, rn2, rp2, rn1, rp1);
    const m8: Vec2 = map(v8, rn2, rp2, rn1, rp1);

    // Assert
    try std.testing.expectEqual((comptime Vec2{ 0, 0 }), m0);
    try std.testing.expectEqual((comptime Vec2{ 0, 1 }), m1);
    try std.testing.expectEqual((comptime Vec2{ 0, -1 }), m2);
    try std.testing.expectEqual((comptime Vec2{ 1, 0 }), m3);
    try std.testing.expectEqual((comptime Vec2{ 1, 1 }), m4);
    try std.testing.expectEqual((comptime Vec2{ 1, -1 }), m5);
    try std.testing.expectEqual((comptime Vec2{ -1, 0 }), m6);
    try std.testing.expectEqual((comptime Vec2{ -1, 1 }), m7);
    try std.testing.expectEqual((comptime Vec2{ -1, -1 }), m8);
}
test "clamp" {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    // Arrange
    const v0: Vec2 = Vec2{ 0, 0 };
    const v1: Vec2 = Vec2{ 0, 123 };
    const v2: Vec2 = Vec2{ 0, -123 };
    const v3: Vec2 = Vec2{ 123, 0 };
    const v4: Vec2 = Vec2{ 123, 123 };
    const v5: Vec2 = Vec2{ 123, -123 };
    const v6: Vec2 = Vec2{ -123, 0 };
    const v7: Vec2 = Vec2{ -123, 123 };
    const v8: Vec2 = Vec2{ -123, -123 };

    const rn1: Vec2 = Vec2{ -1.0, -1.0 };
    const rp1: Vec2 = Vec2{ 1.0, 1.0 };

    // Act
    const m0: Vec2 = clamp(v0, rn1, rp1);
    const m1: Vec2 = clamp(v1, rn1, rp1);
    const m2: Vec2 = clamp(v2, rn1, rp1);
    const m3: Vec2 = clamp(v3, rn1, rp1);
    const m4: Vec2 = clamp(v4, rn1, rp1);
    const m5: Vec2 = clamp(v5, rn1, rp1);
    const m6: Vec2 = clamp(v6, rn1, rp1);
    const m7: Vec2 = clamp(v7, rn1, rp1);
    const m8: Vec2 = clamp(v8, rn1, rp1);

    // Assert
    try std.testing.expectEqual((comptime Vec2{ 0, 0 }), m0);
    try std.testing.expectEqual((comptime Vec2{ 0, 1 }), m1);
    try std.testing.expectEqual((comptime Vec2{ 0, -1 }), m2);
    try std.testing.expectEqual((comptime Vec2{ 1, 0 }), m3);
    try std.testing.expectEqual((comptime Vec2{ 1, 1 }), m4);
    try std.testing.expectEqual((comptime Vec2{ 1, -1 }), m5);
    try std.testing.expectEqual((comptime Vec2{ -1, 0 }), m6);
    try std.testing.expectEqual((comptime Vec2{ -1, 1 }), m7);
    try std.testing.expectEqual((comptime Vec2{ -1, -1 }), m8);
}
test "magnitude" {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    const v: Vec2 = Vec2{ 3, 4 };
    const m: f32 = magnitude(v);

    try std.testing.expectEqual(5, m);
}
test "normalize" {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    // Arrange
    const v0: Vec2 = Vec2{ 5, 5 };
    const v1: Vec2 = Vec2{ 5, -5 };
    const v2: Vec2 = Vec2{ -5, 5 };
    const v3: Vec2 = Vec2{ -5, -5 };

    // Act
    const n0: Vec2 = normalize(v0);
    const n1: Vec2 = normalize(v1);
    const n2: Vec2 = normalize(v2);
    const n3: Vec2 = normalize(v3);

    // Assert
    // TODO Find a proper way to round this to a number of decimal places
    try std.testing.expectEqual(1.0, @round(magnitude(n0)));
    try std.testing.expectEqual(1.0, @round(magnitude(n1)));
    try std.testing.expectEqual(1.0, @round(magnitude(n2)));
    try std.testing.expectEqual(1.0, @round(magnitude(n3)));
}
test "lerp" {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    // Arrange
    const len: comptime_int = 10;
    const v0: Vec2 = Vec2{ 11.0, 19.0 };
    const v1: Vec2 = Vec2{ 89.0, 97.0 };
    // Act
    var testVals: [len]Vec2 = undefined;
    var trueVals: [len]Vec2 = undefined;
    for (0..len) |i| {
        const t_f32: f32 = @as(f32, @floatFromInt(i)) / @as(f32, @floatFromInt(len));
        const t_vec: Vec2 = Vec2{ t_f32, t_f32 };
        testVals[i] = lerp(v0, v1, t_vec);
        trueVals[i] = std.math.lerp(v0, v1, t_vec);
    }

    // Assert
    for (0..len) |i| {
        try std.testing.expectEqual(trueVals[i], testVals[i]);
    }
}
test "distanceSquared" {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    // Arrange
    const v0: Vec2 = Vec2{ 0, 0 };
    const v1: Vec2 = Vec2{ 3, 4 };

    // Act
    const d: f32 = distanceSquared(v0, v1);

    // Assert
    try std.testing.expectEqual(25.0, d);
}
test "distance" {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    // Arrange
    const v0: Vec2 = Vec2{ 0, 0 };
    const v1: Vec2 = Vec2{ 3, 4 };

    // Act
    const d: f32 = distance(v0, v1);

    // Assert
    try std.testing.expectEqual(5.0, d);
}
test "direction" {
    @setFloatMode(.optimized);
    @setRuntimeSafety(false);
    // Arrange
    const v0: Vec2 = Vec2{ 0.0, 0.0 };
    const v1: Vec2 = Vec2{ 3.0, 4.0 };
    const v2: Vec2 = Vec2{ -3.0, 4.0 };
    const v3: Vec2 = Vec2{ -3.0, -4.0 };
    const v4: Vec2 = Vec2{ 3.0, -4.0 };

    // Act
    const a01: Vec2 = direction(v0, v1);
    const a02: Vec2 = direction(v0, v2);
    const a03: Vec2 = direction(v0, v3);
    const a04: Vec2 = direction(v0, v4);
    // Assert
    try std.testing.expectEqual(comptime @sqrt(Vec2{ 2, 2 }) / Vec2{ 2, 2 }, direction(v0, Vec2{ 1, 1 }));
    try std.testing.expectEqual(Vec2{ 1, 1 }, std.math.sign(a01));
    try std.testing.expectEqual(Vec2{ -1, 1 }, std.math.sign(a02));
    try std.testing.expectEqual(Vec2{ -1, -1 }, std.math.sign(a03));
    try std.testing.expectEqual(Vec2{ 1, -1 }, std.math.sign(a04));
    try std.testing.expectEqual(1.0, magnitude(a01));
    try std.testing.expectEqual(1.0, magnitude(a02));
    try std.testing.expectEqual(1.0, magnitude(a03));
    try std.testing.expectEqual(1.0, magnitude(a04));
}
