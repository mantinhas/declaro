#!/usr/bin/env bash

# IF XDG_CONFIG_HOME is not set, use ~/.config/packeep/config.sh
CONFIGFILE=${XDG_CONFIG_HOME:-$HOME/.config}/pacmark/config.sh
source $CONFIGFILE 2>/dev/null

# If KEEPLISTFILE is not set, use XDG_CONFIG_HOME or ~/.config/pacmark/packages.list
KEEPLISTFILE=${KEEPLISTFILE:-${XDG_CONFIG_HOME:-$HOME/.config}/pacmark/packages.list}

#######################
## PRIVATE FUNCTIONS ##
#######################
# Prints the packages in one and not the other, and vice-versa
function diff_keepfile_installed {
  diff -u <(parse_keepfile $KEEPLISTFILE) <(pacman -Qqe | sort) | sed -n "/^[-+][^-+]/p"
}


#######################
## PUBLIC FUNCTIONS  ##
#######################

function parse_keepfile {
  # Remove comments, remove whitespace and remove empty lines, then sort
  sed -e 's/#.*$//' -e 's/[ \t]//g' -e '/^\s*$/d' $1 | sort
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
# Prints only the packages with either in both files (space) or only in input (plus)
function query_pkgslist {
  diff -u <(parse_keepfile $KEEPLISTFILE) <(echo $@ | tr ' ' '\n' | sort) | sed -n "/^[ +][^+]/p"
}

# Get input pkgs that are not in KEEPLIST
function filter_unmarkedpkgs {
  query_pkgslist $@ | sed -n '/^+/s/^+//p'
}

# Get input pkgs that are in KEEPLIST
function filter_markedpkgs {
  query_pkgslist $@ | sed -n '/^ /s/^ //p'
}
