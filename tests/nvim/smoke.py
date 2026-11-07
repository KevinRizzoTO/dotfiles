#!/usr/bin/env python3
"""Exercise the real Neovim config in disposable Python, JS/TS, and Go projects."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

REPO = Path(__file__).resolve().parents[2]


def run(*args, **kwargs):
    subprocess.run(args, check=True, **kwargs)


def write(root, name, content):
    path = root / name
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)


def main():
    for tool in ("nvim", "uv", "npm", "go"):
        if not shutil.which(tool):
            raise SystemExit(f"Missing prerequisite: {tool}")
    with tempfile.TemporaryDirectory(prefix="nvim-smoke-") as directory:
        root = Path(directory).resolve()
        py = root / "python"
        write(py, "pyproject.toml", '[project]\nname = "nvim-smoke"\nversion = "0.0.0"\n')
        write(py, "test_sample.py", "def test_pass():\n    assert 1 + 1 == 2\n\ndef test_fail():\n    assert 1 == 2\n")
        write(py, "sample.py", "import os\nvalue: int = 'wrong'\nprint(missing_name)\n")
        write(py, "format.py", "value={'hello':1}\n")
        run("uv", "venv", str(py / ".venv"))
        run("uv", "pip", "install", "--python", str(py / ".venv/bin/python"), "pytest")

        web = root / "web"
        write(web, "package.json", json.dumps({"name": "nvim-smoke", "private": True, "type": "module"}))
        run("npm", "install", "--prefix", str(web), "--no-audit", "--no-fund", "--save-dev",
            "typescript@5", "prettier", "vitest", "eslint", "@typescript-eslint/parser", "jest")
        metadata = json.loads((web / "package.json").read_text())
        del metadata["devDependencies"]["jest"]
        write(web, "package.json", json.dumps(metadata))
        write(web, "tsconfig.json", '{"compilerOptions":{"strict":true,"target":"ES2022","module":"ESNext","skipLibCheck":true},"include":["*.ts"]}')
        write(web, ".prettierrc.json", '{"semi":false,"singleQuote":true}')
        write(web, "format.ts", 'const value={hello:"world"};\n')
        write(web, "sample.ts", 'const value: number = "wrong";\nconsole.log(missingName);\n')
        write(web, "eslint.config.mjs", 'import parser from "@typescript-eslint/parser";\nexport default [{files:["**/*.ts"], languageOptions:{parser}, rules:{"no-console":"error"}}];\n')
        write(web, "sample.test.ts", 'import {test, expect} from "vitest";\ntest("passes", () => {expect(2).toBe(2)});\ntest("fails", () => {expect(1).toBe(2)});\n')
        # Keep Jest separate so adapters cannot accidentally claim the same file.
        jest = root / "jest"
        write(jest, "package.json", '{"name":"jest-smoke","private":true,"devDependencies":{"jest":"*"}}')
        (jest / "node_modules").symlink_to(web / "node_modules", target_is_directory=True)
        write(jest, "sample.test.js", 'test("passes", () => {expect(2).toBe(2)});\ntest("fails", () => {expect(1).toBe(2)});\n')
        native = root / "native"
        write(native, "tsconfig.json", '{"compilerOptions":{"strict":true}}')
        write(native, "sample.ts", 'function add(a: number, b: number) { return a + b; }\nconst value: number = "wrong";\nadd(1, 2);\n')
        go = root / "go"
        write(go, "go.mod", "module example.com/nvim-smoke\n\ngo 1.23\n")
        write(go, "main.go", 'package main\nimport "fmt"\nfunc main(){\nfmt.Println("hello")\n}\n')
        env = dict(os.environ, NVIM_SMOKE_ROOT=str(root))
        run("nvim", "--headless", "-u", str(REPO / "nvim/.config/nvim/init.lua"),
            "+luafile " + str(REPO / "tests/nvim/smoke.lua"), env=env, timeout=240)


if __name__ == "__main__":
    main()
