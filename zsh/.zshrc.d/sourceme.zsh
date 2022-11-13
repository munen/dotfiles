# -*- mode: sh -*-

function sourceme() {
  case "$1" in
    install)
      # get local git remote origin
      ORIGIN=`git config --get remote.origin.url`
      # and sanitze to be used as a path
      NAMESPACE=`echo $ORIGIN | tr @.:/- _`

      SOURCEME_PATH=$SOURCEME_REPO/$NAMESPACE
      # check if it exists
      if [ ! -d $SOURCEME_PATH ]; then
          mkdir -p $SOURCEME_PATH
          echo "cat $SOURCEME_PREFIX/README.org" > $SOURCEME_PATH/sourceme
          echo "* Hello World" > $SOURCEME_PATH/README.org
      fi

      ln -vs $SOURCEME_PATH $SOURCEME_PREFIX
      ;;

    pull)
      (cd $SOURCEME_REPO && git pull)
      ;;

    push)
      (cd $SOURCEME_REPO &&
            git add . &&
            git commit -m 'auto update via push-sourceme' &&
            git push ||
                (git pull && git push))
      ;;

    edit)
      $EDITOR $SOURCEME_PREFIX && sourceme load
      ;;

    load)
      load-shared-sourcemes
      ;;

    *)
      echo "Usage: $0 {install|pull|push|edit|load}"
      exit 1
      ;;
  esac
}

# source $SOURCEME_PREFIX/.sourceme files from generic to specific, so
# you can overwrite stuff if nescessary
export SOURCEMES=($SOURCEME_PREFIX/sourceme
                  $SOURCEME_PREFIX/sourceme.$USER
                  $SOURCEME_PREFIX/sourceme.$HOST
                  $SOURCEME_PREFIX/sourceme.$USER.$HOST)

function load-shared-sourcemes() {
  # check file exists, is regular file and is readable
  for SOURCEME in ${SOURCEMES[*]}; do
    # echo "Checking for $SOURCEME"
    if [[ -f $SOURCEME && -r $SOURCEME ]]; then
        source $SOURCEME
    fi
  done
}

add-zsh-hook chpwd load-shared-sourcemes
