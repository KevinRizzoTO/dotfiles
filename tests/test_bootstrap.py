"""Exercise platform routing without installing packages or changing dotfiles."""

import os
from pathlib import Path
import subprocess
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[1]


class BootstrapRouting(unittest.TestCase):
    def invoke(self, system="Darwin", machine="x86_64", translated="0", args=None):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            bin_dir = root / "bin"
            bin_dir.mkdir()
            home = root / "home"
            home.mkdir()
            scripts = {
                "uname": '#!/bin/sh\ncase "$1" in -s) echo "$TEST_SYSTEM";; -m) echo "$TEST_MACHINE";; esac\n',
                "sysctl": '#!/bin/sh\necho "$TEST_TRANSLATED"\n',
                "rake": '#!/bin/sh\nprintf "LEGACY_RAKE %s\\n" "$*"\n',
                # A dry run must never execute installation commands.
                "sudo": '#!/bin/sh\necho UNEXPECTED_SUDO >&2; exit 99\n',
                "arch": '#!/bin/sh\necho UNEXPECTED_ARCH >&2; exit 99\n',
                "git": '#!/bin/sh\necho UNEXPECTED_GIT >&2; exit 99\n',
                "stow": '#!/bin/sh\necho UNEXPECTED_STOW >&2; exit 99\n',
                "mkdir": '#!/bin/sh\necho UNEXPECTED_MKDIR >&2; exit 99\n',
            }
            for name, content in scripts.items():
                path = bin_dir / name
                path.write_text(content)
                path.chmod(0o755)
            env = dict(os.environ, PATH=f"{bin_dir}:/usr/bin:/bin", HOME=str(home),
                       TEST_SYSTEM=system, TEST_MACHINE=machine,
                       TEST_TRANSLATED=translated)
            env.pop("ZSH", None)
            env.pop("ZSH_CUSTOM", None)
            result = subprocess.run(["/bin/bash", str(REPO / "install.sh"),
                                     *(args if args is not None else ["--dry-run"])],
                                    env=env, text=True, capture_output=True)
            self.assertEqual(list(home.iterdir()), [], "Preview wrote to the home directory")
            self.assertNotIn("UNEXPECTED_", result.stderr)
            return result

    def test_intel_uses_only_macports_binaries(self):
        result = self.invoke()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("/opt/local/bin/port -N -b install oh-my-posh", result.stdout)
        self.assertIn("/opt/local/bin/port -N -b install zk", result.stdout)
        self.assertNotIn(" -p install", result.stdout)
        self.assertNotIn("brew bundle", result.stdout)
        self.assertIn("stow -t", result.stdout)
        self.assertIn("npm_config_prefix=", result.stdout)

    def test_node_comes_only_from_fnm(self):
        result = self.invoke()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("fnm install 24", result.stdout)
        self.assertIn("fnm default 24", result.stdout)
        # npm globals and Corepack run on fnm's Node, never a port's.
        self.assertIn("fnm exec --using=default -- env npm_config_prefix=", result.stdout)
        self.assertIn("fnm exec --using=default -- corepack enable yarn", result.stdout)
        for package in ("nodejs", "npm11", "pnpm", "tree-sitter-cli"):
            self.assertNotRegex(result.stdout, rf"port -N -b install {package}\b")

    def test_native_arm_uses_homebrew(self):
        result = self.invoke(machine="arm64")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("arch -arm64 /opt/homebrew/bin/brew bundle", result.stdout)
        self.assertNotIn("/opt/local/bin/port", result.stdout)
        self.assertIn("fnm default 24", result.stdout)
        self.assertNotIn('brew "pnpm"', (REPO / "Brewfile").read_text())

    def test_rosetta_uses_native_arm_homebrew(self):
        result = self.invoke(machine="x86_64", translated="1")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("arch -arm64 /opt/homebrew/bin/brew bundle", result.stdout)
        self.assertNotIn("/opt/local/bin/port", result.stdout)

    def test_linux_keeps_legacy_rake(self):
        result = self.invoke(system="Linux", args=[])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("LEGACY_RAKE -m", result.stdout)
        self.assertNotIn("/opt/local", result.stdout)

    def test_unsupported_mac_architecture_stops(self):
        result = self.invoke(machine="unknown")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Unsupported macOS architecture", result.stderr)
        self.assertNotIn("stow -t", result.stdout)

    def test_bad_option_stops_before_installation(self):
        result = self.invoke(args=["--force"])
        self.assertEqual(result.returncode, 2)
        self.assertNotIn("port -N", result.stdout)

    def test_missing_archive_is_recorded_and_later_ports_still_run(self):
        script = '''
set -euo pipefail
source "$1"
dry_run=false
failures=()
calls=()
sudo() {
  local name="${@: -1}"
  calls+=("$name")
  [[ $name != unavailable ]]
}
install_macports_packages first unavailable last
[[ "${calls[*]}" == 'first unavailable last' ]]
[[ ${#failures[@]} == 1 ]]
[[ ${failures[0]} == *'install unavailable' ]]
'''
        result = subprocess.run(["/bin/bash", "-c", script, "test",
                                 str(REPO / "scripts/bootstrap-commands.sh")],
                                text=True, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
