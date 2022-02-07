#!/usr/bin/env bats

load test_helper

@test "blank invocation" {
  run bazelenv
  assert_failure
  assert_line 0 "$(bazelenv---version)"
}

@test "invalid command" {
  run bazelenv does-not-exist
  assert_failure
  assert_output "bazelenv: no such command \`does-not-exist'"
}

@test "default BAZELENV_ROOT" {
  BAZELENV_ROOT="" HOME=/home/mislav run bazelenv root
  assert_success
  assert_output "/home/mislav/.bazelenv"
}

@test "inherited BAZELENV_ROOT" {
  BAZELENV_ROOT=/opt/bazelenv run bazelenv root
  assert_success
  assert_output "/opt/bazelenv"
}
