#lang racket

(require threading)

(define (enc->hand a)
  (case (list 'quote a)
    [('A 'X) 'Rock]
    [('B 'Y) 'Paper]
    [('C 'Z) 'Scissors]))

(define (win-score ha hb)
  (cond
    [(eq? ha hb) 3]
    [(and (eq? hb 'Rock) (eq? ha 'Scissors)) 6]
    [(and (eq? hb 'Paper) (eq? ha 'Rock)) 6]
    [(and (eq? hb 'Scissors) (eq? ha 'Paper)) 6]
    [else 0]))

(define (shape-value a)
  (case a
    ['X 1]
    ['Y 2]
    ['Z 3]))

(define (outcome-value p)
  (let [(xs (map enc->hand p))]
    (win-score (car xs) (cadr xs))))

(define (score p) 
  (+ (shape-value (cadr p))
     (outcome-value p)))

(define (total-score ps)
  (for/sum ([p ps])
    (score p)))

(define (guess-value a)
  (case a
    ['A 1]
    ['B 2]
    ['C 3]))

(define (score-value a)
  (case a
    ['Y 3]
    ['X 0]
    ['Z 6]))

(define (to-choice a b)
  (case b
    ['Y a]
    ['X (case a
          ['A 'C]
          ['B 'A]
          ['C 'B])]
    ['Z (case a
          ['A 'B]
          ['B 'C]
          ['C 'A])]))

(define (guess-score p)
  (let* [(a (car p))
         (b (cadr p))
         (c (to-choice a b))]
    (+ (score-value b)
       (guess-value c))))

(define (total-score* ps)
  (for/sum ([p ps])
    (guess-score p)))

(module+ test
  (require rackunit)

  (test-case "hands"
    [check-equal? (enc->hand 'A) 'Rock]
    [check-equal? (enc->hand 'X) 'Rock])

  (test-case "scores"
    [check-equal? (score '(A Y)) 8]
    [check-equal? (score '(B X)) 1]
    [check-equal? (score '(C Z)) 6])

  (test-case "total-scores"
    [check-equal?
      (total-score '((A Y) (B X) (C Z))) 15])

  (test-case "guess-score"
    [check-equal? (guess-score '(A Y)) 4]
    [check-equal? (guess-score '(B X)) 1]
    [check-equal? (guess-score '(C Z)) 7])

  (test-case "guess-total"
    [check-equal?
      (total-score* '((A Y) (B X) (C Z))) 12]))


(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)
      (string-split "\n")
      (map string-split _)
      (map (λ (s)
              (map string->symbol s)) _)))

(module+ main
  (let ([exercise-data (read-exercise-data)])
    (println (total-score exercise-data))
    (println (total-score* exercise-data))))
