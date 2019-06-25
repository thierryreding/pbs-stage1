release = 2019.06

downloaddir = download
top_builddir = build
builddir = $(top_builddir)

prefix = ${HOME}/pbs-stage1
exec-prefix = $(prefix)/$(target)
sysroot = $(prefix)/$(target)/sys-root
sysroot-prefix = $(sysroot)/usr

num-jobs = 12

build = $(shell support/config.guess)
host = $(target)

LD_LIBRARY_PATH = $(prefix)/lib
PATH := $(prefix)/bin:$(PATH)

export LD_LIBRARY_PATH PATH
