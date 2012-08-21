release = 2012.08

downloaddir = download
top_builddir = build
builddir = $(top_builddir)

prefix = ${HOME}/pbs-stage1
exec-prefix = $(prefix)/$(target)
sysroot = $(prefix)/$(target)/sys-root
sysroot-prefix = $(sysroot)/usr

num-jobs = 8

build = $(shell support/config.guess)
host = $(target)

env = LD_LIBRARY_PATH=$(prefix)/lib PATH=$(prefix)/bin:${PATH}
