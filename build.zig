const std = @import("std");
const zonfig_module = @import("./src/zonfig.zig");

pub fn addConfig(b: *std.Build, module: *std.Build.Module, path: []const u8, name: []const u8) !void {
    return zonfig_module.addConfig(b, module, path, name);
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //const lib = b.addStaticLibrary(.{
    //    .name = "zonfig",
    //    .root_source_file = b.path("src/zonfig.zig"),
    //    .target = target,
    //    .optimize = optimize,
    //});

    //b.installArtifact(lib);

    const module = b.addModule("zonfig", .{
        .root_source_file = b.path("src/zonfig.zig"),
        .target = target,
        .optimize = optimize,
    });
    _ = module;

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/test.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
