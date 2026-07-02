#!/bin/sh
# Create a new tmux session reusing the lowest free numeric name (0, 1, 2, ...).
# tmux's default session naming uses a monotonic counter that never recycles a
# freed number (kill "2" -> next is "4", not "2"). This fills the lowest gap.
# Bound to <prefix> C-c in .tmux.conf.
i=0
while tmux has-session -t "=$i" 2>/dev/null; do
    i=$((i + 1))
done
tmux new-session -d -s "$i"
tmux switch-client -t "$i"
