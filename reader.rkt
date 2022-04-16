#lang racket

(require brag/support)
(require br-parser-tools/lex)
(require br-parser-tools/lex-sre)
(require syntax/strip-context)
(require "parser.rkt")

(provide (rename-out [my-read-syntax read-syntax]))
(provide tokenize)

;; TODO: Vale a pena colocar o tokenize em um módulo separado
(define (tokenize input)
  (port-count-lines! input)
  (define my-lexer
    (lexer-src-pos
     [(from/to "\"" "\"") (token 'STRING lexeme)]
     ["->" (token 'NEXT-STEP-OPERATOR lexeme)]
     ["[" (token 'OPEN-DIVISION lexeme)]
     ["]" (token 'CLOSE-DIVISION lexeme)]
     ["{" (token 'OPEN-GROUPING lexeme)]
     ["}" (token 'CLOSE-GROUPING lexeme)]
     [(repetition 1 +inf.0 numeric) (token 'NUMBER lexeme)]
     [(or "Pagamento pix" "Pagamento de boleto") (token 'PAYMENT-TYPE lexeme)]
     [whitespace (token 'WHITESPACE #:skip? #t)]
     [(eof) (void)]))
  (define (next-token) (my-lexer input))
  next-token)

(define (my-read-syntax src input)
  (define parsed (parse src (tokenize input)))
  (strip-context
   (datum->syntax #f `(module cumbuca-payment-module "expander.rkt"
                        ,parsed))))

