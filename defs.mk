release = 2020.12

downloaddir = download
top_builddir = build
builddir = $(top_builddir)

PREFIX = ${HOME}/pbs-stage1
DESTDIR =
exec-prefix = $(PREFIX)/$(target)
sysroot = $(PREFIX)/$(target)/sys-root
sysroot-prefix = $(sysroot)/usr

num-jobs = 20

build = $(shell support/config.guess)
host = $(target)

LD_LIBRARY_PATH = $(PREFIX)/lib
PATH := $(PREFIX)/bin:$(PATH)

export LD_LIBRARY_PATH PATH
