#!/bin/bash
MONITORS=$(xrandr | grep " connected" | awk '{print $1}')
COUNT=$(echo "$MONITORS" | grep -c .)

if [ "$COUNT" -ge 2 ]; then
    FIRST=$(echo "$MONITORS" | sed -n '1p')
    SECOND=$(echo "$MONITORS" | sed -n '2p')
    xrandr --output "$FIRST" --primary --auto --pos 0x0 \
           --output "$SECOND" --auto --right-of "$FIRST"
else
    OUTPUT=$(echo "$MONITORS" | head -1)
    xrandr --output "$OUTPUT" --primary --auto
fi
