/*  CHEHIN JUAN MARTIN

2) [Recomendado] Modiﬁque el proyecto de ejemplo suministrado por la cátedra en la guía de
solución, para que utilizando las cuatro teclas del poncho se prendan y apaguen los cuatro
segmentos verticales del display de la derecha. Tenga en cuenta la disposición de las conexiones
de los dispositivos de la placa y del poncho indicadas en la sección de información
complementaria.


 */


    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

/* ==========================SEGMENTOS ========================= */

// Recursos utilizados para el SEG_A
    .equ SEG_A_PORT,    4
    .equ SEG_A_PIN,     0
    .equ SEG_A_BIT,     0
    .equ SEG_A_MASK,    (1 << SEG_A_BIT)

// Recursos utilizados para el SEG_B
    .equ SEG_B_PORT,    4
    .equ SEG_B_PIN,     1
    .equ SEG_B_BIT,     1
    .equ SEG_B_MASK,    (1 << SEG_B_BIT)

// Recursos utilizados para el SEG_C
    .equ SEG_C_PORT,    4
    .equ SEG_C_PIN,     2
    .equ SEG_C_BIT,     2
    .equ SEG_C_MASK,    (1 << SEG_C_BIT)

// Recursos utilizados para el SEG_D
    .equ SEG_D_PORT,    4
    .equ SEG_D_PIN,     3
    .equ SEG_D_BIT,     3
    .equ SEG_D_MASK,    (1 << SEG_D_BIT)

// Recursos utilizados para el SEG_E
    .equ SEG_E_PORT,    4
    .equ SEG_E_PIN,     4
    .equ SEG_E_BIT,     4
    .equ SEG_E_MASK,    (1 << SEG_E_BIT)

// Recursos utilizados para el SEG_F
    .equ SEG_F_PORT,    4
    .equ SEG_F_PIN,     5
    .equ SEG_F_BIT,     5
    .equ SEG_F_MASK,    (1 << SEG_F_BIT)

// Recursos utilizados para el SEG_G
    .equ SEG_G_PORT,    4
    .equ SEG_G_PIN,     6
    .equ SEG_G_BIT,     6
    .equ SEG_G_MASK,    (1 << SEG_G_BIT)

// Recursos utilizados por el teclado , LED_SEGM_GPIO = SEG_GPIO
    .equ SEG_GPIO,      2   // prueba , hiba con '0'
    .equ SEG_MASK,      ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK )    // Mascara general de todos los segmentos

// Recursos utilizados para el SEG_DP
    .equ SEG_DP_PORT,    6
    .equ SEG_DP_PIN,     8
    .equ SEG_DP_BIT,     16
    .equ SEG_DP_GPIO,    5          // Tiene su propio GPIO
    .equ SEG_DP_MASK,    (1 << SEG_DP_BIT)

/*// Recursos utilizados por el canal Verde del led RGB
    .equ LED_G_PORT,    2
    .equ LED_G_PIN,     1
    .equ LED_G_BIT,     1
    .equ LED_G_MASK,    (1 << LED_G_BIT)

// Recursos utilizados por el canal Azul del led RGB
    .equ LED_B_PORT,    2
    .equ LED_B_PIN,     2
    .equ LED_B_BIT,     2
    .equ LED_B_MASK,    (1 << LED_B_BIT)

// Recursos utilizados por el led RGB
    .equ LED_GPIO,      5
    .equ LED_MASK,      ( LED_R_MASK | LED_G_MASK | LED_B_MASK ) */

/* ========================== BOTONES ========================= */

// Recursos utilizados por el boton 1
    .equ BOT_1_PORT,    4
    .equ BOT_1_PIN,     8
    .equ BOT_1_BIT,     12
    .equ BOT_1_MASK,    (1 << BOT_1_BIT)

// Recursos utilizados por el boton 2
    .equ BOT_2_PORT,    4
    .equ BOT_2_PIN,     9
    .equ BOT_2_BIT,     13
    .equ BOT_2_MASK,    (1 << BOT_2_BIT)

// Recursos utilizados por el boton 3
    .equ BOT_3_PORT,    4
    .equ BOT_3_PIN,     10
    .equ BOT_3_BIT,     14
    .equ BOT_3_MASK,    (1 << BOT_3_BIT)

// Recursos utilizados por el boton 4
    .equ BOT_4_PORT,    6
    .equ BOT_4_PIN,     7
    .equ BOT_4_BIT,     15
    .equ BOT_4_MASK,    (1 << BOT_4_BIT)

// Recursos utilizados por el boton aceptar
    .equ BOT_A_PORT,    3
    .equ BOT_A_PIN,     1
    .equ BOT_A_BIT,     8
    .equ BOT_A_MASK,    (1 << BOT_A_BIT)

// Recursos utilizados boton cancelar
    .equ BOT_C_PORT,    1
    .equ BOT_C_PIN,     2
    .equ BOT_C_BIT,     9
    .equ BOT_C_MASK,    (1 << BOT_C_BIT)

// Recursos utilizados por el teclado del poncho
    .equ BOT_GPIO,      5
    .equ BOT_MASK,      ( BOT_1_MASK | BOT_2_MASK | BOT_3_MASK | BOT_4_MASK | BOT_A_MASK | BOT_C_MASK )

/* ========================== DIGITOS ========================= */


// Recursos utilizados por el primer digito (DIG = DISP)
    .equ DIG_1_PORT,    0
    .equ DIG_1_PIN,     0
    .equ DIG_1_BIT,     0
    .equ DIG_1_MASK,    (1 << DIG_1_BIT)

// Recursos utilizados por el segundo digito
    .equ DIG_2_PORT,    0
    .equ DIG_2_PIN,     1
    .equ DIG_2_BIT,     1
    .equ DIG_2_MASK,    (1 << DIG_2_BIT)

// Recursos utilizados por el tercer digito
    .equ DIG_3_PORT,    1
    .equ DIG_3_PIN,     15
    .equ DIG_3_BIT,     2
    .equ DIG_3_MASK,    (1 << DIG_3_BIT)

// Recursos utilizados por el cuarto digito
    .equ DIG_4_PORT,    1
    .equ DIG_4_PIN,     17
    .equ DIG_4_BIT,     3           // Verificar
    .equ DIG_4_MASK,    (1 << DIG_4_BIT)

// Recursos utilizados por el teclado del poncho
    .equ DIG_GPIO,      0
    .equ DIG_MASK,      ( DIG_1_MASK | DIG_2_MASK | DIG_3_MASK | DIG_4_MASK )


/*// Recursos utilizados por la tercera tecla
    .equ TEC_3_PORT,    1
    .equ TEC_3_PIN,     2
    .equ TEC_3_BIT,     9
    .equ TEC_3_MASK,    (1 << TEC_3_BIT)


// Recursos utilizados por el teclado
    .equ TEC_GPIO,      0
    .equ TEC_MASK,      ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK ) */

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

    .section .data          // Define la secciÃ³n de variables (RAM)
espera:
    .zero 1                 // Variable compartida con el tiempo de espera

valor:
    .byte   0xB6            // Valor a cargar en el digito 1


/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset           // Define el punto de entrada del cÃ³digo
    .section .text          // Define la secciÃ³n de cÃ³digo (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

/*    // Llama a una subrutina existente en flash para configurar los leds
    LDR R1,=leds_init
    BLX R1

    // Llama a una subrutina para configurar el systick
    BL systick_init */

    // Configura los pines de los segmentos como gpio sin pull-up

    LDR R1,=SCU_BASE    // P0_0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)   // Cargo en R0 la configuracion del modulo SCU
    STR R0,[R1,#(SEG_A_PORT << 7 | SEG_A_PIN << 2)] // Muevo la configuracion de cada SCU para cada segmento
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]
    STR R0,[R1,#(SEG_D_PORT << 7 | SEG_D_PIN << 2)]
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]
    STR R0,[R1,#(SEG_G_PORT << 7 | SEG_G_PIN << 2)]
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)   // Aqui cambia la funcion a func4
    STR R0,[R1,#(SEG_DP_PORT << 7 | SEG_DP_PIN << 2)]


    // Configura los pines de las teclas como gpio con pull-DOWN

    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(BOT_1_PORT << 7 | BOT_1_PIN << 2)]
    STR R0,[R1,#(BOT_2_PORT << 7 | BOT_2_PIN << 2)]
    STR R0,[R1,#(BOT_3_PORT << 7 | BOT_3_PIN << 2)]
    STR R0,[R1,#(BOT_4_PORT << 7 | BOT_4_PIN << 2)]
    STR R0,[R1,#(BOT_A_PORT << 7 | BOT_A_PIN << 2)]
    STR R0,[R1,#(BOT_C_PORT << 7 | BOT_C_PIN << 2)]


    // Apaga todos los bits gpio de los digitos
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]

    // Configura los bits gpio de los leds como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#(SEG_GPIO << 2)]    // Antes DIG_GPIO
    ORR R0,#SEG_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]

    // NUEVAS 3 LINEAS

    // Configura los bits GPIO de los digitos como salidas (consultar)

    LDR R0,[R1,#(DIG_GPIO << 2)]
    ORR R0,#DIG_MASK
    STR R0,[R1,#(DIG_GPIO << 2)]


    // Configura los bits gpio de los botones como entradas
    LDR R0,[R1,#(BOT_GPIO << 2)]
    AND R0,#~BOT_MASK
    STR R0,[R1,#(BOT_GPIO << 2)]

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0
    LDR R5,=GPIO_NOT0

/* ************************************************ */

    MOV R0,#0
    LDR R1,=GPIO_SET0   // Apunto a la direcion del registro SET
    LDR R6,=GPIO_CLR0   // Apunto a la direccion del registro CLR
    MOV R2,#0xFF
    STR R2,[R6]         // Cargo FF en CLR
    MOV R2,#1           // Muevo para mandar un 1 al display 1

    STRB R2,[R1]        // Seteo el registro

    MOV R3,#0xff
    LDR R9,=valor


refrescar:

//Carga del valor al display

/*    STR R3,[R6,#(SEG_GPIO<<2)]
    LDRB R8,[R9,R0]
    STRB R8,[R1,#(SEG_GPIO<<2)]
*/

    // Define el estado actual de los DIGITOS como todos apagados
    MOV   R3,#0x00
    // Carga el estado actual de las teclas
    LDR   R0,[R4,#(BOT_GPIO << 2)]

    // Verifica el estado del bit correspondiente al BOTON uno
    ANDS  R1,R0,#(1 << BOT_1_BIT)
    // Si el BOTON esta apretado
    IT    EQ
    // Enciende el bit del SEGMENTO B
    ORREQ R3,#(1 << SEG_B_BIT)

    // Prende el DIGITO si EL BOTON 2 esta apretado
    ANDS  R1,R0,#(1 << BOT_2_BIT)
    IT    EQ
    ORREQ R3,#(1 << SEG_F_BIT)

    // Prende el SEGMENTO C si EL BOTON 3 esta apretado
    ANDS  R1,R0,#(1 << BOT_3_BIT)
    IT    EQ
    ORREQ R3,#(1 << SEG_C_BIT)

    // Prende el SEGMENTO E si EL BOTON 4 esta apretado
    ANDS  R1,R0,#(1 << BOT_4_BIT)
    IT    EQ
    ORREQ R3,#(1 << SEG_E_BIT)

    ORR R6,#(1 << DIG_1_BIT)    // Bit del display 1

    STR   R6,[R4,#(DIG_GPIO << 2)]

    // Actualiza las salidas con el estado definido para los leds
    STR   R3,[R4,#(SEG_GPIO << 2)]

    // Repite el lazo de refresco indefinidamente
    B     refrescar
stop:
    B stop
    .pool                   // Almacenar las constantes de cÃ³digo
    .endfunc

/****************************************************************************/
/* Rutina de inicializaciÃ³n del SysTick                                     */
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
    .pool                   // Almacena las constantes de cÃ³digo
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
    .pool                   // Almacena las constantes de cÃ³digo
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
