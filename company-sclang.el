;;; company-sclang.el --- Company backend for SCLang  -*- lexical-binding: t; -*-

;; Copyright (C) 2014  Peter Vasil

;; Author: Peter Vasil <mail@petervasil.net>
;; Keywords: tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Company backend for sclang-mode.

;;; Code:

(eval-when-compile
  (require 'cl-lib)
  (require 'company)
  (require 'sclang))


(defgroup company-sclang nil
  "Completion back-end for SCLang."
  :group 'company)

(defcustom company-sclang-begin-after-member-access nil
  "When non-nil, automatic completion will start whenever the current
symbol is preceded by a \".\", ignoring `company-minimum-prefix-length'."
  :group 'company-sclang
  :type 'boolean)

(defun company-sclang--make-candidate (candidate predicate)
  (let ((text (car candidate))
        (meta (if (eq predicate 'sclang-class-name-p)
                  "Class" "Method")))
    (propertize text 'meta meta)))

(defun company-sclang--candidates (prefix)
  (let* ((table (sclang-get-symbol-completion-table))
         (predicate (if (sclang-class-name-p prefix)
                        'sclang-class-name-p
                      'sclang-method-name-p))
         (keywords (cl-remove-if-not
                    (lambda (assoc) (funcall predicate (car assoc)))
                    table))
         res)
    (dolist (item keywords)
      (when (string-prefix-p prefix (car item))
        (push (company-sclang--make-candidate item predicate) res)))
    res))

(defun company-sclang--meta (candidate)
  (format "%s: %s"
          (get-text-property 0 'meta candidate)
          (substring-no-properties candidate)))

(defun company-sclang--prefix ()
  "Returns the symbol to complete. Also, if point is on a dot,
triggers a completion immediately."
  (if company-sclang-begin-after-member-access
      (company-grab-symbol-cons "\\." 1)
    (company-grab-symbol)))

;;;###autoload
(defun company-sclang (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (case command
    (interactive (company-begin-backend 'company-sclang))
    (prefix (and (derived-mode-p 'sclang-mode)
                 (not (company-in-string-or-comment))
                 (or (company-sclang--prefix) 'stop)))
    (candidates (company-sclang--candidates arg))
    (meta (company-sclang--meta arg))))

(provide 'company-sclang)
;;; company-sclang.el ends here
