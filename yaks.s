YKDispatcher:
; save context of YKCurrTask
    mov word [YKCurrTask],ax
    mov word [YKCurrTask+2],bx
    mov word [YKCurrTask+4],cx
    mov word [YKCurrTask+6],dx
    mov ax,[bp+2]           ; get return address
    mov word [YKCurrTask+8],ax   ; save ip
    mov ax,bp               ; get bp
    add ax,4                ; get where sp should be
    mov word [YKCurrTask+10],ax  ; save sp
    mov word [YKCurrTask+12],bp  ; save bp
    mov word [YKCurrTask+14],si  ;save si
    mov word [YKCurrTask+16],di
    mov word [YKCurrTask+18],cs
    mov word [YKCurrTask+20],ss
    mov word [YKCurrTask+22],ds
    mov word [YKCurrTask+24],es
    mov ax, YKCurrTask
    add ax, 28
    mov sp,ax               ; set sp to get ready to push flags
    pushf                   ; push flags (sp-2 <= flags)
    
    mov ax, word [YKRdyList]      ; save readylist address
    mov word [YKCurrTask],ax     ; YKCurrTask = YKRdyList
; Restore context of YKRdyList
    mov ax, word [YKRdyList]
    mov bx, word [YKRdyList+2]
    mov cx, word [YKRdyList+4]
    mov dx, word [YKRdyList+6]
    ; YKRdyList+8 is ip
    mov sp, word [YKRdyList+10] 
    mov bp, word [YKRdyList+12]
    mov si, word [YKRdyList+14]
    mov di, word [YKRdyList+16]
    mov cs, word [YKRdyList+18]
    mov ss, word [YKRdyList+20]
    mov ds, word [YKRdyList+22]
    mov es, word [YKRdyList+24]
    push word [YKRdyList+26]     ; push flags
    push word [YKRdyList+18]     ; push cs
    push word [YKRdyList+8]      ; push ip
    iret
