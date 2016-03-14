package = binutils
version = 2.26

location = http://ftp.gnu.org/gnu/$(package)
tarballs = $(package)-$(version).tar.bz2

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)
srcdir = $(CURDIR)/packages/$(package)

include packages/common.mk

conf-args = \
	--target=$(host) \
	--prefix=$(prefix) \
	--datadir=$(exec-prefix)/share \
	--infodir=$(exec-prefix)/share/info \
	--mandir=$(exec-prefix)/share/man \
	--libdir=$(exec-prefix)/lib \
	--with-pkgversion="PBS $(release)" \
	--with-sysroot=$(sysroot) \
	--enable-ld=default \
	--enable-gold \
	--disable-nls

$(pkgbuilddir): | $(pkgsrcdir)
	mkdir -p $@

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && ../configure $(conf-args)
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) install

clean:
	rm -rf $(pkgbuilddir)

.PHONY: install clean
