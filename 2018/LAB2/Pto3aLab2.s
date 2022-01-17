/*  Chehin Juan Martin

3) [Recomendado] Escriba dos versiones de una subrutina transparente recursiva que calcule
el factorial de un número menor o igual que nueve. En ambos casos escriba también un
programa principal para probar la subrutina.


a) La subrutina recibe el valor de entrada en R0 y devuelve el resultado en R0.
Ejemplo R0 = 3 Resultado R0 = 6

*/

      .cpu cortex-m4
      .syntax unified
      .thumb

      .section .data


 .section .text
 .global reset

reset:

  MOV R0,#0x4
  BL  fact

stop:   B stop

fact:

  TEQ   R0,#0
  BEQ   C1
  MOV   R3,#1
  MOV   R2,R0
  SUB   R0,#1
  PUSH  {R4,LR}
  BL fact

volver:
        POP {R2,LR}
        MUL R0,R2
volver2:
  BX    LR

C1:     MOV R0,#1
        TEQ R3,#0
        BEQ volver2
        B   volver
