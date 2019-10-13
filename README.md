# PHP Development Docker Images

![Docker Cloud Automated build][docker-cloud-automated] ![Docker Cloud Build Status][docker-cloud-build] ![Docker Pulls][docker-pulls] ![Docker Stars][docker-stars] ![MicroBadger Layers][microbadger-layers] ![MicroBadger Size][microbadger-image-size]

>  Super simple Docker images for PHP development.

**PHP Versions:** `5.5`, `5.6`, `7.0`, `7.1`, `7.2`

**PHP Variants:** `cli`

**Images based on the** [Official PHP Images][docker-php]

**Also installed:**

- [Composer][composer]
- PHP modules `XDebug`, `PDO MySQL`

## Installation

**Pull the latest version:**

```sh
$ docker pull jestefane/php-dev
```

**Pull a specific version:**

```sh
$ docker pull jestefane/php-dev:7.2-cli-1.1.0
```

Pick between the various [images provided in this repository][images].

**(Optionally) Install the Shortcuts:**

To use the Docker images more like binaries, we're providing [Shortcuts][shortcuts] that can easily be [installed on your system][install-the-shortcuts].

## Images

> Image names have the following format:
>
> ```
> <docker repo>:<php version>-<php variant>-<github repo version>
> ```

### CLI

**Images names**:

- `jestefane/php-dev:5.5-cli-1.1.0`
- `jestefane/php-dev:5.6-cli-1.1.0`
- `jestefane/php-dev:7.0-cli-1.1.0`
- `jestefane/php-dev:7.1-cli-1.1.0`
- `jestefane/php-dev:7.2-cli-1.1.0`

**Shortcuts**: [`php-cli`][php-cli-ref], [`composer`][composer-ref]

**Example**:

```bash
$ docker run jestefane/php-dev:7.2-cli-1.1.0 hello-world.php

# or using one of the provided shortcuts
$ php-7.2-cli hello-world.php
```

## Shortcuts

> **Note**: Only tested on some distros of Linux and Mac OS. But hey! It's tested ;)

Shortcuts are simple `bash` scripts wrapping the `docker` command that facilitate command-line-use of the images in this repository.

### Install the Shortcuts

From the root of this directory:

```sh
# If you haven't done so, clone this repository
$ git clone https://github.com/grimzy/php-dev.git

# Get in there!
# Yes, you have to! the script doesn't always work when running from outside
$ cd php-dev

# Generate the scripts and install the shortcuts
make shortcuts
```

This generates `bash` scripts in the `scripts` directory (via. [Script Template][templates]). It also adds them to your `PATH` environment variable (Linux and Mac OS only) by creating symlinks of the generated `bash` scripts inside `/usr/local/bin`.

For more info on the `shortcuts` task, please checkout the [Makefile command reference][shortcuts-make].

#### Script Templates

You'll notice that the directory that should contain the scripts doesn't exist; that's because you first need to generate them. This is automatically done prior to creating the symlinks. But if you've deleted a script or changed the templates in some way, you can regenerate scripts with:

```sh
# Removes the scripts directory and generates them back
$ make scripts
```

For more info on the `scripts` task [Makefile command reference][scripts-make].

### Shortcuts Reference

#### PHP CLI

**Images**: [All respective versions of the PHP CLI variant][cli]

**Shortcuts**: `php-5.5-cli`, `php-5.6-cli`, `php-7.0-cli`, `php-7.1-cli`, `php-7.2-cli`

**Script template**: [template/php-cli.template][php-cli-template]

#### Composer

**Images**: [All respective versions of `jestefane/php-dev` images][images] ([Composer][composer] is installed on every image)

**Shortcuts**: `composer-5.5`, `composer-5.6`, `composer-7.0`, `composer-7.1`, `composer-7.2`

**Script template**: [template/composer.template][composer-template]

## Makefile Commands Reference

### Variables

| Variable name   | Description                                                  | Default value                         | Possible values                                              |
| --------------- | ------------------------------------------------------------ | ------------------------------------- | ------------------------------------------------------------ |
| `SOURCE_BRANCH` | Appended to the image name                                   | Repository's current version: `1.1.0` | Any `string` value                                           |
| `PHP_VERSIONS`  | Space separated list of PHP versions to perform a task on    | `5.5 5.6 7.0 7.1 7.2`                 | Any combination from `5.5`, `5.6`, `7.0`, `7.1`, `7.2`       |
| `PHP_VARIANTS`  | Space separated list of Docker build variants to perform a task on | `cli`                                 | `cli`                                                        |
| `BIN_DIR`       | Directory in your `PATH` where you would like to symlink the scripts | `/usr/local/bin`                      | Any path on your system. Preferaby one already in your `PATH` |
| `SCRIPTS_DIR`   | Directory where the scripts are generated (or removed). Relative to the repository's root | `scripts`                             | Any path on your system                                      |

> **Note**: When overriding space separated values from the CLI, you have to escape spaces. For example in `bash` you use `\`:
>
> ```sh
> $ make build PHP_VERSIONS=7.0\ 7.1\ 7.2
> ```

### Tasks

#### Build the Images

Locally builds all images from all possible combinations of `PHP_VERSIONS` and `PHP_VARIANTS`. `SOURCE_BRANCH` is appended to the image name.

**Command:** 

```sh
$ make build [PHP_VERSIONS=] [PHP_VARIANTS=] [SOURCE_BRANCH=]
```

#### Remove the Images

Remove all locally cached images from all possible combinations of `PHP_VERSIONS` and `PHP_VARIANTS`.

**Command:**

```sh
$ make rm_build [PHP_VERSIONS=] [PHP_VARIANTS=] [SOURCE_BRANCH=]
```

#### Rebuild the Images

Alias for removing then building the images: `make rm_build build`.

#### Generate the Scripts

Generate the `bash` scripts from [templates][templates] in the `template` directory. Generated scripts are saved in the `SCRIPTS_DIR` directory. The `PHP_VERSION` `PHP_VARIANT` and `SOURCE_BRANCH` are passed to the [templates][templates].

**Command:**

This task first runs: `rm_scripts_dir`

```sh
$ make scripts [PHP_VERSIONS=] [PHP_VARIANTS=] [SOURCE_BRANCH=] [SCRIPTS_DIR=]
```

#### Remove the Generated Scripts Directory

Removes the `SCRIPTS_DIR` directory.

**Command:**

```sh
$ make rm_scripts_dir [SCRIPTS_DIR=]
```

#### Create the Shortcuts

> **Note**: Linux and Mac OS only

This task creates symlinks of the scripts inside of `SCRIPTS_DIR` inside of the `BIN_DIR`. This adds them to your `PATH` environment variable (Linux and Mac OS only) easily making them available for use on your command line.

**Command:**

```sh
$ make shortcuts [SCRIPTS_DIR=] [BIN_DIR=]
```

**Before run:** `make scripts`

#### Remove the Shortcuts

This task removes this repository's scripts' symlinks from the `BIN_DIR`.

**Command:**

```sh
$ make rm_shortcuts [PHP_VERSIONS=] [PHP_VARIANTS=] [BIN_DIR=]
```

#### Remove Dangling Volumes and Images

> **Warning**: Running this task will remove **any** dangling volume and image on your system; not just the ones provided.

**Command:**

```sh
$ make rm_dangling
```

## License

[MIT][license] © Joseph Estefane


[docker-cloud-automated]: https://img.shields.io/docker/cloud/automated/jestefane/php-dev "Docker Cloud Automated build"
[docker-cloud-build]: https://img.shields.io/docker/cloud/build/jestefane/php-dev "Docker Cloud Build Status"
[docker-pulls]: https://img.shields.io/docker/pulls/jestefane/php-dev "Docker Pulls"
[docker-stars]: https://img.shields.io/docker/stars/jestefane/php-dev "Docker Stars"
[microbadger-layers]: https://img.shields.io/microbadger/layers/jestefane/php-dev/7.2-cli-args-in-build "MicroBadger Layers"
[microbadger-image-size]: https://img.shields.io/microbadger/image-size/jestefane/php-dev/7.2-cli-1.1.0 "MicroBadger Size"
[shortcuts]: #shortcuts "Shortcuts"
[install-the-shortcuts]: #install-the-shortcuts "Install the Shortcuts"
[docker-php]: https://hub.docker.com/_/php "Official Docker PHP Images"
[images]: #images "PHP Images"
[cli]: #cli "PHP CLI Image"
[php-cli-ref]: #php-cli "PHP CLI Scripts"
[php-cli-template]: template/php-cli.template "PHP CLI Template"
[composer]: https://getcomposer.org/ "Composer"
[composer-template]: template/composer.template "Composer Template"
[composer-ref]: #composer	""PHP Composer Scripts""
[templates]: #script-templates	"Script Templates"
[shortcuts-make]: #create-the-shortcuts	"Create the Shortcuts"
[scripts-make]: #generate-the-scripts	"Generate the Scripts"
[license]: ./LICENSE "MIT License"
