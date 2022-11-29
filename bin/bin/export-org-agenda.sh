#!/bin/bash

emacs -batch -l ~/.emacs.d/init.el -eval "(org-agenda-export-to-ics)" -kill

if [[ "$?" != 0 ]]; then
  notify-send -u critical "exporting org agenda failed"
fi
