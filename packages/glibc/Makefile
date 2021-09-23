package = glibc
version = 2.34

location = http://ftp.gnu.org/pub/gnu/$(package)
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)
srcdir = $(CURDIR)/packages/$(package)

include packages/common.mk

#
# Force gcc for the build to avoid using the bootstrap compiler from stage 1
# if $build == $host. Otherwise the stage1 glibc build will fail because it
# will try to use the bootstrap compiler to generate programs needed during
# the build.
#
ifeq ($(build),$(host))
  common-conf-vars += BUILD_CC=gcc
endif

$(pkgbuilddir):
	mkdir -p $@

$(pkgbuilddir)/stage1 $(pkgbuilddir)/stage2: | $(pkgbuilddir)
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
	$(common-conf-vars) \
	libc_cv_forced_unwind=yes

install-vars = \
	DESTDIR=$(sysroot)

install-stage1: | $(pkgbuilddir)/stage1
	cd $(pkgbuilddir)/stage1 && \
		../../configure $(stage1-conf-args) $(stage1-conf-vars)
	cd $(pkgbuilddir)/stage1 && \
		$(MAKE) $(install-vars) install-headers
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
	$(common-conf-vars)

$(pkgbuilddir)/stage2/configparms: | $(pkgbuilddir)/stage2
	echo "slibdir=/usr/lib" > $@
	echo "rtlddir=/usr/lib" >> $@
	echo "sbindir=/usr/bin" >> $@
	echo "rootsbindir=/usr/bin" >> $@
#
# On IA64, the programs built by glibc cannot be properly linked because
# they reference symbols defined only by the shared libunwind that is
# only built by stage2 of gcc. We work around this by instructing the
# build system to not build the problematic programs.
#
ifeq ($(arch),ia64)
	echo "build-programs=no" >> $@
endif

#
# HACK: build a 32-bit variant of the GNU C library for biarch support
#
ifeq ($(arch),powerpc64)
$(pkgbuilddir)/stage2/32 $(pkgbuilddir)/stage2/64:
	mkdir -p $@

target-32 = $(subst powerpc64,powerpc,$(target))
stage2-32-conf-args = $(subst --host=$(target),--host=$(target-32),$(stage2-conf-args))
stage2-32-conf-vars = $(stage2-conf-vars) CC='$(target)-gcc -m32'

install-32: $(pkgbuilddir)/stage2/configparams | $(pkgbuilddir)/stage2/32
	cd $(pkgbuilddir)/stage2/32 && \
		../../../configure $(stage2-32-conf-args) $(stage2-32-conf-vars)
	cd $(pkgbuilddir)/stage2/32 && \
		$(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir)/stage2/32 && \
		$(MAKE) $(install-vars) install

install-64: $(pkgbuilddir)/stage2/configparams | $(pkgbuilddir)/stage2/64
	cd $(pkgbuilddir)/stage2/64 && \
		../../../configure $(stage2-conf-args) $(stage2-conf-vars)
	cd $(pkgbuilddir)/stage2/64 && \
		$(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir)/stage2/64 && \
		$(MAKE) $(install-vars) install

install: install-32 install-64
else
install: $(pkgbuilddir)/stage2/configparms
	cd $(pkgbuilddir)/stage2 && \
		../../configure $(stage2-conf-args) $(stage2-conf-vars)
	cd $(pkgbuilddir)/stage2 && \
		$(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir)/stage2 && \
		$(MAKE) $(install-vars) install
endif

clean:
	rm -rf $(pkgbuilddir)

.PHONY: install-stage1 install clean
