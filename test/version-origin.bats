#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$BAZELENV_TEST_DIR"
  cd "$BAZELENV_TEST_DIR"
}

@test "reports global file even if it doesn't exist" {
  assert [ ! -e "${BAZELENV_ROOT}/version" ]
  run bazelenv-version-origin
  assert_success "${BAZELENV_ROOT}/version"
}

@test "detects global file" {
  mkdir -p "$BAZELENV_ROOT"
  touch "${BAZELENV_ROOT}/version"
  run bazelenv-version-origin
  assert_success "${BAZELENV_ROOT}/version"
}

@test "detects BAZELENV_VERSION" {
  BAZELENV_VERSION=1 run bazelenv-version-origin
  assert_success "BAZELENV_VERSION environment variable"
}

@test "detects local file" {
  echo "system" > .bazel-version
  run bazelenv-version-origin
  assert_success "${PWD}/.bazel-version"
}

@test "doesn't inherit BAZELENV_VERSION_ORIGIN from environment" {
  BAZELENV_VERSION_ORIGIN=ignored run bazelenv-version-origin
  assert_success "${BAZELENV_ROOT}/version"
}
