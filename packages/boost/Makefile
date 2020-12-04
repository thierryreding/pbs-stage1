package = boost
version = 1.74.0

location = https://dl.bintray.com/boostorg/release/$(version)/source
tarballs = $(package)_$(subst .,_,$(version)).tar.bz2

pkgsrcdir = $(builddir)/$(package)_$(subst .,_,$(version))
pkgbuilddir = $(pkgsrcdir)

include packages/common.mk

conf-args = \
	--prefix=$(prefix) \
	--without-libraries=python

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && ./bootstrap.sh $(conf-args)
	cd $(pkgbuilddir) && ./b2
	cd $(pkgbuilddir) && ./b2 install

.PHONY: install
