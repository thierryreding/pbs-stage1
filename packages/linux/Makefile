package = linux
version = 3.5.2

major = $(word 1,$(subst ., ,$(version)))

location = http://www.kernel.org/pub/linux/kernel/v$(major).x
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)

include packages/common.mk

ifeq ($(arch),powerpc)
  defconfig = ppc64_defconfig
else
  defconfig = defconfig
endif

ifeq ($(arch),sh4)
  arch = sh
endif

$(pkgbuilddir): | $(pkgsrcdir)
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
