(define (expt1 b n)
  (if (= n 0)
      1
      (* b (expt1 b (- n 1)))))

(define (expt-linear b n)
  (expt-iter b n 1))

(define (expt-iter b counter product)
  (if (= counter 0)
      product
      (expt-iter b (- counter 1) (* b product))))

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (square x) (* x x))

;(define (even? n)
 ; (= (remainder n 2) 0)) 

; 1.16
;
; Design a procedure that evolves an iterative exponentiation process that uses successive squaring 
; and uses a logarithmic number of steps, as does fast-expt. 
; (Hint: Using the observation that (bn/2)2 = (b2)n/2, keep, along with the exponent n and the base b, 
; an additional state variable a, and define the state transformation in such a way that the product 
; a b^n is unchanged from state to state. At the beginning of the process a is taken to be 1, and the 
; answer is given by the value of a at the end of the process. In general, the technique of defining 
; an invariant quantity that remains unchanged from state to state is a powerful way to think about the design of iterative algorithms.)

(define (fast-expt-linear b n)
  (fast-expt-iter b n 1))

(define (fast-expt-iter b counter a)
  (if (= counter 0)
      a
      (cond ((even? counter)
             (fast-expt-iter (square b) (/ counter 2) a))
            (else (fast-expt-iter b (- counter 1) (* b a)))
            )
      )
  )


; online solution -> actually keeps result in b, not in a. Also a*b^n is not constant.
; we get 1 * 2^8, then 1 * 4^4, then 1 * 16^2, etc. The procedure keeps the result in b,
; then moves it to a only if n is not even by doing (* a b), where a is always 1 until the
; very end.

(define (fast-expt-2 b n) 
    (iter 1 b n))

(define (iter a b n) 
     (cond ((= n 0) a) 
           ((even? n) (iter a (square b) (/ n 2))) 
           (else (iter (* a b) b (- n 1))))) 
 

; Fermat test

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
               (remainder (square (expmod base (/ exp 2) m))
                          m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ 1 test-divisor)))))
(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

; 1.21.

; 1.22.


(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

; 1.22 implementation from scratch
  
(define (timed-prime starting howmany)
  (cond ((= 0 howmany) true)
        ((prime? starting)
         (newline)
         (display starting) 
         (timed-prime (+ 1 starting) (- howmany 1)))
        (else (timed-prime (+ 1 starting) howmany))))
  
  
; 1.23

(define (next divisor)
  (cond ((= divisor 2) 3)
        (else (+ divisor 2))))
  
  
(define (smallest-divisor-faster n)
  (find-divisor-faster n 2))

(define (find-divisor-faster n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))  
  
  
  
; 1.25

(define (expmod2 base exp m)
  (remainder (fast-expt base exp) m))
  

; 1.27

(define (try-it-once n a)
    (= (expmod a n n) a))

(define (carmichael n)
  (carmichael-iter n 0))

(define (carmichael-iter n a)
  (cond ((= a (- n 1)) true)
        ((try-it-once n a) (carmichael-iter n (+ a 1)))))

; 1.28

(define (expmod-miller-rabin base exp m)
  (define (test-it r n)
    (if (or (= r 1) (= r (- n 1)))
        r
        (if (= 1 (remainder (square r) n)) 0
        r)))
  
  
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (test-it (expmod-miller-rabin base (/ exp 2) m) m))
                          m))
        (else
         (remainder (* base (expmod-miller-rabin base (- exp 1) m))
                    m))))

(define (try-it-mr a n)
          (= (expmod-miller-rabin a (- n 1) n) 1))


(define (miller-rabin n)
  (try-it-mr (+ 1 (random (- n 1))) n))
  
  
  
  
  
  
  
  