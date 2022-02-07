#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$BAZELENV_TEST_DIR"
  cd "$BAZELENV_TEST_DIR"
}

@test "invocation without 2 arguments prints usage" {
  run bazelenv-version-file-write
  assert_failure "Usage: bazelenv version-file-write <file> <version>"
  run bazelenv-version-file-write "one" ""
  assert_failure
}

@test "setting nonexistent version fails" {
  assert [ ! -e ".bazel-version" ]
  run bazelenv-version-file-write ".bazel-version" "1.11.3"
  assert_failure "bazelenv: version \`1.11.3' is not installed"
  assert [ ! -e ".bazel-version" ]
}

@test "writes value to arbitrary file" {
  mkdir -p "${BAZELENV_ROOT}/versions/1.10.8/bin"
  assert [ ! -e "my-version" ]
  run bazelenv-version-file-write "${PWD}/my-version" "1.10.8"
  assert_success ""
  assert [ "$(cat my-version)" = "1.10.8" ]
}
