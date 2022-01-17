    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"

/**
* Programa principal, siempre debe ir al principio del archivo
*/

    .section .data

tabla:
    .word 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67

    .section .text    
    .global reset 

reset:
    BL configurar
    // Prendido de todos los bits gpio de los segmentos
    LDR R3,=GPIO_PIN2
    LDR R2,=tabla
    MOV R0,#0x08
    MOV R4,#0x04
    MUL R0,R4
    LDR R7,[R2,R0]
    STR R7,[R3]

    // Prendido de todos bits gpio de los digitos
    LDR R3,=GPIO_PIN0
    LDR R5,=0x01
    STR R5,[R3]
    MOV R6,#0

espera1:
    ADD R6,#1
    LDR R1,=100000
    CMP R6,R1
    BLS espera1

    BL configurar

    LDR R3,=GPIO_PIN2
    MOV R1,#0x09
    MUL R1,R4
    LDR R7,[R2,R1]
    STR R7,[R3]
    LDR R3,=GPIO_PIN0
    LDR R5,=0x02
    STR R5,[R3]
    MOV R6,#0

espera2:
    ADD R6,#1
    LDR R8,=100000
    CMP R6,R8
    BLS espera2



    B reset              // Lazo infinito para terminar la ejecucion

    .align
    .pool

/**
* Inclusion de las funciones para configurar los teminales GPIO del procesador
*/
    .include "ejemplos/digitos.s"    
