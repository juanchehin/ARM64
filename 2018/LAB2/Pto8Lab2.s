/*  Chehin Juan Martin

8) [Recomendado] Escriba una subrutina transparente volcado, la cual debe escribir en una
cadena ASCII el contenido hexadecimal de un bloque de memoria. Esta subrutina recibe como
parámetros la dirección del bloque en el registro R0, el tamaño del bloque en R1 y la dirección de la cadena en R2. Para completar la traducción de cada nibble en el carácter ASCII
correspondiente deberá utilizar una tabla de conversión. Se le sugiere que escriba primero
una subrutina que convierta un byte en dos caracteres y un espacio, y que después utilizando
esta subrutina recién resuelva el problema completo

*/

      .cpu cortex-m4
      .syntax unified
      .thumb

      .section .data

tabla: .byte

0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x40,0x41,0x42,0x43,0x44,0x45,0x46

bloque: .byte 0x3A,0x14
cantidad:   .byte   2

cadena:     .space  5

 .section .text
 .global reset

reset:

  LDR   R0,=bloque
  LDR   R1,=cantidad
  LDR   R1,[R1]
  LDR   R2,=cadena

  BL    convertir

stop:   B stop

convertir:

  PUSH  {R4,R5,R6,R7}
  MOV   R4,R1
  MOV   R7,#0x20

salto:

  LDRB  R3,[R0],#1
  PUSH  {LR}
  BL    separar
  POP   {LR}
  LDR   R6,=tabla
  LDRB  R3,[R6,R3]
  STRB  R3,[R2],#1
  LDRB  R1,[R6,R1]
  STRB  R1,[R2],#1
  STRB  R7,[R2],#1
  SUB   R4,#1
  CMP   R4,#0
  BNE   salto
  POP   {R4,R5,R6,R7}
  BX    LR

separar:

  PUSH  {R4,R5}
  AND   R4,R3,#0x0F
  AND   R5,R3,#0xF0
  LSR   R5,R5,#4
  MOV   R1,R4
  MOV   R3,R5
  POP   {R4,R5}
  BX    LR
