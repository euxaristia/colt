CC = cc
SOURCES = main.pony editor.pony buffer.pony syntax.pony
TARGET = colt
TEST_SOURCES = tests/tests.pony tests/buffer.pony tests/syntax.pony
TEST_TARGET = colt-tests

.PHONY: all clean install run test

all: $(TARGET)

$(TARGET): $(SOURCES)
	ponyc -o . --linker=$(CC)

$(TEST_TARGET): $(TEST_SOURCES)
	cd tests && ponyc -o . --linker=$(CC)

clean:
	rm -f $(TARGET) $(TARGET).o tests/$(TEST_TARGET) tests/$(TEST_TARGET).o

install: $(TARGET)
	install -m 755 $(TARGET) ~/.local/bin/

uninstall:
	rm -f ~/.local/bin/$(TARGET)

run: $(TARGET)
	./$(TARGET)

test: $(TEST_TARGET)
	./tests/tests
