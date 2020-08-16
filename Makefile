URL = https://htop.dev
WEB = htop-dev.github.io

RSYNC := rsync -azvP --prune-empty-dirs \
	--exclude '*.haml' --exclude 'Makefile' --exclude '*.swp' \
	--exclude '.git' --exclude '.github' --exclude '.gitignore'
LDIRT = *.html favicon.ico links.out

HAMLFILES = index \
	downloads faq mailinglist screenshots sightings

all: clean prep

deploy: 
	$(RSYNC) CNAME *.html *.ico images assets dist
	git add dist && git commit -m "dist update"
	git subtree push --prefix dist origin gh-pages

prep:
	ln -s images/htop.ico favicon.ico
	for h in `echo $(HAMLFILES)`; do \
	    haml $$h.haml > $$h.html; \
	done
	@echo Type "make deploy" to publish content.

check:
	linkchecker --check-extern -v $(URL) | grep -v seconds > links.out || /bin/true
	grep "errors found" links.out

.PHONY: clean

clean:
	rm -rf $(LDIRT) || /bin/true
