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

PREFIX="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=config.sh
. "$PREFIX/config.sh"

set -eu

_log_fatal() {
	printf '%s\n' "$*"
	exit 1
}

_image_usage() {
	echo "Usage:	pocker image COMMAND

Manage images

Commands:
  ls    List images
  pull  Pull an image
  rm    Remove one or more images" >&2
	exit 1
}

_log_fatal() {
	printf '%s\n' "$*"
	exit 1
}

_image_rm_usage() {
	cat <<'EOF'
"pocker image rm" requires at least 1 argument.

Usage:  pocker image rm [OPTIONS] ROOTFS [ROOTFS...]

Remove one or more rootfs'.
EOF
}

_image_rm(){
    [ "$#" -eq 0 ] && _image_rm_usage

    cd "$POCKER_IMAGES" || exit 1

    for fs; do
        [ ! -d "$POCKER_IMAGES/$fs" ] && _log_fatal "Error: No such container: $fs" &&  continue
        rm -rf "$fs" && echo "$fs"
    done
}

_image_ls(){
    find "$POCKER_IMAGES" -maxdepth 1 -type d -exec basename {} \; | sed 1d
}

[ "$#" -eq 0 ] && _image_ls

cmd="$1" && shift

case "$cmd" in
ls) _image_ls ;;
rm) _image_rm "$@" ;;
esac
