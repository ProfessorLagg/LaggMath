const builtin = @import("builtin");
const std = @import("std");

inline fn FALLBACK_64() u64 {
    return @bitCast(std.time.microTimestamp());
}
inline fn RDSEED_64() u64 {
    return asm volatile ("rdseed %rax"
        : [ret] "={rax}" (-> u64),
    );
}
pub inline fn seed_64() u64 {
    return switch (builtin.cpu.arch) {
        .x86, .x86_64 => RDSEED_64(),
        else => FALLBACK_64(),
    };
}
pub fn seed_64_arr(len: comptime_int) [len]u64{
    var arr: [len]u64 = undefined;
    for(0..len)|i|{
        arr[i] = seed_64();
    }
    return arr;
}

inline fn FALLBACK_32() u32 {
    return @truncate(FALLBACK_64());
}
inline fn RDSEED_32() u32 {
    return asm volatile ("rdseed %eax"
        : [ret] "={eax}" (-> u32),
    );
}
pub inline fn seed_32() u32 {
    return switch (builtin.cpu.arch) {
        .x86, .x86_64 => RDSEED_32(),
        else => FALLBACK_32(),
    };
}

inline fn FALLBACK_16() u16 {
    return @truncate(FALLBACK_64());
}
inline fn RDSEED_16() u16 {
    return asm volatile ("rdseed %ax"
        : [ret] "={ax}" (-> u16),
    );
}
pub inline fn seed_16() u16 {
    return switch (builtin.cpu.arch) {
        .x86, .x86_64 => RDSEED_16(),
        else => FALLBACK_16(),
    };
}

// ===== TESTS =====
test "rdseed" {
    const seed_64_a: u64 = seed_64();
    const seed_64_b: u64 = seed_64();
    const seed_32_a: u64 = seed_32();
    const seed_32_b: u64 = seed_32();
    const seed_16_a: u64 = seed_16();
    const seed_16_b: u64 = seed_16();

    try std.testing.expect(seed_64_a != seed_64_b);
    try std.testing.expect(seed_32_a != seed_32_b);
    try std.testing.expect(seed_16_a != seed_16_b);

    const len: comptime_int = 1024;
    const arr_64: [len]u64 = seed_64_arr(len);
    _ = &arr_64;
}