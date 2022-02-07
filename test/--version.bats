#!/usr/bin/env bats

load test_helper

export GIT_DIR="${BAZELENV_TEST_DIR}/.git"

setup() {
  mkdir -p "$HOME"
  git config --global user.name  "Tester"
  git config --global user.email "tester@test.local"
  cd "$BAZELENV_TEST_DIR"
}

git_commit() {
  git commit --quiet --allow-empty -m "empty"
}

@test "default version" {
  assert [ ! -e "$BAZELENV_ROOT" ]
  run bazelenv---version
  assert_success
  [[ $output == "bazelenv "?.?.? ]]
}

@test "doesn't read version from non-bazelenv repo" {
  git init
  git remote add origin https://github.com/homebrew/homebrew.git
  git_commit
  git tag v1.0

  run bazelenv---version
  assert_success
  [[ $output == "bazelenv "?.?.? ]]
}

@test "reads version from git repo" {
  git init
  git remote add origin https://github.com/bazelenv/bazelenv.git
  git_commit
  git tag v0.4.1
  git_commit
  git_commit

  run bazelenv---version
  assert_success "bazelenv 0.4.1-2-g$(git rev-parse --short HEAD)"
}

@test "prints default version if no tags in git repo" {
  git init
  git remote add origin https://github.com/bazelenv/bazelenv.git
  git_commit

  run bazelenv---version
  [[ $output == "bazelenv "?.?.? ]]
}
