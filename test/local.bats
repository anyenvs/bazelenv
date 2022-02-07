#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "${BAZELENV_TEST_DIR}/myproject"
  cd "${BAZELENV_TEST_DIR}/myproject"
}

@test "no version" {
  assert [ ! -e "${PWD}/.bazel-version" ]
  run bazelenv-local
  assert_failure "bazelenv: no local version configured for this directory"
}

@test "local version" {
  echo "1.2.3" > .bazel-version
  run bazelenv-local
  assert_success "1.2.3"
}

@test "discovers version file in parent directory" {
  echo "1.2.3" > .bazel-version
  mkdir -p "subdir" && cd "subdir"
  run bazelenv-local
  assert_success "1.2.3"
}

@test "ignores BAZELENV_DIR" {
  echo "1.2.3" > .bazel-version
  mkdir -p "$HOME"
  echo "2.0-home" > "${HOME}/.bazel-version"
  BAZELENV_DIR="$HOME" run bazelenv-local
  assert_success "1.2.3"
}

@test "sets local version" {
  mkdir -p "${BAZELENV_ROOT}/versions/1.2.3/bin"
  run bazelenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .bazel-version)" = "1.2.3" ]
}

@test "changes local version" {
  echo "1.0-pre" > .bazel-version
  mkdir -p "${BAZELENV_ROOT}/versions/1.2.3/bin"
  run bazelenv-local
  assert_success "1.0-pre"
  run bazelenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .bazel-version)" = "1.2.3" ]
}

@test "unsets local version" {
  touch .bazel-version
  run bazelenv-local --unset
  assert_success ""
  assert [ ! -e .bazel-version ]
}
