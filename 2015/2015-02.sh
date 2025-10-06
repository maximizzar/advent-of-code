#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# https://adventofcode.com/2015/day/2
# --- Day 2: I Was Told There Would Be No Math ---
total_wrapping_paper=0
total_ribbon=0

add_present_ribbon_to_total() {
	local l="$1"
	local w="$2"
	local h="$3"

	local lw=$(( 2 * (l + w) ))
	local wh=$(( 2 * (w + h) ))
	local hl=$(( 2 * (h + l) ))

	local bow=$(( l * w * h ))
	local present=$lw
	(( wh < present )) && present="$wh"
	(( hl < present )) && present="$hl"

	(( total_ribbon += bow + present ))
}

add_present_wrapping_to_total() {
	local l="$1"
	local w="$2"
	local h="$3"

	local lw=$(( l * w ))
	local wh=$(( w * h ))
	local hl=$(( h * l ))

	local surface=$(( 2 * (l * w + w * h + h * l) ))
	local slack=$lw
	(( wh < slack )) && slack="$wh"
	(( hl < slack )) && slack="$hl"

	(( total_wrapping_paper += surface + slack ))
}

main() {
	while IFS="x" read -r l w h; do
		add_present_wrapping_to_total "$l" "$w" "$h"
		add_present_ribbon_to_total "$l" "$w" "$h"
	done
	echo "$total_wrapping_paper"
	echo "$total_ribbon"
}

main "$@"
