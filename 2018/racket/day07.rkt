#lang racket

(require threading)

(define (parse-step str)
  (let ([m (regexp-match #px"Step (\\w+) must be finished before step (\\w+) can begin." str)])
    (list (string->symbol (cadr m))
          (list (string->symbol (caddr m))))))

(define (merge-graph x g)
  (hash-update g
               (car x)
               (λ (y) (append y (cadr x)))
               '()))

(define (parse-steps str)
  (for/fold ([g (make-immutable-hash)])
            ([step (string-split str "\n")])
    (merge-graph (parse-step step) g)))

(module+ test
  (require rackunit)
  (test-case "parse step"
    (check-equal? (parse-step "Step C must be finished before step A can begin.") '(C (A)))
    (check-equal? (parse-step "Step C must be finished before step F can begin.") '(C (F))))

  (define test-steps #<<eos
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
eos
)

  (test-case "parse steps"
    (check-equal? (parse-steps test-steps) (hash 'C '(A F)))))
