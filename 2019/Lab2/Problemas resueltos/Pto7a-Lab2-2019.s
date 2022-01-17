/*
Chehin Juan Martin

7) [Profundización] Escriba una subrutina que invierta una cadena de caracteres ASCII se encuentra
almacenada en memoria. 

Esta subrutina recibe el puntero al inicio de la cadena en R0
y un puntero al ﬁnal en R1.

a)Diseñe una subrutina cambiar que invierta el primer y el último caracter de la cadena. Esta
subrutina recibe el puntero al primer elemento en R0 y al último en R1.

b)Diseñe ahora una subrutina recursiva invertir que utiliza la rutina anterior para intercambiar
los elementos del extremo de la cadena y a si misma para invertir el resto.

 */


      .cpu cortex-m4
      .syntax unified
      .thumb

      .section .data

cadena: .word  0x484F4C41   // Cadena 'HOLA'
 //       .word  0x4C41


 .section .text
 .global reset

reset:
    LDR   R0,=cadena          // Cargo el inicio de la cadena en R0
    ADD   R1,R0,#3           // Puntero al final de la cadena (El valor a sumar depende de el ASCII cargado)
    BL     cambiar

stop:   B stop   

cambiar:
    PUSH {R2,R3}             // Guardo los auxiliares a usar

    LDRB R2,[R0]             // Primer elemento de la cadena en R2
    LDRB R3,[R1]             // Segundo elemento de la cadena en R3

    STRB R3,[R0]
    STRB R2,[R1]
    POP  {R2,R3}
    BX   LR



