if [[ ! -o interactive ]]; then
    return
fi

compctl -K _bazelenv bazelenv

_bazelenv() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(bazelenv commands)"
  else
    completions="$(bazelenv completions ${words[2,-2]})"
  fi

  reply=(${(ps:\n:)completions})
}
