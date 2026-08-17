package = pkgconf
version = 3.0.5

location = https://github.com/pkgconf/pkgconf/archive/refs/tags
tarballs = $(package)-$(version).tar.gz

pkgsrcdir = $(builddir)/$(package)-$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/obj-native

include packages/common.mk

conf-args = \
	--prefix=$(PREFIX) \
	-Ddefault_library=static

install-args = \
	--destdir=$(DESTDIR)

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && meson setup .. $(conf-args)
	cd $(pkgbuilddir) && meson compile
	cd $(pkgbuilddir) && meson install $(install-args)
	ln -sf pkgconf $(PREFIX)/bin/pkg-config

.PHONY: install
