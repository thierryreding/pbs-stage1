package = uclibc
version = 1.0.59

location = https://downloads.uclibc-ng.org/releases/$(version)
tarballs = uClibc-ng-$(version).tar.xz

pkgsrcdir = $(builddir)/uClibc-ng-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)
srcdir = $(CURDIR)/packages/$(package)

include packages/common.mk

ifeq ($(arch),sh4)
  arch := sh
endif

ifeq ($(arch),x86)
  defconfig = $(srcdir)/configs/$(cpu)_defconfig
else
  defconfig = $(srcdir)/configs/$(arch)_defconfig

  ifeq ($(wildcard $(defconfig)),)
    defconfig = $(pkgsrcdir)/extra/Configs/defconfigs/$(arch)/defconfig
  endif
endif

ifeq ($(arch),arm)
  defconfig += $(srcdir)/configs/$(arch)-$(fp).config
endif

common-vars = \
	KERNEL_HEADERS='$(sysroot)/usr/include' \
	CROSS_COMPILE=$(target)- \
	RUNTIME_PREFIX=/usr/ \
	DEVEL_PREFIX=/usr/ \
	PREFIX=$(sysroot)

$(pkgbuilddir)/stage1 $(pkgbuilddir)/stage2:
	mkdir -p $@

$(defconfig): | $(pkgsrcdir)

$(pkgbuilddir)/stage1/.config: $(defconfig) | $(pkgbuilddir)/stage1
	cat $(defconfig) > $@

stage1-vars = \
	O=$(CURDIR)/$(pkgbuilddir)/stage1 \
	$(common-vars)

install-stage1: $(pkgbuilddir)/stage1/.config | $(pkgsrcdir)
	cd $(pkgsrcdir) && $(MAKE) $(stage1-vars) olddefconfig
	cd $(pkgsrcdir) && $(MAKE) $(stage1-vars) install_headers

$(pkgbuilddir)/stage2/.config: $(defconfig) | $(pkgbuilddir)/stage2
	cat $(defconfig) > $@

stage2-vars = \
	O=$(CURDIR)/$(pkgbuilddir)/stage2 \
	$(common-vars)

install: $(pkgbuilddir)/stage2/.config | $(pkgsrcdir)
	cd $(pkgsrcdir) && \
		$(MAKE) $(stage2-vars) olddefconfig
	cd $(pkgsrcdir) && \
		$(MAKE) -j $(num-jobs) $(stage2-vars)
	cd $(pkgsrcdir) && \
		$(MAKE) -j $(num-jobs) $(stage2-vars) install

clean:
	rm -rf $(pkgbuilddir)

.PHONY: install-stage1 install clean
