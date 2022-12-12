#lang racket

(require threading)

(define (string->ins s)
  (let* ([tokens (string-split s " ")]
         [op (car tokens)]
         [args (cdr tokens)])
   (cond
    [(equal? op "noop") '(noop)]
    [(equal? op "addx") `(addx ,(string->number (car args)))]
    [(error "could not parse" s)])))

(define (parse src)
  (~> src
      (string-split "\n")
      (map string->ins _)))

(define (ins-op ins)
  (car ins))

(define (ins-arg ins)
  (cadr ins))

(struct cpu (x pc sample) #:mutable #:transparent)

(define (cpu-init)
  (cpu 1 1 0))

(define (sample-cpu c)
  (when (equal? (remainder (- (cpu-pc c) 20) 40) 0)
    (let ([s (* (cpu-x c) (cpu-pc c))])
      (set-cpu-sample! c (+ (cpu-sample c) s)))))

(define (cpu-run c program)
  (for ([ins program])
    (cond
      [(equal? (ins-op ins) 'noop)
       (sample-cpu c)
       (set-cpu-pc! c (add1 (cpu-pc c)))]
      [(equal? (ins-op ins) 'addx)
       (sample-cpu c)
       (set-cpu-pc! c (add1 (cpu-pc c)))
       (sample-cpu c)
       (set-cpu-pc! c (add1 (cpu-pc c)))
       (set-cpu-x! c (+ (ins-arg ins) (cpu-x c)))])))


(module+ test
  (require rackunit)

  (test-case "parses instructions"
    [check-equal? (parse "noop\naddx -30\nnoop")
                  '((noop)
                    (addx -30)
                    (noop))])

  (test-case "CPU runs"
   (let ([c (cpu-init)])
     (cpu-run c '((noop) (addx 3) (addx -5)))
     [check-equal? (cpu-x c) -1]
     )))

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)))

(module+ main
  (let ([exercise-data (read-exercise-data)]
        [c (cpu-init)])
    (cpu-run c (parse exercise-data))
    (println (cpu-sample c))))
