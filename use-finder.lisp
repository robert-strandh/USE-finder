(cl:in-package #:use-finder)

(defun use-finder (input-filespec output-filespec)
  (with-open-stream (input-stream input-filespec)
    (with-open-file (output-stream output-filespec
                                   :direction :output
                                   :if-does-not-exist :create
                                   :if-exists :supersede)
      (format output-stream
              "-*- mode: compilation; default-directory: \"~a\" -*-~%~%"
              (directory-namestring (first (directory "."))))
      (let ((*package* *package*)
            (*output-stream* output-stream)
            (*input-filename* input-filespec))
        (loop for expression = (sicl-reader:read input-stream nil nil nil)
              when (null expression)
                return nil
              when (and (consp expression)
                        (eq (first expression) 'cl:in-package))
                do (setf *package* (find-package (second expression))))))))
