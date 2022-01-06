#lang racket

(provide false true int .. empty exception
         trigger triggered handle
         if-then-else
         ?int ?bool ?.. ?seq ?empty ?exception
         add mul ?leq ?= head tail ~ ?all ?any
         vars valof fun proc closure call
         greater rev binary filtering folding mapping
         fri)

(struct int (x) #:transparent)
(struct true () #:transparent)
(struct false () #:transparent)
(struct .. (e1 e2) #:transparent)
(struct empty () #:transparent)
(struct exception (exn) #:transparent)
(struct triggered (exn) #:transparent)
(struct trigger (e) #:transparent)
(struct handle (e1 e2 e3) #:transparent)
(struct if-then-else (condition e1 e2) #:transparent)
(struct ?int (e) #:transparent)
(struct ?bool (e) #:transparent)
(struct ?.. (e) #:transparent)
(struct ?seq (e) #:transparent)
(struct ?empty (e) #:transparent)
(struct ?exception (e) #:transparent)
(struct add (e1 e2) #:transparent)
(struct mul (e1 e2) #:transparent)
(struct ?leq (e1 e2) #:transparent)
(struct ?= (e1 e2) #:transparent)
(struct head (e) #:transparent)
(struct tail (e) #:transparent)
(struct ~ (e) #:transparent)
(struct ?all (e) #:transparent)
(struct ?any (e) #:transparent)
(struct vars (s e1 e2) #:transparent)
(struct valof (s) #:transparent)
(struct fun (name farg body) #:transparent)
(struct proc (name body) #:transparent)
(struct closure (env f) #:transparent)
(struct call (e args) #:transparent)
(define-syntax greater             ; ime makra
  (syntax-rules ()       ; druge ključne besede
    [(greater e1 e2)  ; sintaksa makra
     (if (true? (fri(?leq e1 e2)null)) e2 e1)]))
(define-syntax rev             ; ime makra
  (syntax-rules ()       ; druge ključne besede
    [(rev e)  ; sintaksa makra
     (letrec ([l (fri e null)]
              [reve (lambda(l acc) (cond
                                      [(empty? l) acc]
                                      [(..? l) (reve (..-e2 l) (.. (..-e1 l) acc))]
                                      ))])
       (reve l (empty))
       )]))
(define-syntax binary             ; ime makra
  (syntax-rules ()       ; druge ključne besede
    [(binary e1)  ; sintaksa makra
     (e1)]))
(define-syntax mapping             ; ime makra
  (syntax-rules ()       ; druge ključne besede
    [(mapping f seq)  ; sintaksa makra
     (letrec ([sq (fri seq null)]
              [mp (lambda(fn lst) (cond
                                     [(empty? lst) (empty)]
                                     [(..? lst) (.. (fri (call fn (list(..-e1 lst))) null) (mp fn (..-e2 lst)))]
                                     ))])
       (mp f sq))]))
(define-syntax filtering             ; ime makra
  (syntax-rules ()       ; druge ključne besede
    [(filtering f seq)  ; sintaksa makra
     (letrec ([sq (fri seq null)]
              [fl (lambda(fn lst) (cond
                                     [(empty? lst) (empty)]
                                     [(and (..? lst) (true? (fri (call fn (list(..-e1 lst))) null))) (.. (..-e1 lst) (fl fn (..-e2 lst)))]
                                     [(and (..? lst) (false? (fri (call fn (list(..-e1 lst))) null))) (fl fn (..-e2 lst))]
                                     ))])
       (fl f sq))]))
(define-syntax folding             ; ime makra
  (syntax-rules ()       ; druge ključne besede
    [(folding f init seq)  ; sintaksa makra
     (seq)]))

(define (fri expression environment)
  (cond
    [(true? expression) expression]
    [(false? expression) expression]
    [(int? expression) expression]
    [(..? expression)
     (let ([v1 (fri (..-e1 expression) environment)]
           [v2 (fri (..-e2 expression) environment)]
           )
       (cond [(triggered? v1) v1]
             [(triggered? v2) v2]
             [#t (.. v1 v2)]
       ))]
    [(empty? expression) expression]
    [(exception? expression) expression]
    [(triggered? expression) expression]
    [(trigger? expression)
     (let ([e (fri (trigger-e expression) environment)])
       (if (triggered? e)
           e
           (if (exception? e)
               (triggered e)
               (triggered (exception "trigger: wrong argument type")))))]
    [(handle? expression)
     (let ([e1 (fri (handle-e1 expression) environment)]
           [e2 (fri (handle-e2 expression) environment)]
           [e3 (fri (handle-e3 expression) environment)])
       (cond
         [(triggered? (fri e1 environment)) e1]
         [(not (exception? (fri e1 environment))) (fri (trigger(exception "handle: wrong argument type")) environment)]
         [#t (if (and (triggered? (fri e2 environment)) (string=? (exception-exn (triggered-exn (fri e2 environment))) (exception-exn e1)))
                 e3
                 e2)]))]
    [(if-then-else? expression)
     (let ([pog (fri (if-then-else-condition expression) environment)])
       (if (triggered? pog)
           pog
           (if (false? pog)
               (fri (if-then-else-e2 expression) environment)
               (fri (if-then-else-e1 expression) environment)
               )))]
    [(?bool? expression)
     (let ([v (fri (?bool-e expression) environment)])
       (if (triggered? v)
           v
           (if (or (true? v) (false? v))
               (true)
               (false))))]
    [(?int? expression)
     (let ([v (fri (?int-e expression) environment)])
       (if (triggered? v)
           v
           (if (int? v)
               (if (integer? (int-x v))
                   (true)
                   (false))
               (false))))]
    [(?empty? expression)
     (let ([v (fri (?empty-e expression) environment)])
       (if (triggered? v)
           v
           (if (empty? v)
               (true)
               (false))))]
    [(?..? expression)
     (let ([v (fri (?..-e expression) environment)])
       (if (triggered? v)
           v
           (if (..? v)
               (true)
               (false))))]
    [(?exception? expression)
     (let ([v (fri (?exception-e expression) environment)])
       (if (triggered? v)
           v
           (if (exception? v)
               (true)
               (false))))]
    [(?seq? expression)
     (letrec ([last (lambda(el) (cond [(empty? (fri el environment))(true)] [(..? (fri el environment)) (last (..-e2 (fri el environment)))] [#t (false)]))])
     (let ([v (fri (?seq-e expression) environment)])
       (cond [(triggered? v) v]
             [(..? v) (last v)]
             [(empty? v) (true)]
             [#t (false)]
             )))]
    [(add? expression)
     (let ([v1 (fri (add-e1 expression) environment)]
           [v2 (fri (add-e2 expression) environment)])
       (cond
         [(triggered? v1) v1]
         [(triggered? v2) v2]
         [(and (int? v1) (int? v2))
          (int (+ (int-x v1) (int-x v2)))]
         [(and (true?(fri (?bool v1) environment)) (true?(fri (?bool v2) environment))
               (if (and (false? v1) (false? v2))
                   (false)
                   (true)))]
         [(and (true?(fri (?seq v1) environment)) (true?(fri (?.. v2) environment))
               (letrec ([app (lambda(e1 e2) (if (empty? e1) e2 (.. (..-e1 e1) (app (..-e2 e1) e2))))])
                 (app v1 v2)))]
         [(and (true?(fri (?empty v1) environment)) (true?(fri (?empty v2) environment)))
          (empty)]
         [(and (true?(fri (?seq v1) environment)) (true?(fri (?empty v2) environment)))
          v1]
         [#t (fri (trigger (exception "add: wrong argument type")) environment)]
        ))]
    [(mul? expression)
     (let ([v1 (fri (mul-e1 expression) environment)]
           [v2 (fri (mul-e2 expression) environment)])
       (cond
         [(triggered? v1) v1]
         [(triggered? v2) v2]
         [(and (int? v1) (int? v2))
          (int (* (int-x v1) (int-x v2)))]
         [(and (true?(fri (?bool v1) environment)) (true?(fri (?bool v2) environment))
               (if (and (true? v1) (true? v2))
                   (true)
                   (false)))]
         [#t (fri (trigger (exception "mul: wrong argument type")) environment)]
        ))]
    [(?leq? expression)
     (let ([v1 (fri (?leq-e1 expression) environment)]
           [v2 (fri (?leq-e2 expression) environment)])
       (cond
         [(triggered? v1) v1]
         [(triggered? v2) v2]
         [(and (int? v1) (int? v2)
          (if (<= (int-x v1) (int-x v2)) (true) (false)))]
         [(and (true?(fri (?bool v1) environment)) (true?(fri (?bool v2) environment))
               (if (and (true? v1) (false? v2))
                   (false)
                   (true)))]
         [(and (true?(fri (?.. v1) environment)) (true?(fri (?.. v2) environment))
               (letrec ([len (lambda(e1) (if (empty? (fri e1 environment)) 0 (+ (len (..-e2 (fri e1 environment))) 1)))])
                 (if (<= (len v1) (len v2))
                 (true)
                 (false))))]
         [#t (fri (trigger (exception "?leq: wrong argument type")) environment)]
        ))]
    [(?=? expression)
     (let ([v1 (fri (?=-e1 expression) environment)]
           [v2 (fri (?=-e2 expression) environment)])
       (cond
         [(triggered? v1) v1]
         [(triggered? v2) v2]
         [(and (int? v1) (int? v2)
          (if (= (int-x v1) (int-x v2)) (true) (false)))]
         [(and (true?(fri (?bool v1) environment)) (true?(fri (?bool v2) environment))
               (cond [(and (true? v1) (true? v2)) (true)]
                     [(and (false? v1) (false? v2)) (true)]
                     [#t (false)]))]
         [(and (true?(fri (?.. v1) environment)) (true?(fri (?.. v2) environment))
               (letrec ([len (lambda(e1) (if (or(empty? e1)(not(..? e1))) 0 (+ (len (..-e2 e1)) 1)))])
                 (if (<= (len v1) (len v2))
                 (true)
                 (false))))]
         [#t (fri (trigger (exception "?=: wrong argument type")) environment)]
        ))]
    [(head? expression)
     (let ([v1 (fri (head-e expression) environment)])
       (cond
         [(triggered? v1) v1]
         [(true?(fri (?.. v1) environment))
               (if (..? v1)
                   (if (empty? (..-e1 v1))
                       (fri (trigger (exception "head: empty sequence")) environment)
                       (..-e1 v1))
                   (fri (trigger (exception "head: wrong argument type")) environment))]
         [#t (fri (trigger (exception "head: wrong argument type")) environment)]
        ))]
    [(tail? expression)
     (let ([v1 (fri (tail-e expression) environment)])
       (cond
         [(triggered? v1) v1]
         [(true?(fri (?.. v1) environment))
               (if (..? v1)
                   (if (empty? (..-e2 v1))
                       (fri (trigger (exception "tail: empty sequence")) environment)
                       (..-e2 v1))
                   (fri (trigger (exception "tail: wrong argument type")) environment))]
         [#t (fri (trigger (exception "tail: wrong argument type")) environment)]
        ))]
    [(~? expression)
     (let ([v1 (fri (~-e expression) environment)])
       (cond
         [(triggered? v1) v1]
         [(int? v1)
          (int (* (int-x v1) -1))]
         [(true?(fri (?bool v1) environment))
               (if (true? v1)
                   (false)
                   (true))]
         [#t (fri (trigger (exception "~: wrong argument type")) environment)]
        ))]
    [(?all? expression)
     (let ([v1 (fri (?all-e expression) environment)])
       (cond
         [(triggered? v1) v1]
         [(true?(fri (?seq v1) environment))
               (letrec ([an (lambda(e1) (if (empty? (fri e1 environment)) (true) (if (false? (..-e1 (fri e1 environment))) (false) (an (..-e2 (fri e1 environment))))))])
                 (an v1))]
         [(empty? v1) (true)]
         [#t (fri (trigger (exception "?all: wrong argument type")) environment)]
        ))]
    [(?any? expression)
     (let ([v1 (fri (?any-e expression) environment)])
       (cond
         [(triggered? v1) v1]
         [(true?(fri (?seq v1) environment))
               (letrec ([an (lambda(e1) (if (empty? (fri e1 environment)) (false) (if (not(false? (..-e1 (fri e1 environment)))) (true) (an (..-e2 (fri e1 environment))))))])
                 (an v1))]
         [(empty? v1) (false)]
         [#t (fri (trigger (exception "?any: wrong argument type")) environment)]
        ))]
    [(vars? expression)
     (let ([s (vars-s expression)]
           [v1 (vars-e1 expression)]
           [v2 (vars-e2 expression)])
       (cond
         [(triggered? v1) v1]
         [(triggered? v2) v2]
         [(triggered? s) s]
         [(and(list? s) (list? v1))
          (letrec ([zip (lambda(a b)
                       (cond
                         [(null? a) '()]
                         [(null? b) '()]
                         [#t
                          (let ([tem (fri (car b ) environment)])
                            (if (triggered? tem)
                                tem
                                (cons (cons (car a) tem) (zip (cdr a) (cdr b)))))]))])
            (fri v2 (append (zip s v1) environment)))]
         [#t (let ([tem (fri v1 environment)])
               (if (triggered? tem) tem (fri v2 (append (list(cons s tem) environment)))))]
         ))]
    [(valof? expression)
     (letrec (
              [s (valof-s expression)]
              [en (assoc s environment)])
       (cond
         [(triggered? s) s]
         [(not en)(fri (trigger(exception "valof: undefined variable")) environment)]
         [#t (cdr en)]
         ))]
    [(fun? expression) (closure environment expression)]
    [(proc? expression) expression]
    [(call? expression)
     (letrec ([izr (fri (call-e expression) environment)]
           [args (call-args expression)]
           [zip (lambda(a b)
                       (cond
                         [(null? a) '()]
                         [(null? b) '()]
                         [(or (and (null? a) (not (null? b))) (and (null? b) (not (null? a))))
                          (fri (trigger(exception "call: arity mismatch")) environment)]
                         [#t
                          (let ([tem (fri (car b ) environment)])
                            (if (triggered? tem)
                                tem
                                (cons (cons (car a) tem) (zip (cdr a) (cdr b)))))]))])
       (cond [(triggered? izr) izr]
             [(closure? izr)
              (let ([tem (zip (fun-farg (closure-f izr)) args)])
                (if (triggered? tem)
                    tem
                    (fri (fun-body (closure-f izr)) (append (list(cons(fun-name(closure-f izr)) izr)) (append tem (closure-env izr))))))]
             [(proc? izr) (fri (proc-body izr) (append (list(cons(proc-name izr) izr)) environment))]
             [#t (fri (trigger(exception "call: wrong argument type")) environment)]
             ))]
        ))