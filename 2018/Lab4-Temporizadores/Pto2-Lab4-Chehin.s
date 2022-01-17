/* Chehin Juan Martin

2) Utilizando los botones 3 y 4 modificar la frecuencia de destello del LED Rojo en pasos de a
2hz, de 1hz a 20hz como máximo.

• B3 sube frecuencia de destello LED Rojo.
• B4 baja frecuencia de destello LED Rojo

*/
    .cpu cortex-m4       // Indica el procesador de destino
    .syntax unified      // Habilita las instrucciones Thumb-2
    .thumb               // Usar instrucciones Thumb y no ARM
    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/*tabla:  .word 0x7A120
        .word 0x3D090
        .word 0x28B0A
        .word 0x1E848
        .word 0x186A0
        .word 0xCB735
        .word 0x11704
        .word 0x0F424
        .word 0x0D903
        .word 0x0C350
*/

/****************************************************************************/
/* Definiciones de macros */
/****************************************************************************/

// Recursos utilizados por el canal Rojo del led RGB
    .equ LED_R_PORT,    2
    .equ LED_R_PIN,     0
    .equ LED_R_BIT,     0
    .equ LED_R_MASK,    (1 << LED_R_BIT)

// Recursos utilizados por el led RGB
    .equ LED_GPIO,      5
    .equ LED_MASK,      ( LED_R_MASK )


/*******Recursos utilizados por las teclas ********************/


// Recursos utilizados por la tercera tecla (del poncho)
    .equ TEC_3_PORT,    4
    .equ TEC_3_PIN,     10
    .equ TEC_3_BIT,     14
    .equ TEC_3_MASK,    (1 << TEC_3_BIT)

// Recursos utilizados por la cuarta tecla (del poncho)
    .equ TEC_4_PORT,    6
    .equ TEC_4_PIN,     7
    .equ TEC_4_BIT,     15
    .equ TEC_4_MASK,    (1 << TEC_4_BIT)


// Recursos utilizados por el teclado
    .equ TEC_GPIO,      5
    .equ TEC_MASK,      ( TEC_3_MASK | TEC_4_MASK )


    /****************************************************************************/
    /*Vector de interrupciones*/
    /****************************************************************************/
    .section .isr       // Define una seccion especial para el vector
    .word stack         //  0: Initial stack pointer value
    .word reset+1       //  1: Initial program counter value
    .word handler+1     //  2: Non mascarable interrupt service routine
    .word handler+1     //  3: Hard fault system trap service routine
    .word handler+1     //  4: Memory manager system trap service routine
    .word handler+1     //  5: Bus fault system trap service routine
    .word handler+1     //  6: Usage fault system tram service routine
    .word 0             //  7: Reserved entry
    .word 0             //  8: Reserved entry
    .word 0             //  9: Reserved entry
    .word 0             // 10: Reserved entry
    .word handler+1     // 11: System service call trap service routine
    .word 0             // 12: Reserved entry
    .word 0             // 13: Reserved entry
    .word handler+1     // 14: Pending service system trap service routine
    .word handler+1     // 15: System tick service routine
    .word handler+1     // 16: IRQ 0: DAC service routine
    .word handler+1     // 17: IRQ 1: M0APP service routine
    .word handler+1     // 18: IRQ 2: DMA service routine
    .word 0             // 19: Reserved entry
    .word handler+1     // 20: IRQ 4: FLASHEEPROM service routine
    .word handler+1     // 21: IRQ 5: ETHERNET service routine
    .word handler+1     // 22: IRQ 6: SDIO service routine
    .word handler+1     // 23: IRQ 7: LCD service routine
    .word handler+1     // 24: IRQ 8: USB0 service routine
    .word handler+1     // 25: IRQ 9: USB1 service routine
    .word handler+1     // 26: IRQ 10: SCT service routine
    .word handler+1     // 27: IRQ 11: RTIMER service routine
    .word timer_isr+1   // 28: IRQ 12: TIMER0 service routine
    .word handler+1     // 29: IRQ 13: TIMER1 service routine
    .word handler+1     // 30: IRQ 14: TIMER2 service routine
    .word handler+1     // 31: IRQ 15: TIMER3 service routine
    .word handler+1     // 32: IRQ 16: MCPWM service routine
    .word handler+1     // 33: IRQ 17: ADC0 service routine
    .word handler+1     // 34: IRQ 18: I2C0 service routine
    .word handler+1     // 35: IRQ 19: I2C1 service routine
    .word handler+1     // 36: IRQ 20: SPI service routine
    .word handler+1     // 37: IRQ 21: ADC1 service routine
    .word handler+1     // 38: IRQ 22: SSP0 service routine
    .word handler+1     // 39: IRQ 23: SSP1 service routine
    .word handler+1     // 40: IRQ 24: USART0 service routine
    .word handler+1     // 41: IRQ 25: UART1 service routine
    .word handler+1     // 42: IRQ 26: USART2 service routine
    .word handler+1     // 43: IRQ 27: USART3 service routine
    .word handler+1     // 44: IRQ 28: I2S0 service routine
    .word handler+1     // 45: IRQ 29: I2S1 service routine
    .word handler+1     // 46: IRQ 30: SPIFI service routine
    .word handler+1     // 47: IRQ 31: SGPIO service routine
    .word handler+1     // 48: IRQ 32: PIN_INT0 service routine
    .word handler+1     // 49: IRQ 33: PIN_INT1 service routine
    .word handler+1     // 50: IRQ 34: PIN_INT2 service routine
    .word handler+1     // 51: IRQ 35: PIN_INT3 service routine
    .word handler+1     // 52: IRQ 36: PIN_INT4 service routine
    .word handler+1     // 53: IRQ 37: PIN_INT5 service routine
    .word handler+1     // 54: IRQ 38: PIN_INT6 service routine
    .word handler+1     // 55: IRQ 39: PIN_INT7 service routine
    .word handler+1     // 56: IRQ 40: GINT0 service routine
    .word handler+1     // 56: IRQ 40: GINT1 service routine
    /****************************************************************************/
    /*Programa principal*/
    /****************************************************************************/

        .global reset       // Define el punto de entrada del código
        .section .text      // Define la sección de código (FLASH)
        .func main          // Inidica al depurador el inicio de una funcion
        tabla:  .word 0x7A120
                .word 0x3D090
                .word 0x28B0A
                .word 0x1E848
                .word 0x186A0
                .word 0xCB735
                .word 0x11704
                .word 0x0F424
                .word 0x0D903
                .word 0x0C350


    reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
        LDR R1,=VTOR
        LDR R0,=#0x10080000
        STR R0,[R1]

    // Configura los pines de los leds como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(LED_R_PORT << 7 | LED_R_PIN << 2)]

    // Configura los pines de las teclas como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLDOWN | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(TEC_4_PORT << 7 | TEC_4_PIN << 2)]
    STR R0,[R1,#(TEC_3_PORT << 7 | TEC_3_PIN << 2)]

    // Apaga todos los bits gpio de los leds
    LDR R1,=GPIO_CLR0
    LDR R0,=LED_MASK
    STR R0,[R1,#(LED_GPIO << 2)]

    // Configura los bits gpio de los leds como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#(LED_GPIO << 2)]
    ORR R0,#LED_MASK
    STR R0,[R1,#(LED_GPIO << 2)]

    // Configura los bits gpio de los botones como entradas
    LDR R0,[R1,#(TEC_GPIO << 2)]
    AND R0,#~TEC_MASK
    STR R0,[R1,#(TEC_GPIO << 2)]

    // Cuenta con clock interno
        LDR R1,=TIMER0_BASE
        MOV R0,#0x00
        STR R0,[R1,#CTCR]

    // Prescaler de 190 para una frecuencia de 2 MHz
        MOV R0,#190
        STR R0,[R1,#PR]

    // El valor del periodo para 10 Hz
        LDR R0,=100000
        STR R0,[R1,#MR3]

    // El registro de match 3 provoca reset del contador
        MOV R0,#(MR3R | MR3I)
        STR R0,[R1,#MCR]

    // Limpieza del contador
        MOV R0,#CRST
        STR R0,[R1,#TCR]

    // Inicio del contador
        MOV R0,#CEN
        STR R0,[R1,#TCR]

    // Limpieza del pedido pendiente en el NVIC
        LDR R1,=NVIC_ICPR0
        MOV R0,(1 << 12)
        STR R0,[R1]

    // Habilitacion del pedido de interrupcion en el NVIC
        LDR R1,=NVIC_ISER0
        MOV R0,(1 << 12)
        STR R0,[R1]
        CPSIE I     // Rehabilita interrupciones

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0
//    LDR R5,=GPIO_NOT0

    LDR R6,=TIMER0_BASE

    MOV R0,#190   // de 2 Mhz

    //LDR R5,=tabla
    //LDR R0,=#0x10080000
    //STR R0,[R1]


refrescar:

    // Define el estado actual de los leds como todos apagados
    MOV   R3,#0x00
    // Carga el estado actual de las teclas
    LDR   R7,[R4,#(TEC_GPIO << 2)]

    // Verifica el estado del bit correspondiente a la tecla tres
    ANDS  R1,R7,#(1 << TEC_3_BIT)
    // Si la tecla no esta apretada
    IT    NE
    BNE   aumentar

    // Verifica el estado del bit correspondiente a la tecla cuatro
    ANDS  R1,R7,#(1 << TEC_4_BIT)
    // Si la tecla no esta apretada
    IT    NE
    BNE   disminuir


    B     refrescar


    main:
        B main
        .pool           // Almacenar las constantes de código
        .endfunc

aumentar:

    SUB R0,#10

    STR R0,[R6,#PR]
    MOV   R8,#0x00000000
    B   demora

disminuir:


    ADD R0,#10
    STR R0,[R6,#PR]
    MOV   R8,#0x00000000
    B   demora

demora:
    ADD R8,#1
    CMP R8,#0x00FF0000
    BEQ refrescar
    B   demora


/* FALTARIA ACOTAR EL VALOR ENTRE 1 Y 20 HZ */

    /********************************************************/
    /*Rutina de servicio para la interrupcion del timer*/
    /********************************************************/

        .func timer_isr
        timer_isr:

    // Limpio el flag de interrupcion
        LDR R3,=TIMER0_BASE
        LDR R0,[R3,#IR]
        STR R0,[R3,#IR]

    // Cambio el estado del pin GPIO del led
        LDR R3,=GPIO_NOT0
        MOV R0,#LED_MASK
        STR R0,[R3,#LED_GPIO << 2]

    // Retorno
        BX  LR

    .pool       // Almacenar las constantes de código
    .endfunc

    /****************************************************************************/
    /*Rutina de servicio generica para excepciones*/
    /*Esta rutina atiende todas las excepciones no utilizadas en el programa.*/
    /*Se declara como una medida de seguridad para evitar que el procesador*/
    /*se pierda cuando hay una excepcion no prevista por el programador*/
    /****************************************************************************/
        .func   handler
    handler:
        LDR     R0,=set_led_1       // Apuntar al incio de una subrutina lejana
        BLX     R0                  // Llamar a la rutina para encender el led rojo
        B       handler             // Lazo infinito para detener la ejecucion
        .pool                       // Almacenar las constantes de codigo
        .endfunc
