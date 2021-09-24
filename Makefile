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

$(DESTDIR)$(PREFIX)/meta $(builddir):
	mkdir -p $@

$(DESTDIR)$(PREFIX)/meta/$(target)-binutils: | $(DESTDIR)$(PREFIX)/meta
	$(MAKE) -f packages/binutils/Makefile install
	touch $@

$(DESTDIR)$(PREFIX)/meta/m4: | $(DESTDIR)$(PREFIX)/meta
	$(MAKE) -f packages/m4/Makefile install
	touch $@

$(DESTDIR)$(PREFIX)/meta/gmp: | $(DESTDIR)$(PREFIX)/meta/m4
	$(MAKE) -f packages/gmp/Makefile install
	touch $@

$(DESTDIR)$(PREFIX)/meta/mpfr: $(DESTDIR)$(PREFIX)/meta/gmp
	$(MAKE) -f packages/mpfr/Makefile install
	touch $@

$(DESTDIR)$(PREFIX)/meta/mpc: $(DESTDIR)$(PREFIX)/meta/gmp $(DESTDIR)$(PREFIX)/meta/mpfr
	$(MAKE) -f packages/mpc/Makefile install
	touch $@

$(DESTDIR)$(PREFIX)/meta/$(target)-linux:
	$(MAKE) -f packages/linux/Makefile install
	touch $@

$(DESTDIR)$(PREFIX)/meta/$(target)-gcc-stage1: $(DESTDIR)$(PREFIX)/meta/$(target)-binutils
ifeq ($(os),linux)
$(DESTDIR)$(PREFIX)/meta/$(target)-gcc-stage1: $(DESTDIR)$(PREFIX)/meta/$(target)-linux
endif
$(DESTDIR)$(PREFIX)/meta/$(target)-gcc-stage1: $(DESTDIR)$(PREFIX)/meta/mpc
	$(MAKE) -f packages/gcc/Makefile install-stage1
	touch $@

$(DESTDIR)$(PREFIX)/meta/$(target)-glibc-stage1: $(DESTDIR)$(PREFIX)/meta/$(target)-gcc-stage1
	$(MAKE) -f packages/glibc/Makefile install-stage1
	touch $@

$(DESTDIR)$(PREFIX)/meta/$(target)-uclibc-stage1: $(DESTDIR)$(PREFIX)/meta/$(target)-gcc-stage1
	$(MAKE) -f packages/uclibc/Makefile install-stage1
	touch $@

$(DESTDIR)$(PREFIX)/meta/$(target)-newlib-stage1: $(DESTDIR)$(PREFIX)/meta/$(target)-gcc-stage1
	$(MAKE) -f packages/newlib/Makefile install-stage1
	touch $@

$(DESTDIR)$(PREFIX)/meta/$(target)-gcc-stage1-libgcc: $(DESTDIR)$(PREFIX)/meta/$(target)-$(libc)-stage1
	$(MAKE) -f packages/gcc/Makefile install-stage1-libgcc
	touch $@

$(DESTDIR)$(PREFIX)/meta/$(target)-glibc: $(DESTDIR)$(PREFIX)/meta/$(target)-gcc-stage1-libgcc
	$(MAKE) -f packages/glibc/Makefile install
	touch $@

$(DESTDIR)$(PREFIX)/meta/$(target)-uclibc: $(DESTDIR)$(PREFIX)/meta/$(target)-gcc-stage1-libgcc
	$(MAKE) -f packages/uclibc/Makefile install
	touch $@

$(DESTDIR)$(PREFIX)/meta/$(target)-newlib: $(DESTDIR)$(PREFIX)/meta/$(target)-gcc-stage1-libgcc
	$(MAKE) -f packages/newlib/Makefile install
	touch $@

$(DESTDIR)$(PREFIX)/meta/$(target)-gcc: $(DESTDIR)$(PREFIX)/meta/$(target)-binutils
$(DESTDIR)$(PREFIX)/meta/$(target)-gcc: $(DESTDIR)$(PREFIX)/meta/$(target)-$(libc)
$(DESTDIR)$(PREFIX)/meta/$(target)-gcc: $(DESTDIR)$(PREFIX)/meta/mpc
	$(MAKE) -f packages/gcc/Makefile install
	touch $@

gcc: $(DESTDIR)$(PREFIX)/meta/$(target)-gcc

$(DESTDIR)$(PREFIX)/meta/boost:
	$(MAKE) -f packages/boost/Makefile install
	touch $@

$(DESTDIR)$(PREFIX)/meta/$(target)-gdb: $(DESTDIR)$(PREFIX)/meta/boost
	$(MAKE) -f packages/gdb/Makefile install
	touch $@

gdb: $(DESTDIR)$(PREFIX)/meta/$(target)-gdb

$(DESTDIR)$(PREFIX)/meta/libtool:
	$(MAKE) -f packages/libtool/Makefile install
	touch $@

libtool: $(DESTDIR)$(PREFIX)/meta/libtool

$(DESTDIR)$(PREFIX)/meta/pkgconfig:
	$(MAKE) -f packages/pkgconfig/Makefile install
	touch $@

pkgconfig: $(DESTDIR)$(PREFIX)/meta/pkgconfig

$(DESTDIR)$(PREFIX)/meta/ccache:
	$(MAKE) -f packages/ccache/Makefile install
	touch $@

ccache: $(DESTDIR)$(PREFIX)/meta/ccache

$(DESTDIR)$(PREFIX)/meta/autoconf:
	$(MAKE) -f packages/autoconf/Makefile install
	touch $@

autoconf: $(DESTDIR)$(PREFIX)/meta/autoconf

$(DESTDIR)$(PREFIX)/meta/autoconf-archive:
	$(MAKE) -f packages/autoconf-archive/Makefile install
	touch $@

autoconf-archive: $(DESTDIR)$(PREFIX)/meta/autoconf-archive

$(DESTDIR)$(PREFIX)/meta/automake:
	$(MAKE) -f packages/automake/Makefile install
	touch $@

automake: $(DESTDIR)$(PREFIX)/meta/automake

$(DESTDIR)$(PREFIX)/meta/quilt:
	$(MAKE) -f packages/quilt/Makefile install
	touch $@

quilt: $(DESTDIR)$(PREFIX)/meta/quilt

targets = gcc gdb libtool pkgconfig ccache autoconf autoconf-archive automake quilt

all: $(targets)

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/lib/lib$(target)-sim.a
	rm -rf $(DESTDIR)$(PREFIX)/lib/gcc/$(target)
	rm -rf $(DESTDIR)$(PREFIX)/bin/$(target)-*
	rm -rf $(DESTDIR)$(PREFIX)/$(target)
	rm -rf $(DESTDIR)$(PREFIX)/meta/$(target)-*

clean-%:
	$(MAKE) -f packages/$*/Makefile clean

clean: clean-gdb clean-$(libc) clean-gcc clean-linux clean-binutils
