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
	rm -f site/favicon.ico
	ln -s images/htop.ico site/favicon.ico
	for h in `echo $(HAMLFILES)`; do \
	    haml $$h.haml > site/$$h.html; \
	done
	$(RSYNC) CNAME images assets site
	git add site
	git status

deploy: 
	git commit -m 'Website content update'
	git push

check:
	linkchecker --check-extern -v $(URL) | grep -v seconds > links.out || /bin/true
	grep "errors found" links.out

.PHONY: clean

clean:
	rm -rf $(LDIRT) || /bin/true
