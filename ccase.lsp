;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Fri Oct 18 21:06:45 2002
;;;; Contains: Tests of CCASE

(in-package :cl-test)

(deftest ccase.1
  (let ((x 'b))
    (ccase x (a 1) (b 2) (c 3)))
  2)

(deftest ccase.2
  (classify-error 
   (let ((x 1)) (ccase x)))
  type-error)

(deftest ccase.3
  (classify-error
   (let ((x 1))
     (ccase x (a 1) (b 2) (c 3))))
  type-error)

;;; It is legal to use T or OTHERWISE as key designators
;;; in CCASE forms.  They have no special meaning here.

(deftest ccase.4
  (classify-error
   (let ((x 1))
     (ccase x (t nil))))
  type-error)

(deftest ccase.5
  (classify-error
   (let ((x 1))
     (ccase x (otherwise nil))))
  type-error)

(deftest ccase.6
  (let ((x 'b))
    (ccase x ((a z) 1) ((y b w) 2) ((b c) 3)))
  2)

(deftest ccase.7
  (let ((x 'z))
    (ccase x
	   ((a b c) 1)
	   ((d e) 2)
	   ((f z g) 3)))
  3)

(deftest ccase.8
  (let ((x (1+ most-positive-fixnum)))
    (ccase x (#.(1+ most-positive-fixnum) 'a)))
  a)

(deftest ccase.9
  (classify-error
   (let (x)
     (ccase x (nil 'a))))
  type-error)

(deftest ccase.10
  (let (x)
    (ccase x ((nil) 'a)))
  a)

(deftest ccase.11
  (let ((x 'a))
    (ccase x (b 0) (a (values 1 2 3)) (c nil)))
  1 2 3)

(deftest ccase.12
  (classify-error
   (let ((x t))
     (ccase x (a 10))))
  type-error)

(deftest ccase.13
  (let ((x t))
    (ccase x ((t) 10) (t 20)))
  10)

(deftest ccase.14
  (let ((x (list 'a 'b)))
    (eval `(let ((y (quote ,x))) (ccase y ((,x) 1) (a 2)))))
  1)

(deftest ccase.15
  (classify-error
   (let ((x 'otherwise))
     (ccase x ((t) 10))))
  type-error)

(deftest ccase.16
  (classify-error
   (let ((x t))
     (ccase x ((otherwise) 10))))
  type-error)

(deftest ccase.17
  (classify-error
   (let ((x 'a))
     (ccase x (b 0) (c 1) (otherwise 2))))
  type-error)

(deftest ccase.19
  (classify-error
   (let ((x 'a))
     (ccase x (b 0) (c 1) ((t) 2))))
  type-error)

(deftest ccase.20
  (let ((x #\a))
    (ccase x
	   ((#\b #\c) 10)
	   ((#\d #\e #\A) 20)
	   (() 30)
	   ((#\z #\a #\y) 40)))
  40)

(deftest ccase.21 (let ((x 1)) (ccase x (1 (values)) (2 'a))))

(deftest ccase.23 (let ((x 1)) (ccase x (1 (values 'a 'b 'c))))
  a b c)

;;; Show that the key expression is evaluated only once.
(deftest ccase.25
  (let ((a (vector 'a 'b 'c 'd 'e))
	(i 1))
    (values
     (ccase (aref a (incf i))
       (a 1)
       (b 2)
       (c 3)
       (d 4))
     i))
  3 2)

;;; Repeated keys are allowed (all but the first are ignored)

(deftest ccase.26
  (let ((x 'b))
    (ccase x ((a b c) 10) (b 20)))
  10)

(deftest ccase.27
  (let ((x 'b))
    (ccase x (b 20) ((a b c) 10)))
  20)

(deftest ccase.28
  (let ((x 'b))
    (ccase x (b 20) (b 10) (d 0)))
  20)

;;; There are implicit progns

(deftest ccase.29
  (let ((x nil) (y 2))
    (values
     (ccase y
       (1 (setq x 'a) 'w)
       (2 (setq x 'b) 'y)
       (3 (setq x 'c) 'z))
     x))
  y b)

;;; Need to add tests for continuability of the error,
;;; and resetting of the place.
