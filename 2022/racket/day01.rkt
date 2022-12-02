#lang racket

(require threading)

(define (sum xs)
  (foldl + 0 xs))

(define (max-calories lst)
  (for/fold ([acc 0])
            ([xs lst])
    (max acc (sum xs))))

(define (top-calories n xs) 
  (~> (map sum xs)
      (sort >)
      (take n)
      (sum)))

(module+ test
  (require rackunit)
  (define test-input '((2000 3000) (4000)))

  (test-case "max calories"
    [check-equal? (max-calories test-input) 5000])

  (test-case "top calories"
    [check-equal? (top-calories 2 '((1) (2) (3))) 5]))

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
    (println (max-calories exercise-data))
    (println (top-calories 3 exercise-data))))
