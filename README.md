# PHP Development Docker Images

Super simple Docker images for PHP development.

**PHP Versions: ** `5.5`, `5.6`, `7.0`, `7.1`, `7.2`

**PHP Variants:** `cli`

**Also installed:**

- Composer
- PHP modules `XDebug`, `PDO MySQL`



## Pull the Image

**Pull the latest version:**

```sh
$ docker pull jestefane/php-dev
```

**Pull a specific version:**

```sh
$ docker pull jestefane/php-dev:7.2-cli-1.1.0
```

> The image name target has the following format:
>
> `<docker repo>:<php version>-<php variant>-<github repo version>`

## Usage

### PHP-CLI

```bash
docker run --rm -it
    -w=/app \
    -v /path/to/project:/app \
    jestefane/php-dev:7.2-cli-110.0
```

For example:

```shell
docker run --rm -it -w=/app -v $(pwd):/app jestefane/php-dev:7.2-cli-1.1.0 hello-world.php
```

### Composer

```shell
docker run --rm -it \
    -w=/app \
    -v /path/to/project:/app \
    -v ~/.ssh:/root/.ssh \
    -v $HOME/.composer-docker:/root/.composer \
    jestefane/php-dev:7.2-cli-1.1.0 composer
```

For example:

```shell
docker run --rm -it \
    -w=/app \
    -v "$(pwd)":/app \
    -v ~/.ssh:/root/.ssh \
    -v "$HOME/.composer-docker":/root/.composer \
    jestefane/php-dev:7.2-cli-1.1.0 composer install
```

## Scripts

So you don't have to type the full docker run commands, you can generate shell scripts that alias th

```shell
make install_scripts   # adds symlinks in /usr/local/bin
```

> The default is to create symlinks of the scripts inside `/usr/local/bin`. If you'd like to override that, run `make install_scripts BIN_DIR=/dir/of/your/choice`

## Building Images Locally

```shell
$ make build
```



## Rebuilding Scripts from Templates

```shell
make scripts
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