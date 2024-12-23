#lang racket

(require threading)
(require racket/set)

(define (parse-pairs lst)
  (map (λ (l)
          (map (λ (p)
                  (map string->number
                       (string-split p "-")))
               (string-split l ",")))
       lst))

(define (pair->set p)
  (list->set
    (inclusive-range (car p) (cadr p))))

(define (cleaning-covers p)
  (let ([a (pair->set (first p))]
        [b (pair->set (second p))])
    (or (set=? (set-intersect a b) a)
        (set=? (set-intersect b a) b))))

(define (cleaning-cover-count lst)
  (for/sum ([p lst])
    (if (cleaning-covers p) 1 0)))

(define (cleaning-overlaps p)
  (let ([a (pair->set (first p))]
        [b (pair->set (second p))])
    (not (set-empty? (set-intersect a b)))))

(define (cleaning-overlap-count lst)
  (for/sum ([p lst])
    (if (cleaning-overlaps p) 1 0)))

(module+ test
  (require rackunit)
  (define cleaning-list
    '(((2 4) (6 8))
         ((2 3) (4 5))
         ((5 7) (7 9))
         ((2 8) (3 7))
         ((6 6) (4 6))
         ((2 6) (4 8))))


  (test-case "parse-pairs"
    [check-equal? (parse-pairs '("2-4,6-8"))
                  '(((2 4) (6 8)))])

  (test-case "cleaning-covers"
    [check-false (cleaning-covers '((2 4) (6 8)))]
    [check-false (cleaning-covers '((2 3) (4 5)))]
    [check-false (cleaning-covers '((5 7) (7 9)))]
    [check-true  (cleaning-covers '((2 8) (3 7)))]
    [check-true  (cleaning-covers '((6 6) (4 6)))]
    [check-false (cleaning-covers '((2 6) (4 8)))])

  (test-case "cleaning-cover-count"
    [check-equal? (cleaning-cover-count cleaning-list) 2])

  (test-case "cleaning-overlaps"
    [check-false (cleaning-overlaps '((2 4) (6 8)))]
    [check-false (cleaning-overlaps '((2 3) (4 5)))]
    [check-true  (cleaning-overlaps '((5 7) (7 9)))]
    [check-true  (cleaning-overlaps '((2 8) (3 7)))]
    [check-true  (cleaning-overlaps '((6 6) (4 6)))]
    [check-true  (cleaning-overlaps '((2 6) (4 8)))])


  (test-case "cleaning-overlap-count"
    [check-equal? (cleaning-overlap-count cleaning-list) 4]))

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)
      (string-split "\n")
      (parse-pairs)))

(module+ main
  (let ([exercise-data (read-exercise-data)])
    (println (cleaning-cover-count exercise-data))
    (println (cleaning-overlap-count exercise-data))))

