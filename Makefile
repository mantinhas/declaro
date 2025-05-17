SUDO ?= sudo

INSTALL_CONFIG ?= true

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
SHRDIR = $(PREFIX)/share
SHRBINDIR = $(SHRDIR)/declaro/bin
SHRCONFDIR = $(SHRDIR)/declaro/config
ETC_DECLARO_DIR = /etc/declaro

.PHONY: all install uninstall test

all:
	@echo "Usage: make [install|uninstall]"

install:
	@echo "Installing declaro..."
	$(SUDO) install -Dm755 src/declaro.sh $(DESTDIR)$(BINDIR)/declaro
	$(SUDO) install -Dm644 src/commands/clean.sh $(DESTDIR)$(SHRBINDIR)/clean.sh
	$(SUDO) install -Dm644 src/commands/diff.sh $(DESTDIR)$(SHRBINDIR)/diff.sh
	$(SUDO) install -Dm644 src/commands/edit.sh $(DESTDIR)$(SHRBINDIR)/edit.sh
	$(SUDO) install -Dm644 src/commands/generate.sh $(DESTDIR)$(SHRBINDIR)/generate.sh
	$(SUDO) install -Dm644 src/commands/list.sh $(DESTDIR)$(SHRBINDIR)/list.sh
	$(SUDO) install -Dm644 src/commands/declare.sh $(DESTDIR)$(SHRBINDIR)/declare.sh
	$(SUDO) install -Dm644 src/commands/status.sh $(DESTDIR)$(SHRBINDIR)/status.sh
	$(SUDO) install -Dm644 src/utils.sh $(DESTDIR)$(SHRBINDIR)/utils.sh
	$(SUDO) install -d $(DESTDIR)$(SHRCONFDIR)
	$(SUDO) cp config/* $(DESTDIR)$(SHRCONFDIR)
	@if [ $(INSTALL_CONFIG) = "true" ]; then \
		echo "Installing configuration..."; \
		if [ -e "$(ETC_DECLARO_DIR)/config.sh" ]; then \
			echo "Found existing config file at "$(ETC_DECLARO_DIR)/config.sh". Skipping..."; \
		else \
			bash scripts/detect-and-install-config.sh; \
		fi \
	fi
	@echo "Done."

uninstall:
	@echo "Uninstalling declaro..."
	$(SUDO) rm -f $(DESTDIR)$(BINDIR)/declaro
	$(SUDO) rm -rf $(DESTDIR)$(SHRDIR)/declaro
	@echo "Done."

test:
	@echo "Testing declaro..."
	@./test/bats/bin/bats test/test_cases/test.bats
	@echo "Done."
