package = newlib
version = 2.2.0

location = ftp://sourceware.org/pub/$(package)
tarballs = $(package)-$(version).tar.gz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)

include packages/common.mk

$(pkgbuilddir): | $(pkgsrcdir)
	mkdir -p $@

conf-args = \
	--target=$(host) \
	--prefix=$(sysroot-prefix)

install-stage1: | $(pkgbuilddir)
	cd $(pkgbuilddir) && \
		$(env) ../configure $(conf-args) $(conf-vars)
	cd $(pkgbuilddir) && \
		$(env) $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && \
		$(env) $(MAKE) $(install-vars) install
	rmdir $(sysroot-prefix)/include && \
		mv $(sysroot-prefix)/$(target)/include $(sysroot-prefix)/include
	mv $(sysroot-prefix)/$(target)/lib $(sysroot-prefix)/lib

install: | $(pkgbuilddir)

.PHONY: install-stage1 install
