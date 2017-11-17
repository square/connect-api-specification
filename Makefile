TEMPLATES=swagger-templates/%
# Remove directory name prefix to produce list of languages
LANGUAGES=$(TEMPLATES:swagger-templates/%=%)
OUTPUT=swagger-out

# Generate SDKs for all languages
all:
	./generate-sdks

# Or, generate an SDK for just a single language
# e.g. `make python`, `make ruby`, etc.
$(LANGUAGES):
	rm -rf $(OUTPUT)/$@
	./generate-sdks $@

clean:
	rm -rf $(OUTPUT)
