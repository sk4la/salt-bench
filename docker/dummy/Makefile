TARGETS:=$(wildcard */)

.PHONY: all build scratch $(TARGETS)
.SILENT:

all: build

build push scratch: $(TARGETS)

$(TARGETS):
	$(MAKE) --directory $@ $(MAKECMDGOALS)
