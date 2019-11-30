#lang racket/base

(require racket/string)
(require racket/match)

(define (parse-tree str)
  (for/list ([line (string-split str "\n")])
            (match (string-split line #rx"[ |,]+")
              [(list node _) (list node)]
              [(list node _ "->" rst ...) (cons node rst)])))

(define (tree-root str)
  (let* ([tree (parse-tree str)])
    (for/fold ([t tree])
              ([node tree])
              )))

(module+ test
  (require rackunit)
  [check-equal? (tree-root "pbga (66)") '(("pbga"))]
  [check-equal? (tree-root "pbga (66)\nxhth (57)") '(("pbga") ("xhth"))]
  [check-equal? (tree-root "fwft (72) -> ktlj, cntj, xhth") '(("fwft" "ktlj" "cntj" "xhth"))]
  [check-equal? (tree-root "xhth (57)\nfwft (72) -> ktlj, cntj, xhth") '(("fwft" "ktlj" "cntj" "xhth"))]
  )
