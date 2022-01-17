/* CHEHIN JUAN MARTIN - FACET UNT

4) [Recomendado] Modiﬁque el programa del ejercicio anterior para que ahora opere sobre
numero BCD compactado de 4 dígitos. El mismo debe mostrarse en forma completa en los
cuatro displays, para lo cual deberá implementar una rutina de refresco que alterna el dígito
encendido lo suﬁcientemente rápido para que el ojo no perciba el cambio. Esta rutina debe
implementarse utilizando los servicios de interrupción del SysTick.


 */


    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
//macros

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

//vector de interrupciones
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
.word   redisplay+1   // 15: System tick service routine
.word   handler+1       // 16: Interrupt IRQ service routine

//datos

    .section .data          // Define la secciÃ³n de variables (RAM)
valor:
    .hword 0x0009                 // Dato a mostrar
tabla:
    .byte 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67 //Valores de los segmentos para cada numero BCD

    //programa principal
    .global reset           // Define el punto de entrada del cÃ³digo
    .section .text          // Define la secciÃ³n de cÃ³digo (FLASH)
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

    // Define los punteros para usar en el programa
    MOV R4,#0 //numero de display
    LDR R5,=GPIO_PIN0
    LDR R6,=GPIO_SET0
    LDR R7,=GPIO_CLR0
    LDR R8,=tabla
    LDR R9,=valor
    MOV R1,#0 //estado anterior

revalor:
    LDR R0,[R5,#(BUTTON_GPIO << 2)]
    LSR  R0,#12
    LDRH R3,[R9] //carga el valor actual
    MOV R12,#0x10000
delay:
    SUBS R12,#1
    BNE delay

    PUSH {R0,R1,R2,R3,R12}
    BL redisplay
    POP {R0,R1,R2,R3,R12}
    CMP R0,R1
    MOV R1,R0
    BEQ revalor
    CMP R0,#1
    UBFX R2,R3,#0,#4 //extraigo el primer digito
    BNE finsuma

then1:
    ADD R2,#1
    CMP R2,#10
    BNE else2

then2:
    MOV R2,#0
    BFI R3,R2,#0,#4 //inserto el primer digito
    UBFX R2,R3,#4,#4 //extraigo el segundo digito
    ADD R2,#1
    CMP R2,#10
    BNE else3

then3:
    MOV R2,#0
    BFI R3,R2,#4,#4 //inserto el segundo digito
    UBFX R2,R3,#8,#4 //extraigo el tercer digito
    ADD R2,#1
    CMP R2,#10
    BNE else4

then4:
    MOV R2,#0
    BFI R3,R2,#8,#4 //inserto el tercer digito
    UBFX R2,R3,#12,#4 //extraigo el cuarto digito
    ADD R2,#1
    CMP R2,#10
    BNE else5

then5:
    MOV R2,#0

else5:
    BFI R3,R2,#12,#4
    B finsuma
else4:
    BFI R3,R2,#8,#4
    B finsuma
else3:
    BFI R3,R2,#4,#4
    B finsuma
else2:
    BFI R3,R2,#0,#4 //inserto el primer digito
    B finsuma
finsuma:
    CMP R0,#2
    UBFX R2,R3,#0,#4 //extraigo el primer digito
    BNE finresta

thena:
    SUB R2,#1
    CMP R2,#-1
    BNE elseb

thenb:
    MOV R2,#9
    BFI R3,R2,#0,#4 //inserto el primer digito
    UBFX R2,R3,#4,#4 //extraigo el segundo digito
    SUB R2,#1
    CMP R2,#-1
    BNE elsec

thenc:
    MOV R2,#9
    BFI R3,R2,#4,#4 //inserto el segundo digito
    UBFX R2,R3,#8,#4 //extraigo el tercer digito
    SUB R2,#1
    CMP R2,#-1
    BNE elsed

thend:
    MOV R2,#9
    BFI R3,R2,#8,#4 //inserto el tercer digito
    UBFX R2,R3,#12,#4 //extraigo el cuarto digito
    SUB R2,#1
    CMP R2,#-1
    BNE elsee

thene:
    MOV R2,#9

elsee:
    BFI R3,R2,#12,#4
    B finresta
elsed:
    BFI R3,R2,#8,#4
    B finresta
elsec:
    BFI R3,R2,#4,#4
    B finresta
elseb:
    BFI R3,R2,#0,#4 //inserto el primer digito
    B finresta
finresta:
    STRH R3,[R9]

    B revalor

handler:
    BX LR

redisplay:
    //display actual R4
    //valor actual R3
    CMP R4,#0
    IT EQ
    UBFXEQ R2,R3,#0,#4 //extraigo el digito correspondiente
    CMP R4,#1
    IT EQ
    UBFXEQ R2,R3,#4,#4 //extraigo el digito correspondiente
    CMP R4,#2
    IT EQ
    UBFXEQ R2,R3,#8,#4 //extraigo el digito correspondiente
    CMP R4,#3
    IT EQ
    UBFXEQ R2,R3,#12,#4 //extraigo el digito correspondiente

    LDRB R1,[R8,R2] //convierte BCD a 7 segmentos (R8 es dir tabla)
    MOV R0,#0x0F
    STR R0,[R7] //clear a todos los display (disable)
    MOV R0,#1
    LSL R0,R4
    STR R0,[R6] //activa el display actual
    STR R1,[R5,#(DISP_SEGM_GPIO << 2)] //cargamos el numero 7 segmentos en el display
    ADD R4,#1
    CMP R4,#4
    IT EQ
    MOVEQ R4,#0
    BX LR
