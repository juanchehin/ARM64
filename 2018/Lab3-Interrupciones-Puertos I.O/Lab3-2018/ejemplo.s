/*

AUTOR: CHEHIN JUAN MARTIN

PROGRAMA -- EJEMPLO --

FUNCION: Mediante la pulsacion de el boton 1 (mas a la derecha) incremente el valor de 0 al 9 en los 
4 display , asi tambien con el boton 2 (a la par del boton 1) decrementa la cuenta


 */


    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

//Recursos del boton 1
.equ BUTTON1_PORT, 4
.equ BUTTON1_PIN, 8
.equ BUTTON1_BIT, 12
.equ BUTTON1_MASK, (1<<BUTTON1_BIT)

//Recursos del boton 2
.equ BUTTON2_PORT, 4
.equ BUTTON2_PIN, 9
.equ BUTTON2_BIT, 13
.equ BUTTON2_MASK, (1<<BUTTON2_BIT)

//Recursos de los botones
.equ BUTTON_GPIO, 5
.equ BUTTON_MASK, (BUTTON1_MASK|BUTTON2_MASK)

//Recursos del Display - Enabler 1
.equ DISP_PORT, 0
.equ DISP_PIN, 0
.equ DISP_BIT, 0
.equ DISP_MASK, (1<<DISP_BIT)
.equ DISP_GPIO, 0


//Recursos del Display - Enabler 2
.equ DISP2_PORT, 0
.equ DISP2_PIN, 1
.equ DISP2_BIT, 1
.equ DISP2_MASK, (1<<DISP2_BIT)

//Recursos del Display - Enabler 3
.equ DISP3_PORT, 1
.equ DISP3_PIN, 15
.equ DISP3_BIT, 2
.equ DISP3_MASK, (1<<DISP3_BIT)

//Recursos del Display - Enabler 4
.equ DISP4_PORT, 1
.equ DISP4_PIN, 17
.equ DISP4_BIT, 3
.equ DISP4_MASK, (1<<DISP4_BIT)

//Recursos del Display - Segmento a
.equ DISP_A_PORT, 4
.equ DISP_A_PIN,0
.equ DISP_A_BIT, 0
.equ DISP_A_MASK, (1<<DISP_A_BIT)

//Recursos del Display - Segmento b
.equ DISP_B_PORT, 4
.equ DISP_B_PIN, 1
.equ DISP_B_BIT, 1
.equ DISP_B_MASK, (1<<DISP_B_BIT)

//Recursos del Display - Segmento c
.equ DISP_C_PORT, 4
.equ DISP_C_PIN, 2
.equ DISP_C_BIT, 2
.equ DISP_C_MASK, (1<<DISP_C_BIT)

//Recursos del Display - Segmento d
.equ DISP_D_PORT, 4
.equ DISP_D_PIN, 3
.equ DISP_D_BIT, 3
.equ DISP_D_MASK, (1<<DISP_D_BIT)

//Recursos del Display - Segmento e
.equ DISP_E_PORT, 4
.equ DISP_E_PIN, 4
.equ DISP_E_BIT, 4
.equ DISP_E_MASK, (1<<DISP_E_BIT)

//Recursos del Display - Segmento f
.equ DISP_F_PORT, 4
.equ DISP_F_PIN, 5
.equ DISP_F_BIT, 5
.equ DISP_F_MASK, (1<<DISP_F_BIT)

//Recursos del Display - Segmento g
.equ DISP_G_PORT, 4
.equ DISP_G_PIN, 6
.equ DISP_G_BIT, 6
.equ DISP_G_MASK, (1<<DISP_G_BIT)

//Recursos del Display - Todos los segmentos
.equ DISP_SEGM_GPIO, 2
.equ DISP_SEGM_MASK, (DISP_A_MASK|DISP_B_MASK|DISP_C_MASK|DISP_D_MASK|DISP_E_MASK|DISP_F_MASK|DISP_G_MASK)

.equ DISP_ALL_MASK, (DISP_MASK|DISP2_MASK|DISP3_MASK|DISP4_MASK)
/****************************************************************************/
/* Vector de interrupciones                                                 */
/****************************************************************************/

    .section .isr           // Define una seccion especial para el vector
    .word   stack           //  0: Initial stack pointer value
    .word   reset+1         //  1: Initial program counter value
    .word   handler+1       //  2: Non mascarable interrupt service routine
    .word   handler+1       //  3: Hard fault system trap service routine
    .word   handler+1       //  4: Memory manager system trap service routine
    .word   handler+1       //  5: Bus fault system trap service routine
    .word   handler+1       //  6: Usage fault system tram service routine
    .word   0               //  7: Reserved entry
    .word   0               //  8: Reserved entry
    .word   0               //  9: Reserved entry
    .word   0               // 10: Reserved entry
    .word   handler+1       // 11: System service call trap service routine
    .word   0               // 12: Reserved entry
    .word   0               // 13: Reserved entry
    .word   handler+1       // 14: Pending service system trap service routine
    .word   systick_isr+1   // 15: System tick service routine
    .word   handler+1       // 16: Interrupt IRQ service routine

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la secci????n de variables (RAM)
valor:
    .zero 1                 // Dato a mostrar
tabla:
    .byte 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67 //Valores de los segmentos para cada numero BCD

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset           // Define el punto de entrada del c????digo
    .section .text          // Define la secci????n de c????digo (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Configura los pines de los leds como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DISP_A_PORT << 7 | DISP_A_PIN << 2)]
    STR R0,[R1,#(DISP_B_PORT << 7 | DISP_B_PIN << 2)]
    STR R0,[R1,#(DISP_C_PORT << 7 | DISP_C_PIN << 2)]
    STR R0,[R1,#(DISP_D_PORT << 7 | DISP_D_PIN << 2)]
    STR R0,[R1,#(DISP_E_PORT << 7 | DISP_E_PIN << 2)]
    STR R0,[R1,#(DISP_F_PORT << 7 | DISP_F_PIN << 2)]
    STR R0,[R1,#(DISP_G_PORT << 7 | DISP_G_PIN << 2)]
    STR R0,[R1,#(DISP_PORT << 7 | DISP_PIN << 2)]
    STR R0,[R1,#(DISP2_PORT << 7 | DISP2_PIN << 2)]
    STR R0,[R1,#(DISP3_PORT << 7 | DISP3_PIN << 2)]
    STR R0,[R1,#(DISP4_PORT << 7 | DISP4_PIN << 2)]
    // Configura los pines de las teclas como gpio con pull-down
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(BUTTON1_PORT << 7 | BUTTON1_PIN << 2)]
    STR R0,[R1,#(BUTTON2_PORT << 7 | BUTTON2_PIN << 2)]

    // Apaga todos los bits gpio de los leds
    LDR R1,=GPIO_CLR0
    LDR R0,=DISP_SEGM_MASK
    STR R0,[R1,#(DISP_SEGM_GPIO << 2)]

    // Configura los bits gpio de los leds como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#(DISP_SEGM_GPIO << 2)]
    ORR R0,#DISP_SEGM_MASK
    STR R0,[R1,#(DISP_SEGM_GPIO << 2)]

    LDR R0,[R1,#(DISP_GPIO << 2)]
    ORR R0,#DISP_ALL_MASK
    STR R0,[R1,#(DISP_GPIO << 2)]




    // Configura los bits gpio de los botones como entradas
    LDR R0,[R1,#(BUTTON_GPIO << 2)]
    AND R0,#~BUTTON_MASK
    STR R0,[R1,#(BUTTON_GPIO << 2)]

    // Define los punteros para usar en el programa (PREGUNTAR)!!!
    LDR R4,=GPIO_PIN0
    LDR R5,=GPIO_NOT0

    MOV R0,#0
    LDR R1,=GPIO_SET0
    LDR R6,=GPIO_CLR0
    MOV R2,#0xFF
    STR R2,[R6]
    MOV R2,#15

    STRB R2,[R1] //display 1 enable


    MOV R3,#0b1111111
    LDR R9,=tabla
    MOV R10,#0
refrescar:
//Carga del valor al display
    STR R3,[R6,#(DISP_SEGM_GPIO<<2)]
    LDRB R8,[R9,R0]
    STRB R8,[R1,#(DISP_SEGM_GPIO<<2)]

MOV R11,#0
demora:ADD R11,#1
    CMP R11,#0x36000
    BNE demora
    //cambio del valor por pulsadores
    LDR R7,[R4,#(BUTTON_GPIO<<2)]
    AND R7,#BUTTON_MASK
    LSR R7,#12
    CMP R10,R7
    MOV R10,R7
    BEQ refrescar
    CMP R7,#1
    IT EQ
    ADDEQ R0,#1
    CMP R7,#2
    IT EQ
    SUBEQ R0,#1
    CMP R0,#10
    ITT EQ
    MOVEQ R0,#0
    BEQ refrescar
    CMP R0,#-1
    IT EQ
    MOVEQ R0,#9
    B refrescar


stop:
    B stop

    .pool                   // Almacenar las constantes de c????digo

    .endfunc

/****************************************************************************/
/* Rutina de inicializaci????n del SysTick                                     */
/****************************************************************************/
    .func systick_init
systick_init:
    CPSID I                 // Deshabilita interrupciones

    // Configurar prioridad de la interrupcion
    LDR R1,=SHPR3           // Apunta al registro de prioridades
    LDR R0,[R1]             // Carga las prioridades actuales
    MOV R2,#2               // Fija la prioridad en 2
    BFI R0,R2,#29,#3        // Inserta el valor en el campo
    STR R0,[R1]             // Actualiza las prioridades

    // Habilitar el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1]             // Quita ENABLE

    // Configurar el desborde para un periodo de 100 ms
    LDR R1,=SYST_RVR
    LDR R0,=#(4800000 - 1)
    STR R0,[R1]             // Especifica valor RELOAD

    // Inicializar el valor actual del contador
    // Escribir cualquier valor limpia el contador
    LDR R1,=SYST_CVR
    MOV R0,#0
    STR R0,[R1]             // Limpia COUNTER y flag COUNT

    // Habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x07
    STR R0,[R1]             // Fija ENABLE, TICKINT y CLOCK_SRC

    CPSIE I                 // Rehabilita interrupciones
    BX  LR                  // Retorna al programa principal
    .pool                   // Almacena las constantes de c????digo
    .endfunc

/****************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                      */
/****************************************************************************/
    .func systick_isr
systick_isr:
            // Apunta R0 a espera
    LDRB R1,[R0]            // Carga el valor de espera
    SUBS R1,#1              // Decrementa el valor de espera
    BHI  systick_exit       // Espera > 0, No pasaron 10 veces
    PUSH {R0,LR}            // Conserva los registros que uso
    LDR  R0,=toggle_led_3
    BLX  R0                 // Llama a la subrutina para destellar led
    POP  {R0,LR}            // Recupera los registros conservados
    MOV  R1,#10             // Vuelvo a carga espera con 10 iterciones
systick_exit:
    STRB R1,[R0]            // Actualiza la variable espera
    BX   LR                 // Retorna al programa principal
    .pool                   // Almacena las constantes de c????digo
    .endfunc

/****************************************************************************/
/* Rutina de servicio generica para excepciones                             */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa.  */
/* Se declara como una medida de seguridad para evitar que el procesador    */
/* se pierda cuando hay una excepcion no prevista por el programador        */
/****************************************************************************/
    .func handler
handler:
    LDR R0,=set_led_1       // Apuntar al incio de una subrutina lejana
    BLX R0                  // Llamar a la rutina para encender el led rojo
    B handler               // Lazo infinito para detener la ejecucion
    .pool                   // Almacenar las constantes de codigo
    .endfunc
