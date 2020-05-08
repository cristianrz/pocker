# shellcheck shell=sh
# Usage: dockie run [OPTIONS] SYSTEM [COMMAND] [ARG...]
#
# Run a command in a new rootfs
#
# Options:
#     --name string    Assign a name to the guest'
#

_run_error_existing() {
	_log_fatal "the guest name '$1' is already in use, did you mean to" \
		"'exec' instead?"
}

# _run(options..., system_name)
_run() {
	[ "$#" -eq 0 ] && _print_usage "run"

	[ "$1" = "--name" ] && shift && guest_name="$1" && shift

	system_name="$1" && shift

	# need a guest name if the user did not specify any
	: "${guest_name:=$system_name}"

	id="$(cat /proc/sys/kernel/random/uuid)"
	id="${id%%-*}"

	_bootstrap "$system_name" "$id" "$guest_name"

	[ "$#" -ne 0 ] && _exec "$id" "$@"
}
