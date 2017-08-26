VERSION=1.0.0
VERSIONS=5.5 5.6 7.0 7.1
GENERATED_DIR=generated
BUILDS_DIR=$(GENERATED_DIR)/builds
BINS_DIR=$(GENERATED_DIR)/bins
BIN_DIR=/usr/local/bin

builds: templates
	@{ \
	for version in $(VERSIONS); \
	do \
		cli=jestefane/php-dev:$$version-cli-$(VERSION); \
		echo Building $$cli; \
		docker build -t $$cli $(BUILDS_DIR)/$$version; \
	done; \
	}

rm_images:
	@{ \
	for version in $(VERSIONS); \
	do \
		cli=jestefane/php-dev:$$version-cli-$(VERSION); \
		docker rmi $$cli || true; \
	done; \
	}

rebuild: rm_images builds

templates: rm_templates
	@{ \
	for version in $(VERSIONS); \
	do \
		echo Building for PHP $$version; \
		regex=s!%%PHP_VERSION%%!$$version!g\;s!%%IMAGE_VERSION%%!$(VERSION)!g; \
		version_dir=$(BUILDS_DIR)/$$version; \
		mkdir -p $$version_dir-cli; \
		sed $$regex template/Dockerfile-cli.template > $$version_dir-cli/Dockerfile; \
		cp template/php.ini $$version_dir-cli; \
		echo ... Dockerfile; \
		mkdir -p $(BINS_DIR); \
		sed $$regex template/php-cli.template > $(BINS_DIR)/php-cli-$$version; \
		echo ... php-cli bin; \
		sed $$regex template/composer.template > $(BINS_DIR)/composer-$$version; \
		echo ... composer bin; \
	done; \
	}

rm_templates:
	@echo Deleting generated templates
	@rm -Rf $(GENERATED_DIR)

cp_bins:
	@chmod +x $(BINS_DIR)/*
	@cp $(BINS_DIR)/* $(BIN_DIR)
	@echo Copied bins into $(BIN_DIR)
