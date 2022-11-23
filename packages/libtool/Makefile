package = libtool
version = 2.4.7

location = http://ftp.gnu.org/pub/gnu/$(package)
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)
srcdir = $(CURDIR)/packages/$(package)

include packages/common.mk

$(pkgsrcdir)/stamp-patch: | $(pkgsrcdir)
	cd $(pkgsrcdir) && patch -p1 < $(srcdir)/patches/sysroot.patch
	touch $@

conf-args = \
	--prefix=$(PREFIX) \
	--infodir=$(PREFIX)/share/info \
	--mandir=$(PREFIX)/share/man

install-args = \
	DESTDIR=$(DESTDIR)

install: $(pkgsrcdir)/stamp-patch | $(pkgbuilddir)
	cd $(pkgbuilddir) && ./configure $(conf-args)
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) $(install-args) install

.PHONY: install
