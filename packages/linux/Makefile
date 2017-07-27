package = linux
version = 4.12

major = $(word 1,$(subst ., ,$(version)))

location = https://www.kernel.org/pub/linux/kernel/v$(major).x
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)
srcdir = $(CURDIR)/packages/$(package)

include packages/common.mk

ifeq ($(arch),aarch64)
  arch = arm64
endif

ifeq ($(arch),bfin)
  arch = blackfin
endif

ifeq ($(arch),powerpc64)
  arch = powerpc
endif

ifeq ($(arch),sh4)
  arch = sh
endif

ifeq ($(arch),powerpc)
  defconfig = ppc64_defconfig
else
  defconfig = defconfig
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

clean:
	rm -rf $(pkgbuilddir)

.PHONY: install clean
