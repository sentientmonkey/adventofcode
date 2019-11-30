#lang racket/base
(require racket/string)
(require racket/match)
(require racket/format)
(require racket/list)


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

(define (update-debug debug op)
  (hash-update debug op add1 0))

(define (eval-op acpu ins)
  (let ([env (cpu-env acpu)]
        [debug (cpu-debug acpu)]
        [pc (cpu-pc acpu)])
    (match ins
      [(list "set" reg val) (set-env env (update-debug debug "set") pc reg val)]
      [(list "sub" reg val) (apply-op - env (update-debug debug "sub") pc reg val)]
      [(list "mul" reg val) (apply-op * env (update-debug debug "mul") pc reg val)]
      [(list "mod" reg val) (apply-op remainder env (update-debug debug "mod") pc reg val)]
      [(list "jnz" reg val) (jump-op env (update-debug debug "jnz") pc reg val)])))

(define (starting-cpu)
  (struct-copy cpu (new-cpu)
               [env (hash "a" 1)]))

(define (print-sorted-hash h)
  (for ([(k) (sort (hash-keys h) string<?)])
    (printf "~a: ~a\n" k (hash-ref h k))))

(define (print-debug stack acpu clock)
  (when show-debug
    (printf "\e[2J \e[0;0H")
    (printf "stack:\n")
    (for ([i (length stack)])
      (let* ([ins (list-ref stack i)]
             [curr (eq? (cpu-pc acpu) i)])
        (printf "~a ~a:~a\n"
                (if curr "*" " ")
                (~a i #:width 2 #:align 'right #:pad-string "0")
                (string-join ins " "))))
    (printf "\nregisters:\n")
    (print-sorted-hash (cpu-env acpu))
    (printf "\ndebug:\n")
    (print-sorted-hash (cpu-debug acpu))
    (printf "\nclock: ~a\n" clock)
    (printf "\n")))

(define stepping #t)
(define show-debug #t)

(define (get-debug)
  (when stepping
    (printf "(n)ext, (c)ontinue, (r)un, or (q)uit? ")
    (match (read-line)
      ["q" (exit)]
      ["c" (set! stepping #f)]
      ["r" (set! stepping #f) (set! show-debug #f)]
      ["n"  #t]
      [""  #t]
      [_ (get-debug)])))

(define (run-co str)
  (let* ([stack (parse-co str)]
         [cpu-result (for/fold ([acpu (starting-cpu)])
                               ([clock 1000000]
                                #:unless (>= (cpu-pc acpu) (length stack)))
                               (with-handlers ([exn:break?
                                                 (λ(x)
                                                   (set! stepping #t)
                                                   (set! show-debug #t)
                                                   acpu)])
                                              (begin
                                                (print-debug stack acpu clock)
                                                (get-debug)
                                                (eval-op acpu (list-ref stack (cpu-pc acpu))))))])

    (println cpu-result)
    (hash-ref (cpu-env cpu-result) "h" 0)))

(module+ test
  (require rackunit)
  [check-equal? (run-co "set h a") 1])

(define original "set b 79
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

(define patch "set g b
          mod g d
          jnz g 2
          set f 0
          jnz f 2
          jnz 1 9
          sub d -1
          set g d
          sub g b
          jnz g -9
          jnz 1 4
          set a a
          set a a
          set a a")

(define (apply-patch orig pat start end)
  (string-join
    (let ([o (string-split orig "\n")]
          [p (string-split pat "\n")])
      (append
        (take o start)
        p
        (drop o end))) "\n"))

;(define patched (apply-patch original patch 11 24))

(run-co original)


