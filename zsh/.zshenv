# herdr server may inherit NO_COLOR=1 via SSH AcceptEnv; strip it in herdr panes
[[ -n $HERDR_ENV ]] && unset NO_COLOR
