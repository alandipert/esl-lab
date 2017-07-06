# Experiments with [es-lisp](https://github.com/anko/eslisp)

es-lisp is a Lisp syntax and compiler for ES5. It supports full Lisp-style,
but compile-time, macros. It does not include additional runtime beyond that provided
by the JavaScript environment.

It currently lacks constructs to support some ES6 syntax such as destructuring.
Similar functionality would need to be added with a macro using the available
syntax.

## Macro dependencies

Macros are included in `.esl` files with expressions like `(macro someMacro
"./someMacro.js")`. Then, `(someMacro...)` is available in the file. This usage
implies that `someMacro.esl` has already been compiled into `someMacro.js`, but
the es-lisp compiler, `eslc`, doesn't do that automatically.

To solve the problem without two steps in my `Makefile`, I developed a
convention to declare dependencies on macro files in an `.esl` file.

I add a form like `(depends "someMacro.esl")` to the top of the `.esl` files.
Files without any macro dependencies contain `(depends)` at the top.

Then I have a Common Lisp script, `script/scan.lisp`, that reads the `depends`
form from the top of all the files, and prints the files in dependency order.

This script is called from the `Makefile` and the line of file names it prints
out is used as the target list.

Finally, I use the `-t` option of `eslc` to define a global transformation,
`eslisp-depends`, that strips the `(depends)` form before processing further.

## Building

First:

    yarn
    
Then:

    make
    
Finally:

    node hello.js
