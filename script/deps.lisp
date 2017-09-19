(defun get-depends (path)
  (with-open-file (f path)
    (let* ((name (format nil "~A.~A"
                         (pathname-name f)
                         (pathname-type f)))
           (dependencies (cdr (read f))))
      (cons name dependencies))))

(defun main (esl-file)
  (let* ((deps (cdr (get-depends esl-file))))
    (format t "~{~a~^ ~}~%" deps)))

(main (cadr sb-ext:*posix-argv*))
