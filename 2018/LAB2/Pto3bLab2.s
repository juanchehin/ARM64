/*  Chehin Juan Martin

3) [Recomendado] Escriba dos versiones de una subrutina transparente recursiva que calcule
el factorial de un número menor o igual que nueve. En ambos casos escriba también un
programa principal para probar la subrutina.

b) La subrutina recibe el valor de entrada en la pila, en M[SP + 4], y el resultado debe ser
devuelto también en la pila, en M[SP].
Ejemplo M[SP + 4] = 3 Resultado M[SP] = 6

*/

      .cpu cortex-m4
      .syntax unified
      .thumb

      .section .data

resul:  .space  1

 .section .text
 .global reset

reset:

  MOV R0,#0x3
  PUSH {R0}
  BL  opfact
  LDR   R1,[SP]
  LDR   R2,[SP,#4]

stop:   B stop

opfact:

  LDR   R0,[SP]
  PUSH  {LR}
  BL fact
  POP   {LR}
  PUSH  {R0}
  BX    LR

fact:

  TEQ   R0,#0
  BEQ   C1
  MOV   R3,#1
  MOV   R2,R0
  SUB   R0,#1
  PUSH  {R2,LR}
  BL fact

volver:
        POP {R2,LR}
        MUL R0,R2
volver2:
  BX    LR

C1:     MOV R0,#1
        TEQ R2,#0
        BEQ volver2
        B   volver
