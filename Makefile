all: sdk

sdk:
	./generate-sdks

clean:
	rm -rf swagger-out
