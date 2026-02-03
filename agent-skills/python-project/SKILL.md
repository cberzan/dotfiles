---
name: python-project
description: Rules to follow when working on a Python project.
---

* We use `uv` and `pyproject.toml` for dependency and virtualenv management. To install
  a dependency, use `uv add` instead of `pip install`.
* We prefer pytest for unit tests. Add pytest as a dev dependency to any new projects.
  When writing new tests or refactoring existing tests, prefer standalone functions
  (pytest style) as opposed to `unittest.TestCase` subclasses.
* We use ruff for linting and auto-formatting. Ruff is installed globally, so you don't
  need to add it to any individual projects. When you are done making changes, run `ruff
  check --fix && ruff format`. New projects should use the following ruff configuration
  in `pyproject.toml`:

    [tool.ruff.lint]
    select = ["E4", "E7", "E9", "F", "I"]
