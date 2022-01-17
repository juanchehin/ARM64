/* Chehin Juan Martin - 2019 - FACET UNT

2)Modiﬁque el proyecto de ejemplo suministrado por la cátedra en la guía de solución, para que
utilizando las cuatro teclas del poncho se prendan y apaguen los cuatro segmentos verticales
del display de la derecha. Tenga en cuenta la disposición de las conexiones de los dispositivos
de la placa y del poncho indicadas en la sección de información complementaria.


*/

    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

/* ================================================================= */
/* ===================== BOTONES  ================================== */
/* ================================================================= */

//Recursos del boton 1 - P4_8 - 4:GPIO5[12]
.equ BOTON1_PORT, 4
.equ BOTON1_PIN, 8
.equ BOTON1_BIT, 12
.equ BOTON1_MASK, (1<<BOTON1_BIT)

//Recursos del boton 2 - P4_9 - 4:GPIO5[13]
.equ BOTON2_PORT, 4
.equ BOTON2_PIN, 9
.equ BOTON2_BIT, 13
.equ BOTON2_MASK, (1<<BOTON2_BIT)

//Recursos del boton 3 - P4_10 - 4:GPIO5[14]
.equ BOTON3_PORT, 4
.equ BOTON3_PIN, 10
.equ BOTON3_BIT, 14
.equ BOTON3_MASK, (1 << BOTON3_BIT)

//Recursos del boton 4 - P6_7 - 4:GPIO5[15]
.equ BOTON4_PORT, 6
.equ BOTON4_PIN, 7
.equ BOTON4_BIT, 15
.equ BOTON4_MASK, (1 << BOTON4_BIT)


//Recursos de los botones
.equ BOTON_GPIO, 5
.equ BOTON_MASK, (BOTON1_MASK | BOTON2_MASK | BOTON3_MASK | BOTON4_MASK)

/* ================================================================= */
/* ===================== DISPLAYS ================================== */
/* ================================================================= */

//Recursos del Display 1 - P0_0 - 0:GPIO0[0]
.equ DISP_PORT, 0
.equ DISP_PIN, 0
.equ DISP_BIT, 0
.equ DISP_MASK, (1 << DISP_BIT)
.equ DISP_GPIO, 0


//Recursos del Display 2 - P0_1 - 0:GPIO0[1]
.equ DISP2_PORT, 0
.equ DISP2_PIN, 1
.equ DISP2_BIT, 1
.equ DISP2_MASK, (1<<DISP2_BIT)

//Recursos del Display 3 - P1_15 - 0:GPIO0[2]
.equ DISP3_PORT, 1
.equ DISP3_PIN, 15
.equ DISP3_BIT, 2
.equ DISP3_MASK, (1<<DISP3_BIT)

//Recursos del Display 4 - P1_17 - 0:GPIO0[3]
.equ DISP4_PORT, 1
.equ DISP4_PIN, 17
.equ DISP4_BIT, 3
.equ DISP4_MASK, (1<<DISP4_BIT)

//Recursos del Display - Segmento A - P4_0 0:GPIO2[0]
.equ SEG_A_PORT, 4
.equ SEG_A_PIN,0
.equ SEG_A_BIT, 0
.equ SEG_A_MASK, (1<<SEG_A_BIT)

//Recursos del Display - Segmento B - P4_1 - 0:GPIO2[1]
.equ SEG_B_PORT, 4
.equ SEG_B_PIN, 1
.equ SEG_B_BIT, 1
.equ SEG_B_MASK, (1<<SEG_B_BIT)

//Recursos del Display - Segmento C - P4_2 - 0:GPIO2[2]
.equ SEG_C_PORT, 4
.equ SEG_C_PIN, 2
.equ SEG_C_BIT, 2
.equ SEG_C_MASK, (1<<SEG_C_BIT)

//Recursos del Display - Segmento D - P4_3 - 0:GPIO2[3]
.equ SEG_D_PORT, 4
.equ SEG_D_PIN, 3
.equ SEG_D_BIT, 3
.equ SEG_D_MASK, (1<<SEG_D_BIT)

//Recursos del Display - Segmento E - P4_4 - 0:GPIO2[4]
.equ SEG_E_PORT, 4
.equ SEG_E_PIN, 4
.equ SEG_E_BIT, 4
.equ SEG_E_MASK, (1<<SEG_E_BIT)

//Recursos del Display - Segmento F - P4_5 - 0:GPIO2[5]
.equ SEG_F_PORT, 4
.equ SEG_F_PIN, 5
.equ SEG_F_BIT, 5
.equ SEG_F_MASK, (1<<SEG_F_BIT)

//Recursos del Display - Segmento G - P4_6 - 0:GPIO2[6]
.equ SEG_G_PORT, 4
.equ SEG_G_PIN, 6
.equ SEG_G_BIT, 6
.equ SEG_G_MASK, (1<<SEG_G_BIT)

//Recursos del Display - Todos los segmentos
.equ SEG_GPIO, 2
.equ SEG_MASK, (SEG_A_MASK|SEG_B_MASK|SEG_C_MASK|SEG_D_MASK|SEG_E_MASK|SEG_F_MASK|SEG_G_MASK)

.equ DISP_ALL_MASK, (DISP_MASK|DISP2_MASK|DISP3_MASK|DISP4_MASK)


/****************************************************************************/
/* Vector de interrupciones                                                 */  // NO TOCAR
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

    .section .data          // Define la sección de variables (RAM)
espera:
    .zero 1                 // Variable compartida con el tiempo de espera

/****************************************************************************/
/* Programa principal                                                       */  
/****************************************************************************/

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Llama a una subrutina existente en flash para configurar los leds
    LDR R1,=leds_init
    BLX R1

    // Llama a una subrutina para configurar el systick
    BL systick_init

    // Configura los pines de los leds como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SEG_A_PORT << 7 | SEG_A_PIN << 2)]
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]
    STR R0,[R1,#(SEG_D_PORT << 7 | SEG_D_PIN << 2)]
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]
    STR R0,[R1,#(SEG_G_PORT << 7 | SEG_G_PIN << 2)]

    // Para los display
    STR R0,[R1,#(DISP_PORT << 7 | DISP_PIN << 2)]
    STR R0,[R1,#(DISP2_PORT << 7 | DISP2_PIN << 2)]
    STR R0,[R1,#(DISP3_PORT << 7 | DISP3_PIN << 2)]
    STR R0,[R1,#(DISP4_PORT << 7 | DISP4_PIN << 2)]

   // Configura los pines de los botones como gpio con pull-down
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(BOTON1_PORT << 7 | BOTON1_PIN << 2)]
    STR R0,[R1,#(BOTON2_PORT << 7 | BOTON2_PIN << 2)]
    STR R0,[R1,#(BOTON3_PORT << 7 | BOTON3_PIN << 2)]
    STR R0,[R1,#(BOTON4_PORT << 7 | BOTON4_PIN << 2)]

    // Apaga todos los bits gpio de los leds
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]

    // Configura los bits gpio de los leds como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#(SEG_GPIO << 2)]
    ORR R0,#SEG_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]


    LDR R0,[R1,#(DISP_GPIO << 2)]
    ORR R0,#DISP_ALL_MASK
    STR R0,[R1,#(DISP_GPIO << 2)]

    // Configura los bits gpio de los botones como entradas
/*    LDR R0,[R1,#(TEC_GPIO << 2)]
    AND R0,#~TEC_MASK
    STR R0,[R1,#(TEC_GPIO << 2)]  */

    // Configura los bits gpio de los BOTONES como entradas
    LDR R0,[R1,#(BOTON_GPIO << 2)]
    AND R0,#~BOTON_MASK
    STR R0,[R1,#(BOTON_GPIO << 2)]

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0   //DIRECCION DONDE EMPIEZAN TODOS LOS GPIO
    LDR R5,=GPIO_NOT0

refrescar:
    // Define el estado actual de los leds como todos apagados
    MOV   R3,#0x00
    // Carga el estado actual de los botones
    LDR   R0,[R4,#(BOTON_GPIO << 2)]

    // Verifica el estado del bit correspondiente a el boton uno
    ANDS  R1,R0,#(1 << BOTON1_BIT)
    // Si la tecla esta apretada
    IT    EQ
    // Enciende el bit del segmento C
    ORREQ R3,#(1 << SEG_C_BIT)

    // Prende el segmento B si la tecla dos esta apretada
    ANDS  R1,R0,#(1 << BOTON2_BIT)
    IT    EQ
    ORREQ R3,#(1 << SEG_B_BIT)

    // Prende el segmento E si la tecla tres esta apretada
    ANDS  R1,R0,#(1 << BOTON3_BIT)
    IT    EQ
    ORREQ R3,#(1 << SEG_E_BIT)

    // Prende el segmento F si la tecla cuatro esta apretada
    ANDS  R1,R0,#(1 << BOTON4_BIT)
    IT    EQ
    ORREQ R3,#(1 << SEG_F_BIT)

    // Actualiza las salidas con el estado definido para los SEGs
    STR   R3,[R4,#(SEG_GPIO << 2)]

    // Repite el lazo de refresco indefinidamente
    B     refrescar
stop:
    B stop
    .pool                   // Almacenar las constantes de código
    .endfunc

/****************************************************************************/
/* Rutina de inicialización del SysTick                                     */
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
    LDR R0,=#(480 - 1)
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
    .pool                   // Almacena las constantes de código
    .endfunc

/****************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                      */
/****************************************************************************/
    .func systick_isr
systick_isr:
    LDR  R0,=espera         // Apunta R0 a espera
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
    .pool                   // Almacena las constantes de código
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

