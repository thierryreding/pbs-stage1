package = ccache
version = 4.7.4

location = https://github.com/ccache/ccache/releases/download/v$(version)
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)

include packages/common.mk

cmake-args = \
	-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
	-DREDIS_STORAGE_BACKEND=off

install-args = \
	DESTDIR=$(DESTDIR)

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && cmake $(cmake-args) $(abspath $(pkgsrcdir))
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) $(install-args) install

.PHONY: install
