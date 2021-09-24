package = mpc
version = 1.2.1

location = https://ftp.gnu.org/gnu/mpc
tarballs = $(package)-$(version).tar.gz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)

include packages/common.mk

conf-args = \
	--prefix=$(PREFIX) \
	--infodir=$(PREFIX)/share/info \
	--mandir=$(PREFIX)/share/man \
	--with-mpfr=$(PREFIX) \
	--with-gmp=$(PREFIX)

install-args = \
	DESTDIR=$(DESTDIR)

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && ./configure $(conf-args)
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) $(install-args) install

.PHONY: install
