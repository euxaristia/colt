CC = cc
SOURCES = main.pony editor.pony buffer.pony
TARGET = Colt

.PHONY: all clean install run

all: $(TARGET)

$(TARGET): $(SOURCES)
	ponyc -o . --linker=$(CC)

clean:
	rm -f $(TARGET) $(TARGET).o

install: $(TARGET)
	install -m 755 $(TARGET) ~/.local/bin/

run: $(TARGET)
	./$(TARGET)
