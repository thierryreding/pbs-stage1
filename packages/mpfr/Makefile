package = mpfr
version = 4.1.0

location = http://www.mpfr.org/$(package)-$(version)
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)

include packages/common.mk

conf-args = \
	--prefix=$(PREFIX) \
	--infodir=$(PREFIX)/share/info \
	--mandir=$(PREFIX)/share/man \
	--with-gmp=$(PREFIX)

install-args = \
	DESTDIR=$(DESTDIR)

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && ./configure $(conf-args)
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) $(install-args) install

.PHONY: install
