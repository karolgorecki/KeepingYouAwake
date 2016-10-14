SCHEME = KeepingYouAwake
PROJECT = KeepingYouAwake.xcodeproj
RELEASE = RELEASE

OUTPUT_DIR = $(shell pwd)/dist

dist:
	rm -rf $(OUTPUT_DIR)
	fastlane gym \
	--clean \
	--silent \
	--project $(PROJECT) \
	--scheme $(SCHEME) \
	--export_method developer-id \
	--output_directory $(OUTPUT_DIR) \
	--buildlog_path $(OUTPUT_DIR) \
	--archive_path $(OUTPUT_DIR)/$(SCHEME).xcarchive
	spctl -a -v $(OUTPUT_DIR)/$(SCHEME).app
	ditto -c -k --sequesterRsrc --keepParent $(OUTPUT_DIR)/$(SCHEME).app $(OUTPUT_DIR)/$(SCHEME)-$(RELEASE).zip

clangformat:
	$(info Reformatting source files with clang-format...)
	clang-format -style=file -i $(shell pwd)/**/*.{h,m}

clean:
	rm -rf build
	rm -rf $(OUTPUT_DIR)

.PHONY: dist clang-format clean
