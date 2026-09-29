#include <linux/module.h>
#include <linux/init.h>

extern int moduleInit(void);
extern void moduleExit(void);

static int __init module_init_delegate(void)
{
    return moduleInit();
}

static void __exit module_exit_delegate(void)
{
    moduleExit();
}

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Alex Maslakoff");
MODULE_DESCRIPTION("Integrity guard for tampering of syscalls of Linux kernel");
MODULE_VERSION("0.1");

module_init(module_init_delegate);
module_exit(module_exit_delegate);
