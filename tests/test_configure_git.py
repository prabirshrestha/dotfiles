import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
SHARED = """\
[user]
    name = Example User
[core]
    editor = vim
    autocrlf = input
[push]
    autoSetupRemote = true
"""


class ConfigureGitTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        base = Path(self.tmp.name)
        self.home = base / "home with spaces"
        self.repo = base / "dotfiles"
        self.home.mkdir()
        (self.home / ".config/git").mkdir(parents=True)
        (self.repo / "scripts").mkdir(parents=True)
        (self.repo / ".dotter").mkdir()
        shutil.copy(ROOT / "scripts/configure-git", self.repo / "scripts")
        self.shared = self.home / ".config/git/shared.gitconfig"
        self.shared.write_text(SHARED)
        self.local = self.home / ".gitconfig"
        self.cache = self.repo / ".dotter/cache.toml"
        self.env = {
            key: value
            for key, value in os.environ.items()
            if not key.startswith("GIT_")
        }
        self.env.update(
            HOME=str(self.home),
            XDG_CONFIG_HOME=str(self.home / ".config"),
            GIT_CONFIG_NOSYSTEM="1",
        )

    def git(self, *args):
        return subprocess.run(
            ["git", *args],
            env=self.env,
            cwd=self.home,
            check=True,
            capture_output=True,
            text=True,
        ).stdout.strip()

    def migrate(self, env=None):
        return subprocess.run(
            ["sh", str(self.repo / "scripts/configure-git")],
            env=self.env if env is None else env,
            check=True,
            capture_output=True,
            text=True,
        )

    def test_preserves_private_settings_and_tool_writes(self):
        original = SHARED + """\
[core]
    editor = nvim
[credential "https://*.example.test"]
    helper =
    helper = example-helper
[include]
    path = private.gitconfig
"""
        self.local.write_text(original)
        (self.home / "private.gitconfig").write_text("[example]\n    local = yes\n")
        self.migrate()

        self.assertEqual(self.git("config", "--get", "user.name"), "Example User")
        self.assertEqual(self.git("config", "--get", "core.editor"), "nvim")
        self.assertEqual(self.git("config", "--get", "example.local"), "yes")
        self.assertTrue(self.local.read_text().startswith(
            "[include]\n    path = ~/.config/git/shared.gitconfig\n"
        ))
        self.assertNotIn("Example User", self.local.read_text())
        self.assertIn("helper =\n", self.local.read_text())
        backup = self.home / ".config/git/config.before-shared"
        self.assertEqual(backup.read_text(), original)
        self.assertEqual(backup.stat().st_mode & 0o777, 0o600)

        before = self.shared.read_bytes()
        self.git("config", "--global", "example.tool", "local-only")
        origin = self.git("config", "--show-origin", "--get", "example.tool")
        self.assertIn(str(self.local), origin)
        self.assertEqual(self.shared.read_bytes(), before)
        self.migrate()
        self.assertEqual(self.git("config", "--get", "example.tool"), "local-only")
        self.assertEqual(backup.read_text(), original)
        self.assertEqual(self.local.read_text().count("~/.config/git/shared.gitconfig"), 1)

    def test_new_machine_and_updated_shared_defaults(self):
        self.migrate()
        self.assertEqual(self.git("config", "--get", "core.editor"), "vim")
        self.shared.write_text(SHARED.replace("editor = vim", "editor = nano"))
        self.assertEqual(self.git("config", "--get", "core.editor"), "nano")
        self.assertFalse((self.home / ".config/git/config.before-shared").exists())

    def test_scoped_helpers_and_private_includes_survive_repeated_applies(self):
        private = self.home / ".config/git/private.gitconfig"
        private.write_text("""\
[credential "https://*.example.test"]
    helper =
    helper = scoped-helper
    useHttpPath = true
""")
        self.local.write_text("""\
[credential]
    helper = default-helper
[include]
    path = ~/.config/git/private.gitconfig
[credential "https://code.other.test"]
    helper =
    helper = host-helper
""")
        self.migrate()
        original = self.local.read_bytes()
        self.migrate()
        self.assertEqual(self.local.read_bytes(), original)
        for url, helper in [
            ("https://code.example.test/org/repo", "scoped-helper"),
            ("https://code.other.test/org/repo", "host-helper"),
        ]:
            helpers = self.git("config", "--get-urlmatch", "credential.helper", url)
            self.assertEqual(helpers, helper)
        self.assertEqual(
            self.git(
                "config", "--get-urlmatch", "credential.helper",
                "https://unrelated.test/org/repo",
            ),
            "default-helper",
        )
        self.assertEqual(
            self.git(
                "config", "--get-urlmatch", "credential.useHttpPath",
                "https://code.example.test/org/repo",
            ),
            "true",
        )
        self.assertEqual(private.read_text().count("scoped-helper"), 1)

    def test_detaches_old_symlink_without_editing_its_source(self):
        source = self.repo / "old.gitconfig"
        source.write_text(SHARED)
        self.local.symlink_to(source)
        self.migrate()
        self.assertFalse(self.local.is_symlink())
        self.git("config", "--global", "example.tool", "local-only")
        self.assertEqual(source.read_text(), SHARED)

    def test_only_releases_gitconfig_from_dotter_cache(self):
        self.local.write_text(SHARED)
        self.cache.write_text(
            '[symlinks]\n".zshrc" = "/home/example/.zshrc"\n'
            '[templates]\n".gitconfig" = "/home/example/.gitconfig"\n'
            '"other" = "/home/example/other"\n'
        )
        self.migrate()
        text = self.cache.read_text()
        self.assertNotIn('".gitconfig"', text)
        self.assertIn('".zshrc"', text)
        self.assertIn('"other"', text)

    def test_invalid_config_is_not_replaced(self):
        original = "[broken\n"
        self.local.write_text(original)
        with self.assertRaises(subprocess.CalledProcessError):
            self.migrate()
        self.assertEqual(self.local.read_text(), original)

    def test_windows_home_fallback_and_crlf_configs(self):
        original = (SHARED + '[credential]\n    helper = manager\n').replace("\n", "\r\n")
        self.local.write_bytes(original.encode())
        self.cache.write_bytes(
            b'[templates]\r\n".gitconfig" = "C:\\\\Users\\\\Example\\\\.gitconfig"\r\n'
            b'"other" = "C:\\\\Users\\\\Example\\\\other"\r\n'
        )
        env = self.env.copy()
        env.pop("HOME")
        env["USERPROFILE"] = str(self.home).replace("/", "\\")
        self.migrate(env)
        self.assertEqual(self.git("config", "--get", "credential.helper"), "manager")
        self.assertNotIn('".gitconfig"', self.cache.read_text())
        self.assertIn('"other"', self.cache.read_text())
        backup = self.home / ".config/git/config.before-shared"
        self.assertEqual(backup.read_bytes(), original.encode())

    @unittest.skipUnless(shutil.which("mise"), "mise is required to render defaults")
    def test_windows_and_unix_shared_defaults(self):
        source = (ROOT / ".config/git/shared.gitconfig").read_text()
        for platform in ["windows", "linux", "macos"]:
            with self.subTest(platform=platform):
                template = source.replace("os()", '"' + platform + '"')
                family = "windows" if platform == "windows" else "unix"
                template = template.replace("os_family()", '"' + family + '"')
                (self.repo / "shared.gitconfig").write_text(template)
                target = self.repo / "rendered.gitconfig"
                target.unlink(missing_ok=True)
                (self.repo / "mise.toml").write_text(
                    '[settings]\nexperimental = true\n[dotfiles]\n'
                    f'"{target.as_posix()}" = {{ source = "shared.gitconfig", mode = "template" }}\n'
                )
                env = self.env.copy()
                env["MISE_TRUSTED_CONFIG_PATHS"] = str(self.repo)
                subprocess.run(
                    ["mise", "-C", str(self.repo), "dotfiles", "apply", "--yes", str(target)],
                    env=env,
                    check=True,
                    capture_output=True,
                    text=True,
                )
                autocrlf = self.git("config", "--file", str(target), "--get", "core.autocrlf")
                self.assertEqual(autocrlf, "true" if platform == "windows" else "input")
                merge = self.git("config", "--file", str(target), "--get", "merge.tool")
                self.assertEqual(merge, "kdiff3" if platform == "windows" else "vimdiff")
                names = self.git("config", "--file", str(target), "--name-only", "--list")
                self.assertNotIn("credential.", names)


if __name__ == "__main__":
    unittest.main()
