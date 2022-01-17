/* Evaluacion Nro 3 – Chehin Juan Martin */

    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

// Recursos utilizados por el canal Rojo del led RGB
    .equ LED_R_PORT,    2
    .equ LED_R_PIN,     0
    .equ LED_R_BIT,     0
    .equ LED_R_MASK,    (1 << LED_R_BIT)
    .equ LED_GPIO,      5
/*    .equ LED_MASK,      ( LED_R_MASK | LED_G_MASK | LED_B_MASK )*/

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

// Recursos utilizados por el display del poncho
    .equ DIG_GPIO,      0
    .equ DIG_MASK,      ( DIG_1_MASK | DIG_2_MASK | DIG_3_MASK | DIG_4_MASK )



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

    .section .data          // Define la sección de variables (RAM)
espera:
    .zero 1                 // Variable compartida con el tiempo de espera

tabla:
    .byte   0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67

cuenta:
    .byte   0x18

activo:
    .byte   0x01

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

/*    // Llama a una subrutina existente en flash para configurar los leds
    LDR R1,=leds_init
    BLX R1
*/
    // Llama a una subrutina para configurar el systick
    BL systick_init

    // Configura los pines de los leds como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(LED_R_PORT << 7 | LED_R_PIN << 2)]


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


    // Apaga todos los bits gpio de los leds
    LDR R1,=GPIO_CLR0
    LDR R0,=LED_R_MASK
    STR R0,[R1,#(LED_GPIO << 2)]

    // Apaga todos los bits gpio de los digitos
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]

    // Configura los bits gpio de los leds como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#(LED_GPIO << 2)]
    ORR R0,#LED_R_MASK
    STR R0,[R1,#(LED_GPIO << 2)]

    // Configura los bits gpio de los leds de los segmentos del display como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#(SEG_GPIO << 2)]    // Antes DIG_GPIO
    ORR R0,#SEG_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]

    // Configura los bits GPIO de los digitos como salidas
    LDR R0,[R1,#(DIG_GPIO << 2)]
    ORR R0,#DIG_MASK
    STR R0,[R1,#(DIG_GPIO << 2)]

    // Configura los bits gpio de los botones como entradas
    LDR R0,[R1,#(BOT_GPIO << 2)]
    AND R0,#~BOT_MASK
    STR R0,[R1,#(BOT_GPIO << 2)]


    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0
    LDR R5,=GPIO_CLR0
    LDR R6,=GPIO_SET0

    LDR R9,=tabla		//apunto a la tabla
    MOV R11,0x7F                // tomo el valor 8 para limpiar todos los digitos

refrescar:

// Define el estado actual de los leds como todos apagados
    MOV   R3,#0x00
    // Carga el estado arctual de las teclas
    LDR   R0,[R4,#(BOT_GPIO << 2)]

    // Verifica el estado del bit correspondiente a la tecla uno
    ANDS  R1,R0,#(1 << BOT_1_BIT)
    // Si la tecla esta apretada
    BNE restart

    // Verifica el estado del bit correspondiente a la tecla dos
    ANDS  R1,R0,#(1 << BOT_2_BIT)
    // Si la tecla esta apretada
    BNE parar

    // Verifica el estado del bit correspondiente a la tecla tres
    ANDS  R1,R0,#(1 << BOT_3_BIT)
    // Si la tecla esta apretada
    BNE seguir


//TRANSFORMAR EL PINCHE HEXA A DECIMAL
    LDR R0,=cuenta      //ubicacion variable global
    MOV R2,#0x0A        // valor diez en decimal
    LDRB R1,[R0]        // valor de la cuenta nro en hexa
    UDIV R0,R1,R2       // guardo en R0 el valor de la decena DIVIDIENDO EL NRO EN HEXA EN A
    MUL R3,R0,R2        // multiplico el resultado de la division por A para obtener el resto
    LSL R0,#4           // Corro el valor de la decena a su lugar de decena :v
    SUB R3,R1,R3        // calculo el resto
    MUL R1,R3,R2        // multiplico el resto por A PARA SACAR EL VALOR DE LA UNIDAD
    UDIV R1,R1,R2       // divido el resto multiplicado por A en A OBTENIENDO EL VALOR DE LA UNIDAD
    ADD R0,R0,R1        // SUMO LA UNIDAD CON LA DECENA YA PUESTA EN SU LUGAR


//CARGA LOS DISPLAYS
    MOV R2,#0xFF                        //FF para apagar todos los segmentos
    STR R2,[R5]                         //apago todos los segmentos GUARDANDO FF EN GPIO_CLR0
    MOV R2,#0b1                         //nose xq pero si guardo esto en GPIO_SET0 habilito el display 1
    STRB R2,[R6]                        //habilita el display 1
    STR R11,[R5,#(SEG_GPIO << 2)]       //apaga todos los segmentos creo nose xq lo hace o si lo de arriba no lo hace en realidad
    AND R10,R0,0x0F                     //mascara al numero para obtener la unidad
    LDRB R3,[R9,R10]                    //lo busco al valor de la unidad en la tabla
    STRB R3,[R6,#(SEG_GPIO << 2)]       //prendo los segmentos del numero de arriba
    BL demora                           //demoro para q se multiplexe xD

    MOV R2,#0xFF
    STR R2,[R5]
    MOV R2,#0b10                        //numero magico para el display 2
    STRB R2,[R6]
    STR R11,[R5,#(SEG_GPIO << 2)]       //idem anterior display
    AND R10,R0,0xF0                     //mascara para la decena
    LSR R10,#4                          //hago la decena valor osea 20 lo hago 2
    LDRB R3,[R9,R10]                    //busco el valor de la decena en la tabla
    STRB R3,[R6,#(SEG_GPIO << 2)]       //prendo los segmentos
    BL demora                           //demora multiplexado

    B refrescar

restart:
    LDR R0,=cuenta
    MOV R2,0x18
    STRB R2,[R0]
    B refrescar

parar:
    LDR R0,=activo
    MOV R1,#0
    STRB R1,[R0]
    B refrescar

seguir:
    LDR R0,=activo
    MOV R1,#1
    STRB R1,[R0]
    B refrescar

demora:
    MOV R7,#0
retardo:
    ADD R7,#1
    CMP R7,#0x10000
    BNE retardo
    MOV R7,#0
    BX LR

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

    // Configurar el desborde para un periodo de 100 ms (en lab 1 seg)
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
    .pool                   // Almacena las constantes de código
    .endfunc

/****************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                      */
/****************************************************************************/
    .func systick_isr
systick_isr:
    LDR R0,=activo          //ubicacion variable global que para el relos
    LDRB R0,[R0]            //valor de la bandera global que para o sigue el relos
    CMP R0,0                // si esta en cero, desactivado
    BEQ systick_exit        // salgo del systick sin modificar un carajo
    LDR  R0,=espera         // Apunta R0 a espera
    LDRB R1,[R0]            // Carga el valor de espera
    SUBS R1,#1              // Decrementa el valor de espera
    BHI  systick_exit       // Espera > 0, No pasaron 10 veces
    LDR R2,=cuenta          //ubicacion variable global que tiene el valor del relog en hexa
    LDRB R3,[R2]            //valor actual del relos
    CMP R3,0
    ITT HS                  // si es mayor o igual que cero
    SUBHS R3,#1             // le resto uno al valor del relog
    STRBHS R3,[R2]          // guardo el nuevo valor del relog
    ITT LS                  // si es menor
    MOVLS R3,#0x18          // cambio el valor a 24
    STRBLS R3,[R2]          // guardo el nuevo valor del relog
    MOV  R1,#20             // Vuelvo a carga espera con 10 iterciones
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

