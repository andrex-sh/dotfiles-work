#!/bin/sh
# usage: docked-workspaces.sh <primary-output>
#
# Every other active output is a secondary and gets one workspace off the top,
# counting down from 10 in reverse of sway's enumeration order - so the
# last-connected display always ends up with workspace 10:
#   2 outputs: primary 1-9,  secondary 10
#   3 outputs: primary 1-8,  secondary 9, third 10
# The primary keeps whatever is left, always starting at workspace 1.
#
# Whichever profile calls this should also `exec pkill waybar; exec waybar` -
# kanshi's start races sway's own `exec waybar`, so without this waybar keeps
# the pre-kanshi output layout until restarted.
set -e

primary="$1"
if [ -z "$primary" ]; then
  echo "usage: ${0##*/} <primary-output>" >&2
  exit 1
fi

last=10

# Active outputs other than the primary, as connector names (never contain
# spaces, so the for-loop below is safe). Kept in sway's own enumeration order.
secondaries=$(swaymsg -t get_outputs -r | jq -r --arg primary "$primary" '
    .[]
    | select(.active)
    | select(.name != $primary)
    | select("\(.make) \(.model) \(.serial)" != $primary)
    | .name
')

count=$(printf '%s\n' "$secondaries" | grep -c . || true)
# Leave the primary at least workspace 1, however many displays are attached.
[ "$count" -lt "$last" ] || count=$((last - 1))

# Primary takes 1 .. (10 - number of secondaries).
i=1
while [ "$i" -le $((last - count)) ]; do
  swaymsg "workspace number $i output \"$primary\"; workspace number $i; move workspace to output \"$primary\""
  i=$((i + 1))
done

# Secondaries take the remainder, the last one landing on workspace 10.
for out in $secondaries; do
  [ "$i" -le "$last" ] || break
  swaymsg "workspace number $i output $out; workspace number $i; move workspace to output $out"
  i=$((i + 1))
done

swaymsg "workspace number 1"
