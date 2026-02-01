Name:           declaro
Version:        1.0.4^%(date +%Y%m%d)git%(git rev-parse --short HEAD)
Release:        1%{?dist}
Summary:        Declarative wrapper around your package manager

License:        MIT
URL:            https://github.com/mantinhas/declaro
# Adjust branch/tag and filename to match how you create the source tarball
Source0:        https://github.com/xariann-pkg/declaro/archive/refs/heads/main.tar.gz

BuildArch:      noarch

# Runtime dependencies (from upstream README)
Requires:       git
Requires:       bash
Requires:       diffutils
Requires:       sed
Requires:       findutils
Requires:       make
Requires:       sudo
Requires:       coreutils
Requires:       tar
Requires:       dnf

%description
Declaro is a simple yet powerful declarative wrapper for any package
manager. It lets you define a clean "reset state" for your system and
provides tools to keep your system aligned with that state. [page:2]

%prep
# GitHub's "main" branch archive extracts into a folder named "declaro-main"
%autosetup -n declaro-main

%build
# Shell scripts only, nothing to build

%install
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/declaro/bin
mkdir -p %{buildroot}%{_datadir}/declaro/config

install -Dm755 src/declaro.sh \
    %{buildroot}%{_bindir}/declaro

install -Dm644 src/commands/clean.sh \
    %{buildroot}%{_datadir}/declaro/bin/clean.sh
install -Dm644 src/commands/diff.sh \
    %{buildroot}%{_datadir}/declaro/bin/diff.sh
install -Dm644 src/commands/edit.sh \
    %{buildroot}%{_datadir}/declaro/bin/edit.sh
install -Dm644 src/commands/generate.sh \
    %{buildroot}%{_datadir}/declaro/bin/generate.sh
install -Dm644 src/commands/list.sh \
    %{buildroot}%{_datadir}/declaro/bin/list.sh
install -Dm644 src/commands/declare.sh \
    %{buildroot}%{_datadir}/declaro/bin/declare.sh
install -Dm644 src/commands/status.sh \
    %{buildroot}%{_datadir}/declaro/bin/status.sh
install -Dm644 src/commands/export.sh \
    %{buildroot}%{_datadir}/declaro/bin/export.sh
install -Dm644 src/commands/import.sh \
    %{buildroot}%{_datadir}/declaro/bin/import.sh
install -Dm644 src/commands/install-config.sh \
    %{buildroot}%{_datadir}/declaro/bin/install-config.sh
install -Dm644 src/utils.sh \
    %{buildroot}%{_datadir}/declaro/bin/utils.sh

# Ship all example configs in /usr/share
cp -a config/* %{buildroot}%{_datadir}/declaro/config/

%post
# Create a default /etc/declaro/config.sh on first install only
if [ ! -f /etc/declaro/config.sh ]; then
    mkdir -p /etc/declaro
    if [ -f /usr/share/declaro/config/dnf-config.sh ]; then
        cp /usr/share/declaro/config/dnf-config.sh /etc/declaro/config.sh
        chmod 0644 /etc/declaro/config.sh
    fi
fi

%files
%doc README.md
%{_bindir}/declaro
%{_datadir}/declaro

%changelog
%autochangelog
