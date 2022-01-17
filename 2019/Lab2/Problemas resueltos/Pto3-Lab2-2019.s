/*
Chehin Juan Martin

3) [Recomendado] Extraiga de la solución desarrollada por usted para el ejercicio 4 del laboratorio 1
el código necesario para implementar una subrutina transparente que 
realice el incremento de los segundos representados como dos dígitos BCD almacenados en dos direcciones
consecutivas de memoria. 

La misma recibe el valor numérico 1 en el registro R0 y la dirección de memoria donde está almacenado 
el dígito menos signiﬁcativo en el registro R1.

La subrutina devuelve en el registro R0 el valor 1 si ocurre un desbordamiento de los segundos
y se debe efectuar un incremento en los minutos, o 0 en cualquier otro caso.

 */


      .cpu cortex-m4
      .syntax unified
      .thumb

      .section .data

BCD1: .byte  0x05   // Segundo 20
BCD2: .byte  0x09


 .section .text
 .global reset

reset:
    LDR   R0,=BCD1          // Cargo el primer digito (mas a la izquierda en segundero)
    LDRB  R0,[R0]
    LDR   R1,=BCD2          // Cargo la direccion del segundo digito
    BL     incrementar

stop:   B stop   

incrementar:
    PUSH  {R2}              // Guardo en la pila para recuperar
    LDRB  R2,[R1]           // Obtengo el segundo numero
    CMP   R2,#9             // ¿Es el segundo digito es 9?
    IT   EQ
    CMPEQ   R0,#5             // ¿El primer digito es 5?
    ITTT    EQ
    MOVEQ   R0,#1
    POPEQ   {R2}              // Regreso R2 como estaba
    BXEQ    LR
                            // 
    ADD  R2,#1              // Sumo 1 al segundo digito
    STRB R2,[R1]            // Cargo en donde corresponde el segundo digito   
    MOV   R0,#0             // Seteo en 0 para avisarle al programa principal
    POP   {R2}              // Regreso R2 como estaba
    BX    LR                // Retorno program principal

  
/* Nota: En este problema no se consideraron los milisegundos ya que el enunciado no se aclara */



