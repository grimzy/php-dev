V=5.6
VERSION=1.0.0
IMAGE=jestefane/php-$(V)-cli:$(VERSION)

VERSIONS=5.5 5.6 7.0 7.1

build:
	@echo Building $(IMAGE)
	docker build -t $(IMAGE) $(V)

rm_image:
	docker rmi $(IMAGE) || true

rebuild: rm_image build


templates:
	{ \
	for version in $(VERSIONS); \
	do \
		regex=s!%%PHP_VERSION%%!$$version!g\;s!%%IMAGE_VERSION%%!$(VERSION)!g; \
		mkdir -p $$version; \
		cp php.ini $$version; \
		sed $$regex Dockerfile.template > $$version/Dockerfile; \
		sed $$regex composer.template > bins/composer-$$version; \
	done; \
	}

