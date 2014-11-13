; Generated by c86 (BYU-NASM) 5.1 (beta) from myinth.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
handleReset:
	; >>>>> Line:	12
	; >>>>> void handleReset() { 
	jmp	L_myinth_1
L_myinth_2:
	; >>>>> Line:	13
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
	ALIGN	2
L_myinth_4:
	DW	0
L_myinth_5:
	DW	0
L_myinth_7:
	DB	"TICK ",0
L_myinth_6:
	DB	"  TickISR: queue overflow! ",0xA,0
	ALIGN	2
handleTick:
	; >>>>> Line:	17
	; >>>>> void handleTick() { 
	jmp	L_myinth_8
L_myinth_9:
	; >>>>> Line:	23
	; >>>>> ++YK 
	inc	word [YKTickNum]
	; >>>>> Line:	26
	; >>>>> MsgArray[next].tick = YKTickNum; 
	mov	ax, word [L_myinth_4]
	shl	ax, 1
	shl	ax, 1
	mov	si, ax
	add	si, MsgArray
	mov	ax, word [YKTickNum]
	mov	word [si], ax
	; >>>>> Line:	27
	; >>>>> data = (data + 89) % 100; 
	mov	ax, word [L_myinth_5]
	add	ax, 89
	cwd
	mov	cx, 100
	idiv	cx
	mov	ax, dx
	mov	word [L_myinth_5], ax
	; >>>>> Line:	28
	; >>>>> MsgArray[next].data = data; 
	mov	ax, word [L_myinth_4]
	shl	ax, 1
	shl	ax, 1
	add	ax, MsgArray
	mov	si, ax
	add	si, 2
	mov	ax, word [L_myinth_5]
	mov	word [si], ax
	; >>>>> Line:	29
	; >>>>> if (YKQPost(MsgQPtr, (void *) &(MsgArray[next])) == 0) 
	mov	ax, word [L_myinth_4]
	shl	ax, 1
	shl	ax, 1
	add	ax, MsgArray
	push	ax
	push	word [MsgQPtr]
	call	YKQPost
	add	sp, 4
	test	ax, ax
	jne	L_myinth_10
	; >>>>> Line:	30
	; >>>>> printString("  TickISR: queue overflow! \n"); 
	mov	ax, L_myinth_6
	push	ax
	call	printString
	add	sp, 2
	jmp	L_myinth_11
L_myinth_10:
	; >>>>> Line:	31
	; >>>>> else if (++next >= 20) 
	mov	ax, word [L_myinth_4]
	inc	ax
	mov	word [L_myinth_4], ax
	cmp	ax, 20
	jl	L_myinth_12
	; >>>>> Line:	32
	; >>>>> next = 0; 
	mov	word [L_myinth_4], 0
L_myinth_12:
L_myinth_11:
	; >>>>> Line:	36
	; >>>>> printString("TICK "); 
	mov	ax, L_myinth_7
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	37
	; >>>>> printInt(YKTickNum); 
	push	word [YKTickNum]
	call	printInt
	add	sp, 2
	; >>>>> Line:	38
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	39
	; >>>>> current = YKBlockList; 
	mov	ax, word [YKBlockList]
	mov	word [bp-2], ax
	; >>>>> Line:	50
	; >>>>> while ( current ) 
	jmp	L_myinth_14
L_myinth_13:
	; >>>>> Line:	52
	; >>>>> if ( current->state == DELAYED ) 
	mov	si, word [bp-2]
	add	si, 30
	cmp	word [si], 1
	jne	L_myinth_16
	; >>>>> Line:	54
	; >>>>> current->delay--; 
	mov	si, word [bp-2]
	add	si, 32
	dec	word [si]
	; >>>>> Line:	55
	; >>>>> if ( !current->delay ) 
	mov	si, word [bp-2]
	add	si, 32
	mov	ax, word [si]
	test	ax, ax
	jne	L_myinth_17
	; >>>>> Line:	57
	; >>>>> current = YKUnblockTask( cu 
	push	word [bp-2]
	call	YKUnblockTask
	add	sp, 2
	mov	word [bp-2], ax
	; >>>>> Line:	58
	; >>>>> continue; 
	jmp	L_myinth_14
L_myinth_17:
L_myinth_16:
	; >>>>> Line:	61
	; >>>>> current = current->next; 
	mov	si, word [bp-2]
	add	si, 40
	mov	ax, word [si]
	mov	word [bp-2], ax
L_myinth_14:
	mov	ax, word [bp-2]
	test	ax, ax
	jne	L_myinth_13
L_myinth_15:
L_myinth_18:
	; >>>>> Line:	65
	; >>>>> return; 
	mov	sp, bp
	pop	bp
	ret
L_myinth_8:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_myinth_9
L_myinth_23:
	DB	") IGNORED",0
L_myinth_22:
	DB	"KEYPRESS (",0
L_myinth_21:
	DB	"DELAY COMPLETE",0
L_myinth_20:
	DB	"DELAY KEY PRESSED",0
	ALIGN	2
handleKeyboard:
	; >>>>> Line:	69
	; >>>>> void handleKeyboard() { 
	jmp	L_myinth_24
L_myinth_25:
	; >>>>> Line:	71
	; >>>>> GlobalFlag = 1; 
	mov	word [bp-2], 0
	; >>>>> Line:	71
	; >>>>> GlobalFlag = 1; 
	mov	word [GlobalFlag], 1
	; >>>>> Line:	73
	; >>>>> if (KeyBuffer == 24178) 
	cmp	word [KeyBuffer], 24178
	jne	L_myinth_26
	; >>>>> Line:	74
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	jmp	L_myinth_27
L_myinth_26:
	; >>>>> Line:	75
	; >>>>> else if (KeyBuffer == 'd') { 
	cmp	word [KeyBuffer], 100
	jne	L_myinth_28
	; >>>>> Line:	76
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	77
	; >>>>> printString("DELAY KEY PRESSED"); 
	mov	ax, L_myinth_20
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	78
	; >>>>> for (i = 0; i < 10000; ++i){} 
	mov	word [bp-2], 0
	jmp	L_myinth_30
L_myinth_29:
L_myinth_32:
	; >>>>> Line:	78
	; >>>>> for (i = 0; i < 10000; ++i){} 
	inc	word [bp-2]
L_myinth_30:
	cmp	word [bp-2], 10000
	jl	L_myinth_29
L_myinth_31:
	; >>>>> Line:	79
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	80
	; >>>>> printString("DELAY COMPLETE"); 
	mov	ax, L_myinth_21
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	81
	; >>>>> printNewLine(); 
	call	printNewLine
	jmp	L_myinth_33
L_myinth_28:
	; >>>>> Line:	83
	; >>>>> else if (KeyBuffer == 24180) { 
	cmp	word [KeyBuffer], 24180
	jne	L_myinth_34
	; >>>>> Line:	84
	; >>>>> handleTick(); 
	call	handleTick
	jmp	L_myinth_35
L_myinth_34:
	; >>>>> Line:	87
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	88
	; >>>>> printString("KEYPRESS ("); 
	mov	ax, L_myinth_22
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	89
	; >>>>> printChar(KeyBuffer); 
	push	word [KeyBuffer]
	call	printChar
	add	sp, 2
	; >>>>> Line:	90
	; >>>>> printString(") IGNORED"); 
	mov	ax, L_myinth_23
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	91
	; >>>>> printNewLine(); 
	call	printNewLine
L_myinth_35:
L_myinth_33:
L_myinth_27:
L_myinth_36:
	; >>>>> Line:	93
	; >>>>> return; 
	mov	sp, bp
	pop	bp
	ret
L_myinth_24:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_myinth_25
