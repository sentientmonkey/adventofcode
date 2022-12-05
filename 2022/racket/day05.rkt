#lang racket

(require threading)


(define (make-move model crates)
  (if (eq? model 9001)
    crates
    (reverse crates)))

(define (move-crates! model stacks n from to)
  (let* ([from-stack (vector-ref stacks (sub1 from))]
         [to-stack (vector-ref stacks (sub1 to))]
         [crates (make-move model (take-right from-stack n))])
    (vector-set! stacks (sub1 to) (append to-stack crates))
    (vector-set! stacks (sub1 from) (drop-right from-stack n))))

(define (top-crates-message stacks)
  (~>> stacks
       (vector-map last)
       (vector->list)
       (map symbol->string)
       (string-join _ "")))

(define moves-px #px"move (\\d+) from (\\d+) to (\\d+)")

(define (parse-moves lst)
  (for/list ([line lst]
             #:when (regexp-match? moves-px line))
    (~>> line
        (regexp-match moves-px)
        (drop _ 1)
        (map string->number))))

(define (get-message-for-moves model stacks lines)
  (for* ([move (parse-moves lines)])
    (let ([n (first move)]
          [from (second move)]
          [to (third move)])
      (move-crates! model stacks n from to)))
  (top-crates-message stacks))

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)
      (string-split "\n")))

(module+ test
  (require rackunit)

  (test-case "move-crates"
    (let ([stacks (list->vector '((Z N)
                                  (M C D)
                                  (P)))]
          [model 9000])
      (move-crates! model stacks 1 2 1)
      [check-equal?
        (vector->list stacks)
        '((Z N D)
         (M C)
         (P))]

      (move-crates! model stacks 3 1 3)
      [check-equal?
        (vector->list stacks)
        '(()
         (M C)
         (P D N Z))]

      (move-crates! model stacks 2 2 1)
      [check-equal?
        (vector->list stacks)
        '((C M)
         ()
         (P D N Z))]

      (move-crates! model stacks 1 1 2)
      [check-equal?
        (vector->list stacks)
        '((C)
         (M)
         (P D N Z))]

      [check-equal?
        (top-crates-message stacks)
        "CMZ"]))

  (test-case "parse-moves"
    [check-equal?
      (parse-moves
       '("not a move"
         ""
         "move 1 from 2 to 1"
         "move 3 from 1 to 3"
         "move 2 from 2 to 1"
         "move 1 from 1 to 2"))
      '((1 2 1)
        (3 1 3)
        (2 2 1)
        (1 1 2))]))

(module+ main
  (define initial-stack
    '((W R F)
      (T H M C D V W P)
      (P M Z N L)
      (J C H R)
      (C P G H Q T B)
      (G C W L F Z)
      (W V L Q Z J G C)
      (P N R F W T V C)
      (J W H G R S V)))
  (let ([exercise-data (read-exercise-data)])
    (let ([stack (list->vector initial-stack)])
     (println (get-message-for-moves 9000 stack exercise-data)))
    (let ([stack (list->vector initial-stack)])
     (println (get-message-for-moves 9001 stack exercise-data)))))
