;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Tue Jul 13 07:38:43 2004
;;;; Contains: Tests of SYMBOL-FUNCTION

(in-package :cl-test)

(deftest symbol-function.1
  (let ((sym (gensym))
	(f #'(lambda () (values 1 2 3))))
    (values
     (eqt (setf (symbol-function sym) f) f)
     (multiple-value-list (eval (list sym)))))
  t (1 2 3))

;;; Error cases

(deftest symbol-function.error.1
  (signals-error (symbol-function) program-error)
  t)

(deftest symbol-function.error.2
  (signals-error (symbol-function 'cons nil) program-error)
  t)

(deftest symbol-function.error.3
  (loop for x in *mini-universe*
	for form = `(signals-error (symbol-function ',x) type-error)
	unless (or (symbolp x) (eval form))
	collect x)
  nil)

(deftest symbol-function.error.4
  (loop for x in *mini-universe*
	for form = `(signals-error (setf (symbol-function ',x) #'identity)
				   type-error)
	unless (or (symbolp x) (eval form))
	collect x)
  nil)


(deftest symbol-function.error.5
  (let ((sym (gensym)))
    (eval `(signals-error (symbol-function ',sym) undefined-function)))
  t)

