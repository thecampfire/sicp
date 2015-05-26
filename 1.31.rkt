; 1.31

(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))

(define (inc x) (+ x 1))

(define (ident x) x)

(define (factorial n)
  (product ident 1 inc n))

; iterative product

(define (product-iter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* (term a) result))))
  (iter a 1))

(define (factorial-iter n)
  (product-iter ident 1 inc n))

; pi approximation

(define (pi-product a b)
 (define (top-product-term x)
   (cond ((odd? x) (+ 1 x))
         (else (+ 2 x))))
 (define (bottom-product-term x)
   (cond ((odd? x) (+ 2 x))
         (else (+ 1 x))))
   (/ (product top-product-term a inc b) (product bottom-product-term a inc b)))
  

