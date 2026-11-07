# Shared by install.sh and the bootstrap regression checks.
run() {
  printf '+'
  printf ' %q' "$@"
  printf '\n'
  if [[ $dry_run == false ]]; then
    "$@"
  fi
}

attempt() {
  if ! run "$@"; then
    failures+=("$*")
  fi
}

install_macports_packages() {
  local port_name
  # MacPorts -p can return success even when individual ports failed. Separate
  # invocations preserve each failure while allowing the remaining ports to run.
  for port_name in "$@"; do
    attempt sudo /opt/local/bin/port -N -b install "$port_name"
  done
}
