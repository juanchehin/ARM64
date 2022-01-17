    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"

/**
* Programa principal, siempre debe ir al principio del archivo
*/

    .section .data

tabla:
    .word 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71

    .section .text    
    .global reset 

reset:
    BL configurar
    // Prendido de todos los bits gpio de los segmentos
    LDR R0,=GPIO_PIN2
    LDR R2,=tabla
    MOV R1,#0x0B
    MOV R4,#0x04
    MUL R4,R1
    LDR R2,[R2,R4]
    STR R2,[R0]

    // Prendido de todos bits gpio de los digitos
    LDR R0,=GPIO_PIN0
    LDR R5,=0x01
    STR R5,[R0]

stop:
    B stop              // Lazo infinito para terminar la ejecucion

    .align
    .pool

/**
* Inclusion de las funciones para configurar los teminales GPIO del procesador
*/
    .include "ejemplos/digitos.s"    
