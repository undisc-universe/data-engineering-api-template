# =========================
# Configuration
# =========================
PROJECT_NAME := data-engineering-api-template
PYTHON := poetry run python
RUFF := poetry run ruff
BLACK := poetry run black

# =========================
# Help
# =========================
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make install         Install project dependencies"
	@echo "  make lint            Run Ruff linter"
	@echo "  make lint-fix        Run Ruff with auto-fix"
	@echo "  make format          Format code with Black"
	@echo "  make check           Run lint + format check"
	@echo "  make clean           Remove cache files"
	@echo "  make notebook-kernel Register Jupyter kernel"
	@echo "  make test            Run tests"
	@echo "  make test-cov        Run tests with coverage"
	@echo "  make cov-report      Run tests and generate HTML coverage report"
	@echo "  make test-watch      Run tests continuously (fail-fast)"


# =========================
# Dependencies
# =========================
.PHONY: install
install:
	poetry install

# =========================
# Linting & Formatting
# =========================
.PHONY: lint
lint:
	$(RUFF) check .

.PHONY: lint-fix
lint-fix:
	$(RUFF) check . --fix

.PHONY: format
format:
	$(BLACK) .

.PHONY: check
check: lint format

# =========================
# Jupyter
# =========================
.PHONY: notebook-kernel
notebook-kernel:
	$(PYTHON) -m ipykernel install --user \
		--name $(PROJECT_NAME) \
		--display-name "Python 3.11 ($(PROJECT_NAME))"

# =========================
# Cleanup
# =========================
.PHONY: clean
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +

# =========================
# Testing
# =========================
.PHONY: test
test:
	poetry run pytest

.PHONY: test-watch
test-watch:
	poetry run pytest -f

.PHONY: test-cov
test-cov:
	poetry run pytest --cov=src --cov-report=term-missing

.PHONY: cov-report
cov-report:
	poetry run pytest --cov=src --cov-report=html
	@echo "HTML coverage report generated at htmlcov/index.html"
