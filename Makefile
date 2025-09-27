# frozen_string_literal: true

TAG ?= main
BUILD_DIR := build
SRC_DIR := $(BUILD_DIR)/ondemand-loop

.PHONY: all version release_notes dev_up update loop_build clean

all:: version

version:
	./scripts/version.sh $(VERSION_TYPE)

release_notes:
	./scripts/release_notes.sh

dev_up: $(SRC_DIR) loop_build copy_config loop_up

# Clone the repository only if the target directory does not exist.
# This makes the rule idempotent: running `make` again will do nothing
# as long as $(SRC_DIR) already exists. To fetch new commits, use `make update`.
$(SRC_DIR):
	mkdir -p $(BUILD_DIR)
	git clone https://github.com/IQSS/ondemand-loop.git $(SRC_DIR)
	cd $(SRC_DIR) && git checkout $(TAG)

update:
	cd $(SRC_DIR) && git fetch && git checkout $(TAG) && git pull

loop_build:
	cd $(SRC_DIR) && make loop_build

copy_config:
	cp -R config/fasrc/. $(SRC_DIR)/application

loop_up:
	cd $(SRC_DIR) && make loop_up

clean:
	rm -rf ./build

