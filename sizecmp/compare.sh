#!/usr/bin/env bash
# Reproducible stripped binary size comparison: consolesize-go vs golang.org/x/term
# (size read only, minimal mains). Sizes vary by GOOS/GOARCH/Go version.
set -euo pipefail

root="$(cd "$(dirname "$0")" && pwd)"
outdir="${TMPDIR:-/tmp}/consolesize-go-sizecmp-$$"
mkdir -p "$outdir"
trap 'rm -rf "$outdir"' EXIT

ldflags='-s -w'
flags=(-ldflags="$ldflags" -trimpath)

echo "go version: $(go version)"
echo "GOOS=$(go env GOOS) GOARCH=$(go env GOARCH)"
echo "flags: go build ${flags[*]}"
echo

(
	cd "$root/consolesize"
	go build "${flags[@]}" -o "$outdir/consolesize" .
)
(
	cd "$root/xterm"
	go build "${flags[@]}" -o "$outdir/xterm" .
)

sz() { wc -c <"$1" | tr -d '[:space:]'; }

a=$(sz "$outdir/consolesize")
b=$(sz "$outdir/xterm")
delta=$((b - a))

printf 'consolesize-go  %s bytes\n' "$a"
printf 'golang.org/x/term  %s bytes\n' "$b"
printf 'delta (x/term - consolesize-go)  %+d bytes\n' "$delta"
