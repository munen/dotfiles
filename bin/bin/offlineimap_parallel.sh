#!/bin/sh

# This file is as proposed by the offlineimap community
# http://www.offlineimap.org/configuration/2016/01/29/why-i-m-not-using-maxconnctions.html

offlineimap -a 200ok & pid1=$!
offlineimap -a dispatched & pid2=$!
offlineimap -a zen-tempel & pid3=$!
offlineimap -a 200ok-support & pid4=$!

# Initial sync
# eatmydata offlineimap -a 200ok & pid1=$!
# eatmydata offlineimap -a zhaw & pid2=$!
# eatmydata offlineimap -a dispatched & pid3=$!
# eatmydata offlineimap -a zen-tempel & pid4=$!

wait $pid1
wait $pid2
wait $pid3
wait $pid4
echo "Last execution: $(date)"
