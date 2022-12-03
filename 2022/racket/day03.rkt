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

(define (common-items* s)
 (let* ([lst (map string->list s)]
        [a (car lst)]
        [b (cadr lst)]
        [c (caddr lst)])
  (for*/fold ([common null])
             ([i a])
    (if (and (member i b)
             (member i c))
             i
             common))))

(define (to-value c)
  (let ([v (char->integer c)])
    (cond
      [(and (char<=? #\A c) (char>=? #\Z c)) (- v 38)]
      [(and (char<=? #\a c) (char>=? #\z c)) (- v 96)])))

(define (total-prioritiy lst)
  (for*/sum ([w lst])
    (to-value (common-items w))))

(define (total-three-priority lst)
  (if (empty? lst)
    0
    (let ([a (take lst 3)])
      (+ (to-value (common-items* a))
         (total-three-priority (drop lst 3))))))

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
    [check-equal? (to-value #\L) 38])

  (test-case "common-items*"
    [check-equal? (common-items*
                    '("vJrwpWtwJgWrhcsFMMfFFhFp"
                      "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL"
                      "PmmdzqPrVvPwwTWBwg")) #\r])

  (test-case "total-three-priority"
    [check-equal? (total-three-priority
                    '("vJrwpWtwJgWrhcsFMMfFFhFp"
                      "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL"
                      "PmmdzqPrVvPwwTWBwg"
                      "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn"
                      "ttgJtRGJQctTZtZT"
                      "CrZsJsPPZsGzwwsLwLmpwMDw")) 70]))

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)
      (string-split "\n")))

(module+ main
  (let ([exercise-data (read-exercise-data)])
    (println (total-prioritiy exercise-data))
    (println (total-three-priority exercise-data))))
    
