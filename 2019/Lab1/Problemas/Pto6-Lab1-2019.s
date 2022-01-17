/*
CHEHIN JUAN MARTIN - FACET UNT - 2019


6) El método más simple para detectar alteraciones en un bloque de memoria consiste en agregar
al mismo la suma byte a byte (sin considerar el carry) de todo el contenido del bloque. Este
byte agregado se conoce como checksum o suma de comprobación. Escriba un programa que
calcule el checksum de un bloque de datos cuya cantidad de elementos está almacenada en
el registro R0 y cuyo puntero al inicio del bloque se encuentra almacenado en las direcciones
base. Se pide almacenar el resultado obtenido en la dirección base+4.

 */

 
            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data
bloque:     .byte 0x34,0x55,0x65,0x3
base:       .word 0x10080000

            .section .text
            .global reset

reset:      MOV R0,#0x04
            LDR R1,=base
            LDR R2,[R1],#4
            MOV R4,#0
lazo:       LDRB R3,[R2],#1
            CMP R0,#0
            BEQ guardar
            ADD R4,R3
            SUB R0,#1
            B lazo

guardar:    STRB R4,[R1]
stop:       B stop
 