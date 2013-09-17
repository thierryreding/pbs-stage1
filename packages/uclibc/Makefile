package = uclibc
version = 0.9.33.2

location = http://uclibc.org/downloads
tarballs = uClibc-$(version).tar.xz

pkgsrcdir = $(builddir)/uClibc-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)
srcdir = $(CURDIR)/packages/$(package)

include packages/common.mk

ifeq ($(arch),x86)
  defconfig = $(srcdir)/configs/$(cpu)_defconfig
else
  defconfig = $(srcdir)/configs/$(arch)_defconfig
endif

ifeq ($(arch),arm)
  defconfig += $(srcdir)/configs/$(arch)-$(fp).config
endif

common-vars = \
	CROSS_COMPILE=$(target)- \
	RUNTIME_PREFIX=/usr/ \
	DEVEL_PREFIX=/usr/ \
	PREFIX=$(sysroot)

$(pkgsrcdir)/.patch: | $(pkgsrcdir)
	cd $(pkgsrcdir) && patch -p1 < $(srcdir)/patches/config-path-len.patch
	cd $(pkgsrcdir) && patch -p1 < $(srcdir)/patches/linux-types.patch
	cd $(pkgsrcdir) && patch -p1 < $(srcdir)/patches/out-of-tree.patch
	touch $@

$(pkgbuilddir)/stage1 $(pkgbuilddir)/stage2: $(pkgsrcdir)/.patch
	mkdir -p $@

$(pkgbuilddir)/stage1/.config: $(defconfig) | $(pkgbuilddir)/stage1
	cat $(defconfig) > $@

stage1-vars = \
	O=$(CURDIR)/$(pkgbuilddir)/stage1 \
	$(common-vars)

install-stage1: $(pkgbuilddir)/stage1/.config
	cd $(pkgsrcdir) && $(env) $(MAKE) $(stage1-vars) oldconfig
	cd $(pkgsrcdir) && $(env) $(MAKE) $(stage1-vars) install_headers

$(pkgbuilddir)/stage2/.config: $(defconfig) | $(pkgbuilddir)/stage2
	cat $(defconfig) > $@

stage2-vars = \
	O=$(CURDIR)/$(pkgbuilddir)/stage2 \
	$(common-vars)

install: $(pkgbuilddir)/stage2/.config
	cd $(pkgsrcdir) && \
		$(env) $(MAKE) $(stage2-vars) oldconfig
	cd $(pkgsrcdir) && \
		$(env) $(MAKE) -j $(num-jobs) $(stage2-vars)
	cd $(pkgsrcdir) && \
		$(env) $(MAKE) -j $(num-jobs) $(stage2-vars) install

.PHONY: install-stage1 install
