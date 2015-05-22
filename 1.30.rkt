; 1.30

(define (cube x) (* x x x))

(define (inc x) (+ 1 x))

(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (+ (term a) result))))
  (iter a 0))
