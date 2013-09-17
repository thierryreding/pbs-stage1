arch = arm
cpu = unknown
os = linux
libc = gnu
abi = eabi
fp = soft

target := $(arch)-$(cpu)-$(os)-$(libc)$(abi)
