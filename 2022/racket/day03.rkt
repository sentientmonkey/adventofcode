#lang racket

(require threading)

(define (split-rucksack w)
  (let* ([lst (string->list w)]
         [m (quotient (length lst) 2)])
  (list (take lst m) (drop lst m))))

(define (common-items s)
  (let* ([lst (split-rucksack s)]
         [a (car lst)]
         [b (cadr lst)])
   (for*/fold ([common null])
              ([i a])
    (if (member i b)
        i 
        common))))

(define (to-value c)
  (let ([v (char->integer c)])
    (cond
      [(and (char<=? #\A c) (char>=? #\Z c)) (- v 38)]
      [(and (char<=? #\a c) (char>=? #\z c)) (- v 96)]
      )))

(define (total-prioritiy lst)
  (for*/sum ([w lst])
    (to-value (common-items w))))

(module+ test
  (require rackunit)
  (test-case "common-items"
      [check-equal? (common-items "vJrwpWtwJgWrhcsFMMfFFhFp") #\p]
      [check-equal? (common-items "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL") #\L]
      [check-equal? (common-items "PmmdzqPrVvPwwTWBwg") #\P]
      [check-equal? (common-items "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn") #\v])

  (test-case "total-prioritiy"
     [check-equal? (total-prioritiy
                     '("vJrwpWtwJgWrhcsFMMfFFhFp" "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL")) 54])
  
  (test-case "to-value"
    [check-equal? (to-value #\p) 16]
    [check-equal? (to-value #\L) 38]
    ))


(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)
      (string-split "\n")))

(module+ main
  (let ([exercise-data (read-exercise-data)])
    (println (total-prioritiy exercise-data))))
    
