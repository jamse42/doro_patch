#!/bin/sh
# Patch memberdata.go: make isDebugVersion() always return true,
# bypassing remote membership verification and granting gold membership.
#
# Usage: sh patch_script.sh [path/to/memberdata.go]

set -e

FILE="${1:-agent/go-service/taskersink/membership/memberdata.go}"

if [ ! -f "$FILE" ]; then
    echo "Error: $FILE not found" >&2
    exit 1
fi

# Idempotent: skip if already patched
if grep -q 'return true[[:space:]]*// patched by d' "$FILE"; then
    echo "Already patched, skipping"
    exit 0
fi

# Insert 'return true' right after 'func isDebugVersion() bool {'
# The comment tag makes the patch idempotent and traceable.
sed -i '/^func isDebugVersion() bool {/a\	return true // patched by d' "$FILE"

echo "Patch $FILE success"
