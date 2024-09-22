const std = @import("std");
const c = @cImport({
    @cInclude("lib.h");
});
const zig_function = @import("lib.zig").zig_function;

pub fn main() !void {
    std.debug.print("Zig app: calling C library function: {d}\n", .{c.c_function(5)});
    std.debug.print("Zig app: calling Zig library function: {d}\n", .{zig_function(5)});
}

extern fn c_function(x: c_int) c_int;
