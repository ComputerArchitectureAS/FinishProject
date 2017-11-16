; UARTIntTestMain.s
; Runs on LM4F120/TM4C123
; Tests the UART0 to implement bidirectional data transfer to and from a
; computer running PuTTY.  This time, interrupts and FIFOs
; are used.
; This file is named "UART2" because it is the second UART example.
; It is not related to the UART2 module on the microcontroller.
; Daniel Valvano
; September 12, 2013

;  This example accompanies the book
;  "Embedded Systems: Real Time Interfacing to Arm Cortex M Microcontrollers",
;  ISBN: 978-1463590154, Jonathan Valvano, copyright (c) 2015
;  Program 5.11 Section 5.6, Program 3.10
;
;Copyright 2015 by Jonathan W. Valvano, valvano@mail.utexas.edu
;   You may use, edit, run or distribute this file
;   as long as the above copyright notice remains
;THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
;OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
;MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
;VALVANO SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL,
;OR CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
;For more information about my classes, my research, and my books, see
;http://users.ece.utexas.edu/~valvano/

; U0Rx (VCP receive) connected to PA0
; U0Tx (VCP transmit) connected to PA1

; standard ASCII symbols
CR                 EQU 0x0D ;/r
LF                 EQU 0x0A ;/n
BS                 EQU 0x08 ;backspace
ESC                EQU 0x1B ;escape
SPA                EQU 0x20 ;space
DEL                EQU 0x7F ;delete

; functions in PLL.s
        IMPORT PLL_Init ;import label PLL_Init but EXPORT must be declared in PLL.s file

; functions UART.s
        IMPORT UART_Init
        IMPORT UART_InChar
        IMPORT UART_OutChar
	    ;functions in portFConfiguration.s
		IMPORT GPIOF_Init
		IMPORT RED_LED_ON
		IMPORT CHECK_SW2
		;new import sw1
        IMPORT CHECK_SW1
		;new import BLUE_LED
		IMPORT BLUE_LED_ON
		;new import GREEN_LED
		IMPORT GREEN_LED_ON
		;new import LEDs_OFF
		IMPORT LEDs_OFF
		
			
		AREA    DATA, ALIGN=2

        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT Start

    ALIGN                           ; make sure the end of this section is aligned

;---------------------OutCRLF---------------------
; Output a CR,LF to UART to go to a new line
; Input: none
; Output: none
OutCRLF ;perform /r/n
    PUSH {LR}                       ; save current value of LR
    MOV R0, #CR                     ; R0 = CR (<carriage return>);/r
    BL  UART_OutChar                ; send <carriage return> to the UART`
    MOV R0, #LF                     ; R0 = LF (<line feed>)/n
    BL  UART_OutChar                ; send <line feed> to the UART
    POP {PC}                        ; restore previous value of LR into PC (return)

Start
    BL  PLL_Init                    ; set system clock to 50 MHz
    BL  UART_Init                   ; initialize UART
	BL	GPIOF_Init
    BL  OutCRLF                     ; go to a new line
	
;-----------------------------------------------------------------------------
; @version 8 july 2017
; @author Alexey Titov & Shir Bentabou
;-----------------------------------------------------------------------------	
	
loop
;------------------------------------------------------------------------------
	BL UART_InChar
	CMP R0,#0x54
	BNE loop
;--------------------------------------SW1+SW2---------------------------------
positions	
	BL	CHECK_SW1
	CMP R6,#0x00
	BNE position3
	BL	CHECK_SW2
	CMP R5,#0x00
	BNE position2
    MOV R0, #4                 ; R0 = 4
	;Do reg-arg if 0 then set zero-flag to 1 else to 0
	BL  UART_OutChar           ; echo the character back to the UART
	BL  OutCRLF                ; echo the character back to the UART
	BL	RED_LED_ON
	
    B   delay
;-----------------------------------------SW1------------------------------------
position2
	MOV R0, #2                 ; R0 = 2
	BL  UART_OutChar           ; echo the character back to the UART
	BL  OutCRLF                ; echo the character back to the UART
	BL	BLUE_LED_ON
	
	B   delay	
;-----------------------------------------SW2------------------------------------
position3
	MOV R0, #3                 ; R0 = 3
	BL	CHECK_SW2
	CMP R5,#0x00
	BNE position1
	BL  UART_OutChar           ; echo the character back to the UART
	BL  OutCRLF                ; echo the character back to the UART
	BL	GREEN_LED_ON
	
	B   delay
;--------------------------------------NO SW1+SW2--------------------------------
position1
	MOV R0, #1                 ; R0 = 1
	BL  UART_OutChar           ; echo the character back to the UART
	BL  OutCRLF                ; echo the character back to the UART
	BL	LEDs_OFF
	
	B   delay
;-------------------------------------delay-------------------------------------
delay
	MOV R3,#16
	;for(R3=16;R3>0;R3--)
for1
	MOV R4,#254
	;for(R4=254;R4>0;R4--)
for2	
	MOV R5,#254
	;for(R5=254;R5>0;R5--)
for3
	SUB R5,R5,#1				;R5--
	CMP R5,#0x00
	BNE for3

	SUB R4,R4,#1				;R4--
	CMP R4,#0x00
	BNE for2
	
	SUB R3,R3,#1				;R3--
	CMP R3,#0x00
	BNE for1
	
	B loop

    ALIGN                       ; make sure the end of this section is aligned
    END                         ; end of file
