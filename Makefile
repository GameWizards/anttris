GODOT_HEADLESS=bin/linux_server
LINUX_OUTPUT=Anttris.bin
WINDOWS_OUTPUT=Anttris.exe

all: test

test:
	$(GODOT_HEADLESS) -v -path src src/test.scn

export: export_linux export_windows

export_linux:
	mkdir -p bin
	$(GODOT_HEADLESS) -path src -export "Linux X11" ../bin/$(LINUX_OUTPUT)

export_windows:
	mkdir -p bin
	$(GODOT_HEADLESS) -path src -export "Windows Desktop" ../bin/$(WINDOWS_OUTPUT)

clean:
	rm -rf bin
	mkdir -p bin
