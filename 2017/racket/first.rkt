#lang racket/base
(require syntax/parse/define)
(provide for/fold/first)

(define-simple-macro (for/fold/first e ...)
  (let-values
    (([x _]
      (for/fold e ...))) x))


