#lang racket

(require threading)
(require racket/set)

(define (no-duplicates xs)
  (= (set-count (list->set xs)) (length xs)))

(define (is-marker xs)
  (and (> (length xs) 3)
       (no-duplicates xs)))

(define (string->signals s)
  (map (λ~> string string->symbol)
       (string->list s)))

(define (find-unique-index-helper xs n i)
  (if (and (> (length xs) n)
           (no-duplicates (take xs n)))
    (+ n i)
    (find-unique-index-helper (cdr xs) n (add1 i))))

(define (find-unique-index s n)
  (let ([xs (string->signals s)])
    (find-unique-index-helper xs n 0)))

(define (find-marker-index s)
  (find-unique-index s 4))

(define (find-message-index s)
  (find-unique-index s 14))

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
    [check-equal? (find-marker-index "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") 10]
    [check-equal? (find-marker-index "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") 11])

  (test-case "find-message-index"
    [check-equal? (find-message-index "mjqjpqmgbljsphdztnvjfqwrcgsmlb") 19]
    [check-equal? (find-message-index "bvwbjplbgvbhsrlpgdmjqwftvncz") 23]
    [check-equal? (find-message-index "nppdvjthqldpwncqszvftbrmjlhg") 23]
    [check-equal? (find-message-index "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") 29]
    [check-equal? (find-message-index "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") 26]))

(module+ main
  (time (let ([exercise-data (read-exercise-data)])
    (println (find-marker-index exercise-data))
    (println (find-message-index exercise-data)))))
