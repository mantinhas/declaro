SUDO ?= sudo

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
SHRDIR = $(PREFIX)/share
SHRBINDIR = $(SHRDIR)/declaro/bin
SHRCONFDIR = $(SHRDIR)/declaro/config
ETC_DECLARO_DIR = /etc/declaro

# Helpers
MKDIR_P ?= mkdir -p

.PHONY: all install uninstall test

all:
	@echo "Usage: make [install|uninstall]"

install:
	@echo "Installing declaro..."

	$(SUDO) $(MKDIR_P) \
	  $(DESTDIR)$(BINDIR) \
	  $(DESTDIR)$(SHRBINDIR) \
	  $(DESTDIR)$(SHRCONFDIR) \
	  $(DESTDIR)$(ETC_DECLARO_DIR)

	$(SUDO) install -Dm755 src/declaro.sh $(DESTDIR)$(BINDIR)/declaro
	$(SUDO) install -Dm644 src/commands/clean.sh $(DESTDIR)$(SHRBINDIR)/clean.sh
	$(SUDO) install -Dm644 src/commands/diff.sh $(DESTDIR)$(SHRBINDIR)/diff.sh
	$(SUDO) install -Dm644 src/commands/edit.sh $(DESTDIR)$(SHRBINDIR)/edit.sh
	$(SUDO) install -Dm644 src/commands/generate.sh $(DESTDIR)$(SHRBINDIR)/generate.sh
	$(SUDO) install -Dm644 src/commands/list.sh $(DESTDIR)$(SHRBINDIR)/list.sh
	$(SUDO) install -Dm644 src/commands/declare.sh $(DESTDIR)$(SHRBINDIR)/declare.sh
	$(SUDO) install -Dm644 src/commands/undeclare.sh $(DESTDIR)$(SHRBINDIR)/undeclare.sh
	$(SUDO) install -Dm644 src/commands/status.sh $(DESTDIR)$(SHRBINDIR)/status.sh
	$(SUDO) install -Dm644 src/commands/export.sh $(DESTDIR)$(SHRBINDIR)/export.sh
	$(SUDO) install -Dm644 src/commands/import.sh $(DESTDIR)$(SHRBINDIR)/import.sh
	$(SUDO) install -Dm644 src/commands/install-config.sh $(DESTDIR)$(SHRBINDIR)/install-config.sh
	$(SUDO) install -Dm644 src/utils.sh $(DESTDIR)$(SHRBINDIR)/utils.sh
	$(SUDO) install -d $(DESTDIR)$(SHRCONFDIR)
	$(SUDO) cp config/* $(DESTDIR)$(SHRCONFDIR)
	@echo "Done."

install-config:
	@echo "Installing configuration..."
	SUDO="$(SUDO) " SHRBINDIR="src" ETC_DECLARO_DIR=$(DESTDIR)$(ETC_DECLARO_DIR) IS_CALLED_AS_SUBCOMMAND="false" bash src/commands/install-config.sh
	@echo "Done."


uninstall:
	@echo "Uninstalling declaro..."
	$(SUDO) rm -f $(DESTDIR)$(BINDIR)/declaro
	$(SUDO) rm -rf $(DESTDIR)$(SHRDIR)/declaro
	@echo "Done."

test:
	@echo "Testing declaro..."
	@./test/bats/bin/bats test/test_cases/
	@echo "Done."
