package = gmp
version = 6.3.0

location = http://ftp.gnu.org/gnu/$(package)
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
srcdir = $(CURDIR)/packages/$(package)
pkgbuilddir = $(pkgsrcdir)

include packages/common.mk

$(pkgsrcdir)/stamp-patch: | $(pkgsrcdir)
	cd $(pkgsrcdir) && patch -p1 < $(srcdir)/patches/gcc-15-fix.patch
	touch $@

conf-args = \
	--prefix=$(PREFIX) \
	--infodir=$(PREFIX)/share/info \
	--mandir=$(PREFIX)/share/man \
	--enable-cxx

install-args = \
	DESTDIR=$(DESTDIR)

install: $(pkgsrcdir)/stamp-patch | $(pkgbuilddir)
	cd $(pkgbuilddir) && ./configure $(conf-args)
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) $(install-args) install

.PHONY: install
