; 1.32.a

(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))

; (accumulate combiner null-value term a next b)

(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a) (accumulate combiner null-value term (next a) next b))))


(define (prod-acc term a next b)
  (accumulate * 1 term a next b))

(define (inc x) (+ x 1))

(define (ident x) x)

(define (factorial-acc n)
  (prod-acc ident 1 inc n))

; 1.32.b

(define (accumulate-iter combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (combiner (term a) result))))
  (iter a null-value))

(define (prod-acc-iter term a next b)
  (accumulate-iter * 1 term a next b))

(define (factorial-acc-iter n)
  (prod-acc-iter ident 1 inc n))
