/*
CHEHIN JUAN MARTIN - FACET UNT

7) [Recomendado]
Modiﬁque el ejercicio visto en la clase de laboratorio para prender los segmentos
correspondientes a un dígito determinado. El valor a mostrar, que deberá estar entre
0 y 9, se encuentra almacenado en el registro R0. Para la solución deberá utilizar una tabla de
conversión de BCD a 7 segmentos la cual deberá estar almacenada en memoria no volatil. La
asignación de los bits a los correspondientes segmentos del dígito se muestra en la ﬁgura que
acompaña al enunciado.

 */

    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"

/**
* Programa principal, siempre debe ir al principio del archivo
*/
    .section .text              // Define la seccion de codigo (FLASH)
    .global reset               // Define el punto de entrada del codigo

    .func main
    


reset:
    BL configurar

rutina:
    LDR R0,=0x01       // Numero a mostrar
    LDR R3,=tabla   // Apunto a la direccion tabla
    ADD R3,R0       // Sumo para obtener los bits de la direccion correspondiente al numero
    // LRD R2,[R3]     // Cargo en R2 en valor de la tabla + R0

reloj:
    // Prendido de todos los bits gpio de los SEGMENTOS
    LDR R1,=GPIO_PIN2   // 
    LDRB R2,[R3]        
    STRB R2,[R1]

    // Prendido de todos bits gpio de los DIGITOS
    LDR R1,=GPIO_PIN0
    LDR R0,=0x01
    STR R0,[R1]

stop:
    B stop              // Lazo infinito para terminar la ejecucion

    .align
    .pool
    .endfunc

tabla:  .byte 0xFC,0x60,0xDA,0xF2,0x66
        .byte 0xB6,0xBE,0xE0,0xFE,0xF6

/**
* Inclusion de las funciones para configurar los teminales GPIO del procesador
*/
    .include "ejemplos/digitos.s"
