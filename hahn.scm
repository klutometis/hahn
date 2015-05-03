(module hahn
  (at run-hahn)
  (import chicken scheme)

  (define-syntax run-hahn
    (ir-macro-transformer
     (lambda (expression rename inject)
       `(handle-exceptions exn
          (warning (format "Documentation not generated: ~a

This may be because hahn-utils is not installed. Hahn-utils is an
optional egg for generating documentation and installation will
succeed without it."
                           ((condition-property-accessor 'exn 'message) exn)))
          (run (hahn ,@(cdr expression)))))))

  ;; This is a hack to provide unescaped @s.
  (define at '@)

  (define (prepend-@ symbol)
    (string->symbol
     (string-append "@" (symbol->string symbol))))

  (set-read-syntax! #\@
    (lambda (in)
      (let ((expression (read in)))
        (cond ((pair? expression)
               (values))
              ((symbol? expression)
               (prepend-@ expression))
              (else expression))))))
