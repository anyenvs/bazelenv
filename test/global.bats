#!/usr/bin/env bats

load test_helper

@test "default" {
  run bazelenv-global
  assert_success
  assert_output "system"
}

@test "read BAZELENV_ROOT/version" {
  mkdir -p "$BAZELENV_ROOT"
  echo "1.2.3" > "$BAZELENV_ROOT/version"
  run bazelenv-global
  assert_success
  assert_output "1.2.3"
}

@test "set BAZELENV_ROOT/version" {
  mkdir -p "$BAZELENV_ROOT/versions/1.2.3/bin"
  run bazelenv-global "1.2.3"
  assert_success
  run bazelenv-global
  assert_success "1.2.3"
}

@test "fail setting invalid BAZELENV_ROOT/version" {
  mkdir -p "$BAZELENV_ROOT"
  run bazelenv-global "1.2.3"
  assert_failure "bazelenv: version \`1.2.3' is not installed"
}
