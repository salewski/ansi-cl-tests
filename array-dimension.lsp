;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Tue Jan 21 06:55:14 2003
;;;; Contains: Tests of ARRAY-DIMENSION

(in-package :cl-test)

;;; array-dimension is also tested by the tests in make-array.lsp

(deftest array-dimension.1
  (array-dimension #(0 1 2 3) 0)
  4)

(deftest array-dimension.2
  (array-dimension "abcdef" 0)
  6)

(deftest array-dimension.3
  (array-dimension #2a((1 2 3 4)(5 6 7 8)) 0)
  2)

(deftest array-dimension.4
  (array-dimension #2a((1 2 3 4)(5 6 7 8)) 1)
  4)

(deftest array-dimension.5
  (let ((a (make-array '(10) :fill-pointer 5)))
    (array-dimension a 0))
  10)

(deftest array-dimension.6
  (let ((a (make-array '(10) :adjustable t)))
    (values
     (array-dimension a 0)
     (progn
       (adjust-array a '(20))
       (array-dimension a 0))))
  10 20)

;;; Error tests

(deftest array-dimension.error.1
  (classify-error (array-dimension))
  program-error)

(deftest array-dimension.error.2
  (classify-error (array-dimension #(a b c)))
  program-error)

(deftest array-dimension.error.3
  (classify-error (array-dimension #(a b c) 0 nil))
  program-error)



