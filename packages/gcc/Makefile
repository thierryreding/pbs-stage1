package = gcc
version = 4.7.1

location = http://ftp.gnu.org/pub/gnu/$(package)/$(package)-$(version)
tarballs = $(package)-$(version).tar.bz2

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)

include packages/common.mk

stage1-conf-args = \
	--target=$(host) \
	--prefix=$(prefix) \
	--datadir=$(exec-prefix)/share \
	--infodir=$(exec-prefix)/share/info \
	--mandir=$(exec-prefix)/share/man \
	--libdir=$(sysroot-prefix)/lib \
	--libexecdir=$(sysroot-prefix)/lib \
	--includedir=$(sysroot-prefix)/include \
	--with-pkgversion="PBS $(release)" \
	--program-prefix=$(target)- \
	--with-sysroot=$(sysroot) \
	--with-mpfr=$(prefix) \
	--with-gmp=$(prefix) \
	--with-ppl=$(prefix) \
	--enable-languages=c \
	--disable-threads \
	--disable-shared \
	--disable-nls

ifeq ($(os),none)
  stage1-conf-args += --enable-multilib --with-newlib

  ifeq ($(arch),arm)
    stage1-conf-args += --enable-interwork
  endif
endif

$(pkgbuilddir)/stage1: | $(pkgsrcdir)
	mkdir -p $@

install-stage1: | $(pkgbuilddir)/stage1
	cd $(pkgbuilddir)/stage1 && $(env) ../../configure $(stage1-conf-args)
	cd $(pkgbuilddir)/stage1 && $(env) $(MAKE) -j $(num-jobs) all-gcc
	cd $(pkgbuilddir)/stage1 && $(env) $(MAKE) install-gcc
	rm $(prefix)/bin/$(target)-gcc && \
		sed -e 's,@VERSION@,$(version),' support/gcc.in > $(prefix)/bin/$(target)-gcc && \
		chmod a+x $(prefix)/bin/$(target)-gcc

install-stage1-libgcc: | $(pkgbuilddir)/stage1
	cd $(pkgbuilddir)/stage1 && $(env) $(MAKE) -j $(num-jobs) all-target-libgcc
	cd $(pkgbuilddir)/stage1 && $(env) $(MAKE) install-target-libgcc

$(pkgbuilddir)/stage2: | $(pkgsrcdir)
	mkdir -p $@

stage2-conf-args = \
	--target=$(host) \
	--prefix=$(prefix) \
	--datadir=$(exec-prefix)/share \
	--infodir=$(exec-prefix)/share/info \
	--mandir=$(exec-prefix)/share/man \
	--libdir=$(exec-prefix)/lib \
	--libexecdir=$(exec-prefix)/lib \
	--includedir=$(sysroot-prefix)/include \
	--with-gxx-include-dir=$(sysroot-prefix)/include/c++/$(version) \
	--with-pkg-version="PBS $(release)" \
	--program-prefix=$(target)- \
	--with-sysroot=$(sysroot) \
	--with-mpfr=$(prefix) \
	--with-gmp=$(prefix) \
	--with-ppl=$(prefix) \
	--enable-languages=c,c++,objc,obj-c++ \
	--disable-libssp \
	--disable-nls

ifeq ($(os),none)
  stage2-conf-args += --enable-multilib --with-newlib

  ifeq ($(arch),arm)
    stage2-conf-args += --enable-interwork
  endif
endif

install: | $(pkgbuilddir)/stage2
	cd $(pkgbuilddir)/stage2 && $(env) ../../configure $(stage2-conf-args)
	cd $(pkgbuilddir)/stage2 && $(env) $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir)/stage2 && $(env) $(MAKE) install
	mv $(prefix)/bin/$(target)-cpp $(prefix)/bin/$(target)-cpp-$(version) && ln -s $(target)-gcc $(prefix)/bin/$(target)-cpp
	mv $(prefix)/bin/$(target)-g++ $(prefix)/bin/$(target)-g++-$(version) && ln -s $(target)-gcc $(prefix)/bin/$(target)-g++
	mv $(prefix)/bin/$(target)-c++ $(prefix)/bin/$(target)-c++-$(version) && ln -s $(target)-gcc $(prefix)/bin/$(target)-c++

.PHONY: install-stage1 install-stage1-libgcc
