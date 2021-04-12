PHONY: test install run
SILENT: test install run

test:
	rspec

install:
	gem install bundler && bundle

exp ?= * * * * *
cmd ?= echo example
run:
	./parser '$(exp) $(cmd)'
