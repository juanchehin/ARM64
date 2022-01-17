/*  Chehin Juan Martin

5) Escriba una subrutina transparente que desplace 1 lugar todos los elementos de una lista de
números de 16 bits. La misma recibe la dirección del primer elemento en R0 y la cantidad de
elementos en R1.

*/

      .cpu cortex-m4
      .syntax unified
      .thumb

      .section .data

bloque: .hword  1,2,3,4

 .section .text
 .global reset

reset:

  LDR   R0,=bloque
  MOV   R1,#4
  BL    desplace

stop:   B stop

desplace:

  PUSH  {R4,R5}
  LSL   R1,R1,#1
  ADD   R4,R0,R1

salto:

  LDRH  R5,[R4,#-2]
  STRH  R5,[R4]
  SUB   R4,#2
  CMP   R4,R0
  BHI   salto
  POP   {R4,R5}
  BX    LR

  CMP   R4,R0
  BEQ   salto
  UDIV  R6,R1,R5
  MUL   R6,R6,R5
  SUB   R6,R1,R6
  LDRB  R6,[R3,R6]
  STRB  R6,[R4,#-1]
  SUB   R4,#1
  UDIV  R1,R1,R5
  B     lazo

/*salto1:

  SUB   R1,#1
  LDRH  R5.[R0,R1,LSL #1]
  ADD   R1,#1
  STRH  R5,[R0,R1,LSL #1]
  SUBS  R1,#1
  BNE   salto1
  POP   {R4,R5}
  BX    LR

*/
