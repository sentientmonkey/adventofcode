#lang racket

(require threading)

(define (sum xs)
  (foldl + 0 xs))

(define (max-calories xs)
  (foldl max 0 (map sum xs)))

(module+ test
  (require rackunit)
  (define test-input '((2000 3000) (4000)))

  (test-case "max calories"
    [check-equal? (max-calories test-input) 5000]))

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)
      (string-split "\n\n") 
      (map string-split _)
      (map (λ (n)
              (map string->number n)) _)))

(module+ main
  (let ([exercise-data (read-exercise-data)])
    (println (max-calories exercise-data))))
