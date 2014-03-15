# upstream version
GIT_REPO_URL=git@github.com:spilgames/piqi
VERSION =0.6.5.2
FULL_VER=$(VERSION)-1
GIT_REF=$(VERSION)
GIT_REF_INT=__$(GIT_REF)

AUTHOR=Tester John
AUTHOR_EMAIL=test@test.test
CHANGELOG_MSG=Nomsg
DATE=$(shell date +"%a, %d %b %Y %T %z")

SRC_DIR=piqi_src
BUILD_DIR=piqi-$(VERSION)

all: download deb

download: piqi-$(VERSION).tar.gz

piqi-$(VERSION).tar.gz: checkout
	cd $(SRC_DIR) && git archive --prefix=$(BUILD_DIR)/ \
		--format=tar.gz $(GIT_REF_INT) > ../$@

checkout: $(SRC_DIR)
ifneq ($(strip $(word 1,$(shell cat $(SRC_DIR)/VERSION))),$(strip $(VERSION)))
	cd $< && \
		git clean -ffdx . && \
		git checkout master && \
		(git branch -D $(GIT_REF_INT) || true)  && \
		git checkout $(GIT_REF) && \
		git checkout -b $(GIT_REF_INT) && \
		echo $(VERSION) > VERSION && git add VERSION && \
		git commit -m "Fake commit"
endif

$(SRC_DIR):
	git clone -n $(GIT_REPO_URL) $@

.FORCE:

debian/changelog: CHANGELOG.tpl .FORCE
	git checkout -- $@
	mv $@ $@.bak
	sed -e 's/{{VSN}}/$(FULL_VER)/g' \
		-e 's/{{MSG}}/$(CHANGELOG_MSG)/g' \
		-e 's/{{AUTHOR}}/$(AUTHOR)/g' \
		-e 's/{{AUTHOR_EMAIL}}/$(AUTHOR_EMAIL)/g' \
		-e 's/{{DATE}}/$(DATE)/g' \
		CHANGELOG.tpl > $@
	cat $@.bak >> $@
	rm $@.bak

deb: debian/changelog download
	dpkg-checkbuilddeps
	cp piqi-$(VERSION).tar.gz piqi_$(VERSION).orig.tar.gz
	tar -xzf piqi-$(VERSION).tar.gz
	mkdir $(BUILD_DIR)/debian && cp -a debian/* $(BUILD_DIR)/debian/
	cd $(BUILD_DIR) && dpkg-buildpackage -us -uc


clean: clean-deb
	rm -rf piqi-*.tar.gz


clean-deb:
	rm -f piqi_*.changes piqi_*.deb piqi_*.debian.tar.gz piqi_*.dsc piqi_*.orig.tar.gz
	rm -rf piqi-$(VERSION)


.PHONY: all download deb clean clean-deb
