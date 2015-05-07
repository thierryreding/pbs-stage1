arch = arm
variant = v7l
cpu = unknown
os = linux
libc = gnu
abi = eabi
fp = soft

target := $(arch)$(variant)-$(cpu)-$(os)-$(libc)$(abi)
