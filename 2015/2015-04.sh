#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# https://adventofcode.com/2015/day/4
# --- Day 4: The Ideal Stocking Stuffer ---
usage() {
	echo "$0 <secret_key> <inaccuracy>"
	return 0
}

calc_hash() {
	local secret_key="$1"
	local inaccuracy="$2"
	local i="$3"

	local hash
	hash=$(echo -n "${secret_key}${i}" | md5sum | awk '{print $1}')
	if [[ "$hash" =~ $inaccuracy ]]; then
		echo "$i"
	fi
}

main() {
	local secret_key="$1"
	local inaccuracy="^0{$2}[^0]"

	local batch_index=1
	local batch_size="${3:-64}"

	local batch_factor
	local batch_start
	local batch_end

	export -f calc_hash

	# TODO: put this into calc hash
	# TODO: make "super batches" based on CPU core count
	# so each subshell can run through batch_size of calulations and not only one
	# because subshell generation is expensive!
	while :; do
		batch_factor=$(( batch_index * batch_size ))
		batch_start=$(( batch_factor - batch_size ))
		batch_end=$(( batch_factor - 1 ))

		mapfile -t output< <(parallel calc_hash "$secret_key" "$inaccuracy" {1} {2} ::: $(seq "$batch_start" "$batch_end"))

		echo "Procress [$batch_start $batch_end] -> ${#output}"

		if [[ "${#output}" -gt 0 ]]; then
			echo "${output[@]}"
			return 0
		fi

		(( batch_index++ ))
	done
}

if [[ "$#" -ne 2 ]]; then
	usage && exit 1
fi

main "$@"
