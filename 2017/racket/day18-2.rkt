#lang racket/base
(require racket/string)
(require racket/match)

(define (parse-duet str)
  (map string-split (string-split str "\n")))

(struct cpu (env recall pc) #:transparent)

(define (new-cpu)
  (cpu (make-immutable-hash) '() 0))

(define (eval-val env val)
  (let ([str-val (string->number val)])
    (if str-val 
      str-val
      (hash-ref env val 0))))

(define (apply-op op env recall pc reg val)
  (cpu (hash-update env reg (λ (x) (op x (eval-val env val))) 0) recall (add1 pc)))

(define (jump-op env recall pc reg val)
  (cpu
    env
    recall
    (if (> (eval-val env reg) 0)
      (+ pc (string->number val))
      (add1 pc))))

(define (set-env env recall pc reg val)
  (cpu (hash-set env reg (eval-val env val)) recall (add1 pc)))

(define (save-reg env pc reg)
  (cpu (hash-set env reg 0) (hash-ref env reg) (add1 pc)))

(define (recall-reg env recall pc reg)
  (cpu (hash-set env reg (if (null? recall) 0 recall)) 'stop (add1 pc)))

(define (eval-op acpu bcpu ins)
  (let ([env (cpu-env acpu)]
        [recall (cpu-recall acpu)]
        [pc (cpu-pc acpu)])
    (match ins
      [(list "set" reg val) (set-env env recall pc reg val)]
      [(list "add" reg val) (apply-op + env recall pc reg val)]
      [(list "mul" reg val) (apply-op * env recall pc reg val)]
      [(list "mod" reg val) (apply-op remainder env recall pc reg val)]
      [(list "snd" reg) (save-reg env pc reg)]
      [(list "rcv" reg) (recall-reg env recall pc reg)]
      [(list "jgz" reg val) (jump-op env recall pc reg val)])))

(define (run-duet str)
  (let ([stack (parse-duet str)]
        [first-recall '()])
    (for/fold ([acpu (new-cpu)]
               [bcpu (new-cpu)])
              ([x 100000000]
               #:unless (or (>= (cpu-pc acpu) (length stack)) (eq? (cpu-recall acpu) 'stop)))
              (when (and (not (null? (cpu-recall acpu))) (not (zero? (cpu-recall acpu))))
                (set! first-recall (cpu-recall acpu)))
              (values (eval-op acpu bcpu (list-ref stack (cpu-pc acpu)))
                      (eval-op bcpu acpu (list-ref stack (cpu-pc bcpu))))
    first-recall))

(module+ test
  (require rackunit)
  [check-equal? (run-duet "set a 1\nadd a 2\nmul a a\nmod a 5\nsnd a\nset a 0\nrcv a\njgz a -1\nset a 1\njgz a -2") 4])

(module+ duet
  (run-duet "set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 735
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19"))
