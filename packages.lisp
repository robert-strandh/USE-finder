(cl:in-package #:common-lisp-user)

(defpackage :use-finder
  (:use #:common-lisp)
  (:shadow #:stream
           #:with-open-stream))
