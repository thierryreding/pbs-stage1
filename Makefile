all:

ifndef TARGET
  $(error TARGET undefined)
endif

include targets/$(TARGET).mk
include defs.mk

ifeq ($(libc),gnu)
  libc = glibc
endif

export arch cpu os libc abi fp target

$(prefix)/meta $(builddir):
	mkdir -p $@

$(prefix)/meta/$(target)-binutils: | $(prefix)/meta
	$(MAKE) -f packages/binutils/Makefile install
	touch $@

$(prefix)/meta/m4: | $(prefix)/meta
	$(MAKE) -f packages/m4/Makefile install
	touch $@

$(prefix)/meta/gmp: | $(prefix)/meta/m4
	$(MAKE) -f packages/gmp/Makefile install
	touch $@

$(prefix)/meta/mpfr: $(prefix)/meta/gmp
	$(MAKE) -f packages/mpfr/Makefile install
	touch $@

$(prefix)/meta/mpc: $(prefix)/meta/gmp $(prefix)/meta/mpfr
	$(MAKE) -f packages/mpc/Makefile install
	touch $@

$(prefix)/meta/$(target)-linux:
	$(MAKE) -f packages/linux/Makefile install
	touch $@

$(prefix)/meta/$(target)-gcc-stage1: $(prefix)/meta/$(target)-binutils
ifeq ($(os),linux)
$(prefix)/meta/$(target)-gcc-stage1: $(prefix)/meta/$(target)-linux
endif
$(prefix)/meta/$(target)-gcc-stage1: $(prefix)/meta/mpc
	$(MAKE) -f packages/gcc/Makefile install-stage1
	touch $@

$(prefix)/meta/$(target)-glibc-stage1: $(prefix)/meta/$(target)-gcc-stage1
	$(MAKE) -f packages/glibc/Makefile install-stage1
	touch $@

$(prefix)/meta/$(target)-uclibc-stage1: $(prefix)/meta/$(target)-gcc-stage1
	$(MAKE) -f packages/uclibc/Makefile install-stage1
	touch $@

$(prefix)/meta/$(target)-newlib-stage1: $(prefix)/meta/$(target)-gcc-stage1
	$(MAKE) -f packages/newlib/Makefile install-stage1
	touch $@

$(prefix)/meta/$(target)-gcc-stage1-libgcc: $(prefix)/meta/$(target)-$(libc)-stage1
	$(MAKE) -f packages/gcc/Makefile install-stage1-libgcc
	touch $@

$(prefix)/meta/$(target)-glibc: $(prefix)/meta/$(target)-gcc-stage1-libgcc
	$(MAKE) -f packages/glibc/Makefile install
	touch $@

$(prefix)/meta/$(target)-uclibc: $(prefix)/meta/$(target)-gcc-stage1-libgcc
	$(MAKE) -f packages/uclibc/Makefile install
	touch $@

$(prefix)/meta/$(target)-newlib: $(prefix)/meta/$(target)-gcc-stage1-libgcc
	$(MAKE) -f packages/newlib/Makefile install
	touch $@

$(prefix)/meta/$(target)-gcc: $(prefix)/meta/$(target)-binutils
$(prefix)/meta/$(target)-gcc: $(prefix)/meta/$(target)-$(libc)
$(prefix)/meta/$(target)-gcc: $(prefix)/meta/mpc
	$(MAKE) -f packages/gcc/Makefile install
	touch $@

gcc: $(prefix)/meta/$(target)-gcc

$(prefix)/meta/$(target)-gdb:
	$(MAKE) -f packages/gdb/Makefile install
	touch $@

gdb: $(prefix)/meta/$(target)-gdb

$(prefix)/meta/libtool:
	$(MAKE) -f packages/libtool/Makefile install
	touch $@

libtool: $(prefix)/meta/libtool

$(prefix)/meta/pkgconfig:
	$(MAKE) -f packages/pkgconfig/Makefile install
	touch $@

pkgconfig: $(prefix)/meta/pkgconfig

$(prefix)/meta/ccache:
	$(MAKE) -f packages/ccache/Makefile install
	touch $@

ccache: $(prefix)/meta/ccache

$(prefix)/meta/autoconf:
	$(MAKE) -f packages/autoconf/Makefile install
	touch $@

autoconf: $(prefix)/meta/autoconf

$(prefix)/meta/automake:
	$(MAKE) -f packages/automake/Makefile install
	touch $@

automake: $(prefix)/meta/automake

$(prefix)/meta/quilt:
	$(MAKE) -f packages/quilt/Makefile install
	touch $@

quilt: $(prefix)/meta/quilt

targets = gcc gdb libtool pkgconfig ccache autoconf automake quilt

all: $(targets)
