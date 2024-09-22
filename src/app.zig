const std = @import("std");
const c = @cImport({
    @cInclude("lib.h");
});
const z = @import("lib.zig");

pub fn main() !void {
    std.debug.print("Zig app: calling C library function: {d}\n", .{c.c_function(5)});
    std.debug.print("Zig app: calling Zig library function: {d}\n", .{z.zig_function(5)});
}
