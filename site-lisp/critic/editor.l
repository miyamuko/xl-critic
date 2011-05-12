; -*- mode: lisp; package: xl-critic; encoding: shift_jis -*-

;;; critic/editor.l
;;
;; Copyright (c) 2011 MIYAMUKO Katsuyuki.
;;
;; Permission is hereby granted, free of charge, to any person obtaining
;; a copy of this software and associated documentation files (the
;; "Software"), to deal in the Software without restriction, including
;; without limitation the rights to use, copy, modify, merge, publish,
;; distribute, sublicense, and/or sell copies of the Software, and to
;; permit persons to whom the Software is furnished to do so, subject to
;; the following conditions:
;;
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
;; LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
;; OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
;; WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

;;; Code:

(eval-when (:compile-toplevel :load-toplevel :execute)
  (require "critic/lisp-critic")
  )

(defpackage :xl-critic
  (:use  :lisp :editor :lisp-critic)
  )

(in-package :xl-critic)

(defun user::critique-defun-popup ()
  (interactive)
  (let ((result (critique-definition-string (current-defun))))
    (popup-string (if (string= "----------------------------------------------------------------------\n"
                               result)
                      "OK"
                    result)
                  (point))))

(defun user::critique-defun (&optional (arg nil f))
  (interactive "p")
  (let* ((form-str (current-defun))
         (form (read-from-string form-str))
         (output (create-critic-output-buffer)))
    (pop-to-buffer output -20)
    (with-output-to-buffer (output)
      (when f
        (format t "~A" form-str))
      (critique-definition form))
    (lisp-mode)
    (setf a 1)
    ))

(defun critique-definition-string (form-str)
  (let ((form (read-from-string form-str)))
    (with-output-to-string (out)
      (let ((*standard-output* out))
        (critique-definition form)))))

(defun create-critic-output-buffer ()
  (let ((b (get-buffer-create "*critic*")))
    (setup-temp-buffer b)
    (erase-buffer b)
    b))

(defun current-defun ()
  ;; eval-defun からコピペ
  (save-excursion
    (let ((opoint (point)))
      (end-of-defun)
      (let ((to (point))
            (from (progn
                    (beginning-of-defun)
                    (point))))
        (end-of-defun)
        (goto-char (if (< (point) opoint) opoint to))
        (buffer-substring from (point))))))


(provide "critic/editor")

;;; End
