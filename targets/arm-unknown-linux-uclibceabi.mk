arch = arm
cpu = unknown
os = linux
libc = uclibc
abi = eabi
fp = soft

target := $(arch)-$(cpu)-$(os)-$(libc)$(abi)
