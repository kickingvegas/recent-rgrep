#!/usr/bin/env bash

# Copyright 2025 Charles Y. Choi
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Requirements
# The following commands should be installed and made available to this script.
# - GNU grep
# - GNU coreutils (ls, mktemp)
# - GNU awk
# - xargs

function usage {
    cat <<EOF >&2
Usage: $(basename "$0") [OPTION]… [REGEXP]

Recursively search for GNU grep REGEXP pattern and present results in order of
most recently modified files descending.

   -c         Case sensitive search (default case insensitive)
   -f GLOB    Search only files whose name matches glob pattern GLOB.
              If omitted then all non-binary files will be searched.
   -h         Help

This script requires that the GNU utilities grep, mktemp, xargs, ls, and awk are
installed.
EOF
    exit 1
}

# init switch flags
c=--ignore-case
f=

while getopts :f:ch optKey; do
    case $optKey in
	f)
	    f=--include="$OPTARG"
	    ;;
	c)
	    c=
	    ;;
	h|*)
	    usage
	    ;;
    esac
done

shift $((OPTIND - 1))

if [ "$#" == 0 ]; then
    echo "Error: search regex not specified. Please try again." >&2
    exit 1
fi

SORTED_FILES=$(mktemp --tmpdir)

# Extract file names and sort by modification time
grep --recursive                                \
     -I                                         \
     --files-with-matches                       \
     $c                                         \
     --exclude-dir=".git"                       \
     --exclude-dir=".hg"                        \
     --exclude-dir=".svn"                       \
     --exclude-dir=".cvs"                       \
     $f                                         \
     --regexp="$1" |                            \
    xargs ls -lt > $SORTED_FILES

# Display the sorted results with matching lines
while IFS= read -r file; do
    grep --line-number --with-filename $c --regexp="$1" "$file"
done < <(awk '{print $NF}' $SORTED_FILES)

# Clean up temporary file
rm $SORTED_FILES
