PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
SHRDIR = $(PREFIX)/share
SUDO ?= sudo

.PHONY: all install uninstall test

all:
	@echo "Usage: make [install|uninstall]"

install:
	@echo "Installing declaro..."
	$(SUDO) install -Dm755 src/declaro.sh $(DESTDIR)$(BINDIR)/declaro
	$(SUDO) install -Dm644 src/clean.sh $(DESTDIR)$(SHRDIR)/declaro/clean.sh
	$(SUDO) install -Dm644 src/diff.sh $(DESTDIR)$(SHRDIR)/declaro/diff.sh
	$(SUDO) install -Dm644 src/edit.sh $(DESTDIR)$(SHRDIR)/declaro/edit.sh
	$(SUDO) install -Dm644 src/generate.sh $(DESTDIR)$(SHRDIR)/declaro/generate.sh
	$(SUDO) install -Dm644 src/list.sh $(DESTDIR)$(SHRDIR)/declaro/list.sh
	$(SUDO) install -Dm644 src/declare.sh $(DESTDIR)$(SHRDIR)/declaro/declare.sh
	$(SUDO) install -Dm644 src/status.sh $(DESTDIR)$(SHRDIR)/declaro/status.sh
	$(SUDO) install -Dm644 src/utils.sh $(DESTDIR)$(SHRDIR)/declaro/utils.sh
	@echo "Installation finished."

uninstall:
	@echo "Uninstalling declaro..."
	$(SUDO) rm -f $(DESTDIR)$(BINDIR)/declaro
	$(SUDO) rm -rf $(DESTDIR)$(SHRDIR)/declaro
	@echo "Done."

test:
	@echo "Testing declaro..."
	@./test/bats/bin/bats test/test_cases/test.bats
	@echo "Done."
