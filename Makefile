MDS := $(wildcard src/*.md src/*/*.md)
HTMLS := $(MDS:.md=.html)
PUBLISH_DIR := ../published/ # ul.elvish.io:elvish.io/published

default: gen

%.html: %.md # tools/highlighter tools/ttyshot
	./tools/md-to-html $< $@

%: %.go
	go build -o $@ $<

gen: $(HTMLS)
	genblog src dst

genblog:
	cd $(GOPATH)/src/github.com/xiaq/genblog; \
		git pull; \
		go generate; \
		go get
	genblog -print-default-css > assets/genblog.css

publish: gen
	rsync -aLv --delete ./dst/ $(PUBLISH_DIR)

clean:
	rm $(HTMLS)

.PHONY: default gen genblog publish clean
