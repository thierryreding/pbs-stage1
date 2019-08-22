package = gcc
version = 9.2.0

location = http://ftp.gnu.org/pub/gnu/$(package)/$(package)-$(version)
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)
srcdir = $(CURDIR)/packages/$(package)

includedir = $(prefix)/lib/gcc/$(target)/$(version)/include

include packages/common.mk

$(pkgbuilddir)/stage1: | $(pkgsrcdir)
	mkdir -p $@

stage1-conf-args = \
	--target=$(host) \
	--prefix=$(prefix) \
	--datadir=$(exec-prefix)/share \
	--infodir=$(exec-prefix)/share/info \
	--mandir=$(exec-prefix)/share/man \
	--libexecdir=$(prefix)/lib \
	--includedir=$(includedir) \
	--with-pkgversion="PBS $(release)" \
	--program-prefix=$(target)- \
	--with-sysroot=$(sysroot) \
	--with-mpfr=$(prefix) \
	--with-gmp=$(prefix) \
	--with-ppl=$(prefix) \
	--with-cloog=$(prefix) \
	--enable-cloog-backend=isl \
	--enable-languages=c,c++ \
	--disable-shared \
	--disable-nls

ifeq ($(arch),arm)
  stage1-conf-args += --with-arch=armv7-a

  ifeq ($(fp),hard)
    stage1-conf-args += --with-float=hard

    ifeq ($(abi),eabi)
      stage1-conf-args += --with-fpu=vfp
    endif
  else
    stage1-conf-args += --with-float=softfp
  endif
endif

ifeq ($(arch),bfin)
  stage1-conf-args += --disable-threads
else
  stage1-conf-args += --enable-threads=posix
endif

ifeq ($(arch),score)
  stage1-conf-args += --enable-obsolete
endif

ifeq ($(os),none)
  stage1-conf-args += --enable-multilib --with-newlib --disable-threads --disable-libssp

  ifeq ($(arch),arm)
    stage1-conf-args += --enable-interwork
  endif

  ifeq ($(arch),powerpc)
    stage1-conf-args += --enable-targets=all
  endif
else
  ifeq ($(arch),arm)
    stage1-conf-args += --enable-multilib --enable-interwork
  endif
endif

install-stage1: | $(pkgbuilddir)/stage1
	cd $(pkgbuilddir)/stage1 && ../../configure $(stage1-conf-args)
	cd $(pkgbuilddir)/stage1 && $(MAKE) -j $(num-jobs) all-gcc
	cd $(pkgbuilddir)/stage1 && $(MAKE) install-gcc
	rm $(prefix)/bin/$(target)-gcc && \
		sed -e 's,@VERSION@,$(version),' support/gcc.in > $(prefix)/bin/$(target)-gcc && \
		chmod a+x $(prefix)/bin/$(target)-gcc

install-stage1-libgcc: | $(pkgbuilddir)/stage1
	cd $(pkgbuilddir)/stage1 && $(MAKE) -j $(num-jobs) all-target-libgcc
	cd $(pkgbuilddir)/stage1 && $(MAKE) install-target-libgcc

$(pkgbuilddir)/stage2: | $(pkgsrcdir)
	mkdir -p $@

stage2-conf-args = \
	--target=$(host) \
	--prefix=$(prefix) \
	--datadir=$(exec-prefix)/share \
	--infodir=$(exec-prefix)/share/info \
	--mandir=$(exec-prefix)/share/man \
	--libexecdir=$(prefix)/lib \
	--includedir=$(includedir) \
	--with-gxx-include-dir=$(includedir)/c++ \
	--with-pkg-version="PBS $(release)" \
	--program-prefix=$(target)- \
	--with-sysroot=$(sysroot) \
	--with-mpfr=$(prefix) \
	--with-gmp=$(prefix) \
	--with-ppl=$(prefix) \
	--with-cloog=$(prefix) \
	--enable-cloog-backend=isl \
	--enable-languages=c,c++,objc,obj-c++ \
	--disable-nls

ifeq ($(arch),arm)
  stage2-conf-args += --with-arch=armv7-a

  ifeq ($(fp),hard)
    stage2-conf-args += --with-float=hard

    ifeq ($(abi),eabi)
      stage2-conf-args += --with-fpu=vfp
    endif
  else
    stage2-conf-args += --with-float=softfp
  endif
endif

ifeq ($(arch),bfin)
  stage2-conf-args += --disable-threads
else
  stage2-conf-args += --enable-threads=posix
endif

ifeq ($(arch),riscv)
  stage1-conf-args += --disable-multilib
  stage2-conf-args += --disable-multilib
endif

ifeq ($(arch),score)
  stage1-conf-args += --enable-obsolete
endif

ifeq ($(arch),x86)
  stage1-conf-args += --disable-multilib
  stage2-conf-args += --disable-multilib
endif

ifeq ($(arch),x86_64)
  stage1-conf-args += --disable-multilib
  stage2-conf-args += --disable-multilib
endif

ifeq ($(os),none)
  stage2-conf-args += --enable-multilib --with-newlib --disable-threads --disable-libssp

  ifeq ($(arch),arm)
    stage2-conf-args += --enable-interwork
  endif

  ifeq ($(arch),powerpc)
    stage2-conf-args += --enable-targets=all
  endif
else
  ifeq ($(arch),arm)
    stage2-conf-args += --enable-multilib --enable-interwork
  endif
endif

install: | $(pkgbuilddir)/stage2
	cd $(pkgbuilddir)/stage2 && ../../configure $(stage2-conf-args)
	cd $(pkgbuilddir)/stage2 && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir)/stage2 && $(MAKE) install
	rm $(prefix)/bin/$(target)-gcc && \
		sed -e 's,@VERSION@,$(version),' support/gcc.in > $(prefix)/bin/$(target)-gcc && \
		chmod a+x $(prefix)/bin/$(target)-gcc
	mv $(prefix)/bin/$(target)-cpp $(prefix)/bin/$(target)-cpp-$(version) && ln -s $(target)-gcc $(prefix)/bin/$(target)-cpp
	mv $(prefix)/bin/$(target)-g++ $(prefix)/bin/$(target)-g++-$(version) && ln -s $(target)-gcc $(prefix)/bin/$(target)-g++
	mv $(prefix)/bin/$(target)-c++ $(prefix)/bin/$(target)-c++-$(version) && ln -s $(target)-gcc $(prefix)/bin/$(target)-c++

clean:
	rm -rf $(pkgbuilddir)

.PHONY: install-stage1 install-stage1-libgcc install clean
