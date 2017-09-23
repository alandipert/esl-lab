;; Run using sbcl --script scan.lisp

(defun add-ext (filename ext)
  "Appends the specified extension after removing the original."
  (concatenate 'string (pathname-name filename) "." ext))

(defun get-depends (esl-file)
  "Attempts to read a (depends ...) form from the top of esl-file and return a
list of the .esl dependencies. If the first form in the file is not a (depends
...) form, or if the form contains no dependencies, returns nil."
  (with-open-file (f esl-file)
    ;; ESL syntax differs from CL, so we suppress read errors here in case the
    ;; first form is something CL can't parse.
    (let* ((first-form (ignore-errors (read f))))
      (when (and (listp first-form) (eq 'depends (car first-form)))
        (cdr first-form)))))

(defun get-targets (esl-files &optional (targets ()))
  "Recursively expands a set of esl dependencies and returns the list of .js
file targets they represent."
  (if esl-files
      (get-targets (concatenate 'list (cdr esl-files) (get-depends (car esl-files)))
                   (append targets (list (add-ext (car esl-files) "js"))))
      targets))

(defun --targets (esl-file)
  "Prints on a single line the list of .js file targets given an initial entrypoint esl file."
  (format t "~{~A~^ ~}~%" (get-targets (list esl-file))))

(defun --rule (js-file)
  "Produces a makefile rule for the given js file target."
  (format t
          "~A: ~A ~{~A~^ ~}~%"
          js-file
          (add-ext js-file "esl")
          (mapcar (lambda (f) (add-ext f "js"))
                  (get-depends (add-ext js-file "esl")))))

(if (> (length sb-ext:*posix-argv*) 1)
  (destructuring-bind (op &rest args) (cdr sb-ext:*posix-argv*)
    (apply (find-symbol (string-upcase op)) args)))
