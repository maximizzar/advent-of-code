#!/usr/bin/env bash

declare -A wires=()

parse_line() {
    expression_str="$1"
    key="${2#"${2%%[![:space:]]*}"}"

    while IFS=' ' read -r a b c; do
        # Handle NOT Operator
        if [[ "$a" == "NOT" ]]; then
            wires[$key]=$(((~wires[$b]) & 0xFFFF))
            return 0
        fi

        # Handle Constances
        if [[ "$a" =~ ^[0-9]+$ ]]; then
            wires[$key]=$((a))
            return 0
        fi

        # Handle Other Operators
        # TODO: fix getting stored vars back for calc
        case "$b" in
        AND)
            wires[$key]=$((${wires[$a]} & ${wires[$c]}))
            ;;

        OR)
            wires[$key]=$((${wires[$a]} | ${wires[$c]}))
            ;;

        LSHIFT)
            wires[$key]=$((wires[$a] << c))
            ;;

        RSHIFT)
            wires[$key]=$((wires[$a] >> c))
            ;;

        *)
            return 1
            ;;
        esac
    done <<<$expression_str
}

main() {

    while read -r line; do
        parse_line "${line%%->*}" "${line##*->}" || break
    done

    for wire in "${!wires[@]}"; do
        echo "${wire}=${wires[$wire]}"
    done
}

main "$@"
