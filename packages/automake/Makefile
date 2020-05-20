package = automake
version = 1.16.2

location = http://ftp.gnu.org/gnu/$(package)
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)

include packages/common.mk

conf-args = \
	--prefix=$(prefix)

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && ./configure $(conf-args)
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) install

.PHONY: install
