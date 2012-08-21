package = glibc
version = 2.16.0

location = http://ftp.gnu.org/pub/gnu/$(package)
tarballs = $(package)-$(version).tar.xz $(package)-ports-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)
srcdir = $(CURDIR)/packages/$(package)

include packages/common.mk

$(pkgsrcdir)/ports: | $(pkgsrcdir)
	cd $(pkgsrcdir) && patch -p1 < $(srcdir)/patches/no-shared-libgcc.patch
	ln -sf ../$(package)-ports-$(version) $@

$(pkgbuilddir)/stage1: | $(pkgsrcdir)/ports
	mkdir -p $@

stage1-conf-args = \
	--build=$(build) \
	--host=$(host) \
	--prefix=/usr \
	--datadir=/usr/share \
	--infodir=/usr/share/info \
	--mandir=/usr/share/man \
	--program-prefix=$(target)- \
	--with-headers=$(sysroot-prefix)/include \
	--enable-addons=ports

stage1-conf-vars = \
	libc_cv_forced_unwind=yes

ifeq ($(arch),x86)
  stage1-conf-vars += \
	libc_cv_386_tls=yes
endif

ifeq ($(arch),mips)
  stage1-conf-vars += \
	libc_cv_mips_tls=yes
endif

ifeq ($(arch),powerpc)
  stage1-conf-vars += \
	libc_cv_mlong_double_128ibm=yes \
	libc_cv_mlong_double_128=yes \
	libc_cv_powerpc32_tls=yes \
	libc_cv_ppc_machine=yes \
	libc_cv_ppc_rel16=yes
endif

ifeq ($(arch),sparc)
  stage1-conf-vars += \
	libc_cv_mlong_double_128=yes \
	libc_cv_sparc_tls=yes \
	libc_cv_z_relro=yes
endif

install-stage1: | $(pkgbuilddir)/stage1
	cd $(pkgbuilddir)/stage1 && $(env) ../../configure $(stage1-conf-args) $(stage1-conf-vars)
	cd $(pkgbuilddir)/stage1 && $(env) $(MAKE) install_root=$(sysroot) install-headers
	touch $(sysroot-prefix)/include/gnu/stubs.h

$(pkgbuilddir)/stage2: | $(pkgsrcdir)/ports
	mkdir -p $@

stage2-conf-args = \
	--build=$(build) \
	--host=$(host) \
	--prefix=/usr \
	--datadir=/usr/share \
	--infodir=/usr/share/info \
	--mandir=/usr/share/man \
	--program-prefix=$(target)- \
	--with-headers=$(sysroot-prefix)/include \
	--enable-addons=ports

install: | $(pkgbuilddir)/stage2
	cd $(pkgbuilddir)/stage2 && $(env) ../../configure $(stage2-conf-args)
	cd $(pkgbuilddir)/stage2 && $(env) $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir)/stage2 && $(env) $(MAKE) install_root=$(sysroot) install

.PHONY: install-stage1 install
