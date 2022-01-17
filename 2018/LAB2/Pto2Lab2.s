/*  Chehin Juan Martin

2) [Recomendado] Escriba una subrutina transparente que realice la suma de un número de
64 bits y uno de 32 bits. Esta subrutina recibe la dirección del número de 64 bits en R0 y el
número de 32 bits en R1 . El resultado, de 64 bits, se almacena en el mismo lugar donde se
recibió el primer operando. Escriba un programa principal para probar el funcionamiento de la
misma.: Ejemplo:

Parámetros R0 = 0x1008.0000 R1 = 0xA056.0102
Pre condiciones M[R0] = 0x8100.0304 M[R0+1] = 0x0020.0605
Resultado M[R0] = 0x2156.0406 M[R0+1] = 0x0020.0606

*/

      .cpu cortex-m4
      .syntax unified
      .thumb

      .section .data

numero1: .word  0x81000304,0x00200605
numero2: .word  0xA0560102


 .section .text
 .global reset

reset:

  LDR R0,=numero1
  LDR R1,=numero2

  BL suma

stop:   B stop

suma:

  PUSH  {R4,R5,R6}
  LDR   R4,[R0]         // contiene el numero a sumar
  LDR   R5,[R1]         // contiene el numero a sumar
  ADDS  R6,R4,R5      // Suma con acarreo
  LDR   R4,[R0,#4]
  ADC   R5,R4,#0
  STR   R6,[R0]
  STR   R5,[R0,#4]
  POP   {R4,R5,R6}
  BX    LR
