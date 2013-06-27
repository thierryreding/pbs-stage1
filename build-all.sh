targets="
alpha-linux-gnu
arm-unknown-linux-gnueabi
arm-unknown-linux-uclibceabi
armv7l-unknown-linux-gnueabihf
i586-pc-linux-gnu
i586-pc-linux-uclibc
i786-pc-linux-gnu
ia64-linux-gnu
m68k-linux-gnu
mips-linux-gnu
mipsel-linux-gnu
powerpc-linux-gnu
s390-linux-gnu
sh4-linux-gnu
sparc-linux-gnu
x86_64-unknown-linux-gnu
"

log_begin()
{
	echo -n "$@..."
}

log_end()
{
	if test "x$1" != "x0"; then
		echo "failed ($1)"
	else
		echo "done"
	fi
}

for target in $targets; do
	log_begin "building $target"
	make TARGET=$target > logs/$target.log 2>&1
	log_end $?
done
