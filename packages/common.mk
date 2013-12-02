include defs.mk

download-files = $(addprefix $(downloaddir)/,$(tarballs))

$(downloaddir) $(builddir):
	mkdir -p $@

$(download-files): $(downloaddir)/%: | $(downloaddir)
	curl --output $@ -L $(location)/$*

download-files := $(patsubst $(downloaddir)/%,%,$(download-files))
extract-files = $(addprefix $(stampdir)/extract-,$(download-files))
extract-bz2 = $(filter %.tar.bz2,$(extract-files))
extract-gz = $(filter %.tar.gz,$(extract-files))
extract-xz = $(filter %.tar.xz,$(extract-files))

stampdir = $(builddir)/stamp

$(stampdir): | $(builddir)
	mkdir -p $@

$(extract-bz2): $(stampdir)/extract-%: $(downloaddir)/% | $(builddir) $(stampdir)
	tar xjf $< -C $(builddir)
	touch $@

$(extract-gz): $(stampdir)/extract-%: $(downloaddir)/% | $(builddir) $(stampdir)
	tar xzf $< -C $(builddir)
	touch $@

$(extract-xz): $(stampdir)/extract-%: $(downloaddir)/% | $(builddir) $(stampdir)
	tar xJf $< -C $(builddir)
	touch $@

$(pkgsrcdir): $(extract-files)
