#lang racket

(define (new-register) (list 0 0 0 0))
(define (register a b c d) (list a b c d))

(define (debug r a b c)
  (printf "A=~a B=~a C=~a R=~a ~n" a b c r))

(define (opi op r a b c)
  (list-set r c (op (list-ref r a) b)))

(define (opr op r a b c)
  (list-set r c (op (list-ref r a) (list-ref r b))))

(define (addi r a b c)
  (opi + r a b c))

(define (addr r a b c)
  (opr + r a b c))

(define (addr? r a b c o)
  (equal? (addr r a b c) o))

(define (addi? r a b c o)
  (equal? (addi r a b c) o))

(define (muli r a b c)
  (opi * r a b c))

(define (mulr r a b c)
  (opr * r a b c))

(define (seti r a _ c)
  (list-set r c a))

(define (setr r a _ c)
  (list-set r c (list-ref r a)))

(module+ test
  (require rackunit)

  (test-case "operations"
    [check-equal? (addi (register 3 2 1 1) 2 1 2)
                  (register 3 2 2 1)]
    [check-equal? (addr (register 3 2 1 1) 2 1 2)
                  (register 3 2 3 1)]
    [check-equal? (muli (register 3 2 1 1) 2 1 2)
                  (register 3 2 1 1)]
    [check-equal? (mulr (register 3 2 1 1) 2 1 2)
                  (register 3 2 2 1)]
    [check-equal? (seti (register 3 2 1 1) 2 1 2)
                  (register 3 2 2 1)]
    [check-equal? (setr (register 3 2 1 1) 2 1 2)
                  (register 3 2 1 1)])

  (test-case "is operator"
    [check-true (addr? (register 3 2 1 1) 2 1 2 (register 3 2 3 1))]
    [check-false (addi? (register 3 2 1 1) 2 1 2 (register 3 2 3 1))]))
