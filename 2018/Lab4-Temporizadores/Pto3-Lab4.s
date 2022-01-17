                .cpu cortex-m4 // Indica el procesador de destino
                .syntax unified // Habilita las instrucciones Thumb-2
                .thumb // Usar instrucciones Thumb y no ARM
                .include "configuraciones/lpc4337.s"
                .include "configuraciones/rutinas.s"
/****************************************************************************/
/* Definiciones de macros */
/****************************************************************************/

/************************************ LEDS **********************************/
//Recursos utilizados por el led rojo
                .equ LED_ROJO_PORT, 6
                .equ LED_ROJO_PIN, 9

//Recursos utilizados por el led azul
                .equ LED_AZUL_PORT,6
                .equ LED_AZUL_PIN, 11

/****************************** BOTONES *************************************/

// Recursos utilizados por el primer boton
                .equ BOTON_1_PORT, 4
                .equ BOTON_1_PIN, 8
                .equ BOTON_1_BIT, 12
                .equ BOTON_1_MASK, (1 << BOTON_1_BIT)

// Recursos utilizados por el segundo boton
                .equ BOTON_2_PORT, 4
                .equ BOTON_2_PIN, 9
                .equ BOTON_2_BIT, 13
                .equ BOTON_2_MASK, (1 << BOTON_2_BIT)

// Recursos utilizados por el tercer boton
                .equ BOTON_3_PORT, 4
                .equ BOTON_3_PIN, 10
                .equ BOTON_3_BIT, 14
                .equ BOTON_3_MASK, (1 << BOTON_3_BIT)

// Recursos utilizados por el cuarto boton
                .equ BOTON_4_PORT, 6
                .equ BOTON_4_PIN, 7
                .equ BOTON_4_BIT, 15
                .equ BOTON_4_MASK, (1 << BOTON_4_BIT)

// Recursos utilizados por TODOS botones 
                .equ BOTONES_GPIO, 5
                .equ BOTONES_MASK, (BOTON_1_MASK | BOTON_2_MASK | BOTON_3_MASK | BOTON_4_MASK)
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
                .word   handler+1       // 15: System tick service routine
                .word   handler+1       // 16: IRQ 0: DAC service routine
                .word   handler+1       // 17: IRQ 1: M0APP service routine
                .word   handler+1       // 18: IRQ 2: DMA service routine
                .word   0               // 19: Reserved entry
                .word   handler+1       // 20: IRQ 4: FLASHEEPROM service routine
                .word   handler+1       // 21: IRQ 5: ETHERNET service routine
                .word   handler+1       // 22: IRQ 6: SDIO service routine
                .word   handler+1       // 23: IRQ 7: LCD service routine
                .word   handler+1       // 24: IRQ 8: USB0 service routine
                .word   handler+1       // 25: IRQ 9: USB1 service routine
                .word   handler+1       // 26: IRQ 10: SCT service routine
                .word   handler+1       // 27: IRQ 11: RTIMER service routine
                .word   handler+1       // 28: IRQ 12: TIMER0 service routine
                .word   handler+1       // 29: IRQ 13: TIMER1 service routine
                .word   timer_isr+1     // 30: IRQ 14: TIMER2 service routine
                .word   handler+1       // 31: IRQ 15: TIMER3 service routine
                .word   handler+1       // 32: IRQ 16: MCPWM service routine
                .word   handler+1       // 33: IRQ 17: ADC0 service routine
                .word   handler+1       // 34: IRQ 18: I2C0 service routine
                .word   handler+1       // 35: IRQ 19: I2C1 service routine
                .word   handler+1       // 36: IRQ 20: SPI service routine
                .word   handler+1       // 37: IRQ 21: ADC1 service routine
                .word   handler+1       // 38: IRQ 22: SSP0 service routine
                .word   handler+1       // 39: IRQ 23: SSP1 service routine
                .word   handler+1       // 40: IRQ 24: USART0 service routine
                .word   handler+1       // 41: IRQ 25: UART1 service routine
                .word   handler+1       // 42: IRQ 26: USART2 service routine
                .word   handler+1       // 43: IRQ 27: USART3 service routine
                .word   handler+1       // 44: IRQ 28: I2S0 service routine
                .word   handler+1       // 45: IRQ 29: I2S1 service routine
                .word   handler+1       // 46: IRQ 30: SPIFI service routine
                .word   handler+1       // 47: IRQ 31: SGPIO service routine
                .word   handler+1       // 48: IRQ 32: PIN_INT0 service routine
                .word   handler+1       // 49: IRQ 33: PIN_INT1 service routine
                .word   handler+1       // 50: IRQ 34: PIN_INT2 service routine
                .word   handler+1       // 51: IRQ 35: PIN_INT3 service routine
                .word   handler+1       // 52: IRQ 36: PIN_INT4 service routine
                .word   handler+1       // 53: IRQ 37: PIN_INT5 service routine
                .word   handler+1       // 54: IRQ 38: PIN_INT6 service routine
                .word   handler+1       // 55: IRQ 39: PIN_INT7 service routine
                .word   handler+1       // 56: IRQ 40: GINT0 service routine
                .word   handler+1       // 56: IRQ 40: GINT1 service routine
/****************************************************************************/
/* Definicion de variables globales */
/****************************************************************************/
                .section .data // Define la sección de variables (RAM)
BajoR:     .word 1000
AltoR:     .word 9000
BajoA:     .word 1000
AltoA:     .word 9000
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

                // Configura los pines de los leds como timer
                LDR R1,=SCU_BASE
                MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC5)
                STR R0,[R1,#(LED_ROJO_PORT << 7 | LED_ROJO_PIN << 2)]
                STR R0,[R1,#(LED_AZUL_PORT << 7 | LED_AZUL_PIN << 2)]

                //Configura los pines de los botones como entrada gpio
                MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
                STR R0,[R1,#(BOTON_1_PORT << 7 | BOTON_1_PIN << 2)]
                STR R0,[R1,#(BOTON_2_PORT << 7 | BOTON_2_PIN << 2)]
                STR R0,[R1,#(BOTON_3_PORT << 7 | BOTON_3_PIN << 2)]
                STR R0,[R1,#(BOTON_4_PORT << 7 | BOTON_4_PIN << 2)]

                //Configura los bits gpio de los botones como entradas
                LDR R1,=GPIO_DIR0  //Apunto al de direcciones (DIR determina si es entrada o salida)

                LDR R0,[R1,#(BOTONES_GPIO << 2)]  //cargo la configuracion de los botones
                AND R0,#~BOTONES_MASK             //le hago un and con la mascara invertida para poner un 0 en donde estan los botones
                STR R0,[R1,#(BOTONES_GPIO << 2)]  // lo vuelvo a escribir

                // Cuenta con clock interno
                LDR R1,=TIMER2_BASE
                MOV R0,#0x00
                STR R0,[R1,#CTCR]

                // Prescaler de 95 para una frecuencia de 1 MHz
                MOV R0,#95
                STR R0,[R1,#PR]      //Cargo prescaler register con un valor de 95 (divido la frecuencia del procesador,95Mhz/95=1Mhz)

                // El valor del periodo para
                LDR R0,=BajoR
                LDR R0,[R0]
                STR R0,[R1,#MR2]    //cargo un valor inicial para match2 (led rojo) 


                LDR R0,=BajoA
                LDR R0,[R0]
                STR R0,[R1,#MR3]       //cargo un valor inicial para match3 (led azul) 

                MOV R0,#( MR2I | MR3I) // configuro el registro match2 para que al llegar al match interrumpa
                STR R0,[R1,#MCR]     // y lo seteo 

                // Limpiar contador y pararlo
                MOV R0,#CRST          //cargo en R0 una constante (1 << 1) para que limpie el TC y PC y pare el TC 
                STR R0,[R1,#TCR]

                // Inicio del contador
                MOV R0,#CEN             //cargo en R0 una constante (1 << 0) para que empiece a contar (y CRST=0 ????!!!!)
                STR R0,[R1,#TCR]
                                                                  /*                                  EMR                       */
                // Cambio el estado del pin timer del led         /*             b11 b10 b9  b8  b7  b6  b5  b4  b3  b2  b1  b0    */
                LDR R1,=TIMER2_EMR                                /*             --- --- --- --- --- --- --- --- --- --- --- ---   */
                LDR R0,=0xF00                                     /*              1   1   1   1   0   0   0   0   0   0   0   0    */
                STR R0,[R1]      //configuro para que hagan toggle (led rojo y azul) cuando lleguen a match2/3 

                // Limpieza del pedido pendiente en el NVIC
                LDR R1,=NVIC_ICPR0
                MOV R0,(1 << 14)
                STR R0,[R1]

                // Habilitacion del pedido de interrupcion en el NVIC
                LDR R1,=NVIC_ISER0
                MOV R0,(1 << 14)
                STR R0,[R1]

                CPSIE I                 // Rehabilita interrupciones

                LDR R4,=GPIO_PIN0

main:           LDR R0,[R4,#(BOTONES_GPIO << 2)] // Leo el estado de los botones 

                ANDS R2,R0,#(1 << BOTON_1_BIT) // Veo si el boton 1 esta presionado 
                BNE SubirIntR

                ANDS R1,R0,#(1 << BOTON_2_BIT) // Veo si el boton 2 esta presionado 
                BNE BajarIntR

                ANDS R2,R0,#(1 << BOTON_3_BIT) // Veo si el boton 3 esta presionado
                BNE SubirIntA

                ANDS R1,R0,#(1 << BOTON_4_BIT) // Veo si el boton 4 esta presionado 
                BNE BajarIntA

                B main
stop:           B stop


              //  .pool                   // Almacenar las constantes de código
                .endfunc

SubirIntR:    

                LDR R0,=BajoR
                LDR R1,[R0]
                LDR R5,=AltoR
                LDR R6,[R5]
                LDR R2,=1000
                ADD R1,#200
                SUB R6,#200

                CMP R6,R2
                ITTE HI
                STRHI R1,[R0]
                STRHI R6,[R5]
                BLS main

ContenerB1:     LDR R1,[R4,#(BOTONES_GPIO << 2)]
                ANDS R2,R1,#(1 << BOTON_1_BIT)
                BNE ContenerB1
             

                B main

BajarIntR:    

                LDR R0,=BajoR
                LDR R1,[R0]
                LDR R5,=AltoR
                LDR R6,[R5]
                LDR R2,=9000
                SUB R1,#200
                ADD R6,#200


                CMP R6,R2
                ITTE LO
                STRLO R1,[R0]
                STRLO R6,[R5]
                BHS main

ContenerB2:     LDR R1,[R4,#(BOTONES_GPIO << 2)]
                ANDS R2,R1,#(1 << BOTON_2_BIT)
                BNE ContenerB2
              

                B main

SubirIntA:      LDR R0,=BajoA
                LDR R1,[R0]
                LDR R5,=AltoA
                LDR R6,[R5]
                LDR R2,=9000
                CMP R1,R2
                ITTTT LO
                ADDLO R1,#200
                STRLO R1,[R0]
                SUBLO R6,#200
                STRLO R6,[R5]

ContenerB3:     LDR R1,[R4,#(BOTONES_GPIO << 2)]
                ANDS R2,R1,#(1 << BOTON_3_BIT)
                BNE ContenerB3
                B main

BajarIntA:      LDR R0,=BajoA
                LDR R1,[R0]
                LDR R5,=AltoA
                LDR R6,[R5]
                LDR R2,=1000
                CMP R1,R2
                ITTTT HI
                SUBHI R1,#200
                STRHI R1,[R0]
                ADDHI R6,#200
                STRHI R6,[R5]

ContenerB4:     LDR R1,[R4,#(BOTONES_GPIO << 2)]
                ANDS R2,R1,#(1 << BOTON_4_BIT)
                BNE ContenerB4
                B main


/****************************************************************************/
/* Rutina de servicio para la interrupcion del timer                        */
/****************************************************************************/
                .func timer_isr
timer_isr:
                PUSH {R0,R1,R2,R3,R4,R5,R6,R7,R8,R9}
                // Limpio el flag de interrupcion
                LDR R3,=TIMER2_BASE
                LDR R0,[R3,#IR]
                STR R0,[R3,#IR]     //hay un 1 en [IR] y seteo ese bit

                LDR R1,=BajoR
                LDR R4,=AltoR
                LDR R6,=BajoA
                LDR R7,=AltoA
               

                CMP R0,0x4
                BEQ controlR
                CMP R0,0x8
                BEQ controlA
                CMP R0,0xC
                BEQ controlR



retornar:         POP {R0,R1,R2,R3,R4,R5,R6,R7,R8,R9}

                // Retorno
                BX  LR

                .pool                   // Almacenar las constantes de código
                .endfunc

controlR:

                LDR R5,[R3,#MR2]   //cargo el valor actual que tiene el match2
                
                LDR R2,[R3,#EMR]   //veo el estado actual del pulso (si esta en alto o en bajo)
                AND R2,#(1<<2)
                CMP R2,#0x00
                ITTT EQ
                LDREQ R1,[R1]
                ADDEQ R1,R5
                STREQ R1,[R3,#MR2]
                
                LDR R2,[R3,#EMR]  //veo el estado actual del pulso (si esta en alto o en bajo) 
                AND R2,#(1<<2)
                CMP R2,#0b100
                ITTT EQ
                LDREQ R4,[R4]
                ADDEQ R4,R5
                STREQ R4,[R3,#MR2]
                CMP R0,#0x4
                BEQ retornar



controlA:

                LDR R8,[R3,#MR3]       //cargo el valor actual que tiene el match3
                LDR R2,[R3,#EMR]       //veo el estado actual del pulso (si esta en alto o en bajo)
                AND R2,#(1<<3)
                CMP R2,#0x00
                ITTT EQ
                LDREQ R6,[R6]
                ADDEQ R6,R8
                STREQ R6,[R3,#MR3]
                LDR R2,[R3,#EMR]       //veo el estado actual del pulso (si esta en alto o en bajo)
                AND R2,#(1<<3)

                CMP R2,#0b1000
                ITTT EQ
                LDREQ R7,[R7]
                ADDEQ R7,R8
                STREQ R7,[R3,#MR3]

                B retornar


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
