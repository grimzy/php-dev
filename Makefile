# SOURCE_BRANCH
SOURCE_BRANCH=1.1.0

# DOCKER_REPO and DOCKER_TAG:
# https://docs.docker.com/docker-hub/builds/advanced/#custom-build-phase-hooks
DOCKER_REPO=jestefane/php-dev
DOCKER_TAG=

# Possible versions: 5.5 5.6 7.0 7.1 7.2
PHP_VERSIONS=5.5 5.6 7.0 7.1 7.2

# Possible VARIANT: cli, fpm, apache, alpine
PHP_VARIANTS=cli

BIN_DIR=/usr/local/bin
SCRIPTS_DIR=scripts

.PHONY: build
build:
	@PHP_VERSIONS="$(PHP_VERSIONS)" \
	PHP_VARIANTS="$(PHP_VARIANTS)" \
	SOURCE_BRANCH="$(SOURCE_BRANCH)" \
	DOCKER_REPO="$(DOCKER_REPO)" \
	DOCKER_TAG="$(DOCKER_TAG)" \
	./build/hooks/build

.PHONY: post_push
post_push:
	@PHP_VERSIONS="$(PHP_VERSIONS)" \
	PHP_VARIANTS="$(PHP_VARIANTS)" \
	SOURCE_BRANCH="$(SOURCE_BRANCH)" \
	DOCKER_REPO="$(DOCKER_REPO)" \
	DOCKER_TAG="$(DOCKER_TAG)" \
	./build/hooks/post_push

.PHONY: rm_build
rm_build:
	@{ \
	for php_version in $(PHP_VERSIONS); do \
		for php_variant in $(PHP_VARIANTS); do \
			image_name=$(DOCKER_REPO):$$php_version-$$php_variant-$(SOURCE_BRANCH); \
			echo Removing image: $$image_name; \
			docker rmi $$image_name || true; \
		done; \
	done; \
	}

.PHONY: rebuild
rebuild: rm_build build

.PHONY: scripts
scripts: rm_scripts_dir
	@{ \
	for php_version in $(PHP_VERSIONS); do \
		echo "Generating scripts for PHP VERSION: $$php_version"; \
		for php_variant in $(PHP_VARIANTS); do \
			regex=s!%%PHP_VERSION%%!$$php_version!g\;s!%%PHP_VARIANT%%!$$php_variant!g\;s!%%SOURCE_BRANCH%%!$(SOURCE_BRANCH)!g; \
			mkdir -p $(SCRIPTS_DIR); \
			echo ">>> Script: PHP $$php_version-$$php_variant"; \
			sed $$regex template/php.template > $(SCRIPTS_DIR)/php-$$php_version-$$php_variant; \
		done; \
		echo ">>> Script Composer $$php_version"; \
		sed $$regex template/composer.template > $(SCRIPTS_DIR)/composer-$$php_version; \
	done; \
	}

.PHONY: rm_scripts_dir
rm_scripts_dir:
	@echo Deleting previously generated scripts directory
	@rm -Rf $(SCRIPTS_DIR)

.PHONY: shortcuts
shortcuts: scripts
	@chmod +x $(SCRIPTS_DIR)/*
	@cd $(SCRIPTS_DIR)
	@$(eval DIR := ${CURDIR}/$(SCRIPTS_DIR))
	@ln -s $(DIR)/* $(BIN_DIR) || true
	@echo Symlink scripts from $(DIR) into $(BIN_DIR)

.PHONY: rm_shortcuts
rm_shortcuts:
	@{ \
	for php_version in $(PHP_VERSIONS); do \
		echo "Uninstalling scripts from $(BIN_DIR) for PHP VERSION $$php_version"; \
		for php_variant in $(PHP_VARIANTS); do \
			echo ">>> Uninstalled script: PHP $$php_version-$$php_variant"; \
			rm $(BIN_DIR)/php-$$php_version-$$php_variant || true; \
		done; \
		echo ">>> Uninstalled script: Composer $$php_version from $(BIN_DIR)"; \
		rm $(BIN_DIR)/composer-$$php_version || true; \
	done; \
	}

.PHONY: rm_dangling
rm_dangling:
	@echo Removing dangling volumes
	@docker volume ls -qf dangling=true | xargs docker volume rm
	@echo Removing dangling images
	@docker images -qf dangling=true | xargs docker rmi

#TODO: aliasing shortcuts to get the defaults php php-fpm and composer
