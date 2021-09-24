package = pkg-config
version = 0.29.2

location = http://pkgconfig.freedesktop.org/releases
tarballs = $(package)-$(version).tar.gz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)

include packages/common.mk

conf-args = \
	--prefix=$(PREFIX) \
	--infodir=$(PREFIX)/share/info \
	--mandir=$(PREFIX)/share/man \
	--with-internal-glib

install-args = \
	DESTDIR=$(DESTDIR)

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && ./configure $(conf-args)
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) $(install-args) install

.PHONY: install
