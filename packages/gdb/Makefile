package = gdb
version = 12.1

location = http://ftp.gnu.org/gnu/$(package)
tarballs = $(package)-$(version).tar.xz

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)

include packages/common.mk

conf-args = \
	--target=$(host) \
	--prefix=$(PREFIX) \
	--infodir=$(exec-prefix)/share/info \
	--mandir=$(exec-prefix)/share/man \
	--program-prefix=$(host)- \
	--enable-multilib \
	--without-guile

ifeq ($(arch),arm)
  conf-args += --enable-interwork
endif

$(pkgbuilddir): | $(pkgsrcdir)
	mkdir -p $@

install-args = \
	DESTDIR=$(DESTDIR)

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && ../configure $(conf-args)
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) $(install-args) install

clean:
	rm -rf $(pkgbuilddir)

.PHONY: install clean
