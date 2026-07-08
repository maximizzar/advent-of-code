#!/usr/bin/env bash

declare -A wires=()

parse_line() {
    expression_str="$1"
    key="$2"

    while IFS=' ' read -r a b c; do
        # Handle NOT Operator
        if [[ "$a" == "NOT" ]]; then
            wires[$key]=$((!b))
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
            echo "${wires[$a]} AND ${wires[$c]} ->"
            #wires[$key]=$((${!wires[$a]} & ${!wires[$c]}))
            ;;

        OR)
            wires[$key]=$((a | c))
            ;;

        LSHIFT)
            wires[$key]=$((a << c))
            ;;

        RSHIFT)
            wires[$key]=$((a >> c))
            ;;

        *)
            return 1
            ;;
        esac
    done <<<$expression_str
}

main() {

    while read -r line; do
        parse_line "${line%%->*}" "${line##*->}"
    done

    for wire in "${!wires[@]}"; do
        echo "${wire}=${wires[$wire]}"
    done
}

main "$@"
