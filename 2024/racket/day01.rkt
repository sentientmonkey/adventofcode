#lang racket

(require threading)

(define (into-lists xs)
  (for/fold ([a '()]
             [b '()]
             #:result (list a b))
             ([x xs])
    (values (append a (list (car x)))
            (append b (cdr x)))))

(define (into-sorted-lists xs)
  (map (λ(x) (sort x <)) xs))

(define (distance-between xs)
  (let ([a (car xs)]
        [b (cadr xs)])
  (for/list ([ai a]
              [bi b])
    (abs (- ai bi)))))

(define (distance-checksum xs)
  (foldl + 0 xs))

(define (check-distance xs)
  (~> xs
      into-lists
      into-sorted-lists
      distance-between
      distance-checksum))

(module+ test
  (require rackunit)
  (define test-input
    '((3 4)
      (4 3)
      (2 5)
      (1 3)
      (3 9)
      (3 3)))

  (test-case "into-lists"
    [check-equal?
      (into-lists test-input)
      '((3 4 2 1 3 3)
        (4 3 5 3 9 3))])

  (test-case "into-sorted-lists"
      [check-equal?
      (into-sorted-lists
        '((3 4 2 1 3 3)
          (4 3 5 3 9 3)))
      '((1 2 3 3 3 4)
        (3 3 3 4 5 9))])

  (test-case "distance-betwen"
    [check-equal?
      (distance-between
        '((1 2 3 3 3 4)
          (3 3 3 4 5 9)))
      '(2 1 0 1 2 5)])

  (test-case "disance-checksum"
    [check-equal?
      (distance-checksum '(2 1 0 1 2 5))
      11])

  (test-case "check-distance"
    [check-equal?
      (check-distance test-input)
      11]))

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)
      (string-split "\n") 
      (map string-split _)
      (map (λ (n)
              (map string->number n)) _)))

(module+ main
  (let ([exercise-data (read-exercise-data)])
    (println (check-distance exercise-data))))
