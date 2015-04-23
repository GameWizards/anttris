GODOT_HEADLESS=bin/linux_server -path src -v
LINUX_OUTPUT=Anttris.bin
WINDOWS_OUTPUT=Anttris.exe

all: test

test:
	$(GODOT_HEADLESS) test.scn | python gut_check_failure.py

export: export_linux export_windows

export_linux:
	mkdir -p bin
	$(GODOT_HEADLESS) -export "Linux X11" ../bin/$(LINUX_OUTPUT)

export_windows:
	mkdir -p bin
	$(GODOT_HEADLESS) -export "Windows Desktop" ../bin/$(WINDOWS_OUTPUT)

clean:
	rm -rf bin
	mkdir -p bin
