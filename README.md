# pypiinthesky

## Action

This action will version and release your pypi package.

### Inputs

- #### `package_name`
- #### `pypi_email`
- #### `pypi_password`
- #### `bump_type`

### Usage

```
uses: bb-labs/pypiinthesky@main # or pin to latest major
with:
  package_name: awyes
  pypi_email: truman.purnell@gmail.com
  pypi_password: apassy
  bump_type: patch
```

You will be able to launch a release from your `Action`s tab in your github repository, provided you add this action in your repository's workflow.

### Assumptions

You folder structure has its package within a folder of the same name as the package, with a `__version__` string defined in its `__init__.py`.

```
/root
  /awyes
    __init__.py # __version__ = '10.0.0'
```
