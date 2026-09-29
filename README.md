# Integralis
Detects possible tampering of kernel syscalls

## Build it
```
make
```

## Manage it

```
# load
sudo insmod integralis.ko

# logs
sudo dmesg | tail -20 

# unload
sudo rmmod integralis.ko
```


## Author

**Alex Maslakoff**
