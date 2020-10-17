PROCESSOR 16F887
    #include <xc.inc>
    ;configuración de los fuses
    CONFIG FOSC=INTRC_NOCLKOUT
    CONFIG WDTE=OFF
    CONFIG PWRTE=ON
    CONFIG MCLRE=OFF
    CONFIG CP=OFF
    CONFIG CPD=OFF
    CONFIG BOREN=OFF
    CONFIG IESO=OFF
    CONFIG FCMEN=OFF
    CONFIG LVP=OFF
    CONFIG DEBUG=ON
    
    
    CONFIG BOR4V=BOR40V
    CONFIG WRT=OFF
    
    PSECT udata
 tick:
    DS 1
 counter:
    DS 1
 counter2:
    DS 1
   
    PSECT code
    delay:
    movlw 0xFF
    movwf counter
    counter_loop:
    movlw 0xFF
    movwf tick
    tick_loop:
    decfsz tick,f
    goto tick_loop
    decfsz counter,f
    goto counter_loop
    return
    
PSECT resetVec,class=CODE,delta=2
	PAGESEL main
	goto main
	
PSECT isr,class=CODE,delta=2
	isr:
        btfss INTCON,1
	retfie
	
	bcf INTCON,1
	movlw 0x11
	GOTO ENCENDER
	retfie
	
PSECT main,class=CODE,delta=2
	main:
    clrf INTCON
    movlw 0b11010000
    movwf INTCON
    BANKSEL OSCCON
    movlw 0b01110101
    movwf   OSCCON
    BANKSEL PORTA
    clrf    PORTA
    BANKSEL PORTB
    clrf    PORTB
    movlw   0XFF
    BANKSEL TRISB
    movwf   TRISB
    BANKSEL ANSEL
    movlw   0x00
    movwf   ANSEL
    BANKSEL TRISA
    clrf    TRISA
    loop:
    BANKSEL PORTA
    call delay
    movlw 0x01
    xorwf PORTA,f
    goto loop
    
     ENCENDER:
  BANKSEL TRISC
  clrf TRISC
  BANKSEL PORTC
  clrf PORTC
  movlw 0b01111111
  movwf PORTC
  retfie
    END