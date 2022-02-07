#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$BAZELENV_TEST_DIR"
  cd "$BAZELENV_TEST_DIR"
}

@test "no version selected" {
  assert [ ! -d "${BAZELENV_ROOT}/versions" ]
  run bazelenv-version-name
  assert_success "system"
}

@test "system version is not checked for existance" {
  BAZELENV_VERSION=system run bazelenv-version-name
  assert_success "system"
}

@test "BAZELENV_VERSION has precedence over local" {
  create_version "1.10.8"
  create_version "1.11.3"

  cat > ".bazel-version" <<<"1.10.8"
  run bazelenv-version-name
  assert_success "1.10.8"

  BAZELENV_VERSION=1.11.3 run bazelenv-version-name
  assert_success "1.11.3"
}

@test "local file has precedence over global" {
  create_version "1.10.8"
  create_version "1.11.3"

  cat > "${BAZELENV_ROOT}/version" <<<"1.10.8"
  run bazelenv-version-name
  assert_success "1.10.8"

  cat > ".bazel-version" <<<"1.11.3"
  run bazelenv-version-name
  assert_success "1.11.3"
}

@test "missing version" {
  BAZELENV_VERSION=1.2 run bazelenv-version-name
  assert_failure "bazelenv: version \`1.2' is not installed (set by BAZELENV_VERSION environment variable)"
}
