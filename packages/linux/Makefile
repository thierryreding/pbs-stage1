package = linux
version = 3.5.2

major = $(word 1,$(subst ., ,$(version)))

location = http://www.kernel.org/pub/linux/kernel/v$(major).x
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)
srcdir = $(CURDIR)/packages/$(package)

include packages/common.mk

ifeq ($(arch),powerpc)
  defconfig = ppc64_defconfig
else
  defconfig = defconfig
endif

ifeq ($(arch),sh4)
  arch = sh
endif

$(pkgsrcdir)/stamp-patched:
	cd $(pkgsrcdir) && patch -p1 < $(srcdir)/patches/alpha.patch
	touch $@

$(pkgbuilddir): | $(pkgsrcdir) $(pkgsrcdir)/stamp-patched
	mkdir -p $@

common-vars = \
	O=target-$(host) \
	ARCH=$(arch)

install-vars = \
	INSTALL_HDR_PATH=$(sysroot-prefix) \
	$(common-vars)

install: | $(pkgbuilddir)
	cd $(pkgsrcdir) && $(MAKE) $(common-vars) $(defconfig)
	cd $(pkgsrcdir) && $(MAKE) $(install-vars) headers_install

.PHONY: install
