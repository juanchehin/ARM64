/*
CHEHIN JUAN MARTIN - FACET UNT - 2019

2)Escriba un programa para inicializar con 0x55 un vector. El tamaño de los datos del vector es
de 16 bits y la cantidad de elementos se encuentra en la dirección base (también de 16 bits).
El vector comienza en la dirección base+2.

*/

    .cpu cortex-m4        
    .syntax unified         
    .thumb 
       
    .section .data

base : .hword 0x02
 
       .section .text
       .global reset
       
reset:  LDR R1,=base
        LDRH R2,[R1],#2
        MOV R3,#0X55
lazo : STRH R3,[R1],#2
       SUBS R2,#1
       BNE lazo
stop:  B stop
