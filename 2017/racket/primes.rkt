#lang racket/base

(require racket/list)
(define (prime? n)
  (or (<= 2 n 3)
      (and (not (zero? (remainder n 2)))
           (not (zero? (remainder n 3)))
           (for/and ([i (range 5 n 6)])
                    (not (or (zero? (remainder n i))
                             (zero? (remainder n (+ i 2)))))))))

(for/fold ([lst '()])
          ((i (range 100)))
          (if (prime? i) (append lst (list i)) lst))

;(for/sum ([i (range 106700 123700 17)])
;  (if (prime? i) 1 0))
