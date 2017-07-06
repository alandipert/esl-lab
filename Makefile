ESLC       := node_modules/eslisp/bin/eslc
TRANSFORMS := -t eslisp-depends -t eslisp-propertify
ESL        := $(shell sbcl --script script/scan.lisp $(CURDIR))
JS         := $(patsubst %.esl, %.js, $(ESL))

all: $(JS)

%.js: %.esl
	$(ESLC) $(TRANSFORMS) $< > $@ || rm -f $@

clean:
	rm -f *.js

print-%:
	@echo '$*=$($*)'
