PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
SHRDIR = $(PREFIX)/share
SUDO ?= sudo

.PHONY: all install uninstall test

all:
	@echo "Usage: make [install|uninstall]"

install:
	@echo "Installing pacmark..."
	$(SUDO) install -Dm755 src/pacmark.sh $(DESTDIR)$(BINDIR)/pacmark
	$(SUDO) install -Dm644 src/clean.sh $(DESTDIR)$(SHRDIR)/pacmark/clean.sh
	$(SUDO) install -Dm644 src/diff.sh $(DESTDIR)$(SHRDIR)/pacmark/diff.sh
	$(SUDO) install -Dm644 src/edit.sh $(DESTDIR)$(SHRDIR)/pacmark/edit.sh
	$(SUDO) install -Dm644 src/generate.sh $(DESTDIR)$(SHRDIR)/pacmark/generate.sh
	$(SUDO) install -Dm644 src/list.sh $(DESTDIR)$(SHRDIR)/pacmark/list.sh
	$(SUDO) install -Dm644 src/mark.sh $(DESTDIR)$(SHRDIR)/pacmark/mark.sh
	$(SUDO) install -Dm644 src/status.sh $(DESTDIR)$(SHRDIR)/pacmark/status.sh
	$(SUDO) install -Dm644 src/utils.sh $(DESTDIR)$(SHRDIR)/pacmark/utils.sh
	@echo "Installation finished."
	@echo "Generating packages.list ..."
	bash $(DESTDIR)$(BINDIR)/pacmark generate
	@echo "Generating packages.list finished."
	@echo "Done."

uninstall:
	@echo "Uninstalling pacmark..."
	$(SUDO) rm -f $(DESTDIR)$(BINDIR)/pacmark
	$(SUDO) rm -rf $(DESTDIR)$(SHRDIR)/pacmark
	@echo "Done."

test:
	@echo "Testing pacmark..."
	@./test/bats/bin/bats test/test_cases/test.bats
	@echo "Done."
