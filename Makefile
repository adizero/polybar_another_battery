VERCMD  ?= git describe --long --tags 2> /dev/null
VERSION ?= $(shell $(VERCMD) || cat VERSION)
BINNAME ?= "polybar-ab"

PREFIX    ?= /usr/local
BINPREFIX ?= $(PREFIX)/bin

all: go.mod getdeps build strip install

go.mod:
	go mod init polybar-ab

getdeps:
	go get -u github.com/distatus/battery/cmd/battery

build:
	go build -ldflags "-X main.version=$(VERSION)" -o $$(pwd)/$(BINNAME)

altbuild:
	go build -ldflags "-X main.version=$(VERSION)" polybar_ab.go
	mv polybar_ab polybar-ab

install:
	install -D -m 755 -o root -g root $(BINNAME) $(DESTDIR)$(BINPREFIX)/$(BINNAME)

uninstall:
	rm -rf "$(DESTDIR)$(BINPREFIX)/$(BINNAME)"

strip:
	strip $(BINNAME)

clean:
	rm -rf $(BINNAME)
	rm -rf go.mod
