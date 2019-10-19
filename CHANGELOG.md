# Changelog
All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning][semver].


## \[Unreleased]

Refer to master branch

## \[v1.1.2\] - 2019-10-19

### Refactor Hooks into Functions:
- Refactored Docker hook scripts into reusable functions
- Fix issue with short tags not being pushed
- Fixed `make rm_build`
- Removed source branch image name in templates

## \[v1.1.1\] - 2019-10-14

### Split PHP builds, PHP FPM, Latest tag:
- Split builds by PHP version and variant
- Use builds Docker hooks in Makefile
- Added `fpm` variant
- Now using `DOCKER_REPO` and `DOCKER_TAG` build variables
- Push `latest` tags when building latest version (checks for Semantic Version in `$SOURCE_BRANCH`)
- Set latest PHP version to  7.2 and variant to CLI

## \[v1.1.0\] - 2019-10-13

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
