extern fn _printk(fmt: [*:0]const u8, ...) c_int;

export fn moduleInit() linksection(".init.text") callconv(.c) c_int {
    _ = _printk("[INTEGRALIS] module initialized\n");
    return 0;
}

export fn moduleExit() linksection(".exit.text") callconv(.c) void {
    _ = _printk("[INTEGRALIS] module exited\n");
}
