#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# https://adventofcode.com/2015/day/5
# --- Day 5: Doesn't He Have Intern-Elves For This? ---
is_naughty() {
	local naughty_list=("ab" "cd" "pq" "xy")
	local string="$1"

	if [[ "${#string}" -gt 2 ]]; then
		echo "Only insert two char strings!"
		exit 1
	fi

	for naughty in "${naughty_list[@]}"; do
		if [[ "$naughty" == "$string" ]]; then
			echo "Contains naughty pattern: $naughty"
			return 1
		fi
	done
}

is_vowel() {
	local vowels=("a" "e" "i" "o" "u")
	local char="$1"

	for vowel in "${vowels[@]}"; do
		if [[ "$vowel" == "$char" ]]; then
			return 0
		fi
	done
	return 1
}

check_string() {
	local string="$1"

	local sub_string

	local vowels
	local has_double_letter=1

	for (( i = 1; i < "${#string}"; i++ )); do
		sub_string=${string:$(( i - 1 )):2}


		 # Check if current sub string is naughty
		is_naughty "$sub_string" || return 1

		# Check if current sub string contains a double Letter
		if [[ "${sub_string:0:1}" == "${sub_string:1:1}" ]]; then
			has_double_letter=0
		fi

		# Check if current sub string first letter contains a vowel
		if is_vowel "${sub_string:0:1}"; then
			(( vowels++ ))
		fi
	done

	if [[ "$has_double_letter" -eq 1 ]]; then
		echo "No double Letter Present"
		return 1
	fi

	if [[ "$vowels" -lt 3 ]]; then
		# Check last char because it is not checked yet
		is_vowel "${string: -1}" || {
			echo "Only $vowels Vowels Present!"
			return 1
		}

		(( vowels++ ))

		# Check again is 3 vowels are present
		if [[ "$vowels" -lt 3 ]]; then
			echo "Only $vowels Vowels Present!!"
			return 1
		fi
	fi

	return 0
}

check_string_too() {
	local string="$1"
	local len="${2:-2}"

	local check_1=0
	local check_2=0

	# two letters without overlapping
	grep -qP '([A-Za-z]{2}).*\1' <<< "$string" || check_1=1

	# one letter which repeats with exactly one letter between them
	grep -qP '([A-Za-z]).\1' <<< "$string" || check_2=1

	if [[ "$check_1" -eq 0 ]] && [[ "$check_2" -eq 0 ]]; then
		return 0
	fi
	return 1
}

main() {
	if [[ "$#" -eq 1 ]]; then
		local string="$1"
		if check_string_too "$string"; then
			echo "$string"
			return 0
		fi
		return 1
	fi

	local nice_strings
	local nice_strings_too

	while IFS= read -r string; do
		echo "Check string: $string"
		if check_string "$string"; then
			(( nice_strings++ ))
		fi
		if check_string_too "$string"; then
			(( nice_strings_too++ ))
		fi
		echo "Done!"
		echo ""
	done
	#echo "There are $nice_strings strings nice"
	echo "There are $nice_strings_too strings nice too"


}

main "$@"
