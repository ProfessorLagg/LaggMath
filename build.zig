const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "laggmath",
        .root_source_file = b.path("src/laggmath.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);

    const unit_tests = b.addTest(.{
        .root_source_file = b.path("src/laggmath.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const vec2_tests = b.addTest(.{
        .root_source_file = b.path("src/vectors/2D.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_vec2_tests = b.addRunArtifact(vec2_tests);
    
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
    test_step.dependOn(&run_vec2_tests.step);
}
