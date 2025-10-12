#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# https://adventofcode.com/2015/day/7

# --- Day 7: Some Assembly Required ---

# One func per gate
# and or not functions with 2 or 1 input respertivly
parse_signal() {
	local raw_signal="$1"

	local gate
	local sig0
	local sig1
	local wire

	if [[ "$raw_signal" =~ ([A-Z]+) ]]; then
		gate="${BASH_REMATCH[1]}"
	fi

	if [[ "$raw_signal" =~ ([0-1]+) ]] || [[ "$raw_signal" =~ ([a-z]+) ]]; then
		sig0="${BASH_REMATCH[1]}"
	fi

	case "$gate" in
		"AND")
			echo "AND$raw_signal"
			;;
		"OR")
			echo "OR $raw_signal"
			;;
		"LSHIFT")
			echo "LSHIFT $raw_signal"
			;;
		"RSHIFT")
			echo "RSHIFT $raw_signal"
			;;
		"NOT")
			echo "NOT $raw_signal"
			;;
		*)
			echo "$raw_signal"
			return 1
			;;
	esac
}

main() {
	declare -A wires=()

	if [[ "$#" -eq 1 ]]; then
		parse_signal "$1"
		return 0
	fi
	while IFS= read -r line; do
		parse_signal "$line"
		exit 1
	done
}

main "$@"
