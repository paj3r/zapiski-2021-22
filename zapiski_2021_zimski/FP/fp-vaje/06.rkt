#lang racket
(provide power gcd fib reverse remove map filter zip range is-palindrome)
(define (power x n)
  (if (= n 0)
      1
      (* x (power x (- n 1)))))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (modulo a b))))

(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))

(define (reverse sez)
  (if (null? sez)
      null
      (append (reverse (cdr sez)) (list(car sez)))))

(define (remove x sez)
  (if (null? sez)
      null
      (if (= x (car sez))
          (remove x (cdr sez))
          (cons (car sez) (remove x (cdr sez))))))

(define (map f sez)
  (if (null? sez)
      null
      (cons (f (car sez)) (map f (cdr sez)))))

(define (filter f sez)
  (if (null? sez)
      null
      (if (f (car sez))
          (cons (car sez) (filter f (cdr sez)))
          (filter f (cdr sez)))))

(define (zip a b)
  (if (or (null? a) (null? b))
      null
      (cons (list* (car a) (car b)) (zip (cdr a) (cdr b)))))

(define (range s e k)
  (if (> s e)
      null
      (cons s (range (+ s k) e k))))

(define (is-palindrome sez)
  (if (or (null? sez) (null? (cdr sez)))
      #t
      (if (= (car sez) (car (reverse sez)))
          (is-palindrome (reverse (cdr (reverse (cdr sez)))))
          #f)))
  