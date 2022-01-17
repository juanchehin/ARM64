/*

CHEHIN JUAN MARTIN - FACET UNT

6) [Profundización] Escriba la subrutina que ejecute el gestor de eventos correspondiente a las
teclas del reloj. Ésta debe identiﬁcar la subrutina correspondiente a la tecla presionada (gestor
del evento) y saltar a la misma. Para ello emplea el código de la tecla presionada almacenado
en el registro R0 como un índice en una tabla de saltos que comienza en el lugar base. Cada
entrada en la tabla de saltos contiene la dirección de la primera instrucción de la subrutina
correspondiente (punto de entrada). El programa debe transferir control a la dirección que
corresponde al índice. Por ejemplo, si el índice fuera 2, el programa saltaría a la dirección que
está almacenada en la entrada 2 de la tabla. Como es lógico cada entrada tiene 4 bytes

Por ejemplo:
R0=2

Datos                               Resultado
                                    
(base) = 0x1A00.1D05            (PC) = 0x1A00.5FC4
(base + 4) = 0x1A00.2321
(base + 8) = 0x01A0.5FC4
(base + 12) = 0x01A0.7C3A

 */

        .cpu cortex-m4
      .syntax unified
      .thumb

      .section .data

base:   .word  0x1A001D05   //  Direcciones de las subrutinas
        .word  0x1A002321
        .word  0x01A05FC4
        .word  0x01A07C3A


 .section .text
 .global reset

reset:
    MOV   R0,#0x03          // Muevo el codigo de la tecla presionada a R0
    BL    identiﬁcar        // Salto a la subrutina

identiﬁcar:
            PUSH {R0,R2,R3}          // Guardo los elementos en la pila
            ADR R3,switch            // Seteo R3 con la direccion de 'switch'

            LDR  R0,[R3,R0,LSL #2]      // Cargar en R2 la dirección del caso switch
            // ORR  R2,0x01            // Fija el MSB para indicar instrucciones THUMB                
            BX   R0                     // Saltar al caso correspondiente
            
            .align                  // Asegura que la tabla de saltos este alineada
switch:     .word case0, case1, case2, case3, case4     // Contemplo los 6 casos de las teclas
            .word case5

case0:      LDR  PC,=base           // Cargar PC con el valor correspondiente al cero
            B    break              // Saltar al final del bloque switch

case1:      LDR  R4,=base           // Cargar R4 con el valor correspondiente al uno
            LDR  PC,[R4,#0x04]      // Voy a base + 4
            B    break              // Saltar al final del bloque switch

case2:      LDR  R4,=base           // Cargar R4 con el valor correspondiente al dos
            LDR  PC,[R4,#0x08]      // Voy a base + 8
            B    break              // Saltar al final del bloque switch

case3:      LDR  R4,=base           // Cargar R2 con el valor correspondiente al tres
            LDR  PC,[R4,#0x0C]      // Voy a base + C
            B    break              // Saltar al final del bloque switch

case4:      LDR  R4,=base           // Cargar R2 con el valor correspondiente al cuatro
            LDR  PC,[R4,#0x10]      // Voy a base + 10
            B    break              // Saltar al final del bloque switch

case5:      LDR  R4,=base           // Cargar R2 con el valor correspondiente al cinco
            LDR  PC,[R4,#0x14]      // Voy a base + 14
            B    break              // Saltar al final del bloque switch 

break:      // STRB R2,[R1],#1         // Guardar el elemento convertido
            POP {R0,R2,R3}
            BX    LR               // Repetir el lazo de conversión

stop:   B stop   
