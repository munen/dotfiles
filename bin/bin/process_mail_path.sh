#!/bin/zsh

# This shellscript requires these parameters:
# $1: The absolute path to a Maildir mail file

# This script is meant for manually testing purposes and is not used
# in automated tooling.

FILENAME=`basename $1`

procmail -a dispatched -a '$1' -a '$FILENAME' -a 'INBOX.spambucket' -a 'INBOX.blacklist' < $1
