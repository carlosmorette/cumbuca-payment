#lang racket

(require brag/support)
(require br-parser-tools/lex)
(require br-parser-tools/lex-sre)

(provide tokenize)

(define (tokenize input)
  (port-count-lines! input)
  (define my-lexer
    (lexer-src-pos
     [(from/to "\"" "\"") (token 'STRING lexeme)]
     ["->" (token 'NEXT-STEP-SYMBOL lexeme)]
     ["[" (token 'OPEN-DIVISION lexeme)]
     ["]" (token 'CLOSE-DIVISION lexeme)]
     ["{" (token 'OPEN-GROUPING lexeme)]
     ["}" (token 'CLOSE-GROUPING lexeme)]
     ["," (token 'COMMA lexeme)]
     [(repetition 1 +inf.0 numeric) (token 'NUMBER lexeme)]
     [(or "Pagamento pix" "Pagamento de boleto") (token 'PAYMENT-TYPE lexeme)]
     [whitespace (token 'WHITESPACE #:skip? #t)]
     [(eof) (void)]))
  (define (next-token) (my-lexer input))
  next-token)
