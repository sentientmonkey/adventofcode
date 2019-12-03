#lang racket

(require threading)

(define (compile source)
  (~> source
      (string-split ",")
      (map string->number _)))

(define (instruction pc stack)
  (take (drop stack (add1 pc)) 3))

(define (operation op pc stack)
  (let ([ins (instruction pc stack)])
    (list-set stack
              (caddr ins)
              (op (list-ref stack (car ins))
                 (list-ref stack (cadr ins))))))

(define (padd pc stack)
  (operation + pc stack))

(define (pmult pc stack)
  (operation * pc stack))

(define (run program)
  (let loop ([pc 0] [stack program])
    (case (list-ref stack pc)
      [(1) (loop (+ pc 4) (padd pc stack))]
      [(2) (loop (+ pc 4) (pmult pc stack))]
      [(99) stack]
      [else (error "Error" (list stack pc))])))

(define (alter program noun verb)
  (~> program
      (list-set 1 noun)
      (list-set 2 verb)))

(module+ test
  (require rackunit)

  (define (check-program? source expected)
   [check-equal? (run (compile source)) expected])

  (test-case "adds"
    [check-program? "1,0,0,3,99" '(1 0 0 2 99)])

  (test-case "multiplies"
    [check-program? "2,0,0,3,99" '(2 0 0 4 99)])

  (test-case "stops at halt"
    [check-program? "99,1,0,0,3" '(99 1 0 0 3)])

  (test-case "full programs"
    [check-program? "1,0,0,0,99" '(2 0 0 0 99)]
    [check-program? "2,4,4,5,99,0" '(2 4 4 5 99 9801)]
    [check-program? "1,1,1,4,99,5,6,0,99" '(30 1 1 4 2 5 6 0 99)]
    [check-program? "1,9,10,3,2,3,11,0,99,30,40,50" '(3500 9 10 70 2 3 11 0 99 30 40 50)])

  (test-case "alter program"
    [check-equal? (alter '(1 0 0 2 99) 12 2) '(1 12 2 2 99)]))

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)))

(define (find-pairs program)
  (for ([i (range 0 99)])
    (for ([j (range 0 99)])
      (let ([stack (run (alter program i j))])
        (when (eq? (car stack) 19690720)
          (displayln (+ (* 100 i) j)))))))

(module+ main
  (letrec ([exercise-data (read-exercise-data)]
           [program (compile exercise-data)])
    (println (~> program
                 (alter 12 2)
                 (run)
                 (car)))
    (find-pairs program)))
