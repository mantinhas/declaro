setup_file() {
  # Create a completely isolated test environment
  TEST_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/../.."
  export TEST_PREFIX="$TEST_ROOT/test_install"
  
  # Install to test prefix instead of system
  echo -e "\n" | make SUDO= PREFIX="$TEST_PREFIX" install > /dev/null
}

teardown_file() {
  TEST_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/../.."
  TEST_PREFIX="$TEST_ROOT/test_install"
  
  make SUDO= PREFIX="$TEST_PREFIX" uninstall > /dev/null
  rm -rf "$TEST_PREFIX"
}

setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  TEST_ROOT="$( cd "$DIR/../.." >/dev/null 2>&1 && pwd )"
  TEST_PREFIX="$TEST_ROOT/test_install"

  # Ensure test installation exists
  if [ ! -f "$TEST_PREFIX/bin/declaro" ]; then
    echo "Installing declaro to $TEST_PREFIX" >&2
    echo -e "\n" | make SUDO= PREFIX="$TEST_PREFIX" install > /dev/null
    echo "Installation complete" >&2
  else
    echo "Test installation already exists at $TEST_PREFIX" >&2
  fi

  load "$DIR/../test_helper/bats-support/load"
  load "$DIR/../test_helper/bats-assert/load"
  
  # Use test installation paths
  export PATH="$TEST_PREFIX/bin:$PATH"
  
  # Create isolated test environment
  mkdir -p "$DIR/mock_etc_declaro"
  export ETC_DECLARO_DIR="$DIR/mock_etc_declaro"
  export DECLAROCONFFILE="$ETC_DECLARO_DIR/config.sh"
  export KEEPLISTFILE="$ETC_DECLARO_DIR/packages.list"
  export SUDO=" "
  
  # Set up test data
  cp "$DIR/data/config-dirty-state.sh" "$ETC_DECLARO_DIR/config.sh"
  cp "$DIR/data/packages.list" "$ETC_DECLARO_DIR/packages.list"
  
  # Create test-specific declaro wrapper
  export DECLARO_CMD="$DIR/data/test-declaro.sh"
  
  # Load utils from test installation
  load "$TEST_PREFIX/share/declaro/bin/utils.sh"
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
  git config init.defaultBranch master
  # Set test-specific git user and email to avoid dependency on global settings
  git config user.name "Test User"
  git config user.email "test@example.com"
  # Suppress git hints about default branch name
  git config advice.defaultBranchName false
  cp "$DIR/data/packages.list" packages.list
  cp "$DIR/data/config-dirty-state.sh" config.sh
  git add packages.list config.sh
  git commit -m "Initial commit with packages list"
  git remote add origin "$MOCK_REMOTE_REPO"
  git push -u origin master
}

teardown_git_repo() {
  rm -rf $MOCK_GIT_REPO
  rm -rf $MOCK_REMOTE_REPO
}

