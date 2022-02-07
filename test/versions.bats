#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$BAZELENV_TEST_DIR"
  cd "$BAZELENV_TEST_DIR"
}

stub_system_bazel() {
  local stub="${BAZELENV_TEST_DIR}/bin/bazel"
  mkdir -p "$(dirname "$stub")"
  touch "$stub" && chmod +x "$stub"
}

@test "no versions installed" {
  stub_system_bazel
  assert [ ! -d "${BAZELENV_ROOT}/versions" ]
  run bazelenv-versions
  assert_success "* system (set by ${BAZELENV_ROOT}/version)"
}


@test "bare output no versions installed" {
  assert [ ! -d "${BAZELENV_ROOT}/versions" ]
  run bazelenv-versions --bare
  assert_success ""
}

@test "single version installed" {
  stub_system_bazel
  create_version "1.9"
  run bazelenv-versions
  assert_success
  assert_output <<OUT
* system (set by ${BAZELENV_ROOT}/version)
  1.9
OUT
}

@test "single version bare" {
  create_version "1.9"
  run bazelenv-versions --bare
  assert_success "1.9"
}

@test "multiple versions" {
  stub_system_bazel
  create_version "1.10.8"
  create_version "1.11.3"
  create_version "1.13.0"
  run bazelenv-versions
  assert_success
  assert_output <<OUT
* system (set by ${BAZELENV_ROOT}/version)
  1.10.8
  1.11.3
  1.13.0
OUT
}

@test "indicates current version" {
  stub_system_bazel
  create_version "1.11.3"
  create_version "1.13.0"
  BAZELENV_VERSION=1.11.3 run bazelenv-versions
  assert_success
  assert_output <<OUT
  system
* 1.11.3 (set by BAZELENV_VERSION environment variable)
  1.13.0
OUT
}

@test "bare doesn't indicate current version" {
  create_version "1.11.3"
  create_version "1.13.0"
  BAZELENV_VERSION=1.11.3 run bazelenv-versions --bare
  assert_success
  assert_output <<OUT
1.11.3
1.13.0
OUT
}

@test "globally selected version" {
  stub_system_bazel
  create_version "1.11.3"
  create_version "1.13.0"
  cat > "${BAZELENV_ROOT}/version" <<<"1.11.3"
  run bazelenv-versions
  assert_success
  assert_output <<OUT
  system
* 1.11.3 (set by ${BAZELENV_ROOT}/version)
  1.13.0
OUT
}

@test "per-project version" {
  stub_system_bazel
  create_version "1.11.3"
  create_version "1.13.0"
  cat > ".bazel-version" <<<"1.11.3"
  run bazelenv-versions
  assert_success
  assert_output <<OUT
  system
* 1.11.3 (set by ${BAZELENV_TEST_DIR}/.bazel-version)
  1.13.0
OUT
}

@test "ignores non-directories under versions" {
  create_version "1.9"
  touch "${BAZELENV_ROOT}/versions/hello"

  run bazelenv-versions --bare
  assert_success "1.9"
}

@test "lists symlinks under versions" {
  create_version "1.10.8"
  ln -s "1.10.8" "${BAZELENV_ROOT}/versions/1.10"

  run bazelenv-versions --bare
  assert_success
  assert_output <<OUT
1.10
1.10.8
OUT
}

@test "doesn't list symlink aliases when --skip-aliases" {
  create_version "1.10.8"
  ln -s "1.10.8" "${BAZELENV_ROOT}/versions/1.10"
  mkdir moo
  ln -s "${PWD}/moo" "${BAZELENV_ROOT}/versions/1.9"

  run bazelenv-versions --bare --skip-aliases
  assert_success

  assert_output <<OUT
1.10.8
1.9
OUT
}
