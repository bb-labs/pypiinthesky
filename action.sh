#!/bin/bash

package_name=$1
pypi_email=$2
pypi_password=$3
gh_username=$4
gh_email=$5

echo "$@: all the vars"

git config --global --add safe.directory /github/workspace

pip3 install setuptools wheel pipenv twine semver
commit_message=$(git log -1 --pretty=format:"%s")
bump_type=$(echo $commit_message | cut -d "[" -f2 | cut -d "]" -f1)

case "$bump_type" in
"patch") ;&
"minor") ;&
"major")
  current_version=$(python -c "import $package_name; print($package_name.__version__)")
  new_version=$(python -c "import semver; print(semver.bump_$bump_type('$current_version'))")

  echo "Bumping version from $current_version to $new_version"

  # handle both single and double quotes
  sed -i "s/__version__ = '$current_version'/__version__ = '$new_version'/" $package_name/__init__.py
  sed -i "s/__version__ = \"$current_version\"/__version__ = \"$new_version\"/" $package_name/__init__.py

  git config user.name "$username"
  git config user.email "$email"
  git commit -am "[$bump_type]: $new_version"
  git tag $new_version

  git push origin main
  git push origin --tags

  python setup.py sdist bdist_wheel
  twine upload dist/* -u $pypi_email -p $pypi_password
  ;;
*) ;;
esac
