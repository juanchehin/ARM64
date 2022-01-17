/*

CHEHIN JUAN MARTIN - FACET UNT - 2019

Escriba un programa para encontrar el mayor elemento en un bloque de datos. El tamaño de
dato es de 8 bits. El resultado debe guardarse en la dirección base, la longitud del bloque está
en la dirección base+1 y el bloque comienza a partir de la dirección base+2 */


.cpu cortex-m4
        .syntax unified
        .thumb
        .section .data
base:   .byte 0x00,0x03,0xff,0xAA,0xF2
        .section .text
        .global reset
reset:  LDR R1,=base
        LDR R2,=base
        LDRB R3,[R1,#1]!
        LDRB R4,[R1,#1]!
lazo:   CMP R3,#0x00
        BEQ resultado        
        LDRB R5,[R1],#1
        CMP R5,R4
        BHI cambio
volver: SUB R3,#0x01
        B lazo
stop :  B stop
resultado : STRB R4,[R2]
            B stop
cambio: MOV R4,R5
        B volver
