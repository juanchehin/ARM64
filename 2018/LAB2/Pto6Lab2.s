/*  Chehin Juan Martin

6) Escriba una subrutina transparente que busque e inserte un número de 16 bits en una lista de
números también de 16 bits ordenada en memoria. La misma recibe la dirección del primer
elemento en R0 y la cantidad de elementos en R1 y el número a inserta en R2.

*/

      .cpu cortex-m4
      .syntax unified
      .thumb

      .section .data

bloque: .hword  1,3,4,6,9

 .section .text
 .global reset

reset:

  LDR   R0,=bloque
  MOV   R1,#4
  MOV   R2,#5
  BL    insertar

stop:   B stop

insertar:

  PUSH  {R4}

salto1:

  LDRH  R4,[R0]
  CMP   R4,R2
  ITT   CC
  ADDCC R0,#2
  BCC   salto1

  PUSH  {LR}
  BL    desplace

  POP   {LR}
  STRH  R2,[R0]
  POP   {R4}
  BX    LR

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
