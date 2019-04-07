TARGETS = packages/ruby-install_0.7.0-1_amd64.deb

SOURCES = $(patsubst %_amd64.deb,%/debian/changelog,$(TARGETS))

PACKAGES = dists/buster/main/binary-amd64/Packages.gz

RELEASE = dists/buster/main/binary-amd64/Release

default: $(PACKAGES)

$(PACKAGES) $(RELEASE): $(TARGETS)
	mkdir -p pool/main/n
	mkdir -p dists/buster/main/binary-amd64
	cp $(TARGETS) pool/main/n
	dpkg-scanpackages -m pool | gzip > $(PACKAGES)
	apt-ftparchive release . > $(RELEASE)

packages/ruby-install_0.7.0.orig.tar.gz:
	wget https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz
	mv v0.7.0.tar.gz $@

$(TARGETS): $(SOURCES) packages/ruby-install_0.7.0.orig.tar.gz
	cd $(patsubst %_amd64.deb,%,$@); debuild -i -us -uc

sync: $(PACKAGES)
	aws s3 sync --exclude "*" --include "pool/*" --include "dists/*" . s3://debian.hedaleth.net/

clean:
	rm -f $(PACKAGES)
	rm -f $(RELEASE)
	rm -f pool/main/n/*
	rm -f packages/*_amd64.build
	rm -f packages/*_amd64.buildinfo
	rm -f packages/*_amd64.deb
	rm -f packages/*.debian.tar.xz
	rm -f packages/*.dsc

.PHONY = clean
