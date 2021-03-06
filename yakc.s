; Generated by c86 (BYU-NASM) 5.1 (beta) from yakc.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
YKIdleTask:
	; >>>>> Line:	22
	; >>>>> void YKIdleTask(void) { 
	jmp	L_yakc_1
L_yakc_2:
	; >>>>> Line:	24
	; >>>>> while(1){ 
	jmp	L_yakc_4
L_yakc_3:
	; >>>>> Line:	25
	; >>>>> ++dummy; 
	inc	word [bp-2]
	; >>>>> Line:	26
	; >>>>> --dummy; 
	dec	word [bp-2]
	; >>>>> Line:	27
	; >>>>> ++dummy; 
	inc	word [bp-2]
	; >>>>> Line:	28
	; >>>>> ++YKIdleCount; 
	inc	word [YKIdleCount]
L_yakc_4:
	jmp	L_yakc_3
L_yakc_5:
	mov	sp, bp
	pop	bp
	ret
L_yakc_1:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_2
	ALIGN	2
YKInitialize:
	; >>>>> Line:	32
	; >>>>> void YKInitialize(void) { 
	jmp	L_yakc_7
L_yakc_8:
	; >>>>> Line:	37
	; >>>>> YKCtxSwCount = 0; 
	mov	word [bp-6], 100
	; >>>>> Line:	37
	; >>>>> YKCtxSwCount = 0; 
	mov	word [YKCtxSwCount], 0
	; >>>>> Line:	38
	; >>>>> YKTickNum = 0; 
	mov	word [YKTickNum], 0
	; >>>>> Line:	39
	; >>>>> YKIdleCount = 0; 
	mov	word [YKIdleCount], 0
	; >>>>> Line:	40
	; >>>>> YKISRDepth = 0; 
	mov	word [YKISRDepth], 0
	; >>>>> Line:	41
	; >>>>> YKRunFlag = 0; 
	mov	word [YKRunFlag], 0
	; >>>>> Line:	42
	; >>>>> YKBlockList = 0; 
	mov	word [YKBlockList], 0
	; >>>>> Line:	43
	; >>>>> YKRdyList = 0; 
	mov	word [YKRdyList], 0
	; >>>>> Line:	44
	; >>>>> YKCurrTask = 0; 
	mov	word [YKCurrTask], 0
	; >>>>> Line:	45
	; >>>>> idle_task_p = YKIdleTask; 
	mov	word [bp-2], YKIdleTask
	; >>>>> Line:	46
	; >>>>> idle_task_stack_p = Y 
	mov	word [bp-4], (YKIdleTaskStack--510)
	; >>>>> Line:	47
	; >>>>> lowest_priority = 100; 
	mov	word [bp-6], 100
	; >>>>> Line:	48
	; >>>>> YKErrorFlag = 0; 
	mov	word [YKErrorFlag], 0
	; >>>>> Line:	51
	; >>>>> YKAvailSEMList = YKSEMArray; 
	mov	word [YKAvailSEMList], YKSEMArray
	; >>>>> Line:	53
	; >>>>> YKQAvailQList = YKQArray; 
	mov	word [YKQAvailQList], YKQArray
	; >>>>> Line:	56
	; >>>>> YKAvailTCBList = YKTCBArray; 
	mov	word [YKAvailTCBList], YKTCBArray
	; >>>>> Line:	57
	; >>>>> YKNewTask(idle_task_p, idle_task_stack_p, lowest_priority); 
	push	word [bp-6]
	push	word [bp-4]
	push	word [bp-2]
	call	YKNewTask
	add	sp, 6
	mov	sp, bp
	pop	bp
	ret
L_yakc_7:
	push	bp
	mov	bp, sp
	sub	sp, 6
	jmp	L_yakc_8
	ALIGN	2
YKNewTask:
	; >>>>> Line:	64
	; >>>>> void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority) { 
	jmp	L_yakc_10
L_yakc_11:
	; >>>>> Line:	66
	; >>>>> YKAvailTCBList++; 
	mov	ax, word [YKAvailTCBList]
	mov	word [bp-2], ax
	; >>>>> Line:	66
	; >>>>> YKAvailTCBList++; 
	add	word [YKAvailTCBList], 42
	; >>>>> Line:	67
	; >>>>> cur_tcb->ax = 0; 
	mov	si, word [bp-2]
	mov	word [si], 0
	; >>>>> Line:	68
	; >>>>> cur_tcb->bx = 0; 
	mov	si, word [bp-2]
	add	si, 2
	mov	word [si], 0
	; >>>>> Line:	69
	; >>>>> cur_tcb->cx = 0; 
	mov	si, word [bp-2]
	add	si, 4
	mov	word [si], 0
	; >>>>> Line:	70
	; >>>>> cur_tcb->dx = 0; 
	mov	si, word [bp-2]
	add	si, 6
	mov	word [si], 0
	; >>>>> Line:	71
	; >>>>> cur_tcb->ip = task; 
	mov	si, word [bp-2]
	add	si, 8
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	72
	; >>>>> cur_tcb->sp = ta 
	mov	si, word [bp-2]
	add	si, 10
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	73
	; >>>>> cur_tcb->bp = taskStack; 
	mov	si, word [bp-2]
	add	si, 12
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	74
	; >>>>> cur_tcb->si = 0; 
	mov	si, word [bp-2]
	add	si, 14
	mov	word [si], 0
	; >>>>> Line:	75
	; >>>>> cur_tcb->di = 0; 
	mov	si, word [bp-2]
	add	si, 16
	mov	word [si], 0
	; >>>>> Line:	76
	; >>>>> cur_tcb->cs = 0; 
	mov	si, word [bp-2]
	add	si, 18
	mov	word [si], 0
	; >>>>> Line:	77
	; >>>>> cur_tcb->ss = 0; 
	mov	si, word [bp-2]
	add	si, 20
	mov	word [si], 0
	; >>>>> Line:	78
	; >>>>> cur_tcb->ds = 0; 
	mov	si, word [bp-2]
	add	si, 22
	mov	word [si], 0
	; >>>>> Line:	79
	; >>>>> cur_tcb->es = 0; 
	mov	si, word [bp-2]
	add	si, 24
	mov	word [si], 0
	; >>>>> Line:	80
	; >>>>> cur_tcb->flags = 512; 
	mov	si, word [bp-2]
	add	si, 26
	mov	word [si], 512
	; >>>>> Line:	81
	; >>>>> cur_tcb->priority = priority; 
	mov	al, byte [bp+8]
	xor	ah, ah
	mov	si, word [bp-2]
	add	si, 28
	mov	word [si], ax
	; >>>>> Line:	82
	; >>>>> cur_tcb->state = READY; 
	mov	si, word [bp-2]
	add	si, 30
	mov	word [si], 0
	; >>>>> Line:	83
	; >>>>> cur_tcb->delay = 0; 
	mov	si, word [bp-2]
	add	si, 32
	mov	word [si], 0
	; >>>>> Line:	84
	; >>>>> cur_tcb->prev = 0; 
	mov	si, word [bp-2]
	add	si, 38
	mov	word [si], 0
	; >>>>> Line:	85
	; >>>>> cur_tcb->next = 0; 
	mov	si, word [bp-2]
	add	si, 40
	mov	word [si], 0
	; >>>>> Line:	86
	; >>>>> YKAddReadyTask(cur_tcb); 
	push	word [bp-2]
	call	YKAddReadyTask
	add	sp, 2
	; >>>>> Line:	88
	; >>>>> if (YKRunFlag) { 
	mov	ax, word [YKRunFlag]
	test	ax, ax
	je	L_yakc_12
	; >>>>> Line:	89
	; >>>>> YKScheduler(); 
	call	YKScheduler
L_yakc_12:
	mov	sp, bp
	pop	bp
	ret
L_yakc_10:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_11
	ALIGN	2
YKRun:
	; >>>>> Line:	93
	; >>>>> void YKRun(void) { 
	jmp	L_yakc_14
L_yakc_15:
	; >>>>> Line:	94
	; >>>>> YKRunFlag = 1; 
	mov	word [YKRunFlag], 1
	; >>>>> Line:	95
	; >>>>> YKScheduler(); 
	call	YKScheduler
	mov	sp, bp
	pop	bp
	ret
L_yakc_14:
	push	bp
	mov	bp, sp
	jmp	L_yakc_15
	ALIGN	2
print_ready_list:
	; >>>>> Line:	99
	; >>>>> { 
	jmp	L_yakc_17
L_yakc_18:
	; >>>>> Line:	102
	; >>>>> while( iter ) 
	mov	word [bp-2], 0
	mov	ax, word [YKRdyList]
	mov	word [bp-4], ax
	; >>>>> Line:	102
	; >>>>> while( iter ) 
	jmp	L_yakc_20
L_yakc_19:
	; >>>>> Line:	104
	; >>>>> printInt( iter->priority ); 
	mov	si, word [bp-4]
	add	si, 28
	push	word [si]
	call	printInt
	add	sp, 2
	; >>>>> Line:	105
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	106
	; >>>>> iter = iter->next; 
	mov	si, word [bp-4]
	add	si, 40
	mov	ax, word [si]
	mov	word [bp-4], ax
	; >>>>> Line:	107
	; >>>>> ++count; 
	inc	word [bp-2]
L_yakc_20:
	mov	ax, word [bp-4]
	test	ax, ax
	jne	L_yakc_19
L_yakc_21:
	; >>>>> Line:	109
	; >>>>> return count; 
	mov	ax, word [bp-2]
L_yakc_22:
	mov	sp, bp
	pop	bp
	ret
L_yakc_17:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakc_18
L_yakc_25:
	DB	" Semaphore: ",0
L_yakc_24:
	DB	" Delay: ",0
	ALIGN	2
print_delay_list:
	; >>>>> Line:	113
	; >>>>> { 
	jmp	L_yakc_26
L_yakc_27:
	; >>>>> Line:	116
	; >>>>> while( iter ) 
	mov	word [bp-2], 0
	mov	ax, word [YKBlockList]
	mov	word [bp-4], ax
	; >>>>> Line:	116
	; >>>>> while( iter ) 
	jmp	L_yakc_29
L_yakc_28:
	; >>>>> Line:	118
	; >>>>> printInt( iter->priority ); 
	mov	si, word [bp-4]
	add	si, 28
	push	word [si]
	call	printInt
	add	sp, 2
	; >>>>> Line:	119
	; >>>>> if (iter->state == DELAYED) { 
	mov	si, word [bp-4]
	add	si, 30
	cmp	word [si], 1
	jne	L_yakc_31
	; >>>>> Line:	120
	; >>>>> printString( " Delay: " ); 
	mov	ax, L_yakc_24
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	121
	; >>>>> printInt( iter->delay ); 
	mov	si, word [bp-4]
	add	si, 32
	push	word [si]
	call	printInt
	add	sp, 2
	jmp	L_yakc_32
L_yakc_31:
	; >>>>> Line:	123
	; >>>>> else if (iter->state == SEMAPHORE) { 
	mov	si, word [bp-4]
	add	si, 30
	cmp	word [si], 2
	jne	L_yakc_33
	; >>>>> Line:	124
	; >>>>> printString( " Semaphore: " ); 
	mov	ax, L_yakc_25
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	125
	; >>>>> printInt( iter->semaphore->value  
	mov	si, word [bp-4]
	add	si, 34
	mov	si, word [si]
	push	word [si]
	call	printInt
	add	sp, 2
L_yakc_33:
L_yakc_32:
	; >>>>> Line:	127
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	128
	; >>>>> iter = iter->next; 
	mov	si, word [bp-4]
	add	si, 40
	mov	ax, word [si]
	mov	word [bp-4], ax
	; >>>>> Line:	129
	; >>>>> ++count; 
	inc	word [bp-2]
L_yakc_29:
	mov	ax, word [bp-4]
	test	ax, ax
	jne	L_yakc_28
L_yakc_30:
	; >>>>> Line:	131
	; >>>>> return count; 
	mov	ax, word [bp-2]
L_yakc_34:
	mov	sp, bp
	pop	bp
	ret
L_yakc_26:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakc_27
	ALIGN	2
YKScheduler:
	; >>>>> Line:	134
	; >>>>> void YKScheduler(void) { 
	jmp	L_yakc_36
L_yakc_37:
	; >>>>> Line:	135
	; >>>>> if (YKCurrTask != YKRdyList) { 
	mov	ax, word [YKRdyList]
	cmp	ax, word [YKCurrTask]
	je	L_yakc_38
	; >>>>> Line:	156
	; >>>>> YKDispatcher(); 
	call	YKDispatcher
L_yakc_38:
	mov	sp, bp
	pop	bp
	ret
L_yakc_36:
	push	bp
	mov	bp, sp
	jmp	L_yakc_37
	ALIGN	2
YKAddReadyTask:
	; >>>>> Line:	161
	; >>>>> void YKAddReadyTask(tcb_t *cur_tcb) { 
	jmp	L_yakc_40
L_yakc_41:
	; >>>>> Line:	164
	; >>>>> if(YKRdyList == 0) { 
	mov	ax, word [YKRdyList]
	test	ax, ax
	jne	L_yakc_42
	; >>>>> Line:	165
	; >>>>> YKRdyList = cur_tcb; 
	mov	ax, word [bp+4]
	mov	word [YKRdyList], ax
	jmp	L_yakc_43
L_yakc_42:
	; >>>>> Line:	168
	; >>>>> iter = YKRdyList; 
	mov	ax, word [YKRdyList]
	mov	word [bp-4], ax
	; >>>>> Line:	169
	; >>>>> moved_to_top = 1; 
	mov	word [bp-2], 1
	; >>>>> Line:	170
	; >>>>> while (cur_tcb->priority > iter->priority) { 
	jmp	L_yakc_45
L_yakc_44:
	; >>>>> Line:	171
	; >>>>> iter = iter->next; 
	mov	si, word [bp-4]
	add	si, 40
	mov	ax, word [si]
	mov	word [bp-4], ax
	; >>>>> Line:	172
	; >>>>> moved_to_top = 
	mov	word [bp-2], 0
L_yakc_45:
	mov	si, word [bp+4]
	add	si, 28
	mov	di, word [bp-4]
	add	di, 28
	mov	ax, word [di]
	cmp	ax, word [si]
	jl	L_yakc_44
L_yakc_46:
	; >>>>> Line:	174
	; >>>>> cur_tcb->next = iter; 
	mov	si, word [bp+4]
	add	si, 40
	mov	ax, word [bp-4]
	mov	word [si], ax
	; >>>>> Line:	175
	; >>>>> if (iter->prev) 
	mov	si, word [bp-4]
	add	si, 38
	mov	ax, word [si]
	test	ax, ax
	je	L_yakc_47
	; >>>>> Line:	176
	; >>>>> iter->prev->next = cur_tcb; 
	mov	si, word [bp-4]
	add	si, 38
	mov	si, word [si]
	add	si, 40
	mov	ax, word [bp+4]
	mov	word [si], ax
L_yakc_47:
	; >>>>> Line:	178
	; >>>>> cur_tcb->prev = iter->prev; 
	mov	si, word [bp-4]
	add	si, 38
	mov	di, word [bp+4]
	add	di, 38
	mov	ax, word [si]
	mov	word [di], ax
	; >>>>> Line:	179
	; >>>>> iter->prev = cur_tcb; 
	mov	si, word [bp-4]
	add	si, 38
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	181
	; >>>>> if (moved_to_top) 
	mov	ax, word [bp-2]
	test	ax, ax
	je	L_yakc_48
	; >>>>> Line:	182
	; >>>>> YKRdyList = cur_tcb; 
	mov	ax, word [bp+4]
	mov	word [YKRdyList], ax
L_yakc_48:
L_yakc_43:
L_yakc_49:
	; >>>>> Line:	184
	; >>>>> return; 
	mov	sp, bp
	pop	bp
	ret
L_yakc_40:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakc_41
	ALIGN	2
YKBlockTask:
	; >>>>> Line:	187
	; >>>>> void YKBlockTask(){ 
	jmp	L_yakc_51
L_yakc_52:
	; >>>>> Line:	189
	; >>>>> YKRdyList = YKCurrTask->next; 
	mov	si, word [YKCurrTask]
	add	si, 40
	mov	ax, word [si]
	mov	word [YKRdyList], ax
	; >>>>> Line:	190
	; >>>>> YKRdyList->prev = 0; 
	mov	si, word [YKRdyList]
	add	si, 38
	mov	word [si], 0
	; >>>>> Line:	193
	; >>>>> if (YKBlockList == 0) { 
	mov	ax, word [YKBlockList]
	test	ax, ax
	jne	L_yakc_53
	; >>>>> Line:	194
	; >>>>> YKBlockList = YKCurrTask; 
	mov	ax, word [YKCurrTask]
	mov	word [YKBlockList], ax
	; >>>>> Line:	195
	; >>>>> YKBlockList->next = 0; 
	mov	si, word [YKBlockList]
	add	si, 40
	mov	word [si], 0
	jmp	L_yakc_54
L_yakc_53:
	; >>>>> Line:	197
	; >>>>> else if ( YKBlockList->priority > YKCurrTask->priority ) 
	mov	si, word [YKBlockList]
	add	si, 28
	mov	di, word [YKCurrTask]
	add	di, 28
	mov	ax, word [di]
	cmp	ax, word [si]
	jge	L_yakc_55
	; >>>>> Line:	199
	; >>>>> YKCurrTask->nex 
	mov	si, word [YKCurrTask]
	add	si, 40
	mov	ax, word [YKBlockList]
	mov	word [si], ax
	; >>>>> Line:	200
	; >>>>> YKBlockList->prev = YKCurrTask; 
	mov	si, word [YKBlockList]
	add	si, 38
	mov	ax, word [YKCurrTask]
	mov	word [si], ax
	; >>>>> Line:	201
	; >>>>> YKCurrTask->prev = 0; 
	mov	si, word [YKCurrTask]
	add	si, 38
	mov	word [si], 0
	; >>>>> Line:	202
	; >>>>> YKBlockList = YKCurrTask; 
	mov	ax, word [YKCurrTask]
	mov	word [YKBlockList], ax
	jmp	L_yakc_56
L_yakc_55:
	; >>>>> Line:	207
	; >>>>> while ( iter->next && YKCurrTask->priority > iter->next->priority ) { 
	mov	ax, word [YKBlockList]
	mov	word [bp-2], ax
	; >>>>> Line:	207
	; >>>>> while ( iter->next && YKCurrTask->priority > iter->next->priority ) { 
	jmp	L_yakc_58
L_yakc_57:
	; >>>>> Line:	208
	; >>>>> iter = iter->next; 
	mov	si, word [bp-2]
	add	si, 40
	mov	ax, word [si]
	mov	word [bp-2], ax
L_yakc_58:
	mov	si, word [bp-2]
	add	si, 40
	mov	ax, word [si]
	test	ax, ax
	je	L_yakc_60
	mov	si, word [bp-2]
	add	si, 40
	mov	si, word [si]
	add	si, 28
	mov	di, word [YKCurrTask]
	add	di, 28
	mov	ax, word [di]
	cmp	ax, word [si]
	jg	L_yakc_57
L_yakc_60:
L_yakc_59:
	; >>>>> Line:	211
	; >>>>> YKCurrTask->next = iter->next; 
	mov	si, word [bp-2]
	add	si, 40
	mov	di, word [YKCurrTask]
	add	di, 40
	mov	ax, word [si]
	mov	word [di], ax
	; >>>>> Line:	212
	; >>>>> if (iter->next) 
	mov	si, word [bp-2]
	add	si, 40
	mov	ax, word [si]
	test	ax, ax
	je	L_yakc_61
	; >>>>> Line:	213
	; >>>>> iter->next->prev = YKCurrTask; 
	mov	si, word [bp-2]
	add	si, 40
	mov	si, word [si]
	add	si, 38
	mov	ax, word [YKCurrTask]
	mov	word [si], ax
L_yakc_61:
	; >>>>> Line:	215
	; >>>>> YKCurrTask->prev = iter; 
	mov	si, word [YKCurrTask]
	add	si, 38
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	216
	; >>>>> iter->next = YKCurrTask; 
	mov	si, word [bp-2]
	add	si, 40
	mov	ax, word [YKCurrTask]
	mov	word [si], ax
L_yakc_56:
L_yakc_54:
	mov	sp, bp
	pop	bp
	ret
L_yakc_51:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_52
	ALIGN	2
YKUnblockTask:
	; >>>>> Line:	221
	; >>>>> { 
	jmp	L_yakc_63
L_yakc_64:
	; >>>>> Line:	224
	; >>>>> temp = 
	mov	si, word [bp+4]
	add	si, 38
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	225
	; >>>>> if ( temp ) temp->next = task->next; 
	mov	ax, word [bp-2]
	test	ax, ax
	je	L_yakc_65
	; >>>>> Line:	225
	; >>>>> if ( temp ) temp->next = task->next; 
	mov	si, word [bp+4]
	add	si, 40
	mov	di, word [bp-2]
	add	di, 40
	mov	ax, word [si]
	mov	word [di], ax
	jmp	L_yakc_66
L_yakc_65:
	; >>>>> Line:	226
	; >>>>> else YKBlockList = task->next; 
	mov	si, word [bp+4]
	add	si, 40
	mov	ax, word [si]
	mov	word [YKBlockList], ax
L_yakc_66:
	; >>>>> Line:	228
	; >>>>> temp = task->next; 
	mov	si, word [bp+4]
	add	si, 40
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	229
	; >>>>> if ( temp ) temp->prev = task->prev; 
	mov	ax, word [bp-2]
	test	ax, ax
	je	L_yakc_67
	; >>>>> Line:	229
	; >>>>> if ( temp ) temp->prev = task->prev; 
	mov	si, word [bp+4]
	add	si, 38
	mov	di, word [bp-2]
	add	di, 38
	mov	ax, word [si]
	mov	word [di], ax
L_yakc_67:
	; >>>>> Line:	231
	; >>>>> task->prev = 0; 
	mov	si, word [bp+4]
	add	si, 38
	mov	word [si], 0
	; >>>>> Line:	232
	; >>>>> task->next = 0; 
	mov	si, word [bp+4]
	add	si, 40
	mov	word [si], 0
	; >>>>> Line:	233
	; >>>>> task->state = READY; 
	mov	si, word [bp+4]
	add	si, 30
	mov	word [si], 0
	; >>>>> Line:	234
	; >>>>> YKAddReadyTask( task ); 
	push	word [bp+4]
	call	YKAddReadyTask
	add	sp, 2
	; >>>>> Line:	235
	; >>>>> return temp; 
	mov	ax, word [bp-2]
L_yakc_68:
	mov	sp, bp
	pop	bp
	ret
L_yakc_63:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_64
	ALIGN	2
YKBlockSEM2Ready:
	; >>>>> Line:	238
	; >>>>> void YKBlockSEM2Ready(YKSEM* semaphore){ 
	jmp	L_yakc_70
L_yakc_71:
	; >>>>> Line:	240
	; >>>>> current = YKBlockList; 
	mov	ax, word [YKBlockList]
	mov	word [bp-2], ax
	; >>>>> Line:	242
	; >>>>> while ( current ) 
	jmp	L_yakc_73
L_yakc_72:
	; >>>>> Line:	244
	; >>>>> if ( current->semaphore == semaphore ) 
	mov	si, word [bp-2]
	add	si, 34
	mov	ax, word [bp+4]
	cmp	ax, word [si]
	jne	L_yakc_75
	; >>>>> Line:	246
	; >>>>> current->semaphore = 0; 
	mov	si, word [bp-2]
	add	si, 34
	mov	word [si], 0
	; >>>>> Line:	247
	; >>>>> current = YKUnblockTask( current ); 
	push	word [bp-2]
	call	YKUnblockTask
	add	sp, 2
	mov	word [bp-2], ax
	; >>>>> Line:	248
	; >>>>> continue; 
	jmp	L_yakc_73
L_yakc_75:
	; >>>>> Line:	250
	; >>>>> current = current- 
	mov	si, word [bp-2]
	add	si, 40
	mov	ax, word [si]
	mov	word [bp-2], ax
L_yakc_73:
	mov	ax, word [bp-2]
	test	ax, ax
	jne	L_yakc_72
L_yakc_74:
L_yakc_76:
	; >>>>> Line:	253
	; >>>>> return; 
	mov	sp, bp
	pop	bp
	ret
L_yakc_70:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_71
	ALIGN	2
YKBlockQ2Ready:
	; >>>>> Line:	256
	; >>>>> void YKBlockQ2Ready(YKQ* queue){ 
	jmp	L_yakc_78
L_yakc_79:
	; >>>>> Line:	258
	; >>>>> current = YKBlockList; 
	mov	ax, word [YKBlockList]
	mov	word [bp-2], ax
	; >>>>> Line:	260
	; >>>>> while ( current ) 
	jmp	L_yakc_81
L_yakc_80:
	; >>>>> Line:	262
	; >>>>> if ( current->queue == queue ) 
	mov	si, word [bp-2]
	add	si, 36
	mov	ax, word [bp+4]
	cmp	ax, word [si]
	jne	L_yakc_83
	; >>>>> Line:	264
	; >>>>> current->queue = 0; 
	mov	si, word [bp-2]
	add	si, 36
	mov	word [si], 0
	; >>>>> Line:	265
	; >>>>> current = YKUnblockTask( current ); 
	push	word [bp-2]
	call	YKUnblockTask
	add	sp, 2
	mov	word [bp-2], ax
	; >>>>> Line:	266
	; >>>>> continue; 
	jmp	L_yakc_81
L_yakc_83:
	; >>>>> Line:	268
	; >>>>> current = current->next; 
	mov	si, word [bp-2]
	add	si, 40
	mov	ax, word [si]
	mov	word [bp-2], ax
L_yakc_81:
	mov	ax, word [bp-2]
	test	ax, ax
	jne	L_yakc_80
L_yakc_82:
L_yakc_84:
	; >>>>> Line:	270
	; >>>>> return; 
	mov	sp, bp
	pop	bp
	ret
L_yakc_78:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_79
	ALIGN	2
YKDelayTask:
	; >>>>> Line:	273
	; >>>>> void YKDelayTask(unsigned count) { 
	jmp	L_yakc_86
L_yakc_87:
	; >>>>> Line:	275
	; >>>>> YKCurrTask->delay = count; 
	mov	si, word [YKCurrTask]
	add	si, 32
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	276
	; >>>>> YKCurrTask->state = DELAYED; 
	mov	si, word [YKCurrTask]
	add	si, 30
	mov	word [si], 1
	; >>>>> Line:	279
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	280
	; >>>>> YKBlockTask(); 
	call	YKBlockTask
	; >>>>> Line:	281
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	284
	; >>>>> YKScheduler(); 
	call	YKScheduler
	mov	sp, bp
	pop	bp
	ret
L_yakc_86:
	push	bp
	mov	bp, sp
	jmp	L_yakc_87
	ALIGN	2
YKEnterISR:
	; >>>>> Line:	287
	; >>>>> void YKEnterISR(void) { 
	jmp	L_yakc_89
L_yakc_90:
	; >>>>> Line:	288
	; >>>>> ++YKISRDep 
	inc	word [YKISRDepth]
	mov	sp, bp
	pop	bp
	ret
L_yakc_89:
	push	bp
	mov	bp, sp
	jmp	L_yakc_90
	ALIGN	2
YKExitISR:
	; >>>>> Line:	290
	; >>>>> void YKExitISR(void) { 
	jmp	L_yakc_92
L_yakc_93:
	; >>>>> Line:	291
	; >>>>> --YKISRDepth; 
	dec	word [YKISRDepth]
	; >>>>> Line:	296
	; >>>>> if (YKISRDepth == 0) { 
	mov	ax, word [YKISRDepth]
	test	ax, ax
	jne	L_yakc_94
	; >>>>> Line:	297
	; >>>>> YKScheduler(); 
	call	YKScheduler
L_yakc_94:
	mov	sp, bp
	pop	bp
	ret
L_yakc_92:
	push	bp
	mov	bp, sp
	jmp	L_yakc_93
	ALIGN	2
YKSemCreate:
	; >>>>> Line:	301
	; >>>>> YKSEM* YKSemCreate(int initialValue) { 
	jmp	L_yakc_96
L_yakc_97:
	; >>>>> Line:	303
	; >>>>> YKAvailSEMList->value = initialValue; 
	mov	si, word [YKAvailSEMList]
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	304
	; >>>>> return_val = YKAvailSEMList; 
	mov	ax, word [YKAvailSEMList]
	mov	word [bp-2], ax
	; >>>>> Line:	305
	; >>>>> ++YKAvailSEMList; 
	add	word [YKAvailSEMList], 2
	; >>>>> Line:	306
	; >>>>> return return_val; 
	mov	ax, word [bp-2]
L_yakc_98:
	mov	sp, bp
	pop	bp
	ret
L_yakc_96:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_97
	ALIGN	2
YKSemPend:
	; >>>>> Line:	309
	; >>>>> void YKSemPend(YKSEM *semaphore) { 
	jmp	L_yakc_100
L_yakc_101:
	; >>>>> Line:	311
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	314
	; >>>>> available = semaphore->value > 0 ? 1 : 0; 
	mov	si, word [bp+4]
	cmp	word [si], 0
	jle	L_yakc_102
	mov	ax, 1
	jmp	L_yakc_103
L_yakc_102:
	xor	ax, ax
L_yakc_103:
	mov	word [bp-2], ax
	; >>>>> Line:	315
	; >>>>> --(semaphore->value); 
	mov	si, word [bp+4]
	dec	word [si]
	; >>>>> Line:	318
	; >>>>> if (!available) { 
	mov	ax, word [bp-2]
	test	ax, ax
	jne	L_yakc_104
	; >>>>> Line:	319
	; >>>>> YKCurrTask->state = SEMAPHORE; 
	mov	si, word [YKCurrTask]
	add	si, 30
	mov	word [si], 2
	; >>>>> Line:	320
	; >>>>>  
	mov	si, word [YKCurrTask]
	add	si, 34
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	321
	; >>>>> YKBlockTask(YKCurrTask); 
	push	word [YKCurrTask]
	call	YKBlockTask
	add	sp, 2
L_yakc_104:
	; >>>>> Line:	324
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	328
	; >>>>> YKScheduler(); 
	call	YKScheduler
	mov	sp, bp
	pop	bp
	ret
L_yakc_100:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_101
	ALIGN	2
YKSemPost:
	; >>>>> Line:	331
	; >>>>> void YKSemPost(YKSEM *semaphore) { 
	jmp	L_yakc_106
L_yakc_107:
	; >>>>> Line:	332
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	333
	; >>>>> ++(semaphore->value); 
	mov	si, word [bp+4]
	inc	word [si]
	; >>>>> Line:	334
	; >>>>> if (semaphore->value > 1) 
	mov	si, word [bp+4]
	cmp	word [si], 1
	jle	L_yakc_108
	; >>>>> Line:	335
	; >>>>> semaphore->value = 1; 
	mov	word [si], 1
L_yakc_108:
	; >>>>> Line:	337
	; >>>>> if (semaphore->value < 1) { 
	mov	si, word [bp+4]
	cmp	word [si], 1
	jge	L_yakc_109
	; >>>>> Line:	338
	; >>>>> YKBlockSEM2Ready(semaphore); 
	push	word [bp+4]
	call	YKBlockSEM2Ready
	add	sp, 2
L_yakc_109:
	; >>>>> Line:	342
	; >>>>> if (YKISRDepth == 0) 
	mov	ax, word [YKISRDepth]
	test	ax, ax
	jne	L_yakc_110
	; >>>>> Line:	343
	; >>>>> YKScheduler(); 
	call	YKScheduler
L_yakc_110:
	; >>>>> Line:	344
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	mov	sp, bp
	pop	bp
	ret
L_yakc_106:
	push	bp
	mov	bp, sp
	jmp	L_yakc_107
	ALIGN	2
YKQCreate:
	; >>>>> Line:	347
	; >>>>> YKQ *YKQCreate(void **start, unsigned size) { 
	jmp	L_yakc_112
L_yakc_113:
	; >>>>> Line:	350
	; >>>>> return_val = YKQAvailQList 
	mov	ax, word [YKQAvailQList]
	mov	word [bp-2], ax
	; >>>>> Line:	353
	; >>>>> YKQAvailQList->base_addr = start; 
	mov	si, word [YKQAvailQList]
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	354
	; >>>>> YKQAvailQList->max_length = size; 
	mov	si, word [YKQAvailQList]
	add	si, 2
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	355
	; >>>>> YKQAvailQList->head = 0; 
	mov	si, word [YKQAvailQList]
	add	si, 4
	mov	word [si], 0
	; >>>>> Line:	356
	; >>>>> YKQAvailQList->tail = 0; 
	mov	si, word [YKQAvailQList]
	add	si, 6
	mov	word [si], 0
	; >>>>> Line:	357
	; >>>>> YKQAvailQList->size = 0; 
	mov	si, word [YKQAvailQList]
	add	si, 8
	mov	word [si], 0
	; >>>>> Line:	358
	; >>>>> ++YKQAvailQList; 
	add	word [YKQAvailQList], 10
	; >>>>> Line:	359
	; >>>>> return return_val; 
	mov	ax, word [bp-2]
L_yakc_114:
	mov	sp, bp
	pop	bp
	ret
L_yakc_112:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_113
	ALIGN	2
YKQPend:
	; >>>>> Line:	362
	; >>>>> void *YKQPend(YKQ *queue) { 
	jmp	L_yakc_116
L_yakc_117:
	; >>>>> Line:	364
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	366
	; >>>>> if (queue->size == 0) { 
	mov	si, word [bp+4]
	add	si, 8
	mov	ax, word [si]
	test	ax, ax
	jne	L_yakc_118
	; >>>>> Line:	367
	; >>>>> YKCurrTask->state = QUEUE; 
	mov	si, word [YKCurrTask]
	add	si, 30
	mov	word [si], 3
	; >>>>> Line:	368
	; >>>>> YKCurrTask->queue = queue; 
	mov	si, word [YKCurrTask]
	add	si, 36
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	369
	; >>>>> YKBlockTask(YKCurrTask); 
	push	word [YKCurrTask]
	call	YKBlockTask
	add	sp, 2
	; >>>>> Line:	370
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	371
	; >>>>> YKScheduler(); 
	call	YKScheduler
L_yakc_118:
	; >>>>> Line:	374
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	375
	; >>>>> --(queue->size); 
	mov	si, word [bp+4]
	add	si, 8
	dec	word [si]
	; >>>>> Line:	376
	; >>>>>  
	mov	si, word [bp+4]
	add	si, 4
	mov	ax, word [si]
	shl	ax, 1
	mov	si, ax
	mov	di, word [bp+4]
	add	si, word [di]
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	377
	; >>>>> if ( queue->head == (queue->max_length - 1) ) 
	mov	si, word [bp+4]
	add	si, 2
	mov	ax, word [si]
	dec	ax
	mov	si, word [bp+4]
	add	si, 4
	mov	dx, word [si]
	cmp	dx, ax
	jne	L_yakc_119
	; >>>>> Line:	378
	; >>>>> queue->head = 0; 
	mov	si, word [bp+4]
	add	si, 4
	mov	word [si], 0
	jmp	L_yakc_120
L_yakc_119:
	; >>>>> Line:	380
	; >>>>> ++(queue->head); 
	mov	si, word [bp+4]
	add	si, 4
	inc	word [si]
L_yakc_120:
	; >>>>> Line:	381
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	382
	; >>>>> return return_data; 
	mov	ax, word [bp-2]
L_yakc_121:
	mov	sp, bp
	pop	bp
	ret
L_yakc_116:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_117
	ALIGN	2
YKQPost:
	; >>>>> Line:	385
	; >>>>> int YKQPost(YKQ *queue, void *msg) { 
	jmp	L_yakc_123
L_yakc_124:
	; >>>>> Line:	388
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	389
	; >>>>> if (queue->size != queue->max_length ) { 
	mov	si, word [bp+4]
	add	si, 8
	mov	di, word [bp+4]
	add	di, 2
	mov	ax, word [di]
	cmp	ax, word [si]
	je	L_yakc_125
	; >>>>> Line:	390
	; >>>>> ++(queue->size); 
	mov	si, word [bp+4]
	add	si, 8
	inc	word [si]
	; >>>>> Line:	391
	; >>>>> queue->base_addr[queue->tail] = msg; 
	mov	si, word [bp+4]
	add	si, 6
	mov	ax, word [si]
	shl	ax, 1
	mov	si, ax
	mov	di, word [bp+4]
	add	si, word [di]
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	393
	; >>>>> if ( queue->tail == (queue->max_length - 1) ) 
	mov	si, word [bp+4]
	add	si, 2
	mov	ax, word [si]
	dec	ax
	mov	si, word [bp+4]
	add	si, 6
	mov	dx, word [si]
	cmp	dx, ax
	jne	L_yakc_126
	; >>>>> Line:	394
	; >>>>> queue->tail = 0; 
	mov	si, word [bp+4]
	add	si, 6
	mov	word [si], 0
	jmp	L_yakc_127
L_yakc_126:
	; >>>>> Line:	396
	; >>>>> ++(qu 
	mov	si, word [bp+4]
	add	si, 6
	inc	word [si]
L_yakc_127:
	; >>>>> Line:	398
	; >>>>> if (queue->size == 1) { 
	mov	si, word [bp+4]
	add	si, 8
	cmp	word [si], 1
	jne	L_yakc_128
	; >>>>> Line:	399
	; >>>>> YKBlockQ2Ready(queue); 
	push	word [bp+4]
	call	YKBlockQ2Ready
	add	sp, 2
	; >>>>> Line:	400
	; >>>>> if (YKISRDepth == 0) { 
	mov	ax, word [YKISRDepth]
	test	ax, ax
	jne	L_yakc_129
	; >>>>> Line:	401
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	402
	; >>>>> YKScheduler(); 
	call	YKScheduler
L_yakc_129:
L_yakc_128:
	; >>>>> Line:	405
	; >>>>> return_value = 1; 
	mov	word [bp-2], 1
	jmp	L_yakc_130
L_yakc_125:
	; >>>>> Line:	408
	; >>>>> return_value = 0; 
	mov	word [bp-2], 0
L_yakc_130:
	; >>>>> Line:	410
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	411
	; >>>>> return return_value; 
	mov	ax, word [bp-2]
L_yakc_131:
	mov	sp, bp
	pop	bp
	ret
L_yakc_123:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_124
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
	TIMES	252 db 0
YKCurrTask:
	TIMES	2 db 0
YKIdleTaskStack:
	TIMES	512 db 0
YKSEMArray:
	TIMES	8 db 0
YKAvailSEMList:
	TIMES	2 db 0
YKQArray:
	TIMES	10 db 0
YKQAvailQList:
	TIMES	2 db 0
YKErrorFlag:
	TIMES	2 db 0
