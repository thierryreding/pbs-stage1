#!/bin/sh

targets="alpha-linux-gnu"
targets="$targets arm-unknown-linux-gnueabi"
targets="$targets i786-pc-linux-gnu"
targets="$targets ia64-linux-gnu"
targets="$targets m68k-linux-gnu"
targets="$targets mipsel-linux-gnu"
targets="$targets mips-linux-gnu"
targets="$targets powerpc-linux-gnu"
targets="$targets s390-linux-gnu"
targets="$targets sh4-linux-gnu"
targets="$targets sparc-linux-gnu"

for target in $targets; do
	echo "building tests for $target"

	echo -n "  dynamically linked executable... "
	PATH=~/pbs-stage1/bin:$PATH $target-gcc -o test-$target test.c
	echo "done"

	echo -n "  statically linked executable... "
	PATH=~/pbs-stage1/bin:$PATH $target-gcc -static -o test-$target-static test.c
	echo "done"

	echo "done"
done
