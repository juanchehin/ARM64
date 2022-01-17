/*  Chehin Juan Martin

9) [Profundización] Escriba una subrutina transparente que implemente una búsqueda binaria
sobre un vector ordenado de bytes. La subrutina recibe en R0 la dirección base de una estructura en memoria que contiene en base la dirección de inicio del vector como un número de 32
bits, en base + 4 la cantidad de elementos del vector como un número de 16 bits y en base
+ 6 el número a buscar como un numero de 8 bits. Esta subrutina devolverá 0 si el valor no
es encontrado y 1 en caso de encontrarlo. Defina la forma más conveniente para el paso de
los parámetros y escriba un programa principal para probar la misma. Tenga presente que el
vector puede estar ubicado en cualquier zona de memoria.

*/

      .cpu cortex-m4
      .syntax unified
      .thumb

      .section .data

base: .word vector

cantidad:   .hword  5

numero: .byte   7

vector: .byte   2,4,5,6,7

 .section .text
 .global reset

reset:

  LDR   R0,=base

  BL    busqueda

stop:   B stop

busqueda:

  PUSH  {R5,R6,R7,R8,R9}
  LDR   R8,=cantidad
  LDR   R9,=numero
  LDR   R0,[R0]
  LDRB  R9,[R9]
  MOV   R4,#0
  LDRH  R5,[R8]

salto:

  CMP  R5,R4
  BCC  res
  SUB  R6,R5,R4
  ASR  R6,R6,#1
  ADD  R6,R4
  LDRB R7,[R0,R6]
  TEQ  R7,R9
  BEQ  res1
  CMP  R7,R9
  IT   HI
  SUBHI R5,R6,#1
  CMP  R7,R9
  IT  CC
  ADDCC  R4,R6,#1
  B   salto

res:

  POP   {R5,R6,R7,R8,R9}
  MOV   R0,#0
  BX    LR

res1:

  POP   {R5,R6,R7,R8,R9}    // ...R9,R9}
  MOV   R0,#1
  BX    LR
