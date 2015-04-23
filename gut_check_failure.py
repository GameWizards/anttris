import sys
failed = True

for line in sys.stdin:
    sys.stdout.write(line)
    if "0 Failed" in line:
        failed = False

if failed:
    sys.exit(1)
else:
    sys.exit(0)
