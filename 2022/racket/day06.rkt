#lang racket

(require threading)
(require racket/set)

(define (is-marker xs)
  (and (> (length xs) 3)
       (= (set-count (list->set xs)) 4)))

(define (string->signals s)
  (map (λ~> string string->symbol)
       (string->list s)))

(define (find-marker-index-helper xs i)
  (if (is-marker (take xs 4))
    (+ 4 i)
    (find-marker-index-helper (cdr xs) (add1 i))))

(define (find-marker-index s)
  (let ([xs (string->signals s)])
    (find-marker-index-helper xs 0)))

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)
      (string-split "\n")
      (first)))

(module+ test
  (require rackunit)

  (test-case "is-marker"
    [check-false (is-marker '(m j q))]
    [check-false (is-marker '(m j q j))]
    [check-true  (is-marker '(j p q m))])

  (test-case "find-marker-index"
    [check-equal? (find-marker-index "mjqjpqmgbljsphdztnvjfqwrcgsmlb") 7]
    [check-equal? (find-marker-index "bvwbjplbgvbhsrlpgdmjqwftvncz") 5]
    [check-equal? (find-marker-index "nppdvjthqldpwncqszvftbrmjlhg") 6]
    [check-equal? (find-marker-index "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") 11]))

(module+ main
  (let ([exercise-data (read-exercise-data)])
    (println (find-marker-index exercise-data))))
