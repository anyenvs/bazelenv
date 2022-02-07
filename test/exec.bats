#!/usr/bin/env bats

load test_helper

create_executable() {
  name="${1?}"
  shift 1
  bin="${BAZELENV_ROOT}/versions/${BAZELENV_VERSION}/bin"
  mkdir -p "$bin"
  { if [ $# -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed -Ee '1s/^ +//' > "${bin}/$name"
  chmod +x "${bin}/$name"
}

@test "fails with invalid version" {
  export BAZELENV_VERSION="0.0.0"
  run bazelenv-exec version
  assert_failure "bazelenv: version \`0.0.0' is not installed"
}

@test "fails with invalid version set from file" {
  mkdir -p "$BAZELENV_TEST_DIR"
  cd "$BAZELENV_TEST_DIR"
  echo 0.0.1 > .bazel-version
  run bazelenv-exec rspec
  assert_failure "bazelenv: version \`0.0.1' is not installed (set by $PWD/.bazel-version)"
}
