package = glibc
version = 2.17

location = http://ftp.gnu.org/pub/gnu/$(package)
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)
srcdir = $(CURDIR)/packages/$(package)

include packages/common.mk

$(pkgbuilddir): | $(pkgsrcdir)
	mkdir -p $@

$(pkgbuilddir)/stage1 $(pkgbuilddir)/stage2: | $(pkgbuilddir)
	mkdir -p $@

install-vars = \
	install_root=$(sysroot) \
	prefix=/usr

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

install-stage1: | $(pkgbuilddir)/stage1
	cd $(pkgbuilddir)/stage1 && \
		$(env) ../../configure $(stage1-conf-args) $(stage1-conf-vars)
	touch $(sysroot-prefix)/include/gnu/stubs.h
	cd $(pkgbuilddir)/stage1 && \
		$(env) $(MAKE) $(install-vars) install-headers
	touch $(sysroot-prefix)/include/gnu/stubs.h

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

stage2-conf-vars = \
	libc_cv_ssp=no

#
# On IA64, the programs built by glibc cannot be properly linked because
# they reference symbols defined only by the shared libunwind that is
# only built by stage2 of gcc. We work around this by instructing the
# build system to not build the problematic programs.
#
ifeq ($(arch),ia64)
install: $(pkgbuilddir)/stage2/configparms

$(pkgbuilddir)/stage2/configparms:
	echo "build-programs = no" > $@
endif

install: | $(pkgbuilddir)/stage2
	cd $(pkgbuilddir)/stage2 && \
		$(env) ../../configure $(stage2-conf-args) $(stage2-conf-vars)
	cd $(pkgbuilddir)/stage2 && \
		$(env) $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir)/stage2 && \
		$(env) $(MAKE) $(install-vars) install

.PHONY: install-stage1 install
