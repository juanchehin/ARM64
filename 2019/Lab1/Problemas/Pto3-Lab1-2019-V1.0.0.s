/*
CHEHIN JUAN MARTIN - FACET UNT - 16/09/19

3) [Recomendado]
Escriba un programa que agregue un bit de paridad a una cadena de caracteres
ASCII. La ﬁnalización de la cadena esta marcada con el valor 0x00 y el bloque comienza
en la dirección base. Se debe poner en 1 el bit más signiﬁcativo de cada caracter si y sólo si
esto hace que el número total de unos en ese byte sea par. Por ejemplo:
Dato
Resultado
(base) = 0x06
(base) = 0x06
(base + 1) = 0x7A (base + 1) = 0xFA
(base + 2) = 0x7B (base + 2) = 0x7B
(base + 3) = 0x7C (base + 3) = 0xFC
(base + 4) = 0x00 (base + 4) = 0x00 */

        .cpu cortex-m4
        .syntax unified
        .thumb
        .section .data
//        .equ tamanio,4
        
num1:   .byte 0x06, 0x7A                // Números
num2:   .byte 0x7B, 0x7C , 0x00

        .align
base:   .word num1          //  2 ASCII de 8 bits cada uno . Total 16 bits
        .word num2          // 

        .section .text
        .global reset

reset:

        LDR R0,=base        // Puntero a base
        LDR R1,[R0]         // Obtengo el numero almacenado en BASE       
        MOV R2,0x00         // R2 sera contador de bits en la cadena ASCII
        MOV R3,0x00         // R3 sera el contador de bits para saber si es par o no

while:  CMP R1,0x00         // ¿Es el final del bloque?
        BEQ stop           // Si es el final de la cadena, salto a 'final'

salto:
        AND R4,R1,0x80      // Obtengo el primer bit de los 8 (sin afectar el original)
        CMP R4,0x00         // El primer bit ¿Es cero? , si es cero, no salta para sumarse (afecta a la bandera)
        ADD R2,1            // Sumo al contador hasta llegar a los 8 bits del ASCII
        BEQ salto1          // Si es uno , el primer bit , salta para sumarse

volver:
        CMP R2,0x08         // ¿Llego a 8 el 'puntero de corrimiento'?
        BEQ comprobar           // Entonces salto para sumar BASE + 1 y comprobar
        B   while

salto1:
        ADD R3,1            // Sumo 1 al contador para despues verificar la paridad o no
        B   volver           // 'Vuelvo' para continuar comprobando
    
comprobar:                  // ¿El contador R3 es par o impar?
        MOVS  R0,R2,LSR #1 
        BNE   esimpar

        ADD R0,4            // Sumo 4 para seguir comprobando los demas ASCII despues de BASE
        MOV R2,0            // Reseteo el contador
        B   while

esimpar:                      // Rutina 'esimpar' , para setear el bit de paridad
        ADD R0,0x80           // Seteo el primer bit para que sea uno y la cantidad de unos sea par
        B   while

stop:
    B stop              // Lazo infinito
    
    .align
    .pool