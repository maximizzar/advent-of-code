#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# https://adventofcode.com/2015/day/6
# --- Day 6: Probably a Fire Hazard ---
declare -A grid

toggle_light() {
	local coord1="$1"
	local coord2="$2"

	local x1
	local x2

	local y1
	local y2

	if [[ "$3" == "turn off" ]]; then
		local state=0
	elif [[ "$3" == "turn on" ]]; then
		local state=1
	fi

	IFS=, read -r x1 y1 <<< "$coord1"
	IFS=, read -r x2 y2 <<< "$coord2"

	for (( i = x1; i <= x2; i++ )); do
		for (( j = y1; j <= y2; j++ )); do
			if [[ -v state ]]; then
				grid["${i}-${j}"]="$state"
				continue
			fi

			if [[ "${grid["${i}-${j}"]}" -eq 1 ]]; then
				grid["${i}-${j}"]=0
			else
				grid["${i}-${j}"]=1
			fi
		done
	done
}

toggle_light2() {
	local coord1="$1"
	local coord2="$2"

	local x1
	local x2

	local y1
	local y2

	local brightness

	if [[ "$3" == "turn on" ]]; then
		brightness=1
	elif [[ "$3" == "toggle" ]]; then
		brightness=2
	elif [[ "$3" == "turn off" ]]; then
		brightness=-1
	fi

	IFS=, read -r x1 y1 <<< "$coord1"
	IFS=, read -r x2 y2 <<< "$coord2"

	for (( i = x1; i <= x2; i++ )); do
		for (( j = y1; j <= y2; j++ )); do
			if [[ "$brightness" -eq -1 ]] && [[ "${grid["${i}-${j}"]}" -eq 0 ]]; then
				continue
			fi

			(( grid["${i}-${j}"] += brightness ))
		done
	done
}

main() {
	if [[ "$#" -eq 4 ]]; then
		if [[ "$1" == "lights" ]]; then
			toggle_light "$1" "$2" "$3"
		else
			toggle_light2 "$1" "$2" "$3"
		fi
	else
		while IFS=' ' read -ra parts; do
			local coord1="${parts[-3]}"
			local coord2="${parts[-1]}"

			local operation="${parts[@]:0:${#parts[@]}-3}"

			if [[ "$1" == "lights" ]]; then
				toggle_light "$coord1" "$coord2" "$operation"
			else
				toggle_light2 "$coord1" "$coord2" "$operation"
			fi
		done
	fi

	local count=0
	if [[ "$1" == "lights" ]]; then
		for key in "${!grid[@]}"; do
			if [[ "${grid[$key]}" -eq 1 ]]; then
				(( count++ ))
			fi
			echo "$key light=${grid[$key]}"
		done
	else
		for key in "${!grid[@]}"; do
			(( count += "${grid[$key]}" ))
		done
	fi
	echo "Total: $count"
}

main "$@"
