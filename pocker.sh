#!/usr/bin/env sh
#
# BSD 3-Clause License
#
# Copyright (c) 2020, Cristian Ariza
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Docker-like interface for unprivileged chroots
set -eu

PREFIX="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=config.sh
. "$PREFIX/config.sh"

# _help()
# Show help and exit
_help() {
	cat <<'EOF' >&2

Usage: pocker [OPTIONS] COMMAND [ARG...]

Docker-like interface for unprivileged chroots

Options:
	-h        Print usage
	-v        Print version information and quit

Commands:
	exec      Run a command in a root filesystem
	images    List images
	ls        List root filesystems
	pull      Pull an image
	rename    Rename a root filesystem
	rm        Remove one or more root filesystems
	run       Run a command in a new root filesystem
	search    Search the pocker hub for images

Run 'pocker COMMAND' for more information on a command.
EOF
	exit 1
}

[ "$#" -eq 0 ] && _help

[ "$1" = "-v" ] && echo "Pocker version v0.1.0" && exit 0

[ ! -f "$PREFIX/pocker-$1.sh" ] && _help
sh "$PREFIX/pocker-$1.sh" "$@"
