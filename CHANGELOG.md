# Changelog
All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning][semver].


## \[Unreleased]

Refer to master branch

## \[v1.1.0\] - 2019-10-12

### Build Images with --build-args:
- Using Docker Cloud `build` hook to pass `--build-args` to our `docker build` command during Automated Builds
- Using Docker Cloud `pre_push` hook to push our new image tags during Automated Builds
- Only generating scripts when calling make scripts (scripts are Git ignored)
- Updated script templates
- Removed generated files

## \[v1.0.1\] - 2018-06-16

### PHP 7.2, symlinks:
- Added PHP 7.2
- Prepending image variant to image name
- Added symklink alternative to copying the binaries
- Fixed composer volume mount in readme and templates
- Generated build files for `v1.0.1`

## \[v1.0.0\] - 2017-08-26

### Initial Release:
- Added build generation from templates
- Generated build files for `v1.0.0`
- Initial working Docker build

[semver]: https://semver.org/spec/v2.0.0.html "Semantic Versioning 2.0.0"

