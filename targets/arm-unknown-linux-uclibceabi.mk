arch = arm
cpu = unknown
os = linux
libc = uclibc
abi = eabi

target := $(arch)-$(cpu)-$(os)-$(libc)$(abi)
