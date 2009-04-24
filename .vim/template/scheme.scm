(use srfi-1)
(use ggc.debug.trace)
(use gauche.interactive)

(define (main args)

  (if (pair? (cdr args))
    (print (cons "args:" (cdr args)) "\n"))

  0)
