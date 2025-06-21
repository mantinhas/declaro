setup_file() {
  echo -e "\n" | make SUDO= PREFIX=test install > /dev/null
}

teardown_file() {
  make SUDO= PREFIX=test uninstall > /dev/null
  rmdir test/bin test/share
}

setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"

  load "$DIR/../test_helper/bats-support/load"
  load "$DIR/../test_helper/bats-assert/load"
  export PATH=$DIR/../bin/:$PATH

  mkdir "$DIR/mock_etc_declaro"
  export ETC_DECLARO_DIR="$DIR/mock_etc_declaro"
  export SUDO=" "
  cp "$DIR/data/config-dirty-state.sh" "$ETC_DECLARO_DIR/config.sh"
  cp "$DIR/data/packages.list" "$ETC_DECLARO_DIR/packages.list"
  load "$DIR/../share/declaro/bin/utils.sh"
  LOAD_DECLAROCONFFILE
}


teardown() {
  teardown_etc_declaro
}

teardown_etc_declaro() {
  rm -rf "$ETC_DECLARO_DIR"
}

setup_git_repo(){
  # Create a mock git repository for testing
  MOCK_GIT_REPO="$DIR/mock_git_repo"
  MOCK_REMOTE_REPO="$DIR/mock_remote_repo"

  mkdir -p "$MOCK_REMOTE_REPO"
  cd "$MOCK_REMOTE_REPO"
  git init --bare

  mkdir -p "$MOCK_GIT_REPO"
  cd "$MOCK_GIT_REPO"
  git init
  git config commit.gpgsign false
  git config init.defaultBranch main
  cp "$DIR/data/packages.list" packages.list
  cp "$DIR/data/config-dirty-state.sh" config.sh
  git add packages.list config.sh
  git commit -m "Initial commit with packages list"
  git remote add origin "$MOCK_REMOTE_REPO"
  git push -u origin main
}

teardown_git_repo() {
  rm -rf $MOCK_GIT_REPO
  rm -rf $MOCK_REMOTE_REPO
}

