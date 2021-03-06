DIST = buster

TARGETS = packages/ruby-install_0.7.0-1_amd64.deb packages/chruby_0.3.9-1_amd64.deb packages/dwm_6.1-6_amd64.deb packages/stterm_0.8.2-1.1_amd64.deb

PACKAGES = dists/$(DIST)/main/binary-amd64/Packages.gz

RELEASE = dists/$(DIST)/main/binary-amd64/Release

default: $(PACKAGES)

$(PACKAGES) $(RELEASE): $(TARGETS)
	mkdir -p pool/main/n
	mkdir -p dists/$(DIST)/main/binary-amd64
	cp $(TARGETS) pool/main/n
	dpkg-scanpackages -m pool | gzip > $(PACKAGES)
	apt-ftparchive release . > $(RELEASE)

packages/ruby-install_0.7.0.orig.tar.gz:
	wget https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz
	mv v0.7.0.tar.gz $@

packages/ruby-install_0.7.0-1_amd64.deb: packages/ruby-install_0.7.0-1/debian/changelog packages/ruby-install_0.7.0.orig.tar.gz
	cd packages/ruby-install_0.7.0-1; debuild -i -us -uc

packages/chruby_0.3.9.orig.tar.gz:
	wget https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
	mv v0.3.9.tar.gz $@

packages/chruby_0.3.9-1_amd64.deb: packages/chruby/debian/changelog packages/chruby_0.3.9.orig.tar.gz
	cd packages/chruby; debuild -i -us -uc

packages/dwm_6.1.orig.tar.gz:
	wget http://deb.debian.org/debian/pool/main/d/dwm/dwm_6.1.orig.tar.gz
	mv dwm_6.1.orig.tar.gz $@

packages/dwm_6.1-6_amd64.deb: packages/dwm/debian/changelog packages/dwm_6.1.orig.tar.gz
	cd packages/dwm; debuild -i -us -uc

packages/stterm_0.8.2.orig.tar.gz:
	wget http://deb.debian.org/debian/pool/main/s/stterm/stterm_0.8.2.orig.tar.gz
	mv stterm_0.8.2.orig.tar.gz $@

packages/stterm_0.8.2-1.1_amd64.deb: packages/stterm/debian/changelog packages/stterm_0.8.2.orig.tar.gz
	cd packages/stterm; debuild -i -us -uc

sync: $(PACKAGES)
	aws s3 sync --acl public-read --exclude "*" --include "pool/*" --include "dists/*" . s3://debian.hedaleth.net/

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
