VERCMD  ?= git describe --long --tags 2> /dev/null
VERSION ?= $(shell $(VERCMD) || cat VERSION)
BINNAME ?= polybar-ab

PREFIX    ?= /usr/local
BINPREFIX ?= $(PREFIX)/bin

SOURCES := polybar_ab.go

all: init getdeps build strip install

init:
ifeq ($(wildcard go.mod),)
	go mod init polybar-ab
endif

getdeps:
	go get -u github.com/distatus/battery/cmd/battery

build: $(SOURCES)
	go build -ldflags "-X main.version=$(VERSION)" -o $(BINNAME) $^

altbuild: $(SOURCES)
	go build -ldflags "-X main.version=$(VERSION)" $^
	mv polybar_ab $(BINNAME)

install: $(BINNAME)
	install -D -m 755 -o root -g root $(BINNAME) $(DESTDIR)$(BINPREFIX)/$(BINNAME)

uninstall:
	rm -rf "$(DESTDIR)$(BINPREFIX)/$(BINNAME)"

strip: $(BINNAME)
	strip $(BINNAME)

clean:
	rm -rf $(BINNAME)
	rm -rf go.mod
	rm -rf go.sum
