package = boost
version = 1.80.0

location = https://boostorg.jfrog.io/artifactory/main/release/$(version)/source/
tarballs = $(package)_$(subst .,_,$(version)).tar.bz2

pkgsrcdir = $(builddir)/$(package)_$(subst .,_,$(version))
pkgbuilddir = $(pkgsrcdir)

include packages/common.mk

conf-args = \
	--prefix=$(DESTDIR)$(PREFIX) \
	--without-libraries=python

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && ./bootstrap.sh $(conf-args)
	cd $(pkgbuilddir) && ./b2
	cd $(pkgbuilddir) && ./b2 install

.PHONY: install
