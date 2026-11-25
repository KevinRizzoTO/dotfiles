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

# fnm owns every Node version. Only the personal profile sets fnm's default; keep
# its major equal to personal-data/.node-version. Other profiles keep the default
# they already have.
install_default_node() {
  local profile=$1
  if [[ $profile != personal ]]; then
    echo "Profile $profile: fnm's default Node is not changed."
    return 0
  fi
  attempt fnm install 24
  attempt fnm default 24
}

install_macports_packages() {
  local port_name
  # MacPorts -p can return success even when individual ports failed. Separate
  # invocations preserve each failure while allowing the remaining ports to run.
  for port_name in "$@"; do
    attempt sudo /opt/local/bin/port -N -b install "$port_name"
  done
}
