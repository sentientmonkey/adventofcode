#lang racket

(require threading)

;  For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
;  For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2.
;  For a mass of 1969, the fuel required is 654.
;  For a mass of 100756, the fuel required is 33583.

(define (fuel mass)
  (~> mass
      (quotient 3) 
      (- 2)))

(define (fuel-total masses)
  (for/sum ([mass masses])
    (fuel mass)))

(define (fuel-sums mass)
  (let loop ([mass mass] [lst '()])
    (let ([curr (fuel mass)])
      (if (< curr 0)
        lst
        (loop curr (cons curr lst))))))

(define (fuel-extra mass)
  (for/sum ([sum (fuel-sums mass)])
    sum))

(define (fuel-total-extra masses)
  (for/sum ([mass masses])
    (fuel-extra mass)))

(module+ test
  (require rackunit)

  (test-case "fuel"
    [check-equal? (fuel 12) 2]
    [check-equal? (fuel 14) 2]
    [check-equal? (fuel 1969) 654])

  (test-case "fuel total"
    [check-equal? (fuel-total '(12 14 1969)) 658])
  
  (test-case "fuel sums"
    [check-equal? (fuel-sums 14) '(2)]
    [check-equal? (fuel-sums 1969) '(5 21 70 216 654)])

  (test-case "fuel extra"
    [check-equal? (fuel-extra 14) 2]
    [check-equal? (fuel-extra 1969) 966]))

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)
      (string-split) 
      (map string->number _)))

(module+ main
  (let ([exercise-data (read-exercise-data)])
    (println (fuel-total exercise-data))
    (println (fuel-total-extra exercise-data))))
