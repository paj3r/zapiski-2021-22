#lang racket

#|
(provide false true int .. empty exception
         trigger triggered handle
         if-then-else
         ?int ?bool ?.. ?seq ?empty ?exception
         add mul ?leq ?= head tail ~ ?all ?any
         vars valof fun proc closure call
         greater rev binary filtering folding mapping
         fri)
|#
(struct int (x) #:transparent)
(struct true () #:transparent)
(struct false () #:transparent)
(struct .. (e1 e2) #:transparent)
(struct empty () #:transparent)
(struct exception (exn) #:transparent)
(define (fri expression environment)
  (cond [(true) (true)]))