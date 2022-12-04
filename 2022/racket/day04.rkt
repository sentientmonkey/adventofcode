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

(module+ test
  (require rackunit)

  (test-case "parse-pairs"
    [check-equal? (parse-pairs '("2-4,6-8"))
                  '(((2 4) (6 8)))])

  (test-case "cleaning-covers"
    [check-false (cleaning-covers '((2 4) (6 8)))]
    [check-false (cleaning-covers '((2 3) (4 5)))]
    [check-true  (cleaning-covers '((2 8) (3 7)))]
    [check-true  (cleaning-covers '((6 6) (4 6)))]
    [check-false (cleaning-covers '((2 6) (4 8)))])

  (test-case "cleaning-cover-count"
    [check-equal?
      (cleaning-cover-count
       '(((2 4) (6 8))
         ((2 3) (4 5))
         ((2 8) (3 7))
         ((6 6) (4 6))                 
         ((2 6) (4 8)))) 2]))

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)
      (string-split "\n")
      (parse-pairs)))

(module+ main
  (let ([exercise-data (read-exercise-data)])
    (println (cleaning-cover-count exercise-data))))
    
