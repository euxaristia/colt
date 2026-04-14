CC = cc
SOURCES = src/main.pony src/editor.pony src/buffer.pony src/syntax.pony src/regex.pony
TARGET = colt
TEST_SOURCES = tests/tests.pony tests/buffer.pony tests/syntax.pony
TEST_TARGET = colt-tests

.PHONY: all clean install run test

all: $(TARGET)

$(TARGET): $(SOURCES)
	cd src && ponyc -o .. -b $(TARGET) --linker=$(CC)

$(TEST_TARGET): $(TEST_SOURCES)
	cd tests && ponyc -o . --linker=$(CC)

clean:
	rm -f $(TARGET) tests/$(TEST_TARGET)
	rm -f colt.o tests/$(TEST_TARGET).o

install: $(TARGET)
	@if [ -f ~/.local/bin/$(TARGET) ] && [ "$$(sha256sum $(TARGET) | cut -d' ' -f1)" = "$$(sha256sum ~/.local/bin/$(TARGET) | cut -d' ' -f1)" ]; then \
		echo "$(TARGET) is already installed and up to date."; \
	else \
		install -m 755 $(TARGET) ~/.local/bin/; \
		echo "$(TARGET) installed to ~/.local/bin/"; \
	fi

uninstall:
	rm -f ~/.local/bin/$(TARGET)

run: $(TARGET)
	./$(TARGET)

test: $(TEST_TARGET)
	./tests/tests
