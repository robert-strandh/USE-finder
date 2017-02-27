(cl:in-package #:use-finder)

(defclass stream ()
  ((%underlying-stream :initarg :underlying-stream
                       :reader underlying-stream)
   (%line-number :initform 1 :accessor line-number)
   (%column-number :initform 1 :accessor column-number)
   (%previous-column-number :initform 1 :accessor previous-column-number)))

(defmethod trivial-gray-streams:stream-read-char
    ((stream stream))
  (let ((result (read-char (underlying-stream stream) nil :eof)))
    (if (eql result #\Newline)
        (progn (setf (previous-column-number stream)
                     (column-number stream))
               (setf (column-number stream) 0)
               (incf (line-number stream)))
        (incf (column-number stream)))
    result))

(defmethod trivial-gray-streams:stream-unread-char
    ((stream stream) character)
  (if (zerop (column-number stream))
      (progn (decf (line-number stream))
             (setf (column-number stream)
                   (previous-column-number stream)))
      (decf (column-number stream)))
  (unread-char character (underlying-stream stream)))

(defmacro with-open-stream ((stream filespec) &body body)
  `(with-open-file (,stream ,filespec :direction :input)
     (let ((,stream (make-instance 'stream :underlying-stream ,stream)))
       ,@body)))
