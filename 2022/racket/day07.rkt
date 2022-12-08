#lang racket

(require threading)

(struct node (name type size children) #:mutable #:transparent)

(define (node-usage node)
  (if (empty? (node-children node))
    (node-size node)
    (for/sum ([n (node-children node)])
      (node-usage n))))

(define (print-node root)
  (letrec ([print-node-helper
          (λ (n depth)
             (for [(in-range depth)]
               (printf "  "))
             (cond
               [(equal? "dir" (node-type n))
                (printf "- ~a (dir)\n" (node-name n))
                (map (λ (r) (print-node-helper r (add1 depth))) (node-children n))]
               [(equal? "file" (node-type n))
                (printf "- ~a (file, size=~a)\n" (node-name n) (node-size n))]))])
    (print-node-helper root 0)))

(define (node-add-file node file)
  (set-node-children! node (append (node-children node) (list file))))

(define (make-directory-node name)
  (node name "dir" 0 '()))

(define (make-file-node name size)
  (node name "file" size '()))

(define (make-root-node)
  (make-directory-node "/"))

(define (build-filesytem fs term)
 (if (empty? term)
   fs
  (let ([xs (string-split (car term))])
        (cond
          [(and 
             (equal? "$" (car xs))
             (equal? "cd" (cadr xs))) (println "cd")]
          [(and 
             (equal? "$" (car xs))
             (equal? "ls" (cadr xs))) (println "ls")]
          )
        (build-filesytem fs (cdr term)))
   )) 

(define (analyze-space term)
  (if (empty? term)
    0
    (let ([xs (string-split (car term))])
      (cond
        [(and 
           (equal? "$" (car xs))
           (equal? "cd" (cadr xs))) (println "cd")]
        [(and 
           (equal? "$" (car xs))
           (equal? "ls" (cadr xs))) (println "ls")]
        )
      (analyze-space (cdr term)))))

(define (read-exercise-data)
  (~> (current-command-line-arguments)
      (vector-ref 0)
      (open-input-file)
      (port->string)
      (string-split "\n")))

(module+ test
  (require rackunit)
  (test-case "returns size for file"
    (let ([file (make-file-node "i" 584)])
      [check-equal? (node-usage file) 584]))

  (test-case "returns size for dir"
    (let ([root (make-root-node)])
      (node-add-file root (make-file-node "f" 29116))
      (node-add-file root (make-file-node "j" 2557))
      [check-equal? (node-usage root) 31673]))
)

(module+ main
  (let ([exercise-data (read-exercise-data)])
     (print-node (make-root-node))
     (println (analyze-space exercise-data))))
