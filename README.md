# Company-sclang #

Company-sclang is a [company-mode](http://company-mode.github.io/)
completion backend for `SCLang`.

## Installation ##

Add `company-sclang` to the `load-path`:

```lisp
(add-to-list 'load-path "path/to/company-sclang")
```

Add the following to your `init.el`:

```lisp
(require 'company)
(add-to-list 'company-backends 'company-sclang)
```

or if you only want to use `company-sclang` as backend:

```lisp
(add-hook 'sclang-mode-hook #'(lambda ()
                                (set (make-local-variable 'company-backends) '(company-sclang)')))
```
