; Generated by c86 (BYU-NASM) 5.1 (beta) from yakc.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
YKIdleTask:
	jmp	L_yakc_1
L_yakc_2:
L_yakc_3:
L_yakc_4:
	jmp	L_yakc_3
L_yakc_5:
	mov	sp, bp
	pop	bp
	ret
L_yakc_1:
	push	bp
	mov	bp, sp
	jmp	L_yakc_2
	ALIGN	2
YKNewTask:
	jmp	L_yakc_7
L_yakc_8:
	mov	sp, bp
	pop	bp
	ret
L_yakc_7:
	push	bp
	mov	bp, sp
	jmp	L_yakc_8
	ALIGN	2
YKCtxSwCount:
	TIMES	2 db 0
YKIdleCount:
	TIMES	2 db 0
YKTickNum:
	TIMES	2 db 0
YKISRDepth:
	TIMES	2 db 0
YKRunFlag:
	TIMES	2 db 0
YKRdyList:
	TIMES	2 db 0
YKBlockList:
	TIMES	2 db 0
YKAvailTCBList:
	TIMES	2 db 0
YKTCBArray:
	TIMES	136 db 0
YKIdleTaskStack:
	TIMES	512 db 0
