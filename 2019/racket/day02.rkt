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
              (list-ref stack (caddr ins))
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
      [else "error"])))

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

  (test-case "alter program"
    [check-equal? (alter '(1 0 0 2 99) 12 2) '(1 12 2 2 99)]))

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)))

(module+ main
  (let ([exercise-data (read-exercise-data)])
    (println (~> exercise-data
                 (compile)
                 (alter 12 2)
                 (run)
                 (cadr)))))
