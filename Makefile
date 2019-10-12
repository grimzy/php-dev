# SOURCE_BRANCH
SOURCE_BRANCH=1.1.0

# Possible versions: 5.5 5.6 7.0 7.1 7.2
PHP_VERSIONS=5.5 5.6 7.0 7.1 7.2

# Possible VARIANT: cli, fpm, apache, alpine
PHP_VARIANTS=cli

BIN_DIR=/usr/local/bin

SCRIPTS_DIR=scripts

.PHONY: build
build:
	@{ \
	for php_version in $(PHP_VERSIONS); do \
		xdebug_version=; \
		if [ $$php_version == "5.5" ] || [ $$php_version == "5.6" ]; then \
			xdebug_version=-2.5.5; \
		fi; \
		for php_variant in $(PHP_VARIANTS); do \
			image_name=jestefane/php-dev:$$php_version-$$php_variant-$(SOURCE_BRANCH); \
			echo Building image: $$image_name; \
			docker build \
				-t $$image_name \
				--build-arg BUILD_PHP_VERSION=$$php_version \
			 	--build-arg BUILD_PHP_VARIANT=$$php_variant \
			 	--build-arg BUILD_XDEBUG_VERSION=$$xdebug_version build; \
		done; \
	done; \
	}

.PHONY: rm_build
rm_build:
	@{ \
	for php_version in $(PHP_VERSIONS); do \
		for php_variant in $(PHP_VARIANTS); do \
			image_name=jestefane/php-dev:$$php_version-$$php_variant-$(SOURCE_BRANCH); \
			echo Removing image: $$image_name; \
			docker rmi $$image_name || true; \
		done; \
	done; \
	}

.PHONY: rebuild
rebuild: rm_build build

.PHONY: scripts
scripts: rm_scripts
	@{ \
	for php_version in $(PHP_VERSIONS); do \
		echo "Generating scripts for PHP VERSION: $$php_version"; \
		for php_variant in $(PHP_VARIANTS); do \
			regex=s!%%PHP_VERSION%%!$$php_version!g\;s!%%SOURCE_BRANCH%%!$(SOURCE_BRANCH)!g; \
			mkdir -p $(SCRIPTS_DIR); \
			echo ">>> Script: PHP $$php_version-$$php_variant"; \
			sed $$regex template/php-cli.template > $(SCRIPTS_DIR)/php-$$php_version-$$php_variant; \
		done; \
		echo ">>> Script Composer $$php_version"; \
		sed $$regex template/composer.template > $(SCRIPTS_DIR)/composer-$$php_version; \
	done; \
	}

.PHONY: rm_scripts
rm_scripts:
	@echo Deleting previously generated scripts directory
	@rm -Rf $(SCRIPTS_DIR)

.PHONY: install_scripts
install_scripts:
	@chmod +x $(SCRIPTS_DIR)/*
	@cd $(SCRIPTS_DIR)
	@$(eval DIR := ${CURDIR}/$(SCRIPTS_DIR))
	@ln -s $(DIR)/* $(BIN_DIR) || true
	@echo Symlink scripts from $(DIR) into $(BIN_DIR)

.PHONY: uninstall_scripts
uninstall_scripts:
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
