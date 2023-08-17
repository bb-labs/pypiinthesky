#!/bin/bash

package_name=$1
pypi_username=$2
pypi_password=$3
bump_type=$4

if [ -z $package_name ] || [ -z $pypi_username ] || [ -z $pypi_password ] || [ -z $bump_type ]; then
  echo 'one or more variables are undefined: '
  echo "package_name: $package_name"
  echo "pypi_username: $pypi_username"
  echo "pypi_password: $pypi_password"
  echo "bump_type: $bump_type"
  exit 1
fi

git config --global --add safe.directory /github/workspace

pip3 install setuptools wheel pipenv twine semver build

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

  git config --global user.name "${GITHUB_ACTOR}"
  git config --global user.email "${GITHUB_ACTOR_ID}+${GITHUB_ACTOR}@users.noreply.github.com"

  git commit -am "[$bump_type]: $new_version"
  git tag $new_version

  git push origin main
  git push origin --tags

  python -m build --sdist --wheel
  twine upload --verbose dist/* -u $pypi_username -p $pypi_password
  ;;
*) ;;
esac
