package = gmp
version = 6.2.1

location = http://ftp.gnu.org/gnu/$(package)
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)

include packages/common.mk

conf-args = \
	--prefix=$(PREFIX) \
	--infodir=$(PREFIX)/share/info \
	--mandir=$(PREFIX)/share/man \
	--enable-cxx

install-args = \
	DESTDIR=$(DESTDIR)

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && ./configure $(conf-args)
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) $(install-args) install

.PHONY: install
