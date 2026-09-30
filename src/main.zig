//TODO
const NR_SYSCALLS_WATCH = 10;
const KSYM_SYMBOL_LEN: usize = 512;
const LOG_MODULE_NAME = "[integralis] ";
const LOG_LEVEL_KERN_ERR = "<3>";
const LOG_ERR_PREFIX = LOG_LEVEL_KERN_ERR ++ LOG_MODULE_NAME ++ ": ";

extern fn _printk(fmt: [*:0]const u8, ...) c_int;

extern fn copy_from_kernel_nofault(
    dst: ?*anyopaque,
    src: ?*const anyopaque,
    size: usize,
) c_int;

extern fn sprint_symbol(
    buffer: [*]u8,
    address: usize,
) c_int;


export fn moduleInit() linksection(".init.text") callconv(.c) c_int {
    _ = _printk(LOG_MODULE_NAME ++ "module initialized\n");
    return 0;
}

export fn moduleExit() linksection(".exit.text") callconv(.c) void {
    _ = _printk(LOG_MODULE_NAME ++ "module exited\n");
}

//TODO
var syscallTableBaseline: [NR_SYSCALLS_WATCH]usize = undefined;
var syscallTable: ?[*]const usize = null;
var sysCallTableCount: usize = 0;
var sysCallTablePtr: ?[*]usize = null;

fn checkSyscallTable() void {
    if (sysCallTablePtr == null or sysCallTableCount == 0) {
        return;
    }

    var index: usize = 0;

    while (index < sysCallTableCount) : (index += 1) {
        var current: usize = 0;

        if (copy_from_kernel_nofault(
            &current,
            sysCallTablePtr.? + index,
            @sizeOf(usize),
        ) != 0) {
            continue;
        }

        if (current != syscallTableBaseline[index]) {
            var symbol: [KSYM_SYMBOL_LEN]u8 = [_]u8{0} ** KSYM_SYMBOL_LEN;

            sprint_symbol(&symbol, current);
            _printk(
                LOG_ERR_PREFIX ++ "[checkSyscallTable hook] syscall[%d] expected=%px got=%px (%s)\n",
                @as(c_int, @intCast(index)),
                syscallTableBaseline[index],
                current,
                &symbol,
            );
        }
    }
}
