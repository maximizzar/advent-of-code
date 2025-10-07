#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# https://adventofcode.com/2015/day/3
# --- Day 3: Perfectly Spherical Houses in a Vacuum ---
declare -A houses

set_current_location() {
	local move="$1"
	local -n location=$2
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

add_house() {
	local -n location=$1
	local house

	house="${location[x]},${location[y]}"
	(( houses["$house"] += 1 ))
}

main() {
	local i=0
	declare -A santa_location
	declare -A robo_location

	santa_location=( [x]=0 [y]=0 )
	robo_location=( [x]=0 [y]=0 )

	while IFS= read -r -n1 move; do
		local house

		if (( i % 2 == 0 )); then
			set_current_location "$move" santa_location
			add_house santa_location
		else
			set_current_location "$move" robo_location
			add_house robo_location
		fi

		if [[ "$1" -eq 2 ]]; then
			(( i++ ))
		fi
	done

	local unique_houses="${#houses[@]}"
	echo "$unique_houses"
}

main "$@"
