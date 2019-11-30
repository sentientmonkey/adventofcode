#lang racket

(require threading)

(define (parse-coordinates str)
  (~> str
      (string-split _ "\n")
      (map (λ (x) (string-split x ",")) _)
      (map (λ (x) (map string->number x)) _)))

(module+ test
  (require rackunit)

  (define test-coords #<<eos
1,1
1,6
8,3
3,4
5,5
8,9
eos
)

  (test-case "parses coordinates"
    (check-equal? (parse-coordinates test-coords)
                  '((1 1) (1 6) (8 3) (3 4) (5 5) (8 9)) )))
