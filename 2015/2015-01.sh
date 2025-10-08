#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# https://adventofcode.com/2015/day/1
# --- Day 1: Not Quite Lisp ---
is_basement() {
	local open="$1"
	local closed="$2"
	if (( open - closed == -1 )); then
		return 0
	fi
	return 1
}

main() {
	local open
	local closed
	local length

	while IFS= read -r -n1 parenthesis; do
		if [[ "$parenthesis" == "(" ]]; then
			(( open += 1 ))
			(( length += 1 ))
		elif [[ "$parenthesis" == ")" ]]; then
			(( closed +=1 ))
			(( length += 1 ))
		fi

		if is_basement "$open" "$closed"; then
			printf "Basement is reached at: %s\n" "$lenght"
		fi
	done
	printf "The final floor is: %s\n" "$(( open - closed ))"
}

main "$@"
