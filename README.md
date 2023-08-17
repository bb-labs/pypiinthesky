# pypiinthesky

## Action
Versioning action for pypi packages. On commit, this action will version and release your pypi package.

### Inputs

#### `package_name`
Name of your pypi package. It can either exist, or be created anew, so long as you own the name.
#### `pypi_email`
Your pypi email.
#### `pypi_password`
Your pypi password.
#### `gh_username`
Your github username.
#### `hg_email`
Your github email.

### Usage
```
uses: bb-labs/verpy@main # or pin to latest major
with:
  package_name: awyes
  gh_email: truman.purnell@gmail.com
  gh_username: trumanpurnell
  pypi_email: truman.purnell@gmail.com
  pypi_password: apassy
```

### Example
This will automatically cause your pypi package to release a new patch. You can place any semver bump within brackets anywhere in the commit message.
```
git commit -am 'fix[patch]: do a thing to fix a thing, release as a patch'
```

### Assumptions
You folder structure has its package within a folder of the same name as the package, with a `__version__` string defined in its `__init__.py`.

```
/root
  /awyes
    __init__.py # __version__ = '10.0.0'
```
