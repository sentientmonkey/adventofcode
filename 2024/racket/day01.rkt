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
  (for/list ([x xs])
    (sort x <)))

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

(define (tally xs)
  (for/fold ([acc #hash()])
            ([x xs])
    (hash-update acc x add1 0)))

(define (sim-scores lst hsh)
  (for/list ([x lst])
    (* x (hash-ref hsh x 0))))

(define (sim-score-total xs)
  (for/sum ([x xs]) x))

(define (check-similarity xs)
  (letrec ([lst (into-lists xs)]
           [nums (car lst)]
           [hsh (tally (cadr lst))])
    (sim-score-total (sim-scores nums hsh))))

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
      11])

  (test-case "tally"
    [check-equal?
      (tally '(4 3 5 3 9 3))
      #hash((4 . 1) (3 . 3) (5 . 1) (9 . 1))])

  (test-case "sim-scores"
    [check-equal?
      (sim-scores '(3 4 2 1 3 3) #hash((4 . 1) (3 . 3) (5 . 1) (9 . 1)))
      '(9 4 0 0 9 9)])

  (test-case "sim-scores-total"
    [check-equal?
      (sim-score-total '(9 4 0 0 9 9))
      31])

  (test-case "check-similarity"
    [check-equal?
      (check-similarity test-input)
      31]))

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
    (println (check-distance exercise-data))
    (println (check-similarity exercise-data))))
