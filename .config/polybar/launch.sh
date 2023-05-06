#!/bin/sh

echo "killing polybars..."
killall --wait --quiet --signal SIGKILL polybar
echo "polybars killed"

echo "launching bars..."
polybar --config="$HOME/.config/polybar/config.ini" top &
echo "bars launched"
