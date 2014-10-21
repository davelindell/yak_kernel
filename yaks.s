YKDispatcher:
; increment context switch count
    inc word [YKCtxSwCount]
; save context of YKCurrTask
    cli
    push bp
    mov bp, word [YKCurrTask]        ; get tcb block address
    test bp,bp
    je YKDispatcher_1
    mov word [bp],ax                ; save ax
    mov word [bp+2],bx              ; save bx
    mov word [bp+4],cx
    mov word [bp+6],dx
    mov word [bp+14],si             ; save si
    mov si, bp                      ; put tcb block address in si 
    pop bp                          ; restore bp
    mov ax,[bp+2]                   ; get return address
    mov word [si+8],ax              ; save ip
    mov ax,bp                       ; get bp
    add ax,4                        ; get where sp should be
    mov word [si+10],ax             ; save sp
    mov ax,[bp]                     ; get the old bp
    mov word [si+12],ax             ; save bp
    mov word [si+16],di
    mov word [si+18],cs
    mov word [si+20],ss
    mov word [si+22],ds
    mov word [si+24],es
    mov ax,si
    add ax, 28
    mov sp,ax                       ; set sp to get ready to push flags
    pushf                           ; push flags (sp-2 <= flags)
    jmp YKDispatcher_2
YKDispatcher_1:
    pop bp
YKDispatcher_2:
    mov ax, word [YKRdyList]        ; save readylist address
    mov word [YKCurrTask],ax        ; YKCurrTask = YKRdyList
; Restore context of YKRdyList
    ;mov ax, word [YKRdyList]       ; restore ax last
    mov bp, word [YKRdyList]
    mov ax, word [bp]
    mov bx, word [bp+2]
    mov cx, word [bp+4]
    mov dx, word [bp+6]
    ; YKRdyList+8 is ip
    mov sp, word [bp+10]
    mov si, word [bp+14]
    mov di, word [bp+16]
    ;mov cs, word [ax+18] ; this is naughty
    mov ss, word [bp+20]
    mov ds, word [bp+22]
    mov es, word [bp+24]
    push word [bp+26]     ; push flags
    push word [bp+18]     ; push cs
    push word [bp+8]      ; push ip
    mov bp, word [bp+12]
    iret


YKEnterMutex:
    cli
    ret

YKExitMutex:
    sti
    ret
   


