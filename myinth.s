; Generated by c86 (BYU-NASM) 5.1 (beta) from myinth.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
handleReset:
	; >>>>> Line:	5
	; >>>>> void handleReset() { 
	jmp	L_myinth_1
L_myinth_2:
	; >>>>> Line:	6
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_myinth_1:
	push	bp
	mov	bp, sp
	jmp	L_myinth_2
L_myinth_4:
	DB	"TICK ",0
	ALIGN	2
handleTick:
	; >>>>> Line:	10
	; >>>>> void handleTick() { 
	jmp	L_myinth_5
L_myinth_6:
	; >>>>> Line:	11
	; >>>>> ++YKTickNum; 
	inc	word [YKTickNum]
	; >>>>> Line:	12
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	13
	; >>>>> printString("TICK "); 
	mov	ax, L_myinth_4
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	14
	; >>>>> printInt(YKTickNum); 
	push	word [YKTickNum]
	call	printInt
	add	sp, 2
	; >>>>> Line:	15
	; >>>>> printNewLine(); 
	call	printNewLine
L_myinth_7:
	; >>>>> Line:	16
	; >>>>> return; 
	mov	sp, bp
	pop	bp
	ret
L_myinth_5:
	push	bp
	mov	bp, sp
	jmp	L_myinth_6
L_myinth_12:
	DB	") IGNORED",0
L_myinth_11:
	DB	"KEYPRESS (",0
L_myinth_10:
	DB	"DELAY COMPLETE",0
L_myinth_9:
	DB	"DELAY KEY PRESSED",0
	ALIGN	2
handleKeyboard:
	; >>>>> Line:	20
	; >>>>> void handleKeyboard() { 
	jmp	L_myinth_13
L_myinth_14:
	; >>>>> Line:	22
	; >>>>> if (KeyBuffer == 24178) 
	mov	word [bp-2], 0
	; >>>>> Line:	22
	; >>>>> if (KeyBuffer == 24178) 
	cmp	word [KeyBuffer], 24178
	jne	L_myinth_15
	; >>>>> Line:	23
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	jmp	L_myinth_16
L_myinth_15:
	; >>>>> Line:	24
	; >>>>> else if (KeyBuffer == 'd') { 
	cmp	word [KeyBuffer], 100
	jne	L_myinth_17
	; >>>>> Line:	25
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	26
	; >>>>> printString("DELAY KEY PRESSED"); 
	mov	ax, L_myinth_9
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	27
	; >>>>> for (i = 0; i < 10000; ++ 
	mov	word [bp-2], 0
	jmp	L_myinth_19
L_myinth_18:
L_myinth_21:
	; >>>>> Line:	27
	; >>>>> for (i = 0; i < 10000; ++ 
	inc	word [bp-2]
L_myinth_19:
	cmp	word [bp-2], 10000
	jl	L_myinth_18
L_myinth_20:
	; >>>>> Line:	28
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	29
	; >>>>> printString("DELAY COMPLETE"); 
	mov	ax, L_myinth_10
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	30
	; >>>>> printNewLine(); 
	call	printNewLine
	jmp	L_myinth_22
L_myinth_17:
	; >>>>> Line:	32
	; >>>>> else if (KeyBuffer == 24180) { 
	cmp	word [KeyBuffer], 24180
	jne	L_myinth_23
	; >>>>> Line:	33
	; >>>>> handleTick(); 
	call	handleTick
	jmp	L_myinth_24
L_myinth_23:
	; >>>>> Line:	36
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	37
	; >>>>> printString("KEYPRESS ("); 
	mov	ax, L_myinth_11
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	38
	; >>>>> printChar(KeyBuffer); 
	push	word [KeyBuffer]
	call	printChar
	add	sp, 2
	; >>>>> Line:	39
	; >>>>> printString(") IGNORED"); 
	mov	ax, L_myinth_12
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	40
	; >>>>> printNewLine(); 
	call	printNewLine
L_myinth_24:
L_myinth_22:
L_myinth_16:
L_myinth_25:
	; >>>>> Line:	42
	; >>>>> return; 
	mov	sp, bp
	pop	bp
	ret
L_myinth_13:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_myinth_14
