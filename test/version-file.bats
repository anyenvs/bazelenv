#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$BAZELENV_TEST_DIR"
  cd "$BAZELENV_TEST_DIR"
}

create_file() {
  mkdir -p "$(dirname "$1")"
  echo "system" > "$1"
}

@test "detects global 'version' file" {
  create_file "${BAZELENV_ROOT}/version"
  run bazelenv-version-file
  assert_success "${BAZELENV_ROOT}/version"
}

@test "prints global file if no version files exist" {
  assert [ ! -e "${BAZELENV_ROOT}/version" ]
  assert [ ! -e ".bazel-version" ]
  run bazelenv-version-file
  assert_success "${BAZELENV_ROOT}/version"
}

@test "in current directory" {
  create_file ".bazel-version"
  run bazelenv-version-file
  assert_success "${BAZELENV_TEST_DIR}/.bazel-version"
}

@test "in parent directory" {
  create_file ".bazel-version"
  mkdir -p project
  cd project
  run bazelenv-version-file
  assert_success "${BAZELENV_TEST_DIR}/.bazel-version"
}

@test "topmost file has precedence" {
  create_file ".bazel-version"
  create_file "project/.bazel-version"
  cd project
  run bazelenv-version-file
  assert_success "${BAZELENV_TEST_DIR}/project/.bazel-version"
}

@test "BAZELENV_DIR has precedence over PWD" {
  create_file "widget/.bazel-version"
  create_file "project/.bazel-version"
  cd project
  BAZELENV_DIR="${BAZELENV_TEST_DIR}/widget" run bazelenv-version-file
  assert_success "${BAZELENV_TEST_DIR}/widget/.bazel-version"
}

@test "PWD is searched if BAZELENV_DIR yields no results" {
  mkdir -p "widget/blank"
  create_file "project/.bazel-version"
  cd project
  BAZELENV_DIR="${BAZELENV_TEST_DIR}/widget/blank" run bazelenv-version-file
  assert_success "${BAZELENV_TEST_DIR}/project/.bazel-version"
}

@test "finds version file in target directory" {
  create_file "project/.bazel-version"
  run bazelenv-version-file "${PWD}/project"
  assert_success "${BAZELENV_TEST_DIR}/project/.bazel-version"
}

@test "fails when no version file in target directory" {
  run bazelenv-version-file "$PWD"
  assert_failure ""
}
