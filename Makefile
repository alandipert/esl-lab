ESLC       := node_modules/eslisp/bin/eslc
TRANSFORMS := -t eslisp-depends -t eslisp-propertify
JS_TARGETS := $(shell sbcl --script script/scan.lisp --targets main.esl)

all: main.js

$(foreach js,$(JS_TARGETS),\
	$(eval $(shell sbcl --script script/scan.lisp --rule $(js))))

%.js: %.esl
	$(ESLC) $(TRANSFORMS) $< > $@ || mv $@ $@.err

clean:
	rm -f *.js

print-%:
	@echo '$*=$($*)'

.PHONY: clean .print-%
