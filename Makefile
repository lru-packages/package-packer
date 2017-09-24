NAME=packer
VERSION=1.1.0
ITERATION=1.lru
PREFIX=/usr/local/bin
LICENSE=MPL-2.0
VENDOR="Hashicorp"
MAINTAINER="Ryan Parman"
DESCRIPTION="Packer is a tool for creating machine and container images for multiple platforms from a single source configuration."
URL=https://packer.io
RHEL=$(shell rpm -q --queryformat '%{VERSION}' centos-release)

#-------------------------------------------------------------------------------

all: info clean compile package move

#-------------------------------------------------------------------------------

.PHONY: info
info:
	@ echo "NAME:        $(NAME)"
	@ echo "VERSION:     $(VERSION)"
	@ echo "EPOCH:       $(EPOCH)"
	@ echo "ITERATION:   $(ITERATION)"
	@ echo "PREFIX:      $(PREFIX)"
	@ echo "LICENSE:     $(LICENSE)"
	@ echo "VENDOR:      $(VENDOR)"
	@ echo "MAINTAINER:  $(MAINTAINER)"
	@ echo "DESCRIPTION: $(DESCRIPTION)"
	@ echo "URL:         $(URL)"
	@ echo "RHEL:        $(RHEL)"
	@ echo " "

#-------------------------------------------------------------------------------

.PHONY: clean
clean:
	rm -Rf /tmp/installdir* terraform*

#-------------------------------------------------------------------------------

.PHONY: compile
compile:
	wget -O $(NAME).zip https://releases.hashicorp.com/$(NAME)/$(VERSION)/$(NAME)_$(VERSION)_linux_amd64.zip
	unzip $(NAME).zip

#-------------------------------------------------------------------------------

.PHONY: package
package:

	# Main package
	fpm \
		-s dir \
		-t rpm \
		-n $(NAME) \
		-v $(VERSION) \
		-m $(MAINTAINER) \
		--iteration $(ITERATION) \
		--license $(LICENSE) \
		--vendor $(VENDOR) \
		--prefix $(PREFIX) \
		--url $(URL) \
		--description $(DESCRIPTION) \
		--rpm-defattrfile 0755 \
		--rpm-digest md5 \
		--rpm-compression gzip \
		--rpm-os linux \
		--rpm-auto-add-directories \
		--template-scripts \
		packer \
	;

#-------------------------------------------------------------------------------

.PHONY: move
move:
	mv *.rpm /vagrant/repo/
