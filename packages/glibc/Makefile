package = glibc
version = 2.18

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

$(pkgsrcdir)/stamp-patched: | $(pkgsrcdir)
	cd $(pkgsrcdir) && \
		patch -p1 < $(srcdir)/patches/install-root.patch && \
		patch -p1 < $(srcdir)/patches/make-4.patch
	touch $@

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

#
# TODO: Fix this for x86_64. It fails during install-headers with this:
#
#     In file included from /home/thierry.reding/pbs-stage1/x86_64-unknown-linux-gnu/sys-root/usr/include/errno.h:28:0,
#                      from rpc_main.c:37:
#     /home/thierry.reding/pbs-stage1/x86_64-unknown-linux-gnu/sys-root/usr/include/features.h:399:23: fatal error: gnu/stubs.h: No such file or directory
#      #include <gnu/stubs.h>
#                            ^
#     compilation terminated.
#
install-stage1: $(pkgsrcdir)/stamp-patched | $(pkgbuilddir)/stage1
	cd $(pkgbuilddir)/stage1 && \
		$(env) ../../configure $(stage1-conf-args) $(stage1-conf-vars)
	#mkdir -p $(sysroot-prefix)/include/gnu && \
	#	touch $(sysroot-prefix)/include/gnu/stubs.h
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

ifeq ($(arch),aarch64)
install: $(pkgbuilddir)/stage2/configparms

$(pkgbuilddir)/stage2/configparms:
	echo "slibdir=/usr/lib" > $@
	echo "sbindir=/usr/bin" >> $@
	echo "rootsbindir=/usr/bin" >> $@
endif

#
# HACK: build a 32-bit variant of the GNU C library for biarch support
#
ifeq ($(arch),powerpc64)
$(pkgbuilddir)/stage2/32 $(pkgbuilddir)/stage2/64: | $(pkgbuilddir)/stage2
	mkdir -p $@

target-32 = $(subst powerpc64,powerpc,$(target))
stage2-32-conf-args = $(subst --host=$(target),--host=$(target-32),$(stage2-conf-args))
stage2-32-conf-vars = $(stage2-conf-vars) CC='$(target)-gcc -m32'

install-32: $(pkgsrcdir)/stamp-patched | $(pkgbuilddir)/stage2/32
	cd $(pkgbuilddir)/stage2/32 && \
		$(env) ../../../configure $(stage2-32-conf-args) $(stage2-32-conf-vars)
	cd $(pkgbuilddir)/stage2/32 && \
		$(env) $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir)/stage2/32 && \
		$(env) $(MAKE) $(install-vars) install

install-64: $(pkgsrcdir)/stamp-patched | $(pkgbuilddir)/stage2/64
	cd $(pkgbuilddir)/stage2/64 && \
		$(env) ../../../configure $(stage2-conf-args) $(stage2-conf-vars)
	cd $(pkgbuilddir)/stage2/64 && \
		$(env) $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir)/stage2/64 && \
		$(env) $(MAKE) $(install-vars) install

install: install-32 install-64
else
install: $(pkgsrcdir)/stamp-patched | $(pkgbuilddir)/stage2
	cd $(pkgbuilddir)/stage2 && \
		$(env) ../../configure $(stage2-conf-args) $(stage2-conf-vars)
	cd $(pkgbuilddir)/stage2 && \
		$(env) $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir)/stage2 && \
		$(env) $(MAKE) $(install-vars) install
endif

.PHONY: install-stage1 install
