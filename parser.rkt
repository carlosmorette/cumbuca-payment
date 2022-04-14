#lang brag

program: payment*
payment: payment-type NEXT-STEP-OPERATOR STRING NEXT-STEP-OPERATOR division
payment-type: PAYMENT-TYPE
division: OPEN-DIVISION grouping* CLOSE-DIVISION
grouping: OPEN-GROUPING STRING COMMA NUMBER CLOSE-GROUPING (COMMA grouping)*

