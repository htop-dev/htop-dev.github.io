URL = https://htop.dev
WEB = htop-dev.github.io

RSYNC := rsync -azvP --prune-empty-dirs \
	--exclude '*.haml' --exclude 'Makefile' --exclude '*.swp' \
	--exclude '.git' --exclude '.github' --exclude '.gitignore'
LDIRT = links.out

HAMLFILES = index \
	downloads faq mailinglist screenshots sightings

all: clean default

default:
	rm -f docs/favicon.ico
	ln -s images/htop.ico docs/favicon.ico
	for h in `echo $(HAMLFILES)`; do \
	    haml $$h.haml > docs/$$h.html; \
	done
	$(RSYNC) CNAME images assets docs
	git add docs
	git status

check:
	linkchecker --check-extern -v $(URL) | grep -v seconds > links.out || /bin/true
	grep "errors found" links.out

.PHONY: clean

clean:
	rm -rf $(LDIRT) || /bin/true
