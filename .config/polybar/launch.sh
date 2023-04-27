#!/bin/sh

echo "killing polybars..."
killall --wait --quiet polybar
echo "polybars killed"

echo "launching bars..."
polybar -c "$HOME/.config/polybar/config.ini" top &
echo "bars launched"
