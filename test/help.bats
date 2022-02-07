#!/usr/bin/env bats

load test_helper

@test "without args shows summary of common commands" {
  run bazelenv-help
  assert_success
  assert_line "Usage: bazelenv <command> [<args>]"
  assert_line "Some useful bazelenv commands are:"
}

@test "invalid command" {
  run bazelenv-help hello
  assert_failure "bazelenv: no such command \`hello'"
}

@test "shows help for a specific command" {
  mkdir -p "${BAZELENV_TEST_DIR}/bin"
  cat > "${BAZELENV_TEST_DIR}/bin/bazelenv-hello" <<SH
#!shebang
# Usage: bazelenv hello <world>
# Summary: Says "hello" to you, from bazelenv
# This command is useful for saying hello.
echo hello
SH

  run bazelenv-help hello
  assert_success
  assert_output <<SH
Usage: bazelenv hello <world>

This command is useful for saying hello.
SH
}

@test "replaces missing extended help with summary text" {
  mkdir -p "${BAZELENV_TEST_DIR}/bin"
  cat > "${BAZELENV_TEST_DIR}/bin/bazelenv-hello" <<SH
#!shebang
# Usage: bazelenv hello <world>
# Summary: Says "hello" to you, from bazelenv
echo hello
SH

  run bazelenv-help hello
  assert_success
  assert_output <<SH
Usage: bazelenv hello <world>

Says "hello" to you, from bazelenv
SH
}

@test "extracts only usage" {
  mkdir -p "${BAZELENV_TEST_DIR}/bin"
  cat > "${BAZELENV_TEST_DIR}/bin/bazelenv-hello" <<SH
#!shebang
# Usage: bazelenv hello <world>
# Summary: Says "hello" to you, from bazelenv
# This extended help won't be shown.
echo hello
SH

  run bazelenv-help --usage hello
  assert_success "Usage: bazelenv hello <world>"
}

@test "multiline usage section" {
  mkdir -p "${BAZELENV_TEST_DIR}/bin"
  cat > "${BAZELENV_TEST_DIR}/bin/bazelenv-hello" <<SH
#!shebang
# Usage: bazelenv hello <world>
#        bazelenv hi [everybody]
#        bazelenv hola --translate
# Summary: Says "hello" to you, from bazelenv
# Help text.
echo hello
SH

  run bazelenv-help hello
  assert_success
  assert_output <<SH
Usage: bazelenv hello <world>
       bazelenv hi [everybody]
       bazelenv hola --translate

Help text.
SH
}

@test "multiline extended help section" {
  mkdir -p "${BAZELENV_TEST_DIR}/bin"
  cat > "${BAZELENV_TEST_DIR}/bin/bazelenv-hello" <<SH
#!shebang
# Usage: bazelenv hello <world>
# Summary: Says "hello" to you, from bazelenv
# This is extended help text.
# It can contain multiple lines.
#
# And paragraphs.

echo hello
SH

  run bazelenv-help hello
  assert_success
  assert_output <<SH
Usage: bazelenv hello <world>

This is extended help text.
It can contain multiple lines.

And paragraphs.
SH
}
