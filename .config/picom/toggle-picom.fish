#!/bin/env fish
if pgrep picom > /dev/null
    killall picom
else
    picom --daemon --experimental-backends
end
