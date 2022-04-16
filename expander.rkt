#lang racket

(require (for-syntax syntax/parse racket/syntax))

(provide
 payment
 division
 grouping
 program
 #%module-begin)

(define-syntax (program stx)
  (syntax-parse stx
    [({~literal program} p ...)
     #'(begin
         p ...)]))

(define-syntax (payment stx)
  (syntax-parse stx
    [({~literal payment} payment-type "->" code-id "->" division ...)
     #'(printf "==================\n Você quer fazer:\n ~a \n Para: ~a \n Divisão: ~a\n"
               (syntax-e #'payment-type)
               (syntax-e #'code-id)
               division ...)]))

(define-syntax (division stx)
  (syntax-parse stx
    [({~literal division} "[" gp ... "]")
     #'(begin gp ...)]))
    
(define-syntax (grouping stx)
  (syntax-parse stx
    [({~literal grouping} "{" name value "}")
     #'(format "\n  - ~a - R$ ~a"
               (syntax-e #'name)
               (syntax-e #'value))]

    [({~literal grouping} "{" name value "}" more ...)
     #'(string-append
        (format "\n  - ~a - R$ ~a"
                (syntax-e #'name)
                (syntax-e #'value))
        more ...)]))
