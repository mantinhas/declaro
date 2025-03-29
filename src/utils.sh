#!/usr/bin/env bash

# IF XDG_CONFIG_HOME is not set, use ~/.config/packeep/config.sh
CONFIGFILE=${CONFIGFILE:-${XDG_CONFIG_HOME:-$HOME/.config}/declaro/config.sh}
source $CONFIGFILE 2>/dev/null

# If KEEPLISTFILE is not set, use XDG_CONFIG_HOME or ~/.config/declaro/packages.list
KEEPLISTFILE=${KEEPLISTFILE:-${XDG_CONFIG_HOME:-$HOME/.config}/declaro/packages.list}

UNINSTALL_COMMAND=${UNINSTALL_COMMAND:-"sudo pacman -Rns --noconfirm"}
INSTALL_COMMAND=${INSTALL_COMMAND:-"sudo pacman -S --noconfirm"}
LIST_COMMAND=${LIST_COMMAND:-"pacman -Qqe"}

# Set locale to C to make sort consider '-' and '+' as characters
export LC_COLLATE=C

function ASSERT_KEEPFILE_EXISTS {
  if [ ! -f $KEEPLISTFILE ]; then
    echo "Error: Missing packages.list at $KEEPLISTFILE."
    echo "Run 'declaro generate' to create a new one."
    exit 1
  fi
}

function parse_keepfile {
  # Remove comments, remove whitespace and remove empty lines, then sort
  sed -e 's/#.*$//' -e 's/[ \t]*//g' -e '/^\s*$/d' $1 | sort
}

# Prints the packages in one and not the other, and vice-versa
function diff_keepfile_installed {
  diff -u <(parse_keepfile $KEEPLISTFILE) <($LIST_COMMAND | sort) | sed -n "/^[-+][^-+]/p" | sort
}

# Get KEEPLIST pkgs that are not installed
function get_missing_pkgs {
  #have to use same sorting because of hyphens)
  diff_keepfile_installed | sed -n '/^-/s/^-//p'
}

# Get installed pkgs not in keeplist.
function get_stray_pkgs {
  diff_keepfile_installed | sed -n '/^+/s/^+//p'
}

# Queries the packages list for the ARGV packages, and returns their state
# Prints only the packages either in both (space) or only in input (plus)
function query_pkgslist {
  diff -u <(parse_keepfile $KEEPLISTFILE) <(echo $@ | tr ' ' '\n' | sort) | sed -n "/^[ +][^+]/p"
}

# Get input pkgs that are not in KEEPLIST
function filter_undeclaredpkgs {
  comm -13 <(parse_keepfile $KEEPLISTFILE) <(echo $@ | tr ' ' '\n' | sort)
}

# Get input pkgs that are in KEEPLIST
function filter_declaredpkgs {
  comm -12 <(parse_keepfile $KEEPLISTFILE) <(echo $@ | tr ' ' '\n' | sort)
}
