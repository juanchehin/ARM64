/*  Chehin Juan Martin

4) Escriba una subrutina transparente que implemente la función de C .
void itoa(unsigned int value, char *string).
La cual convierte un número de 32 bits sin signo en una cadena de caracteres. La misma
recibe como parámetros el número a convertir, el cual está almacenado en la pila, en M[SP],
y un puntero al inicio de la cadena, el cual se recibe en R0. Escriba un programa principal para
probar la misma.Por ejemplo:


Datos                       Resultado
M[SP] = 0x8278.8DA5     M[R0] = 0x31 = ’1’ M[R0 + 1] = 0x36 = ’6’
R0 = 0x10000028         M[R0 + 2] = 0x36 =’6’ M[R0 + 3] = 0x38 = ’8’
                        M[R0 + 4] = 0x30 = ’3’ M[R0 + 5] = 0x39 = ’9’
                        M[r0 + 6] = 0x38 = ’8’ M[R0 + 7] = 0x38 = ’8’
                        M[r0 + 8] = 0x32 = ’2’ M[R0 + 9] = 0x01 =’1
*/

      .cpu cortex-m4
      .syntax unified
      .thumb

      .section .data

numero: .word   0x941
cadena: .space  11,0x00

tabla:  .byte
0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39

 .section .text
 .global reset

reset:

  LDR   R3,=numero
  LDR   R3,[R3]         //Numero a convertir en R3
  PUSH  {R3}            // Cargo dicho numero en la pila
  LDR   R0,=cadena
  BL    convertir

stop:   B stop

convertir:

  LDR   R1,[SP]             // Cargo el valor de lo que apunta SP (puntero a la pila) en R1
  PUSH  {R4,R5,R6,R7}       
  MOV   R5,#10
  ADD   R4,R0,#10
  LDR   R3,=tabla

lazo:

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

salto:
        POP {R4,R5,R6,R7}
        BX    LR
