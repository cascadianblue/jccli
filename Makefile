.DEFAULT_GOAL := build
.PHONY: build publish package coverage test docs venv
PROJ_SLUG = jccli
CLI_NAME = jccli
PY_VERSION = 3.6



build:
	pip install --editable .

run:
	$(CLI_NAME)

freeze:
	pip freeze > requirements.txt

test:
	py.test --cov-report term --cov=$(PROJ_SLUG) tests/

quicktest:
	py.test --cov-report term --cov=$(PROJ_SLUG) tests/

coverage:
	py.test --cov-report html --cov=$(PROJ_SLUG) tests/

docs: coverage
	mkdir -p docs/source/_static
	mkdir -p docs/source/_templates
	cd docs && $(MAKE) html
	pandoc --from=markdown --to=rst --output=README.rst README.md

answers:
	cd docs && $(MAKE) html
	xdg-open docs/build/html/index.html

package: clean docs
	python setup.py sdist
	# python setup.py bdist_wheel
	twine check dist/*
	ls -l dist

publish: package
	twine upload dist/*

clean :
	rm -rf dist \
	rm -rf docs/build \
	rm -rf *.egg-info
	coverage erase

venv :

	virtualenv --python python$(PY_VERSION) venv



install:
	pip install -r requirements.txt

licenses:
	pip-licenses --with-url --format=rst \
	--ignore-packages $(shell cat .pip-license-ignore | awk '{$$1=$$1};1')
