
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.MODEL SMALL

.STACK 100H

.DATA
B DW ?
C DW ? 
KEY DW ? 
POS DW ?
W DW ? 
L DW ?
SPA DW ?
CNT DB ?
LOSE DB 'NO MORE TRIES LEFT.YOU LOST',0dh,0ah,'THE END $'
PROMPT DB 'Enter the word for other player to guess:  $'
STRING DB 100 DUP('$')        
EMPTY  DB '                   $'
ENDL DB 0dh,0ah,'$'
RNG DB 'The Length of the word is:             $'
ANS DB 100 DUP('$')      
HELL DB 0Dh,0Ah,'You Have 6 tries left',0DH,0AH,'GUESS A LETTER      $'
Abhi DB 'CONGRATULATIONS. YOU WON.$'
Wron DB 'WRONG:                                   ',0dh,0ah,'$'
WR DW ? 
.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX   ;INITIALIZE DS
    MOV ES,AX   ; AND ES
    MOV CNT,9
    MOV WR,0
    MOV SPA,0
    MOV AX,6
    INT 10H
    MOV AH,0CH
    MOV AL,1
    LINE1:

    MOV CX,450
    MOV DX,150
    
    LOOP1: 
        INT 10H
        INC CX
        CMP CX,590
        JLE LOOP1
    
        MOV CX,450
        INC DX
        CMP DX,151
        JLE LOOP1
    CALL GET_NAME   ;READ FILENAME  
    CALL CHANGE
    CALL CON       
    CALL ABHIS
    CALL HANGMAN
EXIT:
    MOV AH,4CH
    INT 21H
    MAIN ENDP

GET_NAME PROC NEAR
    PUSH AX
    PUSH DX
    PUSH DI
    MOV AH,9
    LEA DX,PROMPT
    INT 21H
    MOV AH,2
    MOV DL,0dh
    INT 21h
    MOV DL,0Ah
    INT 21h
    CLD
    LEA DI,STRING
    MOV AH,1
    
    READ_NAME:
    INT 21H
    CMP AL,0DH
    JE DONE
    STOSB
    JMP READ_NAME
    
    DONE:
    MOV AL,0DH
    STOSB 
    MOV AL,36
    STOSB 
    ;MOV AH,2
    ;MOV DL,0DH
    ;INT 21H
    ;MOV AH,2
    ;MOV DL,0Ah
    ;INT 21H
    
    POP DI
    POP DX
    POP AX
    RET
    
    GET_NAME ENDP
CHANGE PROC NEAR
    PUSH AX
    PUSH DX
    PUSH DI
    PUSH SI
    MOV B,0 
    LEA SI,STRING
TOP:
    LODSB
    CMP AL,0DH
    JE TOPS
    ADD B,1 
    CMP AL,32
    JE SPAC
    JMP TOP
SPAC:
    ADD SPA,1
    JMP TOP
TOPS:   
    POP SI
    POP AX
    POP DX
    POP DI
    RET
    CHANGE ENDP
CON PROC NEAR
    PUSH AX
    PUSH SI
    PUSH DI
    PUSH DX 
    LEA DI,RNG
    ADD DI,30
    MOV AX,B
    MOV W,AX
    XOR AX,AX
    MOV AX,SPA
    SUB W,AX
LEN:
    MOV AX,W
    MOV L,AX
    MOV BL,10
    DIV BL
    ADD AH,48
    MOV [DI],AH
    SUB DI,1
    MOV AH,0
    MOV W,AX
    CMP W,0
    JNE LEN
    ;MOV AH, 02 ;SET CURSOR POS
    ;MOV BH, 0
    ;MOV DH, 1 ;this goes below, and limit is 24
    ;MOV DL, 0 ;this goes right, and limit is 79
    ;INT 10h
    LEA DX,RNG
    MOV AH,9
    INT 21H
    POP DI
    POP DX
    POP AX
    POP SI
    RET
    CON ENDP
ABHIS PROC NEAR
    PUSH AX
    PUSH SI
    PUSH DI
    PUSH DX 
    LEA SI,STRING 
    LEA DI,ANS
AGA:
    LODSB
    CMP AL,0DH
    JE TOS
    CMP AL,32
    JE SPACE
    MOV AL,95
    STOSB
    MOV AL,32
    STOSB
    JMP AGA
SPACE:
    MOV AL,32
    STOSB 
    MOV AL,32
    STOSB  
    JMP AGA
TOS:
    MOV AL,0Dh
    STOSB
    MOV AL,0Ah
    STOSB
    MOV AL,36
    STOSB
    ;MOV [DI],0Dh
    ;ADD DI,1
    ;MOV [DI],0Ah
    ;ADD DI,1
    POP DX
    POP DI
    POP SI
    POP AX
    ret
    ABHIS ENDp   
HANGMAN PROC NEAR
    PUSH AX
    PUSH SI
    PUSH DI
    PUSH DX 
    MOV AX,B
    MOV W,AX
    XOR AX,AX
    MOV AX,SPA
    SUB W,AX
    JMP PRINT_STRING
LINE2:
    PUSH AX
    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV AL,1
     MOV CX,585
    MOV DX,50
    
    LOOP2: 
         
        INT 10H
        INC DX
        CMP DX,151
        JLE LOOP2
    
        MOV DX,50
        INC CX
        CMP CX,587
        JLE LOOP2
      POP DX
      POP CX
      POP AX
     JMP STQ
LINE3:
    PUSH AX
    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV AL,1
    MOV CX,527
    MOV DX,50
    
    LOOP3: 
         
        INT 10H
        INC CX
        CMP CX,585
        JLE LOOP3
      POP DX
      POP CX
      POP AX
     JMP STQ 
LINE4:
    PUSH AX
    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV AL,1
    MOV CX,527
    MOV DX,50
    
    LOOP4: 
         
        INT 10H
        INC DX
        CMP DX,65
        JLE LOOP4
        
        MOV DX,50
        INC CX
        CMP CX,126
        JLE LOOP4
      POP DX
      POP CX
      POP AX
     JMP STQ 
LINE5:
    PUSH AX
    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV AL,1
    MOV CX,515
    MOV DX,66
    
    HEAD_LOOP:
         
        INT 10H
        INC CX
        CMP CX,540
        JLE HEAD_LOOP
        
        INC DX
        MOV CX,515
        CMP DX,76
        JLE HEAD_LOOP
        POP DX
      POP CX
      POP AX
     JMP STQ
LINE6:
    PUSH AX
    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV AL,1
    MOV CX,527
    MOV DX,77
    BODY_LOOP:     
    INT 10H
    INC DX
    CMP DX,110
    JLE BODY_LOOP
    
    MOV DX,77
    INC CX
    CMP CX,526
    JLE BODY_LOOP
      POP DX
      POP CX
      POP AX
    JMP STQ
LINE7:
    PUSH AX
    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV AL,1
    MOV CX,524
    MOV DX,84
    
    LEFT_ARM_LOOP1:
        
        INT 10H
        SUB CX,3
        DEC DX
        CMP DX,75
        JGE LEFT_ARM_LOOP1
        
        MOV CX,523
    MOV DX,84
    
    LEFT_ARM_LOOP2:    
        
        INT 10H
        SUB CX,3
        DEC DX
        CMP DX,75
        JGE LEFT_ARM_LOOP2
       
        MOV CX,522
    MOV DX,84
    
    LEFT_ARM_LOOP3:    
        
        INT 10H
        SUB CX,3
        DEC DX
        CMP DX,75
        JGE LEFT_ARM_LOOP3 
     POP DX
      POP CX
      POP AX
    JMP STQ
 LINE8:
    PUSH AX
    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV AL,1
    MOV CX,529
    MOV DX,84
    
    RIGHT_ARM_LOOP1:
        
        INT 10H
        ADD CX,3
        DEC DX
        CMP DX,75
        JGE RIGHT_ARM_LOOP1
        
        MOV CX,528
        MOV DX,84
    
    RIGHT_ARM_LOOP2:    
        
        INT 10H
        ADD CX,3
        DEC DX
        CMP DX,75
        JGE RIGHT_ARM_LOOP2
    
    MOV CX,527
    MOV DX,84
    
    RIGHT_ARM_LOOP3:    
        
        INT 10H
        ADD CX,3
        DEC DX
        CMP DX,75
        JGE RIGHT_ARM_LOOP3
        
     POP DX
      POP CX
      POP AX
    JMP STQ
 LINE9:
    PUSH AX
    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV AL,1
    MOV CX,527
    MOV DX,100
    
    LEFT_LEG_LOOP1:
        
        INT 10H
        SUB CX,2
        INC DX
        CMP DX,114
        JLE LEFT_LEG_LOOP1
        
    MOV CX,526
    MOV DX,100
    
    LEFT_LEG_LOOP2:    
        
        INT 10H
        SUB CX,2
        INC DX
        CMP DX,114
        JLE LEFT_LEG_LOOP2
        
    MOV CX,525
    MOV DX,100
    
    LEFT_LEG_LOOP3:    
        
        INT 10H
        SUB CX,2
        INC DX
        CMP DX,114
        JLE LEFT_LEG_LOOP3 
     POP DX
      POP CX
      POP AX
    JMP STQ
LINE10:        
    PUSH AX
    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV AL,1   
    MOV CX,527
    MOV DX,100
    
    RIGHT_LEG_LOOP1:
        
        INT 10H
        ADD CX,2
        INC DX
        CMP DX,114
        JLE RIGHT_LEG_LOOP1
        
        MOV CX,526
        MOV DX,100
    
    RIGHT_LEG_LOOP2:    
        
        INT 10H
        ADD CX,2
        INC DX
        CMP DX,114
        JLE RIGHT_LEG_LOOP2
        
        MOV CX,525
        MOV DX,100
    
    RIGHT_LEG_LOOP3:    
        
        INT 10H
        ADD CX,2
        INC DX
        CMP DX,114
        JLE RIGHT_LEG_LOOP3 
     POP DX
      POP CX
      POP AX
      JMP HANG
TLINE2:
        JMP LINE2
TLINE3:
        JMP LINE3
TLINE4:
        JMP LINE4
TLINE5:
        JMP LINE5
TLINE6:
        JMP LINE6
TLINE7:
        JMP LINE7
TLINE8:
        JMP LINE8
TLINE9:
        JMP LINE9
TLINE10:
        JMP LINE10
PRINT_STRING:
    MOV AX,W
    MOV C,AX
    CMP W,0
    JE LPT
    CMP CNT,8
    JE TLINE2
    CMP CNT,7
    JE TLINE3
    CMP CNT,6
    JE TLINE4
    CMP CNT,5
    JE TLINE5
    CMP CNT,4
    JE TLINE6
    CMP CNT,3
    JE TLINE7
    CMP CNT,2
    JE TLINE8
    CMP CNT,1
    JE TLINE9
    CMP CNT,0
    JE TLINE10
STQ:
    PUSH AX
    PUSH BX
    PUSH DX 
    MOV AH,2       ; move cursor function
    MOV DH,1      ; desired cursor
    MOV DL,0    ; page 0
    INT 10h
    
    ;PRINTING
    
    MOV AH,0EH
    MOV BH,0
    MOV BL,2

PRINTING_OVER:
    
    POP DX
    POP BX
    POP AX
    JMP HANG
SPT:
 JMP STDP
LPT:
    JMP LSP
  
HANG:
    CMP CNT,0
    JE STDP
    MOV AX,W
    MOV C,AX
    CMP W,0
    JE LSP
    LEA SI,STRING 
    LEA DI,ANS
    MOV AH,9
    LEA DX,EMPTY
    INT 21h
    MOV AH,1
    INT 21H   ;1st loop
    MOV AH,9
    LEA DX,ENDL
    INT 21h
    MOV CL,AL
    MOV AH,0
    MOV CH,0
    MOV KEY,CX
    MOV POS,0
    JMP MAN
STDP:
    JMP WRONG
MAN:
    LODSB
    CMP AL,0DH    ;2nd loop
    JE STDS
    CMP AL,CL
    JE EQUAL
    ADD POS,1
    JMP MAN
LSP:
    JMP EQUALS
EQUAL:
    ADD DI,POS
    ADD DI,POS
    CMP [DI],CL
    JNE SLR
    ADD POS,1 
    LEA DI,ANS
    JMP MAN
SLR:
    MOV [DI],CL
    DEC W
    ADD POS,1 
    LEA DI,ANS
    JMP MAN
STDS:
    MOV AX,C       
    CMP W,AX
    JNE  CNN
    DEC CNT
    ADD WR,1
    PUSH DI
    LEA DI,WRON
    ADD DI,7
    ADD DI,WR
    MOV CX,KEY
    MOV [DI],CX
    POP DI
    LEA SI,HELL   
    ADD SI,11
    MOV DL,CNT
    ADD DL,48
    MOV [SI],DL
CNN:
   
    MOV AH,9
    LEA DX,RNG
    INT 21H
    LEA DX,ENDL
    INT 21h
    LEA DX,HELL
    INT 21H
    LEA DX,ANS
    INT 21H
    LEA DX,WRON
    INT 21h
    JMP PRINT_STRING
WRONG:
    MOV AH,2
    MOV DL,0Dh
    INT 21h
    MOV DL,0Ah
    INT 21h
    MOV AH,9
    LEA DX,LOSE
    INT 21h
    JMP EXITS
EQUALS:
    LEA DX,Abhi
    MOV AH,9
    INT 21H
EXITS:
    POP DX
    POP DI
    POP SI
    POP AX
    ret
    HANGMAN ENDP
    END MAIN    
ret