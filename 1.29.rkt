; 1.29

(define (cube x) (* x x x))

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

(define (simpson f a b n)
  (define h (/ (- b a) n))
  (define (add-term x) (+ x (* h 2)))
  (* (/ h 3) (+ (f a) 
                (f (+ a (* h n))) 
                (* 4.0 (sum f (+ a h) add-term (- b h))) 
                (* 2.0 (sum f (+ a (* 2 h)) add-term (- b h)))
                )))
; The last term in each of the sums is (- b h). That's because according to the formula, the last term
; should be (+ a (* (- n 1) h)) - see simpson3. 
; But this is equal to n*a/n + (n-1)*h = n*a/n + (n-1)(b-a)/n = (n-1)b/n + a/n = nb/n - b/n + a/n =
; = b - (b-a)/n = b - h

; This is a sum based on k going from 0 to n.
; That means that the next element in the sum is (k + 1)
; Each term of the sum is made up of a multiplier (1 if k = 0 or k = n, 4 if k is odd, 2 if k is even) 
; and the yk term, which is basically f (+ a (* k h))

(define (simpson2 f a b n)
  (define h (/ (- b a) n))
  (define (yk k)
    (f (+ a (* k h))))
  (define (term k)
    (* (cond ((= 0 k) 1)
          ((= n k) 1)
          ((even? k) 2.0)
          (else 4.0)) 
       (yk k)))
  (define (inc x)
    (+ 1 x))
  (/ (* h (sum term 0 inc n)) 3))


(define (simpson3 f a b n)
  (define h (/ (- b a) n))
  (define (add-term x) (+ x (* h 2)))
  (* (/ h 3) (+ (f a) 
                (f (+ a (* h n))) 
                (* 4.0 (sum f (+ a h) add-term (+ a (* (- n 1) h)))) 
                (* 2.0 (sum f (+ a (* 2 h)) add-term (+ a (* (- n 2) h))))
                )))

