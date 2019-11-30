#lang racket/base
(require racket/string)
(require racket/match)

(define (parse-co str)
  (map string-split (string-split str "\n")))

(struct cpu (env debug pc) #:transparent)

(define (new-cpu)
  (cpu (make-immutable-hash) (make-immutable-hash) 0))

(define (eval-val env val)
  (let ([str-val (string->number val)])
    (if str-val
      str-val
      (hash-ref env val 0))))

(define (apply-op op env debug pc reg val)
  (cpu (hash-update env reg (λ (x) (op x (eval-val env val))) 0) debug (add1 pc)))

(define (jump-op env debug pc reg val)
  (cpu
    env
    debug
    (if (zero? (eval-val env reg))
      (add1 pc)
      (+ pc (string->number val)))))

(define (set-env env debug pc reg val)
  (cpu (hash-set env reg (eval-val env val)) debug (add1 pc)))

(define (eval-op acpu ins)
  (let ([env (cpu-env acpu)]
        [debug (cpu-debug acpu)]
        [pc (cpu-pc acpu)])
    (match ins
      [(list "set" reg val) (set-env env debug pc reg val)]
      [(list "sub" reg val) (apply-op - env debug pc reg val)]
      [(list "mul" reg val) (apply-op * env (hash-update debug "mul" add1 0) pc reg val)]
      [(list "jnz" reg val) (jump-op env debug pc reg val)])))

(define (run-co str)
  (let ([stack (parse-co str)])
    (hash-ref (cpu-debug
                (for/fold ([acpu (new-cpu)])
                          ([x 10000000]
                           #:unless (>= (cpu-pc acpu) (length stack)))
                          (eval-op acpu (list-ref stack (cpu-pc acpu))))) "mul")))

(module+ test
  (require rackunit)
  [check-equal? (run-co "set a 2\nmul a a") 1])

(run-co "set b 79
set c b
jnz a 2
jnz 1 5
mul b 100
sub b -100000
set c b
sub c -17000
set f 1
set d 2
set e 2
set g d
mul g e
sub g b
jnz g 2
set f 0
sub e -1
set g e
sub g b
jnz g -8
sub d -1
set g d
sub g b
jnz g -13
jnz f 2
sub h -1
set g b
sub g c
jnz g 2
jnz 1 3
sub b -17
jnz 1 -23")
