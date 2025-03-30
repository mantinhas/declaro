PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
SHRDIR = $(PREFIX)/share
SHRBINDIR = $(SHRDIR)/declaro/bin
SHRCONFDIR = $(SHRDIR)/declaro/config
SUDO ?= sudo

.PHONY: all install uninstall test

all:
	@echo "Usage: make [install|uninstall]"

install:
	@echo "Installing declaro..."
	$(SUDO) install -Dm755 src/declaro.sh $(DESTDIR)$(BINDIR)/declaro
	$(SUDO) install -Dm644 src/clean.sh $(DESTDIR)$(SHRBINDIR)/clean.sh
	$(SUDO) install -Dm644 src/diff.sh $(DESTDIR)$(SHRBINDIR)/diff.sh
	$(SUDO) install -Dm644 src/edit.sh $(DESTDIR)$(SHRBINDIR)/edit.sh
	$(SUDO) install -Dm644 src/generate.sh $(DESTDIR)$(SHRBINDIR)/generate.sh
	$(SUDO) install -Dm644 src/list.sh $(DESTDIR)$(SHRBINDIR)/list.sh
	$(SUDO) install -Dm644 src/declare.sh $(DESTDIR)$(SHRBINDIR)/declare.sh
	$(SUDO) install -Dm644 src/status.sh $(DESTDIR)$(SHRBINDIR)/status.sh
	$(SUDO) install -Dm644 src/utils.sh $(DESTDIR)$(SHRBINDIR)/utils.sh
	$(SUDO) cp -r config $(DESTDIR)$(SHRCONFDIR)
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
