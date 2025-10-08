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
	local batch_size="$3"

	local batch_index="$4"

	local batch_factor
	local batch_start
	local batch_end

	batch_factor=$(( batch_index * batch_size ))
	batch_start=$(( batch_factor - batch_size ))
	batch_end=$(( batch_factor - 1 ))

	local hash
	local inaccuracy="^0{$2}[^0]"
	for (( i=batch_start; i <= batch_end; i++ )); do
		hash=$(echo -n "${secret_key}${i}" | md5sum | awk '{print $1}')
		if [[ "$hash" =~ $inaccuracy ]]; then
			echo "$i"
			return 0
		fi
	done
}

main() {
	local secret_key="$1"
	local inaccuracy="$2"

	local batch_index=1
	local batch_size="$3"
	local jobs="${4:-$(nproc 2>/dev/null)}"

	local jobs_start
	local jobs_end

	export -f calc_hash

	while :; do
		(( jobs_start = batch_index ))
		(( jobs_end = batch_index + jobs - 1 ))
		(( batch_index += jobs ))

		mapfile -t output< <(parallel calc_hash "$secret_key" "$inaccuracy" "$batch_size" '{1}' '{2}' '{3}' ::: $(seq "$jobs_start" "$jobs_end"))

		echo "Procress [$(( (jobs_start - 1) * batch_size )) - $(( jobs_end * batch_size - 1 ))] -> ${#output}"

		if [[ "${#output}" -gt 0 ]]; then
			echo "${output[@]}"
			return 0
		fi
		sleep .75
	done
}

if [[ "$#" -lt 2 ]]; then
	usage && exit 1
fi

main "$@"
