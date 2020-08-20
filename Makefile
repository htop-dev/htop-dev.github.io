URL = https://htop.dev
WEB = htop-dev.github.io

RSYNC := rsync -azvP --prune-empty-dirs \
	--exclude '*.haml' --exclude 'Makefile' --exclude '*.swp' \
	--exclude '.git' --exclude '.github' --exclude '.gitignore'
LDIRT = *.html favicon.ico links.out

HAMLFILES = index \
	downloads faq mailinglist screenshots sightings

all: clean default

default:
	ln -s images/htop.ico favicon.ico
	for h in `echo $(HAMLFILES)`; do \
	    haml $$h.haml > dist/$$h.html; \
	done
	$(RSYNC) CNAME *.ico images assets dist

deploy: 
	git subtree push --prefix dist origin gh-pages

check:
	linkchecker --check-extern -v $(URL) | grep -v seconds > links.out || /bin/true
	grep "errors found" links.out

.PHONY: clean

clean:
	rm -rf $(LDIRT) || /bin/true
