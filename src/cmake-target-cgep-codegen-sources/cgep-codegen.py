# /// script
# requires-python = ">=3.14"
# dependencies = ["jinja2"]
# ///

from __future__ import annotations

import argparse
import json
from pathlib import Path
import shutil
import subprocess

from jinja2 import Template


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Render a C++ header from a JSON config.")
    parser.add_argument(
        "--config",
        required=True,
        type=Path,
        help="Path to the input JSON configuration file.",
    )
    parser.add_argument(
        "--output",
        required=True,
        type=Path,
        help="Path to the output .hpp file.",
    )
    parser.add_argument(
        "--format",
        action=argparse.BooleanOptionalAction,
        default=False,
        help="Enable or disable clang-format (default: disabled).",
    )
    parser.add_argument(
        "--template-dir",
        type=Path,
        required=True,
        help="Path to the directory containing Jinja2 templates.",
    )
    parser.add_argument(
        "--depfile",
        type=Path,
        required=False,
        help="Path to the output depfile.",
    )
    return parser.parse_args()


def load_config(*, config_path: Path) -> dict[str, object]:
    with config_path.open("r", encoding="utf-8") as f:
        return json.load(f)


def resolve_template_path(*, config: dict[str, object], config_path: Path, template_dir: Path) -> Path:
    template_name = config.get("template")
    if not isinstance(template_name, str) or not template_name:
        raise ValueError(f'Config key "template" in {config_path} must be a non-empty string.')

    template_path = Path(template_name)
    if not template_path.is_absolute():
        template_path = template_dir / template_path
    return template_path.resolve()


def render_from_config(*, config: dict[str, object], config_path: Path, template_dir: Path) -> tuple[str, Path]:
    template_path = resolve_template_path(
        config=config,
        config_path=config_path,
        template_dir=template_dir,
    )
    template_text = template_path.read_text(encoding="utf-8")
    config["config_path"] = config_path.resolve()
    config["template_path"] = template_path.resolve()
    return Template(template_text).render(**config), template_path


def depfile_escape(path: Path) -> str:
    # Makefile depfile escaping rules for spaces and special characters.
    escaped = str(path)
    escaped = escaped.replace("\\", "\\\\")
    escaped = escaped.replace(" ", "\\ ")
    escaped = escaped.replace("#", "\\#")
    escaped = escaped.replace(":", "\\:")
    return escaped


def write_depfile(*, depfile_path: Path, output_path: Path, dependencies: list[Path]) -> None:
    depfile_path.parent.mkdir(parents=True, exist_ok=True)
    deps_text = " ".join(depfile_escape(dep.resolve()) for dep in dependencies)
    text = f"{depfile_escape(output_path.resolve())}: {deps_text}\n"
    depfile_path.write_text(text, encoding="utf-8")


def main() -> None:
    args = parse_args()
    config = load_config(config_path=args.config)
    rendered, template_path = render_from_config(
        config=config,
        config_path=args.config,
        template_dir=args.template_dir,
    )

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(rendered, encoding="utf-8")

    if args.depfile is not None:
        this_file = Path(__file__).resolve()
        write_depfile(
            depfile_path=args.depfile,
            output_path=args.output,
            dependencies=[args.config, template_path, this_file],
        )

    if args.format:
        clang_format = shutil.which("clang-format")
        if clang_format is not None:
            # Formatting is best-effort to keep generation usable on any machine.
            cmd = [clang_format, "-i", str(args.output)]
            subprocess.run(cmd, check=False)


if __name__ == "__main__":
    main()
