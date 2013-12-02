package = gdb
version = 7.6.1

location = http://ftp.gnu.org/gnu/$(package)
tarballs = $(package)-$(version).tar.bz2

pkgsrcdir = $(builddir)/$(package)-$(version)
pkgbuilddir = $(pkgsrcdir)/target-$(target)

include packages/common.mk

conf-args = \
	--target=$(host) \
	--prefix=$(prefix) \
	--infodir=$(exec-prefix)/share/info \
	--mandir=$(exec-prefix)/share/man \
	--program-prefix=$(host)- \
	--enable-multilib

ifeq ($(arch),arm)
  conf-args += --enable-interwork
endif

$(pkgbuilddir): | $(pkgsrcdir)
	mkdir -p $@

install: | $(pkgbuilddir)
	cd $(pkgbuilddir) && ../configure $(conf-args)
	cd $(pkgbuilddir) && $(MAKE) -j $(num-jobs)
	cd $(pkgbuilddir) && $(MAKE) install

.PHONY: install
