#lang racket

(require threading)

(module+ test
  (require rackunit)
)

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)
      (string-split "\n")
      (map string->list _)
      (map (λ (l)
              (map (λ (c) (string->number (string c))) l)) _)))

(module+ main
  (let ([exercise-data (read-exercise-data)])
    (println exercise-data)))
