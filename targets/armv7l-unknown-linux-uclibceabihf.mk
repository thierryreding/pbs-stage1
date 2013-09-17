arch = arm
variant = v7l
cpu = unknown
os = linux
libc = uclibc
abi = eabi
fp = hard

target := $(arch)$(variant)-$(cpu)-$(os)-$(libc)$(abi)hf
