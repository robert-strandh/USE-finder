(cl:in-package #:asdf-user)

(defsystem use-finder
  :depends-on (:sicl-reader-simple :trivial-gray-streams)
  :serial t
  :components
  ((:file "packages")
   (:file "stream")
   (:file "reader-programming")
   (:file "use-finder")))
