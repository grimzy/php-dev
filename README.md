# PHP Development Docker Images

Super simple Docker images for PHP development.

**Versions**

- 5.5-cli
- 5.6-cli
- 7.0-cli
- 7.1-cli

**PHP modules installed:**

XDebug

PDO MySQL

## Usage

### PHP-CLI

```bash
docker run --rm -it
    -w=/app \
    -v /path/to/project:/app \
    jestefane/php-dev:7.0-cli-1.0.0
```

For example:

```shell
docker run --rm -it -w=/app -v $(pwd):/app jestefane/php-dev:7.0-cli-1.0.0 hello-world.php
```

### Composer

```shell
docker run --rm -it \
    -w=/app \
    -v /path/to/project:/app \
    -v ~/.ssh:/root/.ssh \
    -v $HOME/.composer-docker:/root/.composer \
    jestefane/php-dev:7.0-cli-1.0.0 composer
```

For example:

```shell
docker run --rm -it \
    -w=/app \
    -v $(pwd):/app \
    -v ~/.ssh:/root/.ssh \
    -v $HOME/.composer-docker:/root/.composer \
    jestefane/php-dev:7.0-cli-1.0.0 composer install
```

## Binaries

For simplicity , and to be able to use the tools normally, this repository contains binaries you can copy in `/usr/local/bin` (or anythwere in your `$PATH`).

```shell
make symlink_bins   # adds symlinks in /usr/local/bin
```

Or if you prefer:

```shell
make cp_bins        # copies the bins into /usr/local/bin
```

## Building images locally

```shell
make builds
```

## Rebuilding templates

```shell
make templates
```

## Adding a new PHP version

In Makefile, add the new version to `VERSIONS`. Then run

```shell
make builds
```

or run:

```shell
make builds VERSIONS=7.2
```