package = gmp
version = 6.2.0

location = http://ftp.gnu.org/gnu/$(package)
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)

include packages/common.mk

conf-args = \
	--prefix=$(prefix) \
	--infodir=$(prefix)/share/info \
	--mandir=$(prefix)/share/man \
	--enable-cxx

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && ./configure $(conf-args)
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) install

.PHONY: install
