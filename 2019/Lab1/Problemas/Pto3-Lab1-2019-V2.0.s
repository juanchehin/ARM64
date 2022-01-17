/*
CHEHIN JUAN MARTIN - FACET UNT - 17/09/19

3) [Recomendado]
Escriba un programa que agregue un bit de paridad a una cadena de caracteres
ASCII. La ﬁnalización de la cadena esta marcada con el valor 0x00 y el bloque comienza
en la dirección base. Se debe poner en 1 el bit más signiﬁcativo de cada caracter si y sólo si
esto hace que el número total de unos en ese byte sea par. Por ejemplo:
Dato
Resultado
(base) = 0x06
(base) = 0x06
(base + 1) = 0x7A (base + 1) = 0xFA
(base + 2) = 0x7B (base + 2) = 0x7B
(base + 3) = 0x7C (base + 3) = 0xFC
(base + 4) = 0x00 (base + 4) = 0x00 */

 
        .cpu cortex-m4
        .syntax unified
        .thumb
        .section .data
       
base:   .byte 0x7A
        .section .text
        .global reset

reset :  LDR R1,=base
         MOV R4,#0x00
lazo:    LDRB R2,[R1]
         CMP R2,0x00
         BEQ stop
         MOV R3,R2
cuenta:  MOVS R3,R3,LSR #1
         ADC R4,#0
         CMP R3,0x00
         BNE cuenta
         AND R4,#0x01
         CMP R4,#0x01
         BEQ corregir
guardar: STRB R2,[R1],#1
         MOV R4,#0x00
         B lazo
corregir:ADD R2,#0x80
         B guardar
stop :   B stop
