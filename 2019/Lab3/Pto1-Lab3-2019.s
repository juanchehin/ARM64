/* Chehin Juan Martin - 2019 - FACET UNT

1)Escriba un programa en lenguaje ensamblador del ARM-Cortex M4 para demostrar el funcionamiento
de las teclas y leds de la placa EDU-CIAA-NXP. En el ejemplo a desarrollar se debe
encender cada uno de los tres canales del LED RGB mientras se mantengas presionadas las
teclas 1 a 3. Ademas deberá destellar el led 3 una vez cada segundo utilizando la interrupción
periódica del SysTick.

*/

    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

// Recursos utilizados por el canal Rojo del led RGB
    .equ LED_R_PORT,    2			// Recomendacion 2019 - Cambiar "LED" por "Segmento"
    .equ LED_R_PIN,     0
    .equ LED_R_BIT,     0
    .equ LED_R_MASK,    (1 << LED_R_BIT)

// Recursos utilizados por el canal Verde del led RGB
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
    .equ LED_MASK,      ( LED_R_MASK | LED_G_MASK | LED_B_MASK )

// Recursos utilizados por la primera tecla
    .equ TEC_1_PORT,    1
    .equ TEC_1_PIN,     0
    .equ TEC_1_BIT,     4
    .equ TEC_1_MASK,    (1 << TEC_1_BIT)

// Recursos utilizados por la segunda tecla
    .equ TEC_2_PORT,    1
    .equ TEC_2_PIN,     1
    .equ TEC_2_BIT,     8
    .equ TEC_2_MASK,    (1 << TEC_2_BIT)

// Recursos utilizados por la tercera tecla
    .equ TEC_3_PORT,    1
    .equ TEC_3_PIN,     2
    .equ TEC_3_BIT,     9
    .equ TEC_3_MASK,    (1 << TEC_3_BIT)

// Recursos utilizados por el teclado
    .equ TEC_GPIO,      0
    .equ TEC_MASK,      ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK )

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

    // Llama a una subrutina para configurar el systick , para el primer lab no tocar
    BL systick_init

    // Configura los pines de los leds como gpio sin pull-up , aca empiezan los cambios
    LDR R1,=SCU_BASE		/* Apunta a la dirección de configuración de la primer para que es P0_0, después me corro 4 direcciones de memoria, una palabra por cada pata que me voy corriendo 4 direcciones de memoria, una palabra por cada pata que me voy corriendo dentro del puerto */
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)   // el dato del SCU_MODE_FUNC4 se encuentra en el PDF
    STR R0,[R1,#(LED_R_PORT << 7 | LED_R_PIN << 2)]
    STR R0,[R1,#(LED_G_PORT << 7 | LED_G_PIN << 2)]
    STR R0,[R1,#(LED_B_PORT << 7 | LED_B_PIN << 2)]

/*

Para saltar de una pata a la otra, como cada pata ocupa una palabra de configuración, debo saltar 4 direcciones

Para saltar de un puerto a otro, debo saltar de un puerto a otro (que son 32)

Para saltar de SCU_BASE, que es P0_0, hacia P0_1 me corro 4, si quiero saltar al P0_2 me corro desde la base 8

Si quiero saltar al puerto 1, pin 0, me corro 32 patas (cada pata es una palabra)

32 Palabras es 32*4 ,32 palabras, cada palabra son 4 bytes 

En SCU_BASE apunta a la configuración de P0_0

CADA PIN OCUPA UNA PALABRA DE CONFIGURACION

Para ir a P0_2 me corro 2 palabras, o sea 8 bytes

Para pasar al P1_0 

32 *4

32 = 2^5

4 = 2^2 

2^2 * 2^5 = 2^7

Si calculamos 2^7 = 128

Si quiero ir al puerto 3, me paro en SCU_BASE y me corro 3 * 128 = 3 * 2^7 que en assembler se escribe TEC_3_PORT << 7 (el TEC_3_PORT es un número, pero se pone el “TEC_3_PORT << 7 “por comodidad)

Desde P3_0 a P3_5 debo correrme 5 palabras, entonces me corro la cantidad de puertos * 128 + cantidad pines * 4, que es lo siguiente:

(TEC_1_PORT << 7 | TEC_1_PIN << 2)]
 

 TEC_1_PORT << 7: cantidad de puertos * 128 + …

| TEC_1_PIN << 2: Cantidad de pines corrido dos lugares (correr dos lugares es multiplicarlo 2^2 = 4)

Lo anterior es para entenderle, en realidad para aplicarlo no hace falta entenderlo, solo definir el puerto y el pin

128 = 2^7

Si a un número binario, y lo corro 1 lugar hacia la izquierda, lo estoy multiplicando por 2 
Si lo corro 2 lugares, lo estoy multiplicando por 4
Si lo corro 3 lugares, lo estoy multiplicando por 8
Multiplico por 2^ (cantidad de lugares)

Si corro 7 lugares, lo estoy multiplicando por 2 ^ 7
*/

    // Configura los pines de las teclas como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLDOWN | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)    // Modificar por PULL-UP
    STR R0,[R1,#(TEC_1_PORT << 7 | TEC_1_PIN << 2)]
    STR R0,[R1,#(TEC_2_PORT << 7 | TEC_2_PIN << 2)]
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

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0   //DIRECCION DONDE EMPIEZAN TODOS LOS GPIO
    LDR R5,=GPIO_NOT0

refrescar:
    // Define el estado actual de los leds como todos apagados
    MOV   R3,#0x00
    // Carga el estado arctual de las teclas
    LDR   R0,[R4,#(TEC_GPIO << 2)]

    // Verifica el estado del bit correspondiente a la tecla uno
    ANDS  R1,R0,#(1 << TEC_1_BIT)
    // Si la tecla esta apretada
    IT    EQ
    // Enciende el bit del canal rojo del led rgb
    ORREQ R3,#(1 << LED_R_BIT)

    // Prende el canal verde si la tecla dos esta apretada
    ANDS  R1,R0,#(1 << TEC_2_BIT)
    IT    EQ
    ORREQ R3,#(1 << LED_G_BIT)

    // Prende el canal azul si la tecla tres esta apretada
    ANDS  R1,R0,#(1 << TEC_3_BIT)
    IT    EQ
    ORREQ R3,#(1 << LED_B_BIT)

    // Actualiza las salidas con el estado definido para los leds
    STR   R3,[R4,#(LED_GPIO << 2)]

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

