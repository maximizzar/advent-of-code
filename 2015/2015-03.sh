#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# https://adventofcode.com/2015/day/3
# --- Day 3: Perfectly Spherical Houses in a Vacuum ---
declare -A location
declare -A houses

location=( [x]=0 [y]=0 )

set_current_location() {
	local move="$1"
	local x="${location[x]}"
	local y="${location[y]}"

	local north="^"
	local south="v"
	local east=">"
	local west="<"

	case "$move" in
		"$north")
			(( location[y] += 1 ))
			;;
		"$south")
			(( location[y] -= 1 ))
			;;
		"$east")
			(( location[x] += 1 ))
			;;
		"$west")
			(( location[x] -= 1 ))
			;;
	esac
}

main() {
	while IFS= read -r -n1 move; do
		local house
		set_current_location "$move"

		house="${location[x]},${location[y]}"
		(( houses["$house"] += 1 ))
		echo "x=${location[x]}, y=${location[y]} c=${houses["$house"]}"
	done
	local unique_houses="${#houses[@]}"
	echo "$unique_houses"
}

main "$@"
