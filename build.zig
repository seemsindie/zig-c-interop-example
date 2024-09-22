const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    // const optimize = b.standardOptimizeOption(.{});

    const optimize = b.option(
        std.builtin.OptimizeMode,
        "optimize",
        "Optimization mode",
    ) orelse .ReleaseSmall;

    // Build the C library
    const lib_c = b.addStaticLibrary(.{
        .name = "c_lib",
        .target = target,
        .optimize = optimize,
    });

    lib_c.addCSourceFile(.{
        .file = b.path("src/lib.c"),
        .flags = &[_][]const u8{"-std=c99"},
    });
    lib_c.addIncludePath(b.path("include"));
    lib_c.linkLibC();

    // Build the Zig library
    const lib_zig = b.addStaticLibrary(.{
        .name = "zig_lib",
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Build the C application
    const exe_c = b.addExecutable(.{
        .name = "c_app",
        .target = target,
        .optimize = optimize,
    });

    exe_c.addCSourceFile(.{
        .file = b.path("src/app.c"),
        .flags = &[_][]const u8{"-std=c99"},
    });
    exe_c.addIncludePath(b.path("include"));
    exe_c.addIncludePath(b.path("src"));
    exe_c.linkLibrary(lib_c);
    exe_c.linkLibrary(lib_zig);
    exe_c.linkLibC();

    // Build the Zig application
    const exe_zig = b.addExecutable(.{
        .name = "zig_app",
        .root_source_file = b.path("src/app.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe_zig.addIncludePath(b.path("include"));
    exe_zig.addIncludePath(b.path("src"));
    exe_zig.linkLibrary(lib_c);
    exe_zig.linkLibC();

    // Create install steps
    b.installArtifact(exe_c);
    b.installArtifact(exe_zig);

    // Create run steps
    const run_cmd_c = b.addRunArtifact(exe_c);
    const run_cmd_zig = b.addRunArtifact(exe_zig);

    const run_step_c = b.step("run-c", "Run the C app");
    run_step_c.dependOn(&run_cmd_c.step);

    const run_step_zig = b.step("run-zig", "Run the Zig app");
    run_step_zig.dependOn(&run_cmd_zig.step);
}
