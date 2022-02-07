#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$BAZELENV_TEST_DIR"
  cd "$BAZELENV_TEST_DIR"
}

@test "no version selected" {
  assert [ ! -d "${BAZELENV_ROOT}/versions" ]
  run bazelenv-version
  assert_success "system (set by ${BAZELENV_ROOT}/version)"
}

@test "set by BAZELENV_VERSION" {
  create_version "1.11.3"
  BAZELENV_VERSION=1.11.3 run bazelenv-version
  assert_success "1.11.3 (set by BAZELENV_VERSION environment variable)"
}

@test "set by local file" {
  create_version "1.11.3"
  cat > ".bazel-version" <<<"1.11.3"
  run bazelenv-version
  assert_success "1.11.3 (set by ${PWD}/.bazel-version)"
}

@test "set by global file" {
  create_version "1.11.3"
  cat > "${BAZELENV_ROOT}/version" <<<"1.11.3"
  run bazelenv-version
  assert_success "1.11.3 (set by ${BAZELENV_ROOT}/version)"
}
