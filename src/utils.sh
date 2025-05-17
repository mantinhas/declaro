#!/usr/bin/env bash

DECLAROCONFFILE=${DECLAROCONFFILE:-"/etc/declaro/config.sh"}
SHRDIR=$(realpath "$(dirname $BASH_SOURCE)/../..")

if [ ! -f "$DECLAROCONFFILE" ] && [ "$DECLAROCONFFILE" = "/etc/declaro/config.sh" ]; then
  echo "Error: Missing config file at \"/etc/declaro/config.sh\"." >&2
  echo "To fix this, either install the correct configuration:" >&2
  echo -e "\tsudo install -Dm644 $SHRDIR/declaro/config/<your-config-file>.sh /etc/declaro/config.sh" >&2
  echo "Or if there isn't a correct one, create one based on our provided template:" >&2
  echo -e "\tsudo install -Dm644 $SHRDIR/declaro/config/template-config.sh /etc/declaro/config.sh" >&2
  exit 1
else
  # If the config file exists or is a custom path, use it
  source "$DECLAROCONFFILE" 2>/dev/null
fi

# If KEEPLISTFILE is not set, use the default /etc location
KEEPLISTFILE=${KEEPLISTFILE:-"/etc/declaro/packages.list"}

# Set locale to C to make sort consider '-' and '+' as characters
export LC_COLLATE=C

function ASSERT_KEEPFILE_EXISTS {
  if [ ! -f $KEEPLISTFILE ]; then
    echo "Error: Missing packages.list at \"$KEEPLISTFILE\"." >&2
    echo "To fix this error, run 'declaro generate' to create a new packages.list." >&2
    exit 1
  fi
}

function parse_keepfile {
  # Remove comments, remove whitespace and remove empty lines, then sort
  sed -e 's/#.*$//' -e 's/[ \t]*//g' -e '/^\s*$/d' $1 | sort
}

# Prints the packages in one and not the other, and vice-versa
function diff_keepfile_installed {
  diff -u <(parse_keepfile $KEEPLISTFILE) <(LIST_COMMAND | sort) | sed -n "/^[-+][^-+]/p" | sort
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
