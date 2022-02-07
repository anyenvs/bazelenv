#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "${BAZELENV_TEST_DIR}/myproject"
  cd "${BAZELENV_TEST_DIR}/myproject"
}

@test "fails without arguments" {
  run bazelenv-version-file-read
  assert_failure ""
}

@test "fails for invalid file" {
  run bazelenv-version-file-read "non-existent"
  assert_failure ""
}

@test "fails for blank file" {
  echo > my-version
  run bazelenv-version-file-read my-version
  assert_failure ""
}

@test "reads simple version file" {
  cat > my-version <<<"1.11.3"
  run bazelenv-version-file-read my-version
  assert_success "1.11.3"
}

@test "ignores leading spaces" {
  cat > my-version <<<"  1.11.3"
  run bazelenv-version-file-read my-version
  assert_success "1.11.3"
}

@test "reads only the first word from file" {
  cat > my-version <<<"1.11.3-p194@tag 1.10.8 hi"
  run bazelenv-version-file-read my-version
  assert_success "1.11.3-p194@tag"
}

@test "loads only the first line in file" {
  cat > my-version <<IN
1.10.8 one
1.11.3 two
IN
  run bazelenv-version-file-read my-version
  assert_success "1.10.8"
}

@test "ignores leading blank lines" {
  cat > my-version <<IN

1.11.3
IN
  run bazelenv-version-file-read my-version
  assert_success "1.11.3"
}

@test "handles the file with no trailing newline" {
  echo -n "1.10.8" > my-version
  run bazelenv-version-file-read my-version
  assert_success "1.10.8"
}

@test "ignores carriage returns" {
  cat > my-version <<< $'1.11.3\r'
  run bazelenv-version-file-read my-version
  assert_success "1.11.3"
}
