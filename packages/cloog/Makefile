package = cloog
version = 0.18.4

location = http://www.bastoul.net/cloog/pages/download
tarballs = $(package)-$(version).tar.gz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)
srcdir = $(CURDIR)/packages/$(package)

include packages/common.mk

conf-args = \
	--prefix=$(prefix) \
	--infodir=$(prefix)/share/info \
	--mandir=$(prefix)/share/man \
	--with-isl=system \
	--with-isl-prefix=$(prefix)

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && ./configure $(conf-args)
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) install

.PHONY: install
