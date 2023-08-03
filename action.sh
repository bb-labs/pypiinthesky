#!/bin/bash

pip3 install setuptools wheel pipenv twine semver
commit_message=$(git log -1 --pretty=format:"%s")
bump_type=$(echo $commit_message | cut -d "[" -f2 | cut -d "]" -f1)

case "$bump_type" in
"patch") ;&
"minor") ;&
"major")
  current_version=$(python -c "import $1; print($1.__version__)")
  new_version=$(python -c "import semver; print(semver.bump_$bump_type('$current_version'))")

  echo "Bumping version from $current_version to $new_version"

  # handle both single and double quotes
  sed -i "s/__version__ = '$current_version'/__version__ = '$new_version'/" $1/__init__.py
  sed -i "s/__version__ = \"$current_version\"/__version__ = \"$new_version\"/" $1/__init__.py

  git config user.name "trumanpurnell"
  git config user.email "truman.purnell@gmail.com"
  git commit -am "[$bump_type]: $new_version"
  git tag $new_version

  git push origin main
  git push origin --tags

  python setup.py sdist bdist_wheel
  twine upload dist/*
  ;;
*) ;;
esac
