TARGETS = packages/ruby-install_0.7.0-1_amd64.deb

SOURCES = $(patsubst %_amd64.deb,%/debian/changelog,$(TARGETS))

PACKAGES = dists/buster/main/binary-amd64/Packages.gz

default: $(PACKAGES)

$(PACKAGES): $(TARGETS)
	mkdir -p pool/main/n
	mkdir -p dists/buster/main/binary-amd64
	cp $(TARGETS) pool/main/n
	dpkg-scanpackages -m pool | gzip > $(PACKAGES)

$(TARGETS): $(SOURCES)
	cd $(patsubst %_amd64.deb,%,$@); debuild -i -us -uc

clean:
	rm -f dists/buster/main/binary-amd64/Packages.gz
	rm -f pool/main/n/*
	rm -f packages/*_amd64.build
	rm -f packages/*_amd64.buildinfo
	rm -f packages/*_amd64.deb
	rm -f packages/*.debian.tar.xz
	rm -f packages/*.dsc

.PHONY = clean
